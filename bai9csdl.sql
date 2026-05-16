CREATE DATABASE SalesManagement;
USE SalesManagement;

CREATE TABLE Stores (
    StoreID INT PRIMARY KEY AUTO_INCREMENT,
    StoreName NVARCHAR(255) NOT NULL
);

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerName NVARCHAR(255) NOT NULL
);

CREATE TABLE Sales (
    SaleID INT PRIMARY KEY AUTO_INCREMENT,
    SaleDate DATE NOT NULL,
    StoreID INT,
    CustomerID INT,
    TotalAmount DECIMAL(12,2),

    CONSTRAINT fk_sales_store
        FOREIGN KEY (StoreID)
        REFERENCES Stores(StoreID),

    CONSTRAINT fk_sales_customer
        FOREIGN KEY (CustomerID)
        REFERENCES Customers(CustomerID)
);

CREATE TABLE SalesDetails (
    SaleDetailID INT PRIMARY KEY AUTO_INCREMENT,
    SaleID INT,
    ProductID INT,
    Quantity INT,
    UnitPrice DECIMAL(12,2),

    CONSTRAINT fk_salesdetails_sale
        FOREIGN KEY (SaleID)
        REFERENCES Sales(SaleID)
);

INSERT INTO Stores (StoreName) VALUES
('Ha Noi Store'),
('Da Nang Store'),
('Ho Chi Minh Store'),
('Hai Phong Store'),
('Can Tho Store');

INSERT INTO Customers (CustomerName) VALUES
('Nguyen Van A'),
('Tran Thi B'),
('Le Van C'),
('Pham Thi D'),
('Hoang Van E'),
('Vo Thi F'),
('Dang Van G');

INSERT INTO Sales (SaleDate, StoreID, CustomerID, TotalAmount) VALUES
('2024-01-15', 1, 1, 1200),
('2024-02-10', 1, 2, 2500),
('2024-03-22', 2, 3, 3200),
('2024-04-05', 3, 4, 1800),
('2024-05-18', 5, 5, 4500),
('2024-06-12', 5, 1, 5200),
('2024-07-20', 2, 6, 2900),
('2024-08-01', 3, 7, 4100),
('2024-09-09', 4, 2, 1500),
('2024-10-25', 5, 3, 6100),
('2025-01-12', 1, 4, 7200),
('2025-02-14', 2, 5, 8300),
('2025-03-08', 3, 6, 9100),
('2025-04-17', 4, 7, 6400),
('2025-05-21', 5, 1, 7800);

INSERT INTO SalesDetails (SaleID, ProductID, Quantity, UnitPrice) VALUES
(1, 101, 2, 300),
(1, 102, 3, 200),
(2, 101, 5, 300),
(2, 103, 2, 500),
(3, 104, 4, 400),
(3, 105, 2, 800),
(4, 101, 1, 300),
(4, 106, 3, 500),
(5, 107, 5, 400),
(5, 108, 2, 1250),
(6, 101, 4, 300),
(6, 109, 2, 2000),
(7, 110, 3, 700),
(7, 102, 4, 200),
(8, 103, 5, 500),
(8, 104, 2, 800),
(9, 105, 1, 1500),
(10, 101, 7, 300),
(10, 108, 3, 1300),
(11, 102, 10, 250),
(11, 109, 2, 2350),
(12, 103, 5, 600),
(12, 110, 4, 1325),
(13, 104, 6, 700),
(13, 105, 3, 1633),
(14, 106, 5, 800),
(14, 107, 4, 600),
(15, 108, 3, 1600),
(15, 109, 2, 1500);

SELECT 
    st.StoreID,
    st.StoreName,
    SUM(s.TotalAmount) AS Revenue
FROM Sales s
JOIN Stores st
    ON s.StoreID = st.StoreID
WHERE QUARTER(s.SaleDate) = QUARTER(CURDATE())
    AND YEAR(s.SaleDate) = YEAR(CURDATE())
GROUP BY st.StoreID, st.StoreName
ORDER BY Revenue DESC
LIMIT 3;

SELECT 
    sd.ProductID,
    SUM(sd.Quantity * sd.UnitPrice) AS ProductRevenue,
    ROUND(
        SUM(sd.Quantity * sd.UnitPrice) * 100 /
        (SELECT SUM(sd2.Quantity * sd2.UnitPrice)
		FROM Sales s2
		JOIN SalesDetails sd2
		ON s2.SaleID = sd2.SaleID
		WHERE s2.StoreID = 5 AND YEAR(s2.SaleDate) = YEAR(CURDATE()) - 1),2) 
        AS ContributionRate
FROM Sales s
JOIN SalesDetails sd
    ON s.SaleID = sd.SaleID
WHERE s.StoreID = 5
    AND YEAR(s.SaleDate) = YEAR(CURDATE()) - 1
GROUP BY sd.ProductID
ORDER BY ProductRevenue DESC;

SELECT 
    c.CustomerID,
    c.CustomerName,
    COUNT(s.SaleID) AS TotalOrders,
    SUM(s.TotalAmount) AS TotalSpent

FROM Customers c
JOIN Sales s
    ON c.CustomerID = s.CustomerID
WHERE YEAR(s.SaleDate) = 2024
GROUP BY c.CustomerID, c.CustomerName
HAVING SUM(s.TotalAmount) > 10000
ORDER BY TotalSpent DESC,
         TotalOrders DESC;

CREATE INDEX idx_sales_saledate
ON Sales(SaleDate);

CREATE INDEX idx_sales_storeid
ON Sales(StoreID);

CREATE INDEX idx_sales_customerid
ON Sales(CustomerID);

CREATE INDEX idx_sales_store_date
ON Sales(StoreID, SaleDate);

CREATE INDEX idx_salesdetails_saleid
ON SalesDetails(SaleID);

CREATE INDEX idx_salesdetails_productid
ON SalesDetails(ProductID);

EXPLAIN SELECT 
    c.CustomerID,
    c.CustomerName,
    COUNT(s.SaleID) AS TotalOrders,
    SUM(s.TotalAmount) AS TotalSpent
FROM Customers c
JOIN Sales s
    ON c.CustomerID = s.CustomerID
WHERE s.SaleDate >= '2024-01-01'
    AND s.SaleDate < '2025-01-01'
GROUP BY c.CustomerID, c.CustomerName
HAVING SUM(s.TotalAmount) > 10000
ORDER BY TotalSpent DESC;