USE master;
GO
IF DB_ID (N'HOTEL') IS NOT NULL
DROP DATABASE HOTEL; -- usuni�cie bazy danych je�li istnieje

CREATE DATABASE HOTEL -- utworzenie bazy danych z nadaniem odpowiednim Collate
COLLATE Polish_100_CI_AS; 
GO

USE [HOTEL]

--tworzymy tabele
CREATE TABLE [dbo].[RodzajPokoju](
	[ID] [int] PRIMARY KEY IDENTITY,
	[Nazwa] [nvarchar] (250) UNIQUE NOT NULL)

CREATE TABLE [dbo].[Pokoje](
	[ID] [int] PRIMARY KEY,
	[RodzajPokojID] [int] NOT NULL FOREIGN KEY REFERENCES RodzajPokoju(ID),
	[Cena] [decimal] (8,2) NOT NULL,
	[MaxLiczbaOsob] [smallint] NOT NULL,
	[Opis] [nvarchar] (1000) NULL)

CREATE TABLE [dbo].[Firmy](
	[ID] [int] PRIMARY KEY IDENTITY,
	[Nazwa] [nvarchar] (500) NOT NULL,
	[NIP] [nvarchar] (20) NOT NULL,
	[KodPocztowy] [nvarchar] (20) NULL,
	[Miasto] [nvarchar] (250) NULL,
	[Adres] [nvarchar] (1000) NULL)

CREATE TABLE [dbo].[Klienci](
	[ID] [int] PRIMARY KEY IDENTITY,
	[Imie] [nvarchar] (50) NOT NULL,
	[Nazwisko] [nvarchar] (100) NOT NULL,
	[PESEL] [nvarchar] (20) NULL,
	[Email] [nvarchar] (250) NULL,
	[Telefon] [nvarchar] (20) NULL,
	[FirmaID] [int] NULL)

CREATE TABLE [dbo].[Statusy](
	[ID] [int] PRIMARY KEY IDENTITY,
	[Nazwa] [nvarchar] (250) UNIQUE NOT NULL)

CREATE TABLE [dbo].[Rabaty](
	[ID] [int] PRIMARY KEY IDENTITY,
	[KlientID] [int] FOREIGN KEY REFERENCES Klienci(ID),
	[FirmaID] [int] FOREIGN KEY REFERENCES Firmy(ID),
	[ObowiazujeOd] [date],
	[Procent] [int] CHECK ([Procent] IN (5,10,15,20,25,30) ) DEFAULT 5)

CREATE TABLE [dbo].[Rezerwacje](
	[ID] [int] PRIMARY KEY IDENTITY,
	[KlientID] [int] FOREIGN KEY REFERENCES Klienci(ID),
	[PokojID] [int] FOREIGN KEY REFERENCES Pokoje(ID),
	[DataRezerwacji] [datetime] NOT NULL,
	[DataPrzyjazdu] [datetime] NOT NULL, 
	[DataWyjazdu] [datetime] NOT NULL,
	[StatusID] [int] FOREIGN KEY REFERENCES Statusy(ID))

CREATE TABLE [dbo].[Pobyty](
	[ID] [int] PRIMARY KEY IDENTITY,
	[RezerwacjaID] [int] FOREIGN KEY REFERENCES Rezerwacje(ID),
	[KlientID] [int] NOT NULL FOREIGN KEY REFERENCES Klienci(ID),
	[PokojID] [int] NOT NULL FOREIGN KEY REFERENCES Pokoje(ID),
	[DataPrzyjazdu] [datetime] NOT NULL, 
	[DataWyjazdu] [datetime],
	[KwotaDoZaplaty] [decimal] (8,2))

-- uzupelniamy tabele danymi

INSERT INTO Statusy (Nazwa)
VALUES ('Wolny'),
('Zaj�ty'),
('Niepotwierdzona'),
('Potwierdzona'),
('Anulowana'),
('Zrealizowana')

INSERT INTO RodzajPokoju (Nazwa)
VALUES ('Standarowy'),
('Ekonomiczny'),
('Biznes'),
('Apartament'),
('Apartament z widokiem na g�ry')

