SELECT * FROM dataanalytics.superstore;

-- super store analysis

-- update column into date format
update superstore set `Ship Date` = str_to_date(`Ship Date`,'%d-%m-%Y');

--  1) sales analysis
			-- a) total sales
					select round(sum(Sales),2) from superstore;
			-- 	b) monthly sales
            
					with temp as
						(select date_format(`Ship Date`,'%Y-%m') as date, round(sum(Sales),2) as total
						from superstore
						group by date order by date)
                    select *, round((sum(total) over(order by date)),2) as roll_total from temp;
					
            -- c) sales by category and sales by region 
						select Region, round(sum(Sales),2) as total 
                        from superstore group by Region;
                        select Category, round(sum(Sales),2) as total 
                        from superstore group by Category;
                        
 -- 2) profit analysis
			-- a) total profit
					select round(sum(Profit),2) from superstore;
			-- 	b) profit margin
					with temp as(select `Product Name`, round(Profit / Sales * 100,2) as profit_margin
                    from superstore order by `Product Name`)
                    select `Product Name`, avg(profit_margin) as avg_margin from temp
                    group by `Product Name` order by avg_margin;
                    
                    select `Product Name`, round(sum(Profit) / sum(Sales) * 100,2) as profit_margin
                    from superstore group by `Product Name`
                    order by profit_margin;
					
            -- c) profit by category  with sub-category 
-- 	3) customer analysis
			-- a) top 10 customer by sales
				select `Customer Name`,`Customer ID`, round(sum(Sales),2) as total_purchase from superstore 
                group by `Customer ID` , `Customer Name`
                order by total_purchase desc limit 10;
                
			-- 	b) top customer by profit
			select `Customer Name`,`Customer ID`, round(sum(Profit),2) as total_profit 
				from superstore 
                group by `Customer ID` , `Customer Name`
                order by total_profit desc limit 10;
            
--  4) order analysis
				-- a) order freq per customer
                select `Customer Name`, count(`Order ID`) as Order_count
				from superstore 
                group by `Customer ID` , `Customer Name`
                order by Order_count desc limit 10;
						
			-- 	b) avg order value per costomer
				 select `Customer Name`, count(`Order ID`) as Order_count,
                 round(avg(Sales),2) as avg_purchase
				from superstore 
                group by `Customer ID` , `Customer Name`
                order by avg_purchase desc limit 10;
            
--  5)product analysis
				-- a) top selling product
                select `Product Name`, `Product ID`, Count(`Product ID`) as avg_profit
					from superstore  group by `Product Name`, `Product ID`
                    order by avg_profit desc limit 10;
                
			-- 	b) most profitable product
				select `Product Name`, `Product ID`, avg(Profit) as avg_profit
					from superstore  group by `Product Name`, `Product ID`
                    order by avg_profit desc limit 10;
				
-- 	6) regional performance