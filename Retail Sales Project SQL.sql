-- SQL Retail Sales Analysis  --

-- create Table--

DROP TABLE IF EXISTS  Retail_Sales;
create Table Retail_Sales (
transactions_id int primary key,
	sale_date	date,
    sale_time	 time,
    customer_id int,retail_sales
	gender VARCHAR(15),
	age int,
	category VARCHAR(15),
	quantity INT,
	price_per_unit FLOAT,
	cogs	FLOAT,
    total_sales FLOAT
);

-- DATA CLEANING --

select count(*) from retail_sales;

select * from retail_sales;

select * from retail_sales
where transactions_id is null
	or sale_date is null
    or sale_time is null 
    or customer_id is null
    or gender is null
    or age is null
    or category is null
    or quantity is null
    or price_per_unit is null
    or cogs is null
    or total_sales is null;
    
delete from retail_sales
where transactions_id is null
	or sale_date is null
    or sale_time is null 
    or customer_id is null
    or gender is null
    or age is null
    or category is null
    or quantity is null
    or price_per_unit is null
    or cogs is null
    or total_sales is null;
    
    -- Data exploration--

-- How many sales we have??--

select count(*) as total_sales from retail_sales;

-- how many unique customer we have?? --

select count(distinct customer_id) as  Total_Customers from retail_sales;

-- how many unique category we have?? --
 
 select distinct category from retail_sales;
 
  -- Data Analysis & Findings --
 
 -- 1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05** --
 -- 2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022** --
 -- 3. **Write a SQL query to calculate the total sales (total_sale) for each category.** --
 -- 4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.** --
 -- 5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.** --
 -- 6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.** --
 -- 7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year** --  	
 -- 8. **Write a SQL query to find the top 5 customers based on the highest total sales ** --	
 -- 9. **Write a SQL query to find the number of unique customers who purchased items from each category.** --	
 -- 10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)** --
  
-- 1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05 --
   
   select * from retail_sales
   where sale_date ='2022-11-05';
   
-- 2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022** --

SELECT
 * 
 FROM retail_sales
where category = 'Clothing'
AND
date_format(sale_date , '%Y-%m') = '2022-11';

-- 3. **Write a SQL query to calculate the total sales (total_sale) for each category.** --

select category,
sum(total_sales) as total_sales,
count(*) as Total_Orders
 from retail_sales
 group by category
;

-- 4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.** -- 

SELECT Round(AVG(age),2) as avg_age 
FROM retail_sales
where category = 'Beauty' ; 

 -- 5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.** --

select * from retail_sales
where total_sales > 1000;

 -- 6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.** --

select category ,gender ,
	count(*) as Total_transaction
from retail_sales 
group by category ,gender 
order by category;


-- 7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year** --

select * from
(select    extract(year from sale_date) as Year,
			extract(month from sale_date) as Month,
			 avg(total_sales) as AVG_total,
	rank() over(partition by extract(year from sale_date) order by avg(total_sales) desc ) as SEGMENT
from retail_sales
 group by 1 , 2
 ) as table1
 where segment = 1;
 


-- 8. **Write a SQL query to find the top 5 customers based on the highest total sales ** --	

select customer_id , sum(total_sales) as Total_sales
	
from retail_sales 
    group by 1 
    order by 2 desc
    limit 5;



 -- 9. **Write a SQL query to find the number of unique customers who purchased items from each category.** --	

select 
	category ,count(distinct customer_id) as Unique_cus from retail_sales
	 group by category;


 -- 10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)** --
 
with NUM_of_shifts
as 
(select * ,
			case
		when extract(hour from sale_time) < 12 then 'Morning'
        when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
        ELSE 'Evening'
        End as SHIFT
      from retail_sales  )
select SHIFT,
count(*) as Total_orders
from NUM_of_shifts
group by shift;

