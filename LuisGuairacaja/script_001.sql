/*
ID: 3
DESCRIPCION: Corregir la cuenta de los detalles que tienen empresa diferente a la del plan de cuentas, el indicador de la empresa real es el de la cabecera (Query de comprobación adjunto)
FECHA: 17/oct/2022
*/

DECLARE @maxContador INT
DECLARE @codigo INT

DECLARE @IdAsientoContableDet int
DECLARE @IdEmpresaCorrecta int
DECLARE @IdPlanCuentas int
DECLARE @IdPlanCuentasEmpresaCorrecto int

DECLARE @tblTemporal TABLE (
	id INT IDENTITY(1, 1) NOT NULL PRIMARY KEY
	, IdAsientoContableDet int
	, IdEmpresaCorrecta int
	, IdPlanCuentas int
	);

WITH detalle (IdEmpresaCAB, IdAsientoContableCab, IdPlanCuentasEmpresa, IdEmpresaDET, IdAsientoContableDet)
as
(
select cab.IdEmpresa as IdEmpresaCAB, det.IdAsientoContableCab, det.IdPlanCuentasEmpresa, det.IdEmpresa as IdEmpresaDET, det.IdAsientoContableDet as IdAsientoContableDet
from tCG_AsientosContableDet det 
join tCG_AsientosContableCab cab on det.IdAsientoContableCab = cab.IdAsientoContableCab and det.IdEmpresa = cab.IdEmpresa
)

INSERT INTO @tblTemporal
select detalle.IdAsientoContableDet, detalle.IdEmpresaCAB, pce.IdPlanCuentas
from detalle
join tCG_PlanCuentasEmpresa pce on detalle.IdPlanCuentasEmpresa = pce.IdPlanCuentasEmpresa 
where detalle.IdEmpresaCAB <> pce.IdEmpresa

SELECT @maxContador = @@ROWCOUNT
IF (@maxContador > 0)
BEGIN
	SELECT @codigo = 1;
	WHILE (@codigo <= @maxContador)
	BEGIN
		SELECT @IdAsientoContableDet = IdAsientoContableDet
		,@IdPlanCuentasEmpresaCorrecto = pce.IdPlanCuentasEmpresa
		from @tblTemporal tmp
		inner join tCG_PlanCuentasEmpresa pce on tmp.IdPlanCuentas = pce.IdPlanCuentas and tmp.IdEmpresaCorrecta = pce.IdEmpresa
		where id = @codigo

		update tCG_AsientosContableDet
		set IdPlanCuentasEmpresa = @IdPlanCuentasEmpresaCorrecto
		where IdAsientoContableDet = @IdAsientoContableDet

		print '-----------------------------' 
	SET @codigo = @codigo + 1;-- iteracion del contador          
	END
END


GO
GO
GO
/*
ID: 5
DESCRIPCION: Corregir que el periodo contable del mayor le pertenezca a la misma empresa (Query de comprobación adjunto)
FECHA: 17/oct/2022
*/

use ccq_desa
go

DECLARE @maxContador INT
DECLARE @codigo INT

DECLARE @IdSaldoMayor int
DECLARE @IdPlanCuentasEmpresa int
DECLARE @IdEmpresaCorrecta int
DECLARE @IdPeriodoContableIncorrecto int
DECLARE @Anio int
DECLARE @Mes int
DECLARE @IdPeriodoContableCorrecto int

DECLARE @tblTemporal TABLE (
	  id INT IDENTITY(1, 1) NOT NULL PRIMARY KEY
	, IdSaldoMayor int
	, IdPlanCuentasEmpresa int
	, IdEmpresaCorrecta int
	, IdPeriodoContableIncorrecto int
	);
insert into @tblTemporal
select sm.IdSaldoMayor, sm.IdPlanCuentasEmpresa, sm.IdEmpresa as IdEmpresaCorrecta, pc.IdPeriodoContable as IdPeriodoContableIncorrecto
from tCG_SaldoMayor sm
join tCG_PeriodoContable pc on sm.IdPeriodoContable= pc.IdPeriodoContable
join tCG_PlanCuentasEmpresa pce ON sm.IdPlanCuentasEmpresa = pce.IdPlanCuentasEmpresa AND pce.NivelCuenta = 4
JOIN tCG_PlanCuentas pcue ON pce.IdPlanCuentas = pcue.IdPlanCuentas
where sm.IdEmpresa <> pc.IdEmpresa
AND pc.Anio >= 2018

SELECT @maxContador = @@ROWCOUNT
IF (@maxContador > 0)
BEGIN
	SELECT @codigo = 1;
	WHILE (@codigo <= @maxContador)
	BEGIN

		print 'Procesando el id: ' + convert(varchar, @codigo)

		SELECT @IdSaldoMayor = IdSaldoMayor
		,@IdPlanCuentasEmpresa = IdPlanCuentasEmpresa
		,@IdEmpresaCorrecta = IdEmpresaCorrecta
		,@IdPeriodoContableIncorrecto = IdPeriodoContableIncorrecto
		from @tblTemporal tmp
		where id = @codigo

		select @Anio = Anio , @Mes = Mes
		from tCG_PeriodoContable
		where IdPeriodoContable = @IdPeriodoContableIncorrecto

		select @IdPeriodoContableCorrecto = IdPeriodoContable 
		from tCG_PeriodoContable
		where IdEmpresa = @IdEmpresaCorrecta and Anio = @Anio and Mes = @Mes

		if exists (
		select top 1 * from tCG_SaldoMayor
		where IdEmpresa = @IdEmpresaCorrecta 
		and IdPlanCuentasEmpresa = @IdPlanCuentasEmpresa
		and IdPeriodoContable = @IdPeriodoContableCorrecto
		)
		BEGIN 
			PRINT 'EXISTE UN REGISTRO PARA LA EMPREA, PLAN DE CUENTAS, Y PERIODO CONTABLE A REDEFINIR'
			PRINT 'ELIMINANDO EL REGISTRO @IdSaldoMayor: ' + convert(varchar,@IdSaldoMayor)
			
			DELETE FROM tCG_SaldoMayor
			where IdSaldoMayor = @IdSaldoMayor
		END
		ELSE
		BEGIN
			update tCG_SaldoMayor
			set IdPeriodoContable = @IdPeriodoContableCorrecto
			where IdSaldoMayor = @IdSaldoMayor
		END

		print '-----------------------------' 
	SET @codigo = @codigo + 1;-- iteracion del contador          
	END
END


GO
GO
GO
/*
ID: 4
DESCRIPCION: Verificar que si borro el 3er y 2do nivel del mayor contable los reportes funcionan y arrojan valores correctos, si la verificación es favorable generar delete del 2do y 3er nivel, si no lo es generar script de borrado del 2do nivel
FECHA: 17/oct/2022
*/

-- Registros del saldo mayor que tienen cuentas de nivel  2 y 3
select sm.*
from tCG_SaldoMayor sm
inner join tCG_PlanCuentasEmpresa pce on sm.IdEmpresa = pce.IdEmpresa and sm.IdPlanCuentasEmpresa = pce.IdPlanCuentasEmpresa
where pce.NivelCuenta in (2,3)

-- al verificar que existen en valores cero, no afectarán a los reportes, se proceden a eliminarlos
delete tCG_SaldoMayor
where IdSaldoMayor in (
select sm.IdSaldoMayor
from tCG_SaldoMayor sm
inner join tCG_PlanCuentasEmpresa pce on sm.IdEmpresa = pce.IdEmpresa and sm.IdPlanCuentasEmpresa = pce.IdPlanCuentasEmpresa
where pce.NivelCuenta in (2,3)
)








