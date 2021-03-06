/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package JDBC;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.sql.DataSource;

public class DAO {

    protected final DataSource myDataSource;

    /**
     *
     * @param dataSource la source de données à utiliser
     */
    public DAO(DataSource dataSource) {
        this.myDataSource = dataSource;
    }

    /**
     *récuperation des id des produits pour les afficher dans ajouterCommande et modifierCommande
     * @return List des id des produits
     */
    public List<Integer> idProducts() {
        List<Integer> result = new ArrayList<>();
        String sql = "SELECT DISTINCT PRODUCT_ID FROM PRODUCT";
        try (Connection connection = myDataSource.getConnection();
                Statement stmt = connection.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                // On récupère les champs nécessaires de l'enregistrement courant
                Integer id = rs.getInt("PRODUCT_ID");
                // On l'ajoute à la liste des résultats
                result.add(id);
            }
        } catch (SQLException ex) {
            Logger.getLogger(DAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return result;
    }

    /**
     * Trouver un Customer à partir de sa clé
     *
     * @param customerID la clé du CUSTOMER à rechercher
     * @return l'enregistrement correspondant dans la table CUSTOMER, ou null si
     * pas trouvé
     * @throws DAOException
     */
    public CustomerEntity findCustomer(int customerID) throws DAOException {
        CustomerEntity result = null;

        String sql = "SELECT * FROM CUSTOMER WHERE CUSTOMER_ID = ?";
        try (Connection connection = myDataSource.getConnection(); // On crée un statement pour exécuter une requête
                PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setInt(1, customerID);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) { // On a trouvé
                    String name = rs.getString("NAME");
                    String address = rs.getString("ADDRESSLINE1");
                    String email = rs.getString("EMAIL");
                    // On crée l'objet "entity"
                    result = new CustomerEntity(customerID, name, address, email);
                } // else on n'a pas trouvé, on renverra null
            }
        } catch (SQLException ex) {
            Logger.getLogger("DAO").log(Level.SEVERE, null, ex);
            throw new DAOException(ex.getMessage());
        }

        return result;
    }

//Permet de trouver les commandes à partir de l'id du client
    public List<PurchaseOrder> findPurchaseOrder(int customerID) throws DAOException, SQLException {
        //PurchaseOrder result = null;
        List<PurchaseOrder> result = new LinkedList<>();

        String sql;
        sql = "SELECT * FROM PURCHASE_ORDER WHERE CUSTOMER_ID = ?";
        try (Connection connection = myDataSource.getConnection(); // On crée un statement pour exécuter une requête
                PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setInt(1, customerID);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) { // On a trouvé
                    int orderNum = rs.getInt("ORDER_NUM");
                    int customerId = rs.getInt("CUSTOMER_ID");
                    int productID = rs.getInt("PRODUCT_ID");
                    int quantity = rs.getInt("QUANTITY");
                    float shippingCost = rs.getFloat("SHIPPING_COST");
                    Date salesDate = rs.getDate("SALES_DATE");
                    Date shippingDate = rs.getDate("SHIPPING_DATE");
                    String freightCompany = rs.getString("FREIGHT_COMPANY");
                    // On crée l'objet "entity"
                    PurchaseOrder PO = new PurchaseOrder(orderNum, customerId, productID, quantity, shippingCost, salesDate, shippingDate, freightCompany);

                    result.add(PO);

                } // else on n'a pas trouvé, on renverra null
            }
        } catch (SQLException ex) {
            Logger.getLogger("DAO").log(Level.SEVERE, null, ex);
            throw new DAOException(ex.getMessage());
        }
        return result;
    }

    //On récupère toute les commandes 
    public List<PurchaseOrder> allCodes() throws SQLException {

        List<PurchaseOrder> result = new LinkedList<>();

        String sql = "SELECT * FROM PURCHASE_ORDER ORDER BY CUSTOMER_ID";
        try (Connection connection = myDataSource.getConnection();
                PreparedStatement stmt = connection.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                int orderNum = rs.getInt("ORDER_NUM");
                int customerId = rs.getInt("CUSTOMER_ID");
                int productID = rs.getInt("PRODUCT_ID");
                int quantity = rs.getInt("QUANTITY");
                float shippingCost = rs.getFloat("SHIPPING_COST");
                Date salesDate = rs.getDate("SALES_DATE");
                Date shippingDate = rs.getDate("SHIPPING_DATE");
                String freightCompany = rs.getString("FREIGHT_COMPANY");
                // On crée l'objet "purchaseOrder"
                PurchaseOrder PO = new PurchaseOrder(orderNum, customerId, productID, quantity, shippingCost, salesDate, shippingDate, freightCompany);
                result.add(PO);
            }
        }
        return result;
    }

    //Fonction pour afficher le premier graphique
    public List<Categorie> CategorieCA() throws SQLException {

        List<Categorie> result = new LinkedList<>();
        //la requête sql j'ai demandé le CA groupé par categorie 
        String sql = "SELECT PRODUCT_CODE.DESCRIPTION AS SA, SUM(PURCHASE_ORDER.QUANTITY*PRODUCT.PURCHASE_COST) AS CA FROM PRODUCT INNER JOIN PURCHASE_ORDER USING(PRODUCT_ID)INNER JOIN PRODUCT_CODE ON PRODUCT.PRODUCT_CODE=PRODUCT_CODE.PROD_CODE GROUP BY PRODUCT_CODE.DESCRIPTION";

        try (Connection connection = myDataSource.getConnection();
                PreparedStatement stmt = connection.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                String sommequantite = rs.getString("SA");
                float produit = rs.getFloat("CA");
                Categorie c = new Categorie(sommequantite, produit);
                result.add(c);
            }
        }
        return result;
    }

    //Fonction pour le deuxième Graphique 
    public List<ZoneGeo> ZoneGeographique() throws SQLException {

        List<ZoneGeo> result = new LinkedList<>();
        //requete sql : j'ai demandé le CA groupé par ville 
        String sql = "SELECT CUSTOMER.CITY AS H, SUM(PURCHASE_ORDER.QUANTITY*PRODUCT.PURCHASE_COST) AS J FROM PRODUCT INNER JOIN PURCHASE_ORDER USING(PRODUCT_ID) INNER JOIN CUSTOMER USING(CUSTOMER_ID) GROUP BY CUSTOMER.CITY";

        try (Connection connection = myDataSource.getConnection();
                PreparedStatement stmt = connection.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                String customer = rs.getString("H");
                float achat = rs.getFloat("J");
                ZoneGeo c1 = new ZoneGeo(customer, achat);
                result.add(c1);
            }
        }
        return result;
    }
    //Pour afficher le troisième graphique 
    public List<Client> GraphiqueClient() throws SQLException {

        List<Client> result = new LinkedList<>();

//requete sql : j'ai deméndé le CA groupé par client 
        String sql = "SELECT CUSTOMER.NAME AS H1, SUM(PURCHASE_ORDER.QUANTITY*PRODUCT.PURCHASE_COST) AS J1 FROM PRODUCT INNER JOIN PURCHASE_ORDER USING(PRODUCT_ID) INNER JOIN CUSTOMER USING(CUSTOMER_ID) GROUP BY CUSTOMER.NAME";

        try (Connection connection = myDataSource.getConnection();
                PreparedStatement stmt = connection.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                String client = rs.getString("H1");
                float prix = rs.getFloat("J1");
                Client c2 = new Client(client, prix);
                result.add(c2);
            }
        }
        return result;
    }

