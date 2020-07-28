FROM
WHERE
JOIN
GROUP BY
HAVING
SELECT
ORDER BY


-- Single entity
-- 1. Prepare a list of offices sorted by country, state, city.
SELECT country, 
	   state, 
       city
FROM offices
ORDER BY country;

-- 2.How many employees are there in the company?
SELECT COUNT(employeeNumber) AS Totalemployees
FROM employees;

-- 3.What is the total of payments received?
SELECT SUM(amount) AS Totalpayment
FROM payments;

-- 4.List the product lines that contain 'Cars'.
SELECT *
FROM productlines
WHERE textDescription LIKE '%Cars%';

-- 5.Report total payments for October 28, 2004.
SELECT SUM(amount) AS totalamount
FROM payments
WHERE paymentDate = '2004-10-28';

-- 6.Report those payments greater than $100,000.
SELECT *
FROM payments
WHERE amount > '1000,000';

-- 7.List the products in each product line.
SELECT  DISTINCT productName, 
		productLine
FROM products;


-- 8.How many products in each product line?
SELECT productLine, 
	COUNT(productName) AS ProductNumbers
FROM products
GROUP BY productLine;

-- 9.What is the minimum payment received?
SELECT MIN(amount) AS Minimumpayment
FROM payments;

-- 10.List all payments greater than twice the average payment.
SELECT amount 
FROM payments
WHERE amount > (SELECT AVG(amount)*2 FROM payments);



-- 11.What is the average percentage markup of the MSRP on buyPrice?
SELECT buyPrice, 
	ROUND(AVG(buyPrice/MSRP),2) AS Markup
FROM products
GROUP BY buyPrice;  

-- select avg((MSRP - buyPrice) /buyPrice) * 100 as avg_percentage_markup
-- from products;

-- 12.How many distinct products does ClassicModels sell?
SELECT COUNT(DISTINCT productCode)
FROM products;

-- 13.Report the name and city of customers who don't have sales representatives?
SELECT DISTINCT city  
FROM customers
WHERE salesRepEmployeeNumber IS NULL;

-- 14.What are the names of executives with VP or Manager in their title? Use the CONCAT function to combine the employee's first name and last name into a single field for reporting.
SELECT  CONCAT(firstName,' ',lastName) AS Fullname, jobTitle
FROM employees 
WHERE jobTitle RLIKE '^VP' OR jobTitle RLIKE 'Manager';


-- 15.Which orders have a value greater than $5,000?
SELECT *
FROM orderdetails
WHERE quantityOrdered*priceEach > 5000;


-- One to many relationship

-- 1.Report the account representative for each customer.
SELECT customerName, 
	   salesRepEmployeeNumber
FROM customers;

-- 2.Report total payments for Atelier graphique.
SELECT SUM(amount) AS AGTotalPayments
FROM payments 
WHERE customerNumber IN(
SELECT customerNumber
FROM customers 
WHERE customerName = 'Atelier graphique');


-- 3.Report the total payments by date--------------------- didnt slove 
SELECT paymentDate, SUM(amount) AS totalpayments
FROM payments
GROUP BY paymentDate
ORDER BY paymentDate;



-- 4.Report the products that have not been sold.
SELECT DISTINCT O.productCode
FROM orderdetails O
LEFT OUTER JOIN products p
ON O.productCode = P.productCode;

-- 5.List the amount paid by each customer.

SElECT customerNumber, 
	SUM(amount) AS totalamountpaid
FROM payments
GROUP BY customerNumber;

#5
select c.customerName, sum(p.amount) as amount_paid
from payments p
join customers c on p.customerNumber = c.customerNumber
group by p.customerNumber;

-- 6.How many orders have been placed by Herkku Gifts?
SELECT COUNT(customerNumber) AS ordertimes
FROM orders
WHERE customerNumber IN (
SELECT customerNumber
FROM customers
WHERE customerName = 'Herkku Gifts');


