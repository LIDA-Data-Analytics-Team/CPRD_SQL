insert into [dbo].[tlkInfection]

select * from [dbo].[tlkInfection_orig] where readcode = 'this aint no readcode'
union
SELECT [medcode] ,[readcode] ,[ICD10] ,[ICD10_nodot] ,[ICD9] ,[term]
 , [abscess], null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null
FROM [dbo].[tlkInfection_orig] where [abscess] is not null
union
SELECT [medcode] ,[readcode] ,[ICD10] ,[ICD10_nodot] ,[ICD9] ,[term]
 , null, [appendicit], null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null
FROM [dbo].[tlkInfection_orig] where [appendicit] is not null
union
SELECT [medcode] ,[readcode] ,[ICD10] ,[ICD10_nodot] ,[ICD9] ,[term]
 , null, null, [candida], null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null
FROM [dbo].[tlkInfection_orig] where [candida] is not null
union
SELECT [medcode] ,[readcode] ,[ICD10] ,[ICD10_nodot] ,[ICD9] ,[term]
 , null, null, null, [cellulitis], null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null
FROM [dbo].[tlkInfection_orig] where [cellulitis] is not null
union
SELECT [medcode] ,[readcode] ,[ICD10] ,[ICD10_nodot] ,[ICD9] ,[term]
 , null, null, null, null, [cholangitis], null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null
FROM [dbo].[tlkInfection_orig] where [cholangitis] is not null
union
SELECT [medcode] ,[readcode] ,[ICD10] ,[ICD10_nodot] ,[ICD9] ,[term]
 , null, null, null, null, null, [cholecyst], null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null
FROM [dbo].[tlkInfection_orig] where [cholecyst] is not null
union
SELECT [medcode] ,[readcode] ,[ICD10] ,[ICD10_nodot] ,[ICD9] ,[term]
 , null, null, null, null, null, null, [colitis], null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null
