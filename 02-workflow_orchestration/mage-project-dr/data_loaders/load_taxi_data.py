import io
import pandas as pd


if 'data_loader' not in globals():
    from mage_ai.data_preparation.decorators import data_loader
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


@data_loader
def load_data_from_api(*args, **kwargs):
    dfs = []
    for month in range(1,13):
        if len(str(month)) == 1:
            mes = '0' + str(month)
        else:
            mes = str(month)
        url = f"https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2022-{mes}.parquet"
        dfs.append(pd.read_parquet(url))

    df = pd.concat(dfs, ignore_index=True)
    return df
     

@test
def test_output(output, *args) -> None:
    """
    Template code for testing the output of the block.
    """
    assert output is not None, 'The output is undefined'