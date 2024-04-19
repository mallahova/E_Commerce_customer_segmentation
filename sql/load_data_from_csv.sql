BULK
INSERT Category_Translations
FROM  '/var/opt/mssql/data/archive/product_category_name_translation.csv'
WITH
(
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\r\n',
FIRSTROW = 2
)
GO



BULK
INSERT Customers
FROM  '/var/opt/mssql/data/archive/olist_customers_dataset.csv'
WITH
(
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n',
FIRSTROW = 2
)
GO


BULK
INSERT Geolocations
FROM  '/var/opt/mssql/data/archive/olist_geolocation_dataset.csv'
WITH
(
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n',
FIRSTROW = 2
)
GO

BULK
INSERT Order_Items
FROM  '/var/opt/mssql/data/archive/olist_order_items_dataset.csv'
WITH
(
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n',
FIRSTROW = 2
)
GO

BULK
INSERT Order_Payments
FROM  '/var/opt/mssql/data/archive/olist_order_payments_dataset.csv'
WITH
(
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n',
FIRSTROW = 2
)
GO

BULK
INSERT Order_Reviews
FROM  '/var/opt/mssql/data/archive/olist_order_reviews_dataset_fixed.csv'
WITH
(
FIELDTERMINATOR = '}',
ROWTERMINATOR = '\n',
FIRSTROW = 2
)
GO


BULK
INSERT Orders
FROM  '/var/opt/mssql/data/archive/olist_orders_dataset.csv'
WITH
(
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n',
FIRSTROW = 2
)
GO




BULK
INSERT Products
FROM  '/var/opt/mssql/data/archive/olist_products_dataset.csv'
WITH
(
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n',
FIRSTROW = 2
)
GO


BULK
INSERT Sellers
FROM  '/var/opt/mssql/data/archive/olist_sellers_dataset.csv'
WITH
(
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n',
FIRSTROW = 2
)
GO


