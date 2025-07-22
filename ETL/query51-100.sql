
--Soru 51: Müşterilerin kiraladıkları filmlerin toplam kiralama süresi ne kadar?
SELECT customer.first_name, customer.last_name, SUM(julianday(rental.return_date) - julianday(rental.rental_date)) AS total_date
FROM customer
JOIN rental ON customer.customer_id = rental.customer_id
GROUP BY customer.first_name, customer.last_name;

--Soru 52: En çok kiralanan türdeki filmler hangileri?
SELECT category.name AS genre, film.title, COUNT(rental.rental_id) AS rental_count
FROM film
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY genre, film.title
ORDER BY rental_count DESC
LIMIT 1;

--Soru 53: En az kiralanan türdeki filmler hangileri?
SELECT category.name AS genre, film.title, COUNT(rental.rental_id) AS rental_count
FROM film
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY genre, film.title
ORDER BY rental_count ASC
LIMIT 1;

--Soru 54: Her müşteri için toplam ödeme miktarını bulun.
SELECT customer.first_name, customer.last_name, SUM(payment.amount) AS total_payment
FROM customer
JOIN rental ON customer.customer_id = rental.customer_id
JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY customer.first_name, customer.last_name;

--Soru 55: Hangi filmler en uzun süre kiralanmış?
SELECT film.title, MAX(julianday(rental.return_date) - julianday(rental.rental_date)) AS max_rental_days
FROM film
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY film.title
ORDER BY max_rental_days DESC;

--Soru 56: Hangi filmler en kısa süre kiralanmış?
SELECT film.title, MIN(julianday(rental.return_date) - julianday(rental.rental_date)) AS min_rental_days
FROM film
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY film.title
ORDER BY min_rental_days ASC;

--Soru 57: Müşterilerin kiraladığı filmler için ortalama ödeme miktarını bulun.
SELECT customer.first_name, customer.last_name, AVG(payment.amount) AS avg_payment
FROM customer
JOIN rental ON customer.customer_id = rental.customer_id
JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY customer.first_name, customer.last_name;

--Soru 58: En çok kiralanan filmlerin ortalama kiralama süresi nedir?
SELECT film.title, AVG(julianday(rental.return_date) - julianday(rental.rental_date)) AS avg_rental_days
FROM film
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY film.title
ORDER BY COUNT(rental.rental_id) DESC
LIMIT 10;

--Soru 59: En az kiralanan filmlerin ortalama kiralama süresi nedir?
SELECT film.title, AVG(julianday(rental.return_date) - julianday(rental.rental_date)) AS avg_rental_days
FROM film
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY film.title
ORDER BY COUNT(rental.rental_id) ASC
LIMIT 10;

--Soru 60: En çok kazanç sağlayan müşterilerin ortalama ödeme miktarı nedir?
SELECT customer.first_name, customer.last_name, AVG(payment.amount) AS avg_payment
FROM customer
JOIN rental ON customer.customer_id = rental.customer_id
JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY customer.first_name, customer.last_name
ORDER BY SUM(payment.amount) DESC
LIMIT 10;

--Soru 61: En az kazanç sağlayan müşterilerin ortalama ödeme miktarı nedir?
SELECT customer.first_name, customer.last_name, AVG(payment.amount) AS avg_payment
FROM customer
JOIN rental ON customer.customer_id = rental.customer_id
JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY customer.first_name, customer.last_name
ORDER BY SUM(payment.amount) ASC
LIMIT 10;

--Soru 62: Mağazalardaki toplam kiralama süresini bulun.
SELECT store.store_id, SUM(julianday(rental.return_date) - julianday(rental.rental_date)) AS total_rental_days
FROM store
JOIN staff ON store.store_id = staff.store_id
JOIN rental ON staff.staff_id = rental.staff_id
GROUP BY store.store_id;

--Soru 63: En uzun süre kiralanan film hangi mağazada kiralanmış?
SELECT store.store_id, film.title, MAX(julianday(rental.return_date) - julianday(rental.rental_date)) AS max_rental_days
FROM store
JOIN staff ON store.store_id = staff.store_id
JOIN rental ON staff.staff_id = rental.staff_id
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
GROUP BY store.store_id, film.title
ORDER BY max_rental_days DESC
LIMIT 1;

