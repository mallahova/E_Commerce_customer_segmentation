IF OBJECT_ID('Total_Sales_Amount_by_Category', 'V') IS NOT NULL
    DROP VIEW Total_Sales_Amount_by_Category;
GO

CREATE VIEW Total_Sales_Amount_by_Category AS
SELECT COALESCE(t.product_category_name_english, 'other') AS product_category_name_english,
        SUM(oi.price*oi.order_item_id) AS Total_Sales_Amount,COUNT(oi.product_id) AS Sales_Count
FROM Products p
LEFT JOIN Category_Translations t ON p.product_category_name = t.product_category_name
LEFT JOIN Order_Items oi ON oi.product_id = p.product_id 
GROUP BY COALESCE(t.product_category_name_english, 'other')
GO

SELECT TOP 10 product_category_name_english, Total_Sales_Amount FROM Total_Sales_Amount_by_Category
ORDER BY Total_Sales_Amount DESC;

GO

SELECT TOP 10 product_category_name_english, Sales_Count FROM Total_Sales_Amount_by_Category
ORDER BY Sales_Count DESC;



IF OBJECT_ID('Total_Sales_Amount_by_City', 'V') IS NOT NULL
    DROP VIEW Total_Sales_Amount_by_City;
GO

CREATE VIEW Total_Sales_Amount_by_City AS
SELECT customer_city, customer_state, SUM(op.payment_value) Total_Sales_Amount
FROM Customers c JOIN Orders o ON c.customer_id=o.customer_id JOIN Order_Payments op ON o.order_id=op.order_id  
GROUP BY customer_city, customer_state
GO

SELECT TOP 10 * FROM Total_Sales_Amount_by_City
ORDER BY Total_Sales_Amount DESC;

IF OBJECT_ID('Total_Sales_Amount_by_State', 'V') IS NOT NULL
    DROP VIEW Total_Sales_Amount_by_State;
GO

CREATE VIEW Total_Sales_Amount_by_State AS
SELECT customer_state, SUM(op.payment_value) Total_Sales_Amount
FROM Customers c JOIN Orders o ON c.customer_id=o.customer_id JOIN Order_Payments op ON o.order_id=op.order_id  
GROUP BY customer_state
GO

SELECT TOP 10 * FROM Total_Sales_Amount_by_State
ORDER BY Total_Sales_Amount DESC;



IF OBJECT_ID('Average_Review_Score_by_Seller', 'V') IS NOT NULL
    DROP VIEW Average_Review_Score_by_Seller;
GO

CREATE VIEW Average_Review_Score_by_Seller AS
SELECT oi.seller_id,COUNT(oi.order_id) Orders_Count, AVG(CAST(orv.review_score AS NUMERIC(6,5)))Average_Score,COUNT(orv.review_score) Review_Count
FROM Sellers s LEFT JOIN Order_Items oi ON s.seller_id=oi.seller_id LEFT JOIN Order_Reviews orv ON orv.order_id=oi.order_id 
GROUP BY oi.seller_id
GO

-- Query the newly created view
SELECT * FROM Average_Review_Score_by_Seller
ORDER BY  Average_Score DESC,Review_Count DESC




IF OBJECT_ID('Top_Selling_Products', 'V') IS NOT NULL
    DROP VIEW Top_Selling_Products;
GO

CREATE VIEW Top_Selling_Products AS
SELECT p.product_id,p.product_category_name, SUM(oi.price*oi.order_item_id) AS Total_Sales_Amount,COUNT(oi.product_id) AS Sales_Count
FROM Products p
LEFT JOIN Order_Items oi ON oi.product_id = p.product_id 
GROUP BY p.product_id,p.product_category_name
GO

SELECT TOP 10 * FROM Top_Selling_Products
ORDER BY Sales_Count DESC, Total_Sales_Amount DESC;


IF OBJECT_ID('Total_Orders', 'V') IS NOT NULL
    DROP VIEW Total_Orders;
GO

CREATE VIEW Total_Orders AS
SELECT COUNT(order_id) Total_Orders
FROM Orders;
GO

SELECT * FROM Total_Orders

IF OBJECT_ID('Total_Sales', 'V') IS NOT NULL
    DROP VIEW Total_Sales;
GO

CREATE VIEW Total_Sales AS
SELECT SUM(price*order_item_id) Total_Sales
FROM Order_Items;
GO

SELECT * FROM Total_Sales


IF OBJECT_ID('Average_Order_Value', 'V') IS NOT NULL
    DROP VIEW Average_Order_Value;
GO

CREATE VIEW Average_Order_Value AS
SELECT Total_Sales/Total_Orders Average_Order_Value
FROM Total_Sales,Total_Orders;
GO

SELECT * FROM Average_Order_Value


IF OBJECT_ID('Total_Items', 'V') IS NOT NULL
    DROP VIEW Total_Items;
GO

CREATE VIEW Total_Items AS
SELECT COUNT(product_id) Total_Items
FROM Products;
GO

SELECT * FROM Total_Items

GO


