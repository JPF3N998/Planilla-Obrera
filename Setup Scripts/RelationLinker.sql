/*
   24 November, 20184:49:05 PM
   User: 
   Server: F3N9-ASUS
   Database: PlanillaObrera
   Application: 
*/

/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Administrador SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.Administrador', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.Administrador', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.Administrador', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.TipoMovimiento SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.TipoMovimiento', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.TipoMovimiento', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.TipoMovimiento', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.Eventos ADD CONSTRAINT
	FK_Eventos_Administrador FOREIGN KEY
	(
	idAdmin
	) REFERENCES dbo.Administrador
	(
	id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Eventos ADD CONSTRAINT
	FK_Eventos_TipoMovimiento FOREIGN KEY
	(
	idTipoMovimiento
	) REFERENCES dbo.TipoMovimiento
	(
	id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Eventos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.Eventos', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.Eventos', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.Eventos', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.TipoJornadas SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.TipoJornadas', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.TipoJornadas', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.TipoJornadas', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.TipoDeduccion SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.TipoDeduccion', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.TipoDeduccion', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.TipoDeduccion', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.Puesto SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.Puesto', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.Puesto', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.Puesto', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.SalarioxHora ADD CONSTRAINT
	FK_SalarioxHora_Puesto FOREIGN KEY
	(
	idPuesto
	) REFERENCES dbo.Puesto
	(
	id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.SalarioxHora ADD CONSTRAINT
	FK_SalarioxHora_TipoJornadas FOREIGN KEY
	(
	idTipoJornada
	) REFERENCES dbo.TipoJornadas
	(
	id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.SalarioxHora SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.SalarioxHora', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.SalarioxHora', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.SalarioxHora', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.PlanillaMensual SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.PlanillaMensual', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.PlanillaMensual', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.PlanillaMensual', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.PlanillaSemanal ADD CONSTRAINT
	FK_PlanillaSemanal_PlanillaMensual FOREIGN KEY
	(
	idPlanillaMensual
	) REFERENCES dbo.PlanillaMensual
	(
	id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.PlanillaSemanal SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.PlanillaSemanal', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.PlanillaSemanal', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.PlanillaSemanal', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.Movimiento ADD CONSTRAINT
	FK_Movimiento_TipoMovimiento FOREIGN KEY
	(
	idTipoMovimiento
	) REFERENCES dbo.TipoMovimiento
	(
	id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Movimiento ADD CONSTRAINT
	FK_Movimiento_PlanillaSemanal FOREIGN KEY
	(
	idPlanillaSemanal
	) REFERENCES dbo.PlanillaSemanal
	(
	id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Movimiento SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.Movimiento', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.Movimiento', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.Movimiento', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.Empleado ADD CONSTRAINT
	FK_Empleado_Puesto FOREIGN KEY
	(
	idPuesto
	) REFERENCES dbo.Puesto
	(
	id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Empleado SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.Empleado', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.Empleado', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.Empleado', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.EmpleadosXPlanillaSemanal ADD CONSTRAINT
	FK_EmpleadosXPlanillaSemanal_Empleado FOREIGN KEY
	(
	idEmpleado
	) REFERENCES dbo.Empleado
	(
	id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.EmpleadosXPlanillaSemanal ADD CONSTRAINT
	FK_EmpleadosXPlanillaSemanal_PlanillaSemanal FOREIGN KEY
	(
	idPlanillaSemanal
	) REFERENCES dbo.PlanillaSemanal
	(
	id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.EmpleadosXPlanillaSemanal ADD CONSTRAINT
	FK_EmpleadosXPlanillaSemanal_TipoJornadas FOREIGN KEY
	(
	idTipoJornada
	) REFERENCES dbo.TipoJornadas
	(
	id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.EmpleadosXPlanillaSemanal SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.EmpleadosXPlanillaSemanal', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.EmpleadosXPlanillaSemanal', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.EmpleadosXPlanillaSemanal', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.Deduccion ADD CONSTRAINT
	FK_Deduccion_TipoDeduccion FOREIGN KEY
	(
	idTipoDeduccion
	) REFERENCES dbo.TipoDeduccion
	(
	id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Deduccion ADD CONSTRAINT
	FK_Deduccion_PlanillaSemanal FOREIGN KEY
	(
	idPlanillaSemanal
	) REFERENCES dbo.PlanillaSemanal
	(
	id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Deduccion SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.Deduccion', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.Deduccion', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.Deduccion', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.Cuenta ADD CONSTRAINT
	FK_Cuenta_Empleado FOREIGN KEY
	(
	idEmpleado
	) REFERENCES dbo.Empleado
	(
	id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Cuenta SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.Cuenta', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.Cuenta', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.Cuenta', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.Asistencia ADD CONSTRAINT
	FK_Asistencia_Empleado FOREIGN KEY
	(
	idEmpleado
	) REFERENCES dbo.Empleado
	(
	id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Asistencia SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.Asistencia', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.Asistencia', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.Asistencia', 'Object', 'CONTROL') as Contr_Per 