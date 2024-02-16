-- Para exportar uno que otro modelo bien rapido.
-- Puedes usar el duckdb CLI para avanzar

copy clientes_energizados to 'clientes_energizados.parquet' (format parquet);
copy clientes_energizados_por_region to 'clientes_energizados_por_region.parquet' (format parquet);