-- sql dump per esempi con PLpgSQL
-- database ristorante
--
-- sql dump per esempi con PLpgSQL
-- database ristorante
--

-- SET search_path TO schema1;
-- per cambiare lo schema (di default è public)

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- Name: dom_certificato; Type: DOMAIN; Schema: public; Owner: --
--

CREATE DOMAIN dom_certificato AS character varying
	CONSTRAINT dom_certificato_check CHECK (((VALUE)::text = ANY ((ARRAY[NULL::character varying, 'DOC'::character varying, 'DOCG'::character varying, 'IGT'::character varying])::text[])));


--
-- Name: categoria; Type: TABLE; Schema: public; Owner: --; Tablespace: 
--

CREATE TABLE categoria (
    nome character varying NOT NULL,
    sopra_categoria character varying
);


--
-- Name: classificazione; Type: TABLE; Schema: public; Owner: --; Tablespace: 
--

CREATE TABLE classificazione (
    ingrediente character varying NOT NULL,
    categoria character varying NOT NULL
);


--
-- Name: fornitore; Type: TABLE; Schema: public; Owner: --; Tablespace: 
--

CREATE TABLE fornitore (
    cf character(16) NOT NULL,
    nominativo character varying(250) NOT NULL,
    indirizzo character varying(500),
    cap character(5),
    citta character varying(50),
    tel character varying(20),
    p_iva character varying(20),
    consegne_ora_da numeric(4,2),
    consegne_ora_a numeric(4,2)
);


--
-- Name: fornitura; Type: TABLE; Schema: public; Owner: --; Tablespace: 
--

CREATE TABLE fornitura (
    prodotto integer NOT NULL,
    fornitore character(16) NOT NULL,
    data timestamp without time zone DEFAULT now() NOT NULL,
    quantita integer NOT NULL,
    costo_unitario numeric(5,2) NOT NULL,
    CONSTRAINT fornitura_costo_unitario_check CHECK ((costo_unitario >= (0)::numeric)),
    CONSTRAINT fornitura_quantita_check CHECK ((quantita >= 0))
);


--
-- Name: inadatto_a; Type: TABLE; Schema: public; Owner: --; Tablespace: 
--

CREATE TABLE inadatto_a (
    prodotto integer NOT NULL,
    intolleranza character varying NOT NULL
);


--
-- Name: ingrediente; Type: TABLE; Schema: public; Owner: --; Tablespace: 
--

CREATE TABLE ingrediente (
    nome character varying NOT NULL,
    stagione character varying
);


--
-- Name: intolleranza; Type: TABLE; Schema: public; Owner: --; Tablespace: 
--

CREATE TABLE intolleranza (
    nome character varying NOT NULL
);


--
-- Name: menu; Type: TABLE; Schema: public; Owner: --; Tablespace: 
--

CREATE TABLE menu (
    id integer NOT NULL,
    titolo character varying(250) NOT NULL
);


--
-- Name: menu_composizione; Type: TABLE; Schema: public; Owner: --; Tablespace: 
--

CREATE TABLE menu_composizione (
    menu integer NOT NULL,
    piatto integer NOT NULL,
    prezzo_cliente numeric(5,2) DEFAULT 10.00
);



--
-- Name: menu_id_seq; Type: SEQUENCE; Schema: public; Owner: --
--

CREATE SEQUENCE menu_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--
-- Name: menu_id_seq; Type: SEQUENCE SET; Schema: public; Owner: --
--

SELECT pg_catalog.setval('menu_id_seq', 1, false);


--
-- Name: piatto; Type: TABLE; Schema: public; Owner: --; Tablespace: 
--

CREATE TABLE piatto (
    id integer NOT NULL,
    nome character varying(50) UNIQUE NOT NULL,
    ricetta integer NOT NULL
);


--
-- Name: piatto_id_seq; Type: SEQUENCE; Schema: public; Owner: --
--

CREATE SEQUENCE piatto_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: prodotto; Type: TABLE; Schema: public; Owner: --; Tablespace: 
--

