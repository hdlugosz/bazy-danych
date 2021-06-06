SELECT COUNT(*) FROM Milion WHERE mod(Milion.liczba,77) IN
(SELECT GeoPietro.id_pietro FROM GeoPietro NATURAL JOIN GeoEpoka NATURAL JOIN 
GeoOkres NATURAL JOIN GeoEra NATURAL JOIN GeoEon);