-- 7.Who are the employees in Boston?
SELECT employeeNumber, 
	   lastName,
       firstName
FROM employees
WHERE officeCode IN (
SELECT officeCode
FROM offices
WHERE city ='Boston');

-- 8.Report those payments greater than $100,000. Sort the report so the customer who made the highest payment appears first.

SELECT P.customerNumber, 
	   C.customerName, 
       SUM(P.amount) AS totalamount
FROM payments P
LEFT JOIN customers C
ON P.customerNumber = C.customerNumber
GROUP BY P.customerNumber
HAVING totalamount > 100000
ORDER BY totalamount DESC;

-- 9.List the value of 'On Hold' orders.
SELECT DISTINCT orderNumber, 
	   productCode, 
       quantityOrdered*priceEach AS totalValue
FROM orderdetails
WHERE orderNumber IN(
SELECT orderNumber
FROM orders 
WHERE status = 'On Hold');


-- 10.Report the number of orders 'On Hold' for each customer.

SELECT customerNumber, 
       COUNT(orderNumber) AS numberOfOrders
FROM orders 
WHERE status = 'On Hold'
GROUP BY customerNumber;




-- Many to many relationship

-- 1.List products sold by order date.
SELECT O.orderDate, 
	   O.orderNumber, 
       D.productCode, 
       P.productName
FROM orders O
LEFT JOIN orderdetails D
ON O.orderNumber = D.orderNumber
LEFT JOIN products P
ON D.productCode = P.productCode;

-- 2.List the order dates in descending order for orders for the 1940 Ford Pickup Truck.
SELECT O.orderDate, 
	   D.productCode, 
       P.productName
FROM orders O
LEFT JOIN orderdetails D
ON O.orderNumber = D.orderNumber
LEFT JOIN products P
ON D.productCode = P.productCode
WHERE P.productName = '1940 Ford Pickup Truck'
ORDER BY O.orderDate DESC;

-- 3.List the names of customers and their corresponding order number where a particular order from that customer has a value greater than $25,000?
SELECT C.customerName
FROM customers C
RIGHT JOIN(
		SELECT customerNumber,
			SUM(amount) AS Totalamount
		FROM payments 
        GROUP BY customerNumber
        HAVING SUM(amount) > '25000') P
        ON C.customerNumber = P.customerNumber;

-- 4.Are there any products that appear on all orders?
SELECT DISTINCT P.productCode, P.productName
FROM products P
RIGHT JOIN orderdetails O
ON P.productCode = O.productCode;

-- 5.List the names of products sold at less than 80% of the MSRP.
SELECT DISTINCT(P.productName), O.priceEach, P.MSRP
FROM products P
LEFT JOIN orderdetails O
ON O.ProductCode = P.productCode
WHERE O.priceEach < P.MSRP*0.8;


-- 6.Reports those products that have been sold with a markup of 100% or more (i.e.,  the priceEach is at least twice the buyPrice)

SELECT DISTINCT(P.productName), P.buyPrice, O.priceEach
FROM products P
RIGHT JOIN orderdetails O
ON O.ProductCode = P.productCode
WHERE O.priceEach > P.buyPrice*2;

-- 7.List the products ordered on a Monday.
SELECT O.orderDate,
	   D.productCode
FROM orders O
LEFT JOIN orderdetails D
ON O.orderNumber = D.orderNumber
WHERE WEEKDAY(orderDate) = '0';

-- 8.What is the quantity on hand for products listed on 'On Hold' orders?
SELECT O.orderNumber,
	   D.quantityOrdered,
       O.status
FROM orders O
LEFT JOIN orderdetails D
ON O.orderNumber = D.orderNumber
WHERE status = 'On Hold';





-- Regular expressions

-- 1.Find products containing the name 'Ford'.
SELECT productName
FROM products
WHERE productName RLIKE 'Ford';  -- regexp need to check up 

-- 2.List products ending in 'ship'.
SELECT productName
FROM products
WHERE productName RLIKE 'ship$'; -- $ match the end a string

