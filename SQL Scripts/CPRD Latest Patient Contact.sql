use GAE
go

select patid
	, max(eventdate ) as LastContact

from (
	select distinct patid
		, eventdate as eventdate
	from [dbo].[tblClinical] Cl
	union
	select distinct patid
		, eventdate as eventdate
	from [dbo].[tblTest] Ts
	union
	select distinct patid
		, eventdate as eventdate
	from [dbo].[tblConsultation]
	union
	select distinct patid
		, eventdate as eventdate
	from [dbo].[tblImmunisation]
	union
	select distinct patid
		, eventdate as eventdate
	from [dbo].[tblReferral]
	union
	select distinct patid
		, eventdate as eventdate
	from [dbo].[tblTherapy]
	) A

group by patid