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
public class DiscountCode {
  

	private int discountCode;

	private int rate;
	
	private String formattedRate;

	public DiscountCode(int code, int rate) {
		this.discountCode = code;
		this.rate = rate;
		//this.formattedRate = String.format("%05.2f %%", rate);
	}


	public int getDiscountCode() {
		return discountCode;
	}

	public int getRate() {
		return rate;
	}
	
	public String getFormatedRate() {
		return formattedRate;
	}

}

