<%-- 
    Document   : newjsp
    Created on : 2 avr. 2019, 13:26:16
    Author     : cbason
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                <link rel="shortcut icon" type="image/x-icon" href="images/customer.ico">
		<title>You are connected</title>
                <!-- On charge jQuery -->
                <script	src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
                <!-- On charge le moteur de template mustache https://mustache.github.io/ -->
                <script src="https://cdnjs.cloudflare.com/ajax/libs/mustache.js/0.8.1/mustache.min.js"></script>

    </head>
    <body>
        <h1>Bienvenue <span id="userName">${userName}</span></h1>
        
            <input id="userID" type="hidden" name="userName" value="${userID}">
                
                <h2>Vos bons de commande : </h2>
                    <!-- La zone où les résultats vont s'afficher -->
                    <div id="codes"></div>

                    <!-- Le template qui sert à formatter la liste des codes -->
                    <script id="codesTemplate" type="text/template">
                        
                        <TABLE id="tableau">
                        <thead>
                            <tr><th>Numéro du bon de commande</th><th>Client ID</th><th>ID du Produit</th><th>Quantite</th><th>Prix</th><th>Date de vente</th></tr>
                        </thead>
<!--                         test : {{customerId}}==${userID}>-->
                        {{! Pour chaque enregistrement }}
                        {{#records}}
                            {{! Une ligne dans la table }}
                            <tbody>
                                <TR><TD>{{orderNum}}</TD><TD>{{customerId}}</TD><TD>{{productID}}</TD><TD>{{quantity}}</TD><TD>{{shippingCost}}</TD><TD>{{salesDate}}</TD><TD><button class="supprimer" onclick="deleteCode('{{orderNum}}')">Supprimer</button></TD></TR>
                            </tbody>
                        {{/records}}

                        </TABLE>
  
                    </script>
    </body>
</html>
