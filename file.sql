-- 16 ottobre 2014
-- lavoro ancora sul database "ristorante"
CREATE TABLE usa(
    ricetta INTEGER,
    PRIMARY KEY (ricetta, usata),
    FOREIGN KEY (ricetta) REFERENCES ricetta(id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (usata) REFERENCES ricetta(ID)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- creare una tabella "persona" con
-- id numerico e autogenerato
-- nome
-- residenza che è chiave esterna rispetto la tabella "citta" che ha:
-- sigla (codice)
-- nome città
-- implementando una gestione di cancellazione e update degli elementi

CREATE TABLE città(
    sigla CHAR(2) PRIMARY KEY,
    nome VARCHAR(20)
);

CREATE TABLE persona(
    id SERIAL PRIMARY KEY,
    nome VARCHAR(20),
    residenza VARCHAR(2),
    FOREIGN KEY (residenza) REFERENCES città(sigla)
        ON DELETE NO ACTION ON UPDATE CASCADE
);

INSERT INTO città (nome, sigla) VALUES ('Milano', 'MI');
INSERT INTO città (nome, sigla) VALUES ('Bergamo', 'BG');

INSERT INTO persona (nome, residenza) VALUES ('Aronne Brivio', 'BG');

-- aggiungiamo alla tabella persona la colonna "cognome"
-- rendiamo la coppia nome-cognome PRIMARY KEY (UNIQUE)

ALTER TABLE persona ADD COLUMN cognome VARCHAR(20);
UPDATE persona SET nome = 'Aronne' WHERE nome = 'Aronne Brivio';
UPDATE persona SET cognome = 'Brivio' WHERE nome = 'Aronne';

ALTER TABLE persona ADD CONSTRAINT nome_cognome UNIQUE (nome, cognome);


-- tabell "professione"
-- ha una chiave primaria che è il codice
-- e la descrizione della professione
-- modificare la tabella delle persone per aggiungere la professione
-- ---> aggiungere una chiave esterna tra persone e professione
-- è obbligatorio che le persone abbiano una professione.

CREATE TABLE professione(
    codice VARCHAR(20) PRIMARY KEY,
    descrizione VARCHAR
);

ALTER TABLE persona ADD COLUMN professione VARCHAR(20);
ALTER TABLE persona ADD FOREIGN KEY (professione) REFERENCES professione(codice);
INSERT INTO professione (codice, descrizione) VALUES ('studente', '--');
UPDATE persona SET professione = 'studente' WHERE nome = 'Aronne';
ALTER TABLE persona ALTER COLUMN professione SET NOT NULL;

-- aggiungere a persona il campo età.
-- l'età DEVE esse 0<x<120
ALTER TABLE persona ADD COLUMN età INTEGER CHECK (età >= 0 AND età <= 120);
UPDATE persona SET età = '19' WHERE nome = 'Aronne';
INSERT INTO professione (codice, descrizione) VALUES ('impiegato', '--');
INSERT INTO persona (nome, residenza, cognome, professione, età) VALUES ('Marco', 'MI', 'Rossi', 'impiegato', '47');

-- tabella prodotti:
-- id
-- marca (obbligatoria)
-- quantità disponibile (>= 0)
-- prezzo aggiunta (valore positivo)
-- data acquisto (momento in cui viene inserito il prodotto nella tabella, giorno ma anche orario)
-- scadenza (data, senza orario. deve essere POSTERIORE alla data d'acquisto)
-- paese di provenieza (sigla di 3 caratteri)
-- soglia di riordino (obbligatoria)
CREATE TABLE prodotti(
    id SERIAL PRIMARY KEY,
    marca VARCHAR(15) NOT NULL,
    qnt_disp INTEGER NOT NULL CHECK (qnt_disp >= 0),
    prezzo_agg NUMERIC(7,2) CHECK (prezzo_agg >= 0),
    data_acquisto TIMESTAMP DEFAULT now(),
    scadenza DATE CHECK (scadenza > data_acquisto),
    provenienza CHAR(3),
    soglia_riordino INTEGER NOT NULL
);

CREATE DOMAIN dom_certificato AS VARCHAR CHECK (VALUE IN ('DOC', 'DOCG', 'IGT'));
ALTER TABLE prodotti ADD COLUMN certificato dom_certificato;


















