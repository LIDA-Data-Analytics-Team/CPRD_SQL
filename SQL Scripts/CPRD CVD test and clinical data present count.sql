 ------------------
/*	Test		*/
-----------------
select COUNT(P.patid) as Occurrences
	, TQU.[text] as data1
	, case when cvd.pad_angio is not null then cvd.pad_angio end as pad_angio 
	, case when cvd.pad_us is not null then cvd.pad_us end as pad_us 

from [dbo].[tblPatient] P
	inner join [dbo].[tblTest] T
		on P.patid = T.patid

	left join (select * from CPRD.dbo.tlkThreeCharacter where reference = 'TQU') TQU
		on T.data1 = TQU.code

	inner join CPRD.dbo.tlkEntity Ent
		on T.enttype = Ent.enttype

	inner join [dbo].[tlkCVD_readcode] cvd
		on T.medcode = cvd.medcode

where (P.Cohort like '%PMR%' or P.Cohort like '%GCA%')
	and (pad_angio is not null or pad_us is not null)

group by TQU.[text]
	, case when cvd.pad_angio is not null then cvd.pad_angio end 
	, case when cvd.pad_us is not null then cvd.pad_us end

order by case when cvd.pad_angio is not null then cvd.pad_angio end desc
	, case when cvd.pad_us is not null then cvd.pad_us end desc
	, COUNT(P.patid) desc

 ------------------
/*	Clinical	*/
------------------
select count (P.patid) as Occurrences
	, PRE1.[text] as data1
	, PRE2.[text] as data2
	, case when cvd.pad_angio is not null then cvd.pad_angio end as pad_angio 
	, case when cvd.pad_us is not null then cvd.pad_us end as pad_us 

from [dbo].[tblPatient] P
	inner join [dbo].[tblClinical] Cl
		on P.patid = Cl.patid
	left join dbo.tblAdditional Ad
		on P.patid = Ad.patid
			and Cl.adid = Ad.adid

	left join (select * from CPRD.dbo.tlkThreeCharacter where reference = 'PRE') PRE1
		on Ad.data1 = PRE1.code

	left join (select * from CPRD.dbo.tlkThreeCharacter where reference = 'PRE') PRE2
		on Ad.data2 = PRE2.code

	inner join CPRD.dbo.tlkEntity Ent
		on Cl.enttype = Ent.enttype

	inner join [dbo].[tlkCVD_readcode] cvd
		on Cl.medcode = cvd.medcode

where (P.Cohort like '%PMR%' or P.Cohort like '%GCA%')
	and (pad_angio is not null or pad_us is not null)

group by PRE1.[text] 
	, PRE2.[text] 
	, case when cvd.pad_angio is not null then cvd.pad_angio end 
	, case when cvd.pad_us is not null then cvd.pad_us end 

order by case when cvd.pad_angio is not null then cvd.pad_angio end desc
	, case when cvd.pad_us is not null then cvd.pad_us end  desc
	, count (P.patid) desc
