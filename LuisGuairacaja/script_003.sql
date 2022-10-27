/*
Migración a la nueva tabla [tGS_Cuotas_V2]
*/
insert into tGS_Cuotas_V2
(
IdSocio
,IdTipoCuota
,IdFactura
,IdNotaCredito
,IdMedioPago
,IdCobrador
,IdVendedor
,IdFrecuenciaGeneracionCuota
,IdPeriodo
,NroMeses
,FechaCuota
,FechaVencimiento
,ValorBruto
,ValorCuota
,ValorDescuento
,Saldo
,SaldoCuotaAnticipada
,ValorCuotaDevengar
,ValorDescuentoDevengar
,Descripcion
,Anulada
,FacturaGenerada
,NCGenerada
,IdCuotaOriginal
,EsCuotaDevengada
,FechaCondonacion
,ObservacionCondonacion
,InformacionAdicionalFactura
,IdAsientoContable
,EsCuotaManual
,IdTipoEmisionCuotaCCQ
,IdMesEmisionBimestral
,MesInicial
,MesFinal
,FechaEmision
,Valor
,ValorIVA
,ValorTOTAL 
)
select 
IdSocio
,cuota.IdTipoCuota
,cuota.IdFactura
,cuota.IdNotaCredito
,cuota.IdMedioPago
,cuota.IdCobrador
,cuota.IdVendedor
,cuota.IdFrecuenciaGeneracionCuota
,cuota.IdPeriodo
,cuota.NroMeses
,cuota.FechaCuota
,cuota.FechaVencimiento
,cuota.ValorBruto
,cuota.ValorCuota
,cuota.ValorDescuento
,cuota.Saldo
,cuota.SaldoCuotaAnticipada
,cuota.ValorCuotaDevengar
,cuota.ValorDescuentoDevengar
,cuota.Descripcion
,cuota.Anulada
,cuota.FacturaGenerada
,cuota.NCGenerada
,cuota.IdCuotaOriginal
,cuota.EsCuotaDevengada
,cuota.FechaCondonacion
,cuota.ObservacionCondonacion
,cuota.InformacionAdicionalFactura
,cuota.IdAsientoContable
,cuota.EsCuotaManual
,cargo.IdTipoDocumentoCCQ
,IIF(month(cuota.FechaCuota)%2=1,1,2)
,cuota.FechaCuota
,DATEADD(month, cuota.NroMeses, cuota.FechaCuota) 
,cargo.FechaEmision
,cargo.SubtotalSinImpuesto
,cargo.Iva
,cargo.ValorTOTAL 
from tGS_Cuotas cuota
inner join tCC_CargosCab cargo on cuota.IdFactura = cargo.IdCargoCab
where cargo.IdEmpresa = 1 --ccq
and cargo.IdTipoDocumento = 1 -- facturas
and cargo.IdTipoDocumentoCCQ = 1 -- ordinarias
and year(cargo.FechaEmision) = 2022

