from flask import Flask, render_template, request, redirect, url_for, flash, session
# from flask_mysqldb import MySQL
from models import user_data #model file in user_data.py
from typing import Any
from models import items
# from models.items import get_items
# from models.cashier.cashier import app, get_cashier_invoices,add_invoice
# from models.cust_search.customer_search import search_user_route
import pymysql 


app = Flask(__name__)
app.config.from_object('config.Config')  #load database file


# mysql = user_data.pymysql = pymysql(app)

DB_CONFIG = {
    'host': 'localhost',        # Replace with your database host
    'user': 'root',     # Replace with your MySQL username
    'password': '@Pasiya12', # Replace with your MySQL password
    'database': 'hospital_management_system', # Replace with your database name
}


# items.pymysql = pymysql
app.config['SECRET_KEY'] = 'Hiroshan1999'

# Main Page Route
@app.route('/')
def home():
    return render_template('base.html')

    
@app.route('/register_user_role')
def registration():

    return render_template('registration.html')

#---------------User role credintial--------------------#

@app.route('/login', methods=['POST']) 
def login():
    username = request.form['username']
    password = request.form['password']

    connection = pymysql.connect(**DB_CONFIG)
    query = "SELECT role FROM users WHERE username=%s AND password=%s"
    cursor = connection.cursor()
    cursor.execute(query, (username, password))
    user = cursor.fetchone()  
    
    if user:
        role = user[0]  # Access the role from the returned tuple
        session['username'] = username
        session['role'] = role
        
        
        if role == 'SuperAdmin':
            return redirect(url_for('superadmin_dashboard1'))
        elif role == 'Admin':
            return redirect(url_for('admin_dashboard'))
        elif role == 'User':
            return redirect(url_for('user_dashboard'))
        elif role == 'Cashier':
            return redirect(url_for('cashier_dashboard'))
    else:
        flash('Invalid username or password')
        return redirect(url_for('home'))

#-------------Role route------------------
@app.route('/admin')
def admin_dashboard():

    connection = pymysql.connect(**DB_CONFIG)
    cursor = connection.cursor();
    users = user_data.get_users()
    # items = get_items() 
    cursor.execute("SELECT * FROM stock ORDER BY date, time")  # FIFO: Order by date and time
    stock = cursor.fetchall()
    return render_template('admin_dsahbord1.html',users=users )

@app.route('/user')
def user_dashboard():
     users = user_data.get_users()
     return render_template('user_dashbord.html', users=users)
#--------------------------Cashier----------------------------------------------------------#

# @app.route('/cashier')
# def cashier_dashboard():
#     invoices = get_cashier_invoices()

#     users = user_data.get_users()
#     return render_template('cahier_dashbord.html',invoices=invoices,users=users)  

#-----------------------Cashier End---------------------------------------------------------#



# SuperAdmin Dashboard Route
# @app.route('/superadmin_db_details')
# def superadmin_dashboard1():
#     cursor = mysql.connection.cursor()
#     cursor.execute("SELECT * FROM stock ORDER BY date, time")  # FIFO: Order by date and time
#     stock = cursor.fetchall()
#     cursor.close()
    
#     users = user_data.get_users()
#     items = get_items()

#     return render_template('superadmin_dashboard.html', stock=stock, users=users, items=items)

#-----------------------------------------STOCK--------------------------------------------------------------------

# Stock Update Route
# @app.route('/add_stock_form')
# def add_stock_form():

#     return render_template('stock/add_stock.html')

# Add Stock Route
# @app.route('/add_stock', methods=['GET', 'POST'])
# def add_stock():
#     if request.method == 'POST':
#         item_code = request.form['code']
#         invoice_number = request.form['invoice_number']
#         item_name = request.form['item_name']
#         time = request.form['time']
#         date = request.form['date']
#         cost = request.form['cost']
#         price = request.form['Selling_price']
#         quantity = request.form['quantity']
#         expire_date=request.form['expire_date']
        
#         cur = pymysql.connection.cursor()
#         cur.execute("""
#             INSERT INTO stock (item_uuid, item_code, invoice_number, item, time, date, cost, price, quantity,expire_date) 
#             VALUES (UUID(), %s, %s, %s, %s, %s, %s, %s, %s,%s )""", 
#             (item_code, invoice_number, item_name, time, date, cost, price, quantity,expire_date))
#         pymysql.connection.commit()
#         cur.close()
#         return redirect(url_for('add_stock_form'))
    
#     return redirect(url_for('add_stock_form'))


# @app.route('/update_stock/<string:item_uuid>', methods=['GET', 'POST'])
# def update_stock(item_uuid):
#     cur = pymysql.connection.cursor()
    
