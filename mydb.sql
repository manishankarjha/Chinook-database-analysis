/*Analysing the CHINOOK music store database to answer various questions on sales, customer choices, best tracks etc.
We have solved a total of 24 questions from basic to conventional questions and also found out some useful queries*/


/*1 What is the total number of Tracks in each playlist?*/

SELECT p.name AS playlist_name, COUNT(trackid) AS no_of_tracks
FROM playlist p
JOIN playlisttrack pt ON p.playlistid = pt.playlistid
GROUP BY p.name;

/*2 Which sales agent sales the most in the year 2010?*/

SELECT e.employeeid, e.firstname, e.lastname, SUM(i.total) AS total_sales
FROM employee e
JOIN customer c ON e.employeeid = c.supportrepid
JOIN invoice i ON c.customerid = i.customerid
WHERE EXTRACT(YEAR FROM i.invoicedate) = 2010
GROUP BY e.employeeid
ORDER BY total_sales DESC;

/*3 What is the Maximum number of Track sold by Genre?*/

SELECT g.name AS genre, COUNT(il.trackid) AS no_of_tracks
FROM invoiceline il
JOIN track t ON il.trackid = t.trackid
JOIN genre g ON t.genreid = g.genreid
GROUP BY g.name
ORDER BY no_of_tracks DESC;


/*4 Count how many songs base on genre does customer 12 bought ?*/

SELECT g.name AS genre, COUNT(*)  
FROM invoice i
JOIN invoiceline il ON i.invoiceid = il.invoiceid
JOIN track t ON il.trackid = t.trackid
JOIN genre g ON t.genreid = g.genreid
WHERE i.customerid = 12
GROUP BY g.name
ORDER BY g.name;

/*5 How much did customer 13 spent across genres?*/

SELECT g.name AS genre, SUM(il.unitprice) AS total_spent
FROM invoice i
JOIN invoiceline il ON i.invoiceid = il.invoiceid
JOIN track t ON il.trackid = t.trackid
JOIN genre g ON t.genreid = g.genreid
WHERE customerid = 13
GROUP BY 1
ORDER BY 2;

/*6 How much did each customers spent per genre?*/

SELECT c.customerid, c.firstname, c.lastname, g.name AS genre, SUM(il.unitprice) AS total_spent
FROM customer c
JOIN invoice i ON c.customerid = i.customerid
JOIN invoiceline il ON i.invoiceid = il.invoiceid
JOIN track t ON il.trackid = t.trackid
JOIN genre g ON t.genreid = g.genreid
GROUP BY 1,2,3,4
ORDER BY 1,5;

/*7 How much was spent over all on each genre?*/

SELECT g.name AS genre, SUM(il.unitprice) AS total_spent
FROM track t
JOIN genre g ON t.genreid = g.genreid
JOIN invoiceline il ON il.trackid = t.trackid
GROUP BY 1
ORDER BY 2 DESC;

/*8 How much did Americans spent total?*/

SELECT c.customerid, c.firstname || ' ' || c.lastname AS customer_name, SUM(i.total) AS total_spent
FROM customer c
JOIN invoice i ON c.customerid = i.customerid
WHERE billingcountry = 'USA'
GROUP BY c.customerid
ORDER BY 3 DESC;

/*9 How many users per country?*/

SELECT country, COUNT(customerid) 
FROM customer
GROUP BY country
ORDER BY 2 DESC;

/*10 How much did users spent total per country?*/

SELECT country, c.firstname || ' ' || c.lastname AS customer_name, SUM(i.total) AS total_spent
FROM customer c
JOIN invoice i ON c.customerid = i.customerid
GROUP BY 1,2
ORDER BY 3 DESC;

/*11 How many songs per genre the music store has?*/

SELECT g.name AS genre, COUNT(*)
FROM track t
JOIN genre g ON t.genreid = g.genreid
GROUP BY 1
ORDER BY 2 DESC;

/*12 What is the top 10 title song with minimum duration (milliseconds)?*/

--we are finding the song with minimum duration in each album:
SELECT a.albumid, a.title, MIN(t.milliseconds) AS min_duration_of_song_in_album
FROM album a
JOIN track t ON a.albumid = t.albumid
GROUP BY 1,2
ORDER BY 3
LIMIT 10;

