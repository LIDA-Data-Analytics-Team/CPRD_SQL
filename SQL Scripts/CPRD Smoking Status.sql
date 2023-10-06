select SmokingStatus.*
from (
	select Ad.patid, MAX(Cl.eventdate) as MaxEventDate
	from [dbo].[tblAdditional] Ad
		inner join [dbo].[tblClinical] Cl
			on Ad.patid = CL.patid
				and Ad.adid = CL.adid
		left join [dbo].[tlkSmokingStatus] SS
			on Cl.medcode = SS.medcode
	where (Ad.enttype = 4 -- Smoking
			or SS.medcode is not null)
	group by Ad.patid
	) MaxEventDate
	inner join (
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
	) SmokingStatus
	on MaxEventDate.patid = SmokingStatus.patid
		and MaxEventDate.MaxEventDate = SmokingStatus.eventdate