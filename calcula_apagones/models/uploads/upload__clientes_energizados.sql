{{ config(materialized='external', location='s3://publica-apagones/datasets/clientes_energizados.parquet', format='parquet') }}
from {{ ref('clientes_energizados') }}