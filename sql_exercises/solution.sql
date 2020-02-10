/*
1- Which one is INCORRECT? (2.5 marks)
    a. SQL is a procedural language
    b. MySQL is an example of relational database management systems
	c. SQL is focused on 'what' rather than 'how'
    d. Data modeler is the person who designs databases

ANSWER:
a
###############################################################################
2- Which one is NOT an example of DML command (data manupulation language)? (2.5 marks)
	a. SELECT command
	b. UPDATE command
	c. CREATE command
	d. INSERT command

ANSWER:
c
DML commadns are SELCET, UPDATE, INSERT, DELETE
###############################################################################
3- Choose the query searching for the names having 's' as the second letter in table_1. (2.5 marks)
	a. SELECT name FROM table_1 WHERE name LIKE '%s%'
	b. SELECT name FROM table_1 WHERE name LIKE '_s%'
	c. SELECT name FROM table_1 WHERE name LIKE '_s_'
	d. SELECT name FROM table_1 WHERE name LIKE '%s_'

ANSWER:
b
c is wrong, because it limits your search to three characters name only.
###############################################################################
4- Which one is CORRECT? (2.5 marks)
	a. Primary key is a unique column that can be NULL in a table
	b. Unique key is the same as primary key
	c. Foreign key is a column that has unique values and used to connect tables
	d. Nono of the above

ANSWER:
d
a: cannot be null
b: Unique key can be null, while primary key cannot
c: Foreign key is not necessarily  unique

*/
###############################################################################
############## REMAINING QUESTIONS ARE ABOUT SAKILA DATABASE ##################

#5- Write a query that returns distinct first name of inactive customers with address_id between 290 and 545.
#(10 marks)

select distinct first_name
from customer
where active=0
and address_id between 290 and 545;

###############################################################################
#6- Write a query that returns the top 10 longest movies, which are not among these ratings: PG, G, NC-17
#(12 marks)

Select title, length, rating
from film
where rating not IN ('PG', 'G', 'NC-17')
order by length desc
limit 10;

#It is better to write this with NOT IN, rather than multiple != conditions
###############################################################################
#7- Considering payments before 2005-08-01, find out customer ids that have total payments more than $100.
#(15 marks)

select customer_id,
sum(amount),
count(payment_id)
from payment
where payment_date < '2005-08-01'
group by customer_id
having sum(amount) > 100;
###############################################################################
/*8- The management is looking for a list of movies that are:
	Either from store id 1 and has been rented more than 17 times,
    OR from store id 2 and has been rented more than 18 times.
	Provide this list of movies (film id, title, and number of rents) in a single query.
    (20 marks)
*/

select film.film_id,
		title,
		count(rental_id)
from film inner join inventory
on film.film_id = inventory.film_id
inner join rental
on inventory.inventory_id = rental.inventory_id
where store_id = 1
group by film.film_id, title
having count(rental_id) > 17
union
select film.film_id,
		title,
		count(rental_id)
from film inner join inventory
on film.film_id = inventory.film_id
inner join rental
on inventory.inventory_id = rental.inventory_id
where store_id = 2
group by film.film_id, title
having count(rental_id) > 18;

###############################################################################
/*9- The management office would like to give a cash bonus to the customers who has purchased more than $200 so far.
However, he wants to make sure that the data is up-to-date.
Write a query for those customers that returns their customer id, and last update of their payments and payments' amount.
(20 marks)
*/

select customer.customer_id,
		payment.last_update,
        amount
from payment inner join customer
on payment.customer_id = customer.customer_id
where customer.customer_id in (select customer.customer_id
from customer inner join payment
on customer.customer_id = payment.customer_id
group  by customer.customer_id
having sum(amount)>200);

#You can write this by join as well

###############################################################################
/*10- The database administrator recently realised that all mising information on rental id in payment table is about rental id 16050.
So we need to do some modifications in database (13 marks in total):

a- Write a query that returns two columns: payment_id, and rental_id filling null values with 16050 (3 marks).

b- Insert a new column to rental table with information below: (5 marks)
(16050, '2005-06-18', 323, 562, '2005-06-25', 1, '2019-12-05')

c- Update and fill the missing values of rental_id column in payment table with correct value 
(Be careful that you will get an error if you want do this before doing part b).
(5 marks)
*/

select payment_id, ifnull( rental_id, 16050)
from payment;

insert into rental
values (16050, '2005-06-18', 323, 562, '2005-06-25', 1, '2019-12-05');

UPDATE rental
SET rental_id = '16050'
WHERE rental_id IS NULL;

/*
to undo your update:
update payment
set rental_id = null
where rental_id = 16050;
*/
