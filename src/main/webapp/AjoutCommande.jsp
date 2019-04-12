<%-- 
    Document   : AjoutCommande
    Created on : 2 avr. 2019, 17:06:13
    Author     : cbason
--%>

<!DOCTYPE html>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%--
    La servlet fait : session.setAttribute("customer", customer)
    La JSP récupère cette valeur dans ${customer}
--%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="shortcut icon" type="image/x-icon" href="Image/commande.ico">
        <title>Ajout d'une commande</title>
        <!-- On charge jQuery -->
        <script	src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
        <!-- On charge le moteur de template mustache https://mustache.github.io/ -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/mustache.js/0.8.1/mustache.min.js"></script>

        <script src="./js/ajoutCommande.js"></script> 
        <link rel="stylesheet" href="./css/ajoutCommande.css"> 
        <script>
            $(document).ready(// Exécuté à la fin du chargement de la page
                    function () {
                        fillIDSelector();
                        fillTransportSelector();
                    }
            );

// Ajouter un code
            function addCode() {
                $.ajax({
                    url: "addCode",
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
        <h1>Ajout d'une commande</h1>
        <input id="userID" type="hidden" name="userName" value="${userID}">
        <!-- Le template qui sert à ajouter une commande -->

        <button class="retour" onclick="window.location = 'Commandes.jsp'">Voir mes commandes </button>

        <div id="messageAjout" style="color:red"></div>
        <!-- On montre le formulaire de saisie -->
        <h2>Edition d'un bon de commande</h2>
        <form id="codeForm" onsubmit="event.preventDefault();">
            <fieldset><legend>Saisie d'un bon de commande</legend>
                Numéro du bon de commande : <input id="code" name="code" type="number" min="0" required><br/>
                <!--Taux: <input id="taux" name="taux" value="1" readonly="readonly" required><br/>-->
                Client ID : <input id="taux" name="taux" value="${userID}" readonly="readonly" required><br/>

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
                <input type="submit" id="Ajouter" value="Ajouter" onclick="addCode()">

            </fieldset>
        </form>

        <form action="<c:url value="/"/>" method="POST"> 
            <input type='submit' name='action' value='Deconnexion'>
        </form>

    </body>
</html>
