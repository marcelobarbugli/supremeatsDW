CREATE TABLE mydb.fact_FactSales (
    OrderID INT,
    ProductName VARCHAR(50),
    CustomerID INT,
    EmployeeID INT,
    ShipperID INT,
    OrderDate DATE,
    Quantity INT,
    UnitPrice DECIMAL(10,2),
    Discount DECIMAL(10,2),
    Revenue DECIMAL(10,2),
    PRIMARY KEY (OrderID, ProductName)
);


INSERT INTO mydb.fact_FactSales (OrderID, ProductName, CustomerID, EmployeeID, ShipperID, OrderDate, Quantity, UnitPrice, Discount, Revenue)
SELECT 
    o.OrderID,
    of.ProductName,
    o.SKCustomerID,
    o.SKEmployeeID,
    d.SKShipperID,
    o.OrderDate,
    od.Quantity,
    od.UnitPrice,
    od.Discount,
    (od.Quantity * od.UnitPrice * (1 - od.Discount / 100)) AS Revenue
FROM 
    mydb.dw_order o
JOIN 
    mydb.dw_order_detail od ON o.OrderID = od.OrderID
JOIN 
    mydb.dw_product of ON of.SKProductID = od.SKProductID
JOIN 
    mydb.dw_delivery d ON o.OrderID = d.OrderID;

## Número de Pedidos em Períodos Específicos:
SELECT DISTINCT COUNT(*) AS NumberOfOrders, OrderDate
FROM mydb.fact_FactSales
GROUP BY OrderDate;