USE Northwind;

-- Exercise 1 – Northwind Queries (40 marks: 5 for each question)

    -- 1.1	Write a query that lists all Customers in either Paris or London. Include Customer ID, Company Name and all address fields.
    SELECT c.CustomerID AS "Customer ID", 
           c.CompanyName AS "Company Name",  
           CONCAT(c.Address, ', ',
                  c.City,
                  c.Region, ', ', 
                  c.PostalCode, ', ', 
                  c.Country) AS "Customer Address"
      FROM Customers AS c 
     WHERE c.City IN ('Paris', 'London');

    -- 1.2	List all products stored in bottles.
    SELECT p.ProductName AS "Product Name"
      FROM Products AS p
     WHERE p.QuantityPerUnit LIKE '%bottles';

    -- 1.3	Repeat question above, but add in the Supplier Name and Country.
    SELECT p.ProductName AS "Product Name", 
           s.CompanyName AS "Supplier Name",
           s.Country
      FROM Products AS p
      JOIN Suppliers AS s 
        ON p.SupplierID = s.SupplierID
     WHERE p.QuantityPerUnit LIKE '%bottles';

    -- 1.4	Write an SQL Statement that shows how many products there are in each category. Include Category Name in result set and list the highest number first.
    SELECT c.CategoryName AS "Category Name",
           COUNT(p.ProductID) AS "No. of Items"
      FROM Categories AS c
      JOIN Products AS p 
        ON c.CategoryID = p.CategoryID
     GROUP BY c.CategoryName
     ORDER BY "No. of Items" DESC;

    -- 1.5	List all UK employees using concatenation to join their title of courtesy, first name and last name together. Also include their city of residence.
    SELECT CONCAT(e.TitleOfCourtesy, ' ', 
                  e.FirstName, ' ', 
                  e.LastName) AS "Employee Name",
           e.City AS "City of Residence"
      FROM Employees AS e 
      
    -- 1.6	List Sales Totals for all Sales Regions (via the Territories table using 4 joins) with a Sales Total greater than 1,000,000. Use rounding or FORMAT to present the numbers. 
    SELECT DISTINCT t.RegionID AS "Sales Region ID", 
           FORMAT(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 'C2', 'en-us') AS "Sales Total"
      FROM Territories AS t
           JOIN EmployeeTerritories AS et 
             ON t.TerritoryID = et.TerritoryID
           JOIN Employees AS e 
             ON et.EmployeeID = e.EmployeeID
           JOIN Orders AS o 
             ON e.EmployeeID = o.EmployeeID
           JOIN [Order Details] AS od 
             ON o.OrderID = od.OrderID
     GROUP BY t.RegionID
    HAVING SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) > 1000000
     ORDER BY t.RegionID;


    -- 1.7	Count how many Orders have a Freight amount greater than 100.00 and either USA or UK as Ship Country.
    SELECT COUNT(*) AS "Freight > 100.00 and Ship to UK/USA" 
      FROM Orders ord
     WHERE ord.Freight > 100.00 
       AND ord.ShipCountry IN ('UK', 'USA');

    -- 1.8	Write an SQL Statement to identify the Order Number of the Order with the highest amount(value) of discount applied to that order.
    SELECT TOP 1 od.OrderID AS "Order Number",
           FORMAT((od.Discount * od.Quantity * od.Discount), 'C2', 'en-us') AS "Value of Discount"
      FROM [Order Details] od
     ORDER BY "Value of Discount" DESC;


CREATE DATABASE kurtis_db;
USE kurtis_db;

