SELECT COUNT(*) FROM Milion 
	INNER JOIN GeoPietro as pietro 
		ON ((Milion.liczba % 77) = pietro.id_pietro) 
	JOIN GeoEpoka as epoka
		ON pietro.id_epoka = epoka.id_epoka
	JOIN GeoOkres  as okres
		ON epoka.id_okres = okres.id_okres 
	JOIN GeoEra as era
		ON okres.id_era = era.id_era
	JOIN GeoEon as eon
		ON era.id_eon = eon.id_eon;