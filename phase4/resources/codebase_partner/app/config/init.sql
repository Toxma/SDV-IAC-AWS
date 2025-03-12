-- Create user only if it doesn't exist
CREATE USER IF NOT EXISTS 'nodeapp' IDENTIFIED
WITH
    mysql_native_password BY 'student12';

-- Grant privileges (this is already idempotent)
GRANT ALL PRIVILEGES ON *.* TO 'nodeapp' @'%';

-- Flush privileges (this is already idempotent)
FLUSH PRIVILEGES;

-- Create database if it doesn't exist
CREATE DATABASE IF NOT EXISTS students;

-- Use the database
USE students;

-- Create table only if it doesn't exist
CREATE TABLE IF NOT EXISTS students (
    id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    address VARCHAR(255) NOT NULL,
    city VARCHAR(255) NOT NULL,
    state VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(100) NOT NULL,
    PRIMARY KEY (id)
);