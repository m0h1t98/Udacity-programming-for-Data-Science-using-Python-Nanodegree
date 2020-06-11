/* programming for Data Science with Python */
/* Udacity 1st project: Investigate a Relational Database */

/* Question Set # 2 */

/*
Question 1:
We want to find out how the two stores compare in their count of rental orders during every month for all the years 
we have data for. Write a query that returns the store ID for the store, the year and month and the number of rental
orders each store has fulfilled for that month. Your table should include a column for each of the following: year, month, 
store ID and count of rental orders fulfilled during that month.
*/
/*Answer 3 */

SELECT DATE_PART('month', r1.rental_date) AS Rental_month, 
       DATE_PART('year', r1.rental_date) AS Rental_year,
       s1.store_id AS Store_ID,
       COUNT(*) as Count_rentals
  FROM store AS s1
       JOIN staff AS s2
        ON s1.store_id = s2.store_id
		
       JOIN rental r1
        ON s2.staff_id = r1.staff_id
 GROUP BY 1, 2, 3
 ORDER BY count_rentals DESC;


 /*
Question 2
We would like to know who were our top 10 paying customers, how many payments they made on a monthly basis during 2007, 
and what was the amount of the monthly payments. Can you write a query to capture the customer name, month and year of 
payment, and total payment amount for each month by these top 10 paying customers?
*/

/*Answer 2 */

WITH t1 AS (SELECT (first_name || ' ' || last_name) AS fullname, 
                   c.customer_id, 
                   p.amount, 
                   p.payment_date
              FROM customer AS c
                   JOIN payment AS p
                    ON c.customer_id = p.customer_id),

     t2 AS (SELECT t1.customer_id,
                    sum(t1.amount) AS Sumition
              FROM t1
             GROUP BY 1
             ORDER BY Sumition DESC
             LIMIT 10)

SELECT t1.fullname,
       COUNT (*) AS pay_countpermon,
       SUM(t1.amount) AS pay_amount
  FROM t1
       JOIN t2
        ON t1.customer_id = t2.customer_id
 WHERE t1.payment_date BETWEEN '20070101' AND '20080101'
 GROUP BY 1, 2, 3;



/*
Question 3
Finally, for each of these top 10 paying customers, I would like to find out the difference across their monthly payments during 2007. Please go ahead and write a query to compare the payment amounts 
in each successive month. Repeat this for each of these 10 paying customers. Also, it will be tremendously helpful if you can identify the customer name who paid the most difference in terms of payments.
*/

/*Answer 3 */

 WITH t1 AS (SELECT (first_name || ' ' || last_name) AS fullname, 
                   c.customer_id, 
                   p.amount, 
                   p.payment_date
              FROM customer AS c
                   JOIN payment AS p
                    ON c.customer_id = p.customer_id),

     t2 AS (SELECT t1.customer_id
              FROM t1
             GROUP BY 1
             ORDER BY SUM(t1.amount) DESC
             LIMIT 10)

SELECT t1.fullname,
       DATE_PART('month', t1.payment_date) AS payment_month, 
       DATE_PART('year', t1.payment_date) AS payment_year,
    

       COUNT (*) AS pay_countpermon,
       SUM(t1.amount) AS pay_amount
  FROM t1
       JOIN t2
        ON t1.customer_id = t2.customer_id
 WHERE t1.payment_date BETWEEN '20070101' AND '20080101'
 GROUP BY 1, 2, 3;