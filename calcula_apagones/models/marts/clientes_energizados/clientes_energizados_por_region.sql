with all_marca_hora_region_pairs as (
    from {{ ref('int_marca_hora_presentada_listado') }}
    cross join
    {{ ref('int_regiones_listado') }}
    order by marca_hora_presentada, region
),

pivoteado_por_region as (
    select
        marca_hora_presentada,
        marca_hora_accedida,
        unnest(regiones) as region_struct,
    from {{ ref('stg_archiva_apagones__capturas_regiones_sin_servicio') }}
),

unnested_region_info as (
    select
        row_number() over (partition by marca_hora_presentada, region_struct.name order by marca_hora_accedida) as row_num,
        marca_hora_presentada,
        marca_hora_accedida,
        region_struct.name as region,
        region_struct.percentageClientsWithService as porcentaje_clientes_con_servicio,
        region_struct.percentageClientsWithoutService as porcentaje_clientes_sin_servicio,
        region_struct.totalClients as total_clientes,
        region_struct.totalClientsWithService as total_clientes_con_servicio,
        region_struct.totalClientsWithoutService as total_clientes_sin_servicio,
        region_struct.totalClientsAffectedByPlannedOutage as total_clientes_afectados_por_apagon_planificado,
        -- region_struct
    from pivoteado_por_region
    -- order by marca_hora_presentada desc
),

info_regiones_deduplicados as (
    select * exclude (row_num)
    from unnested_region_info
    where row_num = 1
),

regiones_incluyendo_horas_no_accedidas as (
    select *
    from all_marca_hora_region_pairs
    left join info_regiones_deduplicados
    using (marca_hora_presentada, region)
    order by marca_hora_presentada, region
)

from regiones_incluyendo_horas_no_accedidas