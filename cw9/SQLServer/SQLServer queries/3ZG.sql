SELECT COUNT(*) FROM Milion 
	WHERE (Milion.liczba % 77) = 
	(SELECT id_pietro FROM GeoTabela WHERE (Milion.liczba % 77) = (id_pietro));
