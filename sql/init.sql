CREATE DATABASE setu_db;

\connect setu_db

CREATE TABLE IF NOT EXISTS students (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    course VARCHAR(100) NOT NULL
);

INSERT INTO students (name, course)
VALUES
    ('Test Student 1', 'Information Technology'),
    ('Test Student 2', 'Computer Science');
