
import requests
import pandas as pd
import sqlalchemy

#connection to the open payments in data in mysql
constr = 'mysql+mysqlconnector://root:J5wyNz72Jgk2R3@localhost:3306/pbgh_property'
engine = sqlalchemy.create_engine(constr,echo=False)


class pb_parcel_parser:
    '''
    Class that parses parcel data obtained from the Western Pennsylvania Data Center API
    http://tools.wprdc.org/property-api/
    
    This class will parse the data received in json format and load to a local mysql db.  
    '''    

    def __init__(self,parcel):
        #initialize with the parcel number
        self.parcel = parcel
        
        #call from api and return json object
        self.api_call = 'http://tools.wprdc.org/property-api/v0/parcels/' + self.parcel
        self.parceldata = requests.get(str(self.api_call)).json()
        
    def printparcel(self):
        #test function to ensure class is working
        return self.parceldata
        
    def get_geodata(self):
        #dataframe with geo data from pbgh housing api
        
        if len(self.parceldata['results']) > 0:
            
            #pass if there is no data
            if len(self.parceldata['results'][0]['data']['centroids_and_geo_info']) > 0:

                #get geographic characteristics from JSON
                geoinfo = self.parceldata['results'][0]['data']['centroids_and_geo_info'][0]

                #parse to table structure and write to staging table 
                geodata = pd.DataFrame([geoinfo.values()],columns = geoinfo.keys())

                #add column with parcel id
                geodata['PARID'] = self.parcel

                geodata.to_sql('allghny_prcls_2021_geodta_stg',if_exists='append',index=False,con=engine)

                #write from staging table to live table if the parcel has not already been processed
                with engine.connect() as con:
                    con.execute('CALL `pbgh_property`.`load_geo_data`();')    

            else:
                pass
            
        else:
            pass
            
    def get_assess_data(self):
        #assessment table
        
        if len(self.parceldata['results']) > 0:
            
            #pass if there is no data
            if len(self.parceldata['results'][0]['data']['assessments']) > 0:

                #get assessment characteristics from JSON
                assessinfo = self.parceldata['results'][0]['data']['assessments'][0]

                #parse to table structure and write to staging table 
                assessdata = pd.DataFrame([assessinfo.values()],columns = assessinfo.keys())

                #add column with parcel id
                assessdata['PARID'] = self.parcel

                assessdata.to_sql('allghny_prcls_2021_assessdta_stg',if_exists='append',index=False,con=engine)

                #write from staging table to live table if the parcel has not already been processed
                with engine.connect() as con:
                    con.execute('CALL `pbgh_property`.`load_assess_data`();')

            else:
                pass 

        else:
            pass

    def get_sales_data(self):
        #sales history table

        if len(self.parceldata['results']) > 0:
        

            #pass if there is no sales data
            if len(self.parceldata['results'][0]['data']['sales']) > 0:

                #get sales data from JSON
                salesinfo = self.parceldata['results'][0]['data']['sales'][0]

                #parse to table structure and write to staging table 
                salesdata = pd.DataFrame([salesinfo.values()],columns = salesinfo.keys())

                #add column with parcel id
                salesdata['PARID'] = self.parcel

                salesdata.to_sql('allghny_prcls_2021_salesdta_stg',if_exists='append',index=False,con=engine)

                #write from staging table to live table if the parcel has not already been processed
                with engine.connect() as con:
                    con.execute('CALL `pbgh_property`.`load_sales_data`();')

            else:
                pass
        
        else:
            pass