#     if request.method == 'POST':
#         item_name = request.form['item_name']
#         quantity = request.form['quantity']
#         price = request.form['Selling_price']
        
#         # Update stock based on item_uuid
#         cur.execute("""
#             UPDATE stock 
#             SET item = %s, quantity = quantity + %s, price = %s 
#             WHERE item_uuid = %s""", (item_name, quantity, price, item_uuid))
        
#         pymysql.connection.commit() 
#         cur.close()  
#         return redirect(url_for('superadmin_dashboard1'))
    
#     # If GET request, fetch the current stock data
#     cur.execute("SELECT * FROM stock WHERE item_uuid = %s", (item_uuid,))
#     stock = cur.fetchone()
#     cur.close()
#     return render_template('stock/update_stock.html', stock=stock)



# @app.route('/delete_stock/<string:item_uuid>', methods=['GET'])
# def delete_stock(item_uuid):
#     cur = pymysql.connection.cursor()
#     cur.execute("DELETE FROM stock WHERE item_uuid = %s", (item_uuid,))
#     pymysql.connection.commit()
#     cur.close()
#     return redirect(url_for('superadmin_dashboard1'))



@app.route('/logout')
def logout():
    session.clear()  # Clear all session data
    flash('You have been logged out.')  # Optional: Add a flash message
    return redirect(url_for('home'))  # Redirect to the homepage or login

# Admin Dashboard Route
@app.route('/admin_dashboard_superadmin')
def super_admin_dashboard():
    return render_template('admin_dashboard.html')

#----------------User operation------------------#
# Initialize MySQL and pass to user_data
from flask import render_template, request, jsonify

@app.route('/add_users')
def add_user_form():
    
    return render_template('user/add_user.html')


# Route to handle adding user customer
@app.route('/add_user_to_', methods=['GET', 'POST'])
def add_user_route():
    if request.method=='POST':
       user_name = request.form['user_name']
       address = request.form['address']
       phone_no = request.form['phone_no']
       email=request.form['email']
       nic=request.form['nic']
       comment = request.form.get('comment', '')
       
       connection = pymysql.connect(**DB_CONFIG)
       cursor = connection.cursor()
       cursor.execute("""
            INSERT INTO users_data (user_name, address, phone_no,email,nic, comment) 
              VALUES (%s, %s, %s, %s,%s,%s)
    """, (user_name, address, phone_no,email,nic, comment))
       
       connection.commit()
       connection.close()  
     
       return redirect(url_for('add_user_form'))
       
    return render_template('user/add_user.html')
#---------------search users(customer)------------------------#
# @app.route('/search_customer', methods=['GET', 'POST']) #post and get is used to form function
# def search_user():
#     return search_user_route()

#---------------search users(customer)end------------------------#

#--------------------Update users-------------------#

@app.route('/update_users/<int:id>', methods=['GET', 'POST'])
def update_user(id):
    cur = pymysql.connection.cursor()

    if request.method == 'POST':
        # Fetch form data
        user_name = request.form['user_name']
        address = request.form['address']
        phone_no = request.form['phone_no']
        comment = request.form.get('comment', '')

        # Update user details in the database
        try:
            cur.execute("""
                UPDATE users_data 
                SET user_name = %s, address = %s, phone_no = %s, comment = %s 
                WHERE user_id = %s
            """, (user_name, address, phone_no, comment, id))
            pymysql.connection.commit()
            return redirect(url_for('view_users'))  # Redirect after updating
        except Exception as e:
            print("Error updating user:", e)
            pymysql.connection.rollback()  # Rollback if there's an error

    # Fetch user details for the GET request
    cur.execute("SELECT * FROM users_data WHERE user_id = %s", (id,))
    user = cur.fetchone()
    cur.close()

    return render_template('user/update_user.html', user=user)

#------------------------Delete Users-----------------------#
# @app.route('/delete_User_data/<int:id>', methods=['GET'])
# def delete_user_DB(id):
#     try:
#         cur = mysql.connection.cursor()
#         cur.execute("DELETE FROM users_data WHERE user_id = %s", (id,))  
#         mysql.connection.commit()
#         return redirect(url_for('superadmin_dashboard1'))
#     except Exception as e:
#         print("Error deleting user:", e)
#         mysql.connection.rollback() 
#         return redirect(url_for('superadmin_dashboard1'))  
#------------------------Delete Users End-----------------------#

#----------------------------------------------------------------------------------------------------------------------------------------------#

#------------------------Items Manages--------------------------#

# @app.route('/items_re')
# def item():
    
