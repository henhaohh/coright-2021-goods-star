select
	viewno
	,count(distinct pluno) cnt
from
(
	select 
		a.organizationno viewno
		,a.pluno
		,b.sno
		,(CASE WHEN b.sno='010101' or b.sno='010102' or b.sno='010103' then '现烤组' WHEN b.sno='010201' or b.sno='010301' or b.sno='010401' then '工厂' WHEN substr(b.sno,1,4)='0105' then '西点组' WHEN substr(b.sno,1,4)='0109' then '水吧组' WHEN b.sno='010402' or b.sno='010701' or substr(b.sno,0,4)='0106' or substr(b.sno,0,4)='0308' then '代销品' WHEN substr(b.sno,1,4)='0108' then '裱花组' ELSE '其他' END) cat_name 
	from 
		tb_goods_shop a
	left join tb_goods b on a.pluno = b.pluno
	where 
		a.COMPANYNO='${para_companyno}'
		and a.cnfflg='Y'
		and a.supplier = 'KRD'
		and a.organizationno not in ('A110')
		--排除掉某些特定商品
		and a.pluno not in ('010102092')
		and substr(b.sno,1,2) = '01'
)
where 1 = 1
${if(len(para_cType)=0,"and cat_name!='裱花组'",if(para_cType='裱花组',"and cat_name='裱花组'","and (cat_name in ('"+REPLACE(para_cType,",","','")+"') and cat_name!='裱花组')"))}
group by
	viewno