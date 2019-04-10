/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

$(document).ready(// Exécuté à la fin du chargement de la page
        function () {
            fillIDSelector();
            fillTransportSelector();
        }
);

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
                },
        error: showError
    });
    return false;
    }
function fillIDSelector() {
    // On fait un appel AJAX pour chercher les états existants
    $.ajax({
        url: "AddIdProducts",
        dataType: "json",
        error: showError,
        success: // La fonction qui traite les résultats
                    function (result) {
                        // Le code source du template est dans la page
                        var template = $('#selectTemplate').html();
                        // On combine le template avec le résultat de la requête
                        var processedTemplate = Mustache.to_html(template, result);
                        // On affiche la liste des options dans le select
                        $('#ID').html(processedTemplate);
                        }
                });
    }
    
    function fillTransportSelector() {
    // On fait un appel AJAX pour chercher les états existants
    $.ajax({
        url: "AddNameManufacturer",
        dataType: "json",
        error: showError,
        success: // La fonction qui traite les résultats
                    function (result) {
                        // Le code source du template est dans la page
                        var template = $('#selectTemplate2').html();
                        // On combine le template avec le résultat de la requête
                        var processedTemplate = Mustache.to_html(template, result);
                        // On affiche la liste des options dans le select
                        $('#Transport').html(processedTemplate);
                        }
                });
    }


// Fonction qui traite les erreurs de la requête
function showError(xhr, status, message) {
	alert("Erreur: " + status + " : " + message);
}