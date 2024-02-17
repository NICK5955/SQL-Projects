create database supply_chain;
use supply_chain;

-- Customer Table
CREATE TABLE customer (
    id INT PRIMARY KEY,
    firstname VARCHAR(50),
    lastname VARCHAR(50),
    city VARCHAR(50),
    country VARCHAR(50),
    phone VARCHAR(20)
);

INSERT INTO customer (id, firstname, lastname, city, country, phone)
VALUES
    (1, 'Arya', 'Singh', 'Delhi', 'India', '9876543210'),
    (2, 'Bhavya', 'Patel', 'Mumbai', 'India', '8765432109'),
    (3, 'Chirag', 'Verma', 'Kolkata', 'India', '7654321098'),
    (4, 'Divya', 'Reddy', 'Hyderabad', 'India', '6543210987'),
    (5, 'Esha', 'Gupta', 'Bangalore', 'India', '5432109876');


-- Supplier table
CREATE TABLE supplier (
    id INT PRIMARY KEY,
    companyname VARCHAR(100),
    country VARCHAR(50),
    contactname VARCHAR(100),
    city VARCHAR(50),
    phone VARCHAR(20)
);

INSERT INTO supplier (id, companyname, country, contactname, city, phone)
VALUES
    (1, 'Royal Spices', 'India', 'Ramesh Sharma', 'Delhi', '9876543210'),
    (2, 'Modern Hardware', 'India', 'Rajesh Patel', 'Mumbai', '8765432109'),
    (3, 'Eastern Paper', 'India', 'Neha Verma', 'Kolkata', '7654321098'),
    (4, 'National Machines', 'India', 'Rohit Reddy', 'Hyderabad', '6543210987'),
    (5, 'Classic Furniture', 'India', 'Pooja Gupta', 'Bangalore', '5432109876');

-- Orders Table
CREATE TABLE orders (
    id INT PRIMARY KEY,
    customerid INT,
    ordernumber INT,
    orderdate DATE,
    totalamount DECIMAL(10, 2),
    FOREIGN KEY (customerid) REFERENCES customer(id)
);

INSERT INTO orders (id, customerid, ordernumber, orderdate, totalamount)
VALUES
    (1, 1, 1001, '2023-01-01', 200.00),
    (2, 1, 1002, '2023-01-10', 300.00),
    (3, 2, 1003, '2023-01-15', 450.00),
    (4, 2, 1004, '2023-02-01', 500.00),
    (5, 3, 1005, '2023-02-15', 600.00),
    (6, 4, 1006, '2023-03-01', 700.00),
    (7, 4, 1007, '2023-03-15', 800.00),
    (8, 5, 1008, '2023-04-01', 900.00),
    (9, 1, 1009, '2023-04-15', 1000.00),
    (10, 1, 1010, '2023-05-01', 1100.00);


-- Product Table
CREATE TABLE product (
    id INT PRIMARY KEY,
    productname VARCHAR(100),
    supplierid INT,
    unitprice DECIMAL(10, 2),
    isdiscontinued BOOLEAN,
    FOREIGN KEY (supplierid) REFERENCES supplier(id)
);

INSERT INTO product (id, productname, supplierid, unitprice, isdiscontinued)
VALUES
    (1, 'Red Chili Powder', 1, 50.00, 0),
    (2, 'Black Pepper Powder', 1, 80.00, 0),
    (3, 'Steel Nails', 2, 15.00, 0),
    (4, 'Iron Screws', 2, 25.00, 0),
    (5, 'A4 Paper', 3, 5.00, 0),
    (6, 'A3 Paper', 3, 8.00, 0),
    (7, 'Lathe Machine', 4, 15000.00, 0),
    (8, 'Drilling Machine', 4, 20000.00, 0),
    (9, 'Wooden Table', 5, 2500.00, 0),
    (10, 'Wooden Chair', 5, 1500.00, 0);

-- Order item table
CREATE TABLE orderitem (
    id INT PRIMARY KEY,
    orderid INT,
    productid INT,
    unitprice DECIMAL(10, 2),
    quantity INT,
    FOREIGN KEY (orderid) REFERENCES orders(id),
    FOREIGN KEY (productid) REFERENCES product(id)
);

