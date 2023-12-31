USE [GAE]
GO

select distinct Cohort
	, patid
	, min([0: H/O CPRD]				) as [0: H/O CPRD]
	, min([0: H/O HES]				) as [0: H/O HES]
	, min([0: H/O ONS]				) as [0: H/O ONS]
	, min([0: H/O All]				) as [0: H/O All]
	, min([1-Diab 1 CPRD]			) as [1-Diab 1 CPRD]
	, min([1-Diab 1 HES]			) as [1-Diab 1 HES]
	, min([1-Diab 1 ONS]			) as [1-Diab 1 ONS]
	, min([0: H/O All]				) as [1-Diab 1 All]
	, min([-2: F/H CPRD]			) as [-2: F/H CPRD]
	, min([-2: F/H HES]				) as [-2: F/H HES]
	, min([-2: F/H ONS]				) as [-2: F/H ONS]
	, min([-2: F/H All]				) as [-2: F/H All]
	, min([2-Diab 2 CPRD]			) as [2-Diab 2 CPRD]
	, min([2-Diab 2 HES]			) as [2-Diab 2 HES]
	, min([2-Diab 2 ONS]			) as [2-Diab 2 ONS]
	, min([2-Diab 2 All]			) as [2-Diab 2 All]
	, min([3-2ry diab CPRD]			) as [3-2ry diab CPRD]
	, min([3-2ry diab HES]			) as [3-2ry diab HES]
	, min([3-2ry diab ONS]			) as [3-2ry diab ONS]
	, min([3-2ry diab All]			) as [3-2ry diab All]
	, min([4-Diab unspec CPRD]		) as [4-Diab unspec CPRD]
	, min([4-Diab unspec HES]		) as [4-Diab unspec HES]
	, min([4-Diab unspec ONS]		) as [4-Diab unspec ONS]
	, min([4-Diab unspec All]		) as [4-Diab unspec All]
	, min([5-Gestation CPRD]		) as [5-Gestation CPRD]
	, min([5-Gestation HES]			) as [5-Gestation HES]
	, min([5-Gestation ONS]			) as [5-Gestation ONS]
	, min([5-Gestation All]			) as [5-Gestation All]
	, min([6-Steroid related CPRD]	) as [6-Steroid related CPRD]
	, min([6-Steroid related HES]	) as [6-Steroid related HES]
	, min([6-Steroid related ONS]	) as [6-Steroid related ONS]
	, min([6-Steroid related All]	) as [6-Steroid related All]