INSERT INTO Pokoje (ID, RodzajPokojID, Cena, MaxLiczbaOsob, Opis) 
VALUES (101, 2, 100, 2, 'bez �azienki, TV, wifi'),
(102, 2, 60, 1, 'bez �azienki, TV, wifi'),
(103, 2, 180, 4, 'bez �azienki, TV, wifi'),
(104, 2, 240, 4, 'z �azienk�, TV, wifi'),
(201, 1, 140, 2, 'z �azienk�, TV, wifi, balkon'),
(202, 1, 140, 2, 'z �azienk�, TV, wifi'),
(203, 1, 90, 1, 'z �azienk�, TV, wifi, balkon'),
(204, 3, 160, 2, 'z �azienk�, TV, wifi, balkon, lod�wka'),
(205, 3, 120, 1, 'z �azienk�, TV, wifi, balkon, lod�wka'),
(301, 4, 250, 2, 'z �azienk�, TV, wifi, balkon, aneks kuchenny'),
(302, 4, 440, 4, 'z �azienk�, TV, wifi, balkon, aneks kuchenny, sejf'),
(303, 5, 660, 6, 'z �azienk�, TV, wifi, balkon, aneks kuchenny, sejf')

INSERT INTO Firmy (Nazwa, NIP, KodPocztowy, Miasto, Adres) 
VALUES ('Blachotrapez Sp. z o.o.', '9931742334','30-215','Rabka Zdr�j','ul. Na wzg�rzu 42'),
('Oknoplast Sp. z o.o.', '7233422312','32-712','Nowy S�cz','ul. Krakowska 12'),
('Evenea Sp�ka z ograniczon� odpowiedzialno�ci�','9256345423', '02-250','Warszawa','ul. Kr�tka 32'),
('Comarch S.A.','6722341245','30-230','Krak�w','ul. Informatyk�w 1'),
('Uniwersytet Ekonomczny w Krakowie', '9913451273','30-118','Krak�w','ul. Rakowicka 27'),
('Neostrain Sp. z o.o.', '6792933459','30-702','Krak�w','ul. Lipowa 3'),
('Polkomtel S.A.', '7452342345','00-212','Warszawa','ul. Pozna�ska 18'),
('Synthos S.A.', '6452349827','45-215','O�wi�cim','Chemik�w 12'),
('Grupa Azoty S.A.', '9933451283','33-101','Tarn�w','ul. I. Mo�cickiego 106')

INSERT INTO Klienci (Imie, Nazwisko, PESEL, Email, Telefon, FirmaID) 
VALUES ('Barbara', 'Fibiana', '75092908342', 'barbara.fibiana@onet.pl', '884317743', NULL),
('Barbara', 'Gruda', '83110523423', 'barbara.gruda@gmail.com', '513518635', 1),
('Jadwiga', 'Bilecka', '70101023456', 'jadwiga.bilecka@onet.pl', '884815648', NULL),
('Ewa', 'Masztaler', '61050512398', 'ewa.masztaler@onet.pl', '885716657', 3),
('Elwira', 'Policzawska', '76042909345', 'elwira.policzawska@onet.pl', '884215842', NULL),
('Edward', 'Zelgowski', '78080834121', 'edward.zelgowski@gmail.com', '514016740', 8),
('Jadwiga', 'Derilecka', '68120323432', 'jadwiga.derilecka@onet.pl', '885018850', NULL),
('Jadwiga', 'Fulecka', '66090934234', 'jadwiga.fulecka@onet.pl', '885217852', 2),
('Boles�aw', 'Bryndza', '90060634098', 'boles�aw.bryndza@gmail.com', '512819128', NULL),
('Adam', 'Dertucha', '94071377345', 'adam.dertucha@gmail.com', '512418624', NULL),
('Adam', 'Fodecki', '92092908411', 'adam.fodecki@gmail.com', '512615226', 4),
('Marek', 'Linda', '81031245178', 'marek.linda@gmail.com', '513716237', NULL),
('Krzysztof', 'Ibisz', '79081212085', 'krzysztof.ibisz@gmail.com', '513916139', NULL),
('Robert', 'Dido', '74070734234', 'robert.dido@onet.pl', '884416344', 5),
('Piotr', 'Forbek', '74120734534', 'piotr.forbek@onet.pl', '884418544', 6),
('Robert', 'Moczysko', '63101312074', 'robert.moczysko@onet.pl', '885515255', NULL),
('Pawe�', 'Policzek', '63012103212', 'pawe�.policzek@onet.pl', '885519855', NULL),
('Wiktor', 'Dudziak', '67082841838', 'wiktor.dudziak@onet.pl', '885114851', 7),
('Zbigniew', 'Chrupek', '64122407520', 'zbigniew.chrupek@gmail.com', '512516925', NULL),
('Andrzej', 'Twardowski', '92071821276', 'andrzej.twardowski@gmail.com', '512617626', NULL)

