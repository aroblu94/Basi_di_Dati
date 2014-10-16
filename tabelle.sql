--   9 ottobre 2014
--   CREATE TABLE
--   Il nostro chef deve avere un nome, cognome, stipendio, data di assunzione ed esperienza (valutazione numerica decimale)
--
--   Forma del comando CREATE TABLE:
--   CREATE TABLE <nome_t> (<nome_attr> <tipo> <vincoli>,, ...)
--   N.B. voglio che il 'nickname' sia una CHIAVE PRIMARIA --> devono essere valori UNIVOCI e NON NULLI

CREATE TABLE chef (
    nickname CHAR(5) PRIMARY KEY,
    nome VARCHAR(20),
    cognome VARCHAR(20),
    stipendio NUMERIC(7,2), -- 7 cifre di cui 2 dedicate alle cifre decimali, quindi 5 cifre intere
    data_assunzione DATE,
    esperienza REAL
    -- PRIMARY KEY(nickname) --> al posto di mettere PRIMARY KEY sopra
);

-- ora inseriamo un cuoco...
INSERT INTO chef VALUES ('Aro', 'Aronne', 'Brivio', 1500.60, '2014-10-9', 8.5);

-- per vedere la tabella: (questa è una QUERY)
SELECT * FROM chef;

INSERT INTO chef VALUES ('Crac', 'Carlo', 'Cracco', 4200.5, '2012-5-1', 9.44);

-- Per modificare un dato:
UPDATE chef SET nome = 'TuaMamma' WHERE nome = 'Carlo';
-- questo modifica il nome di Carlo Cracco in TuaMamma Cracco

-- Per modificare i campi della tabella:
ALTER TABLE chef ALTER stipendio TYPE NUMERIC(5,3);

-- altra query:
SELECT * FROM chef WHERE esperienza > 8;

-- altra query:
SELECT nome, cognome, to_char(data_assunzione, 'Day DD/MM/YYYY') AS "data di assunzione" FROM chef;


-- ESERCIZIO
-- Creare una tabella ricetta
-- attributi: id, titolo, tempo, presentazione
-- vincoli:
-- id è un campo contatore autogenerato e chiave primaria
-- titolo non può assumere valori nulli
-- tempo è espresso in minuti
-- presentazione è un testo di lunghezza arbitraria
-- per creare una sequenza:
CREATE SEQUENCE ricetta_id_gen INCREMENT BY 1;

CREATE TABLE ricetta (
    id INTEGER DEFAULT nextval('ricetta_id_gen') PRIMARY KEY,
    titolo CHAR(200) NOT NULL,
    tempo INTEGER,
    presentazione TEXT
);

-- al posto di creare la sequenza automatica e scrivere poi 'id INTEGER DEFAULT nextval('ricetta_id_gen')', si può usare il tipo SERIA in psql:
CREATE TABLE ricetta (
    id SERIAL PRIMARY KEY,
    titolo CHAR(20) NOT NULL,
    tempo INTEGER,
    presentazione TEXT
);

INSERT INTO ricetta(titolo, tempo, presentazione) VALUES('Bavette al pesto, patate e fagiolini', 25, 'Le bavette al pesto, patate e fagiolini è una versione piuttosto blablabla...');

-- creare la tabella piatto.
-- richiede una chiave esterna. voglio che ogni piatto abbia una ricetta da cui "discende" --> ogni piatto ha 3 attributi:
-- id autogenerato
-- nome non nullo
-- riferimento alla ricetta (chiave esterna)
CREATE TABLE piatto (
    id SERIAL PRIMARY KEY,
    nome CHAR(200) NOT NULL,
    ricetta INTEGER REFERENCES ricetta(id)
);

INSERT INTO piatto(nome, ricetta) VALUES('Pizza Margherita', 2);
