use GAE
go

create table dbo.GAE_FirstDiagnosis (
	patid bigint
	, eventdate datetime
	, eventdate_null bit
	, disease varchar(3)
)

insert into dbo.GAE_FirstDiagnosis
select P.patid
	, CPRD.eventdate
	, CPRD.eventdate_null
	, CPRD.disease
from [dbo].[GAE_Patient_Combine] P
	left join (
		select patid, min(eventdate) as eventdate, eventdate_null, disease
		from (
			select C.patid, min(eventdate) as eventdate, eventdate_null, IC.disease
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
		union 
			select H.patid, min(H.discharged) as discharged, 0, IC.disease
			from [dbo].[tblHES_diagnosis_hosp] H
				inner join [dbo].[tlkIdentiferCodelists] IC
					on H.ICD = coalesce(IC.icd10, IC.icd9)
			group by H.patid, IC.disease
		union 
			select D.patid, min(D.dod) as dod, 0, IC.disease
			from [dbo].[tblDeath_patient] D
				inner join [dbo].[tlkIdentiferCodelists] IC
					on D.[cause]   = coalesce(IC.icd10, IC.icd9)
					or D.[cause1]  = coalesce(IC.icd10, IC.icd9)
					or D.[cause2]  = coalesce(IC.icd10, IC.icd9)
					or D.[cause3]  = coalesce(IC.icd10, IC.icd9)
					or D.[cause4]  = coalesce(IC.icd10, IC.icd9)
					or D.[cause5]  = coalesce(IC.icd10, IC.icd9)
					or D.[cause6]  = coalesce(IC.icd10, IC.icd9)
					or D.[cause7]  = coalesce(IC.icd10, IC.icd9)
					or D.[cause8]  = coalesce(IC.icd10, IC.icd9)
					or D.[cause9]  = coalesce(IC.icd10, IC.icd9)
					or D.[cause10] = coalesce(IC.icd10, IC.icd9)
					or D.[cause11] = coalesce(IC.icd10, IC.icd9)
					or D.[cause12] = coalesce(IC.icd10, IC.icd9)
					or D.[cause13] = coalesce(IC.icd10, IC.icd9)
					or D.[cause14] = coalesce(IC.icd10, IC.icd9)
					or D.[cause15] = coalesce(IC.icd10, IC.icd9)
			group by D.patid, IC.disease
		) a
		group by patid, eventdate_null, disease
	) CPRD
	on P.patid = CPRD.patid







--select * 
--from #t t
--	full outer join [dbo].[tblPatient] P
--		on t.patid = P.patid
--where P.patid is null
--order by t.patid

