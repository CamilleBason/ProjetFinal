/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package JDBC;

/**
 *
 * @author crouvera
 */
public class Client {
    
   private String client;
    private float prix;


	
	//private String formattedRate;

	public Client(String client, float prix) {
		this.client = client;
		this.prix = prix;
            
            
		//this.formattedRate = String.format("%05.2f %%", rate);
	}

	public String getClient() {
		return client;
	}

public float getPrix() {
		return prix;
	}


}