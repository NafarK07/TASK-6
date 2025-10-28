USE LibraryManagement;

-- Simple subquery: Find books with more copies than the average available copies
SELECT 
    title, available_copies
FROM Books
WHERE available_copies > (
    SELECT AVG(available_copies) FROM Books
);

-- Subquery using IN: List members who have borrowed at least one book
SELECT 
    first_name, last_name
FROM Members
WHERE member_id IN (
    SELECT DISTINCT member_id FROM Borrowings
);

-- Subquery using NOT IN: Members who never borrowed any book
SELECT 
    first_name, last_name
FROM Members
WHERE member_id NOT IN (
    SELECT DISTINCT member_id FROM Borrowings
);

-- Subquery using EXISTS: List books that have been borrowed at least once
SELECT 
    title
FROM Books b
WHERE EXISTS (
    SELECT 1 FROM Borrowings br WHERE br.book_id = b.book_id
);

-- Correlated subquery: Members who borrowed more than one book
SELECT 
    m.first_name, m.last_name
FROM Members m
WHERE (
    SELECT COUNT(*) FROM Borrowings br WHERE br.member_id = m.member_id
) > 1;

-- Scalar subquery in SELECT: Show each book with total times borrowed
SELECT 
    b.title,
    (SELECT COUNT(*) FROM Borrowings br WHERE br.book_id = b.book_id) AS times_borrowed
FROM Books b;

-- Subquery in FROM clause (Derived Table)
-- Find average available copies per publication year
SELECT 
    publication_year,
    AVG(available_copies) AS avg_available
FROM (
    SELECT publication_year, available_copies FROM Books
) AS BookData
GROUP BY publication_year;

-- Nested subquery example
-- Find members who borrowed the most recently published book
SELECT 
    first_name, last_name
FROM Members
WHERE member_id IN (
    SELECT member_id FROM Borrowings
    WHERE book_id IN (
        SELECT book_id FROM Books
        WHERE publication_year = (
            SELECT MAX(publication_year) FROM Books
        )
    )
);

-- Subquery with comparison operator (=)
-- Show book(s) with the highest number of total copies
SELECT 
    title, total_copies
FROM Books
WHERE total_copies = (
    SELECT MAX(total_copies) FROM Books
);

-- Correlated subquery with EXISTS
-- List authors who have written at least one book
SELECT 
    first_name, last_name
FROM Authors a
WHERE EXISTS (
    SELECT 1 FROM Book_Authors ba WHERE ba.author_id = a.author_id
);
