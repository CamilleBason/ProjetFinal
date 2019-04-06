/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

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



// Fonction qui traite les erreurs de la requête
function showError(xhr, status, message) {
    alert(JSON.parse(xhr.responseText).message);
}
