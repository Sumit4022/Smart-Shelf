-- SmartShelf : Library Management System
-- Project Task 3
-- Database Schema, Constraints, Indexes, and Sample Data

CREATE DATABASE IF NOT EXISTS SmartShelfDB;
USE SmartShelfDB;


-- MEMBERSHIP TABLE
CREATE TABLE IF NOT EXISTS membership (
    Membership_Type_Id INT AUTO_INCREMENT PRIMARY KEY,
    Max_Book_Allowed INT NOT NULL CHECK (Max_Book_Allowed > 0),
    Duration INT NOT NULL CHECK (Duration > 0), -- in days
    Max_Reservation INT NOT NULL CHECK (Max_Reservation >= 0),
    Fee DECIMAL(10,2) NOT NULL CHECK (Fee >= 0)
);

-- ADMIN TABLE
CREATE TABLE IF NOT EXISTS admin (
    Admin_Id INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Username VARCHAR(50) NOT NULL,
    Password VARCHAR(100) NOT NULL,
    Email_Id VARCHAR(100) UNIQUE NOT NULL,
    Phone_Number BIGINT UNIQUE NOT NULL
);


-- LIBRARIAN TABLE
CREATE TABLE IF NOT EXISTS librarian (
    Librarian_Id INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Username VARCHAR(50) NOT NULL,
    Password VARCHAR(100) NOT NULL,
    Email_Id VARCHAR(100) UNIQUE NOT NULL,
    Phone_Number BIGINT UNIQUE NOT NULL
);


-- SHELF TABLE
CREATE TABLE IF NOT EXISTS shelf (
    Shelf_Number INT PRIMARY KEY,
    Location VARCHAR(100) NOT NULL
);


-- GENRE TABLE
CREATE TABLE IF NOT EXISTS genre (
    Genre_Type VARCHAR(50) PRIMARY KEY,
    Shelf_Number INT NOT NULL,
    FOREIGN KEY (Shelf_Number) REFERENCES shelf(Shelf_Number)
    ON DELETE CASCADE ON UPDATE CASCADE
);


-- PRODUCTION HOUSE TABLE
CREATE TABLE IF NOT EXISTS production_house (
    Production_House_Id INT AUTO_INCREMENT PRIMARY KEY,
    Location VARCHAR(100) NOT NULL
);


-- BOOK TABLE
CREATE TABLE IF NOT EXISTS book (
    Book_Id INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(100) NOT NULL,
    Author VARCHAR(100) NOT NULL,
    Publisher VARCHAR(100),
    ISBN VARCHAR(20) UNIQUE NOT NULL,
    Genre_Type VARCHAR(50) NOT NULL,
    Librarian_Id INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity >= 0),
    FOREIGN KEY (Genre_Type) REFERENCES genre(Genre_Type),
    FOREIGN KEY (Librarian_Id) REFERENCES librarian(Librarian_Id)
);


-- MEMBER TABLE
CREATE TABLE IF NOT EXISTS member (
    Member_Id INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Username VARCHAR(50) NOT NULL,
    Password VARCHAR(100) NOT NULL,
    Email_Id VARCHAR(100) UNIQUE NOT NULL,
    Phone_Number BIGINT UNIQUE NOT NULL,
    Membership_Type_Id INT NOT NULL,
    Membership_Start DATE NOT NULL,
    Membership_Expiry DATE NOT NULL,
    FOREIGN KEY (Membership_Type_Id) REFERENCES membership(Membership_Type_Id)
);


-- BOOK_INFO
CREATE TABLE IF NOT EXISTS book_info (
    Borrow_Id INT AUTO_INCREMENT PRIMARY KEY,
    Borrow_Date DATE NOT NULL,
    Borrow_Time TIME NOT NULL,
    Due_Date DATE NOT NULL,
    Status VARCHAR(20) NOT NULL DEFAULT 'Issued',
    Librarian_Id INT NOT NULL,
    Member_Id INT NOT NULL,
    Book_Id INT NOT NULL,
    FOREIGN KEY (Librarian_Id) REFERENCES librarian(Librarian_Id),
    FOREIGN KEY (Member_Id) REFERENCES member(Member_Id),
    FOREIGN KEY (Book_Id) REFERENCES book(Book_Id)
);


-- RESERVATION TABLE
CREATE TABLE IF NOT EXISTS reservation (
    Reservation_Id INT AUTO_INCREMENT PRIMARY KEY,
    Reservation_Date DATE NOT NULL,
    Status VARCHAR(20) NOT NULL DEFAULT 'Pending',
    Book_Id INT NOT NULL,
    Member_Id INT NOT NULL,
    FOREIGN KEY (Book_Id) REFERENCES book(Book_Id),
    FOREIGN KEY (Member_Id) REFERENCES member(Member_Id)
);


-- FINE TABLE
CREATE TABLE IF NOT EXISTS fine (
    Fine_Id INT AUTO_INCREMENT PRIMARY KEY,
    Amount DECIMAL(10,2) NOT NULL CHECK (Amount >= 0),
    Fine_Due_Date DATE NOT NULL,
    Paid_Status VARCHAR(10) NOT NULL DEFAULT 'Unpaid',
    Borrow_Id INT UNIQUE NOT NULL,
    FOREIGN KEY (Borrow_Id) REFERENCES book_info(Borrow_Id)
);

-- -----------------------------------------------
-- INDEXES
-- -----------------------------------------------
CREATE INDEX idx_member_email ON member(Email_Id);
CREATE INDEX idx_book_isbn ON book(ISBN);
CREATE INDEX idx_bookinfo_member ON book_info(Member_Id);
CREATE INDEX idx_reservation_book ON reservation(Book_Id);

