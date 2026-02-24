CREATE DATABASE ToysGroup;

USE ToysGroup;

SHOW DATABASES; 
#Ho creato il Database 

CREATE TABLE Categoria (
    IdCategoria INT,
    NomeCategoria VARCHAR(100),
    PRIMARY KEY (IdCategoria)
);
#ho creato la tabella categoria
SHOW TABLES;
CREATE TABLE RegioneVendita (
    IdRegioneVendita INT,
    NomeRegioneVendita VARCHAR(100),
    PRIMARY KEY (IdRegioneVendita)
);
#ho creato la tabella Regione Vendita
SHOW TABLES;
CREATE TABLE Stato (
    IdStato INT,
    NomeStato VARCHAR(100),
    IdRegioneVendita INT,
    PRIMARY KEY (IdStato),
    FOREIGN KEY (IdRegioneVendita)
        REFERENCES RegioneVendita(IdRegioneVendita)
);
#ho creato la tabella Stato, creando una relazione fra le tabelle Stato e Regione Vendita grazie alla Foreign Key e References(che mi garantisce l'integrità referenziale)
SHOW TABLES;
CREATE TABLE Prodotto (
    IdProdotto INT,
    NomeProdotto VARCHAR(150),
    CodiceArticolo VARCHAR(50),
    PrezzoListino DECIMAL(10,2),
    IdCategoria INT,
    PRIMARY KEY (IdProdotto),
    FOREIGN KEY (IdCategoria)
        REFERENCES Categoria(IdCategoria)
);
#ho creato la tabella Prodotto, creando una relazione fra le tabelle Prodotto e e Categoria come fatto in precedenza con Foreign Key e a seguire References
SHOW TABLES;
CREATE TABLE Vendita (
    IdVendita INT,
    DataVendita DATE,
    Quantita INT,
    PrezzoUnitario DECIMAL(10,2),
    IdProdotto INT,
    IdStato INT,
    PRIMARY KEY (IdVendita),
    FOREIGN KEY (IdProdotto)
        REFERENCES Prodotto(IdProdotto),
    FOREIGN KEY (IdStato)
        REFERENCES Stato(IdStato)
);
#ho creato l'ultima tabella con il nome Vendita, creando relazioni fra più tabelle (Vendita con Prodotto e Vendita con Stato)
SHOW TABLES;
#Ho creato 5 tabelle coerenti con lo scenario chiesto dalla traccia d'esame. Ogni tabella ha una chiave primaria (PRIMARY KEY) che identifica in modo univoco ogni record. Le relazioni tra le tabelle sono implementate tramite chiavi esterne (FOREIGN KEY), che garantiscono l’integrità referenziale.

INSERT INTO Categoria (IdCategoria, NomeCategoria)
VALUES (1, 'Biciclette'),
       (2, 'Abbigliamento'),
       (3, 'Accessori');

SELECT * FROM Categoria;
SELECT COUNT(*) FROM Categoria;
#ho inserito dei dati nella tabella Categoria

INSERT INTO RegioneVendita (IdRegioneVendita, NomeRegioneVendita)
VALUES (1, 'WestEurope'),
(2, 'SouthEurope');

SELECT * FROM RegioneVendita;
#ho inserito dei dati nella tabella Regione Vendita

INSERT INTO Stato (IdStato, NomeStato, IdRegioneVendita)
VALUES
(1, 'France', 1),
(2, 'Germany', 1),
(3, 'Italy', 2);

SELECT * FROM Stato;
#ho inserito dati nella tabella Stato

INSERT INTO Prodotto (IdProdotto, NomeProdotto, CodiceArticolo, PrezzoListino, IdCategoria)
VALUES
(1, 'Bike 100', 'B100', 500.00, 1),
(2, 'Guanti M', 'GM01', 25.00, 2),
(3, 'Casco Pro', 'CP10', 80.00, 3);

SELECT * FROM Prodotto;
#ho inserito dati nella tabella Prodotto

INSERT INTO Vendita (IdVendita, DataVendita, Quantita, PrezzoUnitario, IdProdotto, IdStato)
VALUES
(1, '2024-01-10', 2, 500.00, 1, 1),
(2, '2024-01-15', 5, 25.00, 2, 3),
(3, '2024-02-01', 1, 80.00, 3, 2);