// permet d'ajouter une commande 
    public int addDiscountCode(int numC, int IDclient, int selectTemplate, int quantite, float fraisPort, Date dateVente, Date dateExp, String selectTemplate2) throws SQLException {
        int result = 0;

        String sql = "INSERT INTO PURCHASE_ORDER VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection connection = myDataSource.getConnection();
                PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, numC);
            stmt.setInt(2, IDclient);
            stmt.setInt(3, selectTemplate);
            stmt.setInt(4, quantite);
            stmt.setFloat(5, fraisPort);
            stmt.setDate(6, (java.sql.Date) dateVente);
            stmt.setDate(7, (java.sql.Date) dateExp);
            stmt.setString(8, selectTemplate2);
            result = stmt.executeUpdate();
        }
        return result;
    }

    /**
     * Supprime un enregistrement dans la table PURCHASE_ORDER
     *
     * @param code la clé de l'enregistrement à supprimer
     * @return le nombre d'enregistrements supprimés (1 ou 0)
     * @throws java.sql.SQLException renvoyées par JDBC
     *
     */
    public int deleteDiscountCode(int code) throws SQLException {
        int result = 0;
        String sql = "DELETE FROM PURCHASE_ORDER WHERE ORDER_NUM = ?";
        try (Connection connection = myDataSource.getConnection();
                PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, code);
            result = stmt.executeUpdate();
        }
        return result;
    }

    /**
     *Mise à jour de la table PURCHASE_ORDER 
     *modification des commandes
     * 
     * @param numC
     * @param IDclient
     * @param prodid
     * @param quantite
     * @param fraisPort
     * @param dateVente
     * @param dateExp
     * @param transport
     * @return
     * @throws SQLException
     */
    public int modifPurchaseOrder(int numC, int IDclient, int prodid, int quantite, float fraisPort, Date dateVente, Date dateExp, String transport) throws SQLException {
        int result = 0;
        String sql = "UPDATE PURCHASE_ORDER SET PRODUCT_ID=? , QUANTITY=?, SHIPPING_COST=?, SALES_DATE=?, SHIPPING_DATE=?, FREIGHT_COMPANY=? WHERE CUSTOMER_ID=" + IDclient + "AND ORDER_NUM=" + numC;
        try (Connection connection = myDataSource.getConnection();
                PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setInt(1, prodid);
            stmt.setInt(2, quantite);
            stmt.setFloat(3, fraisPort);
            stmt.setDate(4, (java.sql.Date) dateVente);
            stmt.setDate(5, (java.sql.Date) dateExp);
            stmt.setString(6, transport);
            result = stmt.executeUpdate();
        }
        return result;
    }

     /**
     *récuperation des noms des sociétés de transport pour les afficher dans ajouterCommande et modifierCommande
     * @return List des sociétés de transport
     */
    public List<String> nameCompany() {
        List<String> result = new ArrayList<>();
        String sql = "SELECT DISTINCT FREIGHT_COMPANY FROM PURCHASE_ORDER";
        try (Connection connection = myDataSource.getConnection();
                Statement stmt = connection.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                // On récupère les champs nécessaires de l'enregistrement courant
                String name = rs.getString("FREIGHT_COMPANY");
                // On l'ajoute à la liste des résultats
                result.add(name);
            }
        } catch (SQLException ex) {
            Logger.getLogger(DAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return result;
    }

}
