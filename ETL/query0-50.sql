-- Soru 1: Tüm rental (kiralama) kayıtlarını listele
SELECT * FROM rental;

-- Soru 2: Her filmdeki oyuncuları listele
SELECT film.title, actor.first_name, actor.last_name
FROM film
JOIN film_actor ON film.film_id = film_actor.film_id
JOIN actor ON film_actor.actor_id = actor.actor_id;

-- Soru 3: Her filmde kaç oyuncu oynadı?
SELECT film.title, COUNT(actor.actor_id) AS actor_count
FROM film
JOIN film_actor ON film.film_id = film_actor.film_id
JOIN actor ON film_actor.actor_id = actor.actor_id
GROUP BY film.title;

-- Soru 4: Her oyuncu kaç filmde oynadı?
SELECT actor.first_name, actor.last_name, COUNT(film.film_id) AS movie_count
FROM actor
JOIN film_actor ON actor.actor_id = film_actor.actor_id
JOIN film ON film_actor.film_id = film.film_id
GROUP BY actor.first_name, actor.last_name;

-- Soru 5: Envanterde olmayan filmler var mı ve varsa kaç tane?
SELECT COUNT(*) AS not_in_inventory
FROM film
WHERE film_id NOT IN (SELECT film_id FROM inventory);

-- Soru 6: Kiralanabilir olan her filmin kaç kez kiralandığını ve toplam gelirlerini getirin
SELECT film.title, COUNT(rental.rental_id) AS rental_count, SUM(payment.amount) AS total_revenue
FROM film
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY film.title;

-- Soru 7:  Envanterde olmayan filmlerin kira oranlarını getirin
SELECT title, rental_rate
FROM film
WHERE film_id NOT IN (SELECT film_id FROM inventory);

-- Soru 8: Birden fazla DVD'yi iade etmeyen kaç müşteri var?
SELECT COUNT(DISTINCT customer_id) AS customer_count
FROM rental
WHERE return_date IS NULL
GROUP BY customer_id
HAVING COUNT(rental_id) > 1;

-- Soru 9: Her müşteri kaç film kiraladı?
SELECT customer.first_name, customer.last_name, COUNT(rental.rental_id) AS rental_count
FROM customer
JOIN rental ON customer.customer_id = rental.customer_id
GROUP BY customer.first_name, customer.last_name;

-- Soru 10: Türlerine göre en çok kiralanan filmler ve bunlara ne kadar ödendi?
SELECT category.name AS genre, film.title, COUNT(rental.rental_id) AS rental_count, SUM(payment.amount) AS total_paid
FROM category
JOIN film_category ON category.category_id = film_category.category_id
JOIN film ON film_category.film_id = film.film_id
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY category.name, film.title
ORDER BY rental_count DESC;

--Soru 11: Tür ve Tarihe Göre Kiralama Sayısı ve Gelir
SELECT category.name AS genre, DATE(rental.rental_date) AS rental_date,COUNT(rental.rental_id) AS rental_count, SUM(payment.amount)
FROM category
JOIN film_category ON category.category_id = film_category.category_id
JOIN film ON film_category.film_id = film.film_id
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY genre,rental_date
ORDER BY rental_date;

--Soru 12: Kiralanabilir Filmler İçin Türlerine Göre Her Filmin Kaç Kez Kiralandığı
SELECT category.name AS genre, film.title, COUNT(rental.rental_id) AS rental_count
FROM category
JOIN film_category ON category.category_id = film_category.category_id
JOIN film ON film_category.film_id = film.film_id
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY genre,film.title;

--Soru 13: En çok rafta bekleyen filmler?
SELECT film.title,
       JULIANDAY('now') - JULIANDAY(rental.rental_date) AS days_on_shelf
FROM film
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
WHERE rental.return_date IS NULL
ORDER BY days_on_shelf DESC;

--Soru 14: Geç, Erken ve Zamanında İade Edilen Kiralanmış Filmler
SELECT 
    SUM(CASE WHEN return_date > DATETIME(rental_date, '+' || film.rental_duration || ' days') THEN 1 ELSE 0 END) AS late_returns,
    SUM(CASE WHEN return_date < DATETIME(rental_date, '+' || film.rental_duration || ' days') THEN 1 ELSE 0 END) AS early_returns,
    SUM(CASE WHEN return_date = DATETIME(rental_date, '+' || film.rental_duration || ' days') THEN 1 ELSE 0 END) AS on_time_returns
