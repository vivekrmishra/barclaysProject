# barclaysProject
The solution is with respect to problem 3 Inventory Management. 

Assumptions:

1. The current solution covers the good case scenarios. The code has not been tested for negative cases. While for selling an item, the code checks that quantity of items to be sold should be less than or equals the items available.
2. The code assumes the good case words that user can enter like create, updateBuy, updateSell, report, delete, updateSellPrice and #(for exit).

Design: Below is the system design:

User sends command through cell phone --> System gets the command and calls the Rest API --> Rest API call the DB layer --> manipulation of data happens in stored procedures --> data is maintained in db tables. 

Reason for the architechture:

1. User enter the command through cell phone to add, sell, delete, or fetch items. Rest Service has been created to consume the messages
2. Every command requires the manipulation of data, like if the the item has been sold, number of tables will be updated. The due to heavy beckend usage, decision was taken to do the logic in stored procs. It helps in one time DB conection and all transactions to perfomed in DB layer. 
	
Another alternate to above design can be usage of Spring Transaction Management, or even Hibernate, but above design aims to reduce the interfacing between Java and DB layer. 

3. Tables have been created to maintain the item data in itemdata table, maintain the user activity in activity table and maintain the history of item selling price in item_sellprice_history table. The history table is needed as an item can have multiple selling price at different times. 

Detailed Design:

1. Spring Boot has been used for making the Rest Service, build and deploy as war file. Spring Boot helps in minimizing the config setting and extra files.
 
2. For every user action, the corresponding API has been hosted. Like /report/, /createItem/, /updateSellPrice/, /updateBuy/, /updateSell/, /updateSellPrice/, /deleteItem/. Every api call has individual stored Procedure call. 

3. /CreateItem – creates new item in itemdetails table set item as active
                - create new record in item_sellprice_history table
                - log activity to activity table as success.
                
4. /updateBuy – update the quantity of item in itedetails table
              - log acitivity in activity table as success
 
5. /UpdateSell – checks if the quantity to sell is lees than or equals the available quantity. 
              - If true, 
                - deducts the quantity to available in itemdetails table, 
                - log the activity in activity table as success
             - If false
		          - log the activity in activity table as failure

6. /deleteItem – fetch the item from itemdetails table and mark it as delete
                - log the activity in activity table as success

7. /UpdateSellPrice – get the item id from itemdetails table and add new row to item_sellprice_history table with itemid, sellpriceid   
                      and new sell price
                      - update the itemdetails table with new sell price id

8. /report – grabs the records since last report generation
          - captures the set of rows that were sold
          - get the profit from the items sold. Note the record do maintain the sell price id, so a same item can have diferent sell 
            priceid (that leads to different sell price) and profit is calculated accordingly. 
          - check if any of item has been deleted since last report generation
          - if yes 
             – calculate the value with costprice * quantity left. This amount negates the profit
          - Get the list of active items  
          - send the details list with the net profit to server
