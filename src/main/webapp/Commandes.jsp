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
        <link rel="shortcut icon" type="image/x-icon" href="image/commande.ico">
        <title>Commandes Client</title>
        <!-- On charge jQuery -->
        
        <script	src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
        <!-- On charge le moteur de template mustache https://mustache.github.io/ -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/mustache.js/0.8.1/mustache.min.js"></script>
        


        <script>
            $(document).ready(// Exécuté à la fin du chargement de la page
                    function () {
                        // On montre la liste des codes
                        showCodes();
                        showProducts();
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
                                $("tbody TR").dblclick(function (event) {
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

                                $("#ToutEffacer").click(function (event) {
                                    toutEffacer();
                                });
                            }
                });

            }




            // Ajouter un code
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
                                toutEffacer();
                                var mes = document.getElementById("messageAjout");
                                mes.innerHTML = result.message;
                            },
                    error: showError
                });
                return false;
            }

            function modify() {
                $.ajax({
                    url: "Modify",
                    data: $("#codeForm").serialize(),
                    dataType: "json",
                    success:
                            function (result) {
                                showCodes();
                                console.log(result); // faire une fenetre popup
                                toutEffacer();
                            },
                    error: showError
                });

            }

            // Supprimer un code
            function deleteCode(code) {
                $.ajax({
                    url: "deleteCode",
                    data: {"code": code},
                    dataType: "json",
                    success:
                            function (result) {
                                alert("Bon de commande supprimé");
                                showCodes();
                                console.log(result);
                            },
                    error: showError
                });
                return false;
            }

            //affiche les produits existant
            function showProducts() {
                $.ajax({
                    url: "allProducts",
                    dataType: "json",
                    error: showError,
                    success:
                            function (result) {
                                //console.log(result);
                                //console.log(result.prod[0]);
                                var sel = document.getElementById("prodid");
                                for (var i = 0; i < result.prod.length; i++) {
                                    var opt = document.createElement("option");
                                    opt.value = result.prod[i].id;
                                    opt.text = result.prod[i].id + " : " + result.prod[i].description;
                                    sel.add(opt, null);
                                }
                            }
                });
            }

            function modeModifier(ligneSelectionne) {
                document.getElementById("Ajouter").disabled = true;
                document.getElementById("Modifier").disabled = false;

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

            function toutEffacer() {
                if (document.getElementById("Ajouter").disabled === true) {
                    document.getElementById("Ajouter").disabled = false;
                }
                if (document.getElementById("Modifier").disabled === false) {
                    document.getElementById("Modifier").disabled = true;
                }
                if (document.getElementById("code").getAttribute("readonly") === "readonly") {
                    document.getElementById("code").removeAttribute("readonly");
                }
                var numCo = document.getElementById("code");
                numCo.value = null;
                var quantite = document.getElementById("quantite");
                quantite.value = null;
                var fraisP = document.getElementById("fraisP");
                fraisP.value = null;
                var dateV = document.getElementById("dateV");
                dateV.value = null;
                var dateE = document.getElementById("dateE");
                dateE.value = null;
                var transport = document.getElementById("transport");
                transport.value = null;
            }

            // Fonction qui traite les erreurs de la requête
            function showError(xhr, status, message) {
                alert(JSON.parse(xhr.responseText).message);
            }



        </script> 
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

        <input id="userID" type="hidden" name="userName" value="${userID}">
        <!-- La zone d'erreur -->
        <div id="erreur"></div>

        <h2>Vos bons de commande : </h2>
        <!-- La zone où les résultats vont s'afficher -->
        <div id="codes"></div>

        <!-- Le template qui sert à formatter la liste des codes -->
        <script id="codesTemplate" type="text/template">
            <TABLE id="tableau">
            <thead>
            <tr><th>Numéro du bon de commande</th><th>Client ID</th><th>ID du Produit</th><th>Quantite</th><th>Frais de port</th><th>Date de vente</th><th>Date d'expédition</th><th>Suppression</th><th>Modifier</th></tr>
            </thead>
            <!--                         test : {{customerId}}==${userID}>-->
            {{! Pour chaque enregistrement }}
            {{#records}}
            {{! Une ligne dans la table }}
            <tbody>
            <TR><TD>{{orderNum}}</TD><TD>{{customerId}}</TD><TD>{{productID}}</TD><TD>{{quantity}}</TD><TD>{{shippingCost}}</TD><TD>{{salesDate}}</TD><TD>{{shippingDate}}</TD><TD><button class="supprimer" onclick="deleteCode('{{orderNum}}')">Supprimer</button></TD><TD><button class="modifier" onclick="modify()">Modifier</button></TD></TR>
            </tbody>
            {{/records}}

            </TABLE>
            <p>
            
           </p>
        <button class="ajouter" onclick="window.location='AjoutCommande.jsp'">Ajouter une commande</button>
        </script>

        <script id="selectTemplate" type="text/template">
            {{! Pour chaque état dans le tableau}}
            {{#records}}
            {{! Une option dans le select }}
            {{! le point représente la valeur courante du tableau }}
            <OPTION VALUE="{{.}}">{{.}}</OPTION>
            {{/records}}
        </script>
            
    </body>
</html>
