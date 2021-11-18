/* sql 分类部分 */
WITH 门店商品销售 as (
    select
        bdate,pluno,shop,count(distinct saleno) cnt 
    from (
        select 
            b.pluno
            ,a.shop
            ,a.bdate
            --,count(distinct a.saleno) cnt 
            ,b.saleno
            ,(CASE WHEN c.sno='010101' or c.sno='010102' or c.sno='010103' then '现烤组' WHEN c.sno='010201' or c.sno='010301' or c.sno='010401' then '工厂' WHEN substr(c.sno,1,4)='0105' then '西点组' WHEN substr(c.sno,1,4)='0109' then '水吧组' WHEN c.sno='010402' or c.sno='010701' or substr(c.sno,0,4)='0106' or substr(c.sno,0,4)='0308' then '代销品' WHEN substr(c.sno,1,4)='0108' then '裱花组' ELSE '其他' END) cat_name -- 分类
        from td_sale_detail b 
        inner join td_sale a on b.companyno=a.companyno and b.shop=a.shop and b.saleno=a.saleno 
        ${if(len(para_iscoupon)==0,""," left join (select companyno,saleno,shop,bdate,sum(hIsCoupon) hIsCoupon from(select companyno,saleno,shop,bdate,case when PAYCODE='#04' AND CTType NOT IN ('KRD001','KRD002','KRD003','KRD004','KED026') then 1 else 0 end hIsCoupon from td_sale_pay)group by companyno,saleno,shop,bdate) z on z.companyno = a.companyno and z.saleno=a.saleno and a.shop=z.shop and z.bdate = a.bdate")}
        left join tb_goods c on c.companyno = b.companyno and c.pluno = b.pluno 
        where b.companyno='${para_companyno}' and a.bdate between '${format(para_bdate,"yyyyMMdd")}' and '${format(para_cdate,"yyyyMMdd")}'
            and a.type=0 
            ${if(para_iscoupon==0," and z.hIsCoupon = 0","")}
            ${if(para_iscoupon==1," and z.hIsCoupon != 0","")} 
        group by b.pluno,a.shop,b.saleno,c.sno,a.bdate
    )
    where 1 = 1
        ${if(len(para_pluno)==0,""," and pluno in ('"+ REPLACE(para_pluno,",","','") +"')")}
        ${if(len(para_cType)=0,"and cat_name!='裱花组'",if(para_cType='裱花组',"and cat_name='裱花组'","and (cat_name in ('"+REPLACE(para_cType,",","','")+"') and cat_name!='裱花组')"))}
    --    ${if(len(para_cType)=0,""," and cat_name in ('"+REPLACE(para_cType,",","','")+"')")}
        ${if(len(para_shop)==0," and shop in (SELECT Shop FROM Platform_Staffs_Shop where opno='"+para_opno+"')"," and shop in ('" + REPLACE(para_shop,",","','") + "')")}
    group by pluno,shop,bdate
),
单品总单数 as (
    select 
        b.pluno
        ,a.bdate
        ,count(distinct a.saleno) cnt  
    from 
        td_sale_detail b 
    inner join td_sale a on b.companyno=a.companyno and b.shop=a.shop and b.saleno=a.saleno
    ${if(len(para_iscoupon)==0,""," left join (select companyno,saleno,shop,bdate,sum(hIsCoupon) hIsCoupon from(select companyno,saleno,shop,bdate,case when PAYCODE='#04' AND CTType NOT IN ('KRD001','KRD002','KRD003','KRD004','KED026') then 1 else 0 end hIsCoupon from td_sale_pay)group by companyno,saleno,shop,bdate) z on z.companyno = a.companyno and z.saleno=a.saleno and a.shop=z.shop and z.bdate = a.bdate")}
    where
        b.companyno='${para_companyno}'
        and a.bdate between '${format(para_bdate,"yyyyMMdd")}' and '${format(para_cdate,"yyyyMMdd")}' and a.type=0
        ${if(len(para_shop)==0," and a.shop in (SELECT Shop FROM Platform_Staffs_Shop where opno='"+para_opno+"')"," and a.shop in ('" + REPLACE(para_shop,",","','") + "')")}
        ${if(para_iscoupon==0," and z.hIsCoupon = 0","")}${if(para_iscoupon==1," and z.hIsCoupon != 0","")}
    group by 
        b.pluno,a.bdate
),
门店单数 as (
    select 
        a.shop
        ,a.bdate
        ,count(distinct a.saleno) cnt  
    from 
        td_sale_detail b 
    inner join td_sale a on b.companyno=a.companyno and b.shop=a.shop and b.saleno=a.saleno
    left join tb_goods c on b.companyno=c.companyno and b.pluno=c.pluno
    ${if(len(para_iscoupon)==0,""," left join (select companyno,saleno,shop,bdate,sum(hIsCoupon) hIsCoupon from(select companyno,saleno,shop,bdate,case when PAYCODE='#04' AND CTType NOT IN ('KRD001','KRD002','KRD003','KRD004','KED026') then 1 else 0 end hIsCoupon from td_sale_pay)group by companyno,saleno,shop,bdate) z on z.companyno = a.companyno and z.saleno=a.saleno and a.shop=z.shop and z.bdate = a.bdate")}
    where
        b.companyno='${para_companyno}'
        and a.bdate between '${format(para_bdate,"yyyyMMdd")}' and '${format(para_cdate,"yyyyMMdd")}' and a.type=0
        ${if(para_iscoupon==0," and z.hIsCoupon = 0","")}${if(para_iscoupon==1," and z.hIsCoupon != 0","")}
        ${if(para_cType='裱花组',"and substr(c.sno,0,4)='0108'","and substr(c.sno,0,4)!='0108'")}
        and substr(c.sno,1,6)!='B10601' 
        and substr(c.sno,1,6)!='011002'
    group by 
        a.shop,a.bdate
),
卖了的门店 as (
    select BDATE,PLUNO
    ,LISTAGG(SHOP,',') WITHIN GROUP(ORDER BY SHOP) SHOPS 
    FROM 门店商品销售 GROUP BY BDATE,PLUNO
),
卖了的门店总单数 as (
    SELECT
        卖了的门店.bdate,
        卖了的门店.PLUNO
        ,SUM(CASE WHEN instr(卖了的门店.shops,门店单数.shop)>0 then 门店单数.cnt else 0 end) companycnt
    FROM 卖了的门店
    LEFT JOIN 门店单数 ON 卖了的门店.bdate = 门店单数.bdate
    GROUP BY 卖了的门店.bdate,卖了的门店.PLUNO
)
/* 主逻辑部分,以下几部分仅能选一个，不能多选,请根据实际需要选择 */
/* 第1部分：每日万购率明细 */
SELECT 
    门店商品销售.bdate
    ,门店商品销售.pluno
    -- ,门店商品销售.shop
    -- ,门店商品销售.cnt
    -- ,门店单数.cnt 门店_单数
    ,单品总单数.cnt 单品_单数
    ,卖了的门店总单数.companycnt 卖了的门店总单数
    ,ROUND(单品总单数.cnt*10000 / 卖了的门店总单数.companycnt,0) 万购率 -- 公司万购率
