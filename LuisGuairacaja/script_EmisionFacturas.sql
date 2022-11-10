-- Actualizando el tipo de datos del campo [Ambiente] de la tabla [tCC_CargosCab]
ALTER TABLE tCC_CargosCab ALTER COLUMN Ambiente	CHAR(1)

GO

/*
Descripcion:  Se optimiza el ingreso de detalles.
Autor: LUIS GUAIRACAJA
Última Modificación:  09/nov/2022
*/
ALTER PROCEDURE [dbo].[sp_FT_GuardarFacturaMain]  
(  
    @IdEmpresa INT,  
    @IdCliente INT,  
    @CorreoElectronicoComprador VARCHAR(100) = NULL,  
    @SubTotal14PorCiento DECIMAL(18, 5),  
    @Subtotal0PorCiento DECIMAL(18, 5),  
    @SubtotalNoObjetoIva DECIMAL(18, 5),  
    @SubtotalExcentoIva DECIMAL(18, 5),  
    @SubtotalSinImpuestos DECIMAL(18, 5),  
    @TotalDescuento DECIMAL(18, 5),  
    @ValorIVA DECIMAL(18, 5),  
    @ValorICE DECIMAL(18, 5),  
    @ValorIRBPNR DECIMAL(18, 5),  
    @ValorPropina DECIMAL(18, 5),  
    @FechaEmision DATE,  
    @Establecimiento VARCHAR(3),  
    @PuntoEmision VARCHAR(3),  
    @IdPeriodoContable INT,  
    @IdGrupoComprobante INT,  
    @IdTipoDocumento INT,  
    @IdTipoDocumentoCCQ INT,  
    @IdCobrador INT,  
    @IdCobradorEfectivo INT,  
    @IdVendedor INT,  
    @Saldo DECIMAL(18, 5),  
    @IdEstadoDocumento INT,  
    @IdPuntoEmision INT,  
    @ArregloCargoDetalle ArregloCargoDetalle READONLY,  
    @IdCaja INT,  
    @informacionAdicionalDeLaFactura VARCHAR(300) = NULL,  
    @NumeroCaso VARCHAR(32),  
	@EsCortesiaEspectaculo BIT = 0,  
    @IdCargoCab INT OUTPUT, -- retorna el identificador de Cargo que se generó     
    @FechaVencimiento DATE = GETDATE  
)  
AS  
--====================================                          
  DECLARE @Ambiente char(1) = '2'

  
--Tratamiento de errores            
--====================================                          
DECLARE @MENSAJE_ERROR NVARCHAR(4000);  
DECLARE @NUMERO_ERROR INT;  
DECLARE @ERROR_SEVERITY INT;  
DECLARE @ERROR_STATE INT;  
DECLARE @MENSAJE_PERSONALIZADO VARCHAR(2000);  
--====================================                                       
  