--this minimum duration could be possessed by a single song or more than 1 songs in the album, so lets find track name also
WITH cte AS (
SELECT a.albumid, a.title, MIN(t.milliseconds) AS min_duration_of_song_in_album
FROM album a
JOIN track t ON a.albumid = t.albumid
GROUP BY 1,2
ORDER BY 3 )

SELECT cte.* , t.name
FROM cte
JOIN track t ON cte.min_duration_of_song_in_album = t.milliseconds
GROUP BY cte.title, cte.albumid, cte.min_duration_of_song_in_album, t.name
ORDER BY albumid;

--===================================================================================--

--===================================================================================--



--Conventional questions: From easy(E) to intermediate(I) to hard(H):

/* E 1: Which countries have the most Invoices?*/

SELECT billingcountry,COUNT(invoiceid) AS no_of_invoices
FROM invoice
GROUP BY billingcountry
ORDER BY no_of_invoices DESC;

/* E 2: Which city has the best customers? 
We would like to throw a promotional Music Festival in the city we made the most money. 
Write a query that returns the 1 city that has the highest sum of invoice totals. 
Return both the city name and the sum of all invoice totals.*/

SELECT billingcity,SUM(total) AS InvoiceTotal
FROM invoice
GROUP BY billingcity
ORDER BY InvoiceTotal DESC
LIMIT 1;

/* E 3: Who is the best customer?
The customer who has spent the most money will be declared the best customer. 
Build a query that returns the person who has spent the most money. 
Invoice, InvoiceLine, and Customer tables to retrieve this information*/

SELECT c.customerid, c.firstname, c.lastname, SUM(i.total) AS Money_Spent
FROM customer c
JOIN invoice i
ON c.customerid = i.customerid
GROUP BY c.customerid
ORDER BY Money_Spent DESC
LIMIT 1;



/*I 1:
Use your query to return the email, first name, last name, and Genre of all Rock Music listeners.
Return your list ordered alphabetically by email address starting with A.*/

SELECT  DISTINCT c.email, c.firstname, c.lastname, g.name AS genre_name
FROM customer c
JOIN invoice i ON c.customerid = i.customerid
JOIN invoiceline il ON i.invoiceid = il.invoiceid
JOIN track t ON il.trackid = t.trackid
JOIN genre g ON t.genreid = g.genreid
WHERE g.name = 'Rock'
ORDER BY email;

--Solution 2:

SELECT DISTINCT email, firstname, lastname
FROM customer c
JOIN invoice i ON c.customerid = i.customerid
JOIN invoiceline il ON i.invoiceid = il.invoiceid
WHERE il.trackid IN (SELECT trackid FROM track
                  	 JOIN genre ON track.genreid = genre.genreid
                  	 WHERE genre.name LIKE 'Rock')
ORDER BY email;


/*I 2 : How many customers are in each genre ?*/

SELECT g.name AS genre_name, COUNT(DISTINCT c.email) AS no_of_customers
FROM customer c
JOIN invoice i ON c.customerid = i.customerid
JOIN invoiceline il ON i.invoiceid = il.invoiceid
JOIN track t ON il.trackid = t.trackid
JOIN genre g ON t.genreid = g.genreid
GROUP BY genre_name
ORDER BY no_of_customers DESC;


/*I 3: Who is writing the rock music?
Now that we know that our customers love rock music, we can decide which musicians to invite to play at the concert.
Let's invite the artists who have written the most rock music in our dataset. 
Write a query that returns the Artist name and total track count of the top 10 rock bands.*/

SELECT a.name AS artist_name, COUNT(a.name) AS track_count
FROM artist a
JOIN album al ON a.artistid = al.artistid
JOIN track t ON al.albumid = t.albumid
JOIN genre g ON t.genreid = g.genreid
WHERE g.name LIKE 'Rock'
GROUP BY a.name
ORDER BY track_count DESC
LIMIT 10;


/*I 4:
First, find which artist has earned the most according to the InvoiceLines?
Now use this artist to find which customer spent the most on this artist.
For this query, you will need to use the Invoice, InvoiceLine, Track, Customer, Album, and Artist tables.
Notice, this one is tricky because the Total spent in the Invoice table might not be on a single product, 
so you need to use the InvoiceLine table to find out how many of each product was purchased, 
and then multiply this by the price for each artist.*/

