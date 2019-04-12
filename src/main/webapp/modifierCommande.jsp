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
        
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
        <link rel="stylesheet" href="./css/modifierCommande.css">

        <script>
            $(document).ready(// Exécuté à la fin du chargement de la page
                    function () {
                        fillIDSelector();
                        fillTransportSelector();
                        //document.getElementById('code').html(window.location.hash.substring(1));
                        //console.log(window.location.hash.substring(1));
                        var numCo = window.location.hash.substring(1);
                       document.getElementById("code").value = numCo;
                    }
            );

// Ajouter un code
            function modifier() {
                $.ajax({
                    url: "Modify",
                    // serialize() renvoie tous les paramètres saisis dans le formulaire
                    data: $("#codeForm").serialize(),
                    dataType: "json",
                    success: // La fonction qui traite les résultats
                            function (result) {
                                //showCodes();
                                console.log(result);
                            },
                    error: showError
                });
                return false;
            }
            function fillIDSelector() {
                // On fait un appel AJAX pour chercher les états existants
                $.ajax({
                    url: "AddIdProducts",
                    dataType: "json",
                    error: showError,
                    success: // La fonction qui traite les résultats
                            function (result) {
                                // Le code source du template est dans la page
                                var template = $('#selectTemplate').html();
                                // On combine le template avec le résultat de la requête
                                var processedTemplate = Mustache.to_html(template, result);
                                // On affiche la liste des options dans le select
                                $('#ID').html(processedTemplate);
                            }
                });
            }

            function fillTransportSelector() {
                // On fait un appel AJAX pour chercher les états existants
                $.ajax({
                    url: "AddNameManufacturer",
                    dataType: "json",
                    error: showError,
                    success: // La fonction qui traite les résultats
                            function (result) {
                                // Le code source du template est dans la page
                                var template = $('#selectTemplate2').html();
                                // On combine le template avec le résultat de la requête
                                var processedTemplate = Mustache.to_html(template, result);
                                // On affiche la liste des options dans le select
                                $('#Transport').html(processedTemplate);
                            }
                });
            }


// Fonction qui traite les erreurs de la requête
            function showError(xhr, status, message) {
                alert("Erreur: " + status + " : " + message);
            }
        </script>

    </head>
    <body>

        <button class="retour" onclick="window.location = 'Commandes.jsp'">Voir mes commandes </button>
        <h1>modifier votre commande :</h1>
        
         <div id="messageModifier" style="color:red"></div>

        <form id="codeForm">
            <fieldset><legend>Saisie d'un bon de commande</legend>
                Numéro du bon de commande : <input id="code" name="code" readonly="readonly" type="text" required><br/>
                Client ID : <input id="clientID" name="clientID" value="${userID}" readonly="readonly" required><br/>
                <script id="selectTemplate" type="text/template">
                    {{! Pour chaque état dans le tableau}}
                    {{#records}}
                    {{! Une option dans le select }}
                    {{! le point représente la valeur courante du tableau }}
                    <OPTION VALUE="{{.}}">{{.}}</OPTION>
                    {{/records}}
                </script>
                <form>
                    <label for="ID">ID du Produit :</label>
                    <select id="ID" name="ID"></select>
                </form>

                Quantité : <input id="quantite" name="quantite" type="number"  min="0" required><br/>
                Frais de port : <input id="fraisP" name="fraisP" type="number" min="0" required><br/>
                Date de vente : <input id="dateV" name="dateVente" type="date" required><br/>
                Date d'expédition : <input id="dateE" name="dateExp" type="date" required><br/>

                <script id="selectTemplate2" type="text/template">
                    {{! Pour chaque état dans le tableau}}
                    {{#records}}
                    {{! Une option dans le select }}
                    {{! le point représente la valeur courante du tableau }}
                    <OPTION VALUE="{{.}}">{{.}}</OPTION>
                    {{/records}}
                </script>
                <form>
                    <label for="Transport">Société de transport :</label>
                    <select id="Transport" name="Transport"></select>
                </form>
                <input type="submit" id="Modifier" value="Modifier" onclick="modifier()">
            </fieldset>
        </form>


        <form action="<c:url value="/"/>" method="POST">
            <input class='deconnexion' type='submit' name='boutonConnexion' value='Se deconnecter'>
        </form>
    </body>
</html>
