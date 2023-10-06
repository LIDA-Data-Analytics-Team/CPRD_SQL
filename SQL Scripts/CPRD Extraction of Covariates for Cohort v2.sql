use GAE
go

--alter proc [dbo].[spExtractCovariate]
--as

select distinct dd.eventdate
	, Patient.cohort
	, Patient.patid
	, Patient.mob as BirthMonth
	, Patient.yob as BirthYear
	, Patient.Gender
	, Patient.[ses] as IMDscore
	, Patient.frd as FirstRegistrationDate
	, Patient.DeathDate
	, Prac.uts

	, [Weight].eventdate as WeightEventDate
	, [Weight].data1 as [Weight(kg)]
	, Height.eventdate as HeightEventDate
	, Height.data1 as [Height(m)]
	, round([Weight].data1/nullif(SQUARE(Height.data1), 0), 2) as BMI
	, Ethnicity.[category] as Ethnicity
	, Smoking.eventdate as SmokingEventDate
	, Smoking.SmokingStatus
	, PassiveSmoking.eventdate as PassiveSmokingEventDate
	, PassiveSmoking.PassiveSmoker

	, BloodPressure.eventdate as BloodPressureEventDate
	, BloodPressure.DiastolicValue as BloodPressureDiastolicValue
	, BloodPressure.SystolicValue as BloodPressureSystolicValue

	, TotalCholesterol.eventdate as TotalCholesterolEventdate
	, TotalCholesterol.Value as TotalCholesterolValue
	, HDLCholesterol.eventdate as HDLCholesterolEventdate
	, HDLCholesterol.Value as HDLCholesterolValue
	, LDLCholesterol.eventdate as LDLCholesterolEventdate
	, LDLCholesterol.Value as LDLCholesterolValue

	, SerumCreatinine.eventdate as [SerumCreatinineEventDate]
	, SerumCreatinine.Value as [SerumCreatinineValue]