FROM rental
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id;   

--Soru 15: Hangi müşteri en çok DVD kiralamış?
SELECT customer.first_name,customer.last_name, COUNT(rental.rental_id) AS rental_count
FROM customer
JOIN rental ON customer.customer_id = rental.customer_id
GROUP BY customer.first_name, customer.last_name
ORDER BY rental_count DESC
LIMIT 1;

--Soru 16: En popüler film kategorisi nedir?
SELECT category.name, COUNT(rental.rental_id) AS rental_count
FROM category
JOIN film_category ON category.category_id = film_category.category_id
JOIN film ON film_category.film_id = film.film_id
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY category.name
ORDER BY rental_count DESC;

--Soru 17: Hangi çalışan en çok kiralama işlemi gerçekleştirmiş?
SELECT staff.first_name, staff.last_name,COUNT(rental.rental_id) AS rental_count
FROM staff
JOIN rental ON staff.staff_id = rental.staff_id
GROUP BY staff.first_name,staff.last_name
ORDER BY rental_count DESC
LIMIT 1;

--Soru 18: En çok geliri hangi film getirmiş?
SELECT film.title, SUM(payment.amount) AS total_revenue
FROM film
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY film.title
ORDER BY total_revenue DESC
LIMIT 1;

--Soru 19: Her müşteri için toplam harcama miktarını bulun
SELECT customer.first_name, customer.last_name, SUM(payment.amount) AS total_spent
FROM customer
JOIN rental ON customer.customer_id = rental.customer_id
JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY customer.first_name, customer.last_name;

--Soru 20: Her kategorideki toplam kiralama sayısını ve gelirleri bulun
SELECT category.name, COUNT(rental.rental_id) AS rental_count, SUM(payment.amount) AS total_revenue
FROM category
JOIN film_category ON category.category_id = film_category.category_id
JOIN film ON film_category.film_id = film.film_id
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY category.name;

--Soru 21: En uzun süre kirada kalmış filmleri bulun 
SELECT film.title, MAX(return_date - rental_date) AS max_rental_duration
FROM film
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
WHERE rental.return_date IS NOT NULL
GROUP BY film.title
ORDER BY max_rental_duration DESC
LIMIT 10;

--Soru 22: En az kiralanan 5 film hangileridir?
SELECT film.title, COUNT(rental.rental_id) AS rental_count
FROM film
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY film.title
ORDER BY rental_count ASC
LIMIT 5;

--Soru 23: En fazla kiralanan 5 film hangileridir?
SELECT film.title, COUNT(rental.rental_id) AS rental_count
FROM film
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY film.title
ORDER BY rental_count DESC
LIMIT 5;

--Soru 24: En fazla kazanç sağlayan 5 müşteriyi bulun
SELECT customer.first_name, customer.last_name, SUM(payment.amount) AS total_spent
FROM customer
JOIN rental ON customer.customer_id = rental.customer_id
JOIN payment ON rental.rental_id  = payment.rental_id
GROUP BY customer.first_name, customer.last_name
ORDER BY total_spent DESC
LIMIT 5;

--Soru 25: Her filmin ortalama kiralanma süresini bulun
SELECT film.title,
       AVG(julianday(return_date) - julianday(rental_date)) AS avg_rental_duration
FROM film
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
WHERE rental.return_date IS NOT NULL
GROUP BY film.title;

--Soru 26: Her türde en popüler filmi bulun
SELECT category.name AS genre, film.title, COUNT(rental.rental_id) AS rental_count
FROM category
JOIN film_category ON category.category_id = film_category.category_id
JOIN film ON film_category.film_id  = film.film_id
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY genre,film.title
ORDER BY rental_count DESC
LIMIT 1;

--Soru 27: Her türde en fazla gelir sağlayan filmi bulun
SELECT category.name AS genre, film.title, SUM(payment.amount) AS total_revenue
FROM category
JOIN film_category ON category.category_id = film_category.category_id
JOIN film ON film_category.film_id  = film.film_id
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY genre,film.title
ORDER BY total_revenue DESC
LIMIT 1;

--Soru 28: En çok DVD iade etmeyen müşteriyi bulun
SELECT customer.first_name, customer.last_name, COUNT(rental.rental_id) AS unreturned_count
FROM customer
JOIN rental ON customer.customer_id = rental.customer_id
WHERE rental.return_date IS NULL
GROUP BY customer.first_name,customer.last_name
ORDER BY unreturned_count DESC
LIMIT 1;

