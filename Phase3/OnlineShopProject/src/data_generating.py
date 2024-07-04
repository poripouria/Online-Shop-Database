import pyodbc
import random
import os
from faker import Faker
import pandas as pd
import requests
from bs4 import BeautifulSoup

def scrape_products(url):
    response = requests.get(url)
    soup = BeautifulSoup(response.text, 'html.parser')
    
    products = []
    for item in soup.select('.product'):
        name = item.select_one('.product-name').text
        description = item.select_one('.product-description').text
        price = float(item.select_one('.product-price').text.replace('$', ''))
        stock = int(item.select_one('.product-stock').text)
        
        product = {
            'ProductName': name,
            'Description': description,
            'Price': price,
            'Stock': stock
        }
        products.append(product)
    
    return products

def connect_to_database(server_name, database_name):
    connection = None
    try:
        connection = pyodbc.connect(
            f'DRIVER={{ODBC Driver 17 for SQL Server}};SERVER={server_name};DATABASE={database_name};Trusted_Connection=yes;'
        )
        print("Connection to SQL Server DB successful")
    except pyodbc.Error as e:
        print(f"The error '{e}' occurred")
    return connection

def insert_data_from_csv(connection, csv_file, table_name):
    cursor = connection.cursor()
    data = pd.read_csv(csv_file)
    columns = ", ".join(data.columns)
    placeholders = ", ".join(["?"] * len(data.columns))
    for index, row in data.iterrows():
        sql = f"INSERT INTO {table_name} ({columns}) VALUES ({placeholders})"
        cursor.execute(sql, tuple(row))
    print("*** Records inserted into", table_name)
    connection.commit()

def generate_fake_data(csv_files):
    faker = Faker()
    data_dict = {}

    # Generate fake data for each type
    data_dict['Admins'] = [{'Username': faker.user_name(), 'Password': faker.password(), 'FullName': faker.name(), 'Email': faker.email()} 
                           for _ in range(5)]
    data_dict['Discounts'] = [{'Code': faker.lexify(text='?????_#####'), 'Amount': round(random.uniform(5.0, 30.0), 2), 'StartDate': faker.date_between(start_date='-1y', end_date='today'), 'EndDate': faker.date_between(start_date='today', end_date='+1y')} 
                              for _ in range(5)]
    data_dict['Users'] = [{'Username': faker.user_name(), 'Password': faker.password(), 'FullName': faker.name(), 'Email': faker.email(), 'Phone': faker.phone_number(), 'Address': faker.address()} 
                          for _ in range(30)]
    data_dict['Categories'] = [{'CategoryName': category} for category in ["Electronics", "Clothing", "Books", "Sports", "Toys"]]
    data_dict['Brands'] = [{'BrandName': brand} for brand in ["Sony", "Samsung", "Nike", "Adidas", "Apple"]]
    data_dict['Products'] = [{'ProductName': faker.word(), 'Description': faker.text(), 'Price': round(random.uniform(10.0, 1000.0), 2), 'Stock': random.randint(1, 100), 'CategoryID': random.randint(1, 5), 'BrandID': random.randint(1, 5)} 
                             for _ in range(15)]
    data_dict['Shipping'] = [{'TrackingNumber': faker.uuid4(), 'ShipDate': faker.date_this_year(), 'DeliveryDate': faker.date_this_year()} 
                             for _ in range(10)]

    # Create dataframes and save to csv files
    for key, data in data_dict.items():
        df = pd.DataFrame(data)
        df.to_csv(csv_files[key], mode='a', header=True, index=False)
        print(f"Data {key} has been added to {csv_files[key]}")
            
if __name__ == "__main__":
    csv_files = {
                 "Admins": "./data/admins.csv", 
                 "Discounts": "./data/discounts.csv", 
                 "Users": "./data/users.csv", 
                 "Categories": "./data/categories.csv", 
                 "Brands": "./data/brands.csv", 
                 "Products": "./data/products.csv",
                 "Shipping": "./data/shipping.csv",
                }
    table_names = [
                   "Admins", "Discounts", "Users", "Categories", 
                   "Brands", "Products", "Shipping"
                  ]
    generate_fake_data(csv_files)
    
    connection = connect_to_database("Poripouria\\SQLEXPRESS", "online_shop")

    if connection:
        for table in table_names:
            print("Inserting...", table, "\tCSV:", csv_files[table])
            insert_data_from_csv(connection, csv_files[table], table)
        connection.close()
        print("Connection closed")
