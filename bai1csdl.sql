
CREATE TABLE IF NOT EXISTS Books (
    BookID INT PRIMARY KEY AUTO_INCREMENT,
    Title VARCHAR(255) NOT NULL,
    Author VARCHAR(100) NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    PublicationDate DATE NOT NULL
);

INSERT INTO Books (Title, Author, Price, PublicationDate) VALUES
('Clean Code', 'Robert C. Martin', 45.50, '2008-08-01'),
('The Pragmatic Programmer', 'Andrew Hunt', 55.00, '1999-10-30'),
('Introduction to Algorithms', 'Thomas H. Cormen', 85.00, '2009-07-31'),
('Effective Java', 'Joshua Bloch', 48.00, '2017-12-18'),
('Design Patterns', 'Erich Gamma', 60.00, '1994-10-31'),
('Artificial Intelligence: A Modern Approach', 'Stuart Russell', 120.00, '2020-04-28'),
('Don Quixote', 'Miguel de Cervantes', 15.25, '1605-01-16'),
('The Great Gatsby', 'F. Scott Fitzgerald', 12.99, '1925-04-10'),
('Code Complete', 'Steve McConnell', 52.00, '2004-06-19'),
('Head First Design Patterns', 'Eric Freeman', 42.50, '2004-10-25');

SELECT Title, Author, Price, PublicationDate 
FROM Books;

SELECT Title, Author 
FROM Books 
WHERE Price > 50;