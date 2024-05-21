import gspread
from oauth2client.service_account import ServiceAccountCredentials
import pandas as pd
from sqlalchemy import create_engine, Date, VARCHAR, INT, DECIMAL



# Set up the connection to Google Sheets and Drive APIs to fetch data from Products table 
scope = ["https://spreadsheets.google.com/feeds", "https://www.googleapis.com/auth/drive"]
creds = ServiceAccountCredentials.from_json_keyfile_name("SecretKey.json",scope)
client = gspread.authorize(creds)




#################################################### UNIFORM #########################################################

# Open the Uniform Google Sheet using its title or URL
Product_gsheet = client.open_by_url('https://docs.google.com/spreadsheets/d/1RMb7mvlysfRnweLG9sa9MDDcp4o0j0sEeJvmXq-pyzc/edit#gid=569488832').sheet1

# Read data from the sheet into a Pandas DataFrame
data = Product_gsheet.get_all_records()
df = pd.DataFrame(data)
#print(df)
 
# Print column names
print("Column Names:")
print(df.columns)

# Initialize an empty list to store the formatted rows
formatted_rows = []

# Iterate through each row of the dataframe
for index, row in df.iterrows():
    # Extract relevant information from the row
    products = row['Products']
    material = row['Material']
    cp_columns = [col for col in df.columns if '/CP/SP' in col]  # Extract CP columns
    color_column = 'Colors'


    # Iterate through CP columns
    for cp_column in cp_columns:
        size = cp_column.split('/')[0]  # Extract size from column name
        cp_sp_values = row[cp_column].split('/')  # Extract CP and SP values
        cp = cp_sp_values[0]  # CP value
        sp = cp_sp_values[1] if len(cp_sp_values) > 1 else None  # SP value if available, else None
        colors = row[color_column].split(',')  # Extract Colors

        # Iterate through Colors
        for color in colors:
            # Create a formatted row and append it to the list
            formatted_row = [size, products, material, cp, sp, color]
            formatted_rows.append(formatted_row)

# Create a new dataframe from the formatted rows
formatted_df = pd.DataFrame(formatted_rows, columns=['Size', 'Products', 'Material', 'CP', 'SP', 'Color'])

# Save the formatted dataframe to a new CSV file
formatted_df.to_csv('Products_formatted_file.csv', index=False)

# Display the formatted dataframe
print(formatted_df)

# Creating SQLAlchemy engine
engine = create_engine(
    r"mssql+pyodbc://dev:Shubham150@localhost\MSSQLSERVER01/Skool?driver=SQL+Server",
    use_setinputsizes=False  # Adding this line to disable automatic input size setting
)


# Specify the data types for each column
dtype_mapping = {
    'Size': INT,
    'Products': VARCHAR(245),
    'Material': VARCHAR(245),
    'CP': INT(),
    'SP': INT(),
    'Color': VARCHAR(20)
}

# actual name of  SQL Server table
table_name = 'Product_uniform'

# Use the `to_sql` method to insert the DataFrame into the SQL Server table
formatted_df.to_sql(table_name, con=engine, index=False, if_exists='replace', dtype=dtype_mapping)

# Attempt to insert data into the SQL Server table
try:
    formatted_df.to_sql(table_name, con=engine, index=False, if_exists='replace', dtype=dtype_mapping)
    print("Data imported successfully into the '{}' table.".format(table_name))

except:
    print("Error importing data into the '{}' table.".format(table_name))






################################################# SHOES ###############################################3

# Open the Shoes Google Sheet using its title or URL
Product_gsheet = client.open_by_url('https://docs.google.com/spreadsheets/d/1RMb7mvlysfRnweLG9sa9MDDcp4o0j0sEeJvmXq-pyzc/edit#gid=569488832').get_worksheet(1)

# Read data from the sheet into a Pandas DataFrame
data = Product_gsheet.get_all_records()
df = pd.DataFrame(data)
#print(df)

# Print column names
#print("Column Names:")
#print(df.columns)

# Initialize an empty list to store the formatted rows
formatted_rows = []

# Iterate through each row of the dataframe
for index, row in df.iterrows():
    # Extract relevant information from the row
    products = row['Products']
    material = row['Material']
    brand    = row['Brand']
    cp_columns = [col for col in df.columns if '/CP/SP' in col]  # Extract CP columns
    color_column = 'Colors'

    # Iterate through CP columns
    for cp_column in cp_columns:
        size = cp_column.split('/')[0]  # Extract size from column name
        cp_sp_values = row[cp_column].split('/')  # Extract CP and SP values
        cp = cp_sp_values[0]  # CP value
        sp = cp_sp_values[1] if len(cp_sp_values) > 1 else None  # SP value if available, else None
        colors = row[color_column].split(',')  # Extract Colors

        # Iterate through Colors
        for color in colors:
            # Create a formatted row and append it to the list
            formatted_row = [size, products, material, cp, sp, color, brand]
            formatted_rows.append(formatted_row)

# Create a new dataframe from the formatted rows
formatted_df1 = pd.DataFrame(formatted_rows, columns=['Size', 'Products', 'Material', 'CP', 'SP', 'Color','Brand'])

# Save the formatted dataframe to a new CSV file
#formatted_df.to_csv('Products_formatted_file.csv', index=False)

# Display the formatted dataframe
print(formatted_df1)


# Creating SQLAlchemy engine
engine = create_engine(
    r"mssql+pyodbc://dev:Shubham150@localhost\MSSQLSERVER01/Skool?driver=SQL+Server",
    use_setinputsizes=False  # Adding this line to disable automatic input size setting
)


# Specify the data types for each column
dtype_mapping = {
    'Size'    : DECIMAL,
    'Products': VARCHAR(245),
    'Material': VARCHAR(245),
    'CP'      : INT(),
    'SP'      : INT(),
    'Color'   : VARCHAR(20),
    'Brand'   : VARCHAR(30)
}

# actual name of  SQL Server table
table_name1 = 'Product_shoes'

# Use the `to_sql` method to insert the DataFrame into the SQL Server table
formatted_df1.to_sql(table_name1, con=engine, index=False, if_exists='replace', dtype=dtype_mapping)

# Attempt to insert data into the SQL Server table
try:
    formatted_df1.to_sql(table_name1, con=engine, index=False, if_exists='replace', dtype=dtype_mapping)
    print("Data imported successfully into the '{}' table.".format(table_name1))

except:
    print("Error importing data into the '{}' table.".format(table_name1))






    
