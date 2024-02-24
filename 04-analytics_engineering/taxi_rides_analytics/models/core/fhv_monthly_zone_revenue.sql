{{ config(materialized='table') }}

with trips_data as (
    select * from {{ ref('fhv_trips') }}
)
    select 
    -- Reveneue (GANANCIA) grouping 
    pickup_zone as revenue_zone,
    {{ dbt.date_trunc("month", "pu_datetime") }} as revenue_month, 

    service_type, 

    -- Additional calculations
    count(tripid) as total_monthly_trips,
    
    from trips_data
    group by 1,2,3