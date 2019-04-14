<%-- 
    Document   : GraphiqueZone
    Created on : 8 avr. 2019, 15:24:02
    Author     : crouvera
--%>

 <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

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
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">


    <script>
        //j'ai utilisée googleChart 
        google.charts.load('current', {'packages': ['corechart', 'bar']});
        google.charts.setOnLoadCallback(drawChart);


        // Fonction qui traite les erreurs de la requête
        function showError(xhr, status, message) {
            alert(JSON.parse(xhr.responseText).message);
        }



        function drawChart(result) {
            $.ajax({
                //on indique l'url pour observer les données que nous avons demandés 
                url: "http://localhost:8080/ProjetFinal/ZoneGeographique",
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
                            //Les colonnes du graphique avec les données 
                                ['CA', result.records[0].ville, result.records[1].ville, result.records[2].ville,result.records[3].ville,result.records[4].ville,result.records[5].ville,result.records[6].ville,result.records[7].ville,result.records[8].ville,result.records[9].ville],
                                [' ', result.records[0].achat, result.records[1].achat, result.records[2].achat,result.records[3].achat,result.records[4].achat,result.records[5].achat,result.records[6].achat,result.records[7].achat,result.records[8].achat,result.records[9].achat]
                                
                            ]);
                            
                            console.log(result.records.length);
                            var options = {
                                chart: {
                                    title: 'Graphique CA',
                                    subtitle: 'CA par zone geographique',
                                }
                            };
                            console.log(result);
                            var chart = new google.charts.Bar(document.getElementById('columnchart_material'));
                            chart.draw(data, google.charts.Bar.convertOptions(options));
                        }
            });



        }

    </script>
</head>
<body>
    <nav class="navbar navbar-expand-md navbar-dark bg-dark fixed-top">
        <div class="ml-3 mr-auto my-2">
            <button class="btn btn-primary" onclick=" window.location = '../PageChoixGraphique.jsp'">Retour à la page d'acceuil adminsitrateur</button>
        </div>
        <div class="ml-auto mr-3 my-2">
            <form action="<c:url value="/"/>" method="POST">
                <button type="submit" class="btn btn-secondary" name="action" value="Deconnexion">Se déconnecter</button>
            </form>
        </div>
    </nav>
    <div class="container" style="padding-top: 70px;">
        <h1>Graphique des CA par zone geographique</h1>
        <div id="codes"></div>

        <div class="row">
            <div class="d-flex col-lg-3">
                <form class=" m-auto" id="dateForm" onsubmit="event.preventDefault();">
                    <div class="form-group">
                        <label for="dateD">Date de début d'étude :</label>
                        <input class="form-control" id="dateD" name="dateD" type="date" required>
                    </div>
                    <div class="form-group">
                        <label for="dateF">Date de fin d'étude :</label>
                        <input class="form-control" id="dateF" name="dateF" type="date" required>
                    </div>
                    
                    <input class="btn btn-primary" type="submit" id="Valider" value="Valider">
                </form>
            </div>
                
            <div class="col-lg-9" id="columnchart_material" style="height: 500px;"></div>
        </div>
    </div>

</body>
</html>