FROM
    门店商品销售
LEFT JOIN 单品总单数 ON 单品总单数.bdate = 门店商品销售.bdate and 单品总单数.pluno = 门店商品销售.pluno
-- LEFT JOIN 门店单数 ON 门店单数.bdate = 门店商品销售.bdate AND 门店单数.Shop = 门店商品销售.Shop
LEFT JOIN 卖了的门店总单数 ON 卖了的门店总单数.bdate = 门店商品销售.bdate AND 卖了的门店总单数.pluno = 门店商品销售.pluno
GROUP BY
    门店商品销售.bdate
    ,门店商品销售.pluno
    -- ,门店商品销售.shop
    -- ,门店商品销售.cnt
    -- ,门店单数.cnt
    ,单品总单数.cnt
    ,卖了的门店总单数.companycnt
ORDER BY 门店商品销售.bdate ASC
/* 第2部分：单品万购率汇总 */
SELECT 
    /*门店商品销售.bdate*/
    row_number() over (order by ROUND(SUM(单品总单数.cnt)*10000 / SUM(卖了的门店总单数.companycnt),0) desc) idx
    ,门店商品销售.pluno
--    ,门店商品销售.shop
--    ,门店商品销售.cnt
--    ,门店单数.cnt 门店_单数
--    ,ROUND(门店商品销售.cnt*10000 / 门店单数.cnt,0) 门店万购率
    ,SUM(单品总单数.cnt) 单品_单数
    ,SUM(卖了的门店总单数.companycnt) 卖了的门店总单数
    ,ROUND(SUM(单品总单数.cnt)*10000 / SUM(卖了的门店总单数.companycnt),0) 万购率 -- 公司万购率