--best selling artist:

SELECT a.artistid, a.name, SUM(il.unitprice * il.quantity) AS total_sales
FROM artist a
JOIN album al ON a.artistid = al.artistid
JOIN track t ON al.albumid = t.albumid
JOIN invoiceline il ON t.trackid = il.trackid
GROUP BY a.artistid
ORDER BY total_sales DESC
LIMIT 1;


--customer who spends most on this artist:

WITH best_selling_artist AS 
(SELECT a.artistid, a.name, SUM(il.unitprice * il.quantity) AS total_sales
FROM artist a
JOIN album al ON a.artistid = al.artistid
JOIN track t ON al.albumid = t.albumid
JOIN invoiceline il ON t.trackid = il.trackid
GROUP BY a.artistid
ORDER BY total_sales DESC
LIMIT 1)

SELECT c.customerid, c.firstname, c.lastname, SUM(il.unitprice * il.quantity) AS total_spent, bsa.name AS artist_name
FROM customer c
JOIN invoice i ON c.customerid = i.customerid
JOIN invoiceline il ON i.invoiceid = il.invoiceid
JOIN track t ON il.trackid = t.trackid
JOIN album al ON t.albumid = al.albumid
JOIN best_selling_artist bsa ON al.artistid = bsa.artistid
GROUP BY c.customerid, artist_name
ORDER BY total_spent DESC;



/*H 1:
We want to find out the most popular music Genre for each country. 
We determine the most popular genre as the genre with the highest amount of purchases. 
Write a query that returns each country along with the top Genre. 
For countries where the maximum number of purchases is shared return all Genres.*/

WITH mycte AS 
(SELECT i.billingcountry AS country, g.name AS genre, COUNT(il.quantity) AS no_of_purchase,
RANK() OVER (PARTITION BY i.billingcountry ORDER BY COUNT(il.quantity) DESC)
FROM invoice i
JOIN invoiceline il ON i.invoiceid = il.invoiceid
JOIN track t ON il.trackid = t.trackid
JOIN genre g ON t.genreid = g.genreid
GROUP BY 1,2
ORDER BY 1, 3 DESC)

SELECT country, genre, no_of_purchase FROM mycte 
WHERE rank=1;


--2nd Solution:

--firstly calculating maximum purchase of genre for each country, then using this maximum value 
WITH sales AS
(SELECT billingcountry, g.name AS genre, COUNT(*) AS purchase_per_genre
FROM invoice i
JOIN invoiceline il ON i.invoiceid = il.invoiceid
JOIN track t ON il.trackid = t.trackid
JOIN genre g ON t.genreid = g.genreid
GROUP BY 1,2
ORDER BY 1, 3 DESC)

SELECT MAX(purchase_per_genre) AS maximum, billingcountry
FROM sales
GROUP BY 2;

--The table got from above query is named "max_genre" below & gives the maximum no of purchase of any genre for a country 
--After that we compare 'purchase_per_genre' from "sales" cte table & find the most popular genre


WITH sales AS
(SELECT billingcountry, g.name AS genre, COUNT(*) AS purchase_per_genre
FROM invoice i
JOIN invoiceline il ON i.invoiceid = il.invoiceid
JOIN track t ON il.trackid = t.trackid
JOIN genre g ON t.genreid = g.genreid
GROUP BY 1,2
ORDER BY 1, 3 DESC),

max_genre AS
(SELECT MAX(purchase_per_genre) AS maximum, billingcountry
FROM sales
GROUP BY 2)

SELECT sales.*
FROM sales
JOIN max_genre ON sales.billingcountry = max_genre.billingcountry
WHERE sales.purchase_per_genre = max_genre.maximum;


--Similarly we can do by considering most popular genre as genre with maximum price of purchase 

WITH mycte AS 
(SELECT i.billingcountry AS country, g.name AS genre, SUM(il.unitprice * il.quantity) AS price_of_purchase,
RANK() OVER (PARTITION BY i.billingcountry ORDER BY SUM(il.unitprice * il.quantity) DESC)
FROM invoice i
JOIN invoiceline il ON i.invoiceid = il.invoiceid
JOIN track t ON il.trackid = t.trackid
JOIN genre g ON t.genreid = g.genreid
GROUP BY 1,2
ORDER BY 1, 3 DESC)

