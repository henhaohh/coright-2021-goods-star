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
		-- 宜春十运会店不要牛乳小馒头,刘松这里不改,我这里手动弄了下
		and not (a.pluno in ('010502036') and organizationno = 'A123')
		-- 萍乡南正街店不要几款产品,刘松这里不改,我这里手动弄了下
		and not (a.pluno in ('010103004','010103008','010103011','010103010') and organizationno = 'A116')
		-- 泸州北路店不要的几款产品
		and not (a.pluno in ('010502036','010502037') and organizationno = 'A112')
		-- 宜春八小店不要的几款产品
		and not (a.pluno in ('010501033') and organizationno = 'A124')
		-- 宜春中学店不要的几款产品
		and not (a.pluno in ('010502033','010501010','010501033','010502028') and organizationno = 'A122')
		-- 宜春润达店不要的几款产品
		and not (a.pluno in ('010201006') and organizationno = 'A108')
		-- 萍乡金三角店不要的几款产品
		and not (a.pluno in ('010102098','010502036','010502037') and organizationno = 'A114')
		-- 湘东新街店不要的几款产品
		and not (a.pluno in ('010102062','010102072','010301009','010501006') and organizationno = 'A113')
		-- 萍乡润达店不要的几款产品
		and not (a.pluno in ('010502028') and organizationno = 'A105')
		-- 芦溪漫时区店不要的几款产品
		and not (a.pluno in ('010102062','010102072','010502036') and organizationno = 'A117')
		and substr(b.sno,1,2) = '01'
)
where 1 = 1
${if(len(para_cType)=0,"and cat_name!='裱花组'",if(para_cType='裱花组',"and cat_name='裱花组'","and (cat_name in ('"+REPLACE(para_cType,",","','")+"') and cat_name!='裱花组')"))}
group by
	viewno