IF OBJECT_ID('Average_Score_By_Product', 'V') IS NOT NULL
    DROP VIEW Average_Score_By_Product;
GO

CREATE VIEW Average_Score_By_Product AS
SELECT p.product_id, AVG(review_score) Average_Score,  CAST(COUNT(CASE WHEN orv.review_score = 5 THEN orv.review_id END) AS NUMERIC(10,5))/COUNT(orv.review_id) AS [Five_Star_Reviews_%], COUNT(orv.review_id) AS Total_Reviews
FROM Products p JOIN Order_Items oi ON p.product_id=oi.product_id JOIN Order_Reviews orv ON orv.order_id=oi.order_id
GROUP BY p.product_id
GO

SELECT * FROM Average_Score_By_Product
ORDER BY Average_Score DESC, Total_Reviews DESC

GO



IF OBJECT_ID('Average_Orders_By_Customers', 'V') IS NOT NULL
    DROP VIEW Average_Orders_By_Customers;
GO

CREATE VIEW Average_Orders_By_Customers AS
SELECT c.customer_id, COUNT(o.order_id) Total_Orders, AVG(op.payment_value) Average_Payment, SUM(op.payment_value) Total_Payment, AVG(CAST(orv.review_score AS NUMERIC(10,5))) Average_Score
FROM Customers c LEFT JOIN Orders o ON c.customer_id=o.customer_id JOIN Order_Payments op ON op.order_id=o.order_id LEFT JOIN Order_Reviews orv ON orv.order_id=o.order_id 
GROUP BY c.customer_id
GO

SELECT * FROM Average_Orders_By_Customers
ORDER BY Total_Orders DESC

GO

SELECT AVG(CAST(Total_Orders AS NUMERIC(10,5))) Average_Total_Orders, AVG(Average_Payment) Average_Payment , AVG(Total_Payment) Average_Total_Payment 
FROM Average_Orders_By_Customers


GO 


IF OBJECT_ID('Product_Counts_Per_Category', 'V') IS NOT NULL
    DROP VIEW Product_Counts_Per_Category;
GO

CREATE VIEW Product_Counts_Per_Category AS
SELECT ct.product_category_name_english, COUNT(p.product_id) Product_Count
FROM Products p JOIN Category_Translations ct ON p.product_category_name=ct.product_category_name
GROUP BY ct.product_category_name_english

GO

SELECT *
FROM Product_Counts_Per_Category
ORDER BY Product_Count DESC

GO

IF OBJECT_ID('Total_Sales_By_Month', 'V') IS NOT NULL
    DROP VIEW Total_Sales_By_Month;
GO

CREATE VIEW Total_Sales_By_Month AS
SELECT MONTH(order_purchase_timestamp) Month, YEAR(order_purchase_timestamp) Year, SUM(op.payment_value) Total_Sales, COUNT(o.order_id) Total_Orders
FROM Orders o JOIN Order_Payments op ON o.order_id=OP.order_id
GROUP BY 
     YEAR(order_purchase_timestamp),MONTH(order_purchase_timestamp)
GO

SELECT *
FROM Total_Sales_By_Month
ORDER BY Year DESC, Month DESC


IF OBJECT_ID('Payment_Type_Count_By_Month', 'V') IS NOT NULL
    DROP VIEW Payment_Type_Count_By_Month;
GO

CREATE VIEW Payment_Type_Count_By_Month AS
SELECT op.payment_type,MONTH(order_purchase_timestamp) Month, YEAR(order_purchase_timestamp) Year, SUM(op.payment_value) Total_Sales, COUNT(o.order_id) Total_Orders
FROM Orders o JOIN Order_Payments op ON o.order_id=OP.order_id
GROUP BY 
     YEAR(order_purchase_timestamp),MONTH(order_purchase_timestamp), op.payment_type
GO

SELECT *
FROM Payment_Type_Count_By_Month
WHERE (Year<2018 OR Month<9)
ORDER BY Year DESC, Month DESC


IF OBJECT_ID('Total_Sales_By_Month_By_State', 'V') IS NOT NULL
    DROP VIEW Total_Sales_By_Month_By_State;
GO

CREATE VIEW Total_Sales_By_Month_By_State AS
SELECT MONTH(order_purchase_timestamp) Month, YEAR(order_purchase_timestamp) Year, c.customer_state,SUM(op.payment_value) Total_Sales, COUNT(o.order_id) Total_Orders
FROM Orders o JOIN Order_Payments op ON o.order_id=OP.order_id JOIN Customers c ON c.customer_id=o.customer_id
GROUP BY 
     YEAR(order_purchase_timestamp),MONTH(order_purchase_timestamp), c.customer_state
GO

SELECT *
FROM Total_Sales_By_Month_By_State
WHERE  customer_state IN 
(
SELECT TOP 10 customer_state FROM Total_Sales_Amount_by_State

) AND (Year<2018 OR Month<9)
ORDER BY Year DESC, Month DESC



IF OBJECT_ID('Total_Sales_By_Day', 'V') IS NOT NULL
    DROP VIEW Total_Sales_By_Day;
GO

