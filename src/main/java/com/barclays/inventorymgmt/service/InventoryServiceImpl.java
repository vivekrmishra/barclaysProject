package com.barclays.inventorymgmt.service;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.simple.SimpleJdbcCall;
import org.springframework.stereotype.Service;

import com.barclays.inventorymgmt.model.Item;



@Service("inventoryService")
public class InventoryServiceImpl implements InventoryService{
	
	@Autowired
	private JdbcTemplate jdbcTemplate;

	@Override
	public void createItem(Item item) {
		SimpleJdbcCall spCall = new SimpleJdbcCall(jdbcTemplate).withProcedureName("createItem");
		
		MapSqlParameterSource params = new MapSqlParameterSource();
		params.addValue("itemname", item.getName());
		params.addValue("costprice", item.getCostPrice());
		params.addValue("sellingprice", item.getSellPrice());
		spCall.execute(params);
		
	}

	@Override
	public void updateBuy(Item item) {
		SimpleJdbcCall spCall = new SimpleJdbcCall(jdbcTemplate).withProcedureName("updateBuy");
		
		MapSqlParameterSource params = new MapSqlParameterSource();
		params.addValue("itemname", item.getName());
		params.addValue("quantity", item.getQuantity());
		spCall.execute(params);
		
	}

	@Override
	public void updateSell(Item item) {
		SimpleJdbcCall spCall = new SimpleJdbcCall(jdbcTemplate).withProcedureName("updateSell");
		
		MapSqlParameterSource params = new MapSqlParameterSource();
		params.addValue("itemname", item.getName());
		params.addValue("a_quantity", item.getQuantity());
		spCall.execute(params);
		
	}

	@Override
	public List<Item> report() {
		
		List<Item> itemList = (ArrayList<Item>)jdbcTemplate.query("{call report()}", new Object[]{}, new RowMapper<Item>(){
			
			@Override
			public Item mapRow(ResultSet rs, int rowNum) throws SQLException {
				Item item = new Item();
				item.setProfit(rs.getDouble("profitsinceprevrep"));
				item.setName(rs.getString("itemname"));
				item.setCostprice(rs.getDouble("broughtat"));
				item.setSellPrice(rs.getDouble("sellingprice"));
				item.setQuantity(rs.getInt("quantity"));
				item.setValue(rs.getDouble("value"));
		    	return  item;
			}
		});
		
		System.out.println("size = " + itemList.size());
		return itemList;
	}

	@Override
	public void deleteItem(Item item) {
		SimpleJdbcCall spCall = new SimpleJdbcCall(jdbcTemplate).withProcedureName("deleteitem");
		
		MapSqlParameterSource params = new MapSqlParameterSource();
		params.addValue("itemname", item.getName());
		spCall.execute(params);
		
	}

	@Override
	public void updateSellPrice(Item item) {
		SimpleJdbcCall spCall = new SimpleJdbcCall(jdbcTemplate).withProcedureName("updateSellPrice");
		
		System.out.println("Inside update sell price - " + item.getSellPrice());
		MapSqlParameterSource params = new MapSqlParameterSource();
		params.addValue("itemname", item.getName());
		params.addValue("sellPrice", item.getSellPrice());
		spCall.execute(params);
		
	}
}
