--Set-1

--Who is the senior most employee based on job title?

SELECT * FROM employee
order by levels desc
limit 1;
-------------------------
--Which countries have the most Invoices?

select count(*) c, billing_country 
from invoice 
group by billing_country order by c desc;
-------------------------
--What are top 3 values of total invoice?

select total from invoice
order by total desc
limit 3;
-------------------------
--Which city has the best customers? 
--We would like to throw a promotional Music Festival in the city we made the most money. 
--Write a query that returns one city that has the highest sum of invoice totals. 
--Return both the city name & sum of all invoice totals

select * from invoice;

select sum(total) invoice_tot, billing_city 
from invoice
group by billing_city 
order by invoice_tot desc;
--------------------------
--Who is the best customer? 
--The customer who has spent the most money will be declared the best customer. 
--Write a query that returns the person who has spent the most money.

select a.customer_id, a.first_name, a.last_name, sum(b.total) total_new
from customer a
join invoice b on a.customer_id = b.customer_id
group by a.customer_id
order by total_new desc limit 1;

--============================
--Set-2
--Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
--Return your list ordered alphabetically by email starting with A

--This is more optimized query.
select email, first_name, Last_name
from customer
join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
where track_id IN(
	select track_id from track
	join genre G on track.genre_id = G.genre_id
	where G.name LIKE 'Rock'
)
GROUP BY customer.email, customer.first_name, customer.last_name
order by email;

--OR we can have this:

SELECT distinct email, first_name, Last_name
from customer
join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
join track on invoice_line.track_id = track.track_id
join genre on track.genre_id = genre.genre_id
where genre.name like 'Rock'
order by email;
--------------------------
--Let's invite the artists who have written the most rock music in our dataset. 
--Write a query that returns the Artist name and total track count of the top 10 rock bands

select artist.artist_id, artist.name, count(artist.artist_id) num_of_songs
from track
join album on album.album_id = track.album_id
join artist on artist.artist_id = album.artist_id
join genre on genre.genre_id = track.genre_id
where genre.name LIKE 'Rock'
GROUP BY artist.artist_id
order by num_of_songs desc
limit 10;
----------------------------
--Return all the track names that have a song length longer than the average song length. 
--Return the Name and Milliseconds for each track. 
--Order by the song length with the longest songs listed first

select name, milliseconds
from track
where milliseconds >(
	select avg(milliseconds) as avg_track_len --this is dynamic here bcz of no specific avg value
	from track
)
order by milliseconds;
--===========================
--Set-3

--Find how much amount spent by each customer on artists? 
--Write a query to return customer name, artist name and total spent

select c.first_name, c.last_name, a.name as artist_name, sum(il.unit_price), i.total
from customer c
JOIN invoice i ON c.customer_id = i.customer_id
JOIN invoice_line il ON i.invoice_id = il.invoice_id
JOIN track t ON il.track_id = t.track_id
JOIN album al ON t.album_id = al.album_id
JOIN artist a ON al.artist_id = a.artist_id
GROUP BY c.customer_id, a.artist_id, i.total
ORDER BY c.last_name, c.first_name DESC;
------------------------------
--We want to find out the most popular music Genre for each country. 
--We determine the most popular genre as the genre with the highest amount of purchases. 
--Write a query that returns each country along with the top Genre.
--For countries where the maximum number of purchases is shared return all Genres

--Doing it using CTE
with popular_genre as
(
	select count(il.quantity) as purchases, c.country, g.name, g.genre_id,
	row_number() over(partition by c.country order by count (il.quantity) desc) as RowNo
	from invoice_line il
	join invoice i on i.invoice_id = il.invoice_id
	join customer c on c.customer_id= i.customer_id
	join track t on t.track_id = il.track_id
	join genre g on g.genre_id = t.genre_id
	group by 2,3,4
	order by 2 asc, 1 desc
)
select * from popular_genre where RowNo <= 1

------------------------------------------
--Write a query that determines the customer that has spent the most on music for each country. 
--Write a query that returns the country along with the top customer and how much they spent. 
--For countries where the top amount spent is shared, provide all customers who spent this amount













