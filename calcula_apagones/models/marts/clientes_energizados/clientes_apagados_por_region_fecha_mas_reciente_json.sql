{{ config(materialized='external', location='s3://publica-apagones/datasets/clientes_apagados_por_region_fecha_mas_reciente.json', format='json') }}
with fecha_mas_reciente as (
select
    *,
    max(marca_fecha_presentada) over () as marca_fecha_presentada_mas_reciente,
from {{ ref('clientes_apagados_por_region_por_dia') }}
),

clientes_apagados_por_region_fecha_mas_reciente as (
    select *
        exclude (marca_fecha_presentada_mas_reciente)
    from fecha_mas_reciente
    where marca_fecha_presentada = marca_fecha_presentada_mas_reciente
),

structed_data as (
    from clientes_apagados_por_region_fecha_mas_reciente
    select clientes_apagados_por_region_fecha_mas_reciente
)

select
    list(clientes_apagados_por_region_fecha_mas_reciente) as data,
    data.list_transform(d -> d.marca_fecha_presentada)[1] as marca_fecha_presentada,
from structed_data