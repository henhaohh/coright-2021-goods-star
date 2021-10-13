select
companyno
,pluno
,shop
,count(distinct saleno) cnt 
from (
select 
b.companyno
,b.pluno
,a.shop
--,count(distinct a.saleno) cnt 
,b.saleno
,(CASE WHEN c.sno='010101' or c.sno='010102' then '现烤组' WHEN c.sno='010103' then '现烤三明治' WHEN c.sno='010201' or c.sno='010301' or c.sno='010401' then '工厂' WHEN substr(c.sno,1,4)='0105' then '西点组' WHEN substr(c.sno,1,4)='0109' then '水吧组' WHEN c.sno='010402' or c.sno='010701' or substr(c.sno,0,4)='0106' or substr(c.sno,0,4)='0308' then '代销品' WHEN substr(c.sno,1,4)='0108' then '裱花组' ELSE '其他' END) cat_name -- 分类
from td_sale_detail b 
inner join td_sale a on b.companyno=a.companyno and b.shop=a.shop and b.saleno=a.saleno 
${if(len(para_iscoupon)==0,""," left join (select companyno,saleno,shop,bdate,sum(hIsCoupon) hIsCoupon from(select companyno,saleno,shop,bdate,case when PAYCODE='#04' AND CTType NOT IN ('KRD001','KRD002','KRD003','KRD004','KED026') then 1 else 0 end hIsCoupon from td_sale_pay)group by companyno,saleno,shop,bdate) z on z.companyno = a.companyno and z.saleno=a.saleno and a.shop=z.shop and z.bdate = a.bdate")}
left join tb_goods c on c.companyno = b.companyno and c.pluno = b.pluno 
where b.companyno='${para_companyno}' and a.bdate between '${format(para_bdate,"yyyyMMdd")}' and '${format(para_cdate,"yyyyMMdd")}'
and a.type=0 
${if(para_iscoupon==0," and z.hIsCoupon = 0","")}
${if(para_iscoupon==1," and z.hIsCoupon != 0","")} 
group by b.companyno,b.pluno,a.shop,b.saleno,c.sno
)
where 1 = 1
${if(len(para_pluno)==0,""," and pluno in ('"+ REPLACE(para_pluno,",","','") +"')")}
${if(len(para_cType)=0,""," and cat_name in ('"+REPLACE(para_cType,",","','")+"')")}
group by companyno,pluno,shop