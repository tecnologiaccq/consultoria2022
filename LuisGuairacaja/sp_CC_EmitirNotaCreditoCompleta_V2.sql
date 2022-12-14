USE [CCQ_DESA]



/*
--============================================================================================================
-- Emision de notas de cr�dito completas
*/
CREATE OR ALTER PROC sp_CC_EmitirNotaCreditoCompleta_V2
(
@ArregloIdCargoCab ArregloIdCargoCab READONLY, 
@Motivo  VARCHAR(300)
)
AS

--DECLARE @ArregloIdCargoCab ArregloIdCargoCab
--DECLARE @Motivo  VARCHAR(300) = 'ANULACI�N TOTAL DE LA FACTURA 001-019-000126808'
--INSERT INTO @ArregloIdCargoCab values(291511);
--INSERT INTO @ArregloIdCargoCab values(291523);

-- ------------------------------
-- Validaci�n de Errores
DECLARE @resultadosValidacion VARCHAR(2000)  

--Tratamiento de errores  
 --====================================  
 DECLARE @MENSAJE_ERROR NVARCHAR(4000)  
 DECLARE @NUMERO_ERROR INT  
 DECLARE @ERROR_SEVERITY INT  
 DECLARE @ERROR_STATE INT  
 --====================================  
 
--En esta variable se retorna el id del Asiento generado o en caso del error el texto de mismo  
DECLARE @IdAsientoContableCab VARCHAR(2000) = NULL 
DECLARE @IdEmpresa INT = 0
DECLARE @IdTipoDocumento INT = 0
DECLARE @IdCaja INT = 0
DECLARE @Establecimiento CHAR(3) = ''
DECLARE @PuntoEmision CHAR(3) = ''
DECLARE @IdPuntoEmision INT = 0
DECLARE @IdTipoDocumentoCCQ INT = 0
DECLARE @IdTipoCobro INT = 0
DECLARE @IdPeriodoContable INT = 0
DECLARE @SecuencialInt INT = 0    
DECLARE @Secuencial CHAR(9) = ''   
DECLARE @IdEstadoDocumento INT = 0
DECLARE @IdGrupoComprobante INT = 0
DECLARE @NumeroComprobanteActual INT = 0
DECLARE @IdDescargoCabInserted INT = 0

--Tabla temporal para los IdCargos que llegan en el arreglo
DECLARE @maxContador INT = 0
DECLARE @codigo INT = 0
DECLARE @IdCargoCabCurrent INT = 0

DECLARE @tblCargos TABLE (
id INT IDENTITY(1, 1) NOT NULL PRIMARY KEY
,IdCargoCab INT NOT NULL
);

BEGIN TRY  
  BEGIN TRANSACTION CC_Registrar_NotaCredito;  

	INSERT INTO @tblCargos
	select * from @ArregloIdCargoCab
	SELECT @maxContador = @@ROWCOUNT
	IF (@maxContador > 0)
	BEGIN
	SELECT @codigo = 1;
	WHILE (@codigo <= @maxContador)
	BEGIN
	-- -----------
	-- ======================================================
	SELECT @IdCargoCabCurrent = IdCargoCab FROM @tblCargos WHERE id = @codigo;

	SELECT @IdEmpresa = cargo.IdEmpresa , @IdTipoDocumentoCCQ = cargo.IdTipoDocumentoCCQ
FROM tCC_CargosCab cargo
INNER JOIN @ArregloIdCargoCab arrIds on cargo.IdCargoCab = arrIds.IdCargoCab;
	SELECT @IdTipoDocumento = IdTipoDocumento FROM tGN_TiposDocumentos WHERE CodigoDocumentoSRI = '04' AND IdEmpresa = @IdEmpresa
	SELECT @IdCaja = Valor FROM tGN_ParametrosGenerales WHERE Codigo = 'ID_CAJA_NOTACREDITO' and IdEmpresa = @IdEmpresa
	SELECT @IdPuntoEmision = IdPuntoEmision FROM tCC_Caja WHERE IdCaja = @IdCaja
	SELECT @IdTipoCobro = IdTipoCobro FROM tCC_TiposCobros WHERE IdEmpresa = @IdEmpresa and Codigo = 'CAJ'
	SELECT @Establecimiento = Establecimiento FROM tGN_Establecimientos estab WHERE estab.IdEmpresa = @IdEmpresa
	SELECT @PuntoEmision = PuntoEmision FROM tGN_PuntosEmision WHERE IdPuntoEmision = @IdPuntoEmision
	SELECT @IdPeriodoContable = IdPeriodoContable FROM tCG_PeriodoContable WHERE IdEstadoPeriodoContable = 1 and IdEmpresa = @IdEmpresa
	SELECT @IdGrupoComprobante = IdGrupoComprobante from tCG_GrupoComprobantes WHERE IdEmpresa = @IdEmpresa and Codigo = 'DIA'
	SELECT @IdEstadoDocumento = IdEstadoDocumento from tCT_EstadoDocumentoSRI WHERE Codigo = 'CARGA'
	
	-- Get el secuencial disponible para la NC
	SELECT @SecuencialInt = Secuencial  
