Select COUNT(*) FROM
(
Select PARID FROM pbgh_property.allghny_prcls_2021_assessdta
union
Select PARID FROM pbgh_property.allghny_prcls_2021_geodta
union
Select PARID FROM pbgh_property.allghny_prcls_2021_salesdta	
)x