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

    public HashMap connectionClient() throws DAOException {
        HashMap login = new HashMap();
        String sql = "SELECT EMAIL,CUSTOMER_ID FROM CUSTOMER";
        try (Connection connection = myDataSource.getConnection(); // Ouvrir une connexion
                Statement stmt = connection.createStatement(); // On crée un statement pour exécuter une requête
                ResultSet rs = stmt.executeQuery(sql) // Un ResultSet pour parcourir les enregistrements du résultat
                ) {
            if (rs.next()) { // On a trouvé
                String email = rs.getString("EMAIL");
                String id = rs.getString("CUSTOMER_ID");
                // On crée l'objet "entity"
                login.put(email, id);

            } // else on n'a pas trouvé, on renverra null
        } catch (SQLException ex) {
            Logger.getLogger("DAO").log(Level.SEVERE, null, ex);
            throw new DAOException(ex.getMessage());
        }
        return login;
    }
    public List<Integer> idProducts(){
        List<Integer> result = new ArrayList<>();
		String sql = "SELECT DISTINCT PRODUCT_ID FROM PRODUCT";
		try ( Connection connection = myDataSource.getConnection(); 
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
     *
     * @return le nombre d'enregistrements dans la table CUSTOMER
     * @throws DAOException
     */
    public int numberOfCustomers() throws DAOException {
        int result = 0;

        String sql = "SELECT COUNT(*) AS NUMBER FROM CUSTOMER";
        // Syntaxe "try with resources" 
        // cf. https://stackoverflow.com/questions/22671697/try-try-with-resources-and-connection-statement-and-resultset-closing
        try (Connection connection = myDataSource.getConnection(); // Ouvrir une connexion
                Statement stmt = connection.createStatement(); // On crée un statement pour exécuter une requête
                ResultSet rs = stmt.executeQuery(sql) // Un ResultSet pour parcourir les enregistrements du résultat
                ) {
            if (rs.next()) { // Pas la peine de faire while, il y a 1 seul enregistrement
                // On récupère le champ NUMBER de l'enregistrement courant
                result = rs.getInt("NUMBER");
            }
        } catch (SQLException ex) {
            Logger.getLogger("DAO").log(Level.SEVERE, null, ex);
            throw new DAOException(ex.getMessage());
        }

        return result;
    }

    /**
     * Detruire un enregistrement dans la table CUSTOMER
     *
     * @param customerId la clé du client à détruire
     * @return le nombre d'enregistrements détruits (1 ou 0 si pas trouvé)
     * @throws DAOException
     */
    public int deleteCustomer(int customerId) throws DAOException {

        // Une requête SQL paramétrée
        String sql = "DELETE FROM CUSTOMER WHERE CUSTOMER_ID = ?";
        try (Connection connection = myDataSource.getConnection();
                PreparedStatement stmt = connection.prepareStatement(sql)) {
            // Définir la valeur du paramètre
            stmt.setInt(1, customerId);

            return stmt.executeUpdate();

        } catch (SQLException ex) {
            Logger.getLogger("DAO").log(Level.SEVERE, null, ex);
            throw new DAOException(ex.getMessage());
        }
    }

    /**
     *
     * @param customerId la clé du client à recherche
     * @return le nombre de bons de commande pour ce client (table
     * PURCHASE_ORDER)
     * @throws DAOException
     */
    public int numberOfOrdersForCustomer(int customerId) throws DAOException {
        int result = 0;

        // Une requête SQL paramétrée
        String sql = "SELECT COUNT(*) AS NUMBER FROM PURCHASE_ORDER WHERE CUSTOMER_ID = ?";
        try (Connection connection = myDataSource.getConnection();
                PreparedStatement stmt = connection.prepareStatement(sql)) {
            // Définir la valeur du paramètre
            stmt.setInt(1, customerId);

            try (ResultSet rs = stmt.executeQuery()) {
                rs.next(); // On a toujours exactement 1 enregistrement dans le résultat
                result = rs.getInt("NUMBER");
            }
        } catch (SQLException ex) {
            Logger.getLogger("DAO").log(Level.SEVERE, null, ex);
            throw new DAOException(ex.getMessage());
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
    
    public List<DiscountCode> allDiscountCodes() throws SQLException {

		List<DiscountCode> result = new LinkedList<>();

		String sql ="SELECT PRODUCT_CODE.DESCRIPTION AS SA, SUM(PURCHASE_ORDER.QUANTITY*PRODUCT.PURCHASE_COST) AS CA FROM PRODUCT INNER JOIN PURCHASE_ORDER USING(PRODUCT_ID)INNER JOIN PRODUCT_CODE ON PRODUCT.PRODUCT_CODE=PRODUCT_CODE.PROD_CODE GROUP BY PRODUCT_CODE.DESCRIPTION";
//"SELECT PRODUCT.PRODUCT_CODE AS SA, SUM(PURCHASE_ORDER.QUANTITY*PRODUCT.PURCHASE_COST) AS CA FROM PRODUCT INNER JOIN PURCHASE_ORDER USING(PRODUCT_ID) GROUP BY PRODUCT_CODE";
                        //"SELECT PRODUCT_ID, SUM(QUANTITY) AS ARBRE FROM PURCHASE_ORDER GROUP BY PRODUCT_ID ";//GROUP BY PRODUCT_ID";
// "SELECT PRODUCT_ID, (PURCHASE_ORDER.QUANTITY * PRODUCT.PURCHASE_COST) FROM PURCHASE_ORDER INNER JOIN PRODUCT USING(PRODUCT_ID) GROUP BY PRODUCT_ID";
		try (Connection connection = myDataSource.getConnection(); 
		     PreparedStatement stmt = connection.prepareStatement(sql)) {
			ResultSet rs = stmt.executeQuery();
			while (rs.next()) {
				String sommequantite = rs.getString("SA");
                               float produit = rs.getFloat("CA");
				DiscountCode c = new DiscountCode(sommequantite, produit);
				result.add(c);
			}
		}
		return result;
	}
      public List<DiscountCode> ZoneGeographique() throws SQLException {

		List<DiscountCode> result = new LinkedList<>();

		String sql ="SELECT CUSTOMER.CITY AS VILLE, SUM(PURCHASE_ORDER.QUANTITY*PRODUCT.PURCHASE_COST) AS PRIX FROM CUSTOMER INNER JOIN PURCHASE_ORDER USING(CUSTOMER_ID) GROUP BY CUSTOMER.CITY";
//"SELECT PRODUCT.PRODUCT_CODE AS SA, SUM(PURCHASE_ORDER.QUANTITY*PRODUCT.PURCHASE_COST) AS CA FROM PRODUCT INNER JOIN PURCHASE_ORDER USING(PRODUCT_ID) GROUP BY PRODUCT_CODE";
                        //"SELECT PRODUCT_ID, SUM(QUANTITY) AS ARBRE FROM PURCHASE_ORDER GROUP BY PRODUCT_ID ";//GROUP BY PRODUCT_ID";
// "SELECT PRODUCT_ID, (PURCHASE_ORDER.QUANTITY * PRODUCT.PURCHASE_COST) FROM PURCHASE_ORDER INNER JOIN PRODUCT USING(PRODUCT_ID) GROUP BY PRODUCT_ID";
		try (Connection connection = myDataSource.getConnection(); 
		     PreparedStatement stmt = connection.prepareStatement(sql)) {
			ResultSet rs = stmt.executeQuery();
			while (rs.next()) {
				String sommequantite = rs.getString("SA");
                               float produit = rs.getFloat("CA");
				DiscountCode c = new DiscountCode(sommequantite, produit);
				result.add(c);
			}
		}
		return result;
	}

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
     * Supprime un enregistrement dans la table DISCOUNT_CODE
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
     public List<Product> allProducts() throws SQLException {

		List<Product> result = new LinkedList<>();

		String sql = "SELECT * FROM PRODUCT ORDER BY PRODUCT_ID";
		try (Connection connection = myDataSource.getConnection(); 
		     PreparedStatement stmt = connection.prepareStatement(sql)) {
			ResultSet rs = stmt.executeQuery();
			while (rs.next()) {                                
                                int prodid = rs.getInt("PRODUCT_ID");
                                int manufac_id = rs.getInt("MANUFACTURER_ID");
                                String code = rs.getString("PRODUCT_CODE");
                                float cout_achat = rs.getFloat("PURCHASE_COST");
                                int quantite_dispo = rs.getInt("QUANTITY_ON_HAND");
                                float majoration = rs.getFloat("MARKUP");
                                boolean dispo = rs.getBoolean("AVAILABLE");
                                String descrip = rs.getString("DESCRIPTION");
                                // On crée l'objet "product"
                                Product p = new Product(prodid, manufac_id, code, cout_achat, quantite_dispo, majoration, dispo, descrip);
                                result.add(p);
			}
		}
		return result;
	}
         public List<String> nameCompany(){
        List<String> result = new ArrayList<>();
		String sql = "SELECT DISTINCT FREIGHT_COMPANY FROM PURCHASE_ORDER";
		try ( Connection connection = myDataSource.getConnection(); 
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