FROM   tGN_Secuenciales WITH (XLOCK, TABLOCK)  
WHERE  IdPuntoEmision = @IdPuntoEmision  
AND IdTipoDocumento = @IdTipoDocumento;      
	SET @Secuencial = [dbo].[fn_LeftPAD](CONVERT(VARCHAR, @SecuencialInt), 9, '0');  
	
	-- get el NumeroComprobante Actual
	SELECT @NumeroComprobanteActual = dbo.ObtenerNumeroComprobanteActual(  @IdEmpresa, @IdPeriodoContable, @IdGrupoComprobante)
	/*
PRINT '@@IdEmpresa: ' + convert(varchar,@IdEmpresa)
PRINT '@IdTipoDocumento: ' + convert(varchar,@IdTipoDocumento)
PRINT '@@IdTipoDocumentoCCQ: ' + convert(varchar,@IdTipoDocumentoCCQ)
PRINT '@IdCaja: ' + convert(varchar,@IdCaja)
PRINT '@IdPuntoEmision: ' + convert(varchar,@IdPuntoEmision)
PRINT '@IdTipoCobro: ' + convert(varchar,@IdTipoCobro)
PRINT '@Establecimiento: ' + convert(varchar,@Establecimiento)
PRINT '@PuntoEmision: ' + convert(varchar,@PuntoEmision)
PRINT '@IdPeriodoContable: ' + convert(varchar,@IdPeriodoContable)
PRINT '@Secuencial: ' + @Secuencial
PRINT '@NumeroComprobanteActual: ' + CONVERT(VARCHAR, @NumeroComprobanteActual)
*/

--[1]  Insert de la Cabecera del descargo

	INSERT INTO tCC_DescargosCab (
	IdCliente
	,IdTipoDocumento
	,IdEmpresa
	,IdPeriodoContable
	,Establecimiento
	,PuntoEmision
	,Secuencial
	,FechaEmision
	,SubtotalIva
	,Subtotal0
	,SubtotalNoObjetoImpuesto
	,TotalExcentoIva
	,SubtotalSinImpuesto
	,TotalDescuento
	,Iva
	,Ice
	,Irbpnr
	,ValorTotal
	,Saldo
	,Motivo
	,InformacionAdicional
	,IdEstadoDocumento
	,IdGrupoComprobante
	,NumeroComprobante
	,Concepto
	,IdTipoCobro
	,IdCaja
	,EnviarAlDoce
	,IdTipoDocumentoModificado
	,NumeroDocumentoModificado
	,FechaEmisionDocSustento
	,IdCobrador
	,IdCargoCab
	)
	select 
	cargo.IdCliente
	,@IdTipoDocumento as IdTipoDocumento
	,cargo.IdEmpresa as IdEmpresa 
	,@IdPeriodoContable as IdPeriodoContable
	,@Establecimiento as Establecimiento
	,@PuntoEmision as PuntoEmision
	,@Secuencial AS Secuencial
	,GETDATE() as FechaEmision
	,cargo.SubtotalIva
	,cargo.Subtotal0
	,cargo.SubtotalNoObjetoImpuesto
	,cargo.TotalExcentoIva
	,cargo.SubtotalSinImpuesto
	,cargo.TotalDescuento
	,cargo.Iva
	,cargo.Ice
	,cargo.Irbpnr
	,cargo.ValorTotal
	,cargo.Saldo
	,@Motivo
	,cargo.InformacionAdicional
	,@IdEstadoDocumento as IdEstadoDocumento
	,@IdGrupoComprobante as IdGrupoComprobante
	,@NumeroComprobanteActual as NumeroComprobante
	,@Motivo
	,@IdTipoCobro 
	,@IdCaja
	,cargo.EnviarAlDoce
	,cargo.IdTipoDocumento as IdTipoDocumentoModificado
	,cargo.NumeroDocumento as NumeroDocumentoModificado
	,cargo.FechaEmision as FechaEmisionDocSustento
	,cargo.IdCobrador
	,cargo.IdCargoCab
	from tCC_CargosCab cargo
	where cargo.IdCargoCab = @IdCargoCabCurrent;
	
	SET @IdDescargoCabInserted = CAST(IDENT_CURRENT('tCC_DescargosCab')  AS INT)-- Obtenemos el Id Ingresado en tCC_DescargosCab

	-- insert de detalles del descargo
	INSERT INTO tCC_DescargosDet(
IdDescargoCab
,CodigoPrincipal
,CodigoAuxiliar
,Descripcion
,Cantidad
,PrecioUnitario
,Descuento
,IdTipoImpuestoIva
,ValorIva
,IdTipoImpuestoIce
,ValorIce
,IdTipoImpuestoIrbpnr
,ValorIrbpnr
,Valor
,IdPlanCuentasEmpresaDebito
,IdPlanCuentasEmpresaCredito
,IdCentroCosto
,IdObjetoConsumo
--,Debito
--,Credito
,IdCargoCab
-- ,idnotacredito
,IdCuota
)
select 
@IdDescargoCabInserted--cab.IdDescargoCab
,det.CodigoPrincipal
,det.CodigoAuxiliar
,det.Descripcion
,det.Cantidad
,det.PrecioUnitario
,det.Descuento
,det.IdTipoImpuestoIva
,det.ValorIva
,det.IdTipoImpuestoIce
,det.ValorIce
,det.IdTipoImpuestoIrbpnr
,det.ValorIrbpnr
,det.Valor
--reemplazar el getdate por el primer dia dle periodo
--,CASE WHEN det.IdPlanCuentasEmpresaCredito = 272 AND cuota.FechaCuota <= GETDATE() THEN det.IdPlanCuentasEmpresaCredito ELSE 327 END IdPlanCuentasEmpresaDebito
,det.IdPlanCuentasEmpresaDebito IdPlanCuentasEmpresaDebito
,det.IdPlanCuentasEmpresaDebito IdPlanCuentasEmpresaCredito
,det.IdCentroCosto
,det.IdObjetoConsumo
,arr.IdCargoCab
,det.IdCuota
from tCC_CargosDet det
inner join tCC_DescargosCab cab on det.IdCargoCab = cab.IdCargoCab
inner join @ArregloIdCargoCab arr on cab.IdCargoCab = arr.IdCargoCab
--inner join tGS_Cuotas_V2 cuota on det.IdCuota = cuota.IdCuota

	-- --------------------------------------------
	-- Cruce de Documentos
	-- --------------------------------------------
	INSERT INTO tCC_TemporalCruceDoc
