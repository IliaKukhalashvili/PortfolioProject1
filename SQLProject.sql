
--Objective: Analyze the SQL database to gain insights into customer orders and product information.

--How many customers are there in each country? (from Highest to Lowest)

SELECT Country, COUNT(CustomerID) AS [Number Of Customers]
FROM Customers
GROUP BY Country
ORDER BY [Number Of Customers] DESC;

--What are the top 10 categories with the most products?

SELECT top 10 CategoryName, COUNT(ProductID) AS [Number Of Products]
FROM Categories
LEFT JOIN Products ON Categories.CategoryID = Products.CategoryID
GROUP BY CategoryName
ORDER BY [Number Of Products] DESC

--Who are the top 20 percent suppliers by the number of products they supply?

SELECT top 20 percent S.SupplierName, COUNT(P.ProductID) AS [Number Of Products Supplied]
FROM Suppliers as S
LEFT JOIN Products as P ON S.SupplierID = P.SupplierID
GROUP BY SupplierName
ORDER BY [Number Of Products Supplied] DESC

--Which employees have processed the most orders? List their IDs, names, and the total number of orders they processed.

SELECT E.EmployeeID, E.FirstName, E.LastName, COUNT(O.OrderID) AS [Total Orders Processed]
FROM Employees E
LEFT JOIN Orders O ON E.EmployeeID = O.EmployeeID
GROUP BY E.EmployeeID, E.FirstName, E.LastName
ORDER BY [Total Orders Processed] DESC

--What are the top 10 products with the highest prices by country?

WITH RankedProducts AS (
    SELECT
        ProductName, Price, Country,
        ROW_NUMBER() OVER (PARTITION BY Country ORDER BY Price DESC) AS Rank
    FROM Products JOIN Suppliers 
	ON Products.SupplierID = Suppliers.SupplierID)

SELECT ProductName, Price, Country
FROM RankedProducts
WHERE Rank <= 10

--Calculate the total revenue generated from each order.

SELECT OrderID, SUM(Quantity * Price) AS [Total Revenue]
FROM OrderDetails
JOIN Products ON OrderDetails.ProductID = Products.ProductID
GROUP BY OrderID

--What is the average order value for each employee, and how does it compare among them?

SELECT E.EmployeeID, FirstName, LastName, 
AVG(Quantity * Price) AS AverageOrderValue
FROM
    OrderDetails OD
JOIN
    Products P ON OD.ProductID = P.ProductID
JOIN
    Orders O ON OD.OrderID = O.OrderID
JOIN
    Employees E ON O.EmployeeID = E.EmployeeID
GROUP BY E.EmployeeID, FirstName, LastName
ORDER BY AverageOrderValue DESC