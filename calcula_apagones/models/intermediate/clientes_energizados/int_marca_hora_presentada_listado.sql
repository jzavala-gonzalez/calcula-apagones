with all_marca_hora_presentada as (
    select
        unnest(generate_series(min("marca_hora_presentada"), max("marca_hora_presentada"), INTERVAL 5 MINUTE)) as "marca_hora_presentada"
    from {{ ref('stg_archiva_apagones__capturas_regiones_sin_servicio') }}
)

select *
from all_marca_hora_presentada