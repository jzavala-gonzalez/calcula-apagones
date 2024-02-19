with unnested_clientes_info as (
     select
         row_number() over (partition by marca_hora_presentada order by marca_hora_accedida) as row_num,
         marca_hora_presentada,
         marca_hora_accedida,
         totales.totalPercentageWithService as porcentaje_clientes_con_servicio,
         totales.totalPercentageWithoutService as porcentaje_clientes_sin_servicio,
         totales.totalClients as total_clientes,
         totales.totalClientsWithService as total_clientes_con_servicio,
         totales.totalClientsWithoutService as total_clientes_sin_servicio,
         totales.totalClientsAffectedByPlannedOutage as total_clientes_afectados_por_apagon_planificado,
     from {{ref('stg_archiva_apagones__capturas_regiones_sin_servicio')}}
     -- order by marca_hora_presentada desc
 ),

 info_clientes_deduplicados as (
     select * exclude (row_num)
     from unnested_clientes_info
     where row_num = 1
 ),

 clientes_incluyendo_horas_no_accedidas as (
     select *
     from {{ref('int_marca_hora_presentada_listado')}}
     left join info_clientes_deduplicados
     using (marca_hora_presentada)
     order by marca_hora_presentada
 )

from clientes_incluyendo_horas_no_accedidas