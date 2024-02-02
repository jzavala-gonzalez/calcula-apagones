{{ config(materialized='table') }}
-- wow!
select
    marca_hora_presentada,
    marca_hora_accedida,
    regions as regiones,
    totals as totales,
    object_key,
from regions_without_service_cache.regions_without_service_staging