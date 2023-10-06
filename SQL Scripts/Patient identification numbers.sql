use GAE
go

declare @t1 table (Cohort varchar(3), GoldPatients bigint)
insert into @t1
select A.*
	, COUNT(P.patid) 
from dbo.tblPatient P
	 left join (
		select distinct rtrim(left(Cohort, 3)) as Cohort
		from [dbo].[tblPatient]
	) A
		on P.Cohort like '%' + A.Cohort + '%'
	inner join (
		select * from [dbo].[tlkLinkageEligibility]
		where hes_e = 1 and death_e = 1
	) LE
		on P.patid = LE.patid
group by A.Cohort


declare @t2 table (Cohort varchar(3), LinkedPatients bigint)
insert into @t2
select A.*
	, COUNT(P.patid) 
from (
	select distinct Cohort, patid from [dbo].[tblHES_patient]
	union
	select distinct Cohort, patid from [dbo].[tblDeath_patient]
	union 
	select distinct Cohort, patid from [dbo].[tblPatient_imd2007]
	) P
	 left join (
		select distinct rtrim(left(cohort, 3)) as Cohort
		from [dbo].[tblHES_patient]
	) A
		on P.Cohort like '%' + A.Cohort + '%'
group by A.Cohort


declare @t3 table (Cohort varchar(3), DistinctPatients bigint, SharedPatients bigint)
insert into @t3
select 'ADR' as Cohort
	, COUNT(*) as DistinctPatients
	, sum (case when G.patid is not null and L.patid is not null then 1 else 0 end) as SharedPatients
from 
	(
	select P.patid 
	from [dbo].[tblDefineResultsAdreno] P
		inner join 
		(
			select * from [dbo].[tlkLinkageEligibility]
			where hes_e = 1 and death_e = 1
		) LE
		on P.patid = LE.patid
	) G
	full outer join (select distinct * from dbo.tblDefineHesOnsAdreno) L
		on G.patid = L.patid

insert into @t3
select 'CSH' as Cohort
	, COUNT(*) as DistinctPatients
	, 0 as SharedPatients
from dbo.tblDefineHesOnsCushings L

insert into @t3
select 'GCA' as Cohort
	, COUNT(*) as DistinctPatients
	, sum (case when G.patid is not null and L.patid is not null then 1 else 0 end) as SharedPatients
from 
	(
	select P.patid 
	from [dbo].[tblDefineResultsGCA] P
		inner join 
		(
			select * from [dbo].[tlkLinkageEligibility]
			where hes_e = 1 and death_e = 1
		) LE
		on P.patid = LE.patid
	) G
	full outer join (select distinct * from dbo.tblDefineHesOnsGCA) L
		on G.patid = L.patid

insert into @t3
select 'IBD' as Cohort
	, COUNT(*) as DistinctPatients
	, sum (case when G.patid is not null and L.patid is not null then 1 else 0 end) as SharedPatients
from 
	(
	select P.patid 
	from [dbo].[tblDefineResultsIBD] P
		inner join 
		(
			select * from [dbo].[tlkLinkageEligibility]
			where hes_e = 1 and death_e = 1
		) LE
		on P.patid = LE.patid
	) G
	full outer join (select distinct * from dbo.tblDefineHesOnsIBD) L
		on G.patid = L.patid

insert into @t3
select 'PMR' as Cohort
	, COUNT(*) as DistinctPatients
	, sum (case when G.patid is not null and L.patid is not null then 1 else 0 end) as SharedPatients
from 
	(
	select P.patid 
	from [dbo].[tblDefineResultsPMR] P
		inner join 
		(
			select * from [dbo].[tlkLinkageEligibility]
			where hes_e = 1 and death_e = 1
		) LE
		on P.patid = LE.patid
	) G
	full outer join (select distinct * from dbo.tblDefineHesOnsPMR) L
		on G.patid = L.patid

insert into @t3
select 'RA' as Cohort
	, COUNT(*) as DistinctPatients
	, sum (case when G.patid is not null and L.patid is not null then 1 else 0 end) as SharedPatients
from 
	(
	select P.patid 
	from [dbo].[tblDefineResultsRA] P
		inner join 
		(
			select * from [dbo].[tlkLinkageEligibility]
			where hes_e = 1 and death_e = 1
		) LE
		on P.patid = LE.patid
	) G
	full outer join (select distinct * from dbo.tblDefineHesOnsRA) L
		on G.patid = L.patid

insert into @t3
select 'SLE' as Cohort
	, COUNT(*) as DistinctPatients
	, sum (case when G.patid is not null and L.patid is not null then 1 else 0 end) as SharedPatients
from 
	(
	select P.patid 
	from [dbo].[tblDefineResultsSLE] P
		inner join 
		(
			select * from [dbo].[tlkLinkageEligibility]
			where hes_e = 1 and death_e = 1
		) LE
		on P.patid = LE.patid
	) G
	full outer join (select distinct * from dbo.tblDefineHesOnsSLE) L
		on G.patid = L.patid

insert into @t3
select 'VAS' as Cohort
	, COUNT(*) as DistinctPatients
	, sum (case when G.patid is not null and L.patid is not null then 1 else 0 end) as SharedPatients
from 
	(
	select P.patid 
	from [dbo].[tblDefineResultsVasculitis] P
		inner join 
		(
			select * from [dbo].[tlkLinkageEligibility]
			where hes_e = 1 and death_e = 1
		) LE
		on P.patid = LE.patid
	) G
	full outer join (select distinct * from dbo.tblDefineHesOnsVasculitis) L
		on G.patid = L.patid 


select coalesce (t1.Cohort, t2.Cohort, t3.Cohort) as Cohort
	, t1.GoldPatients
	, t2.LinkedPatients
	, t3.SharedPatients
	, t3.DistinctPatients
	, isnull(t1.GoldPatients + t2.LinkedPatients - t3.SharedPatients - t3.DistinctPatients, 0) as ShouldBeZero
from @t1 t1 
	full outer join @t2 t2 on t1.Cohort = t2.Cohort
	full outer join @t3 t3 on coalesce (t1.Cohort, t2.Cohort) = t3.Cohort
order by Cohort