from (
		select [patid]
			, cohort
			, sex.[text] as gender
			, [yob] + 1800 as yob
			, [mob]
			, [ses]
			, [frd]
			, [deathdate]
		from [dbo].[tblPatient] Pat
			left join [CPRD].[dbo].[tlkThreeCharacter] SEX
				on Pat.gender = (select SEX.code where SEX.reference = 'SEX')
		) Patient
	left join (
		select distinct Cl.patid
			, eventdate
		from [dbo].[tblAdditional] Ad
			inner join [dbo].[tblClinical] Cl
				on Ad.patid = CL.patid
					and Ad.adid = CL.adid
	union
		select distinct patid
			, eventdate
		from [dbo].[tblTest] Ts
		) dd
		on Patient.patid = dd.patid

	left join [dbo].[tblPractice] Prac
		on right (Patient.patid, 3) = Prac.pracid

	left join (
		select Ad.[patid]
			, Cl.eventdate
			, avg (cast (Ad.[data1] as float)) as data1 -- Height in metres
		from [dbo].[tblAdditional] Ad
			inner join [dbo].[tblClinical] Cl
				on Ad.patid = CL.patid
					and Ad.adid = CL.adid
		where Ad.enttype = 14 -- Height
			and cast (Ad.data1 as float) between 0.8 and 2.5
		group by Ad.[patid], Cl.eventdate
		) Height
		on Patient.patid = Height.patid	
			and cast (Height.eventdate as date) = dd.eventdate

	left join (
		select Ad.[patid]
			, Cl.eventdate
			, avg (cast (Ad.[data1] as float)) as data1 -- Weight in kilograms
		from [dbo].[tblAdditional] Ad
			inner join [dbo].[tblClinical] Cl
				on Ad.patid = CL.patid
					and Ad.adid = CL.adid
		where Ad.enttype = 13 -- Weight
			and cast (Ad.data1 as float)  between 30 and 350
		group by Ad.[patid], Cl.eventdate
		) [Weight]
		on Patient.patid = [Weight].patid	
			and cast ([Weight].eventdate as date) = dd.eventdate

	left join (
		select distinct Cl.patid
			, max (Eth.category) as category
		from (
				select patid, max(eventdate) as MaxEventDate
				from [dbo].[tblClinical] Cl
				where exists (
					select * from [dbo].[tlkEthnicity_read] Eth where CL.medcode = Eth.medcode)
				group by patid
			) LatestEthnicity
			inner join [dbo].[tblClinical] Cl
				on LatestEthnicity.patid = Cl.patid
					and LatestEthnicity.MaxEventDate = Cl.eventdate 
			inner join [dbo].[tlkEthnicity_read] Eth
				on Cl.medcode = case when Eth.category <> '9-Unknown' then Eth.medcode else null end
		group by Cl.patid
		)Ethnicity
		on Patient.patid = Ethnicity.patid

	left join (
		select distinct Ad.[patid]
			, Cl.eventdate
			, YND.[text] as SmokingStatus
		from [dbo].[tblAdditional] Ad
			inner join [dbo].[tblClinical] Cl
				on Ad.patid = CL.patid
					and Ad.adid = CL.adid
			left join [CPRD].[dbo].[tlkThreeCharacter] YND
				on Ad.data1 = (select YND.code where YND.reference = 'YND')
		where Ad.enttype = 4 -- Smoking
		) Smoking
		on Patient.patid = Smoking.patid	
			and cast (Smoking.eventdate as date) = dd.eventdate

	left join (
		select Ad.[patid]
			, Cl.eventdate
			, Y_N.[text] as PassiveSmoker
		from [dbo].[tblAdditional] Ad
			inner join [dbo].[tblClinical] Cl
				on Ad.patid = CL.patid
					and Ad.adid = CL.adid
			left join [CPRD].[dbo].[tlkThreeCharacter] Y_N
				on Ad.data1 = (select Y_N.code where Y_N.reference = 'Y_N')
		where Ad.enttype = 127 -- Passive Smoking
		) PassiveSmoking
		on Patient.patid = PassiveSmoking.patid	
			and cast (PassiveSmoking.eventdate as date) = dd.eventdate

	left join (
		select Ad.[patid]
			, Cl.eventdate
			, avg (cast (Ad.data1 as float)) as [DiastolicValue]
			, avg (cast (Ad.data2 as float)) as [SystolicValue]
		from [dbo].[tblAdditional] Ad
			inner join [dbo].[tblClinical] Cl
				on Ad.patid = CL.patid
					and Ad.adid = CL.adid
		where Ad.enttype = 1 -- Blood pressure
			and (Ad.data1 between 20 and 200
				or Ad.data2 between 20 and 350)
		group by Ad.[patid], Cl.eventdate
		) BloodPressure
		on Patient.patid = BloodPressure.patid	
			and cast (BloodPressure.eventdate as date) = dd.eventdate

	left join (
		select Ts.[patid]
			, Ts.eventdate
			, avg (Ts.[data2]) as Value
		from [dbo].[tblTest] Ts
		where Ts.enttype in (288) -- Serum Cholesterol, Other laboratory tests, High density lipoprotein
			and Ts.medcode in (18040) -- total cholesterol (plasma) code list
			and Ts.data1 = 3 -- operator "="
			and Ts.data3 in (0, 82, 96)
			and Ts.data2 between 0.01 and 50
		group by Ts.[patid], Ts.eventdate
		) TotalCholesterol
		on Patient.patid = TotalCholesterol.patid	
			and cast (TotalCholesterol.eventdate as date) = dd.eventdate

	left join (
		select Ts.[patid]
			, Ts.eventdate
			, avg (Ts.[data2]) as Value
		from [dbo].[tblTest] Ts
		where Ts.enttype in (163, 288, 175) -- Serum Cholesterol, Other laboratory tests, High density lipoprotein
			and Ts.medcode in (44, 13761) -- HDL cholesterol (serum) code list
			and Ts.data1 = 3 -- operator "="
			and isnull (Ts.data3, '') in (0, 96, '')
			and Ts.data2 between 0.01 and 50
		group by Ts.[patid], Ts.eventdate
		) HDLCholesterol
		on Patient.patid = HDLcholesterol.patid	
			and cast (HDLcholesterol.eventdate as date) = dd.eventdate

	left join (
		select Ts.[patid]
			, Ts.eventdate
			, avg (Ts.[data2]) as Value
		from [dbo].[tblTest] Ts
		where Ts.enttype in (163, 288, 177) -- Serum Cholesterol, Other laboratory tests, High density lipoprotein
			and Ts.medcode in (33304, 19764) -- LDL cholesterol (plasma) code list
			and Ts.data1 = 3 -- operator "="
			and isnull (Ts.data3, '') in (0, 96, '')
			and Ts.data2 between 0.01 and 50
		group by Ts.[patid], Ts.eventdate
		) LDLCholesterol
		on Patient.patid = LDLcholesterol.patid	
			and cast (LDLcholesterol.eventdate as date) = dd.eventdate

	left join (
		select Ts.[patid]
			, Ts.eventdate
			, avg (Ts.[data2]) as Value
		from [dbo].[tblTest] Ts
		where Ts.enttype in (165, 288) --Serum creatinine, Other laboratory tests 
			and Ts.medcode in (5, 31277, 35545, 26903, 3927, 42345, 62062, 45096, 13736, 27095) -- crea_gprd codelist
			and Ts.data1 = 3 -- operator "="
			and Ts.data2 > 0
		group by Ts.[patid], Ts.eventdate
		) SerumCreatinine
		on Patient.patid = SerumCreatinine.patid	
			and cast (SerumCreatinine.eventdate as date) = dd.eventdate

order by patid, dd.eventdate

select COUNT (*)
from [dbo].[tblCovariateExtraction]