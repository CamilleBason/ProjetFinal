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
        <title>Commandes Client</title>
        <!-- On charge jQuery -->
        <script	src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
        <!-- On charge le moteur de template mustache https://mustache.github.io/ -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/mustache.js/0.8.1/mustache.min.js"></script>

        <script>
            $(document).ready(// Exécuté à la fin du chargement de la page
                    function () {
                        // On afiche le tableau de commande du client
                        showPurchase();
                    }
            );

            // Afficher les clients dans l'état sélectionné
            function showPurchase() {
                // Quel est le client sélectionné ?

                // On fait un appel AJAX pour chercher les clients de cet état
                $.ajax({
                    url: "Purchases",
                    dataType: "json",
                    success: // La fonction qui traite les résultats
                            function (result) {
                                $var template = $('#customerTemplate').html();
                                // On convertit les enregistrements en table HTML
                                $('#customers').html(processedTemplate);
                            },
                    error: showError
                });
            }

            // Fonction qui traite les erreurs de la requête
            function showError(xhr, status, message) {
                $("#erreur").html("Erreur: " + status + " : " + message);
            }
        </script>




    </head>
    <body>
        <h1>Bienvenue <span id="userName">${userName}</span></h1>

        <input id="userID" type="hidden" name="userName" value="${userID}">
        <!-- La zone d'erreur -->
        <div id="erreur"></div>

        <h2>Vos bons de commande : </h2>
        <!-- La zone où les résultats vont s'afficher -->
        <div id="codes"></div>

        <!-- Le template qui sert à formatter la liste des codes -->
        <script id="customerTemplate" type="text/template">
            <TABLE id="tableau" BORDER="1">
            {{! Un commentaire Mustache }}
            <tr><th>Numéro du bon de commande</th><th>Client ID</th><th>ID du Produit</th><th>Quantite</th><th>Prix</th><th>Date de vente</th></tr>
            {{! Pour chaque enregistrement }}
            {{#records}}
            {{! Une ligne dans la table }}
            <tbody>
            <TR><TD>{{orderNum}}</TD><TD>{{customerId}}</TD><TD>{{productID}}</TD><TD>{{quantity}}</TD><TD>{{shippingCost}}</TD><TD>{{salesDate}}</TD><TD><button class="supprimer" onclick="deleteCode('{{orderNum}}')">Supprimer</button></TD></TR>
            </tbody>
            {{/records}}
            </TABLE>
        </script>

    </head>
<body>
    <h1>Bienvenue <span id="userName">${userName}</span></h1>
    <input id="userID" type="hidden" name="userName" value="${userID}">


    <!-- Le template qui sert à formatter la liste des clients résultats -->
    <script id="selectTemplate" type="text/template">
        {{! Pour chaque état dans le tableau}}
        {{#records}}
        {{! Une option dans le select }}
        {{! le point représente la valeur courante du tableau }}
        <OPTION VALUE="{{.}}">{{.}}</OPTION>
        {{/records}}
    </script>



</html>
