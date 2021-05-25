-- Wykorzystując bazę danych AdventureWorks, zrealizuj poniższe zadania

USE AdventureWorks2019

-- 1. Przygotuj blok anonimowy, który:
--    - znajdzie średnią stawkę wynagrodzenia pracowników, 
--    - wyświetli szczegóły pracowników, których stawka wynagrodzenia jest niższa niż średnia

BEGIN
DECLARE @AVG_RATE FLOAT;

SELECT @AVG_RATE = AVG(Rate) FROM AdventureWorks2019.HumanResources.EmployeePayHistory
PRINT 'AVERAGE RATE IS ' + CAST(@AVG_RATE AS VARCHAR(10));

SELECT FirstName, LastName, Rate
	FROM AdventureWorks2019.Person.Person AS person
		JOIN AdventureWorks2019.HumanResources.EmployeePayHistory AS employee
			ON person.BusinessEntityID = employee.BusinessEntityID
		WHERE employee.Rate < @AVG_RATE

END;

-- 2. Utwórz funkcję, która zwróci datę wysyłki określonego zamówienia.

CREATE OR ALTER FUNCTION OrderDateFunction (@SalesOrderID INT)
RETURNS DATE
AS
BEGIN
	DECLARE @ShipDate DATE;
    SELECT @ShipDate = ShipDate FROM AdventureWorks2019.Sales.SalesOrderHeader
		WHERE @SalesOrderID = AdventureWorks2019.Sales.SalesOrderHeader.SalesOrderID
	RETURN @ShipDate
END

SELECT dbo.OrderDateFunction(43934)

-- 3. Utwórz procedurę składowaną, która jako parametr przyjmuję nazwę produktu, a jako 
--    rezultat wyświetla jego identyfikator, numer i dostępność.

CREATE OR ALTER PROCEDURE ProductInfoProcedure(@ProductName VARCHAR(40))
AS
BEGIN

SELECT Name, product.ProductID, ProductNumber, Quantity
	FROM AdventureWorks2019.Production.Product AS product
		-- Tu skorzystałem z zapytania zagnieżdżonego, gdyż w tabeli Inventory ilość dostępnych produktów była rozłożona po różnych lokalizacjach. Stosując SUM() otrzymałem sumaryczną dostępność produktu
		JOIN (SELECT ProductID, SUM(Quantity) AS Quantity FROM AdventureWorks2019.Production.ProductInventory GROUP BY ProductID) AS inventory 
			ON product.ProductID = inventory.ProductID
		WHERE @ProductName = product.Name

END;

EXEC ProductInfoProcedure @ProductName = 'Road End Caps'


-- 4. Utwórz funkcję, która zwraca numer karty kredytowej dla konkretnego zamówienia.


CREATE OR ALTER FUNCTION CreditCardNumberFunction (@SalesOrderID INT)
RETURNS NVARCHAR(25)
AS
BEGIN
	DECLARE @CardNumber NVARCHAR(25);
    SELECT @CardNumber = CardNumber FROM AdventureWorks2019.Sales.CreditCard AS creditcard
		JOIN AdventureWorks2019.Sales.SalesOrderHeader AS sales
			ON creditcard.CreditCardID = sales.CreditCardID
		WHERE @SalesOrderID = sales.SalesOrderID
	RETURN @CardNumber
END;

SELECT dbo.CreditCardNumberFunction(43660) AS CardNumber


-- 5. Utwórz procedurę składowaną, która jako parametry wejściowe przyjmuje dwie liczby, num1
--	  i num2, a zwraca wynik ich dzielenia. Ponadto wartość num1 powinna zawsze być większa niż 
--	  wartość num2. Jeżeli wartość num1 jest mniejsza niż num2, wygeneruj komunikat o błędzie 
--    „Niewłaściwie zdefiniowałeś dane wejściowe”.

CREATE OR ALTER PROCEDURE Divide(@num1 FLOAT, @num2 FLOAT)
AS
BEGIN

IF @num1 <= @num2
	RAISERROR('Incorrectly defined input.', 16, 1)
ELSE
BEGIN
	DECLARE @result FLOAT;
	SET @result = @num1/@num2
	PRINT 'Result of dividing ' + CAST(@num1 AS VARCHAR) + ' by ' + CAST(@num2 AS VARCHAR) + ' is ' + CAST(@result AS VARCHAR)
