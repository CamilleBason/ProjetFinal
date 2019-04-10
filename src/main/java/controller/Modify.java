/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Servlet;

import com.google.gson.Gson;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Properties;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import JDBC.DAO;
import JDBC.DataSourceFactory;

/**
 *
 * @author camil
 */

@WebServlet(name = "Modify", urlPatterns = {"/Modify"})
public class Modify extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, ParseException {
            
            DAO dao = new DAO(DataSourceFactory.getDataSource());
            String numC = request.getParameter("code");
            String IDclient = request.getParameter("taux");
            String prodid = request.getParameter("prodid");
            String quantite = request.getParameter("quantite");
            String fraisPort = request.getParameter("fraisP");
            String dateVente = request.getParameter("dateVente");
            String dateExp = request.getParameter("dateExp");
            String transport = request.getParameter("transport");
            
            String message;
            SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
            java.util.Date dateV = formatter.parse(dateVente);
            java.util.Date dateE = formatter.parse(dateExp);
            java.sql.Date dateVenteSQL = new java.sql.Date(dateV.getTime());
            java.sql.Date dateExpSQL = new java.sql.Date(dateE.getTime());
            
            try {
                    dao.modifPurchaseOrder(Integer.valueOf(numC), Integer.valueOf(IDclient), Integer.valueOf(prodid), Integer.valueOf(quantite), Float.valueOf(fraisPort), dateVenteSQL, dateExpSQL, transport);
                    message = String.format("Bon de commande n° %s modifié", numC);
		} catch (NumberFormatException | SQLException ex) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    message = ex.getMessage();
		}
		
            Properties resultat = new Properties();
            resultat.put("message", message);

            try (PrintWriter out = response.getWriter()) {
                    // On spécifie que la servlet va générer du JSON
                    response.setContentType("application/json;charset=UTF-8");
                    // Générer du JSON
                    Gson gson = new Gson();
                    out.println(gson.toJson(resultat));
            }
        
    }
}