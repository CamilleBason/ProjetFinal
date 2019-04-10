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
        
         <script	src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
        <!-- On charge le moteur de template mustache https://mustache.github.io/ -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/mustache.js/0.8.1/mustache.min.js"></script>
        <script src="./js/commandes.js"></script>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
        <link rel="stylesheet" href="./css/commandes.css">
<script>
            $(document).ready(// Exécuté à la fin du chargement de la page
                    function () {
                        // On montre la liste des codes
                        showCodes();
                    }
            );

            function showCodes() {
                        // On fait un appel AJAX pour chercher les codes
                        $.ajax({
                            url: "allCodes",
                            dataType: "json",
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
                                        //console.log("userID : " + userID);
                                        for (var i = 1; i < arrayLignes.length; i++) {
                                                //console.log("cc");
                                                let clientIDstr = arrayLignes[i].cells[1].innerHTML;
                                                let clientID = parseInt(clientIDstr);
                                                //console.log(clientID);
                                                //console.log(clientID === userID);
                                                if (clientID === userID) {
                                                        arrayLignes[i].style.visibility = "visible";
                                                        //arrayLignes[i].style.display = "block";
                                                } else {
                                                        arrayLignes[i].style.visibility = "hidden";
                                                        arrayLignes[i].style.display = "none";
                                                }
                                        }
                                        
                                        document.getElementById("Modifier").disabled = true;
                                
                                        //double click modifier
                                        $("tbody TR").dblclick(function(event) {
                                            //console.log($(this).parent());
                                            //console.log($(this).parent());
                                            //console.log($(this).parent().context.innerHTML);
                                            //console.log($(this).parent().context.innerText);
                                            //var ligne =$(this).parent().context.innerHTML;
                                            //console.log(ligne[0]);
                                            var ligne = $(this).parent().context.innerText;
                                            ligneSelectionne = ligne.split("	");
                                            //console.log(ligneSelectionne);
                                            
                                            modeModifier(ligneSelectionne);

                                        });
                                        
                                        $("#ToutEffacer").click(function(event) {
                                            toutEffacer();
                                        });
                                    }
                        });
                     
                    }

            // Ajouter un code
            /*
            function addCode() {
                $.ajax({
                    url: "addCode",
                    // serialize() renvoie tous les paramètres saisis dans le formulaire
                    data: $("#codeForm").serialize(),
                    dataType: "json",
                    success: // La fonction qui traite les résultats
                            function (result) {
                                showCodes();
                                console.log(result);
                            },
                    error: showError
                });
                return false;
            }*/

            // Supprimer un code
            function deleteCode(code) {
                $.ajax({
                    url: "deleteCode",
                    data: {"code": code},
                    dataType: "json",
                    success: 
                            function (result) {
                                showCodes();
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

        </script>    </head>
    <body>
        <div class="container">
            <h1 class="text-primary">Bienvenue <span id="userName">${userName}</span></h1>

            <input id="userID" type="hidden" name="userName" value="${userID}">
            <!-- La zone d'erreur -->
            <div id="erreur"></div>

            <h2>Vos bons de commande : </h2>
            <!-- La zone où les résultats vont s'afficher -->
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
                <!--                         test : {{customerId}}==${userID}>-->
                {{! Pour chaque enregistrement }}
                {{#records}}
                {{! Une ligne dans la table }}
                <tbody>
                <TR>
                    <TD>{{orderNum}}</TD>
                    <TD>{{customerId}}</TD>
                    <TD>{{productID}}</TD>
                    <TD>{{quantity}}</TD>
                    <TD>{{shippingCost}}</TD>
                    <TD>{{salesDate}}</TD>
                    <TD>{{shippingDate}}</TD>
                    <TD><button class="btn btn-danger" onclick="deleteCode('{{orderNum}}')">Supprimer</button></TD>
                    <TD><button class="btn btn-info" onclick="deleteCode('{{orderNum}}')">Modifier</button>
                    </TD>
                </TR>
                </tbody>
                {{/records}}

                </TABLE>
                <p>

               </p>
            <button class="btn btn-primary" onclick="window.location='AjoutCommande.jsp'">Ajouter une commande</button>
            </script>

            <script id="selectTemplate" type="text/template">
                {{! Pour chaque état dans le tableau}}
                {{#records}}
                {{! Une option dans le select }}
                {{! le point représente la valeur courante du tableau }}
                <OPTION VALUE="{{.}}">{{.}}</OPTION>
                {{/records}}
            </script>

            <form action="<c:url value="/"/>" method="POST"> 
                            <input class="btn btn-secondary" type='submit' name='action' value='Deconnexion'>
            </form>
        </div>
            
    </body>
</html>