CREATE TABLE prodotto (
    id integer NOT NULL,
    marca character varying(200) NOT NULL,
    qnt_disponibile integer NOT NULL,
    prezzo_aggiunta double precision,
    data_acquisto timestamp without time zone DEFAULT now(),
    scadenza date,
    paese_provenienza character(3),
    soglia_riordino integer NOT NULL,
    ingrediente character varying NOT NULL,
    certificato dom_certificato,
    CONSTRAINT prodotto_check CHECK ((scadenza > data_acquisto)),
    CONSTRAINT prodotto_prezzo_aggiunta_check CHECK ((prezzo_aggiunta >= (0.0)::double precision)),
    CONSTRAINT prodotto_qnt_disponibile_check CHECK ((qnt_disponibile >= 0))
);


--
-- Name: prodotto_id_seq; Type: SEQUENCE; Schema: public; Owner: --
--

CREATE SEQUENCE prodotto_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ricetta; Type: TABLE; Schema: public; Owner: --; Tablespace: 
--

CREATE TABLE ricetta (
    id integer NOT NULL,
    titolo character varying(50) UNIQUE NOT NULL,
    tempo integer,
    presentazione text
);


--
-- Name: ricetta_composizione; Type: TABLE; Schema: public; Owner: --; Tablespace: 
--

CREATE TABLE ricetta_composizione (
    ricetta integer NOT NULL,
    ingrediente character varying NOT NULL,
    quantita integer NOT NULL,
    CONSTRAINT ricetta_composizione_quantita_check CHECK ((quantita >= 0))
);


--
-- Name: ricetta_id_gen; Type: SEQUENCE; Schema: public; Owner: --
--

CREATE SEQUENCE ricetta_id_gen
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ricetta_id_seq; Type: SEQUENCE; Schema: public; Owner: --
--

CREATE SEQUENCE ricetta_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: usa; Type: TABLE; Schema: public; Owner: --; Tablespace: 
--

CREATE TABLE usa (
    ricetta integer NOT NULL,
    usata integer NOT NULL
);


--
-- Name: uso_prodotto; Type: TABLE; Schema: public; Owner: --; Tablespace: 
--

CREATE TABLE uso_prodotto (
    piatto integer NOT NULL,
    prodotto integer NOT NULL
);



--
-- Name: id; Type: DEFAULT; Schema: public; Owner: --
--

