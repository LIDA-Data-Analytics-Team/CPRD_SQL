use GAE
go

select 
	 adr.adsup 
	, adr.adcris
	, adr.cushing
	, count (distinct P.[patid]) as [CPRD patient count]
	, SUM(case when Link.[hes_e] = 1 then 1 else 0 end) as [HES linked]
	, SUM(case when Link.[death_e] = 1 then 1 else 0 end) as [ONS linked]

from [dbo].[tlkAdrenal_disease_read2] adr
	inner join (
		select distinct patid, medcode
		from [dbo].[tblClinical]
		) Cl
		on adr.medcode = CL.medcode
	full outer join [dbo].[tblPatient] P
		on Cl.patid = P.patid
	left join [dbo].[tlkLinkageEligibility] Link
		on P.patid = Link.patid

where P.Cohort like '%ADR%'
 
group by 
	 adr.adsup 
	, adr.adcris
	, adr.cushing
