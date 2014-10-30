-- Lezione del 30 ottobre 2014

-- 1) marca e quantità disponibile dei prodotti che costano più di 1 euro
-- primo modo (selezione sul prodotto cartesiano) --> meno efficiente
SELECT P.marca, P.qnt_disponibile
FROM prodotto P, fornitura F
WHERE F.prodotto = P.id
AND F.costo_unitario > 1;
-- secondo modo (con JOIN)
SELECT P.marca, P.qnt_disponibile
FROM prodotto P JOIN fornitura F
ON F.prodotto = P.id
WHERE F.costo_unitario > 1;
-- terzo modo --> più efficiente
SELECT marca, qnt_disponibile
FROM prodotto
WHERE id IN (
	SELECT prodotto FROM fornitura
	WHERE costo_unitario > 1);

-- se prima della query metto EXPLAIN
-- al posto che darmi il risultato della query
-- mi dà il piano di esecuzione della query stessa
-- così vedo quale è la più efficiente

-- determinare il nome degli ingredienti che sono sia di categoria
-- vegetali che condimento
-- con INTERSECT
SELECT C.ingrediente
FROM classificazione C
WHERE C.categoria = 'Vegetali'
INTERSECT
SELECT C.ingrediente
FROM classificazione C
WHERE C.categoria = 'Condimento';

-- oppure con due query innestate
SELECT C.ingrediente
FROM classificazione C
WHERE C.categoria = 'Vegetali' AND C.ingrediente IN (
	SELECT C.ingrediente
	FROM classificazione C
	WHERE C.categoria = 'Condimento'
);


-- determinare il numero di forniture e la quantità totale di prodotto fornito
-- per ogni fornitore registrato nella base di dati
SELECT F.cf, A.prodotto, A.quantita
FROM fornitore F LEFT JOIN fornitura A
ON F.cf = A.fornitore;
-- con LEFT JOIN tengo i dati presi da F
-- anche se non hanno fatto nessuna fornitura

SELECT F.cf, COUNT(A.prodotto), SUM(A.quantita)
FROM fornitore F LEFT JOIN fornitura A
ON F.cf = A.fornitore GROUP BY F.cf;


-- per ogni marca di prodotto determinare
-- il costo complessivo e il costo medio delle foriture
SELECT P.marca, SUM(F.quantita * F.costo_unitario) AS costo_tot, AVG(F.quantita * F.costo_unitario) AS costo_medio
FROM prodotto P JOIN fornitura F
ON P.id = F.prodotto GROUP BY P.marca;


-- trovare la ricetta che ha il maggior numero di ingredienti
SELECT R.titolo -- , COUNT(RC.ricetta) AS numero_ingredienti
FROM ricetta R JOIN ricetta_composizione RC
ON R.id = RC.ricetta GROUP BY R.titolo
HAVING COUNT(RC.ricetta) >= ALL
	(SELECT COUNT(RC.ricetta)
	FROM ricetta R JOIN ricetta_composizione RC
	ON R.id = RC.ricetta
	GROUP BY R.titolo);


-- Per ogni coppia marca-ingrediente (di prodotto)
-- trovare il numero di piatti in cui questa coppia
-- è utilizzata (anche i prodotti non usati in nessun piatto,
-- in questo caso restituire 0)
SELECT P.marca, P.ingrediente, COUNT(UP.piatto) AS numero_piatti
FROM prodotto P LEFT JOIN uso_prodotto UP
ON P.id = UP.prodotto
GROUP BY P.marca, P.ingrediente;


-- Per ogni prodotto (espresso con marca-ingrediente)
-- che sono adatti per l'intolleranza al glutine
SELECT DISTINCT P.marca, P.ingrediente
FROM prodotto P
WHERE P.id NOT IN (
	SELECT I.prodotto
	FROM inadatto_a I
	WHERE I.intolleranza = 'Glutine');