-- Exercise 2 – Create Spartans Table (20 marks – 10 each)


    -- 2.1 Write the correct SQL statement to create the following table:DROP TABLE spartans_table;

    /*
    Spartans Table – include details about all the Spartans on this course. Separate Title, First Name and Last Name into separate columns, and include University attended, course taken and mark achieved. Add any other columns you feel would be appropriate. 

    MPORTANT NOTE: For data protection reasons do NOT include date of birth in this exercise. 
    */

    DROP TABLE spartans_table;

    CREATE TABLE spartans_table
    (
        spartan_id INT IDENTITY(1,1) PRIMARY KEY,
        title VARCHAR(6) NOT NULL DEFAULT 'Mx.',
        first_name VARCHAR (20) NOT NULL,
        last_name VARCHAR (20) NOT NULL,
        uni_attended VARCHAR(50) NOT NULL,
        course_taken VARCHAR(50) NOT NULL,
        mark_achieved VARCHAR(3) NOT NULL
    );


    -- 2.2 Write SQL statements to add the details of the Spartans in your course to the table you have created.	
    INSERT INTO spartans_table
    (title, first_name, last_name, uni_attended, course_taken, mark_achieved)
    VALUES
    ('Mr', 'John', 'Smith', 'University College London', 'Aeronautical Engeineering', '1st'),
    ('Mrs', 'Alex', 'Rogan', 'Aberystwyth University', 'Law', '2:1'),
    ('Ms', 'Joe', 'Jones', 'London School of Economics', 'Physics', '1st'),
    ('Mr', 'Idris', 'Weinstein', 'University of Sunderland', 'English Literature', '3rd'),
    ('Miss', 'Harvey', 'Elba', 'University of Manchester', 'Mathematics', '2:2'),
    ('Mr.', 'Alexander', 'Stalin', 'University of Birmingham', 'Computer Science', '2:1'),
    ('Mx', 'Smirnoff', 'McGinn', 'Birmingham City University', 'Sport Science', '1st'),
    ('Dr', 'Connor', 'Ice', 'University of Edinburgh', 'Dentistry', '1st'),
    ('Miss', 'Steve', 'Austin', 'University of Southampton', 'Forensics Computing', '1st'),
    ('Mr.', 'Steve', 'Austin', 'King’s College London', 'English Language and Linguistics', '2:2');

    SELECT * FROM spartans_table;

    SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES;

-- Exercise 3 – Northwind Data Analysis linked to Excel (30 marks)
-- Write SQL statements to extract the data required for the following charts (create these in Excel):
    -- 3.1 List all Employees from the Employees table and who they report to. No Excel required. Include Employee names and ReportTo names. (5 Marks)
    SELECT e.FirstName + ' ' + e.LastName AS "Employee Name",
           b.FirstName + ' ' + b.LastName AS "Reports To"
      FROM Employees AS e
           LEFT JOIN Employees AS b 
             ON e.ReportsTo = b.EmployeeID;

    -- 3.2 List all Suppliers with total sales over $10,000 in the Order Details table. Include the Company Name from the Suppliers Table and present as a bar chart as below: (5 Marks)
    SELECT s.CompanyName AS "Company Name",
           CONVERT(real, SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 0) AS "Sales Total"
      FROM Suppliers AS s
           JOIN Products AS p 
             ON s.SupplierID = p.SupplierID
           JOIN [Order Details] AS od 
             ON p.ProductID = od.ProductID
     GROUP BY s.CompanyName
    HAVING SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) > 10000
    ORDER BY "Company Name";

    -- 3.3 List the Top 10 Customers YTD for the latest year in the Orders file. Based on total value of orders shipped. No Excel required. (10 Marks)
    SELECT TOP 10 c.CompanyName,
           CONVERT(real, SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 0) AS "Orders Total"
      FROM Customers AS c
           JOIN Orders AS o 
             ON c.CustomerID = o.CustomerID
           JOIN [Order Details] AS od 
             ON o.OrderID = od.OrderID
     WHERE YEAR(o.OrderDate) = (
           SELECT TOP 1 YEAR(o.ShippedDate)
             FROM Orders AS o 
            ORDER BY o.ShippedDate DESC)
       AND o.ShippedDate IS NOT NULL
     GROUP BY c.CompanyName
     ORDER BY "Orders Total" DESC;

    
    -- 3.4 Plot the Average Ship Time by month for all data in the Orders Table using a line chart as below. (10 Marks)
    SELECT DISTINCT LEFT(CONVERT(char, o.OrderDate, 20), 7) AS "Date",
           AVG(DATEDIFF(day, o.OrderDate, o.ShippedDate))  AS "Average Ship Time (Days)"
      FROM Orders o
     GROUP BY LEFT(CONVERT(char, o.OrderDate, 20), 7)
     ORDER BY "Date";
