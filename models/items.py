import pymysql

mysql=None

def get_items():
    cur = pymysql.connect(
        host="localhost",
        user="root",
        password="@Pasiya12",
        database="hospital_management_system"
    )
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM items")
    rows = cur.fetchall()
    cur.close()
    return rows
# item.py