-- 3.Report the number of customers in Denmark, Norway, and Sweden.
SELECT country,
	COUNT(*) AS numberOfCustomer
FROM customers
WHERE country IN('Denmark','Norway','Sweden')
GROUP BY country;

-- 4.What are the products with a product code in the range S700_1000 to S700_1499?
SELECT productName, productCode
FROM products
WHERE productCode REGEXP 'S700_1[0-4][0-9][0-9]';
-- between 'S700_1000' and 's700_1499'


-- 5.Which customers have a digit in their name?
SELECT customerName
FROM customers
WHERE customerName REGEXP '[0-9]';

-- 6.List the names of employees called Dianne or Diane.
SELECT *
FROM employees
WHERE firstName IN ('Dianne','Diane');

-- 7.List the products containing ship or boat in their product name.
SELECT *
FROM products
WHERE productName REGEXP 'ship' OR 'boat';

-- 8.List the products with a product code beginning with S700.
SELECT *
FROM products
WHERE productCode RLIKE'^S700';

-- 9.List the names of employees called Larry or Barry.
SELECT *
FROM employees
WHERE firstName IN ('Larry ','Barry');

-- 10.List the names of employees with non-alphabetic characters in their names.
SELECT *
FROM employees
where not (firstName regexp '[a-z]') or not (lastName regexp '[a-z]');


-- 11.List the vendors whose name ends in Diecast
SELECT productVendor
FROM products
WHERE productVendor RLIKE 'Diecast$';



-- General queries

-- 1.Who is at the top of the organization (i.e.,  reports to no one).
SELECT *
FROM employees
WHERE reportsTo IS NULL;

-- 2.Who reports to William Patterson?
SELECT *
FROM employees
WHERE reportsTo IN (
SELECT employeeNumber
FROM employees
WHERE firstName = 'William'
AND lastName = 'Patterson');

-- 3.List all the products purchased by Herkku Gifts.
SELECT orderNumber
FROM orders
WHERE customerNumber IN(
SELECT customerNumber
FROM customers
WHERE customerName = 'Herkku Gifts');

-- 4.Compute the commission for each sales representative, assuming the commission is 5% of the value of an order. Sort by employee last name and first name.
WITH salesRepCommission AS
(SELECT C.salesRepEmployeeNumber, 
		SUM(D.quantityOrdered*D.priceEach)*0.05 AS commission
FROM customers C
RIGHT JOIN orders O
ON C.customerNumber = O.customerNumber
RIGHT JOIN orderdetails D
ON O.orderNumber = D.orderNumber
GROUP BY C.salesRepEmployeeNumber)
SELECT SC.salesRepEmployeeNumber,
	   E.lastName,
       E.firstName,
       SC.commission 
FROM salesRepCommission SC
LEFT JOIN employees E
ON SC.salesRepEmployeeNumber = E.EmployeeNumber
ORDER BY  E.lastName,
		  E.firstName;


-- 5.What is the difference in days between the most recent and oldest order date in the Orders file?

SELECT DATEDIFF(MAX(orderDate), MIN(orderDate)) AS DateDiff
FROM orders;


-- 6.Compute the average time between order date and ship date for each customer ordered by the largest difference.
SELECT customerNumber, 
	AVG(DATEDIFF(shippedDate,orderDate)) AS DateDiff
FROM orders
GROUP BY customerNumber
ORDER BY DateDiff DESC;

-- 7.What is the value of orders shipped in August 2004? (Hint).
SELECT SUM(quantityOrdered*priceEach) AS shippingValue
FROM orders O
LEFT JOIN orderDetails D
ON O.orderNumber = D.orderNumber
WHERE shippedDate BETWEEN '2004-08-01' AND '2004-08-31';


-- where month(shippedDate) = 8 and year(shippedDate) =2004
-- group by o.orderNumber;


