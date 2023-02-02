use sakila;

-- Select the first name, last name, and email address of all the customers who have rented a movie.
select distinct c.first_name, c.last_name, c.email 
from customer c
join rental r on c.customer_id = r.customer_id 
order by c.first_name;


-- What is the average payment made by each customer (display the customer id, customer name (concatenated),
-- and the average payment made).
select c.customer_id, concat(c.first_name, ' ', c.last_name) as customer_name, round(avg(p.amount), 2) as avg_amount_spent 
from customer c
join payment p on c.customer_id = p.customer_id 
group by c.customer_id
order by c.customer_id;


-- Select the name and email address of all the customers who have rented the "Action" movies.
-- Write the query using multiple join statements
select concat(c.first_name, ' ', c.last_name) as customer_name, c.email, ca.name as film_category
from customer c
join rental r on c.customer_id = r.customer_id
join inventory i on r.inventory_id = i.inventory_id
join film f on i.film_id = f.film_id
join film_category fc on f.film_id = fc.film_id
join category ca on fc.category_id = ca.category_id
where ca.name = 'Action'
group by email, customer_name
order by customer_name;


-- Write the query using sub queries with multiple WHERE clause and IN condition
select concat(first_name, ' ', last_name) as customer_name, email
from customer 
where customer_id in (select customer_id from rental
where inventory_id in (select inventory_id from inventory
where film_id in (select film_id from film where film_id in (select film_id from film_category
where category_id = (select category_id from category
where name = 'Action')))))
group by email, customer_name
order by customer_name;
-- The two queries produce the same results


-- Use the case statement to create a new column classifying existing columns as either or high value 
-- transactions based on the amount of payment. If the amount is between 0 and 2, label should be low 
-- and if the amount is between 2 and 4, the label should be medium, and if it is more than 4, then it should be high.
select c.customer_id, concat(c.first_name, ' ', c.last_name) as customer_name, round(avg(p.amount), 2) as avg_amount_spent, 
case when round(avg(p.amount), 2) > 0 and round(avg(p.amount), 2) < 2 then 'low'
	 when round(avg(p.amount), 2) > 2 and round(avg(p.amount), 2) < 4 then 'medium'
	 when round(avg(p.amount), 2) > 4 then 'high'
	 end as transaction_type
from customer c
join payment p on c.customer_id = p.customer_id 
group by c.customer_id
order by c.customer_id;