--Soru 29: En fazla kiralama yapan 5 çalışanı bulun
SELECT staff.first_name, staff.last_name, COUNT(rental.rental_id) AS rental_count
FROM staff
JOIN rental ON staff.staff_id = rental.staff_id
GROUP BY staff.first_name, staff.last_name
ORDER BY rental_count DESC
LIMIT 5;

--Soru 30: En fazla kiralama yapan 5 müşteri hangi şubeden kiralama yapmış?
SELECT store.store_id, customer.first_name, customer.last_name, COUNT(rental.rental_id) AS rental_count
FROM customer
JOIN rental ON customer.customer_id = rental.customer_id
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN store ON inventory.store_id = store.store_id
GROUP BY store.store_id, customer.first_name, customer.last_name
ORDER BY rental_count DESC
LIMIT 5;

--Soru 31: Her türde en az kiralanan filmi bulun
SELECT category.name AS genre, film.title, COUNT(rental.rental_id) AS rental_count
FROM category
JOIN film_category ON category.category_id = film_category.category_id
JOIN film ON film_category.film_id  = film.film_id
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY genre,film.title
ORDER BY rental_count ASC
LIMIT 1;

--Soru 32: En çok kiralama yapan 5 müşteri hangi şehirde?
SELECT city.city, customer.first_name, customer.last_name, COUNT(rental.rental_id) AS rental_count
FROM customer
JOIN address ON customer.address_id = address.address_id
JOIN city ON address.city_id  = city.city_id
JOIN rental ON customer.customer_id = rental.customer_id
GROUP BY city.city, customer.first_name, customer.last_name
ORDER BY rental_count DESC
LIMIT 5;

--Soru 33: En çok kazanç sağlayan 5 müşteriyi hangi şehirde bulun?
SELECT city.city, customer.first_name, customer.last_name, SUM(payment.amount) AS total_spent
FROM customer
JOIN address ON customer.address_id = address.address_id
JOIN city ON address.city_id  = city.city_id
JOIN rental ON customer.customer_id = rental.customer_id
JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY city.city, customer.first_name, customer.last_name
ORDER BY total_spent DESC
LIMIT 5;

--Soru 34: En çok kiralanan 5 filmi hangi şehirde bulun?
SELECT city.city, film.title, COUNT(rental.rental_id) AS rental_count
FROM city
JOIN address ON city.city_id = address.city_id
JOIN customer ON address.address_id = customer.address_id
JOIN rental ON customer.customer_id = rental.customer_id
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
GROUP BY city.city, film.title
ORDER BY rental_count DESC
LIMIT 5;

--Soru 35: En az kiralanan 5 filmi hangi şehirde bulun?
SELECT city.city, film.title, COUNT(rental.rental_id) AS rental_count
FROM city
JOIN address ON city.city_id = address.city_id
JOIN customer ON address.address_id = customer.address_id
JOIN rental ON customer.customer_id = rental.customer_id
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
GROUP BY city.city, film.title
ORDER BY rental_count ASC
LIMIT 5;

--Soru 36: En çok kazanç sağlayan 5 filmi hangi şehirde bulun?
SELECT city.city, film.title, SUM(payment.amount) AS total_revenue
FROM city
JOIN address ON city.city_id = address.city_id
JOIN customer ON address.address_id = customer.address_id
JOIN rental ON customer.customer_id = rental.customer_id
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY city.city, film.title
ORDER BY total_revenue DESC
LIMIT 5;

--Soru 37: En az kazanç sağlayan 5 filmi hangi şehirde bulun?
SELECT city.city, film.title, SUM(payment.amount) AS total_revenue
FROM city
JOIN address ON city.city_id = address.city_id
JOIN customer ON address.address_id = customer.address_id
JOIN rental ON customer.customer_id = rental.customer_id
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY city.city, film.title
ORDER BY total_revenue ASC
LIMIT 5;

--Soru 38: En fazla kiralama yapan müşteri hangi filmleri kiralamış?
SELECT customer.first_name, customer.last_name, category.name AS genre, COUNT(rental.rental_id) AS rental_count
FROM customer
JOIN rental ON customer.customer_id = rental.customer_id
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
WHERE customer.customer_id =(
    SELECT customer.customer_id
    FROM customer
    JOIN rental ON customer.customer_id = rental.customer_id
    GROUP BY customer.customer_id
    ORDER BY COUNT(rental.rental_id) DESC
    LIMIT 1
)
GROUP BY customer.first_name, customer.last_name, genre;

