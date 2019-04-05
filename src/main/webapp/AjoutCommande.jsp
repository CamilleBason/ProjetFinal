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
                <script>
                    /*
                    $(document).ready(// Exécuté à la fin du chargement de la page
                            function () {
                                // On montre la liste des codes
                                //showCodes();
                                //showProducts();
                            }
                    );*/
            
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
                                        //VIDE LE FORMULAIRE
                                        toutEffacer();
                                        var mes = document.getElementById("messageAjout");
                                        mes.innerHTML = result.message;
                                    },
                            error: showError
                        });
                        return false;
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
            <h1>Ajout d'une commande</h1>
            <input id="userID" type="hidden" name="userName" value="${userID}">
                    <!-- Le template qui sert à ajouter une commande -->
                   
            <button class="retour" onclick="window.location='Commandes.jsp'">Voir mes commandes </button>
                
                    <div id="messageAjout" style="color:red"></div>
                <!-- On montre le formulaire de saisie -->
                <h2>Edition d'un bon de commande</h2>
                <form id="codeForm" onsubmit="event.preventDefault();">
                    <fieldset><legend>Saisie d'un bon de commande</legend>
                        Numéro du bon de commande : <input id="code" name="code" type="number" required><br/>
                        Client ID : <input id="taux" name="taux" value="${userID}" readonly="readonly" required><br/>
                        ID du Produit : <select id="prodid" name="prodid" size="1" required>
                            <option>
                                <option value="948933" > Computer tool Kit</option>
                                <option value="958888" > Ultra Spacr</option>
                                <option value="958889" >686 7Ghz Computer </option>
                                <option value="964025" >Jax WS </option>
                                <option value="964026" > JavaEE 6</option>
                                <option value="964027" > Java Application Development</option>
                                <option value="964028" > Netbeans Development Environment</option>
                                <option value="971266" >Network Cable </option>
                                <option value="975789" >Learn Solaris 10 </option>
                                <option value="978493" >Client Server Testing </option>
                                <option value="978494" > Learn Java in 1/2 hours</option>
                                <option value="978495" >Writing Web Service Applications</option>
                                <option value="980001" > Identity Server </option>
                                <option value="980002" > Corporate Expense Survey</option>
                                <option value="980005" > Accounting Application</option>
                                <option value="980025" > 1Ghz Sun Blade Computer</option>
                                <option value="980030" > 10Gb Ram</option>
                                <option value="980031" >Sun Studio C++</option>
                                <option value="980032" >Sound Card  </option>
                                <option value="980122" > Solaris x86 Computer</option>
                                <option value="980500" > Learn NetBeans</option>
                                <option value="980601" > 300Mhz Pentium Computer</option>
                                <option value="984666" >Flat screen Monitor </option>
                                <option value="985510" > 24 inch digital monitor</option>
                                <option value="986420" >Directory Server </option>
                                <option value="986710" >Printer Cable </option>
                                <option value="986712" >512X IDE DVD-ROM </option>
                                <option value="986733" > A1 900 watts Speakers</option>
                                <option value="986734" >Mini Computer Speakers </option>
                                <option value="988765" >104-Key Keyboard </option>
                            </option></select><br/>
                        Quantité : <input id="quantite" name="quantite" type="number" required><br/>
                        Frais de port : <input id="fraisP" name="fraisP" type="number" value="12" required><br/>
                        Date de vente : <input id="dateV" name="dateVente" type="date" required><br/>
                        Date d'expédition : <input id="dateE" name="dateExp" type="date" required><br/>
                        Société de transport : <select id="transport" name="transport" type="text" size="1" required>
                            <option>
                                <option value="Poney Express" > Poney Express</option>
                                <option value="Slow Snail" > Slow Snail</option>
                                <option value="Slow Snail" > Western Fast</option>
                                <option value="Slow Snail" > We deliver</option>
                                <option value="Coastal Freight" > Coastal Freight</option>
                                <option value="Southern Delivery Service" > Southern Delivery Service</option
                                <option value="FR Express" > FR Express</option>
                               </option></select><br/>
                        <input type="submit" id="Ajouter" value="Ajouter" onclick="addCode()">
                        
                    </fieldset>
                </form>

		<form action="<c:url value="/"/>" method="POST"> 
			<input type='submit' name='action' value='Deconnexion'>
		</form>
		
	</body>
</html>