SELECT * FROM Vendita;
#ho inserito dati nella tabella Vendita
/*Per popolare il database ho utilizzato il comando INSERT INTO, rispettando l’ordine delle relazioni tra le tabelle per non violare i vincoli di integrità referenziale.
Ho inserito pochi record per ciascuna tabella, coerenti con le chiavi primarie e le chiavi esterne.
Dopo ogni inserimento ho utilizzato SELECT * FROM... per verificare la corretta registrazione dei dati.*/

SELECT * FROM Categoria;
SELECT * FROM RegioneVendita;
SELECT * FROM Stato;
SELECT * FROM Prodotto;
SELECT * FROM Vendita;
#ho voluto ricontrollare per scrupolo tutte le tabelle create. 

SELECT IdCategoria, COUNT(*) AS Occorrenze
FROM Categoria
GROUP BY IdCategoria
HAVING COUNT(*) > 1;

SELECT IdRegioneVendita, COUNT(*) AS Occorrenze
FROM RegioneVendita
GROUP BY IdRegioneVendita
HAVING COUNT(*) > 1;

SELECT IdStato, COUNT(*) AS Occorrenze
FROM Stato
GROUP BY IdStato
HAVING COUNT(*) > 1;

SELECT IdProdotto, COUNT(*) AS Occorrenze
FROM Prodotto
GROUP BY IdProdotto
HAVING COUNT(*) > 1;

SELECT IdVendita, COUNT(*) AS Occorrenze
FROM Vendita
GROUP BY IdVendita
HAVING COUNT(*) > 1;
#Raggruppo per chiave primaria e conto quante volte compare. Se COUNT(*) > 1 allora la PK non è univoca.

SELECT 
    v.IdVendita AS CodiceDocumento,
    v.DataVendita,
    p.NomeProdotto,
    c.NomeCategoria,
    s.NomeStato,
    r.NomeRegioneVendita,
    IF(DATEDIFF('2025-01-01', v.DataVendita) > 180, TRUE, FALSE) AS Oltre180Giorni #calcolo i giorni passati dalla data vendita a oggi
FROM Vendita v
JOIN Prodotto p       ON v.IdProdotto = p.IdProdotto #Collego ogni vendita al suo prodotto
JOIN Categoria c      ON p.IdCategoria = c.IdCategoria #collego ogni prodotto alla sua categoria
JOIN Stato s          ON v.IdStato = s.IdStato #Collego la vendita allo stato in cui è avvenuta
JOIN RegioneVendita r ON s.IdRegioneVendita = r.IdRegioneVendita; #collego ogni stato alla sua regione

SELECT MAX(YEAR(DataVendita))
FROM Vendita;
#ultimo anno presente nei dati

SELECT AVG(Quantita)
FROM Vendita
WHERE YEAR(DataVendita) = (
    SELECT MAX(YEAR(DataVendita))
    FROM Vendita);
    #Media delle quantità vendute nell’ultimo anno
    
    SELECT 
    IdProdotto,
    SUM(Quantita) AS TotaleVenduto
FROM Vendita
WHERE YEAR(DataVendita) = (
        SELECT MAX(YEAR(DataVendita))
        FROM Vendita)
GROUP BY IdProdotto
HAVING SUM(Quantita) > (
        SELECT AVG(Quantita)
        FROM Vendita
        WHERE YEAR(DataVendita) = (
                SELECT MAX(YEAR(DataVendita))
                FROM Vendita));

SELECT 
    v.IdProdotto,
    YEAR(v.DataVendita) AS Anno,
    SUM(v.Quantita * v.PrezzoUnitario) AS FatturatoTotale
FROM Vendita v
GROUP BY 
    v.IdProdotto,
    YEAR(v.DataVendita)
ORDER BY 
    v.IdProdotto,
    Anno;
    /*La query raggruppa le vendite per prodotto e anno, calcolando il fatturato totale come somma del prodotto tra quantità e prezzo unitario.
Uso solo la tabella Vendita perché la traccia richiede solo prodotti venduti
YEAR(DataVendita) estrae l’anno
SUM(Quantita * PrezzoUnitario) calcola il fatturato
GROUP BY raggruppa per prodotto e anno e ORDER BY rende il risultato ordinato*/

