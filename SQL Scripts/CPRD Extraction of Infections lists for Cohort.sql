use GAE
go

select distinct P.Cohort
	, P.patid
	, Cl.eventdate
	, Ent.[description]
	, case when Inf.sepsis is not null then Inf.sepsis end as sepsis
	, case when Inf.sepsis_type is not null then Inf.sepsis_type end as sepsis_type
	, case when Inf.periton is not null then Inf.periton end as periton
	, case when Inf.appendicit is not null then Inf.appendicit end as appendicit
	, case when Inf.osteomyel is not null then Inf.osteomyel end as osteomyel
	, case when Inf.meningit is not null then Inf.meningit end as meningit
	, case when Inf.cellulitis is not null then Inf.cellulitis end as cellulitis
	, case when Inf.cholangitis is not null then Inf.cholangitis end as cholangitis
	, case when Inf.hzoster is not null then Inf.hzoster end as hzoster
	, case when Inf.gasten is not null then Inf.gasten end as gasten
	, case when Inf.abscess is not null then Inf.abscess end as abscess
	, case when Inf.divertic is not null then Inf.divertic end as divertic
	, case when Inf.colitis is not null then Inf.colitis end as colitis
	, case when Inf.diabfoot is not null then Inf.diabfoot end as diabfoot
	, case when Inf.tb is not null then Inf.tb end as tb
	, case when Inf.pneumonia is not null then Inf.pneumonia end as pneumonia
	, case when Inf.mastoiditis is not null then Inf.mastoiditis end as mastoiditis
		
from [dbo].[tblPatient] P
	inner join [dbo].[tblClinical] Cl
		on P.patid = Cl.patid

	inner join CPRD.dbo.tlkEntity Ent
		on Cl.enttype = Ent.enttype

	inner join [dbo].[tlkInfection] Inf
		on Cl.medcode = Inf.medcode

where P.Cohort like '%PMR%' or Cohort like '%GCA%'

order by P.patid, Cl.eventdate
