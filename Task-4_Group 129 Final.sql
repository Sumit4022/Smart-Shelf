use smartshelfdb;

-- 1. View all books in the library
SELECT Title, Author, Genre_Type, Quantity
FROM book;

-- 2. Show books written by a specific author
SELECT Title, Author
FROM book
WHERE Author = 'Robert C. Martin';

-- 3. List all books along with their shelf location
SELECT b.Title, g.Genre_Type, s.Location
FROM book b
JOIN genre g ON b.Genre_Type = g.Genre_Type
JOIN shelf s ON g.Shelf_Number = s.Shelf_Number;

-- 4. Display all books issued to members
SELECT m.Name, b.Title, bi.Borrow_Date
FROM book_info bi
JOIN member m ON bi.Member_Id = m.Member_Id
JOIN book b ON bi.Book_Id = b.Book_Id;

-- 5. List all members with their membership type
SELECT m.Name, m.Email_Id, ms.Membership_Type_Id
FROM member m
JOIN membership ms
ON m.Membership_Type_Id = ms.Membership_Type_Id;

-- 6. Find books that are currently issued
SELECT Title
FROM book
WHERE Book_Id IN
(
    SELECT Book_Id
    FROM book_info
    WHERE Status = 'Issued'
);

-- 7. Find books with quantity greater than 3
SELECT Title, Quantity
FROM book
WHERE Quantity > 3;

-- 8. Count total number of books in each genre
SELECT Genre_Type, COUNT(*) AS Total_Books
FROM book
GROUP BY Genre_Type;

-- 9. Show all unpaid fines
SELECT Fine_Id, Amount, Fine_Due_Date
FROM fine
WHERE Paid_Status = 'Unpaid';

-- 10. Find total fine amount collected
SELECT SUM(Amount) AS Total_Fine_Collected
FROM fine
WHERE Paid_Status = 'Paid';

-- 11. Find the most borrowed book
SELECT Book_Id, COUNT(*) AS Borrow_Count
FROM book_info
GROUP BY Book_Id
ORDER BY Borrow_Count DESC
LIMIT 1;

-- 12. Find librarian managing the most books
SELECT Librarian_Id, COUNT(*) AS Books_Managed
FROM book
GROUP BY Librarian_Id
ORDER BY Books_Managed DESC
LIMIT 1;

-- 13. Show all members and the books they borrowed
SELECT m.Name, b.Title, bi.Borrow_Date
FROM member m
LEFT JOIN book_info bi ON m.Member_Id = bi.Member_Id
LEFT JOIN book b ON bi.Book_Id = b.Book_Id;

-- 14. Display books and their shelf numbers using
SELECT Title, Genre_Type, Shelf_Number
FROM book
NATURAL JOIN genre;

-- 15. Count books managed by each librarian
SELECT Librarian_Id, COUNT(Book_Id) AS Total_Books
FROM book
GROUP BY Librarian_Id;

-- 16. Find librarians managing more than one book
SELECT Librarian_Id, COUNT(Book_Id) AS Total_Books
FROM book
GROUP BY Librarian_Id
HAVING COUNT(Book_Id) > 1;

-- 17. Count number of reservations for each book
SELECT b.Title, COUNT(r.Reservation_Id) AS Total_Reservations
FROM book b
LEFT JOIN reservation r ON b.Book_Id = r.Book_Id
GROUP BY b.Title;

-- 18. Insert a new book into the library
INSERT INTO book (Title, Author, Publisher, ISBN, Genre_Type, Librarian_Id, Quantity)
VALUES ('Artificial Intelligence', 'Stuart Russell', 'Pearson', 'ISBN008', 'Technology', 2, 3);

-- 19. Update quantity of a specific book
UPDATE book
SET Quantity = 10
WHERE Title = 'Clean Code';

-- 20. Delete a reservation record
DELETE FROM reservation
WHERE Reservation_Id = 4;

-- 21. Create a view for borrowed books
CREATE VIEW Borrowed_Books AS
SELECT m.Name, b.Title, bi.Borrow_Date
FROM book_info bi
JOIN member m ON bi.Member_Id = m.Member_Id
JOIN book b ON bi.Book_Id = b.Book_Id;