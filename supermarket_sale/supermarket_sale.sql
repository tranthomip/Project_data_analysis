/* view all data set */
SELECT * from sales
/* view distinct type of Branch, Customer_type, Payment, gender, product line */
select distinct branch
from sales
-- branch contain A,B,C
select distinct Customer_type
from sales
-- Customer type contain Normal and Member
select distinct payment
from sales
-- type of payment: ewallet, cash and creditcard
select distinct gender
from sales
-- type of gender is male and female
select distinct product_line
from sales 
-- we have four type of product: Fashion accessories, Health and beauty, Electronic accessories, Food and beverages, Sports and travel, Home and lifestyle
/* check range of rating */
select max(rating) as max_rate,
		min(rating) as min_rate
from sales
-- range of rating from 4 to 10
/* check null value in data set */
select sum(case when Branch is null then 1 else 0 end) as null_branch,
		sum(case when City is null then 1 else 0 end) as null_city,
		sum(case when Customer_type is null then 1 else 0 end) as null_customer,
		sum(case when Gender is null then 1 else 0 end) as null_gender,
		sum(case when Product_line is null then 1 else 0 end) as null_product_line,
		sum(case when Unit_price is null then 1 else 0 end) as null_price,
		sum(case when Quantity is null then 1 else 0 end) as null_quantity,
		sum(case when tax_5 is null then 1 else 0 end) as null_tax,
		sum(case when Total is null then 1 else 0 end) as null_total,
		sum(case when Date is null then 1 else 0 end) as null_date,
		sum(case when Time is null then 1 else 0 end) as null_time,
		sum(case when Payment is null then 1 else 0 end) as null_payment,
		sum(case when cogs is null then 1 else 0 end) as null_cogs,
		sum(case when gross_margin_percentage is null then 1 else 0 end) as null_gross_margin,
		sum(case when gross_income is null then 1 else 0 end) as null_gross_income,
		sum(case when Rating is null then 1 else 0 end) as null_rating
from sales
-- there are no null value in this dataset
/* check duplicate */
select Invoice_ID,
		count(*)
from sales
group by Invoice_ID
having count(*) >1
-- there are no duplicate in this data set

/* Create revenue column = unit_price*quantity */
alter table sales
add  revenue as unit_price*quantity
/* which payment more popular */
select payment,
		count(*) 
from sales
group by payment
-- ewallet = 345, cash = 344, credit card = 311. type of payment is same popular
/* total revenue by customer_type */
select customer_type,
		round(sum(revenue), 2) as total_revenue,
		sum(quantity) as total_sale,
		round(sum(gross_income), 2) as total_gross_income
from sales
group by customer_type

--  member create more revenue, sale, gross income than normal

/* which product line create highest revenue, sale, gross_income */
select Product_line,
		round(sum(revenue), 2) as total_revenue,
		sum(quantity) as total_sale,
		round(sum(gross_income), 2) as total_gross_income
from sales
group by product_line
order by round(sum(revenue), 2) desc, round(sum(gross_income), 2) desc, sum(quantity) desc

-- food and beverage generated highest revenue and gross income, but electronic accessories created highest sale

/* revenue, sale, gross income by branch */
select branch,
		round(sum(revenue), 2) as total_revenue,
		sum(quantity) as total_sale,
		round(sum(gross_income), 2) as total_gross_income
from sales
group by branch

-- highest gross income and revenue: branch C, highest sale: branch A
/* Top 10 city create high revenue, sale and gross income */
select city,
		sum(quantity) as total_sale,
		sum(revenue) as total_revenue,
		sum(gross_income) as total_gross_income
from sales
group by city
-- Naypyitaw has highest income and revenue, Yangon has highest sale
/* product_line by female */
with female_total as
(
select product_line,
		gender
 from sales
 where gender = 'female'
 )
 select product_line,
		count(*) as female
from female_total
group by product_line 
-- female will spend more money on fashion accessories, food and beverages

with male_total as
(
select product_line,
		gender
 from sales
 where gender = 'male'
 )
 select product_line,
		count(*) as male
from male_total
group by product_line 

-- health and beauty, electronic accessories are two product_line preferred by male

 /* which product_line have high rating */
 select product_line,
		avg(rating) as avg_rating
from sales
group by product_line
order by avg(rating) desc

-- food and beverage has highest rating
/* find which month have high sale and gross income */
select month(date) as month,
		sum(quantity) as total_sale,
		round(sum(gross_income), 2) as total_gross_income
from sales
group by month(date)
order by 2,3 desc
-- January is the month have highest sale and gross income 
