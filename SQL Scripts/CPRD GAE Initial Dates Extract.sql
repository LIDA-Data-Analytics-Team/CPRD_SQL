use GAE
go

SELECT distinct 
	rtrim (
		case when DCGCA.patid is not null then 'Clinical ' else '' end +
		case when DRGCA.patid is not null then 'Referral ' else '' end +
		case when DTGCA.patid is not null then 'Test ' else '' end 
		) as GCAAppearsOn
	, rtrim (
		case when DCPMR.patid is not null then 'Clinical ' else '' end +
		case when DRPMR.patid is not null then 'Referral ' else '' end +
		case when DTPMR.patid is not null then 'Test ' else '' end 
		) as PMRAppearsOn
	, [cohort]
	, Pat.[patid]
	, GCA.EarliestGCA
	, PMR.EarliestPMR
	, convert (datetime, '15/' + case when mob = 0 then '6' else cast (mob as varchar(2)) end + '/' + cast (yob + 1818 as varchar(4)), 103) as Birthday18
	, Pat.crd as CurrentRegistration
	, Pat.tod as TransferOut
	, Prac.uts as UpToStandard
	, Pat.deathdate as CPRDDeathDate

from [dbo].[tblPatient] Pat
	left join [dbo].[tblPractice] Prac
		on right (Pat.patid, 3) = Prac.pracid
	left join (
		select distinct patid, min(eventdate) as EarliestGCA
		from [dbo].[tblClinical]
		where medcode in (3275, 9843, 10432, 29472, 53789, 68403, 49149)
		group by patid
		) GCA
		on Pat.patid = GCA.patid
	left join (
		select distinct patid, min(eventdate) as EarliestPMR
		from [dbo].[tblClinical]
		where medcode in (1408, 3042, 29472)
		group by patid
		) PMR
		on Pat.patid = PMR.patid

	left join (select * from [dbo].[tblDefineClinicalGCA] /*where eventdate between '1998-01-02' and '2015-09-30'*/) DCGCA 
		on Pat.patid = DCGCA.patid
	left join (select * from [dbo].[tblDefineClinicalPMR] /*where eventdate between '1998-01-02' and '2015-09-30'*/) DCPMR
		on Pat.patid = DCPMR.patid
	left join (select * from [dbo].[tblDefineReferralGCA] /*where eventdate between '1998-01-02' and '2015-09-30'*/) DRGCA
		on Pat.patid = DRGCA.patid	
	left join (select * from [dbo].[tblDefineReferralPMR] /*where eventdate between '1998-01-02' and '2015-09-30'*/) DRPMR
		on Pat.patid = DRPMR.patid
	left join (select * from [dbo].[tblDefineTestGCA] /*where eventdate between '1998-01-02' and '2015-09-30'*/) DTGCA
		on Pat.patid = DTGCA.patid
	left join (select * from [dbo].[tblDefineTestPMR] /*where eventdate between '1998-01-02' and '2015-09-30'*/) DTPMR
		on Pat.patid = DTPMR.patid
