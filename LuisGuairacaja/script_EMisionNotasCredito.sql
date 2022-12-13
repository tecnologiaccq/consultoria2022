USE [CCQ_DESA]

/* 
Se agrega un nuevo campo [IdCargoCab] a la tabla de Descargo.
Permitirá un cruce más rápido de los detalles
*/
alter table tCC_DescargosCab add IdCargoCab int   --*** DESCOMENTAR, antes de pasar a AMBIENTE

-- La Columna [NumeroDocumento] es la concatenacion de los campos Establecimiento-PuntoEmision-Secuencial
ALTER TABLE dbo.tCC_DescargosCab DROP COLUMN NumeroDocumento;
GO
ALTER TABLE tCC_DescargosCab ADD NumeroDocumento  AS (concat([Establecimiento],'-',[PuntoEmision],'-',[Secuencial]))


GO
DROP TRIGGER [tCC_DescargosCabAIIdCobrador]
GO
DROP TRIGGER [tCC_DescargosCabInsertTemporalCruce]
GO

GO
ALTER TRIGGER [dbo].[tCC_DescargosCabAIU]
ON [dbo].[tCC_DescargosCab]
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.tCC_DescargosCab
    SET UltimaModificacion = CURRENT_TIMESTAMP,
        ModificadoPor = SUSER_NAME(),
        EstacionModificacion = HOST_NAME(),
        CreadoPor = IIF(t.CreadoPor IS NULL, SUSER_NAME(), t.CreadoPor),
        FechaCreacion = IIF(t.FechaCreacion IS NULL, GETDATE(), t.FechaCreacion),
        EstacionCreacion = IIF(t.EstacionCreacion IS NULL, HOST_NAME(), t.EstacionCreacion)

    FROM dbo.tCC_DescargosCab AS t
        INNER JOIN INSERTED AS i
            ON t.IdDescargoCab = i.IdDescargoCab;
END;
GO

USE [CCQ_DESA]
GO
/****** Object:  Trigger [dbo].[tCC_DescargosCabExtensionAI]    Script Date: 8/11/2022 14:03:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[tCC_DescargosCabExtensionAI]
ON [dbo].[tCC_DescargosCab]
   AFTER INSERT
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @IdDescargoCab INT = 0;
	SELECT @IdDescargoCab = IdDescargoCab FROM Inserted;
	
	INSERT INTO dbo.tCC_DescargosCabExtension
	  (
	    IdDescargoCab,
	    RazonSocial,
	    Identificacion,
	    IdTipoIdentifcacion,
	    CorreoElectronico,
	    Telefono,
	    Direccion,
	    IdAsesor,
	    IdParroquia,
	    ReferenciaDireccion,
		IdEmpresa
	  )

SELECT i.IdDescargoCab, cli.RazonSocial, cli.Identificacion, cli.IdTipoIdentificacion,
stuff((
        select ';' + t.Contacto
        from tGN_ContactoPersona t
        where t.IdPersona = per.IdPersonas 
		AND t.IdMedioContacto = 15
        for xml path('')
    ),1,1,'') as CorreoElectronico
	,MAX(cto_telef.Contacto) AS Telefono
, MAX(dir.DireccionCompleta)AS Direccion
,socio.IdAsesor
, MAX(dir.IdParroquia) AS IdParroquia
, MAX(dir.Referencia) AS Referencia
, i.IdEmpresa
from  Inserted i
INNER JOIN tCC_Clientes cli on (cli.IdCliente =  i.IdCliente)
INNER JOIN tGN_Personas per on (per.IdPersonas = cli.IdPersona) 
LEFT JOIN tGS_Socios socio on (socio.IdSocio = cli.IdSocio)
LEFT JOIN tGN_ContactoPersona cto_telef on (cto_telef.IdPersona = per.IdPersonas AND cto_telef.IdMedioContacto = 6  and cto_telef.Principal = 1)
LEFT JOIN tGN_Direcciones dir on (dir.IdPersona = per.IdPersonas AND dir.IdTipoDireccion = 1 and dir.Principal = 1)
AND NOT EXISTS (
	               SELECT idcargocab
	               FROM   tCC_CargosCabExtension
	               WHERE  idcargocab = i.IdDescargoCab)
GROUP BY i.IdDescargoCab, cli.RazonSocial, cli.Identificacion, cli.IdTipoIdentificacion,socio.IdAsesor,per.IdPersonas,i.IdEmpresa 
END

GO



