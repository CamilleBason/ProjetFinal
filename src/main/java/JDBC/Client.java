/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package JDBC;
//Création du client pour afficher le graphique des CA par Client
/**
 *
 * @author crouvera
 */
public class Client {
    
   private String client;
   private float prix;

	public Client(String client, float prix) {
		this.client = client;
		this.prix = prix;
	
	}

	public String getClient() {
		return client;
	}

public float getPrix() {
		return prix;
	}


}