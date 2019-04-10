<%-- 
    Document   : PageAdminstrateur3
    Created on : 9 avr. 2019, 13:22:48
    Author     : cbason
--%>


 <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Edition des taux de remise (AJAX)</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <!-- On charge jQuery -->
        <script	src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
        <!-- On charge le moteur de template mustache https://mustache.github.io/ -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/mustache.js/0.8.1/mustache.min.js"></script>
        <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>

        <script>
            google.charts.load('current', {'packages': ['corechart', 'bar']});
            google.charts.setOnLoadCallback(drawChart);



            $(document).ready(// Exécuté à la fin du chargement de la page
                    function () {
                        // On montre la liste des codes
                        showCodes();
                    }
            );

            function showCodes() {
                // On fait un appel AJAX pour chercher les codes

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
                            },
                    error: showError
                });
                return false;
            }

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



            function drawChart(result) {
                $.ajax({
                    url: "http://localhost:8080/ProjetFinal/GraphiqueClient",
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

                             
                                var data = google.visualization.arrayToDataTable([
                                
                                    ['Graphique CA', result.records[0].client, result.records[1].client, result.records[2].client,result.records[3].client,result.records[4].client,result.records[5].client,result.records[6].client,result.records[7].client,result.records[8].client,result.records[9].client,result.records[10].client,result.records[11].client],
                                    ['villes', result.records[0].prix, result.records[1].prix, result.records[2].prix,result.records[3].prix,result.records[4].prix,result.records[5].prix,result.records[6].prix,result.records[7].prix,result.records[8].prix,result.records[9].prix,result.records[10].prix,result.records[11].prix]
                                    //['2015', result.records[0].rate, result.records[1].rate, result.records[2].rate,result.records[3].rate,result.records[4].rate],
                                    //['2016', result.records[0].rate, result.records[1].rate, result.records[2].rate,result.records[3].rate,result.records[4].rate],
                                    //['2017', result.records[0].rate, result.records[1].rate, result.records[2].rate,result.records[3].rate,result.records[4].rate]

                                ]);
                                console.log(result.records[0].discountCode);
                                console.log(result.records.length);
                                var options = {
                                    chart: {
                                        title: 'Company Performance',
                                        subtitle: 'Sales, Expenses, and Profit: 2014-2017',
                                    }
                                };
                                console.log(result);
                                var chart = new google.charts.Bar(document.getElementById('columnchart_material'));
                                chart.draw(data, google.charts.Bar.convertOptions(options));
                            }
                });



            }

        </script>
        <!-- un CSS pour formatter la table -->
        <link rel="stylesheet" type="text/css" href="css/tableformat.css">
    </head>
    <body>

        <!-- On montre le formulaire de saisie -->
        <button class="Retour" onclick=" window.location = '../PageChoixGraphique.jsp'">Retour à la page d'acceuil adminsitrateur</button>
        <h1>Graphique des CA par zone geographique</h1>

         <!-- La zone où les résultats vont s'afficher -->
        <div id="codes"></div>

        <!-- Le template qui sert à formatter la liste des codes -->
        
        <form id="dateForm" onsubmit="event.preventDefault();">
        <fieldset><legend>Saisisez vos dates</legend>
        Date de début d'étude : <input id="dateD" name="dateD" type="date" required><br/>
        Date de fin d'étude : <input id="dateF" name="dateF" type="date" required><br/>
        
        <input type="submit" id="Valider" value="Valider" onclick="">
        </fieldset>
        </form>
            
           
        <div id="columnchart_material" style="width: 800px; height: 500px;"></div>
        
        <form action="<c:url value='/'/>" method="POST"> 
                    <input type='submit' name='action' value='Deconnexion'>
                </form>

        </body>


    </html>
