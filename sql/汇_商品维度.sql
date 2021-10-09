select 
distinct pluno,pluname,item_total_cnt,total_cnt,item_total_per,cat_name
from (
select 
    a.pluno -- 品号
    ,a.viewno -- 门店号
    ,a.viewname -- 门店名
    ,a.pluname -- 品名
    ,a.item_cnt -- 商品_门店_单数
    ,b.cnt shop_total_cnt -- 门店_总_单数
    ,c.cnt item_total_cnt -- 商品_总_单数
    ,a.total_cnt -- 全体_总单数
    ,a.item_cnt/b.cnt item_shop_per -- 商品_门店_购买率
    ,c.cnt/a.total_cnt item_total_per -- 商品_总_购买率
    ,(a.item_cnt/b.cnt) - (c.cnt/a.total_cnt) item_per_dif -- 门店商品购买率与总购买率差异，用以计算得分
    ,a.cat_name  -- 分类    
from (
    select 
        a.pluno -- 品号
        ,a.shop viewno -- 门店号
        ,C.ORG_NAME viewname -- 门店名
        ,b.pluname -- 品名
        ,count(a.cnt) item_cnt -- 单数
        ,(select count(cnt) cnt from ( SELECT case when a.type='1' or a.type='2' or a.type='4' then 0 else 1 end cnt FROM "POS"."TD_SALE" a LEFT JOIN "POS"."TD_SALE_DETAIL" b on a.companyno=b.companyno and a.shop=b.shop and a.saleno=b.saleno ${if(len(para_iscoupon)==0,"","left join (select companyno,saleno,shop,bdate,sum(hIsCoupon) hIsCoupon from(select companyno,saleno,shop,bdate,case when PAYCODE='#04' AND CTType NOT IN ('KRD001','KRD002','KRD003','KRD004','KED026') then 1 else 0 end hIsCoupon from td_sale_pay)group by companyno,saleno,shop,bdate) z on z.companyno = a.companyno and z.saleno=a.saleno and a.shop=z.shop and z.bdate = a.bdate")} where a.bdate between '${format(para_bdate,"yyyyMMdd")}' and '${format(para_cdate,"yyyyMMdd")}' and (b.packagemaster!='Y' or b.packagemaster is null)${if(para_iscoupon==0," and z.hIsCoupon = 0","")}${if(para_iscoupon==1," and z.hIsCoupon != 0","")} )) total_cnt -- 总单数
        ,(CASE WHEN b.sno='010101' or b.sno='010102' then '现烤组' WHEN b.sno='010103' then '现烤三明治' WHEN b.sno='010201' or b.sno='010301' or b.sno='010401' then '工厂' WHEN substr(b.sno,1,4)='0105' then '西点组' WHEN substr(b.sno,1,4)='0109' then '水吧组' WHEN b.sno='010402' or b.sno='010701' or substr(b.sno,0,4)='0106' or substr(b.sno,0,4)='0308' then '代销品' WHEN substr(b.sno,1,4)='0108' then '裱花组' ELSE '其他' END) cat_name -- 分类
    from 
        (
            -- 销售单
            SELECT 
                b.pluno
                ,a.shop
                ,a.companyno
                ,case when a.type='1' or a.type='2' or a.type='4' then 0 else 1 end cnt 
            FROM "POS"."TD_SALE" a 
            LEFT JOIN "POS"."TD_SALE_DETAIL" b on a.companyno=b.companyno and a.shop=b.shop and a.saleno=b.saleno 
            where 
                a.bdate between '${format(para_bdate,"yyyyMMdd")}' and '${format(para_cdate,"yyyyMMdd")}' 
                and (b.packagemaster!='Y' or b.packagemaster is null)                
        ) a 
    left join tb_goods b on a.pluno=b.pluno 
    LEFT JOIN ta_Org_Lang C ON C.OrganizationNo = a.shop
    where a.companyno = '${para_companyno}'
    group by 
        a.pluno
        ,a.shop
        ,b.pluname
        ,C.ORG_NAME
        ,b.sno
) a
-- 门店总单数
left join (select shop,count(cnt) cnt from (SELECT a.shop,case when a.type='1' or a.type='2' or a.type='4' then 0 else 1 end cnt FROM "POS"."TD_SALE" a LEFT JOIN "POS"."TD_SALE_DETAIL" b on a.companyno=b.companyno and a.shop=b.shop and a.saleno=b.saleno ${if(len(para_iscoupon)==0,"","left join (select companyno,saleno,shop,bdate,sum(hIsCoupon) hIsCoupon from(select companyno,saleno,shop,bdate,case when PAYCODE='#04' AND CTType NOT IN ('KRD001','KRD002','KRD003','KRD004','KED026') then 1 else 0 end hIsCoupon from td_sale_pay)group by companyno,saleno,shop,bdate) z on z.companyno = a.companyno and z.saleno=a.saleno and a.shop=z.shop and z.bdate = a.bdate")} where a.bdate between '${format(para_bdate,"yyyyMMdd")}' and '${format(para_cdate,"yyyyMMdd")}' and (b.packagemaster!='Y' or b.packagemaster is null) ${if(para_iscoupon==0," and z.hIsCoupon = 0","")}${if(para_iscoupon==1," and z.hIsCoupon != 0","")} )group by shop) b on a.viewno = b.shop
-- 单品总单数
left join (select pluno,pluname,count(cnt) cnt from (SELECT b.pluno,c.pluname, case when a.type='1' or a.type='2' or a.type='4' then 0 else 1 end cnt FROM "POS"."TD_SALE" a LEFT JOIN "POS"."TD_SALE_DETAIL" b on a.companyno=b.companyno and a.shop=b.shop and a.saleno=b.saleno left join tb_goods c on b.pluno=c.pluno ${if(len(para_iscoupon)==0,"","left join (select companyno,saleno,shop,bdate,sum(hIsCoupon) hIsCoupon from(select companyno,saleno,shop,bdate,case when PAYCODE='#04' AND CTType NOT IN ('KRD001','KRD002','KRD003','KRD004','KED026') then 1 else 0 end hIsCoupon from td_sale_pay)group by companyno,saleno,shop,bdate) z on z.companyno = a.companyno and z.saleno=a.saleno and a.shop=z.shop and z.bdate = a.bdate")} where a.bdate between '${format(para_bdate,"yyyyMMdd")}' and '${format(para_cdate,"yyyyMMdd")}' and (b.packagemaster!='Y' or b.packagemaster is null) ${if(para_iscoupon==0," and z.hIsCoupon = 0","")}${if(para_iscoupon==1," and z.hIsCoupon != 0","")} )group by pluno,pluname) c on a.pluno = c.pluno
group by
    a.pluno
    ,a.viewno
    ,a.viewname
    ,a.pluname
    ,a.item_cnt
    ,b.cnt 
    ,c.cnt
    ,a.total_cnt
    ,a.cat_name
) 
where 1 = 1
${if(para_iscake==0,"and cat_name != '裱花组'","")}
${if(para_iscake==1,"and cat_name = '裱花组'","")}
${if(len(para_pluno)==0,""," and pluno in ('"+ REPLACE(para_pluno,",","','") +"')")}
${if(len(para_shop)==0,""," and viewno in ('"+ REPLACE(para_shop,",","','") +"')")}