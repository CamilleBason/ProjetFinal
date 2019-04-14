<%-- 
    Document   : PageChoixGraphique
    Created on : 3 avr. 2019, 13:27:20
    Author     : cbason
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="shortcut icon" type="image/x-icon" href="image/commande.ico">
    <title>Administrateur</title>
    <!-- On charge jQuery -->

    <script	src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
    <!-- On charge le moteur de template mustache https://mustache.github.io/ -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/mustache.js/0.8.1/mustache.min.js"></script>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">

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
            <h1>Bienvenue <span id="userName">${userName}</span></h1>
            <p>Vous êtes connectés dans l'espace adminsitrateur de l'application.</p>
            <p>Ici vous pouvez consulter des tableaux de bord graphiques qui vous permet de visualiser des statistiques sur les commandes saisies.</p>
            <p> Merci de choisir le graphique que vous voulez consulter. </p>
            <div class="d-flex justify-content-around">
                <button class="btn btn-primary" onclick="window.location = 'View/PageAdministrateur1.jsp'">Chiffre d'affaire par catégorie article</button>
                <button class="btn btn-primary" onclick="window.location = 'View/PageAdministrateur2.jsp'">Chiffre d'affaire par zone géographique</button>
                <button class="btn btn-primary" onclick="window.location = 'View/PageAdminstrateur3.jsp'">Chiffre d'affaire par client</button>
            </div>
        </div>

</body>
</html>