-- 8.Compute the total value ordered, total amount paid, and their difference for each customer for orders placed in 2004 and payments received in 2004 (Hint; Create views for the total paid and total ordered).

SELECT SUM(quantityOrdered*priceEach) AS totalOrderValue, SUM(P.amount) AS totalPaid 
FROM orderDetails D
LEFT JOIN orders O
ON D.orderNumber = O.orderNumber
LEFT JOIN payments P
ON O.customerNumber = P.customerNumber
WHERE P.paymentDate BETWEEN  '2004-01-01' AND '2004-12-31'
AND O.orderDate BETWEEN  '2004-01-01' AND '2004-12-31'
GROUP BY P.customerNumber;

select sum(od.quantityOrdered * od.priceEach) as value_ordered, sum(p.amount) as payment, sum(od.quantityOrdered * od.priceEach)-sum(p.amount) as diff_order_payment
from customers c
join orders o on c.customerNumber = o.customerNumber
join orderdetails od on o.orderNumber = od.orderNumber
join payments p on c.customerNumber = p.customerNumber
where year(o.orderDate) = 2004 and year(p.paymentDate) = 2004
group by c.customerNumber;

-- 9.List the employees who report to those employees who report to Diane Murphy. Use the CONCAT function to combine the employee's first name and last name into a single field for reporting.

SELECT employeeNumber, CONCAT(firstName,' ',lastName) AS employeeFullName
FROM employees
WHERE reportsTo = (
SELECT employeeNumber 
FROM employees
WHERE CONCAT(firstName,' ',lastName) ='Diane Murphy');


-- 10.What is the percentage value of each product in inventory sorted by the highest percentage first (Hint: Create a view first).
SELECT ProductCode, 
	quantityInStock*buyPrice AS productValue,
  100*quantityInStock*buyPrice/SUM(quantityInStock*buyPrice) AS precentage
FROM products
GROUP BY ProductCode
ORDER BY productValue/SUM(productValue) ASC; 

select productCode, productName, 100 * sum(quantityInStock * MSRP)/(SELECT sum(quantityInStock*MSRP) from products) as value_percentage
from products
group by productCode
order by sum(quantityInStock * MSRP) desc;

     

-- 11.Write a function to convert miles per gallon to liters per 100 kilometers.
DELIMITER $$
CREATE 	FUNCTION mpgConvert (
				mpg DOUBLE)
RETURNS DOUBLE
DETERMINISTIC 
BEGIN
DECLARE lpk DOUBLE;
RETURN mpg*235.2145;
END $$
DELITMITER ;



-- delimiter $$
-- create function mpg_convert(v_mpg double) 
-- returns double
-- deterministic no sql reads sql data
-- begin
-- declare v_lpk double;
-- return 2.35215 * v_mpg;
-- end $$
-- delimiter ;

#12
delimiter $$
create procedure increase_price
	(in increase_percentage double, 
	 in category varchar(255))
begin
update products
set MSRP = (increase_percentage + 1)  * MSRP
where productLine = category;
end $$
delimiter;

CALL increase_price(0.5,'Planes')


-- 12.Write a procedure to increase the price of a specified product category by a given percentage. You will need to create a product table with appropriate data to test your procedure. Alternatively, load the ClassicModels database on your personal machine so you have complete access. You have to change the DELIMITER prior to creating the procedure.

-- DELIMITER $$

-- CREATE FUNCTION increasePrice (
-- 				increasePercentage DOUBLE)
-- RETURNS DOUBLE
-- BEGIN 
-- SET MSRP=(increasePercentage + 1)*MSRP

-- 13.What is the value of orders shipped in August 2004? (Hint). 
SELECT SUM(quantityOrdered*priceEach) AS shippingValue
FROM orders O
LEFT JOIN orderDetails D
ON O.orderNumber = D.orderNumber
WHERE shippedDate BETWEEN '2004-08-01' AND '2004-08-31';

-- 14.What is the ratio the value of payments made to orders received for each month of 2004. 
-- (i.e., divide the value of payments made by the orders received)?