(
IdCliente,
IdTipoDocumento,
IdDescargoCab,
Valor,
Saldo,
IdEstadoDocumento,
IdCargoCab
)
select descargoCab.IdCliente, descargoCab.IdTipoDocumento, descargoCab.IdDescargoCab, descargoCab.ValorTotal, descargoCab.Saldo, descargoCab.IdEstadoDocumento, IdCargoCab 
from tCC_DescargosCab descargoCab
where IdDescargoCab = @IdDescargoCabInserted
and descargoCab.IdTipoDocumento <> 59--Ingreso al fideicomiso

	-- --------------------------------------------
	-- Actualizaci�n de secuenciales
	-- --------------------------------------------
	UPDATE tGN_Secuenciales  
SET    Secuencial = [dbo].[fn_LeftPAD](CONVERT(VARCHAR, @SecuencialInt + 1), 9, '0')  
WHERE  IdPuntoEmision = @IdPuntoEmision  AND IdTipoDocumento = @IdTipoDocumento; 

	-- --------------------------------------------
	-- Se ejecuta el proceso de mayorizaci�n
	-- PENDIENTE
	-- --------------------------------------------
	
	-- ======================================================
	-- -----------
	SET @codigo = @codigo + 1;-- iteracion del contador     
	END --cierre del BEGIN del WHILE          
END -- cierre del IF (@maxContador>0)     




END TRY  
 BEGIN CATCH  
  SELECT @MENSAJE_ERROR = ERROR_MESSAGE(),  
         @NUMERO_ERROR       = ERROR_NUMBER(),  
         @ERROR_SEVERITY     = ERROR_SEVERITY(),  
         @ERROR_STATE        = ERROR_STATE();  
    
  SET @IdAsientoContableCab = @MENSAJE_ERROR;  
    
  RAISERROR (@MENSAJE_ERROR, @ERROR_SEVERITY, @ERROR_STATE);  
  IF EXISTS (  
         SELECT [name]  
         FROM   sys.dm_tran_active_transactions  
         WHERE  NAME = 'CC_Registrar_NotaCredito'  
     )  
      ROLLBACK TRANSACTION CC_Registrar_NotaCredito;  
 END CATCH;   
 COMMIT TRANSACTION CC_Registrar_NotaCredito;  
 RETURN  
ERROR:  
 SET @IdAsientoContableCab = @resultadosValidacion;  
 RAISERROR (@resultadosValidacion, 16, 1);  
 IF EXISTS (  
        SELECT [name]  
        FROM   sys.dm_tran_active_transactions  
        WHERE  NAME = 'CC_Registrar_NotaCredito'  
    )  
     ROLLBACK TRANSACTION CC_Registrar_NotaCredito;  