INSERT INTO orderitem (id, orderid, productid, unitprice, quantity)
VALUES
    (1, 1, 1, 50.00, 2),
    (2, 1, 2, 80.00, 1),
    (3, 2, 1, 50.00, 3),
    (4, 2, 3, 15.00, 50),
    (5, 3, 2, 80.00, 2),
    (6, 3, 4, 25.00, 10),
    (7, 4, 2, 80.00, 3),
    (8, 4, 5, 5.00, 200),
    (9, 5, 6, 8.00, 50),
    (10, 5, 7, 15000.00, 1),
    (11, 6, 8, 20000.00, 1),
    (12, 7, 9, 2500.00, 1),
    (13, 8, 10, 1500.00, 2),
    (14, 9, 1, 50.00, 4),
    (15, 9, 2, 80.00, 2);

-- Show all the Tables
show tables;

-- Read the data from all the tables
select * from customer;
select * from orderitem;
select * from orders;
select * from product;
select * from supplier;


-- Subquery Questions:
# 1.  Find the names of customers who have placed orders worth more than 500 rupees.
select id , concat(firstname,' ',lastname) as name 
from customer 
where id in (
	select customerid 
	from orders 
	where totalamount > 500
);


#2. Find customers who have placed orders with a total amount greater than the average order amount.
select * 
from customer 
where id in (
	select customerid 
    from orders 
    where totalamount  > (
		select avg(totalamount) 
        from orders
        )
);

#3. List products that are supplied by companies based in Delhi.
 select Productname 
 from product 
 where supplierid = (
	 select id 
	 from supplier 
	 where city = "Delhi"
);

#4. Find the total amount spent by customers in Mumbai.
select sum(totalamount) 
from orders 
where customerid in (
	select id 
    from customer 
    where city = "mumbai"
);

#5. Find the supplier names who supply products worth more than 10000 rupees.
select * 
from supplier 
where id in (
	select supplierid 
    from product 
    where unitprice *(
		select sum(quantity) 
        from orderitem 
        where orderitem.productid = product.id) 
	group by supplierid 
    having sum(unitprice)>10000
);


-- JOINS QUESTIONS
# 1. Display all orders with customer details (first name, last name) and their respective order numbers.
select o.ordernumber, c.id, concat(c.firstname," ",c.lastname) as Name , o.totalamount, c.city 
from orders as o 
join customer as c 
on c.id = o.customerid;

#2. List all products along with their suppliers' company names ,cities and unit price of product.
select p.id, p.productname , s.companyname, s.city ,p.unitprice
from product p 
join supplier s 
on p.supplierid =s.id;


#3. List all the orders along with the total quantity of each product ordered.
select o.* ,oi.productid, sum(oi.quantity) 
from orders o 
join orderitem oi 
on o.id = oi.orderid 
group by  o.id,oi.productid ;

#4. Display orders along with customer names and their cities where the order total amount is greater than 500.
select o.ordernumber, concat(c.firstname," ",c.lastname) , c.city, o.totalamount 
from orders o 
join customer c 
on c.id = o.customerid 
where totalamount > 500 ;

#5.List all customers along with the total number of orders they've placed.
select c.id,concat(c.firstname," ",c.lastname) as Name ,count(o.id) as no_of_orders
from customer c 
join orders o 
on o.customerid = c.id 
group by c.id,concat(c.firstname," ",c.lastname);

-- multiple joins
#1. List all the order items along with the product name ,order date with unit price
select oi.orderid,oi.productid, p.productname, o.orderdate , p.unitprice
from orderitem oi
join product p on oi.productid = p.id 
join orders o on oi.orderid = o.id
order by orderid;

#2. List all the suppliers who supply products worth more than 5000 rupees.
select s.companyname , SUM(p.unitprice * oi.quantity) as amount
from supplier s
join product p ON s.id = p.supplierid 
join orderitem oi ON p.id = oi.productid 
group by s.companyname 
having amount > 5000;

#3.Find the names and contact information of all customers who have ordered products worth more than 1000 rupees in total.
select concat(c.firstname," ",c.lastname) as Name, c.phone ,p.unitprice * oi.quantity
from customer c 
join orders o on o.customerid = c.id
join orderitem oi on oi.orderid = o.id
join product p on oi.productid= p.id
where p.unitprice * oi.quantity > 1000;






