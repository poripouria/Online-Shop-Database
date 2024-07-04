--CREATE DATABASE online_shop;

USE online_shop;

CREATE TABLE Admins (
    AdminID INT PRIMARY KEY  IDENTITY(20000,1),
    Username VARCHAR(50) NOT NULL,
    Password VARCHAR(50) NOT NULL,
    FullName VARCHAR(100),
    Email VARCHAR(100)
);

CREATE TABLE Discounts (
    DiscountID INT PRIMARY KEY IDENTITY(1,1),
    Code VARCHAR(50),
    Amount DECIMAL(10, 2),
    StartDate DATE,
    EndDate DATE
);

CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY(10000,1),
    Username VARCHAR(50) NOT NULL,
    Password VARCHAR(50) NOT NULL,
    FullName VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(25),
    Address VARCHAR(255),
    DiscountID INT,
    CONSTRAINT FK_User_Discount FOREIGN KEY (DiscountID) REFERENCES Discounts(DiscountID)
);

CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY IDENTITY(1,1),
    CategoryName VARCHAR(50) NOT NULL
);

CREATE TABLE Brands (
    BrandID INT PRIMARY KEY IDENTITY(1,1),
    BrandName VARCHAR(50) NOT NULL
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    ProductName VARCHAR(100) NOT NULL,
    Description TEXT,
    Price DECIMAL(10, 2) NOT NULL,
    Stock INT NOT NULL,
    CategoryID INT,
    BrandID INT,
    DiscountID INT,
    CONSTRAINT FK_Product_Category FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID),
    CONSTRAINT FK_Product_Brand FOREIGN KEY (BrandID) REFERENCES Brands(BrandID),
    CONSTRAINT FK_Product_Discount FOREIGN KEY (DiscountID) REFERENCES Discounts(DiscountID)
);

CREATE TABLE Carriers (
    CarrierID INT PRIMARY KEY IDENTITY(1,1),
    CarrierName VARCHAR(100)
);

CREATE TABLE Shipping (
    ShippingID INT PRIMARY KEY IDENTITY(1,1),
    TrackingNumber VARCHAR(50),
    ShipDate DATE,
    DeliveryDate DATE,
    CarrierID INT,
    CONSTRAINT FK_Shipping_Carrier FOREIGN KEY (CarrierID) REFERENCES Carriers(CarrierID)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    Date DATE,
    Status VARCHAR(50),
    UserID INT,
    ShippingID INT,
    CONSTRAINT FK_Order_User FOREIGN KEY (UserID) REFERENCES Users(UserID),
    CONSTRAINT FK_Order_Shipping FOREIGN KEY (ShippingID) REFERENCES Shipping(ShippingID)
);

CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY IDENTITY(1,1),
    Quantity INT NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    OrderID INT,
    ProductID INT,
    CONSTRAINT FK_OrderDetail_Order FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    CONSTRAINT FK_OrderDetail_Product FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE Cart (
    CartID INT PRIMARY KEY IDENTITY(1,1),
    CreatedDate DATE,
    UserID INT UNIQUE,
    CONSTRAINT FK_Cart_User FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

CREATE TABLE Reviews (
    ReviewID INT PRIMARY KEY IDENTITY(1,1),
    ReviewText TEXT,
    ReviewDate DATE,
    Rating INT,
    UserID INT,
    ProductID INT,
    CONSTRAINT FK_Review_User FOREIGN KEY (UserID) REFERENCES Users(UserID),
    CONSTRAINT FK_Review_Product FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
