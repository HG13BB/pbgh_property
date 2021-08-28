/* Query to find houses that could be possible flips 
	in Allegency County, PA
    Date source from: https://tools.wprdc.org/property-api
    Henry Greeley 5.23.21
*/ 

SELECT 
   parc.*
  ,geo.geo_name_nhood
  ,geo.geo_id_zipcode
  ,geo.x				as longitude
  ,geo.y				as latitude
  ,geo.geo_name_tract
  ,geo.geo_id_tract
 ,DATE(CONCAT(RIGHT(PREVSALEDATE,4),'-',LEFT(PREVSALEDATE,2),'-',RIGHT(LEFT(PREVSALEDATE,5),2))) 						AS PREVSLDT
 ,DATE(CONCAT(RIGHT(SALEDATE,4),'-',LEFT(SALEDATE,2),'-',RIGHT(LEFT(SALEDATE,5),2))) 									AS SALEDT
,DATEDIFF(
		  DATE(CONCAT(RIGHT(SALEDATE,4),'-',LEFT(SALEDATE,2),'-',RIGHT(LEFT(SALEDATE,5),2))),
          DATE(CONCAT(RIGHT(PREVSALEDATE,4),'-',LEFT(PREVSALEDATE,2),'-',RIGHT(LEFT(PREVSALEDATE,5),2)))
          ) 																										    AS HELDDAYS
,parc.SALEPRICE / parc.FINISHEDLIVINGAREA AS SalePriceSqFt
,parc.PREVSALEPRICE / parc.FINISHEDLIVINGAREA AS PrevSalePriceSqFt
							


FROM pbgh_property.allegheny_cty_parcels_2021 parc
	 LEFT OUTER JOIN pbgh_property.allghny_prcls_2021_geodta geo
		on geo.PARID = parc.PARID

WHERE 1=1
AND DATE(CONCAT(RIGHT(PREVSALEDATE,4),'-',LEFT(PREVSALEDATE,2),'-',RIGHT(LEFT(PREVSALEDATE,5),2)))  >= '2006-01-01' 


AND CLASSDESC = 'RESIDENTIAL'
AND SALEPRICE >=  20000
AND PREVSALEPRICE >  1000
AND geo.PARID IS NOT NULL

#bought held for more than 30 days and less than a year
AND DATEDIFF(
		  DATE(CONCAT(RIGHT(SALEDATE,4),'-',LEFT(SALEDATE,2),'-',RIGHT(LEFT(SALEDATE,5),2))),
          DATE(CONCAT(RIGHT(PREVSALEDATE,4),'-',LEFT(PREVSALEDATE,2),'-',RIGHT(LEFT(PREVSALEDATE,5),2)))
          )  BETWEEN 30 AND 365

ORDER BY DATE(CONCAT(RIGHT(PREVSALEDATE,4),'-',LEFT(PREVSALEDATE,2),'-',RIGHT(LEFT(PREVSALEDATE,5),2)));