INSERT INTO [Rezerwacje] (KlientID, PokojID, DataRezerwacji, DataPrzyjazdu, DataWyjazdu, StatusID) 
VALUES ('8', '102', '2017-09-01', '2018-04-19', '2018-04-26', 4),
('17', '205', '2017-09-01', '2018-02-12', '2018-02-17', 5),
('5', '303', '2017-09-06', '2018-02-12', '2018-02-16', 6),
('3', '101', '2017-09-06', '2018-01-05', '2018-01-08', 6),
('9', '201', '2017-09-06', '2018-01-17', '2018-01-30', 6),
('6', '103', '2017-09-06', '2018-03-05', '2018-03-16', 6),
('15', '203', '2017-09-06', '2018-04-02', '2018-04-11', 6),
('18', '102', '2017-09-17', '2018-03-23', '2018-03-28', 6),
('13', '201', '2017-09-23', '2018-02-12', '2018-02-15', 6),
('5', '103', '2017-09-28', '2018-02-12', '2018-02-16', 5),
('13', '101', '2017-09-28', '2018-04-24', '2018-04-28', 6),
('3', '101', '2017-09-28', '2018-02-28', '2018-03-06', 6),
('17', '202', '2017-10-04', '2018-02-28', '2018-03-02', 6),
('15', '302', '2017-10-04', '2018-01-12', '2018-01-24', 5),
('11', '101', '2017-10-16', '2018-01-12', '2018-01-14', 6),
('19', '202', '2017-10-16', '2018-02-05', '2018-02-11', 6),
('4', '201', '2017-11-03', '2018-01-05', '2018-01-17', 6),
('4', '301', '2017-11-03', '2018-01-19', '2018-01-22', 6),
('17', '204', '2017-11-09', '2018-02-28', '2018-03-04', 6),
('12', '204', '2017-11-17', '2018-02-28', '2018-03-13', 6),
('15', '301', '2017-11-17', '2018-03-05', '2018-03-12', 6),
('14', '102', '2017-11-21', '2018-01-12', '2018-01-23', 6),
('14', '204', '2017-11-25', '2018-02-21', '2018-02-26', 5),
('8', '202', '2017-11-27', '2018-04-22', '2018-05-05', 4),
('7', '301', '2017-11-27', '2018-04-02', '2018-04-05', 6),
('5', NULL, '2017-12-06', '2018-04-10', '2018-04-24', 6),
('7', '103', '2017-12-06', '2018-04-22', '2018-05-04', 4),
('6', '303', '2017-12-06', '2018-04-10', '2018-04-19', 6),
('1', '201', '2017-12-14', '2018-01-12', '2018-01-18', 6) ,
('8', '301', '2018-02-06', '2018-05-15', '2018-05-19', 6),
('3', '202', '2018-03-14', '2018-06-12', '2018-06-13', 6)


INSERT INTO [Rabaty] (KlientID, FirmaID, ObowiazujeOd, Procent) 
VALUES (17, NULL, '2018-02-28', 10),
(14, NULL, '2018-02-21', 5),
(7, NULL, '2018-02-28', 10),
(11, 4, '2018-01-12', 25)


INSERT INTO Pobyty (RezerwacjaID, KlientID, PokojID, DataPrzyjazdu, DataWyjazdu)
SELECT ID, KlientID, PokojID, DataPrzyjazdu, DataWyjazdu
FROM Rezerwacje WHERE Rezerwacje.[StatusID] = 6 
AND DataWyjazdu < GETDATE()
AND Rezerwacje.PokojID IS NOT NULL


-- wy�wietlamy dane kt�re mamy we wszystkich tabelach

SELECT * FROM Firmy
SELECT * FROM Klienci
SELECT * FROM Pobyty
SELECT * FROM Pokoje
SELECT * FROM Rabaty
SELECT * FROM Rezerwacje
SELECT * FROM RodzajPokoju
SELECT * FROM Statusy


USE [HOTEL]
	GO

		SELECT Klienci.Imie + ' ' + Klienci.Nazwisko AS ImieNazwisko,
			RodzajPokoju.Nazwa AS NazwaPokoju,
			COUNT(*) AS LiczbaRezerwacji
		FROM
			Rezerwacje
			LEFT JOIN Klienci ON Rezerwacje.KlientID = Klienci.ID
			LEFT JOIN Pokoje ON Rezerwacje.PokojID = Pokoje.ID
			LEFT JOIN RodzajPokoju ON Pokoje.RodzajPokojID = RodzajPokoju.ID
		WHERE Rezerwacje.PokojID IS NOT NULL
		GROUP BY Klienci.ID,Klienci.Imie + ' ' + Klienci.Nazwisko, RodzajPokoju.Nazwa
		ORDER BY COUNT(*) DESC

		SELECT *
		FROM sys.[views]
		WHERE name = 'v_NowyWidok'

		--	utworzenie widoku o nazwie v_NowyWidok
	
		CREATE VIEW [dbo].[v_NowyWidok]
		AS

		SELECT Klienci.Imie + ' ' + Klienci.Nazwisko AS ImieNazwisko,
			RodzajPokoju.Nazwa AS NazwaPokoju,
			COUNT(*) AS LiczbaRezerwacji
		FROM
			Rezerwacje
			LEFT JOIN Klienci ON Rezerwacje.KlientID = Klienci.ID
			LEFT JOIN Pokoje ON Rezerwacje.PokojID = Pokoje.ID
			LEFT JOIN RodzajPokoju ON Pokoje.RodzajPokojID = RodzajPokoju.ID
		WHERE Rezerwacje.PokojID IS NOT NULL
		GROUP BY Klienci.ID,Klienci.Imie + ' ' + Klienci.Nazwisko, RodzajPokoju.Nazwa

