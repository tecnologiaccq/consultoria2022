USE [CCQ_DESA]
GO

/****** Object:  Table [dbo].[tGN_Zonas]    Script Date: 21/10/2022 15:31:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tGN_TiposEmisionCuotaCCQ](
	[IdTipoEmisionCuotaCCQ] [tinyint] NOT NULL,
	[Codigo] [char](2) NOT NULL,
	[Nombre] [varchar](64) NOT NULL,
	[CreadoPor] [varchar](32) NULL,
	[FechaCreacion] [datetime] NULL,
	[EstacionCreacion] [varchar](24) NULL,
	[ModificadoPor] [varchar](32) NULL,
	[UltimaModificacion] [datetime] NULL,
	[EstacionModificacion] [varchar](24) NULL,
PRIMARY KEY CLUSTERED 
(
	[IdTipoEmisionCuotaCCQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

GO
CREATE TRIGGER [dbo].[tGN_TiposEmisionCuotaCCQ_AIU]
       ON [dbo].[tGN_TiposEmisionCuotaCCQ]
       AFTER INSERT,UPDATE
AS
	  BEGIN
         SET NOCOUNT ON

		 
         UPDATE tGN_TiposEmisionCuotaCCQ
            SET UltimaModificacion = CURRENT_TIMESTAMP ,
                ModificadoPor = suser_name(),
                EstacionModificacion = host_name(),
                CreadoPor=iif(t.CreadoPor IS NULL,suser_name(),t.CreadoPor),
                FechaCreacion=iif(t.FechaCreacion IS NULL,getdate(),t.FechaCreacion),
                EstacionCreacion=iif(t.EstacionCreacion IS NULL,host_name(),t.EstacionCreacion)
            FROM dbo.tGN_TiposEmisionCuotaCCQ AS t 
            INNER JOIN inserted AS i 
            ON t.IdTipoEmisionCuotaCCQ = i.IdTipoEmisionCuotaCCQ;
       END

GO
-- Fill
insert into tGN_TiposEmisionCuotaCCQ (IdTipoEmisionCuotaCCQ, Codigo,Nombre) values(1,'OR','ORDINARIA')
insert into tGN_TiposEmisionCuotaCCQ (IdTipoEmisionCuotaCCQ, Codigo,Nombre) values(2,'AN','ANTICIPADA')

--ID: 6	
-- Agregar nuevo campo en tabla Socio que permita identificar si la emision es de tipo ordinaria o anticipada 
ALTER TABLE tGS_Socios add IdTipoEmisionCuotaCCQ  TINYINT DEFAULT(1) --[1] Ordinaria, [2] Anticipada
-- eliminar esta campo
-- ALTER TABLE tGS_Socios add IdMesEmisionCuotaAnticipada TINYINT DEFAULT(1) --[1]Enero, [2] Febrero, ...[12]Diciembre

ALTER TABLE tGS_Socios add ExcluidoParaEmision  bit DEFAULT(0) --  True/1  Si el socio esta excluido,no se lo va a emitir 
ALTER TABLE tGS_Socios add IdMesEmisionBimestral  TINYINT DEFAULT(1) --[1] MesImpar, [2]  MesPar, para cuotas ordinarias

ALTER TABLE [dbo].[tGS_Socios]  WITH CHECK ADD  CONSTRAINT [FK_tGS_Socios_TipoEmisionCuotaCCQ] FOREIGN KEY([IdTipoEmisionCuotaCCQ])
REFERENCES [dbo].[tGN_TiposEmisionCuotaCCQ] ([IdTipoEmisionCuotaCCQ])
GO

-- drop table tGS_Cuotas_V2
CREATE TABLE [dbo].[tGS_Cuotas_V2](
	[IdCuota] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[IdSocio] [int] NOT NULL,
	[IdCobrador] [int] NOT NULL,
	[IdVendedor] [int] NULL,
	[NroMeses] [int] NOT NULL, --Número de meses que contiene la cuota
	[FechaCuota] [date] NOT NULL,  
	FechaEmision DATE NOT null , 
	[FechaVencimiento] [date] NOT null ,
	[ValorCuota] [decimal](18, 2) not NULL check(ValorCuota>=0),
	[ValorDescuento] [decimal](18, 2) not NULL, check(ValorDescuento>=0),
	ValorPorcentajeIva decimal(18,2) NOT NULL CHECK(ValorPorcentajeIva>=0), -- sera en 0.12, 0.00
	ValorIva DECIMAL(18,2) not NULL check(ValorIva>=0),
	ValorTotal DECIMAL(18,2) not NULL check(ValorTotal>=0),
	IdMesEmisionBimestral  TINYINT NOT NULL, --[1] MesImpar, [2]  MesPar, para cuotas ordinarias
	[Descripcion] [nvarchar](128) NOT NULL,
	[CreadoPor] [nvarchar](32) NOT NULL,
	[FechaCreacion] [datetime] NOT NULL,
	[EstacionCreacion] [nvarchar](24) NOT NULL,
	[ModificadoPor] [nvarchar](32) NOT NULL,
	[UltimaModificacion] [datetime] NOT NULL,
	[EstacionModificacion] [nvarchar](24) NOT NULL,

	CHECK (ValorIVA = (ValorCuota - ValorDescuento) * ValorPorcentajeIva),
	CHECK (ValorTotal = ValorIVA  +  ValorCuota - ValorDescuento)
 )

 -- REVISAR ESTA RELACION 
 
--ALTER TABLE tCC_CargosDet WITH CHECK ADD  CONSTRAINT [FK_tGS_Cuotas_V2_tCC_CargosDet] FOREIGN KEY([IdCuota])
--REFERENCES [dbo].[tGS_Cuotas_V2] ([IdCuota])

ALTER TABLE tCC_DescargosDet Add IdCuota INT
--ALTER TABLE tCC_DescargosDet WITH CHECK ADD  CONSTRAINT [FK_tGS_Cuotas_V2_tCC_DescargosDet] FOREIGN KEY([IdCuota])
--REFERENCES [dbo].[tGS_Cuotas_V2] ([IdCuota])


GO

-- Ajustes en la tabla del catalgo de Impuestos de IVA
ALTER TABLE tGN_TiposImpuestosIva add IdTipoImpuesto int
ALTER TABLE tGN_TiposImpuestosIva WITH CHECK ADD  CONSTRAINT [FK_tGN_TiposImpuestosIva_tGN_TiposImpuestos] FOREIGN KEY([IdTipoImpuesto])
REFERENCES [dbo].[tGN_TiposImpuestos] ([IdTipoImpuesto])

UPDATE tGN_TiposImpuestosIva set IdTipoImpuesto = 2 WHERE IdTipoImpuestoIva = 0
UPDATE tGN_TiposImpuestosIva set IdTipoImpuesto = 1 WHERE IdTipoImpuestoIva = 1
UPDATE tGN_TiposImpuestosIva set IdTipoImpuesto = 4 WHERE IdTipoImpuestoIva = 4
UPDATE tGN_TiposImpuestosIva set IdTipoImpuesto = 5 WHERE IdTipoImpuestoIva = 5

