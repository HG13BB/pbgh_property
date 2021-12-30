#main query to be used for modeling home sales activity in Allegheny Count
#Author:Henry Greeley
#Date: 7.3.21
#Name: get_ac_home_sales

SELECT 

parcels.PARID
,parcels.PROPERTYHOUSENUM
,parcels.PROPERTYUNIT
,parcels.PROPERTYADDRESS
,parcels.PROPERTYCITY
,parcels.PROPERTYZIP
,CONVERT(parcels.USECODE,unsigned) AS USECODE
,parcels.USEDESC
,parcels.STYLE
,assess.STYLEDESC
,COALESCE(geo.geo_name_nhood,parcels.PROPERTYCITY)			
,geo.geo_name_nhood
,geo.geo_id_zipcode																					AS NEIGHBHOOD
,CONVERT(geo.x, FLOAT) AS LON
,CONVERT(geo.y, FLOAT) AS LAT
,parcels.SALEDESC
,CONVERT(RIGHT(parcels.SALEDATE,4),UNSIGNED) 																									AS SALEYEAR
,DATE(CONCAT(RIGHT(parcels.SALEDATE,4),'-',LEFT(parcels.SALEDATE,2),'-',RIGHT(LEFT(parcels.SALEDATE,5),2))) 									AS SALEDATE
,CAST(parcels.SALEPRICE AS UNSIGNED)																											AS SALEPRICE
,DATE(CONCAT(RIGHT(assess.PREVSALEDATE,4),'-',LEFT(assess.PREVSALEDATE,2),'-',RIGHT(LEFT(assess.PREVSALEDATE,5),2))) 							AS PREVSALEDATE
,CAST(assess.PREVSALEPRICE AS UNSIGNED)																											AS PREVSALEPRICE
,DATE(CONCAT(RIGHT(assess.PREVSALEDATE2,4),'-',LEFT(assess.PREVSALEDATE2,2),'-',RIGHT(LEFT(assess.PREVSALEDATE2,5),2))) 						AS PREVSALEDATE2
,CAST(assess.PREVSALEPRICE2 AS UNSIGNED)																										AS PREVSALEPRICE2
,CAST(assess.FINISHEDLIVINGAREA AS UNSIGNED)																									AS FINISHEDLIVINGAREA
,DATE(CONCAT(RIGHT(assess.RECORDDATE,4),'-',LEFT(assess.RECORDDATE,2),'-',RIGHT(LEFT(assess.RECORDDATE,5),2))) 									AS RECORDDATE
,CAST(assess.YEARBLT AS UNSIGNED)																												AS YEARBLT
,parcels.ASOFDATE                                                                                      									        AS ASOFDATE
,CAST(assess.FAIRMARKETBUILDING AS UNSIGNED)																									AS FAIRMARKETBUILDING
,CAST(assess.FAIRMARKETLAND AS UNSIGNED)																										AS FAIRMARKETLAND
,CAST(assess.FAIRMARKETTOTAL AS UNSIGNED) 																										AS FAIRMARKETTOTAL
,CAST(assess.BEDROOMS AS UNSIGNED)																												AS BEDROOMS				
,CAST(assess.FULLBATHS AS UNSIGNED)																												AS FULLBATHS
,CAST(assess.STORIES AS UNSIGNED)																												AS STORIES
,assess.BASEMENT
,assess.BASEMENTDESC
,assess.HEATINGCOOLING
,assess.HEATINGCOOLINGDESC
,assess.CONDITION
,assess.CONDITIONDESC
,assess.ROOF
,assess.ROOFDESC
,assess.EXTFINISH_DESC
,assess.FIREPLACES
,CAST(assess.FAIRMARKETTOTAL AS UNSIGNED) 	/ CAST(assess.FINISHEDLIVINGAREA AS UNSIGNED)														AS ASSESS_PER_SQF
,CAST(parcels.SALEPRICE AS UNSIGNED) / CAST(assess.FINISHEDLIVINGAREA AS UNSIGNED)																AS PRICE_PER_SF
,DATEDIFF(
		  DATE(CONCAT(RIGHT(parcels.SALEDATE,4),'-',LEFT(parcels.SALEDATE,2),'-',RIGHT(LEFT(parcels.SALEDATE,5),2))),
          DATE(CONCAT(RIGHT(parcels.PREVSALEDATE,4),'-',LEFT(parcels.PREVSALEDATE,2),'-',RIGHT(LEFT(parcels.PREVSALEDATE,5),2)))
          ) 																										    AS HELDDAYS

FROM pbgh_property.allegheny_cty_parcels_2021 parcels
	 INNER JOIN pbgh_property.allghny_prcls_2021_geodta geo ON parcels.PARID = geo.PARID
     LEFT OUTER JOIN pbgh_property.allghny_prcls_2021_assessdta assess ON assess.PARID = parcels.PARID 
     
WHERE 1=1
AND parcels.USEDESC IN ('SINGLE FAMILY','ROWHOUSE','TOWNHOUSE','TWO FAMILY','FOUR FAMILY','THREE FAMILY')
AND DATE(CONCAT(RIGHT(parcels.SALEDATE,4),'-',LEFT(parcels.SALEDATE,2),'-',RIGHT(LEFT(parcels.SALEDATE,5),2)))  >= '2016-01-01'
AND CAST(parcels.SALEPRICE AS UNSIGNED)	 >= 10000
#AND geo.geo_name_nhood IS NOT NULL