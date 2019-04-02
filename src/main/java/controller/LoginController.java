package controller;

import JDBC.CustomerEntity;
import JDBC.DAO;
import JDBC.DAOException;
import JDBC.DataSourceFactory;
import java.io.IOException;

import java.util.HashMap;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class LoginController extends HttpServlet {

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
            throws ServletException, IOException, DAOException {
        // Quelle action a appelé cette servlet ?
        String action = request.getParameter("action");
        System.out.println("Connexion :" + action);
        if (null != action) {
            switch (action) {
                case "Connexion":
                    checkLogin(request);
                    break;

                case "logout":
                    doLogout(request);
                    break;
            }

        }

        // Est-ce que l'utilisateur est connecté ?
        // On cherche l'attribut userName dans la session
        String userName = findUserInSession(request);
        String jspView;
        if (null == userName) { // L'utilisateur n'est pas connecté
            // On choisit la page de login
            jspView = "login.jsp";

        } else { // L'utilisateur est connecté
            // On choisit la page d'affichage
            if ("Administrateur".equals(userName)) {
                jspView = "/View/PageAdministrateur.jsp";
            } else {
                jspView = "Commandes.jsp";
            }
        }
        // On va vers la page choisie
        request.getRequestDispatcher(jspView).forward(request, response);

    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (DAOException ex) {
            Logger.getLogger(LoginController.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (DAOException ex) {
            Logger.getLogger(LoginController.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

    private void checkLogin(HttpServletRequest request) throws DAOException {
        // Les paramètres transmis dans la requête
        String loginParam = request.getParameter("loginParam");
        String passwordParam = request.getParameter("passwordParam");

        if (loginParam.equals("") || passwordParam.equals("")) {
            request.setAttribute("errorMessage", "Login/Password invalide");
            return;
        }

        // Le login/password défini dans web.xml
        String loginAdmin = getInitParameter("login");
        String passwordAdmin = getInitParameter("password");
        String userName = getInitParameter("userName");

        if (loginAdmin.equals(loginParam) && passwordAdmin.equals(passwordParam)) {
            // On a trouvé la combinaison login / password
            // On stocke l'information dans la session
            HttpSession session = request.getSession(true); // démarre la session
            session.setAttribute("userName", userName);

            //je compare le "customerID" rentré par l'utlisateur avec les "CustomerID" renvoyés par la requete du DAO
        } else {

            // création du DAO
            DAO dao = new DAO(DataSourceFactory.getDataSource());
            try {
                int customerID = Integer.valueOf(passwordParam);
                CustomerEntity customer = dao.findCustomer(customerID);

                if (customer != null && customer.getEmail().equals(loginParam) && customerID == customer.getCustomerId()) {
                    // On a trouvé la combinaison login / password
                    // On stocke l'information dans la session
                    HttpSession session = request.getSession(true); // démarre la session
                    session.setAttribute("userName", customer.getName());
                    session.setAttribute("userID", customer.getCustomerId());

                } else { // On positionne un message d'erreur pour l'afficher dans la JSP
                    request.setAttribute("errorMessage", "Login/Password incorrect");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Login/Password incorrect");
            }

        }

    }

    private void doLogout(HttpServletRequest request) {
        // On termine la session
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
    }

    private String findUserInSession(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return (session == null) ? null : (String) session.getAttribute("userName");
    }

}
