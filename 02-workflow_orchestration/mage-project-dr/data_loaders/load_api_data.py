import io
import pandas as pd
import requests
from bs4 import BeautifulSoup, SoupStrainer
import re

if 'data_loader' not in globals():
    from mage_ai.data_preparation.decorators import data_loader
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


@data_loader
def load_data_from_api(*args, **kwargs):
    """
    Template for loading data from API
    """
    
    html = requests.get('https://github.com/DataTalksClub/nyc-tlc-data/releases/expanded_assets/green')

    taxi_dtypes = {
    'VendorID': pd.Int64Dtype(),
    'store_and_fwd_flag': str,
    'RatecodeID': pd.Int64Dtype(),
    'PULocationID': pd.Int64Dtype(),
    'DOLocationID': pd.Int64Dtype(),
    'passenger_count': float,
    'trip_distance': float,
    'fare_amount': float,
    'extra': float,
    'mta_tax': float,
    'tip_amount': float,
    'tolls_amount': float,
    'ehail_fee': float,
    'improvement_surcharge': float,
    'total_amount': float,
    'payment_type': float,
    'trip_type': float,
    'congestion_surcharge': float
    }

    parse_dates = ['lpep_pickup_datetime', 'lpep_dropoff_datetime']

    dfs = []
    for link in BeautifulSoup(html.text, parse_only=SoupStrainer('a'), features="lxml"):
        if hasattr(link, 'href') and link['href'].endswith('csv.gz'):
            url = 'https://github.com'+link['href']
            regexp = re.compile(r'2020-1[0|1|2]')
            if regexp.search(url):
                dfs.append(pd.read_csv(url, sep=',', compression='gzip', dtype=taxi_dtypes, parse_dates=parse_dates))
          
    df = pd.concat(dfs, ignore_index=True)
    return df
     

@test
def test_output(output, *args) -> None:
    """
    Template code for testing the output of the block.
    """
    assert output is not None, 'The output is undefined'
