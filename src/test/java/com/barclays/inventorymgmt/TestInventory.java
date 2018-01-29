package com.barclays.inventorymgmt;
 
import java.net.URI;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Scanner;

import com.barclays.inventorymgmt.model.Item;

import org.springframework.web.client.RestTemplate;
 

public class TestInventory {
 
    public static final String REST_SERVICE_URI = "http://localhost/BraclaysInventoryManagement-1.0.0/api";
     
    /* GET */
    @SuppressWarnings("unchecked")
    private static void report(){
        //System.out.println("Testing report-----------");
         
        RestTemplate restTemplate = new RestTemplate();
        List<LinkedHashMap<String, Object>> itemsMap = restTemplate.getForObject(REST_SERVICE_URI+"/report/", List.class);
        double totalValue = 0;
        double profit = 0;
        if(itemsMap!=null){
            System.out.println("Item Name	Bought At	Sold At		AvailableQty	Value");
            for(LinkedHashMap<String, Object> map : itemsMap){
                System.out.println(map.get("name") + "		" + map.get("costPrice") + "		"  + map.get("sellPrice")+ "		" + 
                		map.get("quantity") + "		" + map.get("value"));
                totalValue = totalValue + Double.parseDouble((String) map.get("value"));
                profit = Double.parseDouble((String) map.get("profit"));;
            }
            System.out.println("Total Value      " + totalValue);
            System.out.println("Profit       " + profit);
        }else{
            System.out.println("No report exist----------");
        }
    }
     
    /* POST */
    private static void createItem(String name, double costPrice, double sellPrice) {
        //System.out.println("Testing create Item API----------");
        RestTemplate restTemplate = new RestTemplate();
        Item item = new Item();
        item.setName(name);
        item.setCostprice(costPrice);
        item.setSellPrice(sellPrice);
        
        URI uri = restTemplate.postForLocation(REST_SERVICE_URI+"/createItem/", item, Item.class);
        //System.out.println("Location : "+uri.toASCIIString());
    }
 
    /* PUT */
    private static void updateBuy(String name, int quantity) {
        //System.out.println("Testing update Item API----------");
        RestTemplate restTemplate = new RestTemplate();
        Item item = new Item();
        /*item.setName(name);
        item.setQuantity(quantity);*/
        restTemplate.put(REST_SERVICE_URI+"/updateBuy/" + name + "/" + quantity, item);
        //System.out.println(item);
    }
 
    /* PUT */
    private static void updateSell(String name, int quantity) {
        //System.out.println("Testing update Item API----------");
        RestTemplate restTemplate = new RestTemplate();
        Item item = new Item();
        /*item.setName(name);
        item.setQuantity(quantity);*/
        restTemplate.put(REST_SERVICE_URI+"/updateSell/" + name + "/" + quantity, item);
        //System.out.println(item);
    }
 
    /* PUT */
    private static void updateSellPrice(String name, double sellPrice) {
        //System.out.println("Testing updateSellPrice API----------");
        RestTemplate restTemplate = new RestTemplate();
        Item item = new Item();
        item.setName(name);
        item.setSellPrice(sellPrice);
        restTemplate.put(REST_SERVICE_URI+"/updateSellPrice/" + name + "/" + sellPrice, item);
        //System.out.println(item);
    }

    /* DELETE */
    private static void deleteItem(String name) {
        //System.out.println("Testing delete User API----------");
        RestTemplate restTemplate = new RestTemplate();
        restTemplate.delete(REST_SERVICE_URI+"/deleteItem/" + name);
    }
 
 
 
    public static void main(String args[]){
        
    	//createItem("Book03", 10.5, 13.79);
    	//updateBuy("Book02", 100);
    	//updateSell("Book01", 2);
    	//deleteItem("Book01");
    	//report();
    	//updateSellPrice("Med01", 104.44);
    	Scanner sc=new Scanner(System.in);
    	String line;
    	String strArray[];
    	
    	String name;
    	double costPrice = 0;
    	double sellingPrice = 0;
    	int quantity = 0;

    	while (sc.hasNext()) {
    		line = sc.nextLine();
    		strArray = line.split(" ");
        	if (strArray[0].equals("create")) {
        		name = strArray[1];
        		costPrice = Double.parseDouble(strArray[2]);
        		sellingPrice = Double.parseDouble(strArray[3]);
        		createItem(name, costPrice, sellingPrice);
        	} else if (strArray[0].equals("updateBuy")) {
        		name = strArray[1];
        		quantity = Integer.parseInt(strArray[2]);
        		updateBuy(name, quantity);
        	} else if (strArray[0].equals("updateSell")) {
        		name = strArray[1];
        		quantity = Integer.parseInt(strArray[2]);
        		updateSell(name, quantity);
        	} else if (strArray[0].equals("report")) {
        		report();
        	} else if (strArray[0].equals("delete")) {
        		name = strArray[1];
        		deleteItem(name);
        	} else if (strArray[0].equals("updateSellPrice")) {
        		name = strArray[1];
        		sellingPrice = Double.parseDouble(strArray[2]);
        		updateSellPrice(name, sellingPrice);
        	} else if (strArray[0].equals("#")){
        		System.exit(0);
        	}
    		
    	}
    	
    }
}