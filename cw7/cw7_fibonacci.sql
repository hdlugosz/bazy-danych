-- Tworzenie funkcji obliczaj¹cej kolejne wyrazy ci¹gu fibonacciego

CREATE OR ALTER FUNCTION FibonacciFunction(@nth INT) 
RETURNS @fibonacci_series TABLE(Fibonacci_numbers BIGINT)
AS
BEGIN
	DECLARE @a BIGINT;
	SET @a = 0;
	DECLARE @b BIGINT;
	SET @b = 1;
	DECLARE @current BIGINT;
	SET @current = 0;
	DECLARE @i BIGINT;
	SET @i = 0;

	INSERT INTO @fibonacci_series VALUES(@a)

	WHILE (@i < (@nth-1))
		BEGIN
		SET @a = @b
		SET @b = @current
		SET @current = @a + @b
		INSERT INTO @fibonacci_series VALUES(@current)
		SET @i = @i + 1
	END
	RETURN
END;


-- Tworzenie procedury wypisuj¹cej kolejne wyrazy ci¹gu fibonacciego u¿ywaj¹c wy¿ej zadeklarowanej fukncji

CREATE OR ALTER PROCEDURE fibonacci(@max AS INT = 10)
AS
BEGIN
--DECLARE @result TABLE(Fibonacci_series BIGINT) 
--INSERT INTO @result (Fibonacci_series)
--SELECT * FROM FibonacciFunction(@max)
--SELECT * FROM @result
SELECT * FROM FibonacciFunction(@max)
END;

EXEC fibonacci 50;




