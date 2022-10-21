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
ALTER TABLE tGS_Socios add IdMesEmisionCuotaAnticipada TINYINT DEFAULT(1) --[1]Enero, [2] Febrero, ...[12]Diciembre
ALTER TABLE tGS_Socios add ExcluidoParaEmision  bit DEFAULT(0) --  True/1  Si el socio esta excluido,no se lo va a emitir 
ALTER TABLE tGS_Socios add IdMesEmisionBimestral  TINYINT DEFAULT(1) --[1] MesImpar, [2]  MesPar, para cuotas ordinarias

ALTER TABLE [dbo].[tGS_Socios]  WITH CHECK ADD  CONSTRAINT [FK_tGS_Socios_TipoEmisionCuotaCCQ] FOREIGN KEY([IdTipoEmisionCuotaCCQ])
REFERENCES [dbo].[tGN_TiposEmisionCuotaCCQ] ([IdTipoEmisionCuotaCCQ])
GO


/****** Object:  Table [dbo].[tGS_Cuotas]    Script Date: 21/10/2022 15:24:44 ******/
SET ANSI_NULLS ON
GO

-- drop table tGS_Cuotas_V2
CREATE TABLE [dbo].[tGS_Cuotas_V2](
	[IdCuota] [int] IDENTITY(1,1) NOT NULL,
	[IdSocio] [int] NOT NULL,
	[IdTipoCuota] [int] NULL,
	[IdFactura] [int] NULL,
	[IdNotaCredito] [int] NULL,
	[IdMedioPago] [int] NULL,
	[IdCobrador] [int] NULL,
	[IdVendedor] [int] NULL,
	[IdFrecuenciaGeneracionCuota] [int] NULL,
	[IdPeriodo] [int] NULL,
	[NroMeses] [int] NULL,
	[FechaCuota] [date] NULL,
	[FechaVencimiento] [date] NULL,
	[ValorBruto] [decimal](18, 5) NULL,
	[ValorCuota] [decimal](18, 5) NULL,
	[ValorDescuento] [decimal](18, 5) NULL,
	[Saldo] [decimal](18, 5) NULL,
	[SaldoCuotaAnticipada] [decimal](18, 5) NULL,
	[ValorCuotaDevengar] [decimal](18, 5) NULL,
	[ValorDescuentoDevengar] [decimal](18, 5) NULL,
	[Descripcion] [nvarchar](128) NULL,
	[Anulada] [bit] NULL,
	[FacturaGenerada] [bit] NULL,
	[NCGenerada] [bit] NULL,
	[IdCuotaOriginal] [int] NULL,
	[EsCuotaDevengada] [bit] NULL,
	[FechaCondonacion] [datetime] NULL,
	[ObservacionCondonacion] [nvarchar](256) NULL,
	[CreadoPor] [nvarchar](32) NULL,
	[FechaCreacion] [datetime] NULL,
	[EstacionCreacion] [nvarchar](24) NULL,
	[ModificadoPor] [nvarchar](32) NULL,
	[UltimaModificacion] [datetime] NULL,
	[EstacionModificacion] [nvarchar](24) NULL,
	[InformacionAdicionalFactura] [nvarchar](300) NULL,
	[IdAsientoContable] [int] NULL,
	[EsCuotaManual] [bit] NULL,

	IdTipoEmisionCuotaCCQ  TINYINT DEFAULT(1), --[1] Ordinaria, [2] Anticipada
	IdMesEmisionBimestral  TINYINT DEFAULT(1), --[1] MesImpar, [2]  MesPar, para cuotas ordinarias
	MesInicial DATE, --
	MesFinal DATE, --
	FechaEmision DATE, 
	Valor DECIMAL(18,2),
	ValorIVA DECIMAL(18,2),
	ValorTOTAL DECIMAL(18,2)


 CONSTRAINT [PK_tGS_Cuotas_V2] PRIMARY KEY CLUSTERED 
(
	[IdCuota] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].tGS_Cuotas_V2 ADD  CONSTRAINT [DF_tGS_Cuotas_V2_ValorDescuento]  DEFAULT ((0)) FOR [ValorDescuento]
GO

ALTER TABLE [dbo].tGS_Cuotas_V2 ADD  CONSTRAINT [DF_tGS_Cuotas_V2_ValorDescuentoDevengar]  DEFAULT ((0)) FOR [ValorDescuentoDevengar]
GO

ALTER TABLE [dbo].tGS_Cuotas_V2 ADD  CONSTRAINT [DF__tmp_ms_xx__Anula__7DA9E828_V2]  DEFAULT ((0)) FOR [Anulada]
GO

ALTER TABLE [dbo].tGS_Cuotas_V2 ADD  CONSTRAINT [DF__tmp_ms_xx__Factu__7E9E0C61_V2]  DEFAULT ((0)) FOR [FacturaGenerada]
GO

ALTER TABLE [dbo].tGS_Cuotas_V2 ADD  CONSTRAINT [DF__tmp_ms_xx__NCGen__7F92309A_V2]  DEFAULT ((0)) FOR [NCGenerada]
GO

ALTER TABLE [dbo].tGS_Cuotas_V2 ADD  CONSTRAINT [DF__tmp_ms_xx__EsCuo__008654D3_V2]  DEFAULT ((0)) FOR [EsCuotaDevengada]
GO

ALTER TABLE [dbo].tGS_Cuotas_V2 ADD  CONSTRAINT [DF__tGS_Cuota_V2__EsCuo__1F4E0071]  DEFAULT ((0)) FOR [EsCuotaManual]
GO

ALTER TABLE [dbo].tGS_Cuotas_V2  WITH CHECK ADD  CONSTRAINT [FK_tGS_Cuotas_V2_Cobradores] FOREIGN KEY([IdCobrador])
REFERENCES [dbo].[tCC_Cobradores] ([IdCobrador])
GO
ALTER TABLE [dbo].tGS_Cuotas_V2 CHECK CONSTRAINT [FK_tGS_Cuotas_V2_Cobradores]
GO

ALTER TABLE [dbo].tGS_Cuotas_V2  WITH NOCHECK ADD  CONSTRAINT [FK_tGS_Cuotas_V2_IdFrecuenciaGeneracionCuota] FOREIGN KEY([IdFrecuenciaGeneracionCuota])
REFERENCES [dbo].[tGS_FrecuenciaGeneracionCuotas] ([IdFrecuenciaGeneracionCuota])
NOT FOR REPLICATION 
GO

ALTER TABLE [dbo].tGS_Cuotas_V2 CHECK CONSTRAINT [FK_tGS_Cuotas_V2_IdFrecuenciaGeneracionCuota]
GO

ALTER TABLE [dbo].tGS_Cuotas_V2  WITH NOCHECK ADD  CONSTRAINT [FK_tGS_Cuotas_V2_IdMedioPago] FOREIGN KEY([IdMedioPago])
REFERENCES [dbo].[tGN_MediosPagos] ([IdMedioPago])
NOT FOR REPLICATION 
GO

ALTER TABLE [dbo].tGS_Cuotas_V2 CHECK CONSTRAINT [FK_tGS_Cuotas_V2_IdMedioPago]
GO

ALTER TABLE [dbo].tGS_Cuotas_V2  WITH NOCHECK ADD  CONSTRAINT [FK_tGS_Cuotas_V2_IdTipoCuota] FOREIGN KEY([IdTipoCuota])
REFERENCES [dbo].[tCC_TiposDocumentosCCQ] ([IdTipoDocumentoCCQ])
NOT FOR REPLICATION 
GO

ALTER TABLE [dbo].tGS_Cuotas_V2 CHECK CONSTRAINT [FK_tGS_Cuotas_V2_IdTipoCuota]
GO

ALTER TABLE [dbo].tGS_Cuotas_V2  WITH CHECK ADD  CONSTRAINT [FK_tGS_Cuotas_V2_NotasCredito] FOREIGN KEY([IdNotaCredito])
REFERENCES [dbo].[tCC_DescargosCab] ([IdDescargoCab])
GO

ALTER TABLE [dbo].tGS_Cuotas_V2 CHECK CONSTRAINT [FK_tGS_Cuotas_V2_NotasCredito]
GO

ALTER TABLE [dbo].tGS_Cuotas_V2  WITH CHECK ADD  CONSTRAINT [FK_tGS_Cuotas_V2_Periodo] FOREIGN KEY([IdPeriodo])
REFERENCES [dbo].[tCG_PeriodoContable] ([IdPeriodoContable])
GO

ALTER TABLE [dbo].tGS_Cuotas_V2 CHECK CONSTRAINT [FK_tGS_Cuotas_V2_Periodo]
GO

ALTER TABLE [dbo].tGS_Cuotas_V2  WITH CHECK ADD  CONSTRAINT [FK_tGS_Cuotas_V2_tGS_Socios] FOREIGN KEY([IdSocio])
REFERENCES [dbo].[tGS_Socios] ([IdSocio])
GO

ALTER TABLE [dbo].tGS_Cuotas_V2 CHECK CONSTRAINT [FK_tGS_Cuotas_V2_tGS_Socios]
GO

ALTER TABLE [dbo].tGS_Cuotas_V2  WITH CHECK ADD  CONSTRAINT [FK_tGS_Cuotas_V2_Vendedores] FOREIGN KEY([IdVendedor])
REFERENCES [dbo].[tCC_Vendedores] ([IdVendedor])
GO

GO




ALTER TABLE tCC_DescargosDet add IdCuota int
ALTER TABLE tCC_DescargosDet WITH CHECK ADD  CONSTRAINT [FK_tGS_Cuotas_V2_tCC_DescargosDet] FOREIGN KEY([IdCuota])
REFERENCES [dbo].[tGS_Cuotas_V2] ([IdCuota])
GO

-- 



---- UPDATE DE REGISTROS
--update tGS_Socios 
--set ExcluidoParaEmision =  0 -- FALSE, para los socios activos
--where IdEstadoSocio = 1
--go
--update tGS_Socios 
--set ExcluidoParaEmision =  1 -- TRUE, para resto de registros
--where IdEstadoSocio is null




--*/