--Soru 64: En kısa süre kiralanan film hangi mağazada kiralanmış?
SELECT store.store_id, film.title, MAX(julianday(rental.return_date) - julianday(rental.rental_date)) AS max_rental_days
FROM store
JOIN staff ON store.store_id = staff.store_id
JOIN rental ON staff.staff_id = rental.staff_id
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
GROUP BY store.store_id, film.title
ORDER BY max_rental_days ASC
LIMIT 1;

--Soru 65: Her filmin ortalama kiralama süresi nedir?
SELECT film.title, AVG(julianday(rental.return_date) - julianday(rental.rental_date)) AS AVG_rental_days
FROM film
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY  film.title;

--Soru 66: Hangi filmler en çok kiralanan kategoride?
SELECT category.name AS genre, film.title, COUNT(rental.rental_id) AS rental_count
FROM category
JOIN film_category ON category.category_id = film_category.category_id
JOIN film ON film_category.film_id = film.film_id
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY genre, film.title
ORDER BY rental_count DESC;

--Soru 67: Hangi filmler en az kiralanan kategoride?
SELECT category.name AS genre, film.title, COUNT(rental.rental_id) AS rental_count
FROM category
JOIN film_category ON category.category_id = film_category.category_id
JOIN film ON film_category.film_id = film.film_id
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY genre, film.title
ORDER BY rental_count ASC;

--Soru 68: Hangi mağazalarda en çok film kiralanmış?
SELECT store.store_id, COUNT(rental.rental_id) AS rental_count
FROM store
JOIN staff ON store.store_id = staff.store_id
JOIN rental ON staff.staff_id = rental.staff_id
GROUP BY store.store_id
ORDER BY rental_count DESC;

--Soru 69: Hangi mağazalarda en az film kiralanmış?
SELECT store.store_id, COUNT(rental.rental_id) AS rental_count
FROM store
JOIN staff ON store.store_id = staff.store_id
JOIN rental ON staff.staff_id = rental.staff_id
GROUP BY store.store_id
ORDER BY rental_count ASC;

--Soru 70: Hangi aktörler en çok filmde rol almış?
SELECT actor.first_name, actor.last_name, COUNT(film_actor.film_id) AS film_count
FROM actor
JOIN film_actor ON actor.actor_id = film_actor.actor_id
GROUP BY actor.first_name, actor.last_name
ORDER BY film_count DESC;

--Soru 71: Hangi aktörler en az filmde rol almış?
SELECT actor.first_name, actor.last_name, COUNT(film_actor.film_id) AS film_count
FROM actor
JOIN film_actor ON actor.actor_id = film_actor.actor_id
GROUP BY actor.first_name, actor.last_name
ORDER BY film_count ASC;

--Soru 72: Hangi aktörlerin oynadığı filmler en çok kiralanmış?
SELECT actor.first_name, actor.last_name, COUNT(rental.rental_id) AS rental_count
FROM actor
JOIN film_actor ON actor.actor_id = film_actor.actor_id
JOIN film ON film_actor.film_id = film.film_id
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY actor.first_name, actor.last_name
ORDER BY rental_count DESC;

--Soru 73: Hangi aktörlerin oynadığı filmler en az kiralanmış?
SELECT actor.first_name, actor.last_name, COUNT(rental.rental_id) AS rental_count
FROM actor
JOIN film_actor ON actor.actor_id = film_actor.actor_id
JOIN film ON film_actor.film_id = film.film_id
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY actor.first_name, actor.last_name
ORDER BY rental_count ASC;

--Soru 74: Hangi kategorilerde en fazla aktör oynamış?
SELECT category.name AS genre, COUNT(DISTINCT film_actor.actor_id) AS actor_count
FROM category
JOIN film_category ON category.category_id = film_category.category_id
JOIN film ON film_category.film_id = film.film_id
JOIN film_actor ON film.film_id = film_actor.film_id
GROUP BY genre
ORDER BY actor_count DESC;

--Soru 75: Hangi kategorilerde en az aktör oynamış?
SELECT category.name AS genre, COUNT(DISTINCT film_actor.actor_id) AS actor_count
FROM category
JOIN film_category ON category.category_id = film_category.category_id
JOIN film ON film_category.film_id = film.film_id
JOIN film_actor ON film.film_id = film_actor.film_id
GROUP BY genre
ORDER BY actor_count ASC;