-- -----------------------------------------------
-- DATA INSERTION
-- -----------------------------------------------

-- Membership Plans
INSERT INTO membership (Max_Book_Allowed, Duration, Max_Reservation, Fee) VALUES
(2, 180, 1, 500),
(5, 365, 3, 1000),
(10, 365, 5, 2000),
(1, 90, 0, 250),
(7, 365, 4, 1500);

-- Admins
INSERT INTO admin (Name, Username, Password, Email_Id, Phone_Number) VALUES
('System Admin', 'admin1', 'admin@123', 'admin1@library.com', 9876543210);

-- Librarians
INSERT INTO librarian (Name, Username, Password, Email_Id, Phone_Number) VALUES
('Amit Sharma', 'amit_lib', 'lib@123', 'amit@library.com', 9876543220),
('Neha Verma', 'neha_lib', 'lib@456', 'neha@library.com', 9876543221),
('Rahul Mehta', 'rahul_lib', 'lib@789', 'rahul@library.com', 9876543222),
('Priya Nair', 'priya_lib', 'lib@321', 'priya@library.com', 9876543223),
('Vikram Joshi', 'vikram_lib', 'lib@999', 'vikram@library.com', 9876543224);

-- Shelves
INSERT INTO shelf (Shelf_Number, Location) VALUES
(1, 'Ground Floor - A Wing'),
(2, 'First Floor - B Wing'),
(3, 'Second Floor - C Wing'),
(4, 'Third Floor - D Wing');

-- Genres
INSERT INTO genre (Genre_Type, Shelf_Number) VALUES
('Fiction', 1),
('Technology', 2),
('Science', 2),
('History', 3),
('Philosophy', 4),
('Mathematics', 2);

-- Production Houses
INSERT INTO production_house (Location) VALUES
('New Delhi'),
('Mumbai'),
('Chennai'),
('Bangalore'),
('Kolkata');

-- Books
INSERT INTO book (Title, Author, Publisher, ISBN, Genre_Type, Librarian_Id, Quantity) VALUES
('Clean Code', 'Robert C. Martin', 'Pearson', 'ISBN001', 'Technology', 1, 5),
('The Alchemist', 'Paulo Coelho', 'HarperCollins', 'ISBN002', 'Fiction', 2, 4),
('A Brief History of Time', 'Stephen Hawking', 'Bantam', 'ISBN003', 'Science', 1, 3),
('Introduction to Algorithms', 'Cormen', 'MIT Press', 'ISBN004', 'Technology', 3, 6),
('Sapiens', 'Yuval Noah Harari', 'Vintage', 'ISBN005', 'History', 4, 5),
('Meditations', 'Marcus Aurelius', 'Penguin', 'ISBN006', 'Philosophy', 2, 2),
('Linear Algebra Done Right', 'Sheldon Axler', 'Springer', 'ISBN007', 'Mathematics', 1, 4);

-- Members
INSERT INTO member (Name, Username, Password, Email_Id, Phone_Number, Membership_Type_Id, Membership_Start, Membership_Expiry) VALUES
('Rohit Kumar', 'rohit01', 'rohit@123', 'rohit@mail.com', 9876543300, 2, '2024-01-01', '2024-12-31'),
('Ananya Singh', 'ananya01', 'ananya@123', 'ananya@mail.com', 9876543301, 1, '2024-02-01', '2024-07-31'),
('Arjun Patel', 'arjun01', 'arjun@123', 'arjun@mail.com', 9876543302, 3, '2024-01-10', '2024-12-31'),
('Sneha Gupta', 'sneha01', 'sneha@123', 'sneha@mail.com', 9876543303, 2, '2024-02-15', '2025-02-14'),
('Kunal Shah', 'kunal01', 'kunal@123', 'kunal@mail.com', 9876543304, 1, '2024-03-01', '2024-08-28'),
('Meera Iyer', 'meera01', 'meera@123', 'meera@mail.com', 9876543305, 4, '2024-04-01', '2025-03-31');

-- Borrowing Records
INSERT INTO book_info (Borrow_Date, Borrow_Time, Due_Date, Status, Librarian_Id, Member_Id, Book_Id) VALUES
('2024-03-01', '10:30:00', '2024-03-15', 'Issued', 1, 1, 1),
('2024-03-05', '12:00:00', '2024-03-20', 'Returned', 2, 2, 2),
('2024-03-08', '11:00:00', '2024-03-22', 'Issued', 3, 3, 4),
('2024-03-12', '14:30:00', '2024-03-26', 'Issued', 4, 4, 5),
('2024-03-15', '16:00:00', '2024-03-29', 'Returned', 1, 5, 6);

-- Reservations
INSERT INTO reservation (Reservation_Date, Status, Book_Id, Member_Id) VALUES
('2024-03-10', 'Pending', 3, 1),
('2024-03-14', 'Approved', 4, 2),
('2024-03-16', 'Pending', 7, 3),
('2024-03-18', 'Cancelled', 5, 4),
('2024-03-22', 'Pending', 7, 6);

-- Fine
INSERT INTO fine (Amount, Fine_Due_Date, Paid_Status, Borrow_Id) VALUES
(50.00, '2024-03-25', 'Unpaid', 1),
(30.00, '2024-04-01', 'Paid', 2),
(75.00, '2024-04-05', 'Unpaid', 4),
(40.00, '2024-04-10', 'Unpaid', 5);


SHOW TABLES;
