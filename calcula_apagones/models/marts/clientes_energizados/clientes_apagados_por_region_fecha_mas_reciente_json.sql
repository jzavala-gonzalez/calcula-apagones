with fecha_mas_reciente as (
select
    *,
    max(marca_fecha_presentada) over () as marca_fecha_presentada_mas_reciente,
from {{ ref('clientes_apagados_por_region_por_dia') }}
),

hora_mas_reciente as (
select
  date_trunc('day', marca_hora_presentada) as marca_fecha_presentada,
  max(marca_hora_presentada) as marca_hora_presentada_mas_reciente
from {{ ref('clientes_energizados_por_region') }}
group by marca_fecha_presentada
),

clientes_apagados_por_region_fecha_mas_reciente as (
    select *
        exclude (marca_fecha_presentada_mas_reciente)
    from fecha_mas_reciente
    full join hora_mas_reciente
    using (marca_fecha_presentada)
    where marca_fecha_presentada = marca_fecha_presentada_mas_reciente
),

clientes_apagados_totales_fecha_mas_reciente as (
  select
    'Total' as region,
    null::timestamp as marca_hora_presentada,
    sum(capr.total_clientes_sin_servicio) as total_clientes_sin_servicio,
    sum(capr.total_clientes) as total_clientes,
    sum(capr.total_clientes_sin_servicio) / sum(capr.total_clientes) * 100 as porcentaje_clientes_sin_servicio,
    first(capr.marca_fecha_presentada) as marca_fecha_presentada,
    first(capr.marca_hora_presentada_mas_reciente) as marca_hora_presentada_mas_reciente,
  from clientes_apagados_por_region_fecha_mas_reciente as capr
),

structed_regions_data as (
    from clientes_apagados_por_region_fecha_mas_reciente
    select clientes_apagados_por_region_fecha_mas_reciente
),

structed_totals_data as (
    from clientes_apagados_totales_fecha_mas_reciente
    select clientes_apagados_totales_fecha_mas_reciente
)

 select
    list(clientes_apagados_por_region_fecha_mas_reciente) as numeros_regiones,
    first(clientes_apagados_totales_fecha_mas_reciente) as numeros_totales,
    numeros_totales['marca_fecha_presentada'] as marca_fecha_presentada,
    numeros_totales['marca_hora_presentada_mas_reciente'] as marca_hora_presentada_mas_reciente,
 from structed_regions_data
 full join
 structed_totals_data
on 1 = 1