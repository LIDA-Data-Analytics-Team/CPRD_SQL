
select C.patid, min(eventdate) as eventdate, eventdate_null, IC.disease
into #gold
from (
	select Cl.patid, coalesce(Cl.eventdate, Cl.sysdate) as eventdate, Cl.medcode, case when Cl.eventdate is null then 1 else 0 end as eventdate_null
	from [dbo].[tblClinical] Cl
		union
	select Im.patid, coalesce(Im.eventdate, Im.sysdate) as eventdate, Im.medcode, case when Im.eventdate is null then 1 else 0 end as eventdate_null
	from [dbo].[tblImmunisation] Im
		union
	select Rf.patid, coalesce(Rf.eventdate, Rf.sysdate) as eventdate, Rf.medcode, case when Rf.eventdate is null then 1 else 0 end as eventdate_null
	from [dbo].[tblReferral] Rf
		union
	select Ts.patid, coalesce(Ts.eventdate, Ts.sysdate) as eventdate, Ts.medcode, case when Ts.eventdate is null then 1 else 0 end as eventdate_null
	from [dbo].[tblTest] Ts
	) C
	inner join [dbo].[tlkIdentiferCodelists] IC
		on C.medcode = IC.medcode
group by C.patid, eventdate_null, IC.disease





select *
from (
		select *
		from #gold g
		where disease in ('pmr', 'gca')
	) a
	full outer join (
		select gp.* 
		from [dbo].[tblPatient] P
			inner join [dbo].[GAE_Patient_Combine] gp
				on P.patid = gp.patid
			inner join [dbo].[tlkLinkageEligibility] le
				on p.patid = le.patid
		where (le.hes_e=1 and le.death_e=1 and le.lsoa_e=1 )
			and (PMR=1 or GCA=1)
	) b
	on a.patid = b.patid

where a.patid is null