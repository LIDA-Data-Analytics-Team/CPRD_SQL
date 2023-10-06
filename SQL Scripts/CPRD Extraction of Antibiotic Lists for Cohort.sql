use GAE
go

select distinct P.Cohort
	, P.patid
	, Th.eventdate
	, Prod.productname
	, Ant.antibiot
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
	
	inner join [dbo].[tlkAntibiotics] Ant
		on Th.prodcode = Ant.prodcode

where P.Cohort like '%PMR%' or Cohort like '%GCA%'

order by P.patid, Th.eventdate