--	odpytujemy widok

		SELECT *
		FROM v_NowyWidok

		SELECT ImieNazwisko
		FROM v_NowyWidok
		ORDER BY Liczbarezerwacji DESC


		CREATE PROCEDURE DodajKlienta
	@Imie nvarchar (50),
	@Nazwisko nvarchar (100),
	@PESEL nvarchar (20),
	@Email nvarchar (250),
	@Telefon nvarchar (20),
	@FirmaID int
AS
BEGIN
	INSERT Klienci
	VALUES (@Imie, @Nazwisko, @PESEL, @Email, @Telefon, @FirmaID)
END

-- zosta�y zdefiniowane tylko parametry wej�ciowe: @imie, @nazwisko, itd... wykonuj� procedur� podaj�c parametry
SELECT * FROM Klienci

EXECUTE DodajKlienta 'Adam', 'Wawrzyniak', '89051523243', 'adamos89@buziaczek.pl', '773123424',NULL

SELECT * FROM Klienci

--Poni�ej przyk�ad definicji procedury z dwoma typami parametr�w (wej�ciowymi i wyj�ciowymi - OUTPUT)

CREATE PROCEDURE ListaKlient�w
@Imie nvarchar (50),
@Nazwisko nvarchar (100),
@Liczba int OUTPUT
AS
BEGIN
	SET NOCOUNT ON -- wy��czenie wy�wietlania liczby przetworzonych rekord�w

	SET @Liczba = (SELECT COUNT(*)
					FROM Klienci
					WHERE Imie LIKE @Imie 
						AND Nazwisko LIKE @Nazwisko)

	SELECT *
	FROM Klienci
	WHERE Imie LIKE @Imie 
AND Nazwisko LIKE @Nazwisko

END

DECLARE @Liczba INT
EXEC ListaKlient�w 'A%', '%', @Liczba OUTPUT
SELECT @Liczba



CREATE FUNCTION Nazwa_Funkcji
(
  @Nazwa_parametru1 TYP_PARAMETRU,
  �
  @Nazwa_parametruN TYP_PARAMETRU
)
RETURNS typ_zwracany
AS
BEGIN
Tre��_zapytania

RETURN warto��_zwracana
END

	
	
CREATE FUNCTION NowaFunkcjaTabelaryczna
	(@PokojID INT)
RETURNS TABLE 
AS
RETURN

	SELECT Klienci.Imie,
			Klienci.Nazwisko,
			Rezerwacje.DataRezerwacji,
			Rezerwacje.DataPrzyjazdu,
			Rezerwacje.DataWyjazdu
	FROM Rezerwacje 
	JOIN Pokoje ON Rezerwacje.PokojID = Pokoje.ID
	JOIN Klienci ON Rezerwacje.KlientID = Klienci.ID 
	WHERE
		Rezerwacje.PokojID = @PokojID

--	tworzymy funkcj� skalarn� kt�ra zwr�ci Nam informacj� kto ostatnio wynajmowa� wskazany pok�j
	
CREATE FUNCTION NowaFunkcjaSkalarna
	(@PokojID INT)
RETURNS NVARCHAR (300)
AS
BEGIN
			
	DECLARE @ImieNazwisko NVARCHAR (300)
	SET @ImieNazwisko =	(
					SELECT TOP 1 Klienci.Imie + ' ' + Klienci.Nazwisko
					FROM Pobyty
					JOIN Klienci ON Pobyty.KlientID = Klienci.ID 
					WHERE PokojID = @PokojID
					ORDER BY Pobyty.DataWyjazdu DESC
				)
	RETURN @ImieNazwisko
END

	SELECT * 
	FROM NowaFunkcjaTabelaryczna(103)

	SELECT * 
	FROM NowaFunkcjaTabelaryczna(104)

-- skalarnej

SELECT [dbo].[NowaFunkcjaSkalarna] (103)

SELECT [dbo].[NowaFunkcjaSkalarna] (104)



ALTER FUNCTION NowaFunkcjaTabelaryczna
	(@PokojID INT, @Data DATE)
RETURNS TABLE 
AS
RETURN

	SELECT Klienci.Imie,
			Klienci.Nazwisko,
			Rezerwacje.DataRezerwacji,
			Rezerwacje.DataPrzyjazdu,
			Rezerwacje.DataWyjazdu
	FROM Rezerwacje 
	JOIN Pokoje ON Rezerwacje.PokojID = Pokoje.ID
	JOIN Klienci ON Rezerwacje.KlientID = Klienci.ID 
	WHERE
		Rezerwacje.PokojID = @PokojID
		AND DataRezerwacji >= @Data


--	odpytywanie zmodyfikowanej funkcji

	SELECT * 
	FROM NowaFunkcjaTabelaryczna(103, '2017-09-28')





--a)	Utw�rz now� tabel� o nazwie �Zguby�, w kt�rej b�d� przechowywane
--informacje o rzeczach znalezionych w hotelu. Tabela powinna
--mie� takie kolumny jak: ID, Nazwa, Opis, DataZnalezienia, PokojID,
--Pracownik, CzyOdebrano. Zwr�� uwag� kt�re z kolumn nie powinny m�c
--przyjmowa� warto�ci NULL.

CREATE TABLE [dbo].[Zguby](
	[ID] [int] PRIMARY KEY,
	[Nazwa] [nvarchar] (50) NOT NULL,
	[Opis] [nvarchar] (30) NOT NULL,
	[DataZnalezienia] [datetime], 
	[PokojID] [int] FOREIGN KEY REFERENCES Pokoje(ID),
	[Pracownik] [nvarchar] (20), 
	[CzyOdebrano] [nvarchar](10))

--b)	Utw�rz procedur�, kt�ra b�dzie pozwala� na uzupe�nienie danych
--w tabeli Zguby. Nast�pnie zasil za pomoc� utworzonej procedury
--tabel� Zguby min. 5 wierszami.

ALTER PROCEDURE DodajZguby
	@ID int,
	@Nazwa nvarchar (50),
	@Opis nvarchar (30),
	@DataZnalezienia datetime,
	@PokojID int,
	@Pracownik nvarchar (20),
	@CzyOdebrano nvarchar (10)
AS
BEGIN
	INSERT INTO Zguby (ID, Nazwa, Opis, DataZnalezienia, PokojID, Pracownik, CzyOdebrano)
	VALUES (@ID, @Nazwa, @Opis, @DataZnalezienia, @PokojID, @Pracownik, @CzyOdebrano)
END

SELECT * FROM Zguby

EXECUTE DodajZguby '1', 'Portfel', 'Zgubiony', '01.02.2020', '1', 'AdamKowalski', 'Tak'

SELECT * FROM Zguby

--c)	Utw�rz Funkcj� tabelaryczn� kt�ra na podstawie trzech parametr�w: 
--Daty pocz�tkowej, Daty ko�cowej oraz fragmentu opisu b�dzie przeszukiwa�
--tabel� Zguby w poszukiwaniu informacji wg zadanych przez u�ytkownika parametr�w.

CREATE FUNCTION FunkcjaTabelaryczna
	(@PokojID INT)
RETURNS TABLE 
AS
RETURN

SELECT Zguby.DataZnalezienia,
			Zguby.Opis,
			
	FROM 
	JOIN ON 
	JOIN ON 
	









d)	Utw�rz funkcj� skalarn�, kt�ra w wyniku b�dzie zwraca� �redni� d�ugo�� pobytu w hotelu w zadanym (w postaci parametru) miesi�cu. Zar�wno data rozpocz�cia wizyty jak i zako�czenia musi by� w tym samym miesi�cu.
e)	W kt�rym miesi�cu �rednio pobyty w hotelu trwaj� najd�u�ej? (w oparciu tylko o dat� przyjazdu).
f)	Utw�rz procedur�, kt�ra b�dzie wykonywa� nast�puj�ce czynno�ci:
a.	Pozwoli doda� wpis do tabeli Zguby, a nast�pnie
b.	Zamieni wszystkie warto�ci r�wne zadanemu parametrowi �Nazwa� w kolumnie Nazwa na warto�� �Cukierek albo Psikus�
c.	Zwr�ci (parametr output) Liczb� rekord�w w kt�rych wyst�puje Nazwa o warto�ci �Cukierek albo psikus�.