SELECT * FROM mycte 
WHERE rank=1;



/*H 2:
Return all the track names that have a song length longer than the average song length. 
Though you could perform this with two queries. 
Imagine you wanted your query to update based on when new data is put in the database. 
Therefore, you do not want to hard code the average into your query. You only need the Track table to complete this query.
Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first.*/

SELECT name, milliseconds FROM track
WHERE milliseconds > (SELECT AVG(milliseconds) FROM track)
ORDER BY milliseconds DESC;


/*H 3:
Write a query that determines the customer that has spent the most on music for each country. 
Write a query that returns the country along with the top customer and how much they spent. 
For countries where the top amount spent is shared, provide all customers who spent this amount.
You should only need to use the Customer and Invoice tables.*/

WITH money_spent_by_customers AS (
SELECT country, c.customerid, firstname, lastname, SUM(total) AS money_spent,
RANK() OVER(PARTITION BY country ORDER BY SUM(total) DESC)
FROM customer c
JOIN invoice i ON c.customerid = i.customerid
GROUP BY 1,2
ORDER BY 1, 5 DESC )

SELECT * FROM money_spent_by_customers
WHERE rank = 1;


--Solution 2: firstly calculating maximum money spent (by a customer) in each country, then using this maximum value 

WITH money_spent_by_customers AS (
SELECT country, c.customerid, firstname, lastname, SUM(total) AS money_spent
FROM customer c
JOIN invoice i ON c.customerid = i.customerid
GROUP BY 1,2
ORDER BY 1, 5 DESC)

SELECT country, MAX(money_spent) as maximum
FROM money_spent_by_customers
GROUP BY 1;

--The table got from above query is named "max_spent" below & gives the maximum money spent by a customer of each country 
--After that we compare 'money_spent' from "money_spent_by_customers" cte table & find who spent that much money

WITH money_spent_by_customers AS (
SELECT country, c.customerid, firstname, lastname, SUM(total) AS money_spent
FROM customer c
JOIN invoice i ON c.customerid = i.customerid
GROUP BY 1,2
ORDER BY 1, 5 DESC),

max_spent AS 
(SELECT country, MAX(money_spent) as maximum
FROM money_spent_by_customers
GROUP BY 1)

SELECT max_spent.country, customerid, firstname, lastname, money_spent
FROM money_spent_by_customers
JOIN max_spent ON money_spent_by_customers.country = max_spent.country
WHERE money_spent_by_customers.money_spent = max_spent.maximum;


--====================================================================================--

--====================================================================================--


--Some Useful queries:


/* Query 1 - Used to get the unit sales per genre and percentage of sale. */

WITH sub AS 
(SELECT g.name AS genre, COUNT(*) AS units_sold
FROM invoiceline i
JOIN track t ON i.trackid = t.trackid
JOIN genre g ON t.genreid = g.genreid
GROUP BY g.name 
ORDER BY units_sold DESC) 

SELECT sub.*, ROUND (units_sold * 100 / (SELECT SUM(units_sold) FROM sub) , 2)
FROM sub;

/*Note: units_sold comes out as of 'bigint' type, and its SUM will be of 'numeric' type. We know that for integral types, 
division truncates the result towards zero. So when we divide bigint by numeric, it will give us the numeric (desired) result

	5.0 / 2    ->  2.5000000000000000
	5 / 2    ->  2
	(-5) / 2   ->  -2                                                                                                   */


--Solution 2:

SELECT *, 
(SELECT ROUND( ROUND( (units_sold * 100), 2 ) / SUM(quantity) , 2 ) FROM invoiceline) AS percentage
FROM 
(SELECT g.name AS genre, COUNT(*) AS units_sold
FROM track t
JOIN genre g ON t.genreid = g.genreid
JOIN invoiceline il ON il.trackid = t.trackid
GROUP BY 1
ORDER BY 2 DESC) sub;