SELECT MONTH(orderDate) AS orderMonth ,
		SUM(D.priceEach * D.quantityOrdered)/SUM(P.amount) as Ratio 
FROM payments P
JOIN orders O 
ON P.customerNumber = O.customerNumber
JOIN orderdetails D
ON O.orderNumber = D.orderNumber
WHERE YEAR(O.orderDate) = 2004
AND YEAR(P.paymentDate) = 2004
GROUP BY orderMonth;



-- 15.What is the difference in the amount received for each month of 2004 compared to 2003?
WITH paymentOf2003 AS(
SELECT MONTH(PaymentDate) AS paymentMonth,
	   SUM(amount) AS aomuntReceive
FROM payments
WHERE YEAR(paymentDate) = 2003
GROUP BY paymentMonth
ORDER BY paymentMonth ASC
),
paymentOf2004 AS(
SELECT MONTH(PaymentDate) AS paymentMonth,
	   SUM(amount) AS aomuntReceive
FROM payments
WHERE YEAR(paymentDate) = 2004
GROUP BY paymentMonth
ORDER BY paymentMonth ASC
)
SELECT paymentOf2003.aomuntReceive, 
	   paymentOf2004.aomuntReceive, 
       paymentOf2003.aomuntReceive - paymentOf2004.aomuntReceive AS Difference 
FROM paymentOf2003,PaymentOf2004;



-- 16.Write a procedure to report the amount ordered in a specific month and year for customers containing a specified character string in their name.
delimiter $$
create procedure amount_ordered
	(in v_month integer, 
	 in v_year integer, 
     in v_name varchar(255))
begin
	select sum(od.quantityOrdered * od.priceEach)
    from customers c
    left join orders o on c.customerNumber = o.customerNumber
    join orderdetails od on o.orderNumber = od.orderNumber
    where month(o.orderDate) = v_month and year(o.orderDate) = v_year and c.customerName regexp v_name ;
end $$
delimiter ;



-- 17.Write a procedure to change the credit limit of all customers in a specified country by a specified percentage.

DELIMITER $$
CREATE PROCEDURE creditChange 
( IN changePercentage DOUBLE,
  IN changeCountry VARCHAR(50))
BEGIN 
UPDATE customers
SET creditLimit = (changePercentage + 1)*creditLimit
WHERE country = changeCountry;
END $$
DELIMITER ;

CALL creditChange(1.2, ' USA');

-- 18.Basket of goods analysis: A common retail analytics task is to analyze each basket or order to learn what products are often purchased together. 
select items,count(*) as 'Freq' from (select concat(x.productCode,',',y.productCode) as items 
from orderdetails x
JOIN orderdetails y ON x.orderNumber = y.orderNumber 
and x.productCode != y.productCode and x.productCode < y.productCode) A 
group by A.items 
having Freq>10 
order by A.items;


-- 19.ABC reporting: Compute the revenue generated by each customer based on their orders. Also, show each customer's revenue as a percentage of total revenue. Sort by customer name.

SELECT C.customerName, 
	   SUM(D.quantityOrdered* D.priceEach) AS revenue,
       100*SUM(D.quantityOrdered* D.priceEach)/(SELECT SUM(quantityOrdered*priceEach) 
											 FROM orderdetails) AS revenuePercentage
FROM customers C
JOIN orders O
ON C.customerNumber = O.customerNumber
JOIN orderdetails D
ON O.orderNumber = D.orderNumber
GROUP BY C.customerNumber
ORDER BY C.customerName;


SELECT SUM(quantityOrdered*priceEach) 
FROM orderdetails;



   

-- 20.Compute the profit generated by each customer based on their orders. Also, show each customer's profit as a percentage of total profit. Sort by profit descending.
SELECT C.customerNumber,
	   C.customerName,
	  SUM((D.priceEach - P.buyPrice)* D.quantityOrdered) AS profit,
      100*SUM((D.priceEach - P.buyPrice)* D.quantityOrdered)/(
      SELECT SUM((priceEach - buyPrice)* quantityOrdered)
      FROM orderdetails 
      LEFT JOIN products 
      ON orderdetails.productCode= products.productCode) AS percentage	   
