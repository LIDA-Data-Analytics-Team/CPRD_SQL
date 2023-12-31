create table dbo.GAE_FirstDiagnosis (
	patid bigint
	, disease varchar(3)
	, FirstDiagnosis datetime
)

insert into dbo.GAE_FirstDiagnosis
select P.patid
	, case when IC.disease = 'Adrenal supression' then 'ADR'
		when IC.disease = 'Ankylosing spondylitis' then 'ANK'
		when IC.disease = 'Asthma' then 'AST'
		when IC.disease = 'COPD' then 'COP'
		when IC.disease = 'Cushings' then 'CUS'
		when IC.disease = 'Vasculitis' then 'VAS'
		else IC.disease end as disease
	, min (C.eventdate) as FirstDiagnosis

from (
	select patid from [dbo].[tblPatient] 
		union
	select patid from [dbo].[tblHES_patient]
	) P
	inner join [dbo].[tblClinical] C
		on P.patid = C.patid
	inner join [dbo].[tlkIdentiferCodelists] IC
		on C.medcode = IC.medcode

group by P.patid
	, IC.disease