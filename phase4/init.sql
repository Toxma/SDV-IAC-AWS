CREATE USER 'nodeapp' IDENTIFIED
WITH
    mysql_native_password BY 'student12';

GRANT ALL PRIVILEGES ON *.* TO 'nodeapp' @'%';

FLUSH PRIVILEGES;

USE STUDENTS;

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