package com.barclays.inventorymgmt.service;


import java.util.List;

import com.barclays.inventorymgmt.model.Item;

public interface InventoryService {
	
	void createItem(Item item);
	void updateBuy(Item item);
	void updateSell(Item item);
	void deleteItem(Item item);
	List<Item> report();
	void updateSellPrice(Item item);
}
