USE [GAE]
GO

--alter proc dbo.spExtractDMARDbiologic 
--as

select P.patid
	, case when Drg.dmard is not null then cast (Th.eventdate as date) end as dmard
	, case when Drg.biologic is not null then cast (Th.eventdate as date) end as biologic

from [dbo].[tblPatient] P
	inner join [dbo].[tblTherapy] Th
		on P.patid = Th.patid

	inner join (
		select *
		from [dbo].[tlkLinkageEligibility]
		where hes_e = 1 and death_e = 1 and lsoa_e = 1
		) Eligibility
		on P.patid = Eligibility.patid
	
	inner join (
		select *
		from [dbo].[tlkDrugs] 
		where dmard is not null or biologic is not null
		)Drg
		on Th.prodcode = Drg.prodcode

where P.Cohort like '%PMR%' or Cohort like '%GCA%'

order by P.patid, Th.eventdate