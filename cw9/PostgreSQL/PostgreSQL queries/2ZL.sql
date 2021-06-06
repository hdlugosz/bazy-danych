SELECT COUNT(*) FROM Milion INNER JOIN GeoPietro ON 
(mod(Milion.liczba,77)=GeoPietro.id_pietro) NATURAL JOIN GeoEpoka NATURAL JOIN 
GeoOkres NATURAL JOIN GeoEra NATURAL JOIN GeoEon;