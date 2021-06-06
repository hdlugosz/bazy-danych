SELECT COUNT(*) FROM Milion WHERE (Milion.liczba % 77) IN
(SELECT id_pietro FROM GeoPietro as pietro
	JOIN GeoEpoka as epoka 
		ON pietro.id_epoka = epoka.id_epoka
	JOIN GeoOkres as okres
		ON epoka.id_okres = okres.id_okres 
	JOIN GeoEra as era
		ON okres.id_era = era.id_era
	JOIN GeoEon as eon
		ON era.id_eon = eon.id_eon)