--Soru 76: Hangi kategorilerde oynayan filmler en çok kiralanmış?
SELECT category.name AS genre, COUNT(rental.rental_id) AS rental_count
FROM category
JOIN film_category ON category.category_id = film_category.category_id
JOIN film ON film_category.film_id = film.film_id
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY genre
ORDER BY rental_count DESC;

--Soru 77: Hangi kategorilerde oynayan filmler en az kiralanmış?
SELECT category.name AS genre, COUNT(rental.rental_id) AS rental_count
FROM category
JOIN film_category ON category.category_id = film_category.category_id
JOIN film ON film_category.film_id = film.film_id
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY genre
ORDER BY rental_count ASC;

--Soru 78: En fazla kazanç sağlayan kategoriler hangileri?
SELECT category.name AS genre, COUNT(payment.amount) AS total_revenue
FROM category
JOIN film_category ON category.category_id = film_category.category_id
JOIN film ON film_category.film_id = film.film_id
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY genre
ORDER BY total_revenue DESC;

--Soru 79: En az kazanç sağlayan kategoriler hangileri?
SELECT category.name AS genre, COUNT(payment.amount) AS total_revenue
FROM category
JOIN film_category ON category.category_id = film_category.category_id
JOIN film ON film_category.film_id = film.film_id
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY genre
ORDER BY total_revenue ASC;

--Soru 80: En çok film kiralayan müşterilerin ortalama ödeme miktarı nedir?
SELECT customer.first_name,customer.last_name, AVG(payment.amount) AS avg_payment
FROM customer
JOIN rental ON customer.customer_id = rental.customer_id
JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY customer.first_name, customer.last_name
ORDER BY COUNT(rental.rental_id) DESC;

--Soru 81: En az film kiralayan müşterilerin ortalama ödeme miktarı nedir?
SELECT customer.first_name,customer.last_name, AVG(payment.amount) AS avg_payment
FROM customer
JOIN rental ON customer.customer_id = rental.customer_id
JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY customer.first_name, customer.last_name
ORDER BY COUNT(rental.rental_id) ASC;

--Soru 82: Hangi mağazalarda hangi kategoriler en çok kiralanmış?
SELECT store.store_id, category.name AS genre, COUNT(rental.rental_id) AS rental_count
FROM store
JOIN staff ON store.store_id = staff.store_id
JOIN rental ON staff.staff_id = rental.staff_id
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
GROUP BY store.store_id, genre
ORDER BY rental_count DESC;

--Soru 83: Hangi mağazalarda hangi kategoriler en az kiralanmış?
SELECT store.store_id, category.name AS genre, COUNT(rental.rental_id) AS rental_count
FROM store
JOIN staff ON store.store_id = staff.store_id
JOIN rental ON staff.staff_id = rental.staff_id
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
GROUP BY store.store_id, genre
ORDER BY rental_count ASC;

--Soru 84: En fazla sayıda film kiralayan mağaza hangisidir ve toplam kiralama sayısı nedir?
SELECT store.store_id, COUNT(rental.rental_id) AS total_rentals
FROM store
JOIN staff ON store.store_id = staff.store_id
JOIN rental ON staff.staff_id = rental.staff_id
GROUP BY store.store_id
ORDER BY total_rentals DESC
LIMIT 1;

--Soru 85: En az sayıda film kiralayan mağaza hangisidir ve toplam kiralama sayısı nedir?
SELECT store.store_id, COUNT(rental.rental_id) AS total_rentals
FROM store
JOIN staff ON store.store_id = staff.store_id
JOIN rental ON staff.staff_id = rental.staff_id
GROUP BY store.store_id
ORDER BY total_rentals ASC
LIMIT 1;

--Soru 86: En fazla sayıda kiralama yapan müşteri hangisidir ve toplam kiralama sayısı nedir?
SELECT customer.first_name, customer.last_name, COUNT(rental.rental_id) AS total_rentals
FROM customer
JOIN rental ON customer.customer_id = rental.customer_id
GROUP BY customer.first_name, customer.last_name
ORDER BY total_rentals DESC
LIMIT 1;

--Soru 87: En az sayıda kiralama yapan müşteri hangisidir ve toplam kiralama sayısı nedir?
SELECT customer.first_name, customer.last_name, COUNT(rental.rental_id) AS total_rentals
FROM customer
JOIN rental ON customer.customer_id = rental.customer_id
GROUP BY customer.first_name, customer.last_name
ORDER BY total_rentals ASC
LIMIT 1;

