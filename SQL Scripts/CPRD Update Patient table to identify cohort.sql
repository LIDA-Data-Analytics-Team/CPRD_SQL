USE [GAE]
GO

-- use Define tables to determine which cohort(s) patients were captured by
declare @t as table (patid bigint, Cohort varchar(12))

insert into @t
select PAT.patid
	, rtrim (case when isnull (GCA.patid, '') <> ''
			then 'GCA ' else '' end
		+ case when isnull (PMR.patid, '') <> ''
			then 'PMR ' else '' end 
		+ case when isnull (ADR.patid, '') <> ''
			then 'ADR ' else '' end 
		+ case when isnull (IBD.patid, '') <> ''
			then 'IBD ' else '' end 
		+ case when isnull (RA.patid, '') <> ''
			then 'RA ' else '' end 
		+ case when isnull (SLE.patid, '') <> ''
			then 'SLE ' else '' end 
		+ case when isnull (VAS.patid, '') <> ''
			then 'VAS ' else '' end )
		as Cohort
from [dbo].[tblPatient] PAT
	left join [dbo].[tblDefineResultsGCA] GCA
		on pat.patid = GCA.patid
	left join [dbo].[tblDefineResultsPMR] PMR
		on pat.patid = PMR.patid
	left join [dbo].[tblDefineResultsAdreno] ADR
		on pat.patid = ADR.patid
	left join [dbo].[tblDefineResultsIBD] IBD
		on pat.patid = IBD.patid
	left join [dbo].[tblDefineResultsRA] RA
		on pat.patid = RA.patid
	left join [dbo].[tblDefineResultsSLE] SLE
		on pat.patid = SLE.patid
	left join [dbo].[tblDefineResultsVasculitis] VAS
		on pat.patid = VAS.patid

-- add a new column to Patient table if it doesn't already exist
if col_length ('dbo.tblPatient', 'Cohort') is null
begin
	alter table [dbo].[tblPatient]
	add Cohort varchar(40)
end

-- update Patient table to state which cohort(s) the patient was pulled from
update [dbo].[tblPatient]
set Cohort = t.Cohort
from @t t
where [dbo].[tblPatient].patid = t.patid
