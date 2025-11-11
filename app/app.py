from flask import Flask, request, jsonify
import pymysql
import os

app = Flask(__name__)

DB_HOST = os.environ.get("DB_HOST")
DB_USER = os.environ.get("DB_USER")
DB_PASS = os.environ.get("DB_PASS")
DB_NAME = os.environ.get("DB_NAME")

def get_db_connection():
    return pymysql.connect(
        host=DB_HOST,
        user=DB_USER,
        database=DB_NAME,
        password=DB_PASS,
        cursorclass=pymysql.cursors.DictCursor
    )

def init_db():
    conn = get_db_connection()
    with conn.cursor() as cursor:
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS employees (
                       id INT AUTO_INCREMENT PRIMARY KEY,
                       name VARCHAR(100) NOT NULL,
                       role VARCHAR(50) NOT NULL
                       );
        """)
    conn.commit()
    conn.close()

init_db()

@app.route('/')
def index():
    return "Hello from my Flask app!"

@app.route('/employees', methods=['GET', 'POST'])
def employees():
    conn = get_db_connection()
    with conn.cursor() as cursor:
        if request.method == 'POST':
            data = request.get_json()
            name = data.get('name')
            role = data.get('role')
            if not name or not role:
                return jsonify({"error": "Missing name or role"}), 400
            cursor.execute("INSERT INTO employees (name, role) VALUES (%s, %s)", (name,role))
            conn.commit()
            return jsonify({"Message": "Employee added" }), 201
        else:
            cursor.execute("SELECT * from employees")
            result = cursor.fetchall()
    conn.close()
    return jsonify(result)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
