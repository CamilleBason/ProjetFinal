<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- 
    Document   : PageAdministrateur
    Created on : 26 mars 2019, 14:37:09
    Author     : crouvera
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Graphique CA</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <!-- On charge jQuery -->
        <script	src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
        <!-- On charge le moteur de template mustache https://mustache.github.io/ -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/mustache.js/0.8.1/mustache.min.js"></script>
        <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>

        <script>
            google.charts.load('current', {'packages': ['corechart', 'bar']});
            google.charts.setOnLoadCallback(drawChart);

           function showError(xhr, status, message) {
                alert(JSON.parse(xhr.responseText).message);
            }

            function drawChart(result) {
                $.ajax({
                    //on indique l'url pour observer les données que nous avons demandés 
                    url: "http://localhost:8080/ProjetFinal/allDiscountCodes",
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

                                //J'ai utilisé la google Chart
                                var data = google.visualization.arrayToDataTable([
                                    //J'ai créé le graphique
                                    ['CA', result.records[0].discountCode, result.records[1].discountCode, result.records[2].discountCode, result.records[3].discountCode, result.records[4].discountCode],
                                    [' ', result.records[0].rate, result.records[1].rate, result.records[2].rate, result.records[3].rate, result.records[4].rate]
                                  
                                ]);
                                console.log(result.records[0].discountCode);
                                console.log(result.records.length);
                                var options = {
                                    chart: {
                                        //Les titres pour la description
                                        title: 'Graphique CA',
                                        subtitle: "Le chiffre d'affaire par categorie",
                                    }
                                };
                                console.log(result);
                                var chart = new google.charts.Bar(document.getElementById('columnchart_material'));
                                chart.draw(data, google.charts.Bar.convertOptions(options));
                            }
                });

            }

        </script>
        <link rel="stylesheet" type="text/css" href="css/tableformat.css">
    </head>
    <body>
        <!-- On montre le formulaire de saisie -->
        <button class="Retour" onclick=" window.location = '../PageChoixGraphique.jsp'">Retour à la page d'acceuil adminsitrateur</button>
        <h1>Graphique des CA par catégorie d'article</h1>

       
        <div id="codes"></div>
  <!-- Les dates -->
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
