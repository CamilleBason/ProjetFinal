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

        <script>
            $(document).ready(// Exécuté à la fin du chargement de la page
                    function () {
                        //met les ID des produits et les entreprises de transport dans le menu déroullant
                        fillIDSelector();
                        fillTransportSelector();
                        //recuperation de la valeur du nulméro de commande de l'url
                        var numCo = window.location.hash.substring(1);
                        //assignation du numéro de la commande à l'element code
                       document.getElementById("code").value = numCo;
                    }
            );

// Modification d'une commande
            function modifier() {
                $.ajax({
                    url: "Modify",//on charge la servlet Modify
                    // serialize() renvoie tous les paramètres saisis dans le formulaire
                    data: $("#codeForm").serialize(),
                    dataType: "json",
                    success: // La fonction qui traite les résultats
                            function (result) {
                                console.log(result);
                                var mes = document.getElementById("messageModifier");
                                mes.innerHTML = result.message;
                            },
                    error: showError
                });
                return false;
            }
            function fillIDSelector() {
                // On fait un appel AJAX pour chercher les prouits existants
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
                // On fait un appel AJAX pour chercher les transporteurs existants
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
    <nav class="navbar navbar-expand-md navbar-dark bg-dark fixed-top">
        <div class="ml-3 mr-auto my-2">
            <button class="btn btn-primary" onclick="window.location = 'Commandes.jsp'">Voir mes commandes </button>
        </div>
        <div class="ml-auto mr-3 my-2">
            <form action="<c:url value="/"/>" method="POST">
                <button type="submit" class="btn btn-secondary" name="action" value="Deconnexion">Se déconnecter</button>
            </form>
        </div>
    </nav>
    <div class="container" style="padding-top: 70px;">

        <h1>Modifier votre commande :</h1>

        <%
            String error = (String) request.getAttribute("errorMessage");
            if (error != null) {
        %>
                <div id="error" class="bg-danger text-light p-2 rounded"><%= error %></div>
        <% } %>


        <form id="codeForm" onsubmit="modifier();event.preventDefault();">
            <div class="row">
                <div class="col-md-4 form-group">
                    <label for="code">Numéro du bon de commande :</label>
                    <input class="form-control" id="code" name="code" readonly="readonly" type="text" required>
                </div>

                <div class="col-md-4 form-group">
                    <label for="clientID">Client ID :</label>
                    <input class="form-control" id="clientID" name="clientID" value="${userID}" readonly="readonly"
                        required>
                </div>

                <script id="selectTemplate" type="text/template">
                    {{! Pour chaque état dans le tableau}}
                    {{#records}}
                    {{! Une option dans le select }}
                    {{! le point représente la valeur courante du tableau }}
                    <option VALUE="{{.}}">{{.}}</option>
                    {{/records}}
                </script>

                <div class="col-md-4 form-group">
                    <label for="ID">ID du Produit :</label>
                    <select class="form-control" id="ID" name="ID"></select>
                </div>

                <div class="col-md-2 form-group">
                    <label for="quantite">Quantité :</label>
                    <input class="form-control" id="quantite" name="quantite" type="number" min="0" required>
                </div>

                <div class="col-md-2 form-group">
                    <label for="fraisP">Frais de port :</label>
                    <input class="form-control" id="fraisP" name="fraisP" type="number" min="0" required>
                </div>

                <div class="col-md-2 form-group">
                    <label for="dateV">Date de vente :</label>
                    <input class="form-control" id="dateV" name="dateVente" type="date" required>
                </div>

                <div class="col-md-2 form-group">
                    <label for="dateE">Date d'expédition :</label>
                    <input class="form-control" id="dateE" name="dateExp" type="date" required>
                </div>

                <script id="selectTemplate2" type="text/template">
                    {{! Pour chaque état dans le tableau}}
                    {{#records}}
                    {{! Une option dans le select }}
                    {{! le point représente la valeur courante du tableau }}
                    <option VALUE="{{.}}">{{.}}</option>
                    {{/records}}
                </script>

                <div class="col-md-4 form-group">
                    <label for="Transport">Société de transport :</label>
                    <select class="form-control" id="Transport" name="Transport"></select>
                </div>
            </div>

            <div class="form-group">
                <button type="submit" class="btn btn-primary" id="Modifier" value="Modifier">Valider</button>
            </div>
        </form>
    </div>
</body>

</html>