CREATE VIEW Total_Sales_By_Day AS
SELECT  DAY(order_purchase_timestamp) Day, MONTH(order_purchase_timestamp) Month, YEAR(order_purchase_timestamp) Year, SUM(op.payment_value) Total_Sales, COUNT(o.order_id) Total_Orders
FROM Orders o JOIN Order_Payments op ON o.order_id=OP.order_id
GROUP BY 
      YEAR(order_purchase_timestamp),MONTH(order_purchase_timestamp),DAY(order_purchase_timestamp)
GO

SELECT *
FROM Total_Sales_By_Day
ORDER BY Year DESC, Month DESC, Day DESC



IF OBJECT_ID('Order_Items_Amount_Frequency', 'V') IS NOT NULL
    DROP VIEW Order_Items_Amount_Frequency;
GO

CREATE VIEW Order_Items_Amount_Frequency AS
SELECT Items_Amount, COUNT(*) Frequency
FROM(
SELECT SUM(order_item_id) Items_Amount
FROM Order_Items
GROUP BY order_id) res
GROUP BY Items_Amount
GO

SELECT *
FROM Order_Items_Amount_Frequency
ORDER BY Frequency DESC



IF OBJECT_ID('Payment_Type_Count', 'V') IS NOT NULL
    DROP VIEW Payment_Type_Count;
GO

CREATE VIEW Payment_Type_Count AS
SELECT payment_type,COUNT(*) Frequency
FROM Order_Payments op
GROUP BY op.payment_type
GO

SELECT *
FROM Payment_Type_Count
ORDER BY Frequency DESC


IF OBJECT_ID('Delivery_Days_Statictics', 'V') IS NOT NULL
    DROP VIEW Delivery_Days_Statictics;
GO

CREATE VIEW Delivery_Days_Statictics AS
SELECT 
    order_id,DATEDIFF(day, order_approved_at,order_delivered_customer_date) AS Actual_Delivery_Days, DATEDIFF(day, order_approved_at,order_estimated_delivery_date) AS Estimated_Delivery_Days
FROM 
    Orders
    WHERE order_approved_at IS NOT NULL AND order_delivered_customer_date IS NOT NULL AND order_estimated_delivery_date IS NOT NULL
GO

SELECT *
FROM Delivery_Days_Statictics
WHERE Actual_Delivery_Days >=0 AND Estimated_Delivery_Days >=0



IF OBJECT_ID('Recency', 'V') IS NOT NULL
    DROP VIEW Recency;
GO

CREATE VIEW Recency AS
SELECT 
    customer_unique_id,DATEDIFF(day,MAX( order_purchase_timestamp),'2018-09-01' )AS Recency
FROM 
    Orders o JOIN Customers c ON o.customer_id=c.customer_id
    WHERE order_purchase_timestamp<'2018-09-01'
    GROUP BY customer_unique_id
GO

SELECT *
FROM Recency
Order by Recency 




IF OBJECT_ID('Frequency', 'V') IS NOT NULL
    DROP VIEW Frequency;
GO

CREATE VIEW Frequency AS
SELECT 
    customer_unique_id, COUNT(order_id) AS Frequency
FROM    Orders o JOIN Customers c ON o.customer_id=c.customer_id

    GROUP BY customer_unique_id
GO

SELECT *
FROM Frequency
Order by Frequency DESC

GO

SELECT Frequency, COUNT(*) Count
FROM Frequency
GROUP BY Frequency



IF OBJECT_ID('Monetary', 'V') IS NOT NULL
    DROP VIEW Monetary;
GO

CREATE VIEW Monetary AS
SELECT 
    customer_unique_id,SUM(oi.order_item_id*oi.price) AS Monetary
FROM 
    Orders o JOIN Customers c ON o.customer_id=c.customer_id JOIN Order_Items oi ON o.order_id=oi.order_id
    GROUP BY customer_unique_id
GO

SELECT *
FROM Monetary
Order by Monetary DESC


SELECT r.customer_unique_id, Recency, Frequency, Monetary
FROM Recency r JOIN Frequency f ON  r.customer_unique_id=f.customer_unique_id JOIN Monetary m ON m.customer_unique_id=r.customer_unique_id 
ORDER BY Recency ASC

GO

IF OBJECT_ID('GetProductStatistics', 'P') IS NOT NULL
    DROP PROCEDURE GetProductStatistics;
GO

CREATE PROCEDURE GetProductStatistics(@product_id VARBINARY(16))
AS
SELECT @product_id Product_ID, AVG(review_score) Average_Score,CAST(COUNT(CASE WHEN orv.review_score = 5 THEN orv.review_id END) AS NUMERIC(10,5))/COUNT(orv.review_id) AS [Five_Star_Reviews_%], COUNT(orv.review_id) AS Total_Reviews
FROM Products p JOIN Order_Items oi ON p.product_id=oi.product_id JOIN Order_Reviews orv ON orv.order_id=oi.order_id
WHERE p.product_id=@product_id
GO

GO

EXEC GetProductStatistics 0x37EB69ACA8718E843D897AA7B82F462D




