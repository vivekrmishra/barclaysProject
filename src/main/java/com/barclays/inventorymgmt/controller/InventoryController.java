package com.barclays.inventorymgmt.controller;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.web.ErrorController;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.util.UriComponentsBuilder;

import com.barclays.inventorymgmt.model.Item;
import com.barclays.inventorymgmt.service.InventoryService;

@RestController
@RequestMapping("/api")
public class InventoryController implements ErrorController{

	public static final Logger logger = LoggerFactory.getLogger(InventoryController.class);
	private static final String PATH = "/error";
	
	@Autowired
	InventoryService inventoryService; 

	// -------------------Retrieve All Users---------------------------------------------

	@RequestMapping(value = "/report/", method = RequestMethod.GET)
	public ResponseEntity<List<Item>> report() {
		List<Item> items = inventoryService.report();
		if (items.isEmpty()) {
			System.out.println("items are empty");
			return new ResponseEntity(HttpStatus.NO_CONTENT);
		}
		System.out.println("items are not empty");
		return new ResponseEntity<List<Item>>(items, HttpStatus.OK);
	}

	// -------------------Create a Item-------------------------------------------

	@RequestMapping(value = "/createItem/", method = RequestMethod.POST)
	public ResponseEntity<?> createUser(@RequestBody Item item, UriComponentsBuilder ucBuilder) {
		logger.info("Creating User : {}", item);

		inventoryService.createItem(item);

		HttpHeaders headers = new HttpHeaders();
		headers.setLocation(ucBuilder.path("/api/item/{name}").buildAndExpand(item.getId()).toUri());
		return new ResponseEntity<String>(headers, HttpStatus.CREATED);
	}	

	// ------------------- Update a User ------------------------------------------------

	@RequestMapping(value = "/updateBuy/{name}/{quantity}", method = RequestMethod.PUT)
	public ResponseEntity<?> updateItem(@PathVariable("name") String name, @PathVariable("quantity") int quantity) {
		logger.info("Updating item with name {}", name);

		Item item = new Item();
        item.setName(name);
        item.setQuantity(quantity);
		inventoryService.updateBuy(item);
		return new ResponseEntity<Item>(item, HttpStatus.OK);
	}
	
	// ------------------- Update a Item ------------------------------------------------

	@RequestMapping(value = "/updateSell/{name}/{quantity}", method = RequestMethod.PUT)
	public ResponseEntity<?> updateSell(@PathVariable("name") String name, @PathVariable("quantity") int quantity) {
		logger.info("Updating item with name {}", name);
		System.out.println("inside update sell quantity = " + quantity);
		
		Item item = new Item();
        item.setName(name);
        item.setQuantity(quantity);
		inventoryService.updateSell(item);
		return new ResponseEntity<Item>(item, HttpStatus.OK);
	}
	
	// ------------------- Update a Item ------------------------------------------------

	@RequestMapping(value = "/updateSellPrice/{name}/{sellPrice}", method = RequestMethod.PUT)
	public ResponseEntity<?> updateSellPrice(@PathVariable("name") String name, @PathVariable("sellPrice") double sellPrice, @RequestBody Item item) {
		System.out.println("sell price = " + sellPrice);
		/*Item item = new Item();
        item.setName(name);
        item.setSellPrice(sellPrice);*/
		inventoryService.updateSellPrice(item);
		return new ResponseEntity<Item>(item, HttpStatus.OK);
	}

	// ------------------- Delete a Item-----------------------------------------

		@RequestMapping(value = "/deleteItem/{name}", method = RequestMethod.DELETE)
		public ResponseEntity<?> deleteUser(@PathVariable("name") String name) {
			logger.info("Fetching & Deleting Item with name {}", name);

			Item item = new Item();
			item.setName(name);
			inventoryService.deleteItem(item);
			return new ResponseEntity<Item>(HttpStatus.NO_CONTENT);
		}
		
	@Override
	public String getErrorPath() {
		// TODO Auto-generated method stub
		return PATH;
	}

}