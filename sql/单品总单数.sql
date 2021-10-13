select 
    b.companyno
    ,b.pluno
    ,count(distinct a.saleno) cnt  
from 
    td_sale_detail b 
inner join td_sale a on b.companyno=a.companyno and b.shop=a.shop and b.saleno=a.saleno
${if(len(para_iscoupon)==0,""," left join (select companyno,saleno,shop,bdate,sum(hIsCoupon) hIsCoupon from(select companyno,saleno,shop,bdate,case when PAYCODE='#04' AND CTType NOT IN ('KRD001','KRD002','KRD003','KRD004','KED026') then 1 else 0 end hIsCoupon from td_sale_pay)group by companyno,saleno,shop,bdate) z on z.companyno = a.companyno and z.saleno=a.saleno and a.shop=z.shop and z.bdate = a.bdate")}
where
    b.companyno='${para_companyno}'
    and a.bdate between '${format(para_bdate,"yyyyMMdd")}' and '${format(para_cdate,"yyyyMMdd")}' and a.type=0
    ${if(para_iscoupon==0," and z.hIsCoupon = 0","")}${if(para_iscoupon==1," and z.hIsCoupon != 0","")}
group by 
    b.companyno,b.pluno