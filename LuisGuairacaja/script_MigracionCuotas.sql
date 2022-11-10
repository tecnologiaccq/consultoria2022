use CCQ_DESA
go

--INSERT INTO tGS_Cuotas_V2 
--(
--IdSocio
--,IdCobrador
--,IdVendedor
--,NroMeses
--,FechaCuota
--,FechaEmision
--,FechaVencimiento
--,ValorCuota
--,ValorDescuento
--,ValorPorcentajeIva
--,ValorIva
--,ValorTotal
--,IdMesEmisionBimestral
--,Descripcion
--)


select 
IdSocio
,cuota.IdCobrador
,cuota.IdVendedor
,cuota.NroMeses
,cuota.FechaCuota
,cargo.FechaEmision
,cuota.FechaVencimiento
,cuota.ValorCuota
,cuota.ValorDescuento

, 
(
select top 1 catImpuestos.Porcentaje 
from tCC_CargosDet det 
inner join tGN_TiposImpuestosIva catImpuestoIva on det.IdTipoImpuestoIva = catImpuestoIva.IdTipoImpuestoIva
inner join tGN_TiposImpuestos catImpuestos on catImpuestoIva.IdTipoImpuesto = catImpuestos.IdTipoImpuesto
where det.IdCargoCab = cargo.IdCargoCab
) as ValorPorcentajeIva

,cargo.Iva
,cargo.ValorTotal
,IIF(month(cuota.FechaCuota)%2=1,1,2) IdMesEmisionBimestral
, cuota.Descripcion
-- , cargo.*
from tGS_Cuotas cuota
inner join tCC_CargosCab cargo on cuota.IdFactura = cargo.IdCargoCab
where cargo.IdEmpresa = 1 --ccq
and cargo.IdTipoDocumento = 1 -- facturas
and cargo.IdTipoDocumentoCCQ = 1 -- ordinarias
and year(cargo.FechaEmision) = 2022

---- select * from tGS_Cuotas_V2
--select * from tCC_CargosCab
--where IdCargoCab = 279943

--select * from tCC_CargosDet
--where IdCargoCab = 279943

--select * from tGN_TiposImpuestosIva
--select * from tGN_TiposImpuestos