SELECT 
    s.NomeStato,
    YEAR(v.DataVendita) AS Anno,
    SUM(v.Quantita * v.PrezzoUnitario) AS FatturatoTotale
FROM Vendita v
JOIN Stato s ON v.IdStato = s.IdStato
GROUP BY 
    s.NomeStato,
    YEAR(v.DataVendita)
ORDER BY 
    Anno,
    FatturatoTotale DESC;
    /*La query calcola il fatturato totale per "stato" e "anno" aggregando le vendite tramite la funzione SUM. 
    Ho ordinato i risultati per anno e, all’interno di ciascun anno, per fatturato in ordine decrescente*/

#6)	Rispondere alla seguente domanda: qual è la categoria di articoli maggiormente richiesta dal mercato?
SELECT 
    c.NomeCategoria,
    SUM(v.Quantita) AS TotaleVenduto
FROM Vendita v
JOIN Prodotto p ON v.IdProdotto = p.IdProdotto
JOIN Categoria c ON p.IdCategoria = c.IdCategoria
GROUP BY c.NomeCategoria
ORDER BY TotaleVenduto DESC
LIMIT 1;
/*Questa domanda mi ha messo molto in difficoltà, ho fatto ricerche per capire come poter scrivere la query nella maniera
più breve, fluida, leggibile e diretta possibile, perché ho trovato troppo macchinoso e lungo il processo che stavo scrivendo e spesso mi perdevo
nella costruzione della query con le varie subquery nella FROM e e nella HAVING che stavo costruendo. Così ho scoperto la
funzione LIMIT che mi sono andato a studiare e grazie a questa sono riuscito a scrivere una Query più fluida e breve, ma 
con lo stesso risultato*/
#La categoria con la quantità totale più alta è Abbigliamento con 5 unità vendute.

#7)	Rispondere alla seguente domanda: quali sono i prodotti invenduti? Proponi due approcci risolutivi differenti.
#APPROCCIO1 
SELECT 
    p.IdProdotto,
    p.NomeProdotto
FROM Prodotto p
LEFT JOIN Vendita v ON p.IdProdotto = v.IdProdotto
WHERE v.IdProdotto IS NULL;
#prendo tutti i prodotti, "aggancio" le vendite se esistono; se non esistono -> invenduto

#APPROCCIO2
SELECT 
    p.IdProdotto,
    p.NomeProdotto
FROM Prodotto p
WHERE p.IdProdotto NOT IN (
    SELECT v.IdProdotto
    FROM Vendita v);
    #prendo i prodotti il cui Id non è nella lista di quelli venduti
    
    /*Con LEFT JOIN seleziono i prodotti che non trovano corrispondenza in Vendita (NULL)
    Con NOT IN seleziono i prodotti il cui IdProdotto non appare mai nella tabella Vendita*/
    
    #Non esistono prodotti invenduti nel mio caso, in quanto tutti i prodotti presenti nella tabella "Prodotto" compaiono almeno una volta nella tabella "Vendita"
    
    CREATE VIEW VistaProdottiDenormalizzata AS
SELECT
    p.IdProdotto   AS CodiceProdotto,
    p.NomeProdotto,
    c.NomeCategoria
FROM Prodotto p
JOIN Categoria c ON p.IdCategoria = c.IdCategoria;
#Ho utilizzato una VIEW che mi unisce Prodotto e Categoria e mostra solo i campi richiesti senza dover utilizzare altre funzioni ogni volta

SELECT * FROM VistaProdottiDenormalizzata;
#controllo la "versione denormalizzata" 

CREATE VIEW VistaGeografica AS
SELECT
    s.IdStato,
    s.NomeStato,
    r.NomeRegioneVendita
FROM Stato s
JOIN RegioneVendita r 
    ON s.IdRegioneVendita = r.IdRegioneVendita;
    #La vista espone le informazioni geografiche combinando "Stato" e "RegioneVendita" in un’unica interrogazione.
    
    #Esercizio molto faticoso, alcuni punti finali mi hanno messo un po' in difficoltà ma spero di aver fatto tutto giusto :} 