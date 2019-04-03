<%-- 
    Document   : PageChoixGraphique
    Created on : 3 avr. 2019, 13:27:20
    Author     : cbason
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="shortcut icon" type="image/x-icon" href="image/commande.ico">
        <title>Administrateur</title>
        <!-- On charge jQuery -->
        
        <script	src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
        <!-- On charge le moteur de template mustache https://mustache.github.io/ -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/mustache.js/0.8.1/mustache.min.js"></script>
         <style>
                  @import url(https://fonts.googleapis.com/css?family=Roboto:400,500,700,300,100);
table {
                               font-family: "Roboto", helvetica, arial, sans-serif;
                               font-size:11px;
                               color:#333333;
                               border-width: 20px;
                               border-color: #666666;
                               border-collapse: collapse;
                       }
                       table th {
                               border-width: 1px;
                               padding: 8px;
                               border-style: solid;
                               border-color: #666666;
                               background-color: #3f819e;
                       }
                       table td {
                               border-width: 1px;
                               padding: 8px;
                               border-style: solid;
                               border-color: #666666;
                               background-color:  #ffffff;
			
                       }
                        
h1 { color: #3f819e;
font-family: "Roboto", helvetica, arial, sans-serif;}

button {
       border-radius:11px 11px 11px 11px;
       background: #3f819e;
       border:none;
       color:#333333;
       font:bold 12px Verdana;
       padding:6px 0 6px 0;
       box-shadow:1px 1px 3px #999;
}
h2 { color: #FF0000;
font-family: "Roboto", helvetica, arial, sans-serif;}   
        </style>
    </head>
    <body>
        <h1>Bienvenue <span id="userName">${userName}</span></h1>
    <button class="Graphique1" onclick="window.location='PageAdministrateur1.jsp'">Chiffre d'affaire par catégorie article</button>
   <button class="Graphique2" onclick="window.location='PageAdministrateur2.jsp'">Chiffre d'affaire par zonne géographique</button>
   <button class="Graphique3" onclick="window.location='PageAdministrateur3.jsp'">Chiffre d'affaire par client</button>
   
    </body>
</html>
