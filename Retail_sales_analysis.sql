-- SQL Retail Sales Analysis  - P1 

create database sql_project_p2;

---create table 

drop table if exists retail_sales; 
create table retail_sales
(              transactions_id INT PRIMARY KEY,
				sale_date DATE, 	
				sale_time TIME,
				customer_id	INT,
				gender	varchar(15),
				age	INT,
				category varchar(15),
				quantity INT, 
				price_per_unit float,	
				cogs	float,
				total_sale float 
       );

select * from retail_sales;

select 
  count(*) 
from retail_sales;

-- DATA CLEANING 
-- checking for null values 

select * 
from retail_sales
where   transactions_id is null
		or 
		sale_date is null
		or 
		customer_id is null
		or 
		gender is null 
		or 
		sale_time is null 
		or 
		age is null 
		or 
		category is null
		or 
		quantity is null 
		or 
		price_per_unit is null
		or 
		cogs is null 
		or 
		total_sale is null;

--delete null values 

delete from retail_sales 
where age is null or 
				  quantity is null 
				  or price_per_unit is null 
				  or cogs is null 
				  or total_sale is null; 


-- DATA CLEANING 
-- How many sales we have? 

select count(*) as total_sale 
from retail_sales;

--How many customers we have? 

select count(distinct(customer_id)) as unique_cx
from retail_sales;
	  
select distinct category from retail_sales;


---Data Analysis & Business Key Problems and Answers 

--Q1. Write a SQL query to retrive all columnns for sales made on '2022-11-05'

select * from retail_sales 
where sale_date = '2022-11-05'; 


--Q2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and 
--the quantity sold is more than 4 in the month of Nov-2022

select * 
from retail_sales 
where 
	category = 'Clothing'
	and 
	To_CHAR(sale_date, 'YYYY-MM') = '2022-11' 
	and 
	quantity >= 4;

--Q3 Write a SQL query to calculate the total sales (total_sale) for each category.

select category, sum(total_sale) as total_sales,
count(*) as total_orders
from retail_sales 
group by category; 


--Q4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select 
	round(avg(age),2) as average_age
from retail_sales
where category = 'Beauty'

--Q5. Write a SQL query to find all transactions where the total_sale is greater than 1000.

select * from retail_sales 
where total_sale > 1000; 


--Q6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

select 
	category, 
	gender, 
	count(*) as total_transactions
from retail_sales 
group by 1,2
order by 3; 


--Q7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:

select * from (
				select 
						extract(year from sale_date) as year, 
						extract(month from sale_date) as month, 
						avg(total_sale) as average_sales, 
						rank() over(partition by extract(year from sale_date) order by avg(total_sale) desc) as rank 
				from retail_sales
				group by 1,2
				order by 1,2 
				) as t1 
where rank = 1 

--Q8. Write a SQL query to find the top 5 customers based on the highest total sales 

select 
customer_id, sum(total_sale) as total_sales
from retail_sales
group by 1
order by 2 desc
limit 5; 


--Q9. Write a SQL query to find the number of unique customers who purchased items from each category

select 
	  category,
	  count(distinct(customer_id)) as num_of_unique_cx
from retail_sales
group by 1

--Q10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):

select * from retail_sales;

with cte as (
select *,
		case 
			when extract(hours from sale_time) < 12 then 'morning'
			when extract(hours from sale_time) between 12 and 17 then 'Afternoon'
			else 'Evening'
		end as shift 
from retail_sales 
			) 
		
select 
	shift, 
	count(*) as number_of_orders 
from cte 
group by 1 
				 

