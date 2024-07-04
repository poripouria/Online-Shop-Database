USE online_shop;

--SELECT ProductName, Price, BrandName, CategoryName FROM Products JOIN Brands ON Products.BrandID = Brands.BrandID JOIN Categories ON Products.CategoryID = Categories.CategoryID;

--SELECT FullName, Code, Amount, StartDate, EndDate FROM Users JOIN Discounts ON Users.DiscountID = Discounts.DiscountID;

--SELECT Date, Status, UserName, TrackingNumber, ShipDate, DeliveryDate FROM Orders JOIN Users ON Orders.UserID = Users.UserID JOIN Shipping ON Orders.ShippingID = Shipping.ShippingID;

--SELECT ReviewText, Rating, ReviewDate, UserName, ProductName FROM Reviews JOIN Users ON Reviews.UserID = Users.UserID JOIN Products ON Reviews.ProductID = Products.ProductID;

--SELECT ProductName, Price, Amount AS DiscountAmount, StartDate, EndDate FROM Products JOIN Discounts ON Products.DiscountID = Discounts.DiscountID WHERE Discounts.Amount > 20;

--SELECT ProductName, COUNT(ReviewID) AS ReviewCount FROM Products LEFT JOIN Reviews ON Products.ProductID = Reviews.ProductID GROUP BY Products.ProductName;

--SELECT ProductName, AVG(Rating) AS AverageRating FROM Reviews INNER JOIN Products ON Reviews.ProductID = Products.ProductID GROUP BY Products.ProductName;

--SELECT FullName, Address FROM Users WHERE Users.Address LIKE '%Tehran%';

SELECT ProductName FROM Products WHERE Products.ProductID NOT IN (SELECT DISTINCT ProductID FROM OrderDetails);
