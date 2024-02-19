{{ config(materialized='external', location='s3://publica-apagones/datasets/clientes_energizados_por_region.parquet', format='parquet') }}
from {{ ref('clientes_energizados_por_region') }}