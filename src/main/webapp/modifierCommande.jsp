<%-- 
    Document   : modifierCommande
    Created on : 10 avr. 2019, 15:02:13
    Author     : achelle
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Modifier Commande</title>
        <link rel="shortcut icon" type="image/x-icon" href="Image/commande.ico">
        <!-- On charge jQuery -->
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
        <!-- On charge le moteur de template mustache https://mustache.github.io/ -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/mustache.js/0.8.1/mustache.min.js"></script>
        <script src="./js/commandes.js"></script>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
        <link rel="stylesheet" href="./css/modifierCommande.css">

        <!--<script>
            function modeModifier(ligneSelectionne) {

                var numCo = document.getElementById("code");
                numCo.value = ligneSelectionne[0];
                numCo.setAttribute("readonly", "readonly");

                //var client = document.getElementById("taux");
                //client.value = ligneSelectionne[1];
                var produitId = document.getElementById("prodid");
                produitId.value = ligneSelectionne[2];
                var quantite = document.getElementById("quantite");
                quantite.value = ligneSelectionne[3];
                var fraisP = document.getElementById("fraisP");
                fraisP.value = ligneSelectionne[4];
                var dateV = document.getElementById("dateV");
                dateV.value = ligneSelectionne[5];
                var dateE = document.getElementById("dateE");
                dateE.value = ligneSelectionne[6];
                var transport = document.getElementById("transport");
                transport.value = ligneSelectionne[7];

                numCo.focus();
            }
        </script>-->

    </head>
    <body>
        <h1>modifier votre commande :</h1>

        <form id="codeForm" onsubmit="event.preventDefault();">
            <fieldset><legend>Saisie d'un bon de commande</legend>
                Numéro du bon de commande : <input id="code" name="id" value="<%=request.getAttribute("id")%>" type="text" required><br/>
                Client ID : <input id="taux" name="taux" value="${userID}" readonly="readonly" required><br/>
                ID du Produit : <select id="prodid" name="prodid" size="1" required>
                    <option>---</option></select><br/>
                Quantité : <input id="quantite" name="quantite" type="number" required><br/>
                Frais de port : <input id="fraisP" name="fraisP" type="number" required><br/>
                Date de vente : <input id="dateV" name="dateVente" type="date" required><br/>
                Date d'expédition : <input id="dateE" name="dateExp" type="date" required><br/>
                Société de transport : <input id="transport" name="transport" type="text" size="40" required><br/>
            </fieldset>
        </form>


        <form action="<c:url value="/"/>" method="POST">
            <input class='deconnexion' type='submit' name='boutonConnexion' value='Se deconnecter'>
        </form>
    </body>
</html>
