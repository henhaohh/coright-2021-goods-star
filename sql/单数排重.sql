/* para_opnp 用 A08002 */
select 
    a.companyno
    ,count(distinct b.saleno) cnt  
from 
    td_sale_detail a 
inner join td_sale b on a.companyno=b.companyno and a.shop=b.shop and a.saleno=b.saleno
left join tb_goods c on b.companyno=c.companyno and b.pluno=c.pluno
where
    a.companyno='${para_companyno}'  
    ${if(len(para_shop)==0,"and b.shop in (SELECT Shop FROM Platform_Staffs_Shop where opno='"+para_opno+"')"," and b.shop in ('" + para_shop + "')")}   
    and b.bdate between '${format(para_bdate,"yyyyMMdd")}' and '${format(para_cdate,"yyyyMMdd")}' and b.type=0 
    and substr(c.sno,0,4)!='0108'
    and substr(c.sno,1,6)!='B10601' 
    and substr(c.sno,1,6)!='011002'
group by 
    a.companyno