--Soru 39: En az kiralama yapan müşteri hangi filmleri kiralamış?
SELECT customer.first_name, customer.last_name, category.name AS genre, COUNT(rental.rental_id) AS rental_count
FROM customer
JOIN rental ON customer.customer_id = rental.customer_id
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
WHERE customer.customer_id =(
    SELECT customer.customer_id
    FROM customer
    JOIN rental ON customer.customer_id = rental.customer_id
    GROUP BY customer.customer_id
    ORDER BY COUNT(rental.rental_id) ASC
    LIMIT 1
)
GROUP BY customer.first_name, customer.last_name, genre;

--Soru 40: En çok kazanç sağlayan müşteri hangi filmleri kiralamış?
SELECT customer.first_name, customer.last_name, film.title, SUM(payment.amount) AS total_revenue
FROM customer
JOIN rental ON customer.customer_id = rental.customer_id
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
JOIN payment ON rental.rental_id = payment.rental_id
WHERE customer.customer_id =(
    SELECT customer.customer_id
    FROM customer
    JOIN rental ON customer.customer_id = rental.customer_id
    JOIN payment ON rental.rental_id = payment.rental_id
    GROUP BY customer.customer_id
    ORDER BY SUM(payment.amount) DESC
    LIMIT 1
)
GROUP BY customer.first_name, customer.last_name,film.title;

--Soru 41: En az kazanç sağlayan müşteri hangi filmleri kiralamış?
SELECT customer.first_name, customer.last_name, film.title, SUM(payment.amount) AS total_revenue
FROM customer
JOIN rental ON customer.customer_id = rental.customer_id
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
JOIN payment ON rental.rental_id = payment.rental_id
WHERE customer.customer_id =(
    SELECT customer.customer_id
    FROM customer
    JOIN rental ON customer.customer_id = rental.customer_id
    JOIN payment ON rental.rental_id = payment.rental_id
    GROUP BY customer.customer_id
    ORDER BY SUM(payment.amount) ASC
    LIMIT 1
)
GROUP BY customer.first_name, customer.last_name,film.title;

--Soru 42: En az kazanç sağlayan müşteri hangi türde en fazla film kiralamış?
SELECT customer.first_name, customer.last_name, category.name AS genre, COUNT(rental.rental_id) AS total_count
FROM customer
JOIN rental ON customer.customer_id = rental.customer_id
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
WHERE customer.customer_id =(
    SELECT customer.customer_id
    FROM customer
    JOIN rental ON customer.customer_id = rental.customer_id
    JOIN payment ON rental.rental_id = payment.rental_id
    GROUP BY customer.customer_id
    ORDER BY SUM(payment.amount) ASC
    LIMIT 1
)
GROUP BY customer.first_name, customer.last_name, genre;

--Soru 43: En çok kiralanan film hangi çalışan tarafından kiralanmış?
SELECT staff.first_name, staff.last_name, film.title, COUNT(rental.rental_id) AS rental_count
FROM staff
JOIN rental ON staff.staff_id = rental.staff_id
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
WHERE film.film_id =(
    SELECT film.film_id
    FROM film
    JOIN inventory ON film.film_id = inventory.film_id
    JOIN rental ON inventory.inventory_id = rental.inventory_id
    GROUP BY film.film_id
    ORDER BY COUNT(rental.rental_id) DESC
    LIMIT 1
)
GROUP BY staff.first_name, staff.last_name, film.title;

--Soru 44: En az kiralanan film hangi çalışan tarafından kiralanmış?
SELECT staff.first_name, staff.last_name, film.title, COUNT(rental.rental_id) AS rental_count
FROM staff
JOIN rental ON staff.staff_id = rental.staff_id
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
WHERE film.film_id =(
    SELECT film.film_id
    FROM film
    JOIN inventory ON film.film_id = inventory.film_id
    JOIN rental ON inventory.inventory_id = rental.inventory_id
    GROUP BY film.film_id
    ORDER BY COUNT(rental.rental_id) ASC
    LIMIT 1
)
GROUP BY staff.first_name, staff.last_name, film.title;