FROM [dbo].[tlkInfection_orig] where [colitis] is not null
union
SELECT [medcode] ,[readcode] ,[ICD10] ,[ICD10_nodot] ,[ICD9] ,[term]
, null, null, null, null, null, null, null, [conjunct], null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null
FROM [dbo].[tlkInfection_orig] where [conjunct] is not null
union
SELECT [medcode] ,[readcode] ,[ICD10] ,[ICD10_nodot] ,[ICD9] ,[term]
, null, null, null, null, null, null, null, null, [diabfoot], null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null
FROM [dbo].[tlkInfection_orig] where [diabfoot] is not null
union
SELECT [medcode] ,[readcode] ,[ICD10] ,[ICD10_nodot] ,[ICD9] ,[term]
, null, null, null, null, null, null, null, null, null, [divertic], null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null
FROM [dbo].[tlkInfection_orig] where [divertic] is not null
union
SELECT [medcode] ,[readcode] ,[ICD10] ,[ICD10_nodot] ,[ICD9] ,[term]
, null, null, null, null, null, null, null, null, null, null, [empyema], null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null
FROM [dbo].[tlkInfection_orig] where [empyema] is not null
union
SELECT [medcode] ,[readcode] ,[ICD10] ,[ICD10_nodot] ,[ICD9] ,[term]
, null, null, null, null, null, null, null, null, null, null, null, [flu], null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null
FROM [dbo].[tlkInfection_orig] where [flu] is not null
union
SELECT [medcode] ,[readcode] ,[ICD10] ,[ICD10_nodot] ,[ICD9] ,[term]
, null, null, null, null, null, null, null, null, null, null, null, null, [gasten], null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null
FROM [dbo].[tlkInfection_orig] where [gasten] is not null
union
SELECT [medcode] ,[readcode] ,[ICD10] ,[ICD10_nodot] ,[ICD9] ,[term]
, null, null, null, null, null, null, null, null, null, null, null, null, null, [gingivit], null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null
FROM [dbo].[tlkInfection_orig] where [gingivit] is not null
union
SELECT [medcode] ,[readcode] ,[ICD10] ,[ICD10_nodot] ,[ICD9] ,[term]
, null, null, null, null, null, null, null, null, null, null, null, null, null, null, [gingivitis], null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null
FROM [dbo].[tlkInfection_orig] where [gingivitis] is not null
union
SELECT [medcode] ,[readcode] ,[ICD10] ,[ICD10_nodot] ,[ICD9] ,[term]
, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, [hepatitis], null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null
FROM [dbo].[tlkInfection_orig] where [hepatitis] is not null
union
SELECT [medcode] ,[readcode] ,[ICD10] ,[ICD10_nodot] ,[ICD9] ,[term]
, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, [hpylori], null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null
FROM [dbo].[tlkInfection_orig] where [hpylori] is not null
union
SELECT [medcode] ,[readcode] ,[ICD10] ,[ICD10_nodot] ,[ICD9] ,[term]
, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, [hzoster], null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null
FROM [dbo].[tlkInfection_orig] where [hzoster] is not null
union
SELECT [medcode] ,[readcode] ,[ICD10] ,[ICD10_nodot] ,[ICD9] ,[term]
, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, [inf_oth], null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null
FROM [dbo].[tlkInfection_orig] where [inf_oth] is not null
union
SELECT [medcode] ,[readcode] ,[ICD10] ,[ICD10_nodot] ,[ICD9] ,[term]
, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, [inf_symp], null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null
FROM [dbo].[tlkInfection_orig] where [inf_symp] is not null
union
SELECT [medcode] ,[readcode] ,[ICD10] ,[ICD10_nodot] ,[ICD9] ,[term]
, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, [mastoiditis], null, null, null, null, null, null, null, null, null, null, null, null, null, null, null
FROM [dbo].[tlkInfection_orig] where [mastoiditis] is not null
union
SELECT [medcode] ,[readcode] ,[ICD10] ,[ICD10_nodot] ,[ICD9] ,[term]
, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, [meningit], null, null, null, null, null, null, null, null, null, null, null, null, null, null
FROM [dbo].[tlkInfection_orig] where [meningit] is not null
union
SELECT [medcode] ,[readcode] ,[ICD10] ,[ICD10_nodot] ,[ICD9] ,[term]
, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, [osteomyel], null, null, null, null, null, null, null, null, null, null, null, null, null
FROM [dbo].[tlkInfection_orig] where [osteomyel] is not null
union
SELECT [medcode] ,[readcode] ,[ICD10] ,[ICD10_nodot] ,[ICD9] ,[term]
, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, [otitis], null, null, null, null, null, null, null, null, null, null, null, null
FROM [dbo].[tlkInfection_orig] where [otitis] is not null
union
SELECT [medcode] ,[readcode] ,[ICD10] ,[ICD10_nodot] ,[ICD9] ,[term]
, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, [perforat], null, null, null, null, null, null, null, null, null, null, null
FROM [dbo].[tlkInfection_orig] where [perforat] is not null
union
SELECT [medcode] ,[readcode] ,[ICD10] ,[ICD10_nodot] ,[ICD9] ,[term]
, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, [periton], null, null, null, null, null, null, null, null, null, null
FROM [dbo].[tlkInfection_orig] where [periton] is not null
union
SELECT [medcode] ,[readcode] ,[ICD10] ,[ICD10_nodot] ,[ICD9] ,[term]
, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, [pharyng], null, null, null, null, null, null, null, null, null
FROM [dbo].[tlkInfection_orig] where [pharyng] is not null
union
SELECT [medcode] ,[readcode] ,[ICD10] ,[ICD10_nodot] ,[ICD9] ,[term]
, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, [pneumonia], null, null, null, null, null, null, null, null
FROM [dbo].[tlkInfection_orig] where [pneumonia] is not null
union
SELECT [medcode] ,[readcode] ,[ICD10] ,[ICD10_nodot] ,[ICD9] ,[term]
, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, [resp_inf], null, null, null, null, null, null, null
FROM [dbo].[tlkInfection_orig] where [resp_inf] is not null
union
SELECT [medcode] ,[readcode] ,[ICD10] ,[ICD10_nodot] ,[ICD9] ,[term]
, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, [sepsis], null, null, null, null, null, null
FROM [dbo].[tlkInfection_orig] where [sepsis] is not null
union
SELECT [medcode] ,[readcode] ,[ICD10] ,[ICD10_nodot] ,[ICD9] ,[term]
, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, [sepsis_type], null, null, null, null, null
FROM [dbo].[tlkInfection_orig] where [sepsis_type] is not null
union
SELECT [medcode] ,[readcode] ,[ICD10] ,[ICD10_nodot] ,[ICD9] ,[term]
, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, [sinusitis], null, null, null, null
FROM [dbo].[tlkInfection_orig] where [sinusitis] is not null
union
SELECT [medcode] ,[readcode] ,[ICD10] ,[ICD10_nodot] ,[ICD9] ,[term]
, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, [tb], null, null, null
FROM [dbo].[tlkInfection_orig] where [tb] is not null
union
SELECT [medcode] ,[readcode] ,[ICD10] ,[ICD10_nodot] ,[ICD9] ,[term]
, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, [tonsillitis], null, null
FROM [dbo].[tlkInfection_orig] where [tonsillitis] is not null
union
SELECT [medcode] ,[readcode] ,[ICD10] ,[ICD10_nodot] ,[ICD9] ,[term]
, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, [uti], null
FROM [dbo].[tlkInfection_orig] where [uti] is not null
union
SELECT [medcode] ,[readcode] ,[ICD10] ,[ICD10_nodot] ,[ICD9] ,[term]
, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, [vaccinat]
FROM [dbo].[tlkInfection_orig] where [vaccinat] is not null

order by [abscess] desc, [appendicit] desc, [candida] desc, [cellulitis] desc, [cholangitis] desc, [cholecyst] desc, [colitis] desc, [conjunct] desc, [diabfoot] desc, [divertic] desc, [empyema] desc, [flu] desc, [gasten] desc, [gingivit] desc, [gingivitis] desc, [hepatitis] desc, [hpylori] desc, [hzoster] desc, [inf_oth] desc, [inf_symp] desc, [mastoiditis] desc, [meningit] desc, [osteomyel] desc, [otitis] desc, [perforat] desc, [periton] desc, [pharyng] desc, [pneumonia] desc, [resp_inf] desc, [sepsis] desc, [sepsis_type] desc, [sinusitis] desc, [tb] desc, [tonsillitis] desc, [uti] desc, [vaccinat] desc
