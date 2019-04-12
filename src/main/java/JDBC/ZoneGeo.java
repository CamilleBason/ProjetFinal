/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package JDBC;
//classe pour afficher les CA par villes
/**
 *
 * @author crouvera
 */
public class ZoneGeo {
    private String ville;
    private float achat;

	
	//private String formattedRate;

	public ZoneGeo(String ville, float achat) {
		this.ville = ville;
		this.achat = achat;
		//this.formattedRate = String.format("%05.2f %%", rate);
	}


	
	public String getVille() {
		return ville;
	}

public float getAchat() {
		return achat;
	}


}



