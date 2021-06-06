SELECT COUNT(*) FROM Milion INNER JOIN GeoTabela ON 
(mod(Milion.liczba,77)=(GeoTabela.id_pietro));