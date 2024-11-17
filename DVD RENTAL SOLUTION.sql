/*This query shows the top 10 customers with Eleanor Hunt 
spending 211.55./*

---1)TOP CUSTOMER SPENDING
SELECT CONCAT(c.first_name,' ', c.last_name) AS full_name, c.email, SUM(p.amount) as total_spending,
COUNT(*) as rentals
FROM customer as c
JOIN payment as p  on c.customer_id= p.customer_id
GROUP BY full_name, c.email
ORDER BY total_spending DESC
LIMIT 10

---2)FILM POPULARITY BY CATEGORY
/*The top category of film is travel/*

 WITH rental_count AS ( SELECT i.film_id, count(r.rental_id) as rental
FROM rental as r
JOIN inventory as i ON r.inventory_id =i.inventory_id
GROUP BY i.film_id)
SELECT c.name as category_name, f.title, rc.rental
FROM rental_count as rc
JOIN film_category as fc on rc.film_id= fc.film_id
JOIN category AS c ON fc.category_id = c.category_id 
JOIN film as f ON rc.film_id = f.film_id
ORDER BY rc.rental DESC
LIMIT 5
 
---3)STORE PERFORMANCE
/*Store id 2 is the best performing/*

SELECT s.store_id,a.address, SUM(p.amount) AS total_revenue
FROM payment as p 
JOIN staff as s on p.staff_id = s.staff_id
JOIN address as a on s.address_id = a.address_id
GROUP BY s.store_id, a.address 
ORDER BY total_revenue DESC

___4)CUSTOMER SEGMENTATION

SELECT c.first_name, c.last_name,c.email, SUM(p.amount) AS total_spending,
CASE 
WHEN ntile(3) OVER (ORDER BY SUM(p.amount) DESC) = 1 THEN 'High'
WHEN ntile(3) OVER (ORDER BY SUM(p.amount) DESC) = 2 THEN 'Medium'
WHEN ntile(3) OVER (ORDER BY SUM(p.amount) DESC) = 3 THEN 'Low'
END AS category
FROM customer as c
JOIN payment as p
ON c.customer_id = p.customer_id
GROUP BY c.first_name, c.last_name,c.email
ORDER BY total_spending DESC;





---5)INVENTORY AVAILABILITY AND RENTAL RATE
SELECT f.title, 
COUNT(i.inventory_id) AS total_copy,
COUNT(r.rental_id) AS copies_rented,
(COUNT(r.rental_id)/ COUNT(i.inventory_id *100)) AS rental_ratepercent  
FROM film as f
JOIN inventory as i
ON f.film_id = i.film_id
LEFT JOIN rental as r 
ON i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY rental_ratepercent DESC

 ---6)REVENUE TRENDS BY MONTH
 SELECT EXTRACT('MONTH' FROM r.rental_date) as month,
 EXTRACT('YEAR' FROM r.rental_date) AS year,
 SUM(p.amount) AS total_revenue,
COUNT(r.rental_id) as film_rented
FROM rental as r
LEFT JOIN payment as p
ON r.rental_id =p.rental_id
GROUP BY EXTRACT('MONTH' FROM r.rental_date),
EXTRACT('YEAR' FROM r.rental_date)
ORDER BY year DESC,month DESC

___7)UNIQUE CUSTOMER PER YEAR
SELECT EXTRACT(YEAR FROM r.rental_date) AS year, 
COUNT(DISTINCT r.customer_id) AS unique_customers  
FROM rental AS r
GROUP BY EXTRACT(YEAR FROM r.rental_date) 
ORDER BY year DESC;  
	
	

	





