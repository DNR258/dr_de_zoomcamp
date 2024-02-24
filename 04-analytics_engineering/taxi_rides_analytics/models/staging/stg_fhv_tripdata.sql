{{
    config(
        materialized='view'
    )
}}

with tripdata as 
(
  select *
  from {{ source('staging','fhv_tripdata') }}
  where extract(year from pu_datetime) = 2019 

)
select
    -- identifiers
    {{ dbt_utils.generate_surrogate_key(['dispatching_base_num', 'pu_datetime']) }} as tripid,
    {{ dbt.safe_cast("dispatching_base_num", api.Column.translate_type("string")) }} as disp_base_num,
    {{ dbt.safe_cast("aff_base_num", api.Column.translate_type("string")) }} as aff_base_num,
    {{ dbt.safe_cast("pulocationid", api.Column.translate_type("integer")) }} as pickup_locationid,
    {{ dbt.safe_cast("dolocationid", api.Column.translate_type("integer")) }} as dropoff_locationid,
    
    -- timestamps
    cast(pu_datetime as timestamp) as pu_datetime,
    cast(do_datetime as timestamp) as do_datetime,
    
    -- trip info
    {{ dbt.safe_cast("sr_flag", api.Column.translate_type("integer")) }} as sr_flag


from tripdata



-- dbt build --select <model_name> --vars '{'is_test_run': 'false'}'
{% if var('is_test_run', default=true) %}

  limit 100

{% endif %}
