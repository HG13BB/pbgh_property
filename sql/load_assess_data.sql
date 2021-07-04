CREATE PROCEDURE `load_assess_data`()
BEGIN

INSERT INTO `pbgh_property`.`allghny_prcls_2021_assessdta_stg`

 Select stg.* FROM `pbgh_property`.`allghny_prcls_2021_assessdta_stg` stg
 LEFT JOIN `pbgh_property`.`allghny_prcls_2021_assessdta_stg` final 
	ON stg.PARID = final.PARID 
WHERE final.PARID IS NULL;

TRUNCATE TABLE `pbgh_property`.`allghny_prcls_2021_assessdta_stg`;

END