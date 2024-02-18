{{ config(materialized='table') }}

with extra_data as (
select *,
  date_trunc('day', marca_hora_presentada) as marca_fecha_presentada,
  ( max(total_clientes_sin_servicio) over (partition by "marca_fecha_presentada", "region")) as the_worst
from {{ ref('clientes_energizados_por_region') }}
),

only_the_worst as (

select distinct on (marca_fecha_presentada, region) * exclude the_worst
from extra_data
where total_clientes_sin_servicio = the_worst
order by marca_fecha_presentada, region, marca_hora_presentada -- NOTE: no deberiamos tener duplicados de marca_fecha en caso que mas de una hora presentada tengan el mismo valor
)

select
  *
from only_the_worst