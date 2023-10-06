use GAE
go

select distinct P.Cohort
	, P.patid
	, Th.eventdate
	, Prod.productname
	, case when Drg.orgc is not null then Drg.orgc end as orgc
	, case when Drg.articgc is not null then Drg.articgc end as articgc
	, case when Drg.imgc is not null then Drg.imgc end as imgc
	, case when Drg.rectgc is not null then Drg.rectgc end as rectgc
	, case when Drg.topgc is not null then Drg.topgc end as topgc
	, case when Drg.inhgc is not null then Drg.inhgc end as inhgc
	, case when Drg.nasgc is not null then Drg.nasgc end as nasgc
	, case when Drg.dmard is not null then Drg.dmard end as dmard
	, case when Drg.biologic is not null then Drg.biologic end as biologic
	, Th.qty
	, Th.ndd
	, Th.numdays
	, Th.numpacks
	, PT.packtype_desc
	, Th.issueseq

from [dbo].[tblPatient] P
	inner join [dbo].[tblTherapy] Th
		on P.patid = Th.patid
	left join CPRD.[dbo].[tlkProduct] Prod
		on Th.prodcode = Prod.prodcode
	left join CPRD.[dbo].[tlkPackType] PT
		on Th.packtype = PT.packtype
	
	inner join [dbo].[tlkDrugs] Drg
		on Th.prodcode = Drg.prodcode

where P.Cohort like '%PMR%' or Cohort like '%GCA%'

order by P.patid, Th.eventdate