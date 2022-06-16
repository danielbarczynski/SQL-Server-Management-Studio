-- Wyœwietl imiona Klientów

SELECT ID, Imie, Nazwisko
INTO Klienci2
FROM Klienci

-- Wyœwietl imoina klientów, ale tak, aby ka¿de wystêpowano tylko raz w liœcie

SELECT DISTINCT Imie FROM Klienci

SELECT Klienci2

SELECT Imie FROM Klienci
UNION
SELECT Imie FROM Klienci2
ORDER BY Imie DESC;


SELECT * FROM Rezerwacje AS R
INNER JOIN Pokoje P ON R.PokojID = P.ID

SELECT * FROM Rezerwacje AS R
LEFT JOIN Pokoje P ON R.PokojID = P.ID

SELECT * FROM Rezerwacje AS R
RIGHT JOIN Pokoje P ON R.PokojID = P.ID

SELECT * FROM Rezerwacje AS R
FULL JOIN Pokoje P ON R.PokojID = P.ID

--	utworzenie tabel + insert danych
	
		CREATE TABLE [dbo].[Pracownicy]
		(
			[ID]	[INT] NOT NULL,
			[PrzelozonyID] [INT] NULL,
			[Imie]		[NVARCHAR](50) NOT NULL,
			[Nazwisko]	[NVARCHAR](50) NOT NULL,
			[Stanowisko][NVARCHAR](50) NULL
		) ON [PRIMARY]

		INSERT INTO [dbo].[Pracownicy]
		VALUES
			( 1, NULL, N'Alan', N'Brown',  'Prezes' ), 
			( 2, 1, N'Roberto', N'Tamburello',  'Dyrektor finansowy' ), 
			( 3, 1, N'David', N'Brown', 'Dyrektor ds. produkcji' ), 
			( 4, 2, N'Frank', N'Bradley', 'G³ówny ksiêgowy' ), 
			( 5, 2, N'JoLynn', N'Dobney','Specjalista ds. Controllingu' ), 
			( 6, 3, N'Terri', N'Duffy', 'Kierownik zmiany' ), 
			( 7, 3, N'Taylor', N'Maxwell', 'Kieronik zmiany' )

			SELEcT * FROM Pracownicy

-- Wyœwietlamy informacje o pracownika i o ich prze³o¿onych

		SELECT
			[P1].[ID] ,
			[P1].[Imie] ,
			[P1].[Nazwisko] ,
			[P1].[Stanowisko],

			[P2].[Imie]	AS [PrzelozonyImie]	,
			[P2].[Nazwisko]	AS [PrzelozonyNazwisko]	,
			[P2].[Stanowisko]		AS [Przelozonystanowisko]		

		FROM 
			[dbo].[Pracownicy] AS [P1]
		LEFT JOIN	[dbo].[Pracownicy] AS [P2] ON [P2].[ID] = [P1].[PrzelozonyID]

		
CREATE TABLE Cyferki ( ID INT NOT NULL)
	INSERT INTO  Cyferki	VALUES(1),(2),(3),(4),(5)

	SELECT 
		t1.ID,
		t2.ID
	FROM Cyferki AS [t1]
	CROSS JOIN	Cyferki AS [t2]

	Funkcja MIN() zwraca najmniejsz¹ wartoœæ wybranej kolumny.
SELECT MIN(column_name)
FROM table_name
WHERE condition;

Funkcja MAX() zwraca najwiêksz¹ wartoœæ wybranej kolumny.
SELECT MAX(column_name)
FROM table_name
WHERE condition;

-- Wyœwietl wszystkie informacje o pokojach i ich rodzaju

SELECT * FROM Pokoje
LEFT JOIN RodzajPokoju ON RodzajPokoju.ID = Pokoje.RodzajPokojID

-- Wyœwietl najni¿sz¹ cenê za pokój w standardzie Ekonomicznym

SELECT MIN(Cena) AS Najnizsza FROM Pokoje
LEFT JOIN RodzajPokoju ON RodzajPokoju.ID = Pokoje.RodzajPokojID
WHERE RodzajPokoju.Nazwa = 'Ekonomiczny'

SELECT MIN(Cena) AS Najnizsza FROM Pokoje
LEFT JOIN RodzajPokoju ON RodzajPokoju.ID = Pokoje.RodzajPokojID
WHERE RodzajPokojID = 2 

--Wyœwietl najwy¿sz¹ cenê za Apartament

SELECT MAX(Cena) AS Najwyzsza FROM Pokoje
LEFT JOIN RodzajPokoju ON RodzajPokoju.ID = Pokoje.RodzajPokojID
WHERE RodzajPokoju.Nazwa like 'Apartament%'

SELECT AVG(Cena) AS Œrednia
FROM Pokoje
WHERE MaxLiczbaOsob >= 4

SELECT AVG(Cena) AS Œrednia
FROM Pokoje
WHERE MaxLiczbaOsob = 4


--Wyœwietla Imiona klientów które koñcz¹ siê na "a" oraz sumê ID dla ka¿dej z grupy imion, dodatkowo wyniki s¹ posortowane po kolumnie Imiê

SELECT Imie, SUM(ID) AS Suma FROM Klienci WHERE Imie LIKE '%a'
GROUP BY Imie Order BY Imie ASC

--Wyœwietla Nazwy rodzaju pokoju wraz ze œredni¹ za taki pokój

SELECT RodzajPokoju.Nazwa, AVG(Cena), COUNT(*)
FROM Pokoje
LEFT JOIN RodzajPokoju ON RodzajPokoju.ID = Pokoje.RodzajPokojID
GROUP BY RodzajPokoju.Nazwa ORDER BY AVG(Cena) ASC

--Poni¿szy fragment kodu nie zadzia³a – pytanie dlaczego?

SELECT ID, Imie, Nazwisko FROM Klienci WHERE Imie LIKE '%a'
GROUP BY ID, Imie, Nazwisko Order BY Imie ASC


SELECT RodzajPokoju.Nazwa, AVG(Cena), COUNT(*)
FROM Pokoje
LEFT JOIN RodzajPokoju ON RodzajPokoju.ID = Pokoje.RodzajPokojID
GROUP BY RodzajPokoju.Nazwa 
HAVING AVG(Cena) > 200

SELECT RodzajPokoju.Nazwa, AVG(Cena), COUNT(*)
FROM Pokoje
LEFT JOIN RodzajPokoju ON RodzajPokoju.ID = Pokoje.RodzajPokojID
WHERE Cena > 200
GROUP BY RodzajPokoju.Nazwa 
HAVING AVG(Cena) > 230
ORDER BY COUNT(*), AVG(Cena)









