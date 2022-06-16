-- a)	Wy�wietl list� Klient�w kt�rzy maj� na imi� Barbara.

SELECT DISTINCT Imie FROM Klienci WHERE Imie='Barbara'

-- b)	Sprawd� kt�ry z pokoi nigdy nie by� zarezerwowany

SELECT * FROM Rezerwacje
RIGHT JOIN Pokoje ON Rezerwacje.PokojID = Pokoje.ID
ORDER BY PokojID ASC;

-- c)	Wy�wietl niepowtarzaj�ce si� dane klient�w kt�rzy dokonali rezerwacji w okresie od 01.09.2017 do 30.09.2017

-- d)	Za pomoc� UNION oraz UNION ALL wy�wietl ID z tabeli Pokoje kt�re posiadaj� TV lub takie kt�re s� dla minimum 2 os�b

SELECT ID, Opis, MaxLiczbaOsob FROM Pokoje WHERE MaxLiczbaOsob >= 2 
UNION
SELECT ID, Opis, MaxLiczbaOsob FROM Pokoje WHERE MaxLiczbaOsob >= 2 
ORDER BY ID ASC;

SELECT ID, Opis, MaxLiczbaOsob FROM Pokoje WHERE Opis LIKE '%tv%'
UNION
SELECT ID, Opis, MaxLiczbaOsob FROM Pokoje WHERE Opis LIKE '%tv%'
ORDER BY ID ASC;

-- e)	Wy�wietl informacje ile os�b maksymalnie mo�e przebywa� w wynajmowanym pokoju

SELECT MAX(MAXLiczbaOsob) AS Najwiecej FROM Pokoje

-- f)	Wy�wietl informacje o pokojach, kt�re by�y najcz�ciej rezerwowane

SELECT * FROM Rezerwacje ORDER BY PokojID ASC

-- g)	Uzupe�nij Tabel� Pobyty na podstawie tabeli rezerwacji � przyjmij za�o�enie �e powinny si� tam znale�� wszystkie nieanulowane rezerwacje,
-- kt�re ju� si� odby�y, kolumn� z Cen� pozostaw pust� (warto�ci NULL)

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











-- h)	Wy�wietl �redni� d�ugo�� pobytu na podstawie tabeli Pobyty

-- i)	Wy�wietl �redni� d�ugo�� pobytu na podstawie tabeli Pobyty w podziale na klienta

-- j)	Wska� kt�ry pok�j by� najd�u�ej wynajmowanym pokojem do tej pory

-- k)	Wy�wietl jak� kwot� powinni zap�aci� klienci za ka�dy z pobyt�w bez uwzgl�dnienia rabat�w, oraz z uwzgl�dnieniem rabat�w.

-- l)	Uzupe�nij pust� kolumn� w tabeli Pobyty o kwot� nale�n� do zap�aty za pobyt (z uwzgl�dnieniem rabat�w)

-- m)	Wy�wietl informacj� jaka firma, jaki klient i ile zap�aci� za swoje pobyty w hotelu.


