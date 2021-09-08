#main query to look at nearby home sales
#Author:Henry Greeley


SELECT 

parcels.PARID
,parcels.PROPERTYHOUSENUM
,parcels.PROPERTYUNIT
,parcels.PROPERTYADDRESS
,parcels.PROPERTYCITY
,parcels.PROPERTYZIP
,geo.geo_name_nhood
,assess.STYLEDESC
,DATE(CONCAT(RIGHT(parcels.SALEDATE,4),'-',LEFT(parcels.SALEDATE,2),'-',RIGHT(LEFT(parcels.SALEDATE,5),2))) 									AS SALEDATE
,CAST(parcels.SALEPRICE AS UNSIGNED)																											AS SALEPRICE
,CAST(assess.FAIRMARKETTOTAL AS UNSIGNED) 	/ CAST(assess.FINISHEDLIVINGAREA AS UNSIGNED)														AS ASSESS_PER_SQF
,CAST(parcels.SALEPRICE AS UNSIGNED) / CAST(assess.FINISHEDLIVINGAREA AS UNSIGNED)																AS PRICE_PER_SF

FROM pbgh_property.allegheny_cty_parcels_2021 parcels
     LEFT OUTER JOIN pbgh_property.allghny_prcls_2021_geodta geo ON geo.PARID = parcels.PARID
     LEFT OUTER JOIN pbgh_property.allghny_prcls_2021_assessdta assess ON assess.PARID = parcels.PARID 
     
WHERE parcels.USEDESC IN ('SINGLE FAMILY','ROWHOUSE','TOWNHOUSE','TWO FAMILY','FOUR FAMILY','THREE FAMILY')
AND DATE(CONCAT(RIGHT(parcels.SALEDATE,4),'-',LEFT(parcels.SALEDATE,2),'-',RIGHT(LEFT(parcels.SALEDATE,5),2))) >= '2019-01-01'