ALTER TABLE ONLY menu ALTER COLUMN id SET DEFAULT nextval('menu_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: --
--

ALTER TABLE ONLY piatto ALTER COLUMN id SET DEFAULT nextval('piatto_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: --
--

ALTER TABLE ONLY prodotto ALTER COLUMN id SET DEFAULT nextval('prodotto_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: --
--

ALTER TABLE ONLY ricetta ALTER COLUMN id SET DEFAULT nextval('ricetta_id_seq'::regclass);



--
-- Data for Name: categoria; Type: TABLE DATA; Schema: public; Owner: --
--

INSERT INTO categoria (nome, sopra_categoria) VALUES ('Carne', NULL);
INSERT INTO categoria (nome, sopra_categoria) VALUES ('Vitello', 'Carne');
INSERT INTO categoria (nome, sopra_categoria) VALUES ('Manzo', 'Carne');
INSERT INTO categoria (nome, sopra_categoria) VALUES ('Maiale', 'Carne');
INSERT INTO categoria (nome, sopra_categoria) VALUES ('Agnello', 'Carne');
INSERT INTO categoria (nome, sopra_categoria) VALUES ('Vegetali', NULL);
INSERT INTO categoria (nome, sopra_categoria) VALUES ('Verdura', 'Vegetali');
INSERT INTO categoria (nome, sopra_categoria) VALUES ('Latticino', NULL);
INSERT INTO categoria (nome, sopra_categoria) VALUES ('Formaggio', 'Latticino');
INSERT INTO categoria (nome, sopra_categoria) VALUES ('Pasta', NULL);
INSERT INTO categoria (nome, sopra_categoria) VALUES ('Condimento', NULL);


--
-- Data for Name: classificazione; Type: TABLE DATA; Schema: public; Owner: --
--

INSERT INTO classificazione (ingrediente, categoria) VALUES ('Grana', 'Formaggio');
INSERT INTO classificazione (ingrediente, categoria) VALUES ('Pecorino', 'Formaggio');
INSERT INTO classificazione (ingrediente, categoria) VALUES ('Foglia basilico', 'Vegetali');
INSERT INTO classificazione (ingrediente, categoria) VALUES ('Pinoli', 'Vegetali');
INSERT INTO classificazione (ingrediente, categoria) VALUES ('Bavette', 'Pasta');
INSERT INTO classificazione (ingrediente, categoria) VALUES (E'Olio d\'oliva', 'Vegetali');
INSERT INTO classificazione (ingrediente, categoria) VALUES (E'Olio d\'oliva', 'Condimento');



--
-- Data for Name: fornitore; Type: TABLE DATA; Schema: public; Owner: --
--

INSERT INTO fornitore (cf, nominativo, indirizzo, cap, citta, tel, p_iva, consegne_ora_da, consegne_ora_a) VALUES ('KDDSBD201B78210D', 'Forniture Gino e Figli', 'via delle Forniture 18', '20135', 'Milano', '333982828192', '', 10.00, 19.00);
INSERT INTO fornitore (cf, nominativo, indirizzo, cap, citta, tel, p_iva, consegne_ora_da, consegne_ora_a) VALUES ('ABBETT201B78210D', 'Marco Fornitore', 'via Trasporti 6', '80120', 'Napoli', '3420039920', '', 6.00, 12.00);


--
-- Data for Name: fornitura; Type: TABLE DATA; Schema: public; Owner: --
--

INSERT INTO fornitura (prodotto, fornitore, data, quantita, costo_unitario) VALUES (1, 'ABBETT201B78210D', '2014-10-20 18:13:38', 200, 1.10);
INSERT INTO fornitura (prodotto, fornitore, data, quantita, costo_unitario) VALUES (3, 'KDDSBD201B78210D', '2014-10-20 18:15:08', 50, 10.00);
INSERT INTO fornitura (prodotto, fornitore, data, quantita, costo_unitario) VALUES (5, 'ABBETT201B78210D', '2014-08-06 18:15:28', 200, 6.00);
INSERT INTO fornitura (prodotto, fornitore, data, quantita, costo_unitario) VALUES (9, 'KDDSBD201B78210D', '2014-10-20 18:15:08', 50, 0.01);
INSERT INTO fornitura (prodotto, fornitore, data, quantita, costo_unitario) VALUES (12, 'KDDSBD201B78210D', '2014-10-20 18:15:08', 50, 0.2);
INSERT INTO fornitura (prodotto, fornitore, data, quantita, costo_unitario) VALUES (13, 'KDDSBD201B78210D', '2014-10-20 18:15:08', 10, 0.02);

--
-- Data for Name: inadatto_a; Type: TABLE DATA; Schema: public; Owner: --
--

INSERT INTO inadatto_a (prodotto, intolleranza) VALUES (1, 'Glutine');
INSERT INTO inadatto_a (prodotto, intolleranza) VALUES (2, 'Glutine');
INSERT INTO inadatto_a (prodotto, intolleranza) VALUES (7, 'Latticini');
INSERT INTO inadatto_a (prodotto, intolleranza) VALUES (11, 'Latticini');


--
-- Data for Name: ingrediente; Type: TABLE DATA; Schema: public; Owner: --
--

INSERT INTO ingrediente (nome, stagione) VALUES ('Foglia basilico', '');
INSERT INTO ingrediente (nome, stagione) VALUES ('Grana', '');
INSERT INTO ingrediente (nome, stagione) VALUES (E'Olio d\'oliva', '');
INSERT INTO ingrediente (nome, stagione) VALUES ('Spicchio aglio', '');
INSERT INTO ingrediente (nome, stagione) VALUES ('Pinoli', '');
INSERT INTO ingrediente (nome, stagione) VALUES ('Sale', '');
INSERT INTO ingrediente (nome, stagione) VALUES ('Pepe', '');
INSERT INTO ingrediente (nome, stagione) VALUES ('Pecorino', '');
INSERT INTO ingrediente (nome, stagione) VALUES ('Bavette', '');
INSERT INTO ingrediente (nome, stagione) VALUES ('Fagiolini', '');
INSERT INTO ingrediente (nome, stagione) VALUES ('Patate', '');
INSERT INTO ingrediente (nome, stagione) VALUES ('Rosmarino', '');


--
-- Data for Name: intolleranza; Type: TABLE DATA; Schema: public; Owner: --
--

INSERT INTO intolleranza (nome) VALUES ('Arachidi');
INSERT INTO intolleranza (nome) VALUES ('Glutine');
INSERT INTO intolleranza (nome) VALUES ('Noci');
INSERT INTO intolleranza (nome) VALUES ('Latticini');


--
-- Data for Name: menu; Type: TABLE DATA; Schema: public; Owner: --
--

INSERT INTO menu (id, titolo) VALUES (1, 'Tutto al pesto');
INSERT INTO menu (id, titolo) VALUES (2, 'Carne per tutti');


--
-- Data for Name: menu_composizione; Type: TABLE DATA; Schema: public; Owner: --
--

INSERT INTO menu_composizione (menu, piatto, prezzo_cliente) VALUES (1, 1, 12.50);


--
-- Data for Name: piatto; Type: TABLE DATA; Schema: public; Owner: --
--

INSERT INTO piatto (id, nome, ricetta) VALUES (1, 'Bavette al pesto di Gino', 2);
INSERT INTO piatto (id, nome, ricetta) VALUES (2, 'Le patate sfiziose', 3);


--
-- Data for Name: prodotto; Type: TABLE DATA; Schema: public; Owner: --
--

INSERT INTO prodotto (id, marca, qnt_disponibile, prezzo_aggiunta, data_acquisto, scadenza, paese_provenienza, soglia_riordino, ingrediente, certificato) VALUES (1, 'De Cecco', 50, 1, '2014-10-20 17:26:41', '2016-10-20', 'ita', 10, 'Bavette', '');
INSERT INTO prodotto (id, marca, qnt_disponibile, prezzo_aggiunta, data_acquisto, scadenza, paese_provenienza, soglia_riordino, ingrediente, certificato) VALUES (2, 'Buitoni', 90, 1, '2014-10-20 17:35:23', '2017-10-20', 'ita', 10, 'Bavette', '');
INSERT INTO prodotto (id, marca, qnt_disponibile, prezzo_aggiunta, data_acquisto, scadenza, paese_provenienza, soglia_riordino, ingrediente, certificato) VALUES (3, 'Mercato', 10, 2, '2014-10-20 17:36:34', '2014-10-30', 'ita', 2, 'Fagiolini', 'IGT');
INSERT INTO prodotto (id, marca, qnt_disponibile, prezzo_aggiunta, data_acquisto, scadenza, paese_provenienza, soglia_riordino, ingrediente, certificato) VALUES (4, 'Mercato', 10, 0, '2014-10-20 17:37:36', '2014-10-30', 'ita', 5, 'Spicchio aglio', '');
INSERT INTO prodotto (id, marca, qnt_disponibile, prezzo_aggiunta, data_acquisto, scadenza, paese_provenienza, soglia_riordino, ingrediente, certificato) VALUES (5, E'Terre d\'Italia', 200000, 0, '2014-10-20 17:39:14', '2015-10-20', 'ita', 50000, E'Olio d\'oliva', 'IGT');
INSERT INTO prodotto (id, marca, qnt_disponibile, prezzo_aggiunta, data_acquisto, scadenza, paese_provenienza, soglia_riordino, ingrediente, certificato) VALUES (7, 'Mercato', 200, 0, '2014-10-20 18:03:50.828577', '2014-11-09', 'ita', 50, 'Grana', '');
INSERT INTO prodotto (id, marca, qnt_disponibile, prezzo_aggiunta, data_acquisto, scadenza, paese_provenienza, soglia_riordino, ingrediente, certificato) VALUES (8, 'Mercato', 200, 0, '2014-10-20 18:03:50.828577', '2014-11-09', 'ita', 50, 'Pinoli', '');
INSERT INTO prodotto (id, marca, qnt_disponibile, prezzo_aggiunta, data_acquisto, scadenza, paese_provenienza, soglia_riordino, ingrediente, certificato) VALUES (9, 'Mercato', 200, 0, '2014-10-20 18:03:50.828577', '2014-11-09', 'ita', 50, 'Sale', '');
INSERT INTO prodotto (id, marca, qnt_disponibile, prezzo_aggiunta, data_acquisto, scadenza, paese_provenienza, soglia_riordino, ingrediente, certificato) VALUES (10, 'Mercato', 200, 0, '2014-10-20 18:03:50.828577', '2014-11-09', 'ita', 50, 'Pepe', '');
INSERT INTO prodotto (id, marca, qnt_disponibile, prezzo_aggiunta, data_acquisto, scadenza, paese_provenienza, soglia_riordino, ingrediente, certificato) VALUES (11, 'Mercato', 200, 0, '2014-10-20 18:03:50.828577', '2014-11-09', 'ita', 50, 'Pecorino', '');
INSERT INTO prodotto (id, marca, qnt_disponibile, prezzo_aggiunta, data_acquisto, scadenza, paese_provenienza, soglia_riordino, ingrediente, certificato) VALUES (12, 'Mercato', 600, 0, '2014-10-20 18:03:50.828577', '2014-11-09', 'ita', 50, 'Patate', '');
INSERT INTO prodotto (id, marca, qnt_disponibile, prezzo_aggiunta, data_acquisto, scadenza, paese_provenienza, soglia_riordino, ingrediente, certificato) VALUES (6, 'Mercato', 200, NULL, '2014-10-20 18:03:50', '2014-10-30', 'ita', 50, 'Foglia basilico', '');
INSERT INTO prodotto (id, marca, qnt_disponibile, prezzo_aggiunta, data_acquisto, scadenza, paese_provenienza, soglia_riordino, ingrediente, certificato) VALUES (13, 'Mercato', 10, NULL, '2014-10-20 18:03:50', '2014-10-30', 'ita', 50, 'Rosmarino', '');


--
-- Data for Name: ricetta; Type: TABLE DATA; Schema: public; Owner: --
--

INSERT INTO ricetta (id, titolo, tempo, presentazione) VALUES (1, 'Pesto alla genovese', 20, E'Parlando di pesto viene in mente subito la Liguria: è in questa splendida regione infatti che, con sapiente cura, nasce questa salsa che si dice addirittura sia afrodisiaca.

Il pesto è una salsa fredda, sinonimo e simbolo di Genova e dell\'intera Liguria, che da alcuni decenni è tra le salse più conosciute e diffuse nel mondo. 

Le prime tracce del pesto le troviamo addirittura nell\'800 e da allora, la ricetta si è sempre mantenuta identica, almeno nella preparazione casalinga. Per fare il vero pesto alla genovese occorrono un mortaio di marmo e un pestello di legno e... molta pazienza.

Come ogni ricetta tradizionale, ogni famiglia ha la sua ricetta del pesto alla genovese, quella che vi proponiamo in questa ricetta è quella del Consorzio del pesto genovese.');
INSERT INTO ricetta (id, titolo, tempo, presentazione) VALUES (2, 'Bavette al pesto, patate e fagiolini', 25, E'Le bavette al pesto, fagiolini e patate è una versione piuttosto antica e arricchita della pasta con pesto, che potete gustare nei locali di cucina tipica in Liguria, e viene definita pesto ricco (o avvantaggiato). 

L\'aggiunta di patate e fagiolini rende davvero appetitosa questa pietanza che piacerà moltissimo anche ai vegetariani.');
INSERT INTO ricetta (id, titolo, tempo, presentazione) VALUES (3, 'Patate al forno', 40, 'Le patate al forno sono un piatto semplice e gustoso. Pe prepararle è sufficiente un forno e un poco di pazienza...');


--
-- Data for Name: ricetta_composizione; Type: TABLE DATA; Schema: public; Owner: --
--

INSERT INTO ricetta_composizione (ricetta, ingrediente, quantita) VALUES (1, 'Foglia basilico', 50);
INSERT INTO ricetta_composizione (ricetta, ingrediente, quantita) VALUES (1, 'Spicchio aglio', 2);
INSERT INTO ricetta_composizione (ricetta, ingrediente, quantita) VALUES (1, 'Grana', 70);
INSERT INTO ricetta_composizione (ricetta, ingrediente, quantita) VALUES (1, 'Sale', 1);
INSERT INTO ricetta_composizione (ricetta, ingrediente, quantita) VALUES (1, 'Pepe', 1);
INSERT INTO ricetta_composizione (ricetta, ingrediente, quantita) VALUES (1, 'Pecorino', 30);
INSERT INTO ricetta_composizione (ricetta, ingrediente, quantita) VALUES (1, E'Olio d\'oliva', 100);
INSERT INTO ricetta_composizione (ricetta, ingrediente, quantita) VALUES (1, 'Pinoli', 15);
INSERT INTO ricetta_composizione (ricetta, ingrediente, quantita) VALUES (2, 'Bavette', 1);
INSERT INTO ricetta_composizione (ricetta, ingrediente, quantita) VALUES (2, 'Fagiolini', 200);
INSERT INTO ricetta_composizione (ricetta, ingrediente, quantita) VALUES (2, 'Patate', 2);
INSERT INTO ricetta_composizione (ricetta, ingrediente, quantita) VALUES (2, E'Olio d\'oliva', 10);
INSERT INTO ricetta_composizione (ricetta, ingrediente, quantita) VALUES (3, 'Patate', 3);
INSERT INTO ricetta_composizione (ricetta, ingrediente, quantita) VALUES (3, E'Olio d\'oliva', 5);
INSERT INTO ricetta_composizione (ricetta, ingrediente, quantita) VALUES (3, 'Rosmarino',1);
INSERT INTO ricetta_composizione (ricetta, ingrediente, quantita) VALUES (3, 'Sale',1);

--
-- Data for Name: usa; Type: TABLE DATA; Schema: public; Owner: --
--

INSERT INTO usa (ricetta, usata) VALUES (2, 1);


--
-- Data for Name: uso_prodotto; Type: TABLE DATA; Schema: public; Owner: --
--

INSERT INTO uso_prodotto (piatto, prodotto) VALUES (1, 1);
INSERT INTO uso_prodotto (piatto, prodotto) VALUES (1, 4);
INSERT INTO uso_prodotto (piatto, prodotto) VALUES (1, 6);
INSERT INTO uso_prodotto (piatto, prodotto) VALUES (1, 5);
INSERT INTO uso_prodotto (piatto, prodotto) VALUES (2, 5);
INSERT INTO uso_prodotto (piatto, prodotto) VALUES (2, 12);
INSERT INTO uso_prodotto (piatto, prodotto) VALUES (2, 13);
INSERT INTO uso_prodotto (piatto, prodotto) VALUES (2, 9);


ALTER TABLE ONLY categoria
    ADD CONSTRAINT categoria_pkey PRIMARY KEY (nome);


--
-- Name: classificazione_pkey; Type: CONSTRAINT; Schema: public; Owner: --; Tablespace: 
--

ALTER TABLE ONLY classificazione
    ADD CONSTRAINT classificazione_pkey PRIMARY KEY (ingrediente, categoria);


--
-- Name: fornitore_pkey; Type: CONSTRAINT; Schema: public; Owner: --; Tablespace: 
--

ALTER TABLE ONLY fornitore
    ADD CONSTRAINT fornitore_pkey PRIMARY KEY (cf);


--
-- Name: fornitura_pkey; Type: CONSTRAINT; Schema: public; Owner: --; Tablespace: 
--

ALTER TABLE ONLY fornitura
    ADD CONSTRAINT fornitura_pkey PRIMARY KEY (prodotto, fornitore, data);


--
-- Name: inadatto_a_pkey; Type: CONSTRAINT; Schema: public; Owner: --; Tablespace: 
--

ALTER TABLE ONLY inadatto_a
    ADD CONSTRAINT inadatto_a_pkey PRIMARY KEY (prodotto, intolleranza);


--
-- Name: ingrediente_pkey; Type: CONSTRAINT; Schema: public; Owner: --; Tablespace: 
--

ALTER TABLE ONLY ingrediente
    ADD CONSTRAINT ingrediente_pkey PRIMARY KEY (nome);


--
-- Name: intolleranza_pkey; Type: CONSTRAINT; Schema: public; Owner: --; Tablespace: 
--

ALTER TABLE ONLY intolleranza
    ADD CONSTRAINT intolleranza_pkey PRIMARY KEY (nome);


--
-- Name: menu_composizione_pkey; Type: CONSTRAINT; Schema: public; Owner: --; Tablespace: 
--

ALTER TABLE ONLY menu_composizione
    ADD CONSTRAINT menu_composizione_pkey PRIMARY KEY (menu, piatto);


--
-- Name: menu_pkey; Type: CONSTRAINT; Schema: public; Owner: --; Tablespace: 
--

ALTER TABLE ONLY menu
    ADD CONSTRAINT menu_pkey PRIMARY KEY (id);


--
-- Name: piatto_nome_key; Type: CONSTRAINT; Schema: public; Owner: --; Tablespace: 
--

-- ALTER TABLE ONLY piatto
--    ADD CONSTRAINT piatto_nome_key UNIQUE (nome);


--
-- Name: piatto_pkey; Type: CONSTRAINT; Schema: public; Owner: --; Tablespace: 
--

ALTER TABLE ONLY piatto
    ADD CONSTRAINT piatto_pkey PRIMARY KEY (id);


--
-- Name: prodotto_pkey; Type: CONSTRAINT; Schema: public; Owner: --; Tablespace: 
--

ALTER TABLE ONLY prodotto
    ADD CONSTRAINT prodotto_pkey PRIMARY KEY (id);


--
-- Name: ricetta_composizione_pkey; Type: CONSTRAINT; Schema: public; Owner: --; Tablespace: 
--

ALTER TABLE ONLY ricetta_composizione
    ADD CONSTRAINT ricetta_composizione_pkey PRIMARY KEY (ricetta, ingrediente, quantita);


--
-- Name: ricetta_pkey; Type: CONSTRAINT; Schema: public; Owner: --; Tablespace: 
--

ALTER TABLE ONLY ricetta
    ADD CONSTRAINT ricetta_pkey PRIMARY KEY (id);


--
-- Name: usa_pkey; Type: CONSTRAINT; Schema: public; Owner: --; Tablespace: 
--

ALTER TABLE ONLY usa
    ADD CONSTRAINT usa_pkey PRIMARY KEY (ricetta, usata);


--
-- Name: uso_prodotto_pkey; Type: CONSTRAINT; Schema: public; Owner: --; Tablespace: 
--

ALTER TABLE ONLY uso_prodotto
    ADD CONSTRAINT uso_prodotto_pkey PRIMARY KEY (piatto, prodotto);


--
-- Name: categoria_sopra_categoria_fkey; Type: FK CONSTRAINT; Schema: public; Owner: --
--

ALTER TABLE ONLY categoria
    ADD CONSTRAINT categoria_sopra_categoria_fkey FOREIGN KEY (sopra_categoria) REFERENCES categoria(nome) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: classificazione_categoria_fkey; Type: FK CONSTRAINT; Schema: public; Owner: --
--

ALTER TABLE ONLY classificazione
    ADD CONSTRAINT classificazione_categoria_fkey FOREIGN KEY (categoria) REFERENCES categoria(nome) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: classificazione_ingrediente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: --
--

ALTER TABLE ONLY classificazione
    ADD CONSTRAINT classificazione_ingrediente_fkey FOREIGN KEY (ingrediente) REFERENCES ingrediente(nome) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fornitura_fornitore_fkey; Type: FK CONSTRAINT; Schema: public; Owner: --
--

ALTER TABLE ONLY fornitura
    ADD CONSTRAINT fornitura_fornitore_fkey FOREIGN KEY (fornitore) REFERENCES fornitore(cf) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fornitura_prodotto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: --
--

ALTER TABLE ONLY fornitura
    ADD CONSTRAINT fornitura_prodotto_fkey FOREIGN KEY (prodotto) REFERENCES prodotto(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inadatto_a_intolleranza_fkey; Type: FK CONSTRAINT; Schema: public; Owner: --
--

ALTER TABLE ONLY inadatto_a
    ADD CONSTRAINT inadatto_a_intolleranza_fkey FOREIGN KEY (intolleranza) REFERENCES intolleranza(nome);


--
-- Name: inadatto_a_prodotto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: --
--

ALTER TABLE ONLY inadatto_a
    ADD CONSTRAINT inadatto_a_prodotto_fkey FOREIGN KEY (prodotto) REFERENCES prodotto(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: menu_composizione_menu_fkey; Type: FK CONSTRAINT; Schema: public; Owner: --
--

ALTER TABLE ONLY menu_composizione
    ADD CONSTRAINT menu_composizione_menu_fkey FOREIGN KEY (menu) REFERENCES menu(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: menu_composizione_piatto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: --
--

ALTER TABLE ONLY menu_composizione
    ADD CONSTRAINT menu_composizione_piatto_fkey FOREIGN KEY (piatto) REFERENCES piatto(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: piatto_ricetta_fkey; Type: FK CONSTRAINT; Schema: public; Owner: --
--

ALTER TABLE ONLY piatto
    ADD CONSTRAINT piatto_ricetta_fkey FOREIGN KEY (ricetta) REFERENCES ricetta(id) ON UPDATE CASCADE;


--
-- Name: prodotto_ingrediente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: --
--

ALTER TABLE ONLY prodotto
    ADD CONSTRAINT prodotto_ingrediente_fkey FOREIGN KEY (ingrediente) REFERENCES ingrediente(nome) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ricetta_composizione_ingrediente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: --
--

ALTER TABLE ONLY ricetta_composizione
    ADD CONSTRAINT ricetta_composizione_ingrediente_fkey FOREIGN KEY (ingrediente) REFERENCES ingrediente(nome) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ricetta_composizione_ricetta_fkey; Type: FK CONSTRAINT; Schema: public; Owner: --
--

ALTER TABLE ONLY ricetta_composizione
    ADD CONSTRAINT ricetta_composizione_ricetta_fkey FOREIGN KEY (ricetta) REFERENCES ricetta(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: usa_ricetta_fkey; Type: FK CONSTRAINT; Schema: public; Owner: --
--

ALTER TABLE ONLY usa
    ADD CONSTRAINT usa_ricetta_fkey FOREIGN KEY (ricetta) REFERENCES ricetta(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: usa_usata_fkey; Type: FK CONSTRAINT; Schema: public; Owner: --
--

ALTER TABLE ONLY usa
    ADD CONSTRAINT usa_usata_fkey FOREIGN KEY (usata) REFERENCES ricetta(id) ON UPDATE CASCADE ON DELETE CASCADE;

--
-- Name: uso_prodotto_piatto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: --
--

ALTER TABLE ONLY uso_prodotto
    ADD CONSTRAINT uso_prodotto_piatto_fkey FOREIGN KEY (piatto) REFERENCES piatto(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: uso_prodotto_prodotto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: --
--

ALTER TABLE ONLY uso_prodotto
    ADD CONSTRAINT uso_prodotto_prodotto_fkey FOREIGN KEY (prodotto) REFERENCES prodotto(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- database dump complete
--