--Soru 88: En fazla sayıda kiralanan film hangisidir ve toplam kiralama sayısı nedir?
SELECT film.title, COUNT(rental.rental_id) AS total_rentals
FROM film
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY film.title
ORDER BY total_rentals DESC
LIMIT 1;

--Soru 89: En az sayıda kiralanan film hangisidir ve toplam kiralama sayısı nedir?
SELECT film.title, COUNT(rental.rental_id) AS total_rentals
FROM film
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY film.title
ORDER BY total_rentals ASC
LIMIT 1;

--Soru 90: En fazla kazanç sağlayan müşteri hangisidir ve toplam kazancı nedir?
SELECT customer.first_name, customer.last_name, SUM(payment.amount) AS total_revenue
FROM customer
JOIN rental ON customer.customer_id = rental.customer_id
JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY customer.first_name, customer.last_name
ORDER BY total_revenue DESC
LIMIT 1;

--Soru 91: En az kazanç sağlayan müşteri hangisidir ve toplam kazancı nedir?
SELECT customer.first_name, customer.last_name, SUM(payment.amount) AS total_revenue
FROM customer
JOIN rental ON customer.customer_id = rental.customer_id
JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY customer.first_name, customer.last_name
ORDER BY total_revenue ASC
LIMIT 1;

--Soru 92: Hangi film, hangi kategoride en çok kazanç sağlamış?
SELECT film.title, category.name AS genre, SUM(payment.amount) AS total_revenue
FROM film
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY film.title, genre
ORDER BY total_revenue DESC
LIMIT 1;

--Soru 93: Hangi film, hangi kategoride en az kazanç sağlamış?
SELECT film.title, category.name AS genre, SUM(payment.amount) AS total_revenue
FROM film
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY film.title, genre
ORDER BY total_revenue ASC
LIMIT 1;

--Soru 94: En fazla kazanç sağlayan mağaza hangisidir ve toplam kazancı nedir?
SELECT store.store_id, SUM(payment.amount) AS total_revenue
FROM store
JOIN staff ON store.store_id = staff.store_id
JOIN rental ON staff.staff_id = rental.staff_id
JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY store.store_id
ORDER BY total_revenue DESC
LIMIT 1;

--Soru 95: En az kazanç sağlayan mağaza hangisidir ve toplam kazancı nedir?
SELECT store.store_id, SUM(payment.amount) AS total_revenue
FROM store
JOIN staff ON store.store_id = staff.store_id
JOIN rental ON staff.staff_id = rental.staff_id
JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY store.store_id
ORDER BY total_revenue ASC
LIMIT 1;

--Soru 96: En fazla sayıda farklı film kiralayan müşteri hangisidir?
SELECT customer.first_name, customer.last_name, COUNT(DISTINCT rental.inventory_id) AS unique_rentals
FROM customer
JOIN rental ON customer.customer_id = rental.customer_id
GROUP BY customer.first_name, customer.last_name
ORDER BY unique_rentals DESC
LIMIT 1;

--Soru 97: En az sayıda farklı film kiralayan müşteri hangisidir?
SELECT customer.first_name, customer.last_name, COUNT(DISTINCT rental.inventory_id) AS unique_rentals
FROM customer
JOIN rental ON customer.customer_id = rental.customer_id
GROUP BY customer.first_name, customer.last_name
ORDER BY unique_rentals ASC
LIMIT 1;

--Soru 98: En fazla sayıda farklı müşteri tarafından kiralanan film hangisidir?
SELECT film.title, COUNT(DISTINCT rental.customer_id) AS unique_customers
FROM film
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY film.title
ORDER BY unique_customers DESC
LIMIT 1;

--Soru 99: En az sayıda farklı müşteri tarafından kiralanan film hangisidir?
SELECT film.title, COUNT(DISTINCT rental.customer_id) AS unique_customers
FROM film
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY film.title
ORDER BY unique_customers ASC
LIMIT 1;

--Soru 100: Hangi mağazada, hangi kategoride en fazla kazanç sağlanmış?
SELECT store.store_id,category.name AS genre, SUM(payment.amount) AS total_revenue
FROM store
JOIN staff ON store.store_id = staff.store_id
JOIN rental ON staff.staff_id = rental.staff_id
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY store.store_id, genre
ORDER BY total_revenue DESC
LIMIT 1;

