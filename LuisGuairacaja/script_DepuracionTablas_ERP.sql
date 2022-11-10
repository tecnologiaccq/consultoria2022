-- Se eliminan las tablas [dbo].[tFT_FacturaCab]
DROP TABLE [dbo].[backup_tNM_HistorialVacaciones_04_sep_2021]
DROP TABLE [dbo].[tAccesoEdificio_Registrados]
DROP TABLE [dbo].[tAccesoEdificio_Ubicaciones]
DROP TABLE [dbo].[tbl_TemporalReporteBalance]

DROP TABLE [dbo].[SCH_CIIU]
DROP TABLE [dbo].[SCH_ClasificacionEmpresa]
DROP TABLE [dbo].[SCH_Encuestas]
DROP TABLE [dbo].[SCH_NumeroEmpleados]

DROP TABLE [dbo].[AF]
DROP TABLE [dbo].[tempo_CAEP]
DROP TABLE [dbo].[tempo_ColaboradoresTipoSangre]
DROP TABLE [dbo].[tempo_CorreosEliminarERP]
DROP TABLE [dbo].[tempo_CruceDocumentosParaReporte]
DROP TABLE [dbo].[tempo_delete_motorizados]
DROP TABLE [dbo].[tempo_EliminarCorreosERP]
DROP TABLE [dbo].[tempo_fix_SuscripcionContacto_final]
DROP TABLE [dbo].[tempo_NombresApellidosCurrent]
DROP TABLE [dbo].[tempo_tGN_ContactoPersona_fix]
DROP TABLE [dbo].[tempo_tGS_SuscripcionContacto_Fix]
DROP TABLE [dbo].[tempo_UDLA]
DROP TABLE [dbo].[tempoDistribucionCriterios]
DROP TABLE [dbo].[tempoEmpresasEnSuperCias]
DROP TABLE [dbo].[tempoEmpresasEventoRebecaM]
DROP TABLE [dbo].[tempoSociosAntesEmisionMarzoAbril_2022]
DROP TABLE [dbo].[tempoSociosSuspensosAntesEmisionEneFeb_2022]

DROP TABLE [dbo].[tmp_ArregloCargosCabCruce]
DROP TABLE [dbo].[tmp_ArregloDescargosCabCruce]
DROP TABLE [dbo].[tmp_AsignacionCartera]
DROP TABLE [dbo].[tmp_CargarPresupuesto]

DROP TABLE [dbo].[tempoSociosActivos]
DROP TABLE[dbo].[tempoInventarioVacacionesERP]
DROP TABLE [dbo].[TempoCuotas]
DROP TABLE [dbo].[tempoIdsBancosProveedores]

DROP TABLE [dbo].[tGS_TemporalDirecciones]

-- -----------------------------------------------------------------------
DROP TABLE [dbo].[tAM_FechasMediacion]
DROP TABLE [dbo].[tAM_Liquidaciones]
DROP TABLE [dbo].[tAM_Parametros]
DROP TABLE [dbo].[tAM_TribunalesArbitrajeDet]
DROP TABLE [dbo].[tAM_CargosFuncionarios]
DROP TABLE [dbo].[tAM_AnexoCasosArbitraje]
DROP TABLE [dbo].[tAM_ActividadesMonitor]
DROP TABLE [dbo].[tAM_Monitoreo]
DROP TABLE [dbo].[tAM_UnidadTiempo]
DROP TABLE [dbo].[tAM_CasosMediacionAnexo]
DROP TABLE [dbo].[tAM_AnexoCasosMediacion]
DROP TABLE [dbo].[tAM_Actas]
DROP TABLE [dbo].[tAM_CasosMediadores]
DROP TABLE [dbo].[tAM_OrdenesPagoDet]
DROP TABLE [dbo].[tAM_CasosArbitrajeAnexo]
DROP TABLE [dbo].[tAM_Audiencias]
DROP TABLE [dbo].[tAM_Casos]

