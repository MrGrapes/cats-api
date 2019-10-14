CREATE TYPE gender AS ENUM ('male', 'female', 'unisex');

CREATE TABLE Cats (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    tags TEXT[],
    gender gender,
    CONSTRAINT unique_name UNIQUE(name)
);
CREATE TABLE Cats_Validations (
    id SERIAL PRIMARY KEY,
    description TEXT NOT NULL,
    regex TEXT NOT NULL
);

-- Add name validation rules:
INSERT INTO Cats_Validations (description, regex) VALUES
  ('Цифры не принимаются!', '^\D*$'),
  ('Только имена на русском!', '^[а-яА-Я\s-]*$'),
  ('Из спецсимволов можно только тире и только посередине имени', '^([\d\wа-яА-Я]+|[\d\wа-яА-Я]+[-\s]|[\d\wа-яА-Я]+[-\s][\d\wа-яА-Я]+)$');

-- Feature 8 upload images:
CREATE TABLE images (
    id SERIAL PRIMARY KEY,
    link VARCHAR NOT NULL,
    id_cat INT NOT NULL
  constraint images_cats__fk
   references cats ("id")
    on delete cascade
);

-- Bug: add validator for insert name
CREATE TYPE Validation_Type AS ENUM ('search', 'add');
ALTER TABLE Cats_Validations ADD COLUMN type Validation_Type NOT NULL DEFAULT 'search';

INSERT INTO Cats_Validations (description, regex, type) VALUES
    ('Цифры не принимаются!', '^\D*$', 'add'),
    ('Из спецсимволов можно только тире и только посередине имени', '^([\d\wа-яА-Я]+[-\s]?[\d\wа-яА-Я]+)$', 'add'),
    ('Только имена на русском!', '^[а-яА-Я\s-]*$', 'add');