FROM
    门店商品销售
LEFT JOIN 单品总单数 ON 单品总单数.bdate = 门店商品销售.bdate and 单品总单数.pluno = 门店商品销售.pluno
LEFT JOIN 门店单数 ON 门店单数.bdate = 门店商品销售.bdate AND 门店单数.Shop = 门店商品销售.Shop
LEFT JOIN 卖了的门店总单数 ON 卖了的门店总单数.bdate = 门店商品销售.bdate AND 卖了的门店总单数.pluno = 门店商品销售.pluno
GROUP BY
    /*门店商品销售.bdate
    ,*/门店商品销售.pluno
--    ,门店商品销售.shop
--    ,门店商品销售.cnt
--    ,门店单数.cnt
--    ,单品总单数.cnt
--    ,卖了的门店总单数.companycnt
--ORDER BY 门店商品销售.bdate ASC
ORDER BY 万购率 DESC
/* 第3部分：每日门店万购率明细 */
SELECT 
    门店商品销售.bdate
    ,门店商品销售.pluno
    ,门店商品销售.shop
    ,门店商品销售.cnt
    ,门店单数.cnt 门店_单数
    ,单品总单数.cnt 单品_单数
    ,卖了的门店总单数.companycnt 卖了的门店总单数
    ,ROUND(单品总单数.cnt*10000 / 卖了的门店总单数.companycnt,0) 万购率 -- 公司万购率
FROM
    门店商品销售
LEFT JOIN 单品总单数 ON 单品总单数.bdate = 门店商品销售.bdate and 单品总单数.pluno = 门店商品销售.pluno
LEFT JOIN 门店单数 ON 门店单数.bdate = 门店商品销售.bdate AND 门店单数.Shop = 门店商品销售.Shop
LEFT JOIN 卖了的门店总单数 ON 卖了的门店总单数.bdate = 门店商品销售.bdate AND 卖了的门店总单数.pluno = 门店商品销售.pluno
GROUP BY
    门店商品销售.bdate
    ,门店商品销售.pluno
    ,门店商品销售.shop
    ,门店商品销售.cnt
    ,门店单数.cnt
    ,单品总单数.cnt
    ,卖了的门店总单数.companycnt
ORDER BY 门店商品销售.bdate ASC
/* 第4部分：门店万购率明细 */
SELECT 
    /*门店商品销售.bdate
    ,*/门店商品销售.pluno
   ,门店商品销售.shop
   ,sum(门店商品销售.cnt) cnt
   ,sum(门店单数.cnt) 门店_单数
   ,ROUND(sum(门店商品销售.cnt)*10000 / sum(门店单数.cnt),0) 门店万购率
    ,SUM(单品总单数.cnt) 单品_单数
    ,SUM(卖了的门店总单数.companycnt) 卖了的门店总单数
    ,ROUND(SUM(单品总单数.cnt)*10000 / SUM(卖了的门店总单数.companycnt),0) 万购率 -- 公司万购率
    ,ROUND(sum(门店商品销售.cnt)*10000 / sum(门店单数.cnt),0) - ROUND(SUM(单品总单数.cnt)*10000 / SUM(卖了的门店总单数.companycnt),0) 差异 -- 万购率差异 
FROM
    门店商品销售
LEFT JOIN 单品总单数 ON 单品总单数.bdate = 门店商品销售.bdate and 单品总单数.pluno = 门店商品销售.pluno
LEFT JOIN 门店单数 ON 门店单数.bdate = 门店商品销售.bdate AND 门店单数.Shop = 门店商品销售.Shop
LEFT JOIN 卖了的门店总单数 ON 卖了的门店总单数.bdate = 门店商品销售.bdate AND 卖了的门店总单数.pluno = 门店商品销售.pluno
GROUP BY
    /*门店商品销售.bdate
    ,*/门店商品销售.pluno
   ,门店商品销售.shop
--    ,门店商品销售.cnt
--    ,门店单数.cnt
--    ,单品总单数.cnt
--    ,卖了的门店总单数.companycnt
--ORDER BY 门店商品销售.bdate ASC
ORDER BY 门店商品销售.shop asc,差异 DESC