FROM orderdetails D
LEFT JOIN products P
ON D.productCode = P.productCode
JOIN orders O
ON D.orderNumber = O.orderNumber
JOIN customers C
ON O.customerNumber = C.customerNumber
GROUP BY C.customerNumber
ORDER BY profit DESC;


-- 21.Compute the revenue generated by each sales representative based on the orders from the customers they serve.
SELECT  E.employeeNumber,
		E.firstName,
		E.lastName,
		SUM(D.quantityOrdered * D.priceEach) AS Revenue 
FROM employees E
LEFT JOIN customers C
ON E.employeeNumber = C.salesRepEmployeeNumber
JOIN orders O
ON C.customerNumber = O.customerNumber
JOIN orderdetails D
ON O.orderNumber = D.orderNumber
GROUP BY E.employeeNumber;



-- 22.Compute the profit generated by each sales representative based on the orders from the customers they serve. Sort by profit generated descending.

SELECT  E.employeeNumber,
		E.firstName,
		E.lastName,
		SUM((D.priceEach - P.buyPrice)* D.quantityOrdered) AS Profit
FROM employees E
LEFT JOIN customers C
ON E.employeeNumber = C.salesRepEmployeeNumber
JOIN orders O
ON C.customerNumber = O.customerNumber
JOIN orderdetails D
ON O.orderNumber = D.orderNumber
JOIN products P
ON D.productCode = P.productCode
GROUP BY E.employeeNumber;

-- 23.Compute the revenue generated by each product, sorted by product name.
SELECT P.productCode,
	   P.productName,
       SUM(D.quantityOrdered * D.priceEach) AS Revenue
FROM products P
JOIN orderdetails D
ON P.productCode = D.productCode
GROUP BY P.productCode;
       


-- 24.Compute the profit generated by each product line, sorted by profit descending.

SELECT P.productCode,
	   P.productName,
       SUM(D.quantityOrdered * D.priceEach) AS Revenue
FROM products P
JOIN orderdetails D
ON P.productCode = D.productCode
GROUP BY P.productCode;

-- 25.Same as Last Year (SALY) analysis: Compute the ratio for each product of sales for 2003 versus 2004.

WITH SALY2003 AS
(
SELECT P.productCode,
	   P.productName,
       SUM(D.quantityOrdered * D.priceEach) AS Revenue
FROM products P
JOIN orderdetails D
ON P.productCode = D.productCode
JOIN orders O
ON D.orderNumber = O.orderNumber
WHERE YEAR(O.orderDate) = 2003
GROUP BY P.productCode
),
SALY2004 AS
(
SELECT P.productCode,
	   P.productName,
       SUM(D.quantityOrdered * D.priceEach) AS Revenue
FROM products P
JOIN orderdetails D
ON P.productCode = D.productCode
JOIN orders O
ON D.orderNumber = O.orderNumber
WHERE YEAR(O.orderDate) = 2004
GROUP BY P.productCode
)
SELECT SALY2003.productCode,
       SALY2003.productName,
	   SALY2003.Revenue AS RevenueIn2003,
       SALY2004.Revenue AS RevenueIn2004,
	   SALY2004.Revenue/SALY2003.Revenue AS Ratio
FROM SALY2003
LEFT JOIN SALY2004
ON SALY2003.productCode = SALY2004.productCode;



	   

-- 26.Compute the ratio of payments for each customer for 2003 versus 2004.

