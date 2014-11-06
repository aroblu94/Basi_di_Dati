-- Lezione del 6 novembre 2014

-- Creare una funzione che restituisca un testo (varchar molto lungo o text)
-- che contiene il testo della ricetta
-- input: titolo ricetta
-- N.B. operatore di assegnamento a una variabile è: variabile := valore
-- stringa || stringa --> concatenazione
-- E'\n' ---> a capo
-- E'\t' ---> tab

-- tabella ricetta: titolo e tempo
CREATE OR REPLACE FUNCTION stampa_ricetta (r INTEGER)
RETURNS TEXT AS $$
	DECLARE
		k ricetta%ROWTYPE;
		i ricetta_composizione%ROWTYPE;
		append TEXT;
		report TEXT;
	BEGIN
		append := '';
		SELECT * INTO k FROM ricetta WHERE id = r;
		report := k.titolo || E'\n' || 'Tempo preparazione: ' || k.tempo || ' minuti' || E'\n' || E'\n';
		FOR i IN SELECT * FROM ricetta_composizione WHERE ricetta = k.id
			LOOP
				IF i.quantita IS NOT NULL THEN
					report := report || i.quantita || ' di ' || i.ingrediente || E'\n';
				ELSE
					append := append || E'\n' || i.ingrediente || ' q.b.' || E'\n';
				END IF;
			END LOOP;
		report := report || append;
		RETURN report;
	END;
$$ LANGUAGE plpgsql;

-- dato l'id di un piatto restituisce il costo della preparazione del piatto
-- dato dal costo di ogni prodotto utilizzato
CREATE OR REPLACE FUNCTION costo_piatto (r INTEGER)
RETURNS NUMERIC(6,2) AS $$
    DECLARE
        p piatto%ROWTYPE;
        c NUMERIC(6,2);
        prod prodotto.id%TYPE;
        cu fornitura.costo_unitario%TYPE;
        ingr prodotto.ingrediente%TYPE;
        quant ricetta_composizione.quantita%TYPE;
    BEGIN
        c := 0;
        SELECT * INTO p FROM piatto WHERE id = r;
        FOR prod, ingr, cu IN SELECT uso_prodotto.prodotto, prodotto.ingrediente, costo_unitario
            FROM uso_prodotto INNER JOIN prodotto ON uso_prodotto.prodotto = prodotto.id
            INNER JOIN fornitura ON prodotto.id = fornitura.prodotto WHERE piatto = p.id
        LOOP
            SELECT quantita INTO quant FROM ricetta_composizione
                WHERE ingrediente = ingr AND ricetta = p.ricetta;
                IF FOUND THEN
                    c := c + quant * cu;
                END IF;
        END LOOP;
        RETURN c;
    END;
$$ LANGUAGE plpgsql;


-- PROVE
-- seleziona id dei prodotti utilizzati in una ricetta
SELECT fornitura.prodotto, ricetta_composizione.quantita, fornitura.costo_unitario FROM fornitura, ricetta_composizione
WHERE prodotto IN (
    SELECT id FROM prodotto
        WHERE ingrediente IN (
            SELECT ingrediente FROM ricetta_composizione
            WHERE ricetta IN (
                SELECT ricetta FROM piatto
                WHERE id = '1'
            )
        )
    )
;

SELECT * FROM piatto NATURAL JOIN ricetta_composizione JOIN prodotto WHERE ;

SELECT U.piatto, P.ingrediente, F.costo_unitario
FROM uso_prodotto U JOIN prodotto P ON U.prodotto = P.id
JOIN fornitura F ON P.id = F.prodotto;

-- modificare la funzione precedente per aggiornare la tabella 'piatto'
-- aggiungendoci il costo. In questo modo quando verrà aggiunto un ingrediente al piatto
-- si aggiornerà automaticamente anche il costo
-- per prima cosa aggiungiamo il campo 'costo' nella tabella 'piatto'
ALTER TABLE piatto ADD COLUMN costo NUMERIC(6,2);

-- ora creiamo la funzione
CREATE OR REPLACE FUNCTION costo_piatto_auto (r INTEGER)
RETURNS VOID AS $$
    DECLARE
        p piatto%ROWTYPE;
        c NUMERIC(6,2);
        prod prodotto.id%TYPE;
        cu fornitura.costo_unitario%TYPE;
        ingr prodotto.ingrediente%TYPE;
        quant ricetta_composizione.quantita%TYPE;
    BEGIN
        c := 0;
        SELECT * INTO p FROM piatto WHERE id = r;
        FOR prod, ingr, cu IN SELECT uso_prodotto.prodotto, prodotto.ingrediente, costo_unitario
            FROM uso_prodotto INNER JOIN prodotto ON uso_prodotto.prodotto = prodotto.id
            INNER JOIN fornitura ON prodotto.id = fornitura.prodotto WHERE piatto = p.id
        LOOP
            SELECT quantita INTO quant FROM ricetta_composizione
                WHERE ingrediente = ingr AND ricetta = p.ricetta;
                IF FOUND THEN
                    c := c + quant * cu;
                END IF;
        END LOOP;
        UPDATE piatto SET costo = c
            WHERE id = p.id;
    END;
$$ LANGUAGE plpgsql;

-- prendo un piatto, prelevo la ricetta
-- controllo che ci sia coerenza tra i prodotti usati dalla ricetta e quelli usati dal piatto












