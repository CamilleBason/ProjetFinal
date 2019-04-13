<%@page contentType="text/html" pageEncoding="UTF-8" session="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Projet Connexion</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
    <style>
        body{
            display: flex; /* contexte sur le parent */
            flex-direction: column; /* direction d'affichage verticale */
            justify-content: center; /* alignement vertical */
            min-height: 100vh;
        }

        .login{
            max-width: 400px;
            box-shadow: 0 0 5px 2px var(--primary);
        }
    </style>

</head>
<body>
    <div class='container login p-3 rounded'>
        <h1 class='my-3 text-center'>Bienvenue dans notre application</h1>
        <%--
        La servlet fait : request.setAttribute("errorMessage", "Login/Password incorrect");
        La JSP récupère cette valeur dans ${errorMessage}
        --%>

        <%
            String error = (String) request.getAttribute("errorMessage");
            if (error != null) {
        %>
                <div id="error" class="bg-danger text-light p-2 rounded"><%= error %></div>
        <% } %>

            <form action="<c:url value="/" />" method="POST"> <!-- l'action par défaut est l'URL courant, qui va rappeler la servlet -->
                <div class='form-group'>
                    <p class='form-text'>login :</p> 
                    <input class='form-control' name='loginParam' type ='text' placeholder="e-mail@exemple.com">
                </div>
                <div class='form-group'>
                    <p class='form-text'>password :</p> 
                    <input class='form-control' name='passwordParam' type='password' placeholder='mot de passe'>
                </div>
                <div class='text-center'>
                    <input class='btn btn-primary' type='submit' name='action' value='Connexion'>
                </div>
        </form>
    </div>
</body>
</html>
