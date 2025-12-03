-- Table: clinics

CREATE TABLE clinics (
    cid INT PRIMARY KEY AUTO_INCREMENT,
    clinic_name VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL
);


-- Table: customer

CREATE TABLE customer (
    uid INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    mobile VARCHAR(15) UNIQUE NOT NULL
);


-- Table: clinic_sales

CREATE TABLE clinic_sales (
    oid INT PRIMARY KEY AUTO_INCREMENT,
    uid INT NOT NULL,
    cid INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    datetime DATETIME NOT NULL,
    sales_channel VARCHAR(50) NOT NULL,
    FOREIGN KEY (uid) REFERENCES customer(uid),
    FOREIGN KEY (cid) REFERENCES clinics(cid)
);


-- Table: expenses

CREATE TABLE expenses (
    eid INT PRIMARY KEY AUTO_INCREMENT,
    cid INT NOT NULL,
    description VARCHAR(255),
    amount DECIMAL(10,2) NOT NULL,
    datetime DATETIME NOT NULL,
    FOREIGN KEY (cid) REFERENCES clinics(cid)
);
