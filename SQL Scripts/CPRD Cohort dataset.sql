use GAE
go

--alter proc dbo.spExtractCohortDataset
--as

select P.patid												--Patient unique ID
	, SEX.[text] as gender									--Sex
	, P.yob	+ 1800 as birth_year							--Date of birth or age at study entry
	, null as imd											--Index of multiple deprivation (if you have it already)
	, cast (P.crd as date)	as current_registration_date	--Date of registration
	, cast (Pr.uts as date) as uts							--Date of UTS for the practice
															--Date of study entry:
	, cast ((select max(datesColumn)							--latest of 
		from (values (dateadd(m, 12, P.crd))						--1 year since registration,		 
					, (dateadd(m, 12, Pr.uts))						--1 year of UTS follow-up data,
					, (cast((yob+1818) as nvarchar(4)) + '-07-01')	--age 18, 
					, ('1998-01-01')								--date 1st Jan 1998, 
					, (FD.FirstDiagnosis)							--first recorded date of disease diagnosis (PMR or GCA, or the first of the 2 if the 2 diseases are diagnosed)
					) as virtualTable(datesColumn)
		) as date) as study_entry_date
	, rtrim(replace(P.Cohort, 'ADR', '')) as disease		--Disease: PMR, GCA, both
	, cast (FD.FirstDiagnosis as date) as first_diagnosis		--Date of first recorded diagnosis of PMR/GCA
	, cast (LC.latest_contact as date) as latest_contact		--Last date of contact with GP practice
	, cast (P.deathdate as date) as death_date					--Date of death if recorded
	, cast (Pr.lcd as date) as last_collection_date				--Date of administrative censoring of GP practice (last date of data collection in the practice)
	, cast (P.tod as date) as transfer_out_date					--Date of deregistration from GP practice
	, Pr.pracid												--GP practice indicator
	, Pr.region												--Geographical location of GP practice

from [dbo].[tblPatient] P
	left join [CPRD].[dbo].[tlkThreeCharacter] SEX
		on P.gender = (select SEX.code where SEX.reference = 'SEX')
	
	inner join (
		select *
		from [dbo].[tlkLinkageEligibility]
		where hes_e = 1 and death_e = 1 and lsoa_e = 1
		) Eligibility
		on P.patid = Eligibility.patid
	
	left join dbo.tblPractice Pr
		on right (P.patid, 3) = Pr.pracid

	left join (
		select patid, min(indexdate) as FirstDiagnosis
		from
			(
			select * from dbo.tblDefineResultsGCA GCA
				union
			select * from dbo.tblDefineResultsPMR PMR
			)A
		group by patid
		) FD
		on P.patid = FD.patid

	left join (
		select patid
			, max(eventdate) as latest_contact
		from (
			select distinct patid, eventdate as eventdate
			from [dbo].[tblClinical] Cl
				union
			select distinct patid, eventdate as eventdate
			from [dbo].[tblTest] Ts
				union
			select distinct patid, eventdate as eventdate
			from [dbo].[tblConsultation]
				union
			select distinct patid, eventdate as eventdate
			from [dbo].[tblImmunisation]
				union
			select distinct patid, eventdate as eventdate
			from [dbo].[tblReferral]
				union
			select distinct patid, eventdate as eventdate
			from [dbo].[tblTherapy]
			) A
		group by patid
	) LC
	on P.patid = LC.patid

where P.Cohort like '%PMR%' or P.Cohort like '%GCA%'