use GAE
go

--alter proc dbo.spExtractSteroidPrescription
--as

select P.patid
	, cast (Th.eventdate as date) as prescription_date							--prescription date, 
	, CD.text as dose															--dose, 
	, Prod.strength
	, CD.daily_dose 
	, CD.dose_frequency as daily_frequency										--number of times per day,
	, CD.dose_number as amount_per_dose
	, Th.numdays as duration													--duration,
	, Prod.formulation as preparation											--preparation (posology)
	
	, case when Drg.orgc is not null then Drg.orgc end as orgc
	, case when Drg.articgc is not null then Drg.articgc end as articgc
	, case when Drg.imgc is not null then Drg.imgc end as imgc
	, case when Drg.rectgc is not null then Drg.rectgc end as rectgc
	, case when Drg.topgc is not null then Drg.topgc end as topgc
	, case when Drg.inhgc is not null then Drg.inhgc end as inhgc
	, case when Drg.nasgc is not null then Drg.nasgc end as nasgc
	, case when Drg.unkgc is not null then Drg.unkgc end as unkgc

	, Prod.productname as product_name
	, Th.qty as quantity_prescribed
	, Th.issueseq as issue_sequence_number

from [dbo].[tblPatient] P
	inner join [dbo].[tblTherapy] Th
		on P.patid = Th.patid

	inner join (
		select *
		from [dbo].[tlkLinkageEligibility]
		where hes_e = 1 and death_e = 1 and lsoa_e = 1
		) Eligibility
		on P.patid = Eligibility.patid

	left join CPRD.[dbo].[tlkProduct] Prod
		on Th.prodcode = Prod.prodcode
	left join CPRD.dbo.tlkCommonDosage CD
		on Th.textid = cast (CD.textid as varchar(50))

	inner join (
		select *
		from [dbo].[tlkDrugs] 
		where orgc is not null or articgc is not null or imgc is not null or rectgc is not null or topgc is not null or inhgc is not null or nasgc is not null or unkgc is not null
		) Drg
		on Th.prodcode = Drg.prodcode

where P.Cohort like '%PMR%' or Cohort like '%GCA%'

order by P.patid, Th.eventdate