END;

END;

EXEC Divide @num1 = 20, @num2 = 4.2
EXEC Divide @num1 = 10, @num2 = 12.45
EXEC Divide @num1 = 4.123, @num2 = 0

-- 6. Napisz procedurę, która jako parametr przyjmie NationalIDNumber danej osoby, a zwróci 
--    stanowisko oraz liczbę dni urlopowych i chorobowych.

CREATE OR ALTER PROCEDURE DaysOff(@NationalIDNumber NVARCHAR(15))
AS
BEGIN

SELECT NationalIDNumber, JobTitle, ROUND(CAST(VacationHours AS FLOAT)/24, 3) AS VacationDays, ROUND(CAST(SickLeaveHours AS FLOAT)/24, 3) As SickLeaveDays
	FROM AdventureWorks2019.HumanResources.Employee as employee
	WHERE employee.NationalIDNumber = @NationalIDNumber

END;

EXEC DaysOff @NationalIDNumber = 295847284
EXEC DaysOff @NationalIDNumber = 245797967
EXEC DaysOff @NationalIDNumber = 509647174


-- 7. Napisz procedurę będącą kalkulatorem walutowym. Wykorzystaj dwie tabele: Sales.Currency 
--    oraz Sales.CurrencyRate. Parametrami wejściowymi mają być: kwota, waluty oraz data.
--    Przyjmij, iż zawsze jedną ze stron jest dolar amerykański (USD).
--    Zaimplementuj kalkulację obustronną, tj:
--    1400 USD → PLN lub PLN → USD

CREATE OR ALTER PROCEDURE CurrencyExchange(@FromCurrencyCode NCHAR(3), 
										   @ToCurrencyCode NCHAR(3), 
										   @Amount FLOAT, 
										   @CurrencyRateDate DATETIME
										   )
AS
BEGIN

DECLARE @Rate MONEY;

BEGIN TRY

-- Sprawdzenie czy chcemy przekonwertowac z USD na inna walute, i czy ta inna waluta istnieje -> jesli tak, przypisanie kursu
IF (@FromCurrencyCode = 'USD') AND 0 <> (SELECT 1 FROM AdventureWorks2019.Sales.Currency WHERE CurrencyCode = @ToCurrencyCode)
BEGIN
	SET @Rate = (
		SELECT AverageRate 
		FROM AdventureWorks2019.Sales.CurrencyRate
		WHERE (CurrencyRate.FromCurrencyCode = 'USD') AND (CurrencyRate.ToCurrencyCode = @ToCurrencyCode) AND (CurrencyRate.CurrencyRateDate = @CurrencyRateDate)
		)
END;
ELSE
BEGIN
	-- Sprawdzenie czy chcemy przekonwertowac z innej waluty na USD, i czy ta inna waluta istnieje -> jesli tak, przypisanie kursu
	IF (@ToCurrencyCode = 'USD') AND 0 <> (SELECT 1 FROM AdventureWorks2019.Sales.Currency WHERE CurrencyCode = @FromCurrencyCode)
	BEGIN
		SET @Rate = 1.00/(
			SELECT AverageRate 
			FROM AdventureWorks2019.Sales.CurrencyRate 
			WHERE (CurrencyRate.FromCurrencyCode = 'USD') AND (CurrencyRate.ToCurrencyCode = @FromCurrencyCode) AND (CurrencyRate.CurrencyRateDate = @CurrencyRateDate)
			)
	END
	-- Gdy waluty podane procedurze są błędne
	ELSE 	
		RAISERROR ('Wrong currency codes given. Remember that one of the currencies has to be USD.', 16, 1) -- severity: 11-16	Indicate errors that can be corrected by the user.
END;

-- nie było danych dla podanej daty jesli @rate jest nullem
IF(@Rate is NULL)
	RAISERROR ('No rate for the given date. Try again with a different one.', 16, 1)

-- sprawdzenie prawidlowosci wprowadzonej kwoty
IF(@Amount <= 0)
	RAISERROR ('Invalid amount. It should be greater than zero.', 16, 1)