--Soru 45: En çok kazanç sağlayan film hangi çalışan tarafından kiralanmış?
SELECT staff.first_name, staff.last_name, film.title, SUM(payment.amount) AS total_revenue
FROM staff
JOIN rental ON staff.staff_id = rental.staff_id
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
JOIN payment ON rental.rental_id = payment.rental_id
WHERE film.film_id =(
    SELECT film.film_id
    FROM film
    JOIN inventory ON film.film_id = inventory.film_id
    JOIN rental ON inventory.inventory_id = rental.inventory_id
    JOIN payment ON rental.rental_id = payment.rental_id
    GROUP BY film.film_id
    ORDER BY SUM(payment.amount) DESC
    LIMIT 1
)
GROUP BY staff.first_name, staff.last_name, film.title;

--Soru 46: En az kazanç sağlayan film hangi çalışan tarafından kiralanmış?
SELECT staff.first_name, staff.last_name, film.title, SUM(payment.amount) AS total_revenue
FROM staff
JOIN rental ON staff.staff_id = rental.staff_id
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
JOIN payment ON rental.rental_id = payment.rental_id
WHERE film.film_id =(
    SELECT film.film_id
    FROM film
    JOIN inventory ON film.film_id = inventory.film_id
    JOIN rental ON inventory.inventory_id = rental.inventory_id
    JOIN payment ON rental.rental_id = payment.rental_id
    GROUP BY film.film_id
    ORDER BY SUM(payment.amount) ASC
    LIMIT 1
)
GROUP BY staff.first_name, staff.last_name, film.title;

--Soru 47: En çok kiralanan film hangi mağazada kiralanmış?
SELECT store.store_id, film.title, COUNT(rental.rental_id) AS rental_count
FROM store
JOIN staff ON store.store_id = staff.store_id
JOIN rental ON staff.staff_id = rental.staff_id
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
WHERE film.film_id =(
    SELECT film.film_id
    FROM film
    JOIN inventory ON film.film_id = inventory.film_id
    JOIN rental ON inventory.inventory_id = rental.inventory_id
    GROUP BY film.film_id
    ORDER BY COUNT(rental.rental_id) DESC
    LIMIT 1
)
GROUP BY store.store_id, film.title;

--Soru 48: En az kiralanan film hangi mağazada kiralanmış?(*)
SELECT store.store_id, film.title, COUNT(rental.rental_id) AS rental_count
FROM store
JOIN staff ON store.store_id = staff.store_id
JOIN rental ON staff.staff_id = rental.staff_id
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
WHERE film.film_id =(
    SELECT film.film_id
    FROM film
    JOIN inventory ON film.film_id = inventory.film_id
    JOIN rental ON inventory.inventory_id = rental.inventory_id
    GROUP BY film.film_id
    ORDER BY COUNT(rental.rental_id) ASC
    LIMIT 1
)
GROUP BY store.store_id, film.title;

--Soru 49: En çok kazanç sağlayan film hangi mağazada kiralanmış?
SELECT store.store_id, film.title, COUNT(rental.rental_id) AS rental_count
FROM store
JOIN staff ON store.store_id = staff.store_id
JOIN rental ON staff.staff_id = rental.staff_id
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
JOIN payment ON rental.rental_id = payment.rental_id
WHERE film.film_id =(
    SELECT film.film_id
    FROM film
    JOIN inventory ON film.film_id = inventory.film_id
    JOIN rental ON inventory.inventory_id = rental.inventory_id
    JOIN payment ON rental.rental_id = payment.rental_id
    GROUP BY film.film_id
    ORDER BY SUM(payment.amount) DESC
    LIMIT 1
)
GROUP BY store.store_id, film.title;

--Soru 50: En az kazanç sağlayan film hangi mağazada kiralanmış?
SELECT store.store_id, film.title, COUNT(rental.rental_id) AS rental_count
FROM store
JOIN staff ON store.store_id = staff.store_id
JOIN rental ON staff.staff_id = rental.staff_id
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
JOIN payment ON rental.rental_id = payment.rental_id
WHERE film.film_id =(
    SELECT film.film_id
    FROM film
    JOIN inventory ON film.film_id = inventory.film_id
    JOIN rental ON inventory.inventory_id = rental.inventory_id
    JOIN payment ON rental.rental_id = payment.rental_id
    GROUP BY film.film_id
    ORDER BY SUM(payment.amount) ASC
    LIMIT 1
)
GROUP BY store.store_id, film.title;
