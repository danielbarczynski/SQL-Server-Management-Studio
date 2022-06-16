-- a)	Wyœwietl listê Klientów którzy maj¹ na imiê Barbara.

SELECT DISTINCT Imie FROM Klienci WHERE Imie='Barbara'

-- b)	SprawdŸ który z pokoi nigdy nie by³ zarezerwowany

SELECT * FROM Rezerwacje
RIGHT JOIN Pokoje ON Rezerwacje.PokojID = Pokoje.ID
ORDER BY PokojID ASC;

-- c)	Wyœwietl niepowtarzaj¹ce siê dane klientów którzy dokonali rezerwacji w okresie od 01.09.2017 do 30.09.2017

-- d)	Za pomoc¹ UNION oraz UNION ALL wyœwietl ID z tabeli Pokoje które posiadaj¹ TV lub takie które s¹ dla minimum 2 osób

SELECT ID, Opis, MaxLiczbaOsob FROM Pokoje WHERE MaxLiczbaOsob >= 2 
UNION
SELECT ID, Opis, MaxLiczbaOsob FROM Pokoje WHERE MaxLiczbaOsob >= 2 
ORDER BY ID ASC;

SELECT ID, Opis, MaxLiczbaOsob FROM Pokoje WHERE Opis LIKE '%tv%'
UNION
SELECT ID, Opis, MaxLiczbaOsob FROM Pokoje WHERE Opis LIKE '%tv%'
ORDER BY ID ASC;

-- e)	Wyœwietl informacje ile osób maksymalnie mo¿e przebywaæ w wynajmowanym pokoju

SELECT MAX(MAXLiczbaOsob) AS Najwiecej FROM Pokoje

-- f)	Wyœwietl informacje o pokojach, które by³y najczêœciej rezerwowane

SELECT * FROM Rezerwacje ORDER BY PokojID ASC

-- g)	Uzupe³nij Tabelê Pobyty na podstawie tabeli rezerwacji – przyjmij za³o¿enie ¿e powinny siê tam znaleŸæ wszystkie nieanulowane rezerwacje,
-- które ju¿ siê odby³y, kolumnê z Cen¹ pozostaw pust¹ (wartoœci NULL)

SELECT * FROM Pobyty

SELECT * FROM Rezerwacje ORDER BY PokojID ASC

SELECT * FROM Statusy


CREATE TABLE [dbo].[Pobyty](
	[ID] [int] PRIMARY KEY IDENTITY,
	[RezerwacjaID] [int] FOREIGN KEY REFERENCES Rezerwacje(ID),
	[KlientID] [int] NOT NULL FOREIGN KEY REFERENCES Klienci(ID),
	[PokojID] [int] NOT NULL FOREIGN KEY REFERENCES Pokoje(ID),
	[DataPrzyjazdu] [datetime] NOT NULL, 
	[DataWyjazdu] [datetime],
	[KwotaDoZaplaty] [decimal] (8,2))

	SELECT * FROM Pracownicy

SELECT      [P1].[ID] ,
			[P1].[Imie] ,
			[P1].[Nazwisko] ,
			[P1].[Stanowisko],

			[P2].[Imie]	AS [PrzelozonyImie]	,
			[P2].[Nazwisko]	AS [PrzelozonyNazwisko]	,
			[P2].[Stanowisko]		AS [Przelozonystanowisko]		

		FROM 
			[dbo].[Pracownicy] AS [P1]
		JOIN	[dbo].[Pracownicy] AS [P2] ON [P2].[ID] = [P1].[PrzelozonyID]











-- h)	Wyœwietl Œredni¹ d³ugoœæ pobytu na podstawie tabeli Pobyty

-- i)	Wyœwietl Œredni¹ d³ugoœæ pobytu na podstawie tabeli Pobyty w podziale na klienta

-- j)	Wska¿ który pokój by³ najd³u¿ej wynajmowanym pokojem do tej pory

-- k)	Wyœwietl jak¹ kwotê powinni zap³aciæ klienci za ka¿dy z pobytów bez uwzglêdnienia rabatów, oraz z uwzglêdnieniem rabatów.

-- l)	Uzupe³nij pust¹ kolumnê w tabeli Pobyty o kwotê nale¿n¹ do zap³aty za pobyt (z uwzglêdnieniem rabatów)

-- m)	Wyœwietl informacjê jaka firma, jaki klient i ile zap³aci³ za swoje pobyty w hotelu.


