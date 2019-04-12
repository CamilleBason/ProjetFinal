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
public class Categorie {
  

	private String discountCode;

	private float rate;
	
	//private String formattedRate;

	public Categorie(String code, float rate) {
		this.discountCode = code;
		this.rate = rate;
		//this.formattedRate = String.format("%05.2f %%", rate);
	}


	public String getDiscountCode() {
		return discountCode;
	}

	public float getRate() {
		return rate;
	}
	
	//public String getFormatedRate() {
	//	return formattedRate;
	//}

}