WITH Payment2003 AS
(
SELECT C.customerNumber,
	   C.customerName,
       SUM(P.amount) AS totalPaymentAmount 
FROM customers C
JOIN payments P
ON C.customerNumber = P.customerNumber
WHERE YEAR(P.paymentDate) = 2003
GROUP BY C.customerNumber
),
Payment2004 AS
(
SELECT C.customerNumber,
	   C.customerName,
       SUM(P.amount) AS totalPaymentAmount 
FROM customers C
JOIN payments P
ON C.customerNumber = P.customerNumber
WHERE YEAR(P.paymentDate) = 2004
GROUP BY C.customerNumber
)
SELECT Payment2003.customerNumber,
	   Payment2003.customerName,
	   Payment2003.totalPaymentAmount  AS totalPayment2003,
	   Payment2004.totalPaymentAmount  AS totalPayment2004,
	   Payment2004.totalPaymentAmount/Payment2003.totalPaymentAmount AS Ratio
FROM Payment2003
LEFT JOIN Payment2004
ON Payment2003.customerNumber = Payment2004.customerNumber;

-- 27.Find the products sold in 2003 but not 2004.
WITH soldIn2003 AS
(
SELECT P.productCode,
	   P.productName
FROM products P
JOIN orderdetails D
ON P.productCode = D.productCode
JOIN orders O
ON D.orderNumber = O.orderNumber
WHERE YEAR(O.orderDate) = 2003
GROUP BY P.productCode
),
soldIn2004 AS
(
SELECT P.productCode,
	   P.productName
FROM products P
JOIN orderdetails D
ON P.productCode = D.productCode
JOIN orders O
ON D.orderNumber = O.orderNumber
WHERE YEAR(O.orderDate) = 2004
GROUP BY P.productCode
)
SELECT soldIn2003.productCode,
	   soldIn2003.productName
FROM soldIn2003
LEFT JOIN soldIn2004
ON soldIn2003.productCode = soldIn2004.productCode;
-- NOT SURE



-- 28.Find the customers without payments in 2003.
SELECT P.customerNumber, 
	   C.customerName,
       P.paymentDate
FROM payments P
LEFT JOIN customers C
ON P.customerNumber = C.customerNumber
WHERE YEAR(paymentDate) != '2003' ; 




-- Correlated subqueries

-- 1.Who reports to Mary Patterson?
SELECT employeeNumber, 
	   CONCAT(firstName,' ',lastName) AS employeeFullName,
       reportsTo
FROM employees
WHERE reportsTo = (
SELECT employeeNumber 
FROM employees
WHERE CONCAT(firstName,' ',lastName) ='Mary Patterson');

-- 2.Which payments in any month and year are more than twice the average for that month and year (i.e. compare all payments in Oct 2004 with the average payment for Oct 2004)? Order the results by the date of the payment. You will need to use the date functions.
SELECT amount,
       paymentDate
FROM payments
WHERE amount > ( SELECT AVG(amount)*2 FROM payments)
ORDER BY paymentDate;


-- 3.Report for each product, the percentage value of its stock on hand as a percentage of the stock on hand for product line to which it belongs. 
-- Order the report by product line and percentage value within product line descending. Show percentages with two decimal places.

SELECT productCode,
       productName,
       productLine,
       quantityInStock*100/(SELECT SUM(quantityInStock) FROM products) AS percentage
FROM products 
ORDER BY productLine;


-- 4.For orders containing more than two products, report those products that constitute more than 50% of the value of the order.
WITH tb1 AS
(
SELECT productCode,
	   orderNumber,
	   priceEach * quantityOrdered AS productValue
FROM orderdetails
),
tb2 AS 
(
SELECT orderNumber,
	   COUNT(productCode) AS totalItem,
       SUM(priceEach*quantityOrdered) AS orderValue
FROM orderdetails
GROUP BY orderNumber
HAVING totalItem >= 2)
SELECT tb1.productCode,
	   tb2.orderNumber,
       tb1.productValue/tb2.orderValue AS precentage 
FROM tb1
RIGHT JOIN tb2
ON tb1.orderNumber = tb2.orderNumber
WHERE tb1.productValue/tb2.orderValue > 0.5;





       
                

                

