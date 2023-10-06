use GAE
go

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
--	, ethnicity not available
	, Smoking.eventdate as SmokingEventDate
	, Smoking.SmokingStatus
	, PassiveSmoking.eventdate as PassiveSmokingEventDate
	, PassiveSmoking.PassiveSmoker

	, BloodPressure.eventdate as BloodPressureEventDate
	, BloodPressure.EventTime as BloodPressureEventTime
	, BloodPressure.SystolicValue as BloodPressureSystolicValue
	, BloodPressure.Laterality as BloodPressureLaterality
	, BloodPressure.Posture as BloodPressurePosture
	, BloodPressure.Cuff as BloodPressureCuff

--, total cholesterol
--, HDL cholesterol
	, SerumCholesterol.eventdate as [SerumCholesterolEventDate]
	, SerumCholesterol.Operator as [SerumCholesterolOperator]
	, SerumCholesterol.Value as [SerumCholesterolValue]
	, SerumCholesterol.[Unit of measure] as [SerumCholesterolUnit]
	, SerumCholesterol.Qualifier as [SerumCholesterolQualifier]
	, SerumCholesterol.[Normal range from] as [SerumCholesterolLowerNormal]
	, SerumCholesterol.[Normal range to] as [SerumCholesterolUpperNormal]
	, SerumCholesterol.[Normal range basis] as [SerumCholesterolRangeBasis]

	, SerumCreatinine.eventdate as [SerumCreatinineEventDate]
	, SerumCreatinine.Operator as [SerumCreatinineOperator]
	, SerumCreatinine.Value as [SerumCreatinineValue]
	, SerumCreatinine.[Unit of measure] as [SerumCreatinineUnit]
	, SerumCreatinine.Qualifier as [SerumCreatinineQualifier]
	, SerumCreatinine.[Normal range from] as [SerumCreatinineLowerNormal]
	, SerumCreatinine.[Normal range to] as [SerumCreatinineUpperNormal]
	, SerumCreatinine.[Normal range basis] as [SerumCreatinineRangeBasis]

from (
		select distinct Pat.patid
			, CL.eventdate
		from [dbo].[tblPatient] Pat
			left join [dbo].[tblAdditional] Ad
				on Pat.patid = Ad.patid
			inner join [dbo].[tblClinical] Cl
				on Ad.patid = CL.patid
					and Ad.adid = CL.adid
	union
		select distinct Pat.patid
			, Ts.eventdate
		from [dbo].[tblPatient] Pat
			left join [dbo].[tblTest] Ts
				on Pat.patid = Ts.patid
	) dd

	inner join (
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
		on dd.patid = Patient.patid

	left join [dbo].[tblPractice] Prac
		on right (Patient.patid, 3) = Prac.pracid

	left join (
		select Ad.[patid]
			, Cl.eventdate
			, Ad.[data1] -- Height in metres
		from [dbo].[tblAdditional] Ad
			inner join [dbo].[tblClinical] Cl
				on Ad.patid = CL.patid
					and Ad.adid = CL.adid
		where Ad.enttype = 14 -- Height
		) Height
		on Patient.patid = Height.patid	
			and cast (Height.eventdate as date) = dd.eventdate

	left join (
		select Ad.[patid]
			, Cl.eventdate
			, Ad.[data1] -- Weight in kilos
		from [dbo].[tblAdditional] Ad
			inner join [dbo].[tblClinical] Cl
				on Ad.patid = CL.patid
					and Ad.adid = CL.adid
		where Ad.enttype = 13 -- Weight
		) [Weight]
		on Patient.patid = [Weight].patid	
			and cast ([Weight].eventdate as date) = dd.eventdate

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
			, Ad.data2 as [SystolicValue]
			, Ad.data4 as [EventTime]
			, Ad.data5 as Laterality
			, Ad.data6 as Posture
			, Ad.data7 as Cuff
		from [dbo].[tblAdditional] Ad
			inner join [dbo].[tblClinical] Cl
				on Ad.patid = CL.patid
					and Ad.adid = CL.adid
		where Ad.enttype = 1 -- Blood pressure
		) BloodPressure
		on Patient.patid = BloodPressure.patid	
			and cast (BloodPressure.eventdate as date) = dd.eventdate

	left join (
		select Ts.[patid]
			, Ts.eventdate
			, OPR.[text] as Operator
			, Ts.[data2] as Value
			, [SUM].[text] as [Unit of measure]
			, TQU.[text] as Qualifier
			, Ts.[data5] as [Normal range from]
			, Ts.[data6] as [Normal range to]
			, POP.[text] as [Normal range basis]
		from [dbo].[tblTest] Ts
			left join [CPRD].[dbo].[tlkThreeCharacter] OPR
				on Ts.data1 = (select OPR.code where OPR.reference = 'OPR')
			left join [CPRD].[dbo].[tlkThreeCharacter] [SUM]
				on Ts.data3 = (select [SUM].code where [SUM].reference = 'SUM')
			left join [CPRD].[dbo].[tlkThreeCharacter] TQU
				on Ts.data4 = (select TQU.code where TQU.reference = 'TQU')
			left join [CPRD].[dbo].[tlkThreeCharacter] POP
				on Ts.data7 = (select POP.code where POP.reference = 'POP')
		where Ts.enttype = 163 -- Serum cholesterol
		) SerumCholesterol
		on Patient.patid = SerumCholesterol.patid	
			and cast (SerumCholesterol.eventdate as date) = dd.eventdate

	left join (
		select Ts.[patid]
			, Ts.eventdate
			, OPR.[text] as Operator
			, Ts.[data2] as Value
			, [SUM].[text] as [Unit of measure]
			, TQU.[text] as Qualifier
			, Ts.[data5] as [Normal range from]
			, Ts.[data6] as [Normal range to]
			, POP.[text] as [Normal range basis]
		from [dbo].[tblTest] Ts
			left join [CPRD].[dbo].[tlkThreeCharacter] OPR
				on Ts.data1 = (select OPR.code where OPR.reference = 'OPR')
			left join [CPRD].[dbo].[tlkThreeCharacter] [SUM]
				on Ts.data3 = (select [SUM].code where [SUM].reference = 'SUM')
			left join [CPRD].[dbo].[tlkThreeCharacter] TQU
				on Ts.data4 = (select TQU.code where TQU.reference = 'TQU')
			left join [CPRD].[dbo].[tlkThreeCharacter] POP
				on Ts.data7 = (select POP.code where POP.reference = 'POP')
		where Ts.enttype = 165 -- Serum creatinine
		) SerumCreatinine
		on Patient.patid = SerumCreatinine.patid	
			and cast (SerumCreatinine.eventdate as date) = dd.eventdate

where ([Weight].eventdate is not null 
	or Height.eventdate is not null
	or Smoking.eventdate is not null
	or PassiveSmoking.eventdate is not null
	or BloodPressure.eventdate is not null
	or SerumCholesterol.eventdate is not null
	or SerumCreatinine.eventdate is not null)

order by patid, eventdate