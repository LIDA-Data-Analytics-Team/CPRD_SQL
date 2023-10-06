use GAE
go

--alter proc [dbo].[spExtractCovariate]
--as

select dd.eventdate
	, Patient.cohort
	, Patient.patid
	, Patient.mob as BirthMonth
	, Patient.yob +1800 as BirthYear
	, [SEX].[text] as Gender
	, Patient.[ses] as IMDscore
	, Patient.frd as FirstRegistrationDate
	, Patient.DeathDate
	, Prac.uts

	, [Weight].eventdate as WeightEventDate
	, [Weight].data1 as [Weight(kg)]
	, Height.eventdate as HeightEventDate
	, Height.data1 as [Height(m)]
	, case when BMI.data3 is not null then [BMI].data3
		else round([Weight].data1/nullif(SQUARE(Height.data1), 0), 2) 
		end as BMI
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

from [dbo].[tblPatient] Patient
	left join [CPRD].[dbo].[tlkThreeCharacter] SEX
		on Patient.gender = (select SEX.code where SEX.reference = 'SEX')

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
		select Ad.[patid]
			, Cl.eventdate
			, avg (cast (Ad.[data3] as float)) as data3 -- BMI
		from [dbo].[tblAdditional] Ad
			inner join [dbo].[tblClinical] Cl
				on Ad.patid = CL.patid
					and Ad.adid = CL.adid
		where Ad.enttype = 13 -- Weight
			and cast (Ad.data1 as float) between 10 and 80
		group by Ad.[patid], Cl.eventdate
		) [BMI]
		on Patient.patid = [BMI].patid	
			and cast ([BMI].eventdate as date) = dd.eventdate

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
			, min (
				case when SS.code is null then case when Ad.data1 = 0 then null
													when Ad.data1 = 1 then 'Current smoker (4)'
													when Ad.data1 = 2 then 'Non smoker (1)'
													when Ad.data1 = 3 then 'Ex smoker (2)' 
													end
					when Ad.enttype <> 4 then SS.Code
					when Ad.enttype = 4 then 
						case when Ad.data1 = 0 then SS.Code
						when Ad.data1 = 1 then 
							case when SS.Code = 'Non smoker (1)' then 'Code conflict (non & current)'
								when SS.Code = 'Ex smoker (2)' then 'Code conflict (ex & current)'
								when SS.code = 'Ex or current smoker (3)' then 'Current smoker (4)'
								when SS.Code = 'Current smoker (4)' then 'Current smoker (4)'
								end
						when Ad.data1 = 2 then 
							case when SS.Code = 'Non smoker (1)' then 'Non smoker (1)'
								when SS.Code = 'Ex smoker (2)' then 'Ex smoker (2)'
								when SS.code = 'Ex or current smoker (3)' then 'Ex smoker (2)'
								when SS.Code = 'Current smoker (4)' then 'Code conflict (non & current)'
								end
						when Ad.data1 = 3 then 
							case when SS.Code = 'Non smoker (1)' then 'Ex smoker (2)'
								when SS.Code = 'Ex smoker (2)' then 'Ex smoker (2)'
								when SS.code = 'Ex or current smoker (3)' then 'Ex smoker (2)'
								when SS.Code = 'Current smoker (4)' then 'Code conflict (ex & current)'
								end
						end
				end 
				) as SmokingStatus
		from [dbo].[tblAdditional] Ad
			inner join [dbo].[tblClinical] Cl
				on Ad.patid = CL.patid
					and Ad.adid = CL.adid
			left join [dbo].[tlkSmokingStatus] SS
				on Cl.medcode = SS.medcode
		where (Ad.enttype = 4 -- Smoking
				or SS.medcode is not null)
			--and Ad.patid in (4444, 123263)
		group by Ad.[patid]
			, Cl.eventdate
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
		where (Ts.enttype = (163) --Serum cholesterol
				or (Ts.enttype = (288) and Ts.medcode in (18040))) -- Other laboratory tests and total cholesterol (plasma) code list
			and Ts.data1 = 3 -- operator "="
			and Ts.data3 in (0, 82, 96) -- Data not entered, mg/dL, mmol/L
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
		where (Ts.enttype = (175) -- High density lipoprotein
				or (Ts.enttype = (288) and Ts.medcode in (44, 13761))) -- Other laboratory tests and HDL cholesterol (serum) code list
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
		where (Ts.enttype = (177) -- Low density lipoprotein
				or (Ts.enttype = (288) and Ts.medcode in (33304, 19764))) -- Other laboratory tests and LDL cholesterol (plasma) code list
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
		where (Ts.enttype = (165) -- Serum creatinine
				or (Ts.enttype = (288) and Ts.medcode in (5, 31277, 35545, 26903, 3927, 42345, 62062, 45096, 13736, 27095))) -- Other laboratory tests and crea_gprd codelist
			and Ts.data1 = 3 -- operator "="
			and Ts.data2 > 0
		group by Ts.[patid], Ts.eventdate
		) SerumCreatinine
		on Patient.patid = SerumCreatinine.patid	
			and cast (SerumCreatinine.eventdate as date) = dd.eventdate

where Patient.Cohort like '%PMR%' or Cohort like '%GCA%'

order by patid, dd.eventdate