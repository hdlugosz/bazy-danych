SELECT COUNT(*) FROM Milion INNER JOIN GeoTabela ON 
((Milion.liczba % 77)=(GeoTabela.id_pietro));
