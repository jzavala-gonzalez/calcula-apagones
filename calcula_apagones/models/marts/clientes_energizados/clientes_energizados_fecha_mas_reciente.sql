with initial_window_calculations as (
    select
        *,
        date_trunc('day', marca_hora_presentada) as marca_fecha_presentada,
        max(marca_fecha_presentada) over () as max_marca_fecha_presentada
    from clientes_energizados
)

select * exclude max_marca_fecha_presentada
from initial_window_calculations
where marca_fecha_presentada = max_marca_fecha_presentada