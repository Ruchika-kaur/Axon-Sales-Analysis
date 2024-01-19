use classicmodels;
select * from customers
LIMIT 5;
select * from employees
limit 5;
select*from offices
limit 5;
select*from orderdetails
limit 5;
select * from orders
limit 5;
select*from payments
limit 5;
select * from productlines
limit 5;
select * from products;

-- Getting table infomation or details. We can identify the primary keys and the columns containg null values
desc customers;
desc employees;
desc offices;
desc orderdetails;
desc orders;
desc payments;
desc productlines;
desc products;

-- Distribution of customers based on countries
SELECT country, count(customerNumber) AS Total_Customers FROM customers
GROUP BY country
Order By Total_customers DESC;

-- No of Country
SELECT COUNT(DISTINCT(country)) from customers;

-- Highest Paying Customers
SELECT  customerName, city, country, SUM(quantityOrdered*priceEach) AS total_amount_spent
FROM    orderdetails JOIN
        orders USING (orderNumber) JOIN
        customers USING (customerNumber)
GROUP BY    customerNumber
ORDER BY    total_amount_Spent DESC;

-- Employees with Highest Sales
SELECT  salesRepEmployeeNumber, employees.firstName, employees.lastName, employees.email, SUM(quantityOrdered*priceEach) AS totalSales
FROM    orderdetails JOIN orders USING (orderNumber)
        JOIN customers USING (customerNumber)
        JOIN employees ON customers.salesRepEmployeeNumber = employees.employeeNumber
GROUP BY    salesRepEmployeeNumber
ORDER BY    totalSales DESC;

-- Highest Payment across different countries
SELECT c.country, SUM(p.amount) AS Total_Payment_Amount FROM customers c
INNER JOIN payments p on c.customerNumber=p.customerNumber
Group by country
Order by Total_Payment_Amount DESC;

-- Country with highest number of orders

SELECT c.country, count(o.orderNumber) as Total_Orders from customers c
INNER JOIN orders o on c.customerNumber=o.customerNumber
GROUP BY country
ORDER BY Total_Orders DESC;

-- Average price of each product
SELECT productcode, AVG(priceEach) AS Average_product_price FROM orders o 
INNER JOIN orderdetails od on o.orderNumber=od.orderNumber
GROUP BY productCode
ORDER BY Average_product_price;

-- Calculating the Profit
SELECT p.productcode,
p.productName,
pl.productLine,
p.quantityInStock,
p.buyPrice,
p.MSRP,
(p.MSRP - p.buyPrice) AS estimated_profit
FROM products p
JOIN productlines pl
USING (productLine)
ORDER BY productcode DESC;

-- Year wise sales analysis
-- Payments in 2003
SELECT customerNumber, paymentDate, amount FROM payments
WHERE paymentDate BETWEEN '2003-01-01' and '2003-12-31'
ORDER BY amount DESC;
-- Total payment done in 2003
SELECT SUM(amount) FROM payments as Total_Payment
WHERE paymentDate BETWEEN '2003-01-01' and '2003-12-31';

-- Payments in 2004
SELECT customerNumber, paymentDate, amount FROM payments
WHERE paymentDate BETWEEN '2004-01-01' and '2004-12-31'
ORDER BY amount DESC;
-- Total Payment in 2004
SELECT SUM(amount) FROM payments as Total_Payment
WHERE paymentDate BETWEEN '2004-01-01' and '2004-12-31';
-- Payments in 2005
SELECT customerNumber, paymentDate, amount FROM payments
WHERE paymentDate BETWEEN '2005-01-01' and '2005-12-31'
ORDER BY amount DESC;
-- Total Payment on 2005
SELECT SUM(amount) FROM payments as Total_Payment
WHERE paymentDate BETWEEN '2005-01-01' and '2005-12-31';

-- Product with highest orders

SELECT od.productCode, p.productName, count(od.productCode) as Number_Of_Products_Ordered FROM orderdetails od
INNER JOIN products p on p.productCode=od.productCode
GROUP BY productCode
ORDER BY Number_Of_Products_Ordered DESC;

-- Product line with highest orders

SELECT p.productLine, count(od.productCode) as Number_Of_ProductLines_Ordered FROM orderdetails od
INNER JOIN products p on p.productCode=od.productCode
GROUP BY productLine
ORDER BY Number_Of_ProductLines_Ordered DESC;

SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

-- Products with highest sales

SELECT od.productCode, p.productName, quantityOrdered*priceEach AS Total_Sales FROM orderdetails od
INNER JOIN products p ON p.productCode=od.productCode
GROUP BY od.productCode
ORDER BY Total_Sales DESC;

-- Product Line with highest sales value
SELECT  productLine, SUM(quantityOrdered*priceEach) AS Total_Sales FROM    productlines
INNER JOIN products USING (productLine)
INNER JOIN orderdetails USING (productCode)
GROUP BY    productLine
ORDER BY    Total_Sales DESC;