/*Note: "quantity" in invoiceline is of 'integer' type and its SUM will be of 'bigint' type, and since (units_sold * 100) is also 
of bigint type; when we divide bigint by bigint, it will give us the bigint result which is not desired. So if we round off the 
(units_sold * 100) part, it will make that part numeric & we would now be dividing numeric by bigint, so we will get the desired
result. We could also use "CAST( (units_sold * 100) as numeric )" and that too will give the same result as using 
"ROUND( (units_sold * 100) , 2 )" .The motto is to have atleast one of the values as numeric, float or decimal while dividing 
as dividing both integers will give an integer result and for values like 5/2, its not worth it if our focus is not on quotient
but on the final result of division.
*/



/* Query 2 - Used to get the aggregated table of countries with one customers grouped under 'Other' as country name, 
total number of customers, total number of orders, total value of orders, average value of orders.
Countries grouped in others are excluded in the analysis */

SELECT c.country, COUNT(DISTINCT c.customerid) AS no_of_customers, COUNT(i.invoiceid) AS no_of_orders, 
       SUM(i.total) AS value_of_orders, ROUND((SUM(i.total) / COUNT(i.invoiceid)), 2) AS avg_value_of_orders
FROM customer c
JOIN invoice i ON c.customerid = i.customerid
GROUP BY c.country
HAVING COUNT(DISTINCT c.customerid) != 1
ORDER BY value_of_orders DESC;


--Solution 2 -> In above solution we got the correct result but we haven't done any facility to mark countries with 1 customers
--as 'Other'. So we will do it below: 

WITH all_country_stats AS 
(SELECT c.country country_name, SUM(i.total) total_order, ROUND(AVG(i.total), 2) avg_order, COUNT(invoiceid) no_of_orders,
  COUNT(DISTINCT c.customerid) no_of_customers
FROM invoice i
JOIN customer c ON c.customerid = i.customerid
GROUP BY 1),

grouped_country AS 
(SELECT
  CASE
    WHEN no_of_customers = 1 THEN 'Other'
    ELSE country_name
  END AS country_type,
  *
FROM all_country_stats)

SELECT DISTINCT(country_type), SUM(no_of_customers) no_of_customers, SUM(no_of_orders) no_of_orders,
       SUM(total_order) total_value_order, ROUND(AVG(avg_order), 2) avg_order
FROM grouped_country
WHERE NOT country_type = 'Other'
GROUP BY 1
ORDER BY 3 DESC;



/* Query 3 - Used to get the percentage of sale per media type */

SELECT *,
(SELECT ROUND( CAST(sale*100 AS numeric) / SUM(quantity), 2) FROM invoiceline) AS percentage
FROM 
(SELECT m.name AS media_type, COUNT(il.quantity) AS sale 
FROM invoiceline il
JOIN track t ON il.trackid = t.trackid
JOIN mediatype m ON t.mediatypeid = m.mediatypeid
GROUP BY media_type
ORDER BY sale DESC) sub;

--Solution 2:

WITH sub AS (  SELECT m.name AS media_type, COUNT(il.quantity) AS sale 
			   FROM invoiceline il
			   JOIN track t ON il.trackid = t.trackid
			   JOIN mediatype m ON t.mediatypeid = m.mediatypeid
			   GROUP BY media_type
			   ORDER BY sale DESC  )
			 
SELECT *, ROUND(sale*100 / (SELECT SUM(sale) FROM sub), 2) AS percentage
FROM sub;



/* Query 4 - Used to get all sales made by the sales agent*/

--To get elaborate individual sales figure by agents:

SELECT i.invoicedate,
  (CASE
    WHEN e.employeeid = '3' THEN i.total
    ELSE NULL
  END) AS "Jane Peacock",
  
  (CASE
    WHEN e.employeeid = '4' THEN i.total
    ELSE NULL
  END) AS "Margaret Park",
  
  (CASE
    WHEN e.employeeid = '5' THEN i.total
    ELSE NULL
  END) AS "Steve Johnson"
  
FROM employee e
JOIN customer c ON c.supportrepid = e.employeeid
JOIN invoice i ON i.customerid = c.customerid;



/* Query 5 - Used to get which agent has the most sales */

SELECT e.employeeid, e.firstname|| ' ' ||e.lastname AS employee_name, e.title, 
       SUM(i.total) AS total_sales, COUNT(i.invoiceid) AS no_of_sale
FROM customer c
JOIN employee e ON c.supportrepid = e.employeeid
JOIN invoice i ON c.customerid = i.customerid
GROUP BY 1
ORDER BY 4 DESC;

--================================================================================--