PRINT CAST(@Amount AS VARCHAR) + ' ' + @FromCurrencyCode + ' is ' + CAST(ROUND(@Rate * @Amount, 2) AS VARCHAR) + ' ' + 
		   @ToCurrencyCode + ' according to the exchange rate on ' + CAST(@CurrencyRateDate AS VARCHAR)

END TRY

BEGIN CATCH

DECLARE @ErrorMessage NVARCHAR(4000);  
DECLARE @ErrorSeverity INT;  
DECLARE @ErrorState INT;  
  
SELECT   
	@ErrorMessage = ERROR_MESSAGE(),  
	@ErrorSeverity = ERROR_SEVERITY(),  
	@ErrorState = ERROR_STATE();  
   
RAISERROR (@ErrorMessage,
           @ErrorSeverity,
           @ErrorState
           );  

END CATCH
END;

-- działające
EXEC CurrencyExchange @FromCurrencyCode = 'USD', @ToCurrencyCode = 'JPY', @Amount = 100.22, @CurrencyRateDate = '2011-06-01 00:00:00.000'
EXEC CurrencyExchange @FromCurrencyCode = 'JPY', @ToCurrencyCode = 'USD', @Amount = 100.22, @CurrencyRateDate = '2011-06-01 00:00:00.000'
EXEC CurrencyExchange @FromCurrencyCode = 'USD', @ToCurrencyCode = 'USD', @Amount = 100.22, @CurrencyRateDate = '2011-06-01 00:00:00.000'

EXEC CurrencyExchange @FromCurrencyCode = 'USD', @ToCurrencyCode = 'JPY', @Amount = 1, @CurrencyRateDate = '2011-06-01 00:00:00.000'
EXEC CurrencyExchange @FromCurrencyCode = 'JPY', @ToCurrencyCode = 'USD', @Amount = 105.7, @CurrencyRateDate = '2011-06-01 00:00:00.000'
EXEC CurrencyExchange @FromCurrencyCode = 'USD', @ToCurrencyCode = 'USD', @Amount = 1, @CurrencyRateDate = '2011-06-01 00:00:00.000'

-- ze złymi kodami walut
EXEC CurrencyExchange @FromCurrencyCode = 'XYZ', @ToCurrencyCode = 'JPY', @Amount = 1, @CurrencyRateDate = '2011-06-01 00:00:00.000'
EXEC CurrencyExchange @FromCurrencyCode = 'ZYX', @ToCurrencyCode = 'USD', @Amount = 105.7, @CurrencyRateDate = '2011-06-01 00:00:00.000'
EXEC CurrencyExchange @FromCurrencyCode = 'JPY', @ToCurrencyCode = 'ABC', @Amount = 1, @CurrencyRateDate = '2011-06-01 00:00:00.000'
EXEC CurrencyExchange @FromCurrencyCode = 'USD', @ToCurrencyCode = 'CBA', @Amount = 105.7, @CurrencyRateDate = '2011-06-01 00:00:00.000'
EXEC CurrencyExchange @FromCurrencyCode = 'AAA', @ToCurrencyCode = 'BBB', @Amount = 1, @CurrencyRateDate = '2011-06-01 00:00:00.000'

-- ze złą datą
EXEC CurrencyExchange @FromCurrencyCode = 'USD', @ToCurrencyCode = 'JPY', @Amount = 100.22, @CurrencyRateDate = '2011-04-01 00:00:00.000'
EXEC CurrencyExchange @FromCurrencyCode = 'USD', @ToCurrencyCode = 'JPY', @Amount = 100.22, @CurrencyRateDate = '2021-04-01 00:00:00.000'

-- ze złą kwotą
EXEC CurrencyExchange @FromCurrencyCode = 'USD', @ToCurrencyCode = 'JPY', @Amount = 0, @CurrencyRateDate = '2011-06-01 00:00:00.000'
EXEC CurrencyExchange @FromCurrencyCode = 'JPY', @ToCurrencyCode = 'USD', @Amount = -10, @CurrencyRateDate = '2011-06-01 00:00:00.000'
EXEC CurrencyExchange @FromCurrencyCode = 'USD', @ToCurrencyCode = 'USD', @Amount = XD, @CurrencyRateDate = '2011-06-01 00:00:00.000'



