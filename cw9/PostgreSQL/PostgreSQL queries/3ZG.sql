SELECT COUNT(*) FROM Milion WHERE mod(Milion.liczba,77)= 
(SELECT id_pietro FROM GeoTabela WHERE mod(Milion.liczba,77)=(id_pietro));