#     return render_template('item/add_item.html')
 #--------------------ADD Item----------------------------------#
 
 # Stock Update Route
# @app.route('/Add_Items', methods=['GET', 'POST'])
# def add_items():
#     cur = mysql.connection.cursor()
    
#     if request.method == 'POST':
#         item_name= request.form['item_name']
#         company_name = request.form['company_name']
#         dose=request.form['dose']
#         genetic_name = request.form['genetic_name']
#         brand_name = request.form['brand_name']
#         specific1= request.form['specific1']
        
       
#         cur = mysql.connection.cursor()  # Interact with DB
#         cur.execute("INSERT INTO items (item_name, company, dose, genetic_name,brand_name,specific1) VALUES (%s, %s, %s, %s,%s,%s)", 
#                    (item_name,  company_name,  dose,genetic_name, brand_name,specific1))
#         mysql.connection.commit()  # Save
#         cur.close()  # Close the cursor
#         return redirect(url_for('item'))
    
#     return redirect(url_for('item'))

#-------------Update Uesr------------------#


# @app.route('/update_item_ii/<uuid:uuid>', methods=['GET', 'POST'])
# def update_items(uuid):
#     cur = mysql.connection.cursor()

#     if request.method == 'POST':
#         item_name = request.form['item_name']
#         company_name = request.form['company_name']
#         dose = request.form['dose']
#         genetic_name = request.form['genetic_name']
#         brand_name = request.form['brand_name']
#         specific1 = request.form['specific1']

     
#         try:
#             cur.execute("""
#                 UPDATE items 
#                 SET item_name = %s, company = %s, dose = %s, genetic_name = %s, brand_name = %s, specific1 = %s 
#                 WHERE uuid = %s
#             """, (item_name, company_name, dose, genetic_name, brand_name, specific1, uuid))
#             mysql.connection.commit()
#             return redirect(url_for('update_item_route')) 
#         except Exception as e:
#             print("Error updating item:", e)  
#             mysql.connection.rollback()  
            
#     cur.execute("SELECT * FROM items WHERE uuid = %s", (uuid,))
#     items = cur.fetchone()
#     cur.close()

#     return render_template('item/updated_item.html', items=items)
#---------------------Delete Items----------------------------------#
# @app.route('/delete_item_data/<uuid:uuid>', methods=['GET'])
# def delete_item_DB(uuid):
#     try:
#         cur = mysql.connection.cursor()
#         cur.execute("DELETE  FROM items WHERE uuid = %s", (uuid,))  
#         mysql.connection.commit()
#         return redirect(url_for('superadmin_dashboard1'))
#     except Exception as e:
#         print("Error deleting user:", e)
#         mysql.connection.rollback() 
#         return redirect(url_for('superadmin_dashboard1')) 
    
#-------cahier add---------------------------------------------------------------------#
# @app.route('/add_invoice', methods=['GET', 'POST'])
# def add_invoice_route():
#     return add_invoice(mysql)

# @app.route('/add-invoice_form')
# def add_invoice_form():
#       return render_template('cashier/cashier_invoice.html')



    
    







if __name__ == '__main__':
    app.run(debug=True)



# blinker==1.9.0
# click==8.1.7
# colorama==0.4.6
# distlib==0.3.9
# filelock==3.16.1
# Flask==3.1.0
# Flask-MySQLdb==2.0.0
# Flask-SQLAlchemy==3.1.1
# itsdangerous==2.2.0
# Jinja2==3.1.4
# MarkupSafe==3.0.2
# mysql-connector-python==9.1.0
# mysqlclient==2.2.6
# platformdirs==4.3.6
# SQLAlchemy==2.0.36
# typing_extensions==4.12.2
# virtualenv==20.28.0
# Werkzeug==3.1.3


# blinker==1.9.0
# click==8.1.8
# Flask==3.1.0
# Flask-MySQLdb==2.0.0
# Flask-SQLAlchemy==3.1.1
# itsdangerous==2.2.0
# Jinja2==3.1.5
# MarkupSafe==3.0.2
# mysqlclient==2.2.6
# SQLAlchemy==2.0.36
# typing_extensions==4.12.2
# Werkzeug==3.1.3


# blinker==1.9.0
# click==8.1.8
# Flask==3.1.0
# Flask-MySQLdb==2.0.0
# Flask-SQLAlchemy==3.1.1
# itsdangerous==2.2.0
# Jinja2==3.1.5
# MarkupSafe==3.0.2
# PyMySQL==1.1.1
# SQLAlchemy==2.0.36
# typing_extensions==4.12.2
# Werkzeug==3.1.3


