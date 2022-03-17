/* sql 分类部分 */
WITH 销售明细 AS (
    SELECT
        *
    FROM (
        select 
            b.pluno
            ,a.shop
            ,a.bdate
            ,b.saleno
            ,(CASE 
                WHEN substr(c.sno,1,4)='0101' then '现烤类'
                WHEN substr(c.sno,1,4)='0102' then '面包类'
                WHEN substr(c.sno,1,4)='0103' then '蛋糕类'
                WHEN substr(c.sno,1,4)='0104' then '饼干类'
                WHEN substr(c.sno,1,4)='0105' then '西点组'
                WHEN substr(c.sno,1,4)='0106' then '代销品'
                WHEN substr(c.sno,1,4)='0108' then '裱花组'
                WHEN substr(c.sno,1,4)='0109' then '水吧组'
                WHEN substr(c.sno,1,4)='0111' then '中点类'
                WHEN substr(c.sno,1,4)='0112' then '三明治'
                ELSE '其他' 
            END) cat_name -- 分类
        from td_sale_detail b 
        inner join td_sale a on b.companyno=a.companyno and b.shop=a.shop and b.saleno=a.saleno 
        ${if(len(para_iscoupon)==0,""," left join (select companyno,saleno,shop,bdate,sum(hIsCoupon) hIsCoupon from(select companyno,saleno,shop,bdate,case when PAYCODE='#04' AND CTType NOT IN ('KRD001','KRD002','KRD003','KRD004','KED026') then 1 else 0 end hIsCoupon from td_sale_pay)group by companyno,saleno,shop,bdate) z on z.companyno = a.companyno and z.saleno=a.saleno and a.shop=z.shop and z.bdate = a.bdate")}
        left join tb_goods c on c.companyno = b.companyno and c.pluno = b.pluno 
        where b.companyno='${para_companyno}' and a.bdate between '${format(para_bdate,"yyyyMMdd")}' and '${format(para_cdate,"yyyyMMdd")}'
            and a.type=0 
            and substr(c.sno,1,6)!='B10601' 
            and substr(c.sno,1,6)!='011002'
            ${if(para_iscoupon==0," and z.hIsCoupon = 0","")}
            ${if(para_iscoupon==1," and z.hIsCoupon != 0","")} 
        group by b.pluno,a.shop,b.saleno,c.sno,a.bdate
    )
    where 1 = 1
        ${if(len(para_cType)=0,"and cat_name!='裱花组'",if(para_cType='裱花组',"and cat_name='裱花组'","and (cat_name in ('"+REPLACE(para_cType,",","','")+"') and cat_name!='裱花组')"))}
        -- ${if(len(para_shop)==0," and shop in (SELECT Shop FROM Platform_Staffs_Shop where opno='"+para_opno+"')"," and shop in ('" + REPLACE(para_shop,",","','") + "')")}
),
/* 连接层 */
门店商品客流 as (
    select
        bdate,pluno,shop,count(distinct saleno) cnt 
    from 
        销售明细
    group by pluno,shop,bdate
),
单品总客流 as (
    select 
        pluno
        ,bdate
        ,count(distinct saleno) cnt  
    from 
        销售明细
    group by 
        pluno,bdate
),
门店客流 as (
    select 
        shop
        ,bdate
        ,count(distinct saleno) cnt  
    from 
        销售明细
    group by 
        shop,bdate
),
卖了的门店 as (
    select BDATE,PLUNO
    ,LISTAGG(SHOP,',') WITHIN GROUP(ORDER BY SHOP) SHOPS 
    FROM 门店商品客流 GROUP BY BDATE,PLUNO
),
卖了的门店总客流 as (
    SELECT
        卖了的门店.bdate,
        卖了的门店.PLUNO
        ,SUM(CASE WHEN instr(卖了的门店.shops,门店客流.shop)>0 then 门店客流.cnt else 0 end) companycnt
    FROM 卖了的门店
    LEFT JOIN 门店客流 ON 卖了的门店.bdate = 门店客流.bdate
    GROUP BY 卖了的门店.bdate,卖了的门店.PLUNO
),
/** 中间层 */
每日万购率明细 AS (
    SELECT 
        门店商品客流.bdate
        ,门店商品客流.pluno
        ,单品总客流.cnt 单品_单数
        ,卖了的门店总客流.companycnt 卖了的门店总客流
        ,ROUND(单品总客流.cnt*10000 / 卖了的门店总客流.companycnt,0) 万购率 -- 公司万购率
    FROM
        门店商品客流
    LEFT JOIN 单品总客流 ON 单品总客流.bdate = 门店商品客流.bdate and 单品总客流.pluno = 门店商品客流.pluno
    -- LEFT JOIN 门店客流 ON 门店客流.bdate = 门店商品客流.bdate AND 门店客流.Shop = 门店商品客流.Shop
    LEFT JOIN 卖了的门店总客流 ON 卖了的门店总客流.bdate = 门店商品客流.bdate AND 卖了的门店总客流.pluno = 门店商品客流.pluno
    where 1 = 1
        ${if(len(para_pluno)==0,""," and 门店商品客流.pluno in ('"+ REPLACE(para_pluno,",","','") +"')")}
    GROUP BY
        门店商品客流.bdate
        ,门店商品客流.pluno
        ,单品总客流.cnt
        ,卖了的门店总客流.companycnt
    ORDER BY 门店商品客流.bdate ASC
),
单品万购率汇总 AS (
    SELECT 
        row_number() over (order by ROUND(SUM(单品总客流.cnt)*10000 / SUM(卖了的门店总客流.companycnt),0) desc) idx
        ,门店商品客流.pluno
        ,SUM(单品总客流.cnt) 单品_单数
        ,SUM(卖了的门店总客流.companycnt) 卖了的门店总客流
        ,ROUND(SUM(单品总客流.cnt)*10000 / SUM(卖了的门店总客流.companycnt),0) 万购率 -- 公司万购率
    FROM
        门店商品客流
    LEFT JOIN 单品总客流 ON 单品总客流.bdate = 门店商品客流.bdate and 单品总客流.pluno = 门店商品客流.pluno
    LEFT JOIN 门店客流 ON 门店客流.bdate = 门店商品客流.bdate AND 门店客流.Shop = 门店商品客流.Shop
    LEFT JOIN 卖了的门店总客流 ON 卖了的门店总客流.bdate = 门店商品客流.bdate AND 卖了的门店总客流.pluno = 门店商品客流.pluno
    where 1 = 1
        ${if(len(para_pluno)==0,""," and 门店商品客流.pluno in ('"+ REPLACE(para_pluno,",","','") +"')")}
        ${if(len(para_shop)==0 && para_viewtype==0," and 门店商品客流.shop in (SELECT Shop FROM Platform_Staffs_Shop where opno='"+para_opno+"')"," and 门店商品客流.shop in ('" + REPLACE(para_shop,",","','") + "')")}
    GROUP BY
        门店商品客流.pluno
    ORDER BY 万购率 DESC
),
每日门店万购率明细 AS (
    SELECT 
        门店商品客流.bdate
        ,门店商品客流.pluno
        ,门店商品客流.shop
        ,门店商品客流.cnt
        ,门店客流.cnt 门店_单数
        ,单品总客流.cnt 单品_单数
        ,卖了的门店总客流.companycnt 卖了的门店总客流
        ,ROUND(单品总客流.cnt*10000 / 卖了的门店总客流.companycnt,0) 万购率 -- 公司万购率
    FROM
        门店商品客流
    LEFT JOIN 单品总客流 ON 单品总客流.bdate = 门店商品客流.bdate and 单品总客流.pluno = 门店商品客流.pluno
    LEFT JOIN 门店客流 ON 门店客流.bdate = 门店商品客流.bdate AND 门店客流.Shop = 门店商品客流.Shop
    LEFT JOIN 卖了的门店总客流 ON 卖了的门店总客流.bdate = 门店商品客流.bdate AND 卖了的门店总客流.pluno = 门店商品客流.pluno
    where 1 = 1
        ${if(len(para_pluno)==0,""," and 门店商品客流.pluno in ('"+ REPLACE(para_pluno,",","','") +"')")}
    GROUP BY
        门店商品客流.bdate
        ,门店商品客流.pluno
        ,门店商品客流.shop
        ,门店商品客流.cnt
        ,门店客流.cnt
        ,单品总客流.cnt
        ,卖了的门店总客流.companycnt
    ORDER BY 门店商品客流.bdate ASC
),
门店万购率明细 AS (
    SELECT 
        门店商品客流.pluno
        ,门店商品客流.shop
        ,sum(门店商品客流.cnt) cnt
        ,sum(门店客流.cnt) 门店_单数
        ,ROUND(sum(门店商品客流.cnt)*10000 / sum(门店客流.cnt),0) 门店万购率
        ,SUM(单品总客流.cnt) 单品_单数
        ,SUM(卖了的门店总客流.companycnt) 卖了的门店总客流
        ,ROUND(SUM(单品总客流.cnt)*10000 / SUM(卖了的门店总客流.companycnt),0) 万购率 -- 公司万购率
        ,ROUND(sum(门店商品客流.cnt)*10000 / sum(门店客流.cnt),0) - ROUND(SUM(单品总客流.cnt)*10000 / SUM(卖了的门店总客流.companycnt),0) 差异 -- 万购率差异 
    FROM
        门店商品客流
    LEFT JOIN 单品总客流 ON 单品总客流.bdate = 门店商品客流.bdate and 单品总客流.pluno = 门店商品客流.pluno
    LEFT JOIN 门店客流 ON 门店客流.bdate = 门店商品客流.bdate AND 门店客流.Shop = 门店商品客流.Shop
    LEFT JOIN 卖了的门店总客流 ON 卖了的门店总客流.bdate = 门店商品客流.bdate AND 卖了的门店总客流.pluno = 门店商品客流.pluno
    where 1 = 1
        ${if(len(para_pluno)==0,""," and 门店商品客流.pluno in ('"+ REPLACE(para_pluno,",","','") +"')")}
    GROUP BY
        门店商品客流.pluno
        ,门店商品客流.shop
    ORDER BY 差异 DESC,门店商品客流.shop asc
)
/* 最终 */
SELECT * FROM ${if(para_viewtype==0,'单品万购率汇总',if(para_viewtype==1,'门店万购率明细','dual'))}