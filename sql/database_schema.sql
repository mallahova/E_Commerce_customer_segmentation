-- The detailed explanation of this database can be foung on https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce/data
CREATE TABLE [Customers] (
  [customer_id] VARBINARY(16) NOT NULL,
  [customer_unique_id]VARBINARY(16) NOT NULL,
  [customer_zip_code_prefix] NCHAR(5) NOT NULL,
  [customer_city] NVARCHAR(64) not null,
  [customer_state] NVARCHAR(32) not null

  PRIMARY KEY ([customer_id])
)
GO


CREATE TABLE [Geolocations] (
  [geolocation_zip_code_prefix] NCHAR(5) NOT NULL,
  [geolocation_lat] NUMERIC(20,18) NOT NULL,
  [geolocation_lng] NUMERIC(20,17) NOT NULL,
  [customer_city] NVARCHAR(64) NOT NULL,
  [customer_state] NVARCHAR(32) NOT NULL,
)
GO

CREATE TABLE [Order_Items] (
  [order_id] VARBINARY(16) NOT NULL,
  [order_item_id] TINYINT NOT NULL,
  [product_id] VARBINARY(16) NOT NULL,
  [seller_id] VARBINARY(16) NOT NULL,
  [shipping_limit_date] DATETIME NOT NULL,
  [price] MONEY NOT NULL,
  [freight_value] DECIMAL(8,2) NOT NULL,
  PRIMARY KEY ([order_id],[order_item_id], [product_id],[seller_id])
)
GO

CREATE TABLE [Order_Payments] (
  [order_id] VARBINARY(16) NOT NULL,
  [payment_sequential] TINYINT NOT NULL,
  [payment_type] NVARCHAR(16) NOT NULL,
  [payment_installments] TINYINT NOT NULL,
  [payment_value] MONEY NOT NULL,
  PRIMARY KEY ([order_id],payment_sequential)
)
GO

CREATE TABLE [Order_Reviews] (
  [review_id] VARBINARY(16) NOT NULL,
  [order_id] VARBINARY(16) NOT NULL,
  [review_score] TINYINT NOT NULL,
  [review_comment_title] NVARCHAR(100),
  [review_comment_message] NVARCHAR(MAX),
  [review_creation_date] DATETIME NOT NULL,
  [review_answer_timestamp] DATETIME NOT NULL,
  PRIMARY KEY ([review_id], [order_id])
)
GO

CREATE TABLE [Orders] (
  [order_id] VARBINARY(16) NOT NULL,
  [customer_id] VARBINARY(16) NOT NULL,
  [order_status] NVARCHAR(16) NOT NULL,
  [order_purchase_timestamp] DATETIME NOT NULL,
  [order_approved_at] DATETIME,
  [order_delivered_carrier_date] DATETIME,
  [order_delivered_customer_date] DATETIME,
  [order_estimated_delivery_date] DATETIME,
  PRIMARY KEY ([order_id])
)
GO

CREATE TABLE [Products] (
  [product_id] VARBINARY(16) NOT NULL,
  [product_category_name] NVARCHAR(64),
  [product_name_lenght] TINYINT,
  [product_description_lenght] INT,
  [product_photos_qty] TINYINT,
  [product_weight_g] DECIMAL(8,2),
  [product_length_cm] DECIMAL(5,2),
  [product_height_cm] DECIMAL(5,2),
  [product_width_cm] DECIMAL(5,2),
  PRIMARY KEY ([product_id])
)
GO

CREATE TABLE [Sellers] (
  [seller_id] VARBINARY(16) NOT NULL,
  [seller_zip_code_prefix] NCHAR(5) NOT NULL,
  [seller_city] NVARCHAR(64) NOT NULL,
  [seller_state] NVARCHAR(32) NOT NULL
  PRIMARY KEY ([seller_id])
)
GO

CREATE TABLE [Category_Translations] (
  [product_category_name] NVARCHAR(64),
  [product_category_name_english] NVARCHAR(64),
  PRIMARY KEY ([product_category_name])
)
GO

ALTER TABLE [Order_Payments] ADD FOREIGN KEY ([order_id]) REFERENCES [Orders] ([order_id]) ON DELETE CASCADE
GO

ALTER TABLE [Orders] ADD FOREIGN KEY ([customer_id]) REFERENCES [Customers] ([customer_id]) ON DELETE CASCADE
GO

ALTER TABLE [Order_Items] ADD CONSTRAINT [Orders_order_id_Order_Items] FOREIGN KEY ([order_id]) REFERENCES [Orders] ([order_id]) ON DELETE CASCADE
GO

ALTER TABLE [Order_Reviews] ADD CONSTRAINT [Orders_order_id_Order_Reviews] FOREIGN KEY ([order_id]) REFERENCES [Orders] ([order_id]) ON DELETE CASCADE
GO

ALTER TABLE [Order_Items] ADD CONSTRAINT [Products_product_id_Order_Items] FOREIGN KEY ([product_id]) REFERENCES [Products] ([product_id]) 
GO

ALTER TABLE [Order_Items] ADD CONSTRAINT [Sellers_seller_id_Order_Items] FOREIGN KEY ([seller_id]) REFERENCES [Sellers] ([seller_id]) 
GO



-- This trigger manages the payment_sequential column, which tracks the sequence of payments made by a customer for an order.
-- In cases where a customer pays for an order using multiple payment methods, a sequence is created to organize and accommodate each payment method effectively.
IF OBJECT_ID('Update_Payment_Sequential', 'T') IS NOT NULL
    DROP TRIGGER Update_Payment_Sequential;
GO

CREATE TRIGGER Update_Payment_Sequential
ON Order_Payments
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @order_id VARBINARY(16);    
    DECLARE @CurrentSequential TINYINT;
    DECLARE @payment_type NVARCHAR(16) 
    DECLARE @payment_installments TINYINT 
    DECLARE @payment_value MONEY 
    DECLARE currData CURSOR FOR
    SELECT order_id, payment_type, payment_installments, payment_value FROM inserted
    OPEN currData

    FETCH currData INTO @order_id, @payment_type, @payment_installments, @payment_value 

    WHILE(@@FETCH_STATUS = 0)
        BEGIN
    
        SELECT @CurrentSequential = ISNULL(MAX(payment_sequential), 0)
        FROM Order_Payments
        WHERE order_id = @order_id;
        
        INSERT INTO Order_Payments (order_id, payment_sequential, payment_type, payment_installments, payment_value)
        SELECT @order_id,@CurrentSequential + 1,  @payment_type, @payment_installments, @payment_value
        FETCH currData INTO @order_id, @payment_type, @payment_installments, @payment_value 
        END
    CLOSE currData
    DEALLOCATE currData
END;



INSERT INTO Order_Payments (order_id, payment_sequential, payment_type, payment_installments, payment_value)
VALUES (0xBFBD0F9BDEF84302105AD712DB648A6C,0, 'debit_card' ,0, 72.19),
(0xBFBD0F9BDEF84302105AD712DB648A6C,0, 'credit_card' ,2, 72.19)





