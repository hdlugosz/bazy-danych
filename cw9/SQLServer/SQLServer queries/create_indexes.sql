CREATE INDEX idx_GeoPietro_id_pietro_id_epoka ON GeoPietro(id_pietro, id_epoka);
CREATE INDEX idx_GeoEpoka_id_epoka_id_okres ON GeoEpoka(id_epoka, id_okres);
CREATE INDEX idx_GeoEra_id_era_id_eon ON GeoEra(id_era, id_eon);
CREATE INDEX idx_GeoOkres_id_okres_id_era ON GeoOkres(id_okres, id_era);

CREATE INDEX idx_GeoTabela_id_pietro ON GeoTabela(id_pietro);

CREATE INDEX idx_Milion_liczba ON Milion(liczba);