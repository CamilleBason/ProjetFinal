<%-- 
    Document   : PageAdminstrateur3
    Created on : 9 avr. 2019, 13:22:48
    Author     : cbason
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Hello World!</h1>
        <form id="dateForm" onsubmit="event.preventDefault();">
        <fieldset><legend>Saisisez vos dates</legend>
        Date de début d'étude : <input id="dateD" name="dateD" type="date" required><br/>
        Date de fin d'étude : <input id="dateF" name="dateF" type="date" required><br/>
        
        <input type="submit" id="Valider" value="Valider" onclick="">
        </fieldset>
        </form>
    </body>
</html>