from (
	select distinct P.Cohort
		, P.patid
	
		, case when CPRD.diabetes =	'0: H/O'			then CPRD.minEventDate		else null end as [0: H/O CPRD]
		, case when HES.diabetes =	'0: H/O'			then HES.minDischargeDate	else null end as [0: H/O HES]
		, case when ONS.diabetes =	'0: H/O'			then ONS.dod				else null end as [0: H/O ONS]
		, case when [All].diabetes ='0: H/O'			then [All].minEventDate		else null end as [0: H/O All]
	
		, case when CPRD.diabetes =	'1-Diab 1'			then CPRD.minEventDate		else null end as [1-Diab 1 CPRD]
		, case when HES.diabetes =	'1-Diab 1'			then HES.minDischargeDate	else null end as [1-Diab 1 HES]
		, case when ONS.diabetes =	'1-Diab 1'			then ONS.dod				else null end as [1-Diab 1 ONS]
		, case when [All].diabetes ='1-Diab 1'			then [All].minEventDate		else null end as [1-Diab 1 All]

		, case when CPRD.diabetes =	'-2: F/H'			then CPRD.minEventDate		else null end as [-2: F/H CPRD]
		, case when HES.diabetes =	'-2: F/H'			then HES.minDischargeDate	else null end as [-2: F/H HES]
		, case when ONS.diabetes =	'-2: F/H'			then ONS.dod				else null end as [-2: F/H ONS]
		, case when [All].diabetes ='-2: F/H'			then [All].minEventDate		else null end as [-2: F/H All]

		, case when CPRD.diabetes =	'2-Diab 2'			then CPRD.minEventDate		else null end as [2-Diab 2 CPRD]
		, case when HES.diabetes =	'2-Diab 2'			then HES.minDischargeDate	else null end as [2-Diab 2 HES]
		, case when ONS.diabetes =	'2-Diab 2'			then ONS.dod				else null end as [2-Diab 2 ONS]
		, case when [All].diabetes ='2-Diab 2'			then [All].minEventDate		else null end as [2-Diab 2 All]
	
		, case when CPRD.diabetes =	'3-2ry diab'		then CPRD.minEventDate		else null end as [3-2ry diab CPRD]
		, case when HES.diabetes =	'3-2ry diab'		then HES.minDischargeDate	else null end as [3-2ry diab HES]
		, case when ONS.diabetes =	'3-2ry diab'		then ONS.dod				else null end as [3-2ry diab ONS]
		, case when [All].diabetes ='3-2ry diab'		then [All].minEventDate		else null end as [3-2ry diab All]

		, case when CPRD.diabetes =	'4-Diab unspec'		then CPRD.minEventDate		else null end as [4-Diab unspec CPRD]
		, case when HES.diabetes =	'4-Diab unspec'		then HES.minDischargeDate	else null end as [4-Diab unspec HES]
		, case when ONS.diabetes =	'4-Diab unspec'		then ONS.dod				else null end as [4-Diab unspec ONS]
		, case when [All].diabetes ='4-Diab unspec'		then [All].minEventDate		else null end as [4-Diab unspec All]

		, case when CPRD.diabetes =	'5-Gestation'		then CPRD.minEventDate		else null end as [5-Gestation CPRD]
		, case when HES.diabetes =	'5-Gestation'		then HES.minDischargeDate	else null end as [5-Gestation HES]
		, case when ONS.diabetes =	'5-Gestation'		then ONS.dod				else null end as [5-Gestation ONS]
		, case when [All].diabetes ='5-Gestation'		then [All].minEventDate		else null end as [5-Gestation All]

		, case when CPRD.diabetes =	'6-Steroid related'	then CPRD.minEventDate		else null end as [6-Steroid related CPRD]
		, case when HES.diabetes =	'6-Steroid related'	then HES.minDischargeDate	else null end as [6-Steroid related HES]
		, case when ONS.diabetes =	'6-Steroid related'	then ONS.dod				else null end as [6-Steroid related ONS]
		, case when [All].diabetes ='6-Steroid related'	then [All].minEventDate		else null end as [6-Steroid related All]

	from [dbo].[tblPatient] P

		left join (
			select Dia.diabetes, patid, min(eventdate) as minEventDate
			from [dbo].[tblClinical] Cl
				inner join [dbo].[tlkDiabetes] Dia
					on Cl.medcode = Dia.medcode
			group by Dia.diabetes, patid
		) CPRD
			on P.patid = CPRD.patid

		left join (
			select Dia.diabetes, patid, min(discharged) as minDischargeDate
			from [dbo].[tblHES_diagnosis_hosp] hes
				inner join [dbo].[tlkDiabetes] Dia
					on hes.ICD = coalesce(Dia.ICD10, Dia.ICD9)
			group by Dia.diabetes, patid
		) HES
			on P.patid = HES.patid

		left join (
			select Dia.diabetes, patid, dod 
			from [dbo].[tblDeath_patient] ons
				inner join [dbo].[tlkDiabetes] Dia
					on ons.cause = Dia.ICD10
		) ONS
			on P.patid = ONS.patid

		left join (
			select Dia.diabetes, patid, min(eventdate) as minEventDate
			from [dbo].[tblClinical] Cl
				inner join [dbo].[tlkDiabetes] Dia
					on Cl.medcode = Dia.medcode
			group by Dia.diabetes, patid
		union
			select Dia.diabetes, patid, min(discharged)
			from [dbo].[tblHES_diagnosis_hosp] hes
				inner join [dbo].[tlkDiabetes] Dia
					on hes.ICD = Dia.ICD10
			group by Dia.diabetes, patid
		union
			select Dia.diabetes, patid, dod 
			from [dbo].[tblDeath_patient] ons
				inner join [dbo].[tlkDiabetes] Dia
					on ons.cause = coalesce(Dia.ICD10, Dia.ICD9)
		) [All]
			on P.patid = [All].patid
	where P.Cohort like '%PMR%' or P.Cohort like '%GCA%'
) A
group by Cohort, patid