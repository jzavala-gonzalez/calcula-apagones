with initial as (
from "calcula_apagones"."main"."stg_archiva_apagones__capturas_regiones_sin_servicio"
),

all_marca_hora_presentada as (
    select
        unnest(generate_series(min("marca_hora_presentada"), max("marca_hora_presentada"), INTERVAL 5 MINUTE)) as "marca_hora_presentada"
    from initial
),

all_region as (
    select distinct unnest(regiones).name as region
    from initial
    order by region
),

all_marca_hora_region_pairs as (
    from all_marca_hora_presentada
    cross join
    all_region
    order by marca_hora_presentada, region
)

from all_marca_hora_region_pairs