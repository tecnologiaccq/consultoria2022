use CCQ_DESA
go

/*
DESCRIPCION:   Migración de cuotas ordinarias emitidas en el año 2022
*/

select 
cuota.IdCuota
,cuota.IdSocio
,cuota.IdCobrador
,cuota.IdVendedor
,cuota.NroMeses
,cuota.FechaCuota
,cuota.FechaCuota FechaEmision
,cuota.FechaVencimiento
,CONVERT(decimal (18,2), cuota.ValorCuota) ValorCuota
,CONVERT(decimal (18,2), cuota.ValorDescuento) ValorDescuento
,CONVERT(decimal (18,2), case WHEN cuota.ValorCuota >= 250 then 0.12 else 0.00 END) as PorcentajeIva
,CONVERT(decimal (18,2), 0) as ValorIva
,CONVERT(decimal (18,2), 0) ValorTotal
,IIF(month(cuota.FechaCuota)%2=1,1,2) IdMesEmisionBimestral
,cuota.Descripcion
into #temp
from tGS_Cuotas cuota
WHERE YEAR(cuota.FechaCuota) = 2022
and cuota.IdTipoCuota = 1 ---ORDINARIA
AND cuota.Anulada = 0


update #temp
set ValorIva = (ValorCuota - ValorDescuento) * PorcentajeIva

update #temp
set ValorTotal = ValorCuota - ValorDescuento + ValorIva


INSERT INTO tGS_Cuotas_V2 
(
IdSocio
,IdCobrador
,IdVendedor
,NroMeses
,FechaCuota
,FechaEmision
,FechaVencimiento
,ValorCuota
,ValorDescuento
,ValorPorcentajeIva
,ValorIva
,ValorTotal
,IdMesEmisionBimestral
,Descripcion
)
select IdSocio
,IdCobrador
,IdVendedor
,NroMeses
,FechaCuota
,FechaEmision
,FechaVencimiento
, ValorCuota
,ValorDescuento
,PorcentajeIva
,ValorIva
,ValorTotal
,IdMesEmisionBimestral
,Descripcion
from #temp

drop table #temp

-- ========================================
-- MIGRACION DE CUOTAS ANTICIPADAS
-- ========================================
select 
cuota.IdCuota
,cuota.IdSocio
,cuota.IdCobrador
,cuota.IdVendedor
,cuota.NroMeses
,cuota.FechaCuota
,cuota.FechaCuota FechaEmision
,cuota.FechaVencimiento
,CONVERT(decimal (18,2), cuota.ValorCuota) ValorCuota
,CONVERT(decimal (18,2), cuota.ValorDescuento) ValorDescuento
,CONVERT(decimal (18,2), case WHEN cuota.ValorCuota >= 250 then 0.12 else 0.00 END) as PorcentajeIva
,CONVERT(decimal (18,2), 0) as ValorIva
,CONVERT(decimal (18,2), 0) ValorTotal
,IIF(month(cuota.FechaCuota)%2=1,1,2) IdMesEmisionBimestral
,cuota.Descripcion
--into #temp
from tGS_Cuotas cuota
WHERE YEAR(cuota.FechaCuota) = 2022
and cuota.IdTipoCuota = 2 ---ANTICIPADAS
AND cuota.Anulada = 0

update #temp
set ValorIva = (ValorCuota - ValorDescuento) * PorcentajeIva

update #temp
set ValorTotal = ValorCuota - ValorDescuento + ValorIva


INSERT INTO tGS_Cuotas_V2 
(
IdSocio
,IdCobrador
,IdVendedor
,NroMeses
,FechaCuota
,FechaEmision
,FechaVencimiento
,ValorCuota
,ValorDescuento
,ValorPorcentajeIva
,ValorIva
,ValorTotal
,IdMesEmisionBimestral
,Descripcion
)
select IdSocio
,IdCobrador
,IdVendedor
,NroMeses
,FechaCuota
,FechaEmision
,FechaVencimiento
, ValorCuota
,ValorDescuento
,PorcentajeIva
,ValorIva
,ValorTotal
,IdMesEmisionBimestral
,Descripcion
from #temp

drop table #temp


select * from tGS_Cuotas_V2