ALTER TABLE [dbo].[tAM_CasosArbitraje] DROP CONSTRAINT [DF__tAM_Casos__Cread__59FD8BDC];
  ALTER TABLE [dbo].[tAM_CasosArbitraje] DROP CONSTRAINT [DF__tAM_Casos__Fecha__5AF1B015];
  ALTER TABLE [dbo].[tAM_CasosArbitraje] DROP CONSTRAINT [DF__tAM_Casos__Estac__5BE5D44E];
  ALTER TABLE [dbo].[tAM_CasosArbitraje] DROP CONSTRAINT [DF__tAM_Casos__Modif__5CD9F887];
  ALTER TABLE [dbo].[tAM_CasosArbitraje] DROP CONSTRAINT [DF__tAM_Casos__Ultim__5DCE1CC0];
  ALTER TABLE [dbo].[tAM_CasosArbitraje] DROP CONSTRAINT [DF__tAM_Casos__Estac__5EC240F9];
  ALTER TABLE [dbo].[tAM_CasosMediacion] DROP CONSTRAINT [DF__tmp_ms_xx__Solic__6ED64B2C];
  ALTER TABLE [dbo].[tAM_CasosMediacion] DROP CONSTRAINT [DF__tmp_ms_xx__IdSit__6FCA6F65];
  ALTER TABLE [dbo].[tAM_CasosMediacion] DROP CONSTRAINT [DF__tmp_ms_xx__IdArb__70BE939E];
  ALTER TABLE [dbo].[tAM_CasosMediacion] DROP CONSTRAINT [DF__tmp_ms_xx__Cread__71B2B7D7];
  ALTER TABLE [dbo].[tAM_CasosMediacion] DROP CONSTRAINT [DF__tmp_ms_xx__Fecha__72A6DC10];
  ALTER TABLE [dbo].[tAM_CasosMediacion] DROP CONSTRAINT [DF__tmp_ms_xx__Estac__739B0049];
  ALTER TABLE [dbo].[tAM_CasosMediacion] DROP CONSTRAINT [DF__tmp_ms_xx__Modif__748F2482];
  ALTER TABLE [dbo].[tAM_Mediadores] DROP CONSTRAINT [DF__tAM_Media__Cread__59BB32B5];
  ALTER TABLE [dbo].[tAM_Mediadores] DROP CONSTRAINT [DF__tAM_Media__Fecha__5AAF56EE];
  ALTER TABLE [dbo].[tAM_Mediadores] DROP CONSTRAINT [DF__tAM_Media__Estac__5BA37B27];
  ALTER TABLE [dbo].[tAM_Mediadores] DROP CONSTRAINT [DF__tAM_Media__Modif__5C979F60];
  ALTER TABLE [dbo].[tAM_Mediadores] DROP CONSTRAINT [DF__tAM_Media__Ultim__5D8BC399];
  ALTER TABLE [dbo].[tAM_Mediadores] DROP CONSTRAINT [DF__tAM_Media__Estac__5E7FE7D2];
  ALTER TABLE [dbo].[tAM_CasosMediacion] DROP CONSTRAINT [DF__tmp_ms_xx__Estac__76776CF4];
  ALTER TABLE [dbo].[tAM_CasosMediacion] DROP CONSTRAINT [DF__tmp_ms_xx__Ultim__758348BB];
  ALTER TABLE [dbo].[tAM_OrdenesPago] DROP CONSTRAINT [DF__tAM_Orden__IdSit__71D5156D];
  ALTER TABLE [dbo].[tAM_OrdenesPago] DROP CONSTRAINT [DF__tAM_Orden__Fecha__72C939A6];
  ALTER TABLE [dbo].[tAM_OrdenesPago] DROP CONSTRAINT [DF__tAM_Orden__Cread__73BD5DDF];
  ALTER TABLE [dbo].[tAM_OrdenesPago] DROP CONSTRAINT [DF__tAM_Orden__Fecha__74B18218];
  ALTER TABLE [dbo].[tAM_OrdenesPago] DROP CONSTRAINT [DF__tAM_Orden__Estac__75A5A651];
  ALTER TABLE [dbo].[tAM_OrdenesPago] DROP CONSTRAINT [DF__tAM_Orden__Modif__7699CA8A];
  ALTER TABLE [dbo].[tAM_OrdenesPago] DROP CONSTRAINT [DF__tAM_Orden__Ultim__778DEEC3];
  ALTER TABLE [dbo].[tAM_OrdenesPago] DROP CONSTRAINT [DF__tAM_Orden__Estac__788212FC];
  ALTER TABLE [dbo].[tAM_Secretarios] DROP CONSTRAINT [DF__tAM_Secre__Activ__04C58C4B];
  ALTER TABLE [dbo].[tAM_Secretarios] DROP CONSTRAINT [DF__tAM_Secre__Cread__05B9B084];
  ALTER TABLE [dbo].[tAM_Secretarios] DROP CONSTRAINT [DF__tAM_Secre__Fecha__06ADD4BD];
  ALTER TABLE [dbo].[tAM_Secretarios] DROP CONSTRAINT [DF__tAM_Secre__Estac__07A1F8F6];
  ALTER TABLE [dbo].[tAM_Secretarios] DROP CONSTRAINT [DF__tAM_Secre__Modif__08961D2F];
  ALTER TABLE [dbo].[tAM_Secretarios] DROP CONSTRAINT [DF__tAM_Secre__Ultim__098A4168];
  ALTER TABLE [dbo].[tAM_Secretarios] DROP CONSTRAINT [DF__tAM_Secre__Estac__0A7E65A1];
  ALTER TABLE [dbo].[tAM_Situaciones] DROP CONSTRAINT [DF__tmp_ms_xx__Cread__021E29CA];
  ALTER TABLE [dbo].[tAM_Situaciones] DROP CONSTRAINT [DF__tmp_ms_xx__Fecha__03124E03];
  ALTER TABLE [dbo].[tAM_Situaciones] DROP CONSTRAINT [DF__tmp_ms_xx__Estac__0406723C];
  ALTER TABLE [dbo].[tAM_Situaciones] DROP CONSTRAINT [DF__tmp_ms_xx__Modif__04FA9675];
  ALTER TABLE [dbo].[tAM_Situaciones] DROP CONSTRAINT [DF__tmp_ms_xx__Ultim__05EEBAAE];
  ALTER TABLE [dbo].[tAM_Situaciones] DROP CONSTRAINT [DF__tmp_ms_xx__Estac__06E2DEE7];
  ALTER TABLE [dbo].[tAM_TiposActas] DROP CONSTRAINT [DF__tAM_Tipos__Cread__34A9A997];
  ALTER TABLE [dbo].[tAM_TiposActas] DROP CONSTRAINT [DF__tAM_Tipos__Fecha__359DCDD0];

   ALTER TABLE [dbo].[tAM_TribunalesArbitraje] DROP CONSTRAINT [DF__tAM_Tribu__Cread__07C4568C];
  ALTER TABLE [dbo].[tAM_TribunalesArbitraje] DROP CONSTRAINT [DF__tAM_Tribu__Fecha__08B87AC5];
  ALTER TABLE [dbo].[tAM_TribunalesArbitraje] DROP CONSTRAINT [DF__tAM_Tribu__Estac__09AC9EFE];
  ALTER TABLE [dbo].[tAM_TribunalesArbitraje] DROP CONSTRAINT [DF__tAM_Tribu__Modif__0AA0C337];
  ALTER TABLE [dbo].[tAM_TribunalesArbitraje] DROP CONSTRAINT [DF__tAM_Tribu__Ultim__0B94E770];
  ALTER TABLE [dbo].[tAM_TribunalesArbitraje] DROP CONSTRAINT [DF__tAM_Tribu__Estac__0C890BA9];
  ALTER TABLE [dbo].[tAM_TiposActas] DROP CONSTRAINT [DF__tAM_Tipos__Estac__3691F209];
  ALTER TABLE [dbo].[tAM_TiposActas] DROP CONSTRAINT [DF__tAM_Tipos__Modif__37861642];
  ALTER TABLE [dbo].[tAM_TiposActas] DROP CONSTRAINT [DF__tAM_Tipos__Ultim__387A3A7B];
  ALTER TABLE [dbo].[tAM_TiposActas] DROP CONSTRAINT [DF__tAM_Tipos__Estac__396E5EB4];
  ALTER TABLE [dbo].[tAM_TribunalesArbitraje] DROP CONSTRAINT [FK_tAM_TribunalesArbitraje_CasosArbitraje];
  ALTER TABLE [dbo].[tAM_CasosArbitraje] DROP CONSTRAINT [FK_tAM_CasosArbitraje_IdEmpresa];
  ALTER TABLE [dbo].[tAM_CasosArbitraje] DROP CONSTRAINT [FK_tAM_CasosArbitraje_IdSecretarios];
  ALTER TABLE [dbo].[tAM_CasosArbitraje] DROP CONSTRAINT [FK_tAM_CasosArbitraje_IdSituacion];
  ALTER TABLE [dbo].[tAM_CasosArbitraje] DROP CONSTRAINT [FK_tAM_CasosArbitraje_TipoIdActor];
  ALTER TABLE [dbo].[tAM_CasosArbitraje] DROP CONSTRAINT [FK_tAM_CasosArbitraje_TipoIdDemandado];
  ALTER TABLE [dbo].[tAM_CasosArbitraje] DROP CONSTRAINT [FK_tAM_CasosArbitraje_Tribunal];
  ALTER TABLE [dbo].[tAM_Asistentes] DROP CONSTRAINT [FK_tAM_Asistentes_TipoIdAsistente];
  ALTER TABLE [dbo].[tAM_CasosArbitraje] DROP CONSTRAINT [FK_tAM_CasosArbitraje_IdOrdenPago];
  ALTER TABLE [dbo].[tAM_CasosArbitraje] DROP CONSTRAINT [FK_tAM_CasosArbitraje_IdOrdenPagoReconvencion];
  ALTER TABLE [dbo].[tAM_CasosMediacion] DROP CONSTRAINT [FK_tAM_CasosMediacion_IdEmpresa];
  ALTER TABLE [dbo].[tAM_CasosMediacion] DROP CONSTRAINT [FK_tAM_CasosMediacion_IdAsistente];
  ALTER TABLE [dbo].[tAM_CasosMediacion] DROP CONSTRAINT [FK_tAM_CasosMediacion_IdMediadores];
  ALTER TABLE [dbo].[tAM_CasosMediacion] DROP CONSTRAINT [FK_tAM_CasosMediacion_IdSituacion];
  ALTER TABLE [dbo].[tAM_CasosMediacion] DROP CONSTRAINT [FK_tAM_CasosMediacion_TipoIdDemandado];
  ALTER TABLE [dbo].[tAM_CasosMediacion] DROP CONSTRAINT [FK_tAM_CasosMediacion_TipoIdSolicitante];
  ALTER TABLE [dbo].[tAM_CasosMediacion] DROP CONSTRAINT [FK_tAM_CasosMediacion_IdCasoArbitraje];
  ALTER TABLE [dbo].[tAM_CasosMediacion] DROP CONSTRAINT [FK_tAM_CasosMediacion_IdOrdenPagoInicial];
  ALTER TABLE [dbo].[tAM_CasosMediacion] DROP CONSTRAINT [FK_tAM_CasosMediacion_IdOrdenPagoFinal];
  ALTER TABLE [dbo].[tAM_CasosMediacion] DROP CONSTRAINT [FK_tAM_CasosMediacion_IdTipoActa];
  ALTER TABLE [dbo].[tAM_Mediadores] DROP CONSTRAINT [FK_tAM_Mediadores_TipoIdMediador];
  ALTER TABLE [dbo].[tAM_Mediadores] DROP CONSTRAINT [FK_tAM_Mediadores_TiposId];
  ALTER TABLE [dbo].[tAM_OrdenesPago] DROP CONSTRAINT [FK_tAM_OrdenesPago_IdCasosArbitraje];
  ALTER TABLE [dbo].[tAM_OrdenesPago] DROP CONSTRAINT [FK_tAM_OrdenesPago_IdCasosMediacion];
  ALTER TABLE [dbo].[tAM_OrdenesPago] DROP CONSTRAINT [FK_tAM_OrdenesPago_IdSituacion];
  ALTER TABLE [dbo].[tAM_Secretarios] DROP CONSTRAINT [FK_tAM_Secretarios_TiposId];
  ALTER TABLE [dbo].[tAM_Secretarios] DROP CONSTRAINT [FK_tAM_Secretarios_TipoIdSecretario];
  ALTER TABLE [dbo].[tAM_Secretarios] DROP CONSTRAINT [PK_Secretarios];
  ALTER TABLE [dbo].[tAM_Situaciones] DROP CONSTRAINT [PK_Situacioness];
  ALTER TABLE [dbo].[tAM_Mediadores] DROP CONSTRAINT [PK_Mediadores];
  ALTER TABLE [dbo].[tAM_OrdenesPago] DROP CONSTRAINT [PK_tAM_OrdenesPago];
  ALTER TABLE [dbo].[tAM_CasosMediacion] DROP CONSTRAINT [PK_tAM_CasosMediacion];

  ALTER TABLE [dbo].[tAM_CasosArbitraje] DROP CONSTRAINT [PK_tAM_CasosArbitraje];
  ALTER TABLE [dbo].[tAM_Asistentes] DROP CONSTRAINT [PK_tAM_Asistentes];
  ALTER TABLE [dbo].[tAM_TribunalesArbitraje] DROP CONSTRAINT [PK__tAM_Trib__9D1B5B3D44CF519B];
  DROP TABLE [dbo].[tAM_Asistentes]
DROP TABLE [dbo].[tAM_CasosArbitraje]
DROP TABLE [dbo].[tAM_CasosMediacion]
DROP TABLE [dbo].[tAM_Mediadores]
DROP TABLE [dbo].[tAM_OrdenesPago]
DROP TABLE [dbo].[tAM_Secretarios]
DROP TABLE [dbo].[tAM_Situaciones]
DROP TABLE [dbo].[tAM_TribunalesArbitraje]
DROP TABLE [dbo].[tAM_ModelosActas]
DROP TABLE [dbo].[tAM_TiposActas]