BEGIN TRY  
    BEGIN TRANSACTION GuardarFacturaMain;  

	SELECT @Ambiente = Valor
	FROM [dbo].[tGN_ParametrosGenerales]  
    WHERE Codigo = 'DOCE_AMBIENTE'  AND IdEmpresa = @IdEmpresa  


    --[0] OBTENGO EL SECUENCIAL ACTUAL DEL DOCUMENTO PARA EL PUNTO DE EMISION DEL USUARIO ACTUAL                          
    DECLARE @SecuencialInt BIGINT;  
    DECLARE @Secuencial VARCHAR(9);  
  
    SELECT @SecuencialInt = Secuencial  
    FROM dbo.tGN_Secuenciales WITH (XLOCK, TABLOCK)  
    WHERE IdPuntoEmision = @IdPuntoEmision  
          AND IdTipoDocumento = @IdTipoDocumento;  
    SET @Secuencial = [dbo].[fn_LeftPAD](CONVERT(VARCHAR, @SecuencialInt), 9, '0');  
  
    --==================================================            
    --[3] INSERT CARGO-CABECERA                      
  
    DECLARE @indice INT;  
    DECLARE @limite INT;  
    INSERT INTO [dbo].[tCC_CargosCab]  
    (  
        [IdTipoDocumentoCCQ],  
        [IdCobrador],  
        [IdCobradorEfectivo],  
        [IdVendedor],  
        [IdTipoDocumento],  
        [IdEmpresa],  
        [IdPeriodoContable],  
        [IdCliente],  
        [IdGrupoComprobante],  
        [Establecimiento],  
        [PuntoEmision],  
        [Secuencial],  
        [FechaEmision],  
        [Propina],  
        [SubtotalIva],  
        [Subtotal0],  
        [SubtotalNoObjetoImpuesto],  
        [TotalExcentoIva],  
        [SubtotalSinImpuesto],  
        [TotalDescuento],  
        [Iva],  
        [Ice],  
        [Irbpnr],  
        [ValorTotal],  
        [Saldo],  
        [IdEstadoDocumento],  
        [Ambiente],  
        [IdCaja],  
        -- [IdFactura],            
        [InformacionAdicional],  
        [NumeroCaso],  
        [FechaVencimiento],  
        CorreoElectronicoCargo,  
  EsCortesiaEspectaculo  
    )  
    VALUES  
    (   @IdTipoDocumentoCCQ, @IdCobrador, @IdCobradorEfectivo, @IdVendedor, @IdTipoDocumento, @IdEmpresa,  
        @IdPeriodoContable, @IdCliente, @IdGrupoComprobante, @Establecimiento, @PuntoEmision, @Secuencial,  
        @FechaEmision, @ValorPropina, @SubTotal14PorCiento, @Subtotal0PorCiento, @SubtotalNoObjetoIva,  
        @SubtotalExcentoIva, @SubtotalSinImpuestos, @TotalDescuento, @ValorIVA, @ValorICE, @ValorIRBPNR, @Saldo,  
        @Saldo, @IdEstadoDocumento, @Ambiente, @IdCaja,  
        @informacionAdicionalDeLaFactura, @NumeroCaso, @FechaVencimiento, @CorreoElectronicoComprador, @EsCortesiaEspectaculo);  
  
    --[3-1] Obtener el IdCargo ingresado en el autonumerico                      
    -- SELECT @IdCargoCab = SCOPE_IDENTITY();  
	SET @IdCargoCab = CAST(IDENT_CURRENT('tCC_CargosCab')  AS INT)-- Obtenemos el Id Ingresado en tCC_CargosCab
  
  
    --[4] INSERT CARGO-DETALLES            
    --==================================================                          
	 INSERT INTO [dbo].[tCC_CargosDet]  
        (  
            [IdCargoCab],  
            [CodigoPrincipal],  
            [CodigoAuxiliar],  
            [Descripcion],  
            [Cantidad],  
            [PrecioUnitario],  
            [Descuento],  
            [IdTipoImpuestoIva],  
            [ValorIva],  
            [IdTipoImpuestoIce],  
            [ValorIce],  
            [IdTipoImpuestoIrbpnr],  
            [Valor],  
            [IdPlanCuentasEmpresaDebito],  
            [IdPlanCuentasEmpresaCredito],  
			[IdInscripcion]  
        )  
        SELECT @IdCargoCab,  
               CodigoPrincipal,  
               CodigoAuxiliar,  
               Descripcion,  
               Cantidad,  
               PrecioUnitario,  
               Descuento,  
               IdTipoImpuestoIva,  
               ValorIva,  
               IdTipoImpuestoIce,  
               ValorIce,  
               IdTipoImpuestoIrbpnr,  
               Valor,  
               IdPlanCuentasEmpresaDebito,  
               IdPlanCuentasEmpresaCredito,  
			   IIF(IdInscripcion = 0, NULL, IdInscripcion)  
		FROM @ArregloCargoDetalle;
        --- WHERE Id = @indice;  
  
    -- -----------------------------------                  
    COMMIT TRANSACTION GuardarFacturaMain;  
END TRY  
BEGIN CATCH  
    SELECT @MENSAJE_ERROR = ERROR_MESSAGE(),  
           @NUMERO_ERROR = ERROR_NUMBER(),  
           @ERROR_SEVERITY = ERROR_SEVERITY(),  
           @ERROR_STATE = ERROR_STATE();  
    RAISERROR(@MENSAJE_ERROR, @ERROR_SEVERITY, @ERROR_STATE);  
    IF EXISTS  
    (  
        SELECT [name]  
        FROM sys.dm_tran_active_transactions  
        WHERE name = 'GuardarFacturaMain'  
    )  
        ROLLBACK TRANSACTION GuardarFacturaMain;  
END CATCH;  
RETURN;  
ERROR:  
RAISERROR(@MENSAJE_PERSONALIZADO, 16, 1);  
IF EXISTS  
(  
    SELECT [name]  
    FROM sys.dm_tran_active_transactions  
    WHERE name = 'GuardarFacturaMain'  
)  
    ROLLBACK TRANSACTION GuardarFacturaMain;  
  
  
  
  
  
