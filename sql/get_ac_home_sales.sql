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
,parcels.USEDESC
,assess.STYLEDESC
,COALESCE(geo.geo_name_nhood,parcels.PROPERTYCITY)																								AS NEIGHBHOOD
,geo.x AS LON
,geo.y AS LAT
,parcels.SALEDESC
,DATE(CONCAT(RIGHT(parcels.SALEDATE,4),'-',LEFT(parcels.SALEDATE,2),'-',RIGHT(LEFT(parcels.SALEDATE,5),2))) 									AS SALEDATE
,CAST(parcels.SALEPRICE AS UNSIGNED)																											AS SALEPRICE
,DATE(CONCAT(RIGHT(assess.PREVSALEDATE,4),'-',LEFT(assess.PREVSALEDATE,2),'-',RIGHT(LEFT(assess.PREVSALEDATE,5),2))) 							AS PREVSALEDATE
,CAST(assess.PREVSALEPRICE AS UNSIGNED)																											AS PREVSALEPRICE
,DATE(CONCAT(RIGHT(assess.PREVSALEDATE2,4),'-',LEFT(assess.PREVSALEDATE2,2),'-',RIGHT(LEFT(assess.PREVSALEDATE2,5),2))) 						AS PREVSALEDATE2
,CAST(assess.PREVSALEPRICE2 AS UNSIGNED)																										AS PREVSALEPRICE2
,CAST(assess.FINISHEDLIVINGAREA AS UNSIGNED)																									AS FINISHEDLIVINGAREA
,DATE(CONCAT(RIGHT(assess.RECORDDATE,4),'-',LEFT(assess.RECORDDATE,2),'-',RIGHT(LEFT(assess.RECORDDATE,5),2))) 									AS RECORDDATE
,CAST(assess.YEARBLT AS UNSIGNED)																												AS YEARBLT
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

FROM pbgh_property.allegheny_cty_parcels_2021 parcels
	 INNER JOIN pbgh_property.allghny_prcls_2021_geodta geo ON parcels.PARID = geo.PARID
     LEFT OUTER JOIN pbgh_property.allghny_prcls_2021_assessdta assess ON assess.PARID = parcels.PARID 
     
WHERE parcels.USEDESC IN ('SINGLE FAMILY','ROWHOUSE','TOWNHOUSE','TWO FAMILY','FOUR FAMILY','THREE FAMILY')