import pymysql
import os

def lambda_handler(event, context):
    db_host = os.environ['DB_HOST']
    db_user = os.environ['DB_USER']
    db_password = os.environ['DB_PASSWORD']

    connection = pymysql.connect(
        host=db_host,
        user=db_user,
        password=db_password
    )

    try:
        with connection.cursor() as cursor:
            cursor.execute("CREATE USER 'nodeapp' IDENTIFIED WITH mysql_native_password BY 'student12';")
            cursor.execute("GRANT ALL PRIVILEGES ON *.* TO 'nodeapp'@'%';")
            cursor.execute("FLUSH PRIVILEGES;")
            cursor.execute("CREATE DATABASE IF NOT EXISTS STUDENTS;")
            cursor.execute("USE STUDENTS;")
            cursor.execute("""
                CREATE TABLE students (
                    id INT NOT NULL AUTO_INCREMENT,
                    name VARCHAR(255) NOT NULL,
                    address VARCHAR(255) NOT NULL,
                    city VARCHAR(255) NOT NULL,
                    state VARCHAR(255) NOT NULL,
                    email VARCHAR(255) NOT NULL,
                    phone VARCHAR(100) NOT NULL,
                    PRIMARY KEY (id)
                );
            """)
        connection.commit()
    finally:
        connection.close()
