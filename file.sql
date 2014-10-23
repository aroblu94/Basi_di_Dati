-- Lezione del 23 ottobre 2014
-- Come importo uno script e ricreare il database?
-- file di dump: http://islab.di.unimi.it/teaching/plpgsql_schema.sql

-- .:FUNZIONI:.
-- 1) Dichiarare funzioni:
CREATE FUNCTION somma (a1 INTEGER, a2 INTEGER)
-- restituisce la somma di due numeri interi forniti in input
	RETURN INTEGER AS $$
	BEGIN
		RETURN a1 + a2;
	END;
$$ LANGUAGE plpgsql;

-- invocare una funzione:
SELECT somma(4,5);

-- eliminare una funzione
DROP FUNCTION <nomefunzione>

-- oppure usando "OUT":
CREATE FUNCTION somma (a1 INTEGER, a2 INTEGER, OUT result INTEGER)
	AS $$
	BEGIN
		result := a1 + a2;
	END;
$$ LANGUAGE plpgsql;

-- --------------------------------------------------------------------
CREATE OR REPLACE FUNCTION get_ingrediente_cat (varchar)
RETURN varchar AS $$
	DECLARE
		categoria_ingrediente classificazione-categoria %TYPE;
	BEGIN
		SELECT categoria INTO categoria_ingrediente FROM classificazione WHERE ingrediente = $1;
		RETURN categoria_ingrediente;
	END;
$$ LANGUAGE plpgsql;

-- funzione ricorsiva
CREATE OR REPLACE FUNCTION print_cat (varchar) RETURNS SETOF varchar AS $$
	DECLARE
		cat categoria%ROWTYPE;
	BEGIN
		SELECT * INTO cat FROM categoria WHERE nome = $1;
		RETURN NEXT cat.nome;
		IF cat.sopra_categoria IS NOT NULL THEN
			RETURN QUERY SELECT * FROM print_cat(cat.sopra_categoria);
		END IF;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

SELECT * FROM print_cat('Carne');

-- .:FOR:.
-- FOR <condizione>
-- LOOP ...
-- END LOOP


-- .:ESERCIZIO:.
-- Creare funzione per cui dato in input l'id di una ricetta
-- restituisce l'elenco degli ingredienti utilizzati dalla ricetta
CREATE OR REPLACE FUNCTION get_ingredients (INTEGER)
	RETURNS SETOF VARCHAR AS $$
	DECLARE
-- la variabile ingredient ha lo stesso TIPO della variabile ingrediente
-- nella tabella ricetta_composizione
		ingredient ricetta_composizione.ingrediente%TYPE;
	BEGIN
		FOR ingredient IN
			SELECT ingrediente FROM ricetta_composizione
			WHERE ricetta = $1
		LOOP
			RETURN NEXT ingredient;
		END LOOP;
		RETURN;
	END;
$$ LANGUAGE plpgsql;


-- funzione che restituisca tutti i piatti che sono compatibili con la data intolleranza
CREATE OR REPLACE FUNCTION get_piatti_per_intolleranza(VARCHAR)
	RETURNS SETOF INTEGER AS $$
	DECLARE
		dishes uso_prodotto.piatto%TYPE;
	BEGIN
-- in pratica prendo da tutti i piatti quelli che hanno ingredienti
-- inadatti all'intolleranza e poi li sottraggo a tutti i piatti,
-- ritornando il risultato (perchè non posso selezionare
-- degli elementi che NON presentano determinate cose, devo fare
-- questo workaround
		FOR dishes IN
			SELECT piatto FROM uso_prodotto
			EXCEPT
			SELECT piatto FROM uso_prodotto WHERE prodotto IN
			(SELECT prodotto FROM inadatto_a WHERE intolleranza = $1)
		LOOP
			RETURN NEXT dishes;
		END LOOP;
		RETURN;
	END;
$$ LANGUAGE plpgsql;


-- Altra funzione "trovaricetta"
-- fornire come input il nome di un ingrediente e il tempo massimo richiesto per la preparazione
-- restituisca il titolo e il tempo di preparazione delle ricette che rispettano gli input
CREATE OR REPLACE FUNCTION trovaricetta(VARCHAR, INTEGER)
	RETURNS SETOF ricetta AS $$
	DECLARE
		rec  ricetta%ROWTYPE;
	BEGIN
		FOR rec IN
			SELECT ricetta FROM ricetta_composizione, ricetta
			WHERE (ingrediente = $1) AND (ricetta.tempo < $2)
		LOOP
			RETURN NEXT rec;
		END LOOP;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

















