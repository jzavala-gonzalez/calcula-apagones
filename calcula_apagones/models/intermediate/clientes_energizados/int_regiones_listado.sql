with listado_regiones as (
    select distinct unnest(regiones).name as region
    from {{ ref('stg_archiva_apagones__capturas_regiones_sin_servicio') }}
    order by region
)

select *
from listado_regiones