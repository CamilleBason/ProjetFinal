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
    <link rel="shortcut icon" type="image/x-icon" href="Image/commande.ico">
    <title>Commandes Client</title>
    <!-- On charge jQuery -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
    <!-- On charge le moteur de template mustache https://mustache.github.io/ -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/mustache.js/0.8.1/mustache.min.js"></script>

    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">

    <script>
        $(document).ready(// Exécuté à la fin du chargement de la page
            function () {
                // On montre la liste des commandes
                showCodes();
            }
        );

        function showCodes() {
            // On fait un appel AJAX pour chercher les codes
            $.ajax({
                //on charge la servlet ListCodesJsonServlet
                url: "allCodes",
                dataType: "json",
                //on affiche le type d'erreur si il y a une erreur
                error: showError,
                success: // La fonction qui traite les résultats
                    function (result) {
                        // Le code source du template est dans la page
                        var template = $('#codesTemplate').html();
                        // On combine le template avec le résultat de la requête
                        var processedTemplate = Mustache.to_html(template, result);
                        // On affiche la liste des options dans le select
                        $('#codes').html(processedTemplate);
                        let arrayLignes = document.getElementById("tableau").rows;
                        let userIDstr = document.getElementById("userID");
                        let userID = parseInt(userIDstr.value);
                        document.getElementById("codes").style.visibility = "visible";
                        document.getElementById("codes").style.display = "block";

                        //affiche seulement les bons de commandes du client connecté, les autres sont cachés

                        for (var i = 1; i < arrayLignes.length; i++) {

                            let clientIDstr = arrayLignes[i].cells[1].innerHTML;
                            let clientID = parseInt(clientIDstr);

                            if (clientID === userID) {
                                //on affiche seulement les commandes de l'utilisateur connecté
                                arrayLignes[i].style.visibility = "visible";

                            } else {
                                //sinon on les cache
                                arrayLignes[i].style.visibility = "hidden";
                                arrayLignes[i].style.display = "none";
                            }
                        }

                    }
            });

        }
        
        function modifierCommande(element){
            var rowSelected = element.parentNode.parentNode.rowIndex;
            console.log("row : " + element.parentNode.parentNode.rowIndex);
            //console.log("cells : " + document.getElementsByTagName('td').values(0));
            for(var i=0;i<1;i++) {
                var res = document.getElementById("tableau").rows[rowSelected].cells[i].innerHTML;
                console.log("res : " + res);
            }
            
            //var template = $('#codesTemplate').html();
            
            //console.log(this);
            window.location='modifierCommande.jsp'+'#' +res;
            
        }

        // Supprimer un code
        function deleteCode(code) {
            $.ajax({
                // utilise la servlet DeleteCodeJsonServlet 
                url: "deleteCode",
                data: {"code": code},
                dataType: "json",
                success:
                        function (result) {
                            showCodes();
                            alert("Votre bon de commande a été supprimé");
                            console.log(result);
                        },
                error: showError
            });
            return false;
        }

        // Fonction qui traite les erreurs de la requête
        function showError(xhr, status, message) {
            alert(JSON.parse(xhr.responseText).message);
        }

    </script>
</head>
<body>
    <nav class="navbar navbar-expand-md navbar-dark bg-dark fixed-top">

        <div class="ml-auto mr-3 my-2">
            <form action="<c:url value="/"/>" method="POST">
                <button type="submit" class="btn btn-secondary" name="action" value="Deconnexion">Se déconnecter</button>
            </form>
        </div>
    </nav>
    <div class="container" style="padding-top: 70px;">
        <!-- Afficher le nom de l'utlisateur -->
        <h1 class="text-primary">Bienvenue <span id="userName">${userName}</span></h1>

        <input id="userID" type="hidden" name="userName" value="${userID}">


        <h2>Vos bons de commande : </h2>
        <!--La zone où les résultats vont s'afficher -->
        <div id="codes"></div>

        <!-- Le template qui sert à formatter la liste des codes -->
        <script id="codesTemplate" type="text/template">
            <TABLE id="tableau" class="table table-striped">
            <thead>
            <tr>
                <th>Numéro du bon de commande</th>
                <th>Client ID</th>
                <th>ID du Produit</th>
                <th>Quantite</th>
                <th>Frais de port</th>
                <th>Date de vente</th>
                <th>Date d'expédition</th>
                <th colspan="2">Actions</th>
            </tr>
            </thead>
            <!--test : {{customerId}}==${userID}>-->
            {{! Pour chaque enregistrement }}
            {{#records}}
            {{! Une ligne dans la table }}
            <tbody>
            <tr>
                <td>{{orderNum}}</td>
                <td>{{customerId}}</td>
                <td>{{productID}}</td>
                <td>{{quantity}}</td>
                <td>{{shippingCost}}</td>
                <td>{{salesDate}}</td>
                <td>{{shippingDate}}</td>
                <td><button class="btn btn-danger" onclick="deleteCode('{{orderNum}}')">Supprimer</button></td>
                <td><button class="btn btn-primary" onclick="modifierCommande(this)">Modifier</button></td>
            </tr>
            </tbody>
            {{/records}}

            </TABLE>
            <p>

            </p>
            <button class="btn btn-primary" onclick="window.location='AjoutCommande.jsp'">Ajouter une commande</button>
        </script>

        <!--  <script id="selectTemplate" type="text/template">
                {{! Pour chaque état dans le tableau}}
                {{#records}}
                {{! Une option dans le select }}
                {{! le point représente la valeur courante du tableau }}
                <OPTION VALUE="{{.}}">{{.}}</OPTION>
                {{/records}}
            </script> 
        -->
    </div>

</body>
</html>
