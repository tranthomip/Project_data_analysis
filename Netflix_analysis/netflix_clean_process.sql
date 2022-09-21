USE netflix_project
select * from netflix;
/* change type of release_year column */
ALTER TABLE netflix 
ALTER COLUMN release_year int
/* check duplicate in show_id */
select count(*),
		show_id
from netflix
group by show_id
having count(*) >1
-- no duplicates in column show id
/* check distinct value in type column */
select distinct(type) 
from netflix;
-- we have two values Movie and TV

/* check null values in columns */
select sum(case when type is null then 1 else 0 end) as null_type,
		sum(case when title is null then 1 else 0 end) as null_title,
		sum(case when director is null then 1 else 0 end) as null_director,
		sum(case when country is null then 1 else 0 end) as null_country,
		sum(case when date_added is null then 1 else 0 end) as null_date,
		sum(case when release_year is null then 1 else 0 end) as null_year,
		sum(case when rating is null then 1 else 0 end) as null_rating,
		sum(case when duration is null then 1 else 0 end) as null_duration,
		sum(case when listed_in is null then 1 else 0 end) as null_list
from netflix;
-- null director have 2634 null values, null country have 831 null values, null date have 98 null values, null duration have 3 null values
/* the null values in director column is high, so instead of delete them, i will replace null values by not given */
update netflix
set director = 'unknown'
where director is null
/* change null value in country column */
update netflix 
set country = 'unknown'
where country is null
/* change date null value with the mode */
with date_table as (
	select date_added, count(date_added) as count_date
	from netflix
	group by date_added)
	select date_added from date_table
	where count_date in (select max(count_date) from date_table)
/* mode date is 2020 - 01 - 01 */
update netflix
set date_added = '2020-01-01'
where date_added is null
/* because the missing values in duration column are 3, in rating are 4, so we can delete them from table */
delete from netflix where duration is null
delete from netflix where rating is null
/* check null value again */
/* check null values in columns */
select sum(case when type is null then 1 else 0 end) as null_type,
		sum(case when title is null then 1 else 0 end) as null_title,
		sum(case when director is null then 1 else 0 end) as null_director,
		sum(case when country is null then 1 else 0 end) as null_country,
		sum(case when date_added is null then 1 else 0 end) as null_date,
		sum(case when release_year is null then 1 else 0 end) as null_year,
		sum(case when rating is null then 1 else 0 end) as null_rating,
		sum(case when duration is null then 1 else 0 end) as null_duration,
		sum(case when listed_in is null then 1 else 0 end) as null_list
from netflix;
/* we found that some rows of country column have multiple values, but we just need one country per row. therefore, i'm going 
to split the country column and retain the first country by the left */
select country from netflix
SELECT *,
	CASE
         WHEN country LIKE '%, %' THEN LEFT(country, Charindex(',', country) - 1)
         ELSE country
       END as new_country
into cleaned_netflix
FROM netflix 
/* drop two unnecessary columns cast and description */
alter table netflix
drop column cast
alter table netflix
drop column description
/* delete the country column */
alter table cleaned_netflix
drop column country

