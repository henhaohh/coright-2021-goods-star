<?xml version="1.0" encoding="UTF-8"?>
<Form xmlVersion="20170720" releaseVersion="10.0.0">
<TableDataMap>
<TableData name="门店分区" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="para_companyno"/>
<O>
<![CDATA[66]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[NRC_DCPS]]></DatabaseName>
</Connection>
<Query>
<![CDATA[select distinct a.shopgroupno,a.shop viewno,C.ORG_NAME viewname,b.shopgroupname,case when regexp_like(b.shopgroupname,'事业部$') then 0 when regexp_like(b.shopgroupname,'区$') then 1 when regexp_like(a.shopgroupno,'^[A-z]AL+') and regexp_like(b.shopgroupname,'.类') then 2 else -1 end viewtype
FROM "POS"."TA_SHOPGROUP" a
inner join "POS"."TA_SHOPGROUP" z on a.shop = z.shop and a.shopgroupno != z.shopgroupno
left join ta_ShopGHead b on a.companyno=b.companyno and a.shopgroupno = b.shopgroupno
LEFT JOIN ta_Org_Lang C ON C.OrganizationNo = a.shop
where a.companyno = '${para_companyno}'
and b.shopgrouptype=2
ORDER BY VIEWNO]]></Query>
<PageQuery>
<![CDATA[]]></PageQuery>
</TableData>
<TableData name="商品" class="com.fr.data.impl.DBTableData">
<Parameters/>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[NRC_DCPS]]></DatabaseName>
</Connection>
<Query>
<![CDATA[SELECT PLUNO,PLUNAME FROM "POS"."TB_GOODS" WHERE COMPANYNO=66]]></Query>
<PageQuery>
<![CDATA[]]></PageQuery>
</TableData>
<TableData name="门店结构产品数量" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="para_companyno"/>
<O>
<![CDATA[66]]></O>
</Parameter>
<Parameter>
<Attributes name="para_cType"/>
<O>
<![CDATA[]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[NRC_DCPS]]></DatabaseName>
</Connection>
<Query>
<![CDATA[select
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
		/*-- 宜春十运会店不要牛乳小馒头,刘松这里不改,我这里手动弄了下
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
		and not (a.pluno in ('010102062','010102072','010502036') and organizationno = 'A117')*/
		and substr(b.sno,1,2) = '01'
)
where 1 = 1
${if(len(para_cType)=0,"and cat_name!='裱花组'",if(para_cType='裱花组',"and cat_name='裱花组'","and (cat_name in ('"+REPLACE(para_cType,",","','")+"') and cat_name!='裱花组')"))}
group by
	viewno]]></Query>
<PageQuery>
<![CDATA[]]></PageQuery>
</TableData>
<TableData name="汇" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="para_pluno"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="para_iscoupon"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="para_cdate"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="para_companyno"/>
<O>
<![CDATA[66]]></O>
</Parameter>
<Parameter>
<Attributes name="para_bdate"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="para_cType"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="para_shop"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="para_opno"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="para_viewtype"/>
<O>
<![CDATA[]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[NRC_DCPS]]></DatabaseName>
</Connection>
<Query>
<![CDATA[/* sql 分类部分 */
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
SELECT * FROM ${if(para_viewtype==0,'单品万购率汇总',if(para_viewtype==1,'门店万购率明细','dual'))}]]></Query>
<PageQuery>
<![CDATA[]]></PageQuery>
</TableData>
</TableDataMap>
<FormMobileAttr>
<FormMobileAttr refresh="false" isUseHTML="false" isMobileOnly="false" isAdaptivePropertyAutoMatch="false" appearRefresh="false" promptWhenLeaveWithoutSubmit="false" allowDoubleClickOrZoom="true"/>
</FormMobileAttr>
<Parameters/>
<Layout class="com.fr.form.ui.container.WBorderLayout">
<WidgetName name="form"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="0.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="form" frozen="false"/>
<PrivilegeControl/>
</WidgetAttr>
<Margin top="0" left="0" bottom="0" right="0"/>
<Border>
<border style="0" color="-723724" borderRadius="0" type="0" borderStyle="0"/>
<WidgetTitle>
<O>
<![CDATA[新建标题]]></O>
<FRFont name="SimSun" style="0" size="72"/>
<Position pos="0"/>
</WidgetTitle>
<Alpha alpha="1.0"/>
</Border>
<LCAttr vgap="0" hgap="0" compInterval="0"/>
<ShowBookmarks showBookmarks="false"/>
<NorthAttr size="36"/>
<North class="com.fr.form.ui.container.WParameterLayout">
<WidgetName name="para"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="0.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="" frozen="false"/>
<PrivilegeControl/>
</WidgetAttr>
<Margin top="0" left="0" bottom="0" right="0"/>
<Border>
<border style="0" color="-723724" borderRadius="0" type="0" borderStyle="0"/>
<WidgetTitle>
<O>
<![CDATA[新建标题]]></O>
<FRFont name="SimSun" style="0" size="72"/>
<Position pos="0"/>
</WidgetTitle>
<Alpha alpha="1.0"/>
</Border>
<Background name="ColorBackground"/>
<FileAttrErrorMarker class="com.fr.base.io.FileAttrErrorMarker" pluginID="com.fr.plugin.mobile.top.query.pane" oriClass="com.fr.plugin.mobile.top.query.pane.MobileTopParamStyle"/>
<LCAttr vgap="0" hgap="0" compInterval="0"/>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ComboBox">
<WidgetName name="para_cType"/>
<WidgetID widgetID="8667c77e-c270-4583-9206-262344ca040f"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="0.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="comboBox0" frozen="false"/>
<PrivilegeControl/>
</WidgetAttr>
<DirectEdit>
<![CDATA[false]]></DirectEdit>
<watermark>
<![CDATA[非蛋糕]]></watermark>
<CustomData>
<![CDATA[false]]></CustomData>
<Dictionary class="com.fr.data.impl.FormulaDictionary">
<FormulaDict>
<![CDATA[=['','现烤类','面包类','蛋糕类','饼干类','西点组','代销品','裱花组','水吧组','中点类','三明治']A]]></FormulaDict>
<EFormulaDict>
<![CDATA[=if($$$='','全部',$$$)]]></EFormulaDict>
</Dictionary>
<widgetValue>
<O>
<![CDATA[现烤类]]></O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="425" y="7" width="89" height="21"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ComboBox">
<WidgetName name="para_iscoupon"/>
<WidgetID widgetID="fd8c737e-b137-42a5-9cb6-cff882006d43"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="0.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="comboBox0" frozen="false"/>
<PrivilegeControl/>
</WidgetAttr>
<DirectEdit>
<![CDATA[false]]></DirectEdit>
<watermark>
<![CDATA[全部销售]]></watermark>
<CustomData>
<![CDATA[false]]></CustomData>
<Dictionary class="com.fr.data.impl.CustomDictionary">
<CustomDictAttr>
<Dict key="" value="全部销售"/>
<Dict key="0" value="现金/卡/免单券"/>
</CustomDictAttr>
</Dictionary>
<widgetValue>
<O>
<![CDATA[0]]></O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="330" y="7" width="80" height="21"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.parameter.FormSubmitButton">
<WidgetName name="formSubmit0"/>
<LabelName name="结束时间"/>
<WidgetID widgetID="fb4c2f7f-27ce-4482-a924-cb5b65e9325d"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="0.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="formSubmit0" frozen="false"/>
<PrivilegeControl/>
</WidgetAttr>
<Text>
<![CDATA[查询]]></Text>
<Hotkeys>
<![CDATA[enter]]></Hotkeys>
</InnerWidget>
<BoundsAttr x="578" y="7" width="72" height="21"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="label1"/>
<WidgetID widgetID="ffc77033-ffef-41ea-a255-7beab0503f04"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="0.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="label1" frozen="false"/>
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<O>
<![CDATA[结束时间]]></O>
</widgetValue>
<LabelAttr verticalcenter="true" textalign="0" autoline="true"/>
<FRFont name="SimSun" style="0" size="72"/>
<border style="0" color="-723724"/>
</InnerWidget>
<BoundsAttr x="172" y="7" width="54" height="21"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="label0"/>
<WidgetID widgetID="737b6544-5ba4-46f2-9269-1b199c2e205a"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="0.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="label0" frozen="false"/>
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<O>
<![CDATA[起始时间]]></O>
</widgetValue>
<LabelAttr verticalcenter="true" textalign="0" autoline="true"/>
<FRFont name="SimSun" style="0" size="72"/>
<border style="0" color="-723724"/>
</InnerWidget>
<BoundsAttr x="4" y="7" width="56" height="21"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.DateEditor">
<WidgetName name="para_cdate"/>
<LabelName name="结束时间"/>
<WidgetID widgetID="a962ff92-ecf8-4e5f-8470-2b376957980f"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="0.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="dateEditor1" frozen="false"/>
<PrivilegeControl/>
</WidgetAttr>
<allowBlank>
<![CDATA[false]]></allowBlank>
<DirectEdit>
<![CDATA[false]]></DirectEdit>
<DateAttr startdatefm="=today()-56" enddatefm="=today()-1"/>
<widgetValue>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=today()-1]]></Attributes>
</O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="226" y="6" width="96" height="22"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.DateEditor">
<WidgetName name="para_bdate"/>
<LabelName name="起始时间"/>
<WidgetID widgetID="029f5605-32ef-4e55-ba97-e54f8380cf1d"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="0.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="dateEditor0" frozen="false"/>
<PrivilegeControl/>
</WidgetAttr>
<allowBlank>
<![CDATA[false]]></allowBlank>
<DirectEdit>
<![CDATA[false]]></DirectEdit>
<DateAttr startdatefm="=today()-56" enddatefm="=today()-1"/>
<widgetValue>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=today()-28]]></Attributes>
</O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="60" y="7" width="96" height="22"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
<Sorted sorted="true"/>
<MobileWidgetList>
<Widget widgetName="para_bdate"/>
<Widget widgetName="para_cdate"/>
<Widget widgetName="para_iscoupon"/>
<Widget widgetName="formSubmit0"/>
<Widget widgetName="para_cType"/>
</MobileWidgetList>
<FrozenWidgets/>
<MobileBookMarkStyle class="com.fr.form.ui.mobile.impl.DefaultMobileBookMarkStyle"/>
<Display display="true"/>
<DelayDisplayContent delay="false"/>
<UseParamsTemplate use="true"/>
<Position position="0"/>
<Design_Width design_width="960"/>
<NameTagModified>
<TagModified tag="formSubmit0" modified="true"/>
<TagModified tag="para_iscoupon" modified="true"/>
<TagModified tag="para_bdate" modified="true"/>
</NameTagModified>
<WidgetNameTagMap>
<NameTag name="formSubmit0" tag="结束时间"/>
<NameTag name="para_iscoupon" tag="结束时间"/>
<NameTag name="para_bdate" tag="起始时间"/>
</WidgetNameTagMap>
<ParamAttr class="com.fr.report.mobile.DefaultMobileParamStyle"/>
<ParamStyle class="com.fr.form.ui.mobile.impl.DefaultMobileParameterStyle"/>
</North>
<Center class="com.fr.form.ui.container.WFitLayout">
<WidgetName name="body"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="0.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="" frozen="false"/>
<PrivilegeControl/>
</WidgetAttr>
<Margin top="0" left="0" bottom="0" right="0"/>
<Border>
<border style="0" color="-723724" borderRadius="0" type="0" borderStyle="0"/>
<WidgetTitle>
<O>
<![CDATA[新建标题]]></O>
<FRFont name="SimSun" style="0" size="72"/>
<Position pos="0"/>
</WidgetTitle>
<Alpha alpha="1.0"/>
</Border>
<LCAttr vgap="0" hgap="0" compInterval="0"/>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WScaleLayout">
<WidgetName name="para_shop"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="0.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="comboCheckBox0" frozen="false"/>
<PrivilegeControl/>
</WidgetAttr>
<Margin top="0" left="0" bottom="0" right="0"/>
<Border>
<border style="0" color="-723724" borderRadius="0" type="0" borderStyle="0"/>
<WidgetTitle>
<O>
<![CDATA[新建标题]]></O>
<FRFont name="SimSun" style="0" size="72"/>
<Position pos="0"/>
</WidgetTitle>
<Alpha alpha="1.0"/>
</Border>
<LCAttr vgap="0" hgap="0" compInterval="0"/>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ComboCheckBox">
<WidgetName name="para_shop"/>
<WidgetID widgetID="c606b8fd-4722-4aa9-84af-d1327ec24a78"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="0.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="" frozen="false"/>
<PrivilegeControl/>
</WidgetAttr>
<watermark>
<![CDATA[选择门店]]></watermark>
<Dictionary class="com.fr.data.impl.TableDataDictionary">
<FormulaDictAttr kiName="ORGANIZATIONNO" viName="ORG_NAME"/>
<TableDataDictAttr>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[NRC_DCP_门店查询]]></Name>
</TableData>
</TableDataDictAttr>
</Dictionary>
<widgetValue>
<O>
<![CDATA[]]></O>
</widgetValue>
<RAAttr isArray="false" supportTag="false"/>
</InnerWidget>
<BoundsAttr x="0" y="20" width="1020" height="21"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
</InnerWidget>
<BoundsAttr x="0" y="20" width="1020" height="20"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="report_STAR"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="0.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="report1" frozen="false"/>
<PrivilegeControl/>
</WidgetAttr>
<Margin top="0" left="0" bottom="0" right="0"/>
<Border>
<border style="0" color="-723724" borderRadius="0" type="0" borderStyle="0"/>
<WidgetTitle>
<O>
<![CDATA[新建标题]]></O>
<FRFont name="SimSun" style="0" size="72"/>
<Position pos="0"/>
</WidgetTitle>
<Alpha alpha="1.0"/>
</Border>
<LCAttr vgap="0" hgap="0" compInterval="0"/>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="report_STAR"/>
<WidgetID widgetID="01205e46-f63c-4e2f-a895-563bc612e6a4"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="0.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="" frozen="false"/>
<PrivilegeControl/>
</WidgetAttr>
<Margin top="0" left="0" bottom="0" right="0"/>
<Border>
<border style="0" color="-723724" borderRadius="0" type="0" borderStyle="0"/>
<WidgetTitle>
<O>
<![CDATA[新建标题]]></O>
<FRFont name="宋体" style="0" size="72"/>
<Position pos="0"/>
</WidgetTitle>
<Alpha alpha="1.0"/>
</Border>
<FormElementCase>
<ReportPageAttr>
<HR/>
<FR/>
<HC/>
<FC/>
</ReportPageAttr>
<ColumnPrivilegeControl/>
<RowPrivilegeControl/>
<RowHeight defaultValue="723900">
<![CDATA[723900,1296000,1296000,0,723900,723900,723900,1296000,1296000,1440000,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,2016000,4032000,4032000,2705100,2743200,2743200,2743200,2304000,2304000,2743200,3456000,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<O t="XMLable" class="com.fr.general.ImageWithSuffix">
<FineImage fm="png">
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320!n,@:beXK/O.Y-'beV$8kiq(D;DIA%2/g3@!s+_'q.AOO*L<K<GB
6I-3$q^<(FkZ_rB?E5ZUW17it\lj?e$>6,16X8*=ltbF54XVGk`*P,$kb9CHO57!X<GI"]ABm
a@1&nN)\V$dBJ;6MD&$*WjcGkLmNNrrrcJ%"^pjZIV/lF762Y"q)Aq-Q&pt<V#lSUbYklhtG
SaR9*Z'$OIno58<Xh6Q+`'5C!X2L^(C?WDlekZs<]A"RJiK1oSfQs9k8D:%2J<NDGiCW'_`YJ
>45]A`M:%#?hUl1hY7!G&:/ToJqik)XPlq33O8HJc,9-fap%G^JnZMLSt9XpYGOF)g-jWl]ABs
j,2YCSFX.]A.rX>BUt-P'-4HKKIP0rV&t/e~
]]></IM>
</FineImage>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsDefault="true"/>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition"/>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="1" r="0">
<O t="XMLable" class="com.fr.general.ImageWithSuffix">
<FineImage fm="png">
<IM>
<![CDATA[!CR%%r/"6F7h#eD$31&+%7s)Y;?-[s6N@)d6O3kr!!('^\8qWM!t.[g5u`*!m@)FbUG*+2.3
U!R#q:E<;F6uC3@21fPX#O(JJ,BoQ]AMD6Esiq,j"n!'NFWWWBD`HRrVH:TK$Z?HnJRf8mSEF
3bjT!>*Msk>=^.*D(m==g`&)gX9e'XD]AF@,"ZdmW-I3>[PVE5En31`2EXuM_/#d-.I3s_uKL
-$$NkRQd9KI]A_!a?JFbE3CtBN?5tX$hju1C\I3,63T*JDKNp?fBsb\&EBlM]A6+@`Y;"i0dr*
u-lmkbKbl6B`F9MkYJ*nGj@Klpph2aWQ>S2VY^?uh+ScQWO7dod<)Qst^m"r9j_Ysc!l+AK6
'(.Q>c@ljO#<"0ti<(BnE&J-OK=N4NdQg+hNsZ2[_T6^e.B(9?*+]AD60EB1jJkk':!5p(?!)
*c>VT8\-b;g$`7^ZV0JpNFr>k\;P!9uY>iArR?##YOm[g9iTI*&VBgV@d3C(ta-EsBKCn>la
\"9nlp\g^PZ_@C'5#Xol;0\AW=!F^Vs%O(n9.S#t[!IAT.L+NVg"\=d4%#b?;O8;Xf@n_HLJ
XEnHi<>GK@TM]Am$c39&"iM,?d/i24(kM;uJIr"3Mh;:gFIFmgiq!A*F@h(o/f@S)Is,N[VjJ
dM.`2PP>NQX+`+\$aB(mq?'Zi[^rZmYYJ\='^Gr)9'iHueZ$8l(M]Al)&nP(_UL!99%)F_=I7
,\2)3eqO2d_S,773UM&5n')1[@<m>XVF_D>@K\D\$^]A[NJX-PH?hQ\&_spcjs3@Wk<=!UqmB
eB97">W/aGDVd0`2U2$,[lQEVRS]Aoq"r!s&855.*272'nnYF$]A/%2PZ^q=SX`k+YXYP_Cu9i
XDiRl(7rVPu333.Fs1HJ4/MO*a:[gF`$:##L]A@;@.>"Q$BAgS4.N=eVlD0"8O+RsKFq")=m4
!ou.UK\0.M44lAr^@>p8EYY0@e]A.<3f4E(pqDid2I$XlU4iZFPnXdV5cY(id?K5,rkHS*]A5H
.AKHl![s!$V^4sPFP!&]A^?Rp1<u:B1@p!(fUS7'8jaJc~
]]></IM>
</FineImage>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="0">
<O>
<![CDATA[]]></O>
<PrivilegeControl/>
<CellGUIAttr showAsDefault="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="0" r="1" rs="3" s="0">
<O>
<![CDATA[产品星级]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$para_viewtype = 1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand leftParentDefault="false"/>
</C>
<C c="1" r="1" s="1">
<O>
<![CDATA[排名]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="1" s="1">
<O>
<![CDATA[品名]]></O>
<PrivilegeControl/>
<CellGUIAttr showAsDefault="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="6" r="1" s="0">
<O>
<![CDATA[商品_总_单数]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="1" s="0">
<O>
<![CDATA[全体_总单数]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="1" s="1">
<O>
<![CDATA[万购率]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="11" r="1" s="1">
<O>
<![CDATA[星级]]></O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0" showAsDefault="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="1" r="2" s="0">
<O t="DSColumn">
<Attributes dsName="汇" columnName="IDX"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=LET(A,$$$, IF(A<=5,'<span class="ani ani-flipInY" style="border-radius: 50%;width: 2.25em;height: 2.25em;display: inline-block;text-align: center;font-size: 1em;line-height: 2.25em;background-color: #090;color: #fff;">'+A+'</span>','<span class="ani ani-flipInY" style="border-radius: 50%;width: 2.25em;height: 2.25em;display: inline-block;text-align: center;font-size: 1em;line-height: 2.25em;background-color:#aaa;color:#fff;">'+A+'</span>'))]]></Content>
</Present>
<Expand dir="0"/>
</C>
<C c="2" r="2" s="2">
<O t="DSColumn">
<Attributes dsName="汇" columnName="PLUNO"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="网络报表1">
<JavaScript class="com.fr.js.ReportletHyperlink">
<JavaScript class="com.fr.js.ReportletHyperlink">
<Parameters>
<Parameter>
<Attributes name="para_pluno"/>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="para_viewtype"/>
<O>
<![CDATA[0]]></O>
</Parameter>
<Parameter>
<Attributes name="para_shop"/>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=""]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_dialog]]></TargetFrame>
<Features width="360" height="640"/>
<ReportletName extendParameters="true">
<![CDATA[/NRC/Reports/产品分析/hh_产品星级表_child.frm]]></ReportletName>
<Attr>
<DialogAttr class="com.fr.js.ReportletHyperlinkDialogAttr">
<O>
<![CDATA[]]></O>
<Location center="true"/>
</DialogAttr>
</Attr>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="移动端弹窗2">
<JavaScript class="com.fr.plugin.mobile.popup.js.MobilePopupHyperlink" pluginID="com.fr.plugin.mobile.popup" plugin-version="10.4.995">
<Parameters>
<Parameter>
<Attributes name="para_pluno"/>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="para_viewtype"/>
<O>
<![CDATA[0]]></O>
</Parameter>
<Parameter>
<Attributes name="para_shop"/>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=""]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<PopupTarget>
<![CDATA[template]]></PopupTarget>
<ReportletName extendParameters="true">
<![CDATA[/NRC/Reports/产品分析/hh_产品星级表_child.frm]]></ReportletName>
<Style borderType="0" borderColor="-16777216" borderRadius="4.0" bgColor="-1" bgOpacity="1.0" mobileRegularType="auto_height" mobileWidth="95.0" mobileHeight="95.0" padRegularType="auto_height" padWidth="95.0" padHeight="95.0"/>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<Present class="com.fr.base.present.DictPresent">
<Dictionary class="com.fr.data.impl.TableDataDictionary">
<FormulaDictAttr kiName="PLUNO" viName="PLUNAME"/>
<TableDataDictAttr>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[商品]]></Name>
</TableData>
</TableDataDictAttr>
</Dictionary>
</Present>
<Expand dir="0"/>
</C>
<C c="6" r="2">
<O t="DSColumn">
<Attributes dsName="汇" columnName="单品_单数"/>
<Complex/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="7" r="2" s="0">
<O t="DSColumn">
<Attributes dsName="汇" columnName="卖了的门店总单数"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="9" r="2" s="1">
<O t="DSColumn">
<Attributes dsName="汇" columnName="万购率"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="11" r="2" s="3">
<O t="I">
<![CDATA[1]]></O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=let(shuoming,'先将单元格放大10被取整,然后除以2并取余数,除以2的结果为整星,余数为半星',a,$$$,b,int((1-&B3/B4)*10)+1,full,'<img src="/webroot/decisioncr/view/form?id=__ImageCache__C4E6AA1ACECF15BFE54DCFF2E8396FBC&cache=true&op=fr_attach&cmd=ah_image" height="16" style="display:inline-block;margin:auto;" />',half,'<img src="/webroot/decisioncr/view/form?id=__ImageCache__DB43D89F29ECE83FD25677A7278E3E96&cache=true&op=fr_attach&cmd=ah_image" height="16" style="display:inline-block;margin:auto;" />',let(c,int(b/2),d,mod(b,2),REPEAT(full,c)+REPEAT(half,d)))]]></Content>
</Present>
<Expand/>
</C>
<C c="1" r="3">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=COUNT(C3) + 1]]></Attributes>
</O>
<PrivilegeControl/>
<Expand leftParentDefault="false" left="A2"/>
</C>
<C c="8" r="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="4" rs="3">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition"/>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="5" cs="5">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition"/>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="8" r="5">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition"/>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="10" r="5">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition"/>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="0" r="7" rs="3" s="0">
<O>
<![CDATA[门店得分]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$para_viewtype = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="1" r="7" s="1">
<O>
<![CDATA[排名]]></O>
<PrivilegeControl/>
<Expand leftParentDefault="false"/>
</C>
<C c="2" r="7" s="1">
<O>
<![CDATA[门店]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="7" s="1">
<O>
<![CDATA[品名]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="7" s="4">
<O>
<![CDATA[商品_门店_单数]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="7" s="4">
<O>
<![CDATA[门店_总_单数]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="7" s="4">
<O>
<![CDATA[商品_总_单数]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="7" s="4">
<O>
<![CDATA[全体_总单数]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="7" s="4">
<O>
<![CDATA[门店购买率]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="7" s="4">
<O>
<![CDATA[全购买率]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$para_viewtype = 1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="10" r="7" s="4">
<O>
<![CDATA[差异]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="11" r="7" s="1">
<O>
<![CDATA[得分]]></O>
<PrivilegeControl/>
<CellGUIAttr showAsDefault="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="12" r="7" s="1">
<O>
<![CDATA[差距]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$para_viewtype = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="1" r="8" s="5">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=seq(2)]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition"/>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=LET(A,&C10, IF(A<=5,'<span style="border-radius: 50%;width: 2.25em;height: 2.25em;display: inline-block;text-align: center;font-size: 1em;line-height: 2.25em;background-color: #900;color: #fff;">'+A+'</span>','<span style="border-radius: 50%;width: 2.25em;height: 2.25em;display: inline-block;text-align: center;font-size: 1em;line-height: 2.25em;background-color:#aaa;color:#fff">'+A+'</span>'))]]></Content>
</Present>
<Expand leftParentDefault="false" left="C9"/>
</C>
<C c="2" r="8" s="5">
<O t="DSColumn">
<Attributes dsName="汇" columnName="SHOP"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Present class="com.fr.base.present.DictPresent">
<Dictionary class="com.fr.data.impl.TableDataDictionary">
<FormulaDictAttr kiName="VIEWNO" viName="VIEWNAME"/>
<TableDataDictAttr>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[门店分区]]></Name>
</TableData>
</TableDataDictAttr>
</Dictionary>
</Present>
<Expand dir="0" order="2">
<SortFormula>
<![CDATA[=L10]]></SortFormula>
</Expand>
</C>
<C c="3" r="8" s="0">
<O t="DSColumn">
<Attributes dsName="汇" columnName="PLUNO"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Present class="com.fr.base.present.DictPresent">
<Dictionary class="com.fr.data.impl.TableDataDictionary">
<FormulaDictAttr kiName="PLUNO" viName="PLUNAME"/>
<TableDataDictAttr>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[商品]]></Name>
</TableData>
</TableDataDictAttr>
</Dictionary>
</Present>
<Expand dir="0"/>
</C>
<C c="4" r="8" s="4">
<O t="DSColumn">
<Attributes dsName="汇" columnName="CNT"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="5" r="8" s="4">
<O t="DSColumn">
<Attributes dsName="汇" columnName="门店_单数"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="6" r="8" s="4">
<O t="DSColumn">
<Attributes dsName="汇" columnName="单品_单数"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="7" r="8" s="4">
<O t="DSColumn">
<Attributes dsName="汇" columnName="卖了的门店总单数"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="8" r="8" s="4">
<O t="DSColumn">
<Attributes dsName="汇" columnName="门店万购率"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="9" r="8" s="4">
<O t="DSColumn">
<Attributes dsName="汇" columnName="万购率"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="10" r="8" s="4">
<O t="DSColumn">
<Attributes dsName="汇" columnName="差异"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="1" r="9" s="0">
<O t="I">
<![CDATA[1]]></O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=LET(A, &C9, A)]]></Content>
</Present>
<Expand leftParentDefault="false" left="C9"/>
</C>
<C c="2" r="9" s="6">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=C9]]></Attributes>
</O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="网络报表1">
<JavaScript class="com.fr.js.ReportletHyperlink">
<JavaScript class="com.fr.js.ReportletHyperlink">
<Parameters>
<Parameter>
<Attributes name="para_viewshop"/>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="para_viewtype"/>
<O>
<![CDATA[1]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_dialog]]></TargetFrame>
<Features width="360" height="640"/>
<ReportletName extendParameters="true" showPI="true">
<![CDATA[/NRC/Reports/产品分析/hh_产品星级表_child.frm]]></ReportletName>
<Attr>
<DialogAttr class="com.fr.js.ReportletHyperlinkDialogAttr">
<O>
<![CDATA[]]></O>
<Location center="true"/>
</DialogAttr>
</Attr>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="移动端弹窗2">
<JavaScript class="com.fr.plugin.mobile.popup.js.MobilePopupHyperlink" pluginID="com.fr.plugin.mobile.popup" plugin-version="10.4.995">
<Parameters>
<Parameter>
<Attributes name="para_viewshop"/>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="para_viewtype"/>
<O>
<![CDATA[1]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<PopupTarget>
<![CDATA[template]]></PopupTarget>
<ReportletName extendParameters="true">
<![CDATA[/NRC/Reports/产品分析/hh_产品星级表_child.frm]]></ReportletName>
<Style borderType="0" borderColor="-16777216" borderRadius="4.0" bgColor="-1" bgOpacity="1.0" mobileRegularType="auto_height" mobileWidth="95.0" mobileHeight="95.0" padRegularType="auto_height" padWidth="95.0" padHeight="95.0"/>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<Present class="com.fr.base.present.DictPresent">
<Dictionary class="com.fr.data.impl.TableDataDictionary">
<FormulaDictAttr kiName="VIEWNO" viName="VIEWNAME"/>
<TableDataDictAttr>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[门店分区]]></Name>
</TableData>
</TableDataDictAttr>
</Dictionary>
</Present>
<Expand/>
</C>
<C c="9" r="9">
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="9">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=count(K9{K9 >= 0}) / count(K9)]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="11" r="9" s="7">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=K10 * 100 * 门店结构产品数量.select(CNT, VIEWNO = C9) / max(门店结构产品数量.select(CNT))]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="12" r="9" s="7">
<O t="I">
<![CDATA[1]]></O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=IF(&C9 > 1, CONCATENATE("+ ", ROUND(ABS(L10 - L10[C9:-1]A), 2)), "🏆")]]></Content>
</Present>
<Expand/>
</C>
</CellElementList>
<ReportAttrSet>
<ReportSettings headerHeight="0" footerHeight="0">
<PaperSetting/>
<Background name="ColorBackground" color="-1"/>
</ReportSettings>
</ReportAttrSet>
</FormElementCase>
<StyleList>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-1381654"/>
<Border>
<Top style="5" color="-1"/>
<Bottom style="5" color="-1"/>
<Left style="5" color="-1"/>
<Right style="5" color="-1"/>
</Border>
</Style>
<Style horizontal_alignment="2" imageLayout="1">
<FRFont name="SimSun" style="0" size="72" foreground="-14701083"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="2" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="128" foreground="-236032"/>
<Background name="ColorBackground" color="-1381654"/>
<Border>
<Top style="5" color="-1"/>
<Bottom style="5" color="-1"/>
<Left style="5" color="-1"/>
<Right style="5" color="-1"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Top style="1"/>
<Bottom style="1"/>
<Left style="1"/>
<Right style="1"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Top style="5" color="-1"/>
<Bottom style="5" color="-1"/>
<Left style="5" color="-1"/>
<Right style="5" color="-1"/>
</Border>
</Style>
<Style horizontal_alignment="2" imageLayout="1">
<FRFont name="SimSun" style="0" size="72" foreground="-14701083" underline="1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#0.00]]></Format>
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-1381654"/>
<Border>
<Top style="5" color="-1"/>
<Bottom style="5" color="-1"/>
<Left style="5" color="-1"/>
<Right style="5" color="-1"/>
</Border>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<IM>
<![CDATA[m(@OAPA/W4MNnbW7VO>=*0K*R-rM96+p^S%5e9Pm!Ke9S_2a*Y.8kjJ/^gI?<E)4uJ,k]AM3e
RJ6dNBgr,l5eFcA_A/n$daYXg?S]A^\Mg;a`Hpamp3*^^9?VN'k9C%Nh[S1Ci#X<QS+Z2Z0`-
7A(tShb?j=<DI,>DRuOOh8H4;8e_jM%p%rHNc=n6:&jb57(X<n<m_]AF65H&jup%IeC'+rLre
HMO^/h)k;,M_.b><Hq%*]Ar%:<U;7PE?co$:3J8ENj'>T4>L#!0^M]ALS^,UWUl)`&Y3Mpf7*m
',a,r=o1sKsAPO`I[Yh_=?$HLnmTai6>3Ge`ehf,gO[+*G=7Vidj;oFp5cd%')pOhpKSE<t(
,Y4D4#C\S4gP@jd[.Y%rRqO\)g;)F^QbW5UF'Q*(F?5-Ym'1bHT?9V:2tUg)n=%E1gM(ih7M
@??dMe06HpPk,7Sq8sW<d^i6ThZPKl^TD>gB2'B"]AWUl'VN*[coVjQ2,o:TCDsdq*dGJfQ?e
aG-(FFrPIU>qYRHgCK#P:eLfRXVpo4R&?[@VF7M$L9>_N:nZcuBCR6)XSDNoLG&H$$oR07eM
a&Y<*+\\0@ra6O/oCh6H0EA*Suh*68pDVTB,(.oR;2KXI*@J_E&gNdC*r\r$h7*F^]A*@NeI6
N1*<fh6)gJ*F>?>2#d!tQD@RR:47r0KT=S>=%%h7"F5[F-`@9j0A[JsceDS8FnijcVG%9%n<
lkU2Ip&5'n&=2gE/<OQO7q#K6Qmj$\<AXAY<N#G0,bT#6-u3\`dY.t:F_%R+7r6KM37Iog"L
"bcIX-E^f(ns&*T3!KXM<X,Z_q*_Me9Y<ePY+deo)/8P]APWnoT\Ed8cg#s^6np3=HKV%Rj-<
<NrR,+\@(!2[jNWugWt:C^/cuugg/_=o4#GsTWJc!Ja5Al?$;&ui.n1@"kI<=^R/c$2`S"7S
:Yki&RqX6WMki[nkd.]AamM.l/iGVS.fm;W!uKWT4),;uTDJQ:^"nTR0<+GhZW-L'@]ADNOb]At
M!iV]A(ZYu+qq>:$m-TkXY'Z4!l0lsB*X_;*K&Ru/rA9"&@s^-beHkNG>"RFR)^?aQ*`@4oU'
mkL-iQAH$?Sff+e77?cP=d6[E9__U*p$b6r4+GQ,cCoBY-8i5[Q\GuFligGH#LG+$P(JB9:U
<XMp&JI/.MlX!C1Y@b7QU[s)&^WdhgXR99?<AKj:<@2*KJmMb?XotQU[63\8-lCLq)QNmr@K
U0r4.bSS`]Ab^inp1WQ5<>kcJ.+NFtqs[bP&0=A8@jIjfG<iUV`.'(X`Y?=9/-JT]A;$rVKKsg
=ep+p7ic)Dh1Qb1BWrNoZM+$0qb1@\]AH$"$W]A&t#oZoEPlVB9!'/$RE[\WIG85MHS\=LIlhs
0Zcbpm9Uq=6sq"j[3rQ!QFF-RYEn$p[1]AERpbbD'Y(h)$]A4.CaYE'Z7QYqulrH3f:X(o)*Y$
\=O>b]A:F`\p&s2ThqOjN=g`8uCZCCBZ=/e;2b1LL[A9)d:*">$E,6mdOEje,2VMu;A25HoX+
%H'cbH6o=4)Kmm2p2.0G*:?gV1=qIl=TbXrh`"AmnT+8gu!_AiOLJ^t>$$!9cK@J`E$'n2:4
,Q9TCB4Ms`f>=ha[,4t_k)Yk2T+T?su0A&`ZUK<co?XfTdgR=CNAt7@,8?ma655:2tB'/sI6
i@`\Q/_n8bcoh'O-Z,-?IH%Mm/cksi\QY"?b:7-Z)]A*Zltj'VX"cU%1SnB62\^<P>NmMT(K[
AYYpOPJC&'C&F?AcCO2U)<`O-&5/Y?NcM@G1>%_:bqG?h_g/FK'!k-9<FUg/s9H)_gS1m8Ok
3;jcpH?K_U>qo`\g!aBqDk0KqEXW`kr2$;.*^$k![-uN-:5ir?p>+2hK/06Gl/GWHmr!\PWO
bJdgEaqpj[B9\K,NULq>s1AQ7VUF+6f_6U6tlTV8B'ATkVX_8Lcpg7hoo*)YU0L$[K3d3Kj,
+-Tpnj]A2P/*YUt#)PkI@8nX+7fq)npr&WsbkiSr(c<9:C@<fON5"a>cGRIt?Vir]A#52n11kW
)Z4Z'W0;u2$(4fE%T/%-rhHdd&50B';0LBiD&LhKu:27S4Aht71!b0<D#*?rK'5?AjsOW"&^
eY;MBZS^'PT^GA(5s&_,UEOS=YH1K"qLm^T7iQQ<A4;(&N$!D2H*"?Ja3lI0OCd`GFMnp0#!
)kRn\3l9,&lW2?LO<J\eY5RCSpqd/:S&#,+p^mZkm"tC\UC(guc@5KnClBemQ*?]AS.Qo+>KQ
V)%L7ORRA2lq-"ue>2:,^Em;#/8Iai0k8,4ed+#&oTShSr_Zb1I-"8\PD`4>S&F(hWXLNdR\
''\mYOo?QUT'B_pTOV#&K9'(l<R5k,Ii\Xk06?lg060N?CV;?13J@O1a^'^dH6NLuI!aBu;)
n)`Um83V)@Ou$$@;@/28t-"j_SViYK`5XMJ;Djdh1a1_%JjD3FR"d^Ab!rKRfK1P.md=o[t\
b_44"G2!'pE9n9gZFZbpb>=g.&qTa$sh*+h9^N)eUIE+=Q::^D$Z-^(+2$jm_ef.^4s.4K`&
0J?SIY8NEK,3m7.l5!P6!9j_`.<otVKY13'NFpPSJ[@?bMTufm\fgqGp,mL>n`ijP&1J,qgO
Iq^jZifu:<CNkeJ\hkFXerB@lC*C.QT_h%\jtHc@.14I?USeR6Z=;;;E_1<bh6<cAWUgC%FR
s,I[rbeY:JGg$$m.3@Y]A!rG2?k+#*A+>$>\F;"el6NhDV`)c7%"JR&Ynil5uRW7Le]AOmE0D7
u%mfs.tb8jsB;OFc-Wrhc1n\U_]A,)%/;-pc,ju0`^SGna&2Y3\sc1<DIZ<Lq!)Rr`h^LU3k@
FWfsR8PSfh#&#f7S^Sr$TDCntVul5U_9*Wp]AMgB?Xkp;pMiL-^NA59JYblEYI=(Tc-G[29P,
,<h*$^@r[mkjX"t'/WbJ=R)5+-'#*QWSTLL@J#")cmHJu6-"%^iKt]A0cegGK;#*[89,H4Q!S
g05'"YM!cL]A*p<$Ibk22%YB2Zc20@,K=@e<>YNZT21fQ6$\,I*Af4FV":fF0j/!lSFBe7-gT
lL"?sZd.E89_Eb/XVnRNC1[&0O.aH'[PN,N@IdH:Xf)]AGkp!gs.qL]Aa'.9bo$mI29bYdMMlk
F_P)blfk@G54ss54p0/#3k!)?2Y;E[1:[6TLJb<j;Vg0.2q,BLKf1_>K'WS/O1aFA@CM)emt
+h#/Atss([*#Sqs?%,eB%5WUj*,oMBoug&Xf&M5+,-PB4QkM7loT[_@).9fr>86Y_A4i3[Y*
Y8l!?P\?-9PGWWr@P^K4eX+I'kShc?8>iLOj$/)e\"&H7EVskkF22T?9T/e\.7Rb.Y\#Q]A%%
]AE]A8K!u:gL=oP)OY$'geKBqK^q')d):Q&0Ep:7=SZMbF_)iGp<GGuZJ0T7AQ)%)=3k7dj\=0
r?<t;8l,b8^pAfMPJ+Fu-d42\Rh.c.fH)JX2-!B!f(V]AWc4*62m:n+7B^C'eE7-TjKX'13E2
th@1_J%EQ;-nh6@+U:o[@:Slb]A96Brt6PC(QgZi2]AVL0`0#b^&rnbVCn&n+_.@+NONAO6da3
0if=2)f?I<Jsj_U(LM([f^J]AA)aghJX/H-X10c7;?qhFqtGQ@WR<]APl^IX'2SfL(ifGLJkCo
.+1BlW`\bd4*=iCVOCWN"6g(AK\;F]A+Z8KpVVdhQp2d6m^8@'["`=(u*q:(SOgZebmSBLeKM
qc8a[_@D$]AZiM@WFa'm^"!EBA[YrX08%)>\^<\lulc5dG%ss`6q<aS;;C9LmJIdj_Tt;9e4-
4^C4:N+C\S8^:`*L=3f_J^*1bs\;j-0+XYdQ3^<%q;Z1f1+jpc;2S"0HX3E]A>o8^5.>'*n+'
:F`il&tY;d4Nk<'Ca7Af/(5c\-6F%9fP-^-h9:,`p16Gkgm%3[;]A/6oZV74a/1O%)`ZBNq3j
jH@;T"<&[RhhX.,P%#rD]A=hm9iL_W]AP'??m?!c42IE@2KH4FKH6M7[fV]Ag0`tiNFcq*a!#\J
:Y=r0Q"rk;l-Ar]As)B@udPeQ'J&Ud$M4jEHh_V^M[eus1'!T-KRh6rap8u=?NE>_KK%u6'0q
gW`1bBY)$$B:.Ls;<\-3V/aSP$s4h,YSYL-edLi3IKZpQul:X_#7PoslmbH"bqS6AR)V<g/j
-_KIaRVPs_]A7/"5R&b-]AGn<eR=5o!uJ)4GF=I.iLXp!GrEg8m$+K`5u+4:sJ2cnWH)lgsU3#
hgnEe'S3%4'V-aU0*,b?fseV&G=8gXitId`OB3^%=1IA[Sd<N@/H:uC<r,As$C=p[-HCK:0V
,T*D.@D-\\(SM-sV!,s61WEYbqS!Rm)l:iZYT]An;>,=,F_]AQ)P0PnXOdg3?HPBc+]A$`d>oK.
?>lLdir`sMOI6u8Rp2),jW'p+DWA"j4j=J-Q_3Zp96hj'e`W)8BcXt$]A$i:BaP8-MChWl<15
aO)QbYN,qQ>PonpeP^pPo3-\_<GGn%EKS>bej'+=rPOC'?)L>>N`"$b2BX6iCBP^e:^VXT.@
5T-.u?;ms^45h]A1aW'PD!7ka0T`T?mV<R9.tGfi6kJ8ZV1)/_q>"+*I)VK6L==tPaHH2dQZZ
4.]AknUaha\O@J4Nu[-uBM0-'NRrQ%C/!PYK)#>]AmfW%>L1Ej)"\[S$V[oL$HYBKC"A6J#16!
sM@AboPdn9/Da*4sYj.4EOHIq&A:F3[-]A`t&Spb>A*ddYJqG<MEkZtqh6/]A>&l*#uGYF$]A\!
`oO)rqVle5cjoMA1((YA2lW-7s0pi-qF*fqBYde^:s;\TiIH-K]AF&8cr#","d"cG,/92Jj$8
"t*ou]A8UrXb1fmi]A6W3O;#BF;tF2S!9.f]AmoV)d-(2o,QA5%1YXrBR]Ag=,RZXT6VMsfo\@>I
3`*)Q#+RSK$kUKBWXNPR2<)9DI$=%`;#BFMs&I[`W0Xii:`3-c#VsE6TW&.2DmUKar:m=mEX
a!!La[to$B4FT_55dqp[p>/V?OH)(XOi+]A:gAL6I#F.,Tu,A*'Q>QQQ,C4U.s_+NMI+.kF.u
A.o#Jdd?iJ#K5GPYJe-KBi;8*V*:7.ABnc0$ZRVPcQ9Q6JXL>kW7bBNWV9^;NHr/<%oB0(=P
Ee6Lo*J"]Ap7lr/:@]AOKY0Tk0\%eI^24?:@qXT>f*CVn!<f=KfB=lb?*.1p>Pr<Ig=YjeC.=P
`eU4(GB1#TpbYl+1)o`l'4lZ&Hhb0nZ]A;lc(O^KnXEn2W9O-eJSb2reuuIKiT7eqJ@i!r;e:
^WJ::TqJEQ*5eS_L46b_:8t`ZE)tj8'>7+m!.JnjfZYpoI5b&$Ef6O69"Z`qq'%o9SAKl2EJ
/T`!&lpS2dCi)M44`lB9&9Z7JH?q7&7Dt7#WA1,2K6_TTYasI*4h4i&j8H/:IbkP[>OHF$6I
4$&0LS;f(4_DC$C*E@9!ro!RFrWShc<>0[;CJ4/u/J;HPrL`u]A9e8D;ujA2+:0,@"n0&LX.k
I%E?s@a8?6f<K+PIRNO0$p+Mb,IO'/h2EVO:0ECQhglb6b62J,5CH*Dn*ls,k\C\Y^)^/"[W
Y6OIIBV4R=-Q.<%OYHNFZVl7b`<+0[SjUgLQ%;mHltP#US(CQ*X!T",k9l/6Z=T`R$5(Q5fp
;GUTE>S4Um"]A@HET%Ffr<Emf=EY/h$*!9"[*`bGR`C&5D-A+50o(u$STR\'OR@Xe9GG&0X6q
[]Ada6e5YJ50#)mhf3:X3J.X84>/:T[E@#PQ+H,049OuPf9DK7&V`5ulfYjUrA?.n_6_.Z>Bd
'Lmgdi=^Ps]AGfT9\;)%/E89dK3n/I=:PR7rWZ2H"PC]A_n0$dAc6NO7s%C1$Pg(eBXRCqdXE.
.oRJblfQY`qb\JD+fcQpAO>dtKE_:P9<)'C),b6\g':noQ[]A3\QXHcH[Q<f98BVST>q-F5Gh
&q(/1/!+^\KbD&,c:6^.Fsf%h7eY1H@bSd1+)El15_AdMh\KHQ!#bBm"NsO,F,9N=20]A(2)Z
#-Odl,SK"FUdZ_\OAqh;fA8`eg[[&0'VIN@4>QYaE>d=-8>J-aLmD7&7N0thjGbIcC;FqNVd
/g6c%)lg+js_H2r#UHD+[d!`e(-S92H@N&%4%.G!iQYe16f)M*%(UYoh$G*CC)N]A+"Xc4P/Q
dqJfYD8C=W^SU=5MYci2Yq40oer'Q2Z'V`)h31qo!s?+1/6?H"Y@4F)HK>410IEI\:'L?TpK
(^Qn.rp$Z/Y4(PAH)kPAL?t&,m?aT4c483'HMdF0!q;)Y.P,`(?XBh[Fq"/S$<b*.a9<#10H
h%S]A^!MT_ZAoC/";@[/(L9Q`M*knA?\jueVql2s+ro/4tsJnHnWAdm8#u`ksV`2p@73"hP8W
\rD\nXA?Fs6eB5,cZJ1QbnKG+r&_'iM6WFt`jALfR;lT!#mH(A<&5T5Pe_X`pUO]Ah/-?.=OU
ceF)nFsiPglJ,5Xb:^,nfrT\5Od[f;NqRm:TQkXZPZIrT?0./BRgDQD`]AMP;7qW\Q!\It-S`
`2f4pSI"/J8Cr7*OO&-XEr"kDeFc=9X0D7$6<f9h8U_k7ImplHK*&"bn\an21hNP4h)E9k\9
7e^SGY]A"OL4.2U'cY;!i9KdZ-qIm0tCCsEGr,E5&d6CnbBQQr_mu-4b*SbJult.#)7gb[*-Z
*9RXgp3d:gp5@?2XS&D>\599LJLT'1o*o)0=[dnHHQLeRsH`d\p[D=tFSug;WgTBdFj[3!pP
+'VhYYgs5T_i1Z3ZiWe+G6lT=Q*U&EIMr0oJp4E0`.u`4(=6nmcVbM8Q1)s[Vh%F;]A;n)HG/
8GG-[dD,//Lns"(cll&"D$:^U,FKl=]A_gHop#;'EgD!U@'"Qek!jf.-+/hT<nTWA$UUsGZpm
$`6Gbd'gZ'A6Mr.>`*qS\si!.(AEDns-Ndj-GcS5RbOC`R0j-<c4;QdthHRVH"(Ab3cH`"1u
jQ!"`O!A,5HW@$#,JD`$A8ficTZW%<NJno!mbBEAU4%io]A!X:tCi*sukiIK,9X^8Q"2WZ,HU
;u*1b#23bI.*LO8cU8MbaJhY<]AP;jtMef?QQtJ9+8jSQC-6eU0qmW>Ae[de]A28]A^&2XiNmWk
/<Hd\Zf<sHg6j$9LE2'T&j7siF$$!3%N/h6`BaeJO_oFnD6nt[8_XH-,W$"rJ9PiFmo[_L"4
:jubL3ocfHKs%*_fZ"5#HWP3fqR5F\k]A$XlGn`Ab8H6D:If]A39f6kd6-?*3r2)jYQmF,bGTp
':>E,Mk[9Nm5p;3K8Ff[4C^J]AtCdNTq]ADljLl,flF.$\u7.gr3XVILn8ST09p20R(I5Z+`)[
.ab*1V>@`B.r\.,rK>V"pdI&#mc>*<N-(n3oJNq]AKRmib_6H4U=M'bSWIP@=il8FMRbN!F'#
Fho?lY]A.?W=AqJm\CQNp!J[T&tF>O<oq1^m;+Mbn3gU>9eb&BoI%?J]A"&24b['p*@bR&fAC%
C5+$7:<;<i&e%s"bCQALpoGZ9#F^JTeIFEmd)^"QRT'\rOe?-2Q.g_#p9Hpp2b!<#Y![8m7f
=d\EB)qS5R)Z*2km%pRBjJNIQ0Tb0%\>c1\.Cdq9RJM-fWKB/=MIje[Pnl(]AmW+=cUX2E*4Q
^&au>b*dN$*dZ.P[!8=\!toerXb;%UKKrOBR6(9Pg`NWhVA_?A;l-<\JUc/tgU6d`N0Pos&c
<debBn4:nq_7n*LEqNUnZ6>X8bWN,/J=a(d9kcl"o$V75&KaI`,rc_R4T&<RSoiqI(?WbKU^
'%tO5[0)_?043hF@O9r>F1".&H[iqm>19G9T6LiYE;rPIQR59TQ$I3JS%#jXP;tNg,!(q!+p
eI7g/P'ok(#N0>qil@&RV7RW:pkp1Z5RkR@Oq_4]Asj=P-HP0o\kcgi-or]ASuiVb`J36Y3FrG
R-K4#\XN@bq4*gO"sbnK^8[3p=8MJ#BZB,_Yd33W:X=!_&h8^(dBXK">R6HksrBo%Wtqh/":
F8@cV>TQ`T_kn^&JAr-lZN^;`H,13hJ[5`Oe2W0XtI%1"rfZ*UKjA[E8:DcVMB`haQ[/IJ`'
INuulo&_oNFl$Nm2;B@e5Ag5Yr!]A=WDnLI7&j%a<.U0m5=Y,;^e3Ipq1BA`AqS78;BYJF=P*
ANE\L5,.m^PS(A)&ra*N;ETLZ&8nVO1BBen"[#Fh+12!+o7l;jgdBm>&gAP9gWlk9N=s]AV>:
KPg,Y\FX-^'O!qPDq5*^lB?)W1rIj=G5G'5Noo?_c2#e:'Qh'"GR4"mWA#;@+f?`JC2gH##O
Op\h$\lBTf8@.d#8b`H8AX/Qga?E8!9Hip#Hh!KSO\YN%_)Ofps_O%j?4WQ>&-5gO_CSHH/f
E$dFQQ<K!'1$bhF[ga2D0".t`iR"Z6?rjr>&CH'qKbLhC;49?ecRhnF%Xb&d03>4LeUR>)#1
>FFN:Z^KMpE2$C]A!,@VmEdTpKV`a<k\)/"tJ]AgsjW-^ZA&mA'kLQlN85U($<!VES'Re4p_nI
:b).tunHH;Eg8DiZEH&#hQkX)r7:dN`@bjT+F>A=\E#Xd#FlT]A6DVAlT+<=337-oirWSgN8G
ilj:tXa/-Q#Bj?L=Z77j1VhPb2;GAoposABXFJXQ*+B=CspLJh.1,c.[6=GrhR$!EnLP7+Q>
4h'GU^TSUQ!p;>;*g.!!&;`g]AmL=E\.o&"<ZkR30VS)%N14P`@)?fep@jJ5"TQ4G7[D-%mR&
*3h):1D\$+g_XVu8kU`]AlnSEe<a;JF'(a^!AQ2aQK)p4/Mr=FA,I"XCW$=G=Qfio/Y,/g<Lg
ilJ9/>qrVADCn5Dm[VqcjWF*Tr!P\9HXR55;AkBWEEIY^6]Ah0dA$9+,1rac/?0V':A77q>M2
EcNWekL6AIYlO%fsd_8.:ft`=R*rkhLO&>eq!tE2+bU1NYJF1f@)]A0i+/U11tY'V6t"s?>=m
IR70[si<9LE=?ZN#pb5jmSGK>+Ee_*j>tfIk)*c-b"q+LL(FH9S(bDmpHtd<pk#Wp]Aj@&\I-
8YI=XnG1j^mBh<(?JJd,9ZqD"lPj@[b:5pD_Hk#_G$8PdIL#Z<U!LI"t4I[:hWS@q[Y@P?;`
qpl3D[2\%p%An`rN`%N)X"ZT!.*"l)N]AS+4McO>sa?=EgMC.:=]A(m;?C%pq-LK"sl^-WTWe=
[/Nt.m$^G)S&m.Q&8%@`HoKW%#8=6iBHC2tHZ<"@KX_h@R`Q!id<7fBO,nM_eEkfqo(I4X"M
.g#T8MZ)Moo6VXs@FS(O'J)7G5JOkn0fiVmjd8QSjDh`ra[`JLCp.n-NHUW*7Z=d<e5HNoK4
>Pe$'u"pR"]Ai*LL1C_hb15U$4$B_Cka$Y:,pD2=_]A%7U5L*d#!u'%$h-8`E*[R)`mqLTmuq<
d_GH<nA_-0;jVDBF\<t6#pa*>6Q?Y5N0Lp[eZb98q(i9,hC?_1/Zo%BJ7uB[p#$ja?=cAi/$
"E9H8is#;X>_8#fXe#uZt-m.'VeT=UG>!Dr79S'`5&C,S%PjnB[:n!3&bKV&_7'T)gVa_8sU
1EcuU'6KcQLqcP<OE`f_$I<PoM9ELE5'LGHY[cVaX6.1;GV7jsfYh^2e"guY=haq3&Z'q;"b
R&!Jia]ANhr=+MX*]A5>n_9e9_j9sE#*Z@Rb1./"3OJU3>!nb)KH$e`eLdGIQfXeC@Q2d>jI/D
i=9,1gBK#Ih[Q9U1Q!X.7)//^Vri#\?Hu>g7<RCa_dO#I=C6i@C_F06HHH1CTZ%2>Z7+9$S#
\=F\\j6a4iY"kH"$dU6g;In&95-*T[7"6`[F9Udf36c"G:9?S?I:a!r`SDg+>WR9!i0]Amo2^
,F+g908ikimTYn7MpN%s/<Tq(doGA;DcVms,m?99Fgh4.1ZQt_Ht0N&dXJX=s"F<(f5p?La$
G9lMuCbqd"KoPhRdDs:s3Zd;[$FZB"io<J@V#NM)CF@,!C;P>\dtDl?^MSMgP1?)`SLc.0FM
*S)ml?L:)A#)R/'7YDp%uX#@RRu!`Cs<_JniYiD#g`CMKK)ka/#;+6Es7M0kk2Mp&'`>fcA]A
>b9m4W'=42>&q>aGrt6-l6A3:eWX\qaIY,9"<cT8[Wa5O#K%bE]AV=pNjJN)ohGI!:0Ge]AuUL
'*e#7J($7i_=fScg=EQlsS38+;,a$.+ri:s0kXBlYJ>=<k!RKD!q-;54<+tMF1f7=eBo_[-_
;4]A,ios<h#ACiM=V!c)^n/BLYkVG!d6C!tABW6@+c,@T6Ho@DFM0GB8<p%YGB_.PT4$P@*af
JT#TV2#I=;(4J5T_5&;QSe:KRpn!6*%e)u`QdBm0O]A0G<:\%]AQL',d@8H\rKi'WG\iHMIF>F
lA1V8ZGE6ak1LeN/57bZK#e,Z`;/OJE%o$/sne@oh(&L)2[J)*]AbO6=_su/Hq>_)6/ttm'j%
+!!-^i+j!u]A]A1R9Z/s1r<OP.s^rDC\#.ReQ-J)mp8\:u&EaKRV@Bb]A=bM\f*o+2\`fN!VpFh
mQk50$?E,k?aQ\mg0J@)=EG&J%=/*S".N85O1,LT)GttftStPEqfKaDM=BrP,7rb(KEV5=Bf
o%-.t]Arcc1-VYIU6]AWL*ViJm]A,WK4"WO]A%@b26VlC'bQ%;5njO<3.qWj4,>[nm*ju6h(#_I,
5JS:`!R]A-'D>pZH[/Z=h8\@S\?eb5LIsT6u53o_Snp_:>aVgJ[i-k8?A5l7W,VO.fre$s0ek
+7r%kYEkT5(gk874+LT8U+k@A3^B!SRK;NB)$8o69<U`$&Ga=UB_FQ!J1UiGaG^=3@!gC(m)
O+ENOPKmd^QR&S=F#3]AX\Zm5Ah,@g1`^l=eeQd*"HJR;$&W[fqRL@&,e0WcAErk42.Og3BT"
R+[N^G9a0;R-Z12RXl$8<_)-h&!2mdfZ`pj`7d\gcP=g&!)_*p[$O4[(PRkEN:L]Ahh?-,ba@
(qO,Zk,@?:%aZP9u>?>_B0[`S:l>/CXZZ+MH.YT5rGqX.+u[FsMuk2p/b)IN7;4`2pVR)D0r
<\O"<eTZ4Xrr&UE;;PImZk'FHAX%7<\COn:\Dp#I\f'nE<Uq%NGOP"Ter3"6FYA!i0R^VEOB
^tRM]AA`&??;A2g",YsZ2&lcL-5$+W9'A$0(&J0KW`8jTDW$#45'$>='*:WbIX@ERUPkRbp>9
VSp^[)K14$Xeo_oX!^BTl1..uu3MlDR,0;H8!(_S.Z[CNDG#$h9<3Mb*b]A@X$ec'3%9lW)"K
h%80^S#KLb1b=Ymf-EbmUfs%]ABoun[-fJ[NauVoT;a!efO"0jXbbX/IiB@rSW"T(kJ-D:N3#
1RqC'F)@ES-?gFE3+1&l/1,<"BJVUqsJ;,.j%:6kW_;o>3qchZdrdR"?O*o7u`cg(jX;7J@p
<IEB>lugcaI\FYj,3W$UnFO78Qdd8TLL'r.qo\>dEcG'QfCH2[QF\QAX'a8d"6jm0GSdZIg*
+NQFYP]A1ef0,\CRO$@Ncflp#;"/LY*1BYd]AV&cb=u+n'heC:YUJJ-I"Z'>R'a]AKbueehebPg
,]A7d=&&_V*&iR`[mD;D6'=akt,$L5e-!=Gs/^SG71meMX&pXE$d]A3K@o_:t^5F=!]A`A:+-($
O4;VRI2,\KMFtShII/R_gFGgIRr93"kg0;n*ckt0m!PEKiNM`RP*PNq/UOhfsR)%q-OuV/nu
mH_)@]ANAapZn"#'EYZg_^YO?V9+LaTWlqkgI]AIt>\_r&5rOF2YLQ4,X7n:1Usk*WGo"(H@hF
[B[Vu`rhY>KI&VsjmR.aj0[1#KL+N05X0&U$t)G@f(("b]A<uto@=,;)]AQm;mdBC6i^\03B@i
r&)LmZW5,@c]ADXE+6=N)Hi4%=4;G[<!Z2]A3paIOZXTNdVbuG(C#a_ilLK#K8h?J8E6pRMGiM
@j'F.FJu1X1PQ"_j21JbE@FCLT-A=O*ik)\M-8,eLN_LZU6qnoER#NNZdTTdIr&L_iDE1!+c
M4_8PW`Bt:qa/g'$44!?]AsEYC3MoM7k`[>b^h+.bK+3<EtSKuo]AkV03(q3VWPU=1Y#^,3jP.
!#YBG+%YFSUmmTsUU^l7C0e#[rEJ+u_`:lfY050:bH[0m;:95Sg_)2aO\<a4]Ah)s/MRCoCAM
"hHt;JOFQ>T[EW.M),;FBcLF@?7NBA@^_CKins+b.Os1&\R,=(O9[-`G^Zd1M1kE;_q1o40i
;MAZ`F1-E9*BmKXoX"7:jgoD2]AghD-!glMtD`1GGLm),J5O<JX)_=S:ZC4DSDrZ3u#B0P=mN
VX9eM]AUl9?LJXoW<"md>d0E#MP*]A%<F3PR(#N+)H&X0_BE-6^8U7\mRa;lu.1"?cEJ_Q&W)0
"fL>\*b(>YUm=NO,u8=Tm%E1=^LGOrU7X$+`RWo59o]Aq0&HO%gJS?=;RhkSTq9*R<dnH(bth
=1Ef&k-,8*MiGlN1;C<#&6:!TND"ep\-I(+Bh.l&g>\o5(Cr*'qf$IcT^q'kJQ^U$-1HOn#9
n"fgg[lcmlF4iC]Ah6mL=D3gdPKE+^=!q9o#>,%R;jOVH[G]A+BEFih$mA>>^lWX`bl"#O2PQ=
=`o<CE@B<a<Yd2?)WR3NYA;M"nXIBQ^l'!`8r*"1u1?7G!N<TcEMjHJim:H)mC$D&<uk-au:
-/D80@[*S&%48iEOi""?P$A\q(<"44RjdH.u0g80]AmSjpsI*H]AnLpuNu^_*c$Si8]A^9(1W6]A
[NS/DRDXC68*PMop(PHlUqoCC'a@RTNWCpBL"q=kTa54G>,$;0KLE/ga)B<F8n:Y(MGZZgS$
cZ_BUDFF$.?(ft1P0TLI<UHc.pSV(m1obbtLB*_dor+s4&_n9CiQ;A2>;p66q!4QHu7[e8=P
G-+2Pi;!t]A#AD\r@K4n<7>nO??[NQRl\us/Lu5(JD)!B3NFC>^ooV?=?pJ_:d=(=dhteirQ!
Wl!G\pTZR5iHf^=4sPTLD)H[0QhfXu-RqKEGpI!gZG^o*"E4hmBt0&iu:?nF[KRNWe#jk]AN*
&<dXXjGK&.LDt"TdR\e4]AKUU(Z#L#heROD)"bRT)HP2TpT<6U\%M5NF9^R`Zs9fN/Z["YC$M
0j(i*oj(5'G(h'Ume^$J926jAY8#H?/7)*AQO'aSDS@k&R-k$<(7OG<[G()=6r%"r@Qp^#[\
T\\\#AsSf@9<("-pGiXn+U\t@9_>q7#*g#94.[:Bl-J90i%1Lm`c70HXT-$'>l`4@TLA&?)R
_k+il%05r1<&hZO&\s%jjE^\kI2.d<=no<NQVVC)Zf:g'm+G1(YAn',S$ISR,NV"',+t^hq6
[)1fA\/hEVE5f?,'_(+nUt*Obh2+$-\t.VtRj+k$06j<1p[I_edJVa1D\JmFc>G2j@X>NN.l
7Su,[hefDrlh@\bY>Npt/Wtl%fWS?VLBQeHUB_P)KmN%532l[h!f&Nf=i5GA)X=r/;eP4!&Z
MODX5tKT!/oH[#:gtao[k1@FI6+.7,Sk]AM-:X'iEOmr/M>koB^L80)2@eZb;Si^=R);8#I]AT
r-gF"q8g6ET3?IU@)&VN*GQ!@XWpo>)9A;BbEr?VFMj1d1;n!o+5=2%7Jh(upJSD"ID^:SAH
J5/Go4%?9Z!'Vnp1H43Z:D?l/Bm<$K!Ant2:=26RI@X^Z23'%r(4CaJ7`5dN.HOmJ;6uABgl
Rj.Yb=/#0'I24(p0A$JZmZC03TRTSMsVTkYe6\@]AK!Z>B-IE9F/AI\D5ntqMIBnp=Y0r(Yt>
Hc1<4U2A+oQ3mk<:<4fI(i2N&D,RJAB,EQK?@d3qsj+2,2;VR^uMi%uuHp9Tm"!M,V&o-=rg
V9"gb#3*EARnsBf^Wo5i;p8</ZJ$-;gfQdg@A\Fp1af6!k^6*:)>D1at#a=mPd1SNE6g)@L?
HkA`f-Uog#OH8,C`DaI%<FOs6s0qn8A2/oh`JN@mG8Gn;'_Wfh]AjDDnlgEuGrR6smNOZAejD
aY5E([bF/fOlM6b^4[@qjabjd!rLV[U9i"*kV3t5(pe?Z+ld=\7pW_n#G":a'_67`_Qb$=Ri
R)E6SioZ[;F4d=EXYTMc42/_I:2Rl`5=/0No23-IB!&R?QpLaRDA>A=6Kj#p%]A[(;LIA>:uH
^qh1!u7o/lsDW#l&c#i3>!!A+9N?8"okl'X)Z.0AOatmm-DE\PGIj-iG=_QC7M;?0<,9U$oS
#enUHV=V:0>%+A8(?V?jigA@p_iUE"HS*skS#lYO6VZ)hkogqee$i@HI,cdNYSlF`Thh[Oh@
E_0o018&T8>_,cn;s>*A0reB!nEc[P3(?GpY=@SH-/a^q4H1jR,*?hWAjXRjb6:H3>$?8Gqt
[W<g:VA3aG*C'`S#/.`qG7nCT^!ojO1WED"s.pOX8fB5fXVn*s`E2YA9>$nHJ8%m<*n:\h?c
8I`o6"G1_\m8T^rf=tc=q!)igA#N2DZ4<W=."@l#h<Wc=t);!(hfr:k)8iA=Aei8?NX63jKM
\I7DqJC8HQ.kRo*2_KDgg>G$=(0i*Qt260^pd\"39?\f.LX<'bDhun`9V%t[!9-+BV_5^TI5
SpOC;YO5YAKaY>mh1+Fe)?rC0)UFI+O#_dFiTUT))=BVF1mD(a+?d/?WMXe.m`=2g\LJ13J0
T^S&F"LTEHrd+^`Y/quK3;Y4Fl<9i$b7bl-I5B%$FAK!pSe*nk=,I@3,o5VF'TdV[_e\Qo"U
#Gc4<DJJGZYa49O[*KfV.H+Rd-FQ)'A_:aPn:^#@YpdO+=odpsC^)Q=W-d&tL&\jdV$[\"Q`
kbf<5CF4R,P)0>S*]A1l#kg8T:#]Akb*^5fL\og/'F:X_\Gp[Lf7D6d'uarN6AJV\);A>/&[BW
%biYP0P*%'Q\b:3?=4Ngoim#l@5hlNp@<7@LKd1e;68";eZl&_.n8&k[8YKh:3TEbH9_Lr=Z
^$LG?67Yb7:_/E$!*Ae:8a0[E8$8\7sho02M$\tDOi9B7JCQA^[g]A?[#ZTQf$)-"gr.$FSN4
@uKgBEATX0io/)5G,Xql?r.qV=?T<PG[mHJBCBshiJE-Mg1STCrQ#7E%(rR^cU$G7jD`2_@)
rTC<+KBGQpmXtrO?I=%=?u;ta%`H0/">'7B!:u32"&GtLXO7]Ae.a+944b_]A0:;)03B3p?!E`
J$!^rgiK$64t"S.YK60>D3TNn9WW$8hY,:3\E]AE*TL3O>o.j/7'`EUrl^SK?q)F=Z'QGQX24
ld_O-HjW.]AN)5"u[G\EArp;V3Q+`K?rXIjVQ@Lq::AcupU</"/*-?/gECK,)A0Won.%6Jdr#
'n,lGT+6_7+t%`N<9FL"-sEB7K_rJCd-NgSiV8i:Y8E@_JSh\c7a0=rUXeNP">\&gmF>iRgS
lfV9QWFH'C;,=*,-$l\)hA%V]A0ETTlo<A,L)*e7D>1MGA2Zfh%ejhEr<l7C_)1b/0!tZ"'t'
,D1;g:LGWo;-20-)nDOOYG;%d=_'6[qjVnU*38Ss2X@*sgNjRCe-2RMjO#crA%,M-_=,`r<N
._r'1Eo6--<9h5S`2F)Q3Hu`d;^iEl(SPFQ^lXOfVXS1%V5?L!m*]A_>L'4_S:`^^MP-X:C6L
D+*8LPFfqa!3@O9#AHT,r3LD+Tn%i;<9))4Z6bZ=5:iUj.n"f/jg)+W:md\INSfa?<2/_l,_
(VPU_abjsTC(k]A'G6=_\1GZJlG^,PN`pHK:062Oj/H\3,L<d.PH:SHCC1=MneVR6SGrgMR.K
#W,5pMQWCbuRmLAmpJ7.dNM"oJg#B@Aad]Af1ta-aE3b]A+e1=3<JEo1tLlQ`up`G'DOoWOWXK
hR!ZZJnoK`gmTL79q=3?`m,XbQCp"bj9m%-d*\8_9QMleb.7//qqbrcP!`@O'q$`p4bdCLio
CSW(YMYHJD.F83k.sojPGCPO\0A!lnV\&0?$uWGS6,VQE?=&.-Og_fO.IGs+[AG(@&=C+Jp\
J1XSmbGp`:gaH->n\N<WBkHegLlX\uQQe9\QhcT$T+.FU@qAkY8]AruF%f9d_rW)rb<LAE_e=
Sfs#=j9!'LlTVsEo#*&qYp0EWY<.2q]A?/3q.S8c$0Mo>P6B1kCi!pkO)\kHYFp!iNY^oR)KU
,,S]AkK@M6_H`!mf4XIIX+`DeU=WgM(:]AN`pe%C&-BNrcme,<<m`4bN2o(ZGW:mJP]AA"]AAlAu
9SZdMeOT124nFDD$epRHhR.ToaB3TdE,m!=VIG_WEifT1G&Xe^mG^#\[H[G;WmT*lXP+Zli@
Lgb<iF1RgJI(MG;Af3=Ynodg+5`)Sgm-<DJ3O?.tE0B7W&Y)AMZQ5oDAYTQS=J2oZnjFBN`[
I!uK?F>L'j05GbX,#,!*JpHYRQIQ6dhDQL@Dh3WpMGi/]A4G(JR4TI%*dMVnuTg8/NG9+S-<g
\+`eVe?M'iUj#)-ea>`GH$.l1&l=#j$SD:;O[A=$D7<;383N%4a:Fs^4UhO8$(j;]A0It<3')
/[j$A=kh=POa\281:Q=2uaM#-/s`H0;/%NtM^8,(%[+s([=G#&M5;E^"5oI.6&3RNl"o[;1e
IG>n?""s*41aXdK%.e%@fEmAA&@`b<nc@<*/hCt8;'!h[m(T>mMBgRB;1t$+>\eUi*eB*0XH
0s#DFROa'.>[%d';:]AmSIl.Z%&nG(ZR`'q)^]AUAbH7t#sArZpFnmt:SE3MN[7m8JZ7rnf")k
=,NeHI:/S.!hY%nVoSJF:@g(qjn2)Z-Y7'?VMe^)D/l:8j9:OO&BO$Q_^oZ6Z0)&]ASIp6V\@
*4g=mD!P+>YS!WA8AC-^X.Ua*Bh+2pnb?o>QgGa61f37k`p0"R,cdc1u;j[72]A76*JRQ2Gid
b3OCCdp`913C9eF2D1FEO5=da#81k?d!8Y/GOfS3aAbX-^J!LBuSlArV7baaIQ=)bCI_cu4N
j'$F[jN#=<)f_=dh#rQ2Sd4-%;.ZD#oV1M+'?.o"3k^j4j\XE4W=FCl1kI-4=#9S.;%0JRSV
lPG+]A.Y%X`LL;<1WgS)ta#,:lsRfRB;,55!X>Y]Ad/VdK1S]Ae6XXos;;2FmaCt73NEAeq5VbL
;7`'Qj'I+f*X8,"`eiqBhoWD!Ybo=*,$LV)LoHX`qi<BbkFrLS6/A@;U]A(cgMn\]AX]AU"H:ej
`)uT6gTQu#2mI^0b.o)4n8uS3))$#'Ee]AE`R=F\'BLn9aECc<FGH/'PI(t/MD,E7f>m-SkfJ
a"7YQ/$_Xl-bb!A#oiA/Zo&[AYQiRFLpj*j:H0\9mBW7c]AKE%TUZ(B!)#1GQ]A%286).4g1:#
AsZ4HOPHsumj.fSWT7#;m43r.kSXMX'JF'CN>YMLPSIlm]AJkrC(n,4<*#"g*(gd1kB3*kfiF
mS)b03ZZ'CF#OZjR`7.\(.a#"eOU>3*CZYmX+.DmTZCe;*/A%jj5_f<=.VA84tKo*B2#<s_D
?"2khuKqYMo0TA_*(arn>86tksm2u[u^s]Ah"D1(Pg:Ci?8;sYP$e)bQS-&$-`r45m\DDc7UK
cN@"rIYR=eXcF1na_k"`ngeKAXk8+*E&`>4LQoVcu.s\JZ7!mgFIrM-gtCQKH"S^7Yja]A"N!
6jdr_X^nVA"[-oV3Qg1`#\.Jf23r+g<D>:9t?h4&=u('^Pn]AK,V+UZ8!DH"=e2"@P>QL&5b2
;6T4Qn*b=6N-0O@&dJu2qR$2H_s(eO?%-=oVPoiR)N`9GrQmULTN<+VG3Z&PiF\ojQ[kAumU
.`hJ]A$gSruQ#Ze]AhN]AUGRo28l<S8UeRPP5HA2[')]A`U2hWuLlM.q&<!,r/d[sq-]Aig8D6`D.
%bnXYW%CtGeOg<`?cr&25'tWN@$u8?<0W>^QMmIG+M4>6*b+^2`G*#3liHjfLp='[_!@YJ/,
.OA4fMT-@Xk\$p:GeC\L)M.@qj4ZBBIPV/7u3m2I/00/G]Ad^p]A6/LK[;e*s$nb`F10eZs<fU
u9(,q>E9/d]A3<f*&jGp?#'Uf?Z8/d8Q1D-NBh`1N5YZCO:m"qbr&c;t6AL[r5k05nK)M&tm<
9?(HYaCTJPVO"cL7`eqV)4]A"9V`qWTNV=DDGb5c`e?KQW=)T^Gfb0!=p=EfSkSbK-Dd]ADc(Z
'i:?^qA]A$EN<h?lREN$Y5kL33qtV0>08j?%]A<iF?k@\8<$0^]AGMB(A%)=^9-SYn/QPh^@@kR
fhj;l;YLMKfOC2$\3!,MD0^UpS33Ya?VghFm"'39+QfE4u22MS&[_Ru6p:F9<Hs=2p9&H6?a
CH;sTju&`X%39em3e.)h.#=D23`f2Ztt/gGO9E^E?uO;4&O?\HuaMsM!HQu9D_+_kS;_1`dk
-PrmVo;Hk5o7g>o1$`e.:2SdD\\JVB>p;E0O^+(%`Dr\ASd=N.'^?H2A.o/eb6q?-:Xc?o)(
k_q01V]AT5P&RQM0cJgp`cM*L;CQ'I<n;?4Ig0s]A^M:RTd?4_TJbGgtNG:j$^Fk``^@WNioEU
2`>'*KOGot[C`Wa";(I41lM[+>@rPL*FEJ+n%X<9X.8Lg\oLEXiO8BbA&B]A3_NO9jt4^_!@U
>\)G/%cR<1'GeaC[i,Zj5aA:@if*K;dY+?9?[3Es/=dWZc,(>cm,WS]A&VYr#XeYfAU@t>kY"
Q?$;A=mlodCN,V?A4'BM>&od?d,Nn;;DVN/HH2)'R)rK+NQe'i]Ad,Jh'`*)gE2;KTXOL$U$(
2t6IU-0cPHX8:1=AV)Xqp('WiV0JkQ2Jlgh5giMUJM"2f-eQarC`=5M8A9.XebbdN&/2J73m
IBT]A`1,e)"YV%`uqg%um)=@i3WS7MUn]AFsR:ma;95[OY\0(%uC8\'M+2::QQc/uof,f"*uK'
^DQ5(bd;<bqYV%W-=a*bo/,iu8:TJ16`(S;1ak?,f"LE*<sCTujnkZu$EmGqF-M@3Y0\_CMu
[e@e]A8i<K.a:DbQ\j#r7qi?>\]A7L;)>JdGp4!Z@Iu9ZA3FCD>+k7>0@9#&_759>H"Vfum&_7
2YI2dc?&6_9%bh8(Mps+T0g%,PNQ)@<8GXgR?&7Oq%9eW&0e-hU.UPl:l->1Oo8fe8(5\E^F
234aC-@?TfEh4/<I1fbl>p@itYhLk0O,jQb7T`'<mpK*Q\f7o2*WiN`7.aJ.p"=I:kklB;ZF
U#pXc*DB1n:2oSLePXuR%fTX;lK3>^>U8]AZGA6eZ9PkR$A<:\CI@tV]A%4Ah%cpq'2-!bSKi4
&0M^>oeLqKS.^ZK6GLARqXYXdZ5leG6]A#Y./0T6;Y[RQ6qPe\+V_ODBq'5GmtN"W+XqXYj`=
7<5PZsSg9=*Lr6_.Xh()Dj\Sr%F=JRT,qI9dNt^M0c4$BDDogf6PdkH@6s\0[qkj(s&ihE6k
1)G_c#f2X*_f0bH!K.^haMR&k-nfO7FPH=)gA=#qs>V,J/M^<*1ik3:4JZ$#Zsbua`O=.8_r
e.%)#^J'(?Kr4a"3TYNfj0+tGoN\knJae6]A>;235ZR#,i")_LPj<#C-sBN(9TI#q-68:QWni
C5&5G8hj#%$Y&&p6"NX@%50RAjPFhG,rE@qHmW3D)1%0oSUR&4S3C3ZOrm.8HeeFb*p))F:d
9lHd*)s4[@;lOAp)j=)#?c;I-7Z.gERC(k6N0bq&+T[N`#"#LJLA^:EduVbgioD,!9)'[>M0
"_V%d.aO+bgY['i]A/V&U^VGCuj(0BS\XI;J%m+8Xo1Q\0LkGeaMlNT\Kl1iLP]AKf"T.$"<&D
E%]A1f&ZlT%3Y?+_=MA,EtCCXJIsm%iu_3;\JI8<Wg@%5[&5D5hK#JN0F%Z6Q$jpB7ur[)]A]AF
[nbMc"t_<\ae]AD:IN_,G;bg>Ip)JP6>(!jAQ\e2'Y+"45i&RKLpDbonS8iAu+]Ad'#/^]AD=&O
Q[rY+HO`nPMIa9:@b*===I5!(oY8&5dsFlem8\2I`18p=Y536IQ+&Q`8*V;knL4aa46s,+$!
j0&JpLF94T[O-3;2is,f4CX9Q_s:]AWP7I\<o[IWc*"rY1G+@,eOtiR=@[h6ObuLT,5=k8.In
DQ+@3m(b)r*B&ftgjS#8DLnj*ri)_d,XY!]Ach7b2a-"oOdO<Q5oJh,-lHN2:gCa`uL2.1Q+2
IIjjIg>rD1EO_9=;X)PNZE49j%5lhb:fk5$Iqspe`(nHgn6kMGbJ5pfpaT9?g:@*'n?QdH<c
.SXuAKT4el22U*hBL%Yhd-*fXZoL10O3ih7uU<bUoek8i\`TgEhnk=DB4eg3s&i`isQA(=+T
Tf4`^6W(>3=m/LAX^B.fLgJjQ:^)h\6?OiiL*J@2@]AmWcE(^7"efFkq^VMON'1ElfOH>kj0d
4[jQTdQ(CaOl6eIgrtO!t]Ae?dV\S./+lW=Ha)pf^<)iA"NFnAFq!\/#-lnXd:a4:b!5XbS:<
s(M?KJ)]A&s->Q8$cWXp#?A'l(`G4+06Xt=`kq&!"PrfoN!`gb+43Z*"?H^V>t)?eqM@WZ!m*
r90QgU8Hg]A;2@4*WnWGpsasJ?'Q<M8ufbujN%?:^<PP<=_d7O="4eT$&+4L<oR2_GS9*(66J
8WejZQEZc6DfWV<0Joc>gI?]Ao,^e?SLgZsFnTMHCC5j.fT0Z4g*6(8T)RNNNMF-0AnMYLm?t
Cl6J"kS;^$gkBpibp]AHb:5E0UgCA*b<5=X(W6!ch0T5&l"uEIpKK0Nmk)Jl]Ae9skn%W*_tEg
X6X=KCu8]A%O0RR3!T9.-\XJh.WbA+rZKnXJXSHXjq4Q[aeg!/t;JnL(6lue_$YMQlj,koch+
IYV/HEDP#aJ[?Gg%Tp3#;oMg9;S9dT,$30+#R,)EE8qI'eSij.-^,/fDO%sT6Prl^)U.?eqp
a07uqCnbG,=/b]A0_AK@rYFdbp#G9C3gk6TNOk-_GJD;(7hoojr[tj\b4UHF%$"m&EAdLS@?)
:7c6:CBqnNGf#+2QJ4IUf]AJc=bN`sKpYl2Z:lUGqW*\<j0HFm8jP3XFnD/U?'D#!FiQGsA^O
b*Z#A0fjaK>2ZCu%8Yp6=V"AuHnPa.[sCiEFWI;!2fm/k1"U!t0Bagb=O"t"2o^Rj_NdEXjo
'9rh)=PV*t%a66nB1$GU=;ql``<'G"g]Ai;Zi3Z;4umV=WaMg*:E0l+o6d."+Oo7]Apt?mL@=:
%0$Mo<1LE[%1oL2"JB0#@n;W\k(_;Cm>V_5G06c`Q;PQ_!Q_4r<RdF(CL40'4Xegm6E0X+C*
(NUp,I2oE[D)P'(dj1"2&soV%F'&p:i"$\YP:X*%#4d98eeGIG:J<+@V4iX^D0:AnOcUE:g]A
9eqT?Lkjm,a-Wi-dp/Dr@>$pILq/>g0Z;C5gPjiYL-_[n&llB]A&TU=n+H2)>V0rYIA+9`B;,
N"rnS%UgX#rD*-Ci^:E)E#K5:73I'PDM^1,ff-k_B)Y,\:rJ2B_p-ZsK;^*:;"G.i>Pk*elX
gnZV3fc="H/g<<[oDY/+1AX8L0Y=hC$*SWiDR<N=YME7qqodqN1SL,+7XKkKV(DnXn2e"`XB
VR@FEo[58@R"j$K.9+fS$)+6cFdueW;0Pc4?.r.g08!0UaX?C[Qg,3e'bR2"HefXSJH&H7'F
K(E&4O#aIqqGlJ(HE4LUj9/U!ab(p$em)o!"J/#M$9NVMdIZKc]A]AAd9e&YF&W6ZMMqa(A`BS
mmrXEp5iTFKm/<+";,"nl+J!of.FRd(,=g9BA81(mTPiF!^Q->+ZKGXE@nbm(>&WjYj'XX8I
)JTr,kh(Was8C'TM;$?.LhgA$T0epVa6*6"6PBn!]A*K<eX_DJcDjUmU]Ap;p/OW(g!HRCC(PM
nXEZ"bU\ZhXHR1<<&W0+kFG1f*/YNktR+;Q!^+J79+q]A"i\BUi$6=UUa1jVU9"nBEuaacbQ9
0QMRu2I0-,8DpDd#m(E3T:0MXf!_@pY1"'dhBOa3u*2+AS!^>QeZd2"M;o>q0K]A>%toSYe3*
*)@s57kqH7*<T#3'$b"TChBoLJKt!akkp(D@*!55::.0gG"2R>o>YZqPZV#,J,C;)AU/nbD5
*CKB?'#W`r_+]Aj0j4ci!*Q#-/4aVaPY>PBbbe9C_<4B<K+TV6G'eNSf4hj7fGQIm:+6RP=Q@
j2r_cI'P;F2e0,>!$2u)j-&AnJ#_H$F2Qsb_l5g/qtLYH:LZ<:Bd@$u/Zd70/hDeNM^XWn^6
ANf01ug<9/(d6X*%T.rB]A#Mp[@\OXp*:Sf9BJ^qi*B4%@Hss9n;K`rY01gs3ohi7l>F3qtaI
#<\'fE(6p&O8-MF%!)Xm"!t,A?&J5TdVur5WAIK+mFTM^m'dBCa"XHD;aufm0!YH\O@@gAQ$
mC:S+Tu[RGkZft[e7>cDnWQif([a,nHZ/-DR.UAqu4mtkPY&B')\?Y]AlppdZ*?rGTBe-VRo!
Hu7;.5Cf^tqsd^k/5mB@2!'/lJf*T,n0OcS-nK)&:YC.a3D_4%bE<MRY"jMMJ0NJbk0p)*s1
$;S5n3E=]Ae:IHeZ]AU/gp^G@O[5O8?Pg<)TMh_[dNP0`PcbC\jQA?ReOZ[g8pbU6,.P-$>t7#
"k;MC-U[13S5lo`<P@\7)D[$o<9b\@_e2Y23hA>'lePq8-muk1dSgcDr:3b2p2_U8i9U9#XF
3[(Jp>-=e;<(]A$9e#:o?u;0>u3KWMtXZY6&=a2N)"!_PS5-VK1h*<2E9QBYp#?F=B:?r3?,'
VmaN2,;*CVhD]AsBOkVM0GAcML+'ib=`mIY/Gl/>ng6'b#OuA>dZF<V^.Str@r]A8U1#UorN5>
8OIS-eYV'`*M2bL&#jU.$6o.(g%5Eq/a"uAZATZe3VmEM_&%O95C#s)B[<KFhMg\0n8/BM_?
i[CYMU<-G:GAQ'W#M?P7eWAonI[pd>7lZbD(?-geMbo$fQp"`V3A.^:9)78[P/.-&s%Z4f`B
<;85/>H@+J1`(TGs)<H&I$!>d"8E;3<TXJ"lFTDt+IOr2cjBG91,U]A/Sb:(".XU]APW<5BK[u
YIkI"E8BkApG[$(/n1r&@'IU754iD!''S;X^lDJQ_2lQ\&^Mu,!b\0mk3>3RrEsoJ/cXsV9p
/(L0#Gc3flGg#mfJLu#'tTk`O4R-b7YqpB_T#$Tft]AacER_HhZ^gNsAL/=POVms]AWhJfE\[d
GMhR2$<f<,ntZ7V3`e%K'^$&@:Q_BFK_!7ag4,O$-[5s%ME:+8QsaBdR8R\&/Xmgd3Vhi3f?
]A:iUZX::!s:]Aqr."09cIm%$TlF>;nn*^IN!).G)+'%?MomQ?OBVrAI9E2TMFWq%Z.oDQDX5)
!O#Q?V0hb&nU5Z&<fAc7-///3EA*FsceIGJ#cfCPt>4TTb!%(q[O?+I#A$`^UVBp'?D?]AlM5
<=AH+jag+ilL/H3S*+"`R'q@p[]AQHp*#"@ka%SNHQK25Y>*^Gqko^-elPYDkeiR%j>U,&"LC
=&Jqs.cK?dSuf!/Ne9&htj+.mW/KHm$pft*gKoXlKI>rs""Z<fIS[&WOjb(J,*j%U5PM3NGt
tX1W\4bnEd^If'`nKkMh8!TnTR5Tn'cAbk:s:"=k/m'W2<&0@nZ([kR1oasXO;T(@!t4&&m2
cYmWuR@;NZF_ZA%Ib6)/00uKoe?$&@d_HdGkea[<E\&=^.S,fo@UASJ/&_PhDS&Y7A-CuonI
[m^LEl2<C<5(:YIur'hfB.(]AHEj4;$dh8?[n/oR`QQAWY()%fVK[,E0PZr0rZub#`qk=N7`s
28`,6\D=?>n`3Q?.2`.*'g544rUOA+P]AM9aukaXb:iQ's@N,r0)2=0*jST/2I,Y]ADC4,uf$4
15SQT9c%S_=d79ot>N,@*SG:fp9uVp_D.35I4OQDEd6kTH%VUN`f0o7\V6]A+r5X+GTC:'bdE
9(2s,5<XBA'fh#V1"S(tt"X?_Yl0i'a$*"8F.(oN=r0-N>@'uf=+C(oeS?E_#XSNo8kF_.N6
_D\IdZUiP*i#["8'?9I-j=u4Xgj9Fa-rb6tqoh1#?Z;[?jXB_\l?'Y3]A8CaICC)Wn)fMJ9GL
(^d"Y7>)*Q+@)gX\N/bG0.kO'q.K3qOKX=9^E1b[s6%(6]AbAZ<f8-%q9lCkQq=2B'3Oj6nLJ
@s3lULc?L)=bEfVD;Jq=`=M3cqTr>2AoVq)LnC[ethI!I\pBMPQ?C['jIceZ=pknOk`".9cX
d6,i*?iF=0Gabh#nGjWb.d?h>bRR=7X('%f^qp1c&#_RE6/-5d!4[1n2Z<JWs=D%cm&bH;fL
hknXBqP6EDP`V\Rb=6FBBlat=pf1jP%R+F5&d53k;]Ae1bNbJ+XZP/R)B*\1`"L8)*8R[*]ALf
95!;Q='Wil<q@?_0C)JcnC%l:.$u'1Lhq]AHg,Nfb?$)b^MtuFXX67W-MIOE,3/$iSQOi1+Q@
h'gPKN-I=1B"09rFkAP?^c3+(b\%>7T8++[Y8`HMZ>SbXDFn7^c_?'n`&,3L,:HAgE_4+Wl8
DjUII2\%/5Iq"af&A8b`rZn7<<i\bNA/e1lF9?5O:&8H<8/QRI!b#s=TR`gc.e)fU_j+-m1+
4_\IOk]ACWs7WeeN4?e@GNg'O5I\Otq[!)2ZAsftCHD3175+:XAtCE(LrlUX+?.V@i-sA&:L_
E_h;B+I-J!"S$tVQ5\oq6"#r!T.jbYW_&VX[%ZX]AatKHMsR>kZ6BjO,8_P2-L`#BPd75m&GP
_;rIQeW$hHgEE#qZ38;`C)sZVo/Lpi1pI2]A\nEX`=M[:lbpBac4ghUB<pe[njELUJ4Z)f*Uu
/N,rt72X(;0EmV[^SP&j6AGDL&&.MB>Z;=^n5W5CL-[Sbj$%VBpUqmVFHl`Gq``r;Jrlh%rg
2Jd@I6ri.<mG`JN;Xg4&]AY2*"TWV`n"&iq>BQ./"]AWsnXV"u6^@\7`)]A&dnET\E<OV-cd:AI
*8BB+D3\;]AO0H;c[%!Fd?Rb<#ss?,:D&JKgIc"@b3?4TZW>%SQ^;88M[OP,0hZPCkpW<;ND=
n6p+(gkg<E)[CT*JO1fjkN$I7rshkKDZ-2Z*MU%?2]AE[\B*\A7W7Xp5lY]AhiUCcZ`YPqrRLq
RM4Q5I&k6u?#mdT9VPT7V^/O4#<k\rOOAsEGsV`G2rEppD=5^GWTSF>A$@BKF`-;_p,#3G^U
sio=L(^^"l[ocAGZm))=\O%Bc2r?91D]A6aG]AG+pi:rqVZ!MieOIL+=!%CXs'lcg*'+E)rSiH
VnqKm`d`hH1FK#AsgI]AD@R(nNre^R5Y]A7=3X;_.p*!R8\WhA%q93\uht%O&VJ#244aLRY)t%
WA`Geo,e*I"_6>E:AJ99J@nAi6t`^(L]A<cZiZimJXO&>0ZU5POs1E6Y[lF;Sk&,6RmkH<2eq
,u3L4oHdgc!7C/1*MIAd8+#k)L:D6FB`09250<LpIm*(%k:Ip%[h'n>)\kb(:)G,k\B-Z0Cc
bT?uf1nG)r\N5[,V5A<,7/DtBB2U%$4a$<=LNk\.mD8UrpJk(m1OXIcl$E#lqD^RbMHH!N'A
qf\9sHB'<CJXDb/HYUe+T1h)r/_(E,h>eWbQE?#_P,BNn'*_5fY5GmdMK8i9]Aaaa"fsbQBJ2
CT)eBVrC*`p+GAMKf]A9Ud>5QPNJ%DV6a2&P;8l"Mj-+@'</r,uYUlLj,^Kdp>"[5?J57_?]AJ
UO;7*2Ht-p#r230b,)0'\Ji:J5Z-6m#WI>pJ;:CgS6oT5X*o+g&d48`:L=PR6(K1:G[=%UI6
):gk5X%+?4Wf9=1)1:#Q.*W9*VRdV%Q2+7"(TrSu.6KsuU+Qn%_<m:M\?_Lr(JL;m9rcK%7/
FTpNh0>irbBHB)(4`sE)Xroh-o\8s>'^DO4bm:^1oG]A.$n\D:'[WFmqc0D^+O7"LXq>+)5iO
!:(11HSRk]AKVk71^ni;T-Q5Ao)FX6;b`e/s5@oYEUOuXU4Efre4oU@O+AOK^ku1/M(f_@#GK
9M`[&NS6_/L=>o!7'JmumI]A7]AIL8boIRXC8N<hM)0P-Yl>l_V:dJDkL4k?KmrDDKm_Eki<I&
f%g@Rg;qEa_.rqP%T?%JJ<+&#i#DW#<VDB^Gm.HSd-T'!L%AT#hm)"MZYarE_6e/1Z;='Oc0
,BClOHqNp,r+Z2N+7[3o,fai:Amm)PXql;uHble)b/iuJnK#f08_qA!><Mfc"o[KM=!n-=b:
XA<0UHBsVtLR:$g&/f$Y[7#;43@1#b-pR%f2NkeMSG(?`0%L^$r"AKj_kZ6(^s.0:#[FNn3#
$d]Ae9g7\IN(JP".+X(THfo#Ms/QU?:QIDRo]AiJ,[\"2M%pcRL-<Jcn[@ijaud;r`j[EG)5"V
=5:&933i./Sn%eFdK1W9kCOhMU")u]Auk^O\$X2b$p1[df(G:9+I)1<6\;kQ/beNE\cf)*[DV
:da1IbS_4K2kn2<eD:^mp<p8LOmWiVZdu!MJu;^1MrqWC!f`lLUC@%3gQ"7,7`jgp#QiXT/:
X`PrQB1*RapmP!<(&F)b]A#9\^E8qGQQ&,CLld:ce*^2Q<[6<S,hqMOCnZ'QqnBV0oK*=*%c0
pC'ci$HAFN%kT@><JtA/f<oFbQ&I*`?:1f6l).J1_W`WML9b^T)\p/b&M2kGdd]A@VZ665T!?
Y/;`Y;hP!#NfiIS)IPO%IMkH>bN\rq!/t8cu5e/NP%D*Q0XP,W<h>TXm]A1Cc>n%aA*!B)hW^
)`Juk57h1qd1AqHJCETnLFF/j.6c7#f`<4Wu,6P99>/"lg2bsiCI't5moAY6kJ8BDm)heWr^
,d>7`1s-[JG,9@H"OT2-7(Fig2h&2i'bHp5ViW.,60go'86PKf>J>?-bm;50+Z&hd^=9:d>&
XdMSB.t$`/(.Ym\#!DolMha%S1uY.pTSm2n<H0&,^B`:;EB;NK^5jYV!m7m%En6'):?kK,rb
h^5\?p(SWaLhX:m*'idu`3nPG-E7n%61hMeHOZ%I/s!sLs6\X_BB@8g2oJ85nW*F*%:jb'XD
D?ij-*Y6,+tj*>otXKbRfI&@=aQPW1%.*oY*hOQ(3!)HU_!,\Oid\$AAt;pf7>NY*]Ag56784
5b)gJnpVRgT[3;GPA97A(I^JfbXg!\Oda,NUXYIM?l^^G7$f[05s"(Ok/aCOX2Wsa0Y%lD,^
T3f='K<*MGYZ!kjG$f_P`Ni+1(Zt2'7aL_h"Ia#rIu>m:/CFI3Gunmp0_I29m&ued!uU!/*X
S]Aoj*:(<jZ@U51ZA\5LCO]Ak+cb+:349N^a/0))JXC^ot?n4[tr&[Zk@&IbPp:Orki[=I=JDI
s8CPqr0@#Qr.S43^rH;%0nq-RYi`E]A%X"9gW7gPdhVfB=;$V=A_T)N0`r$1KcqeFh>Zq?4nH
nRcmqjR0N"N9KJ"n_+qF9q*nV8@.>89i6$p4r]A&?[]AVr.c+F]A'MlAm($?[?b8K>,P$iRNnc%
1P\%B(@%AR?n"*SZn;@Q7D>oM-2+\FS'B4+WG*\fg1GP;DA\(DRF7D\P,U/X4C([QX?<h/i3
l4i'HJR;3ll9t%S?<;+D`Q8GMBq3d?CXToY+o15H238Tbq>na&);oXZ/&(4dDri6Mo2QKOa,
=?HcN5kB7*:Vj^1Q2\+I0P+Sn3+S/He7m'I4QDNKq#S^&-0e+215"M?%qf3W+^*"Om1V.m,.
MoFqJh+#b0)!)38#uK/':I9E$ec2BKOW%`>fl#/gQ4i]A@bT6Vo98/Ul`r%R<5[pI!Lpd@kVP
8[,Ur@VIdK=q>eHriY\3pG$f23hI"<,H(oCI_Br0IW3doK:I$'sDKmX=;R4B-VXH*Lj#p)6&
$(gPuQKu!p&;]A&bIYJK,uHOU/qfP<1N^g;Wu%"ep-VD,Nq@1%VplnoVb@'@E)!db@\(YENmJ
73DJ_\<:k3)!b"J\;8?$g]A_f>[XbOhu\67*\\!TE1"N#!f&350!Nr8E.P\,K+%$'(gLIP_#o
G."V+HJ>i7=7]A>-i\[!9L6Ha<KTL2E$Wn`lBIFgTP26lG+2Y8:L?B%+RK\*p#>INs9IDfbTc
]ACoS~
]]></IM>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false" appearRefresh="false" allowFullScreen="false" allowDoubleClickOrZoom="true" functionalWhenUnactivated="false"/>
<MobileFormCollapsedStyle class="com.fr.form.ui.mobile.MobileFormCollapsedStyle">
<collapseButton showButton="true" color="-6710887" foldedHint="" unfoldedHint="" defaultState="0"/>
<collapsedWork value="false"/>
<lineAttr number="1"/>
</MobileFormCollapsedStyle>
</InnerWidget>
<BoundsAttr x="0" y="0" width="1020" height="551"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
<body class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="report1"/>
<WidgetID widgetID="01205e46-f63c-4e2f-a895-563bc612e6a4"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="0.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="" frozen="false"/>
<PrivilegeControl/>
</WidgetAttr>
<Margin top="0" left="0" bottom="0" right="0"/>
<Border>
<border style="0" color="-723724" borderRadius="0" type="0" borderStyle="0"/>
<WidgetTitle>
<O>
<![CDATA[新建标题]]></O>
<FRFont name="SimSun" style="0" size="72"/>
<Position pos="0"/>
</WidgetTitle>
<Alpha alpha="1.0"/>
</Border>
<FormElementCase>
<ReportPageAttr>
<HR/>
<FR/>
<HC/>
<FC/>
</ReportPageAttr>
<ColumnPrivilegeControl/>
<RowPrivilegeControl/>
<RowHeight defaultValue="723900">
<![CDATA[1104900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,5410200,4076700,2705100,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<O>
<![CDATA[排名]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="0" s="0">
<O>
<![CDATA[品号]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="0" s="0">
<O>
<![CDATA[门店]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="0" s="0">
<O>
<![CDATA[商品_门店_单数]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="0" s="0">
<O>
<![CDATA[门店_总_单数]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="0" s="0">
<O>
<![CDATA[商品_总_单数]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="0" s="0">
<O>
<![CDATA[全体_总单数]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="0" s="0">
<O>
<![CDATA[商品_门店_购买率]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="0" s="0">
<O>
<![CDATA[商品_总_购买率]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="0" s="0">
<O>
<![CDATA[差异]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="1" s="0">
<PrivilegeControl/>
<Expand leftParentDefault="false" left="B2"/>
</C>
<C c="1" r="1" s="0">
<O t="DSColumn">
<Attributes dsName="门店商品销售" columnName="PLUNO"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Present class="com.fr.base.present.DictPresent">
<Dictionary class="com.fr.data.impl.TableDataDictionary">
<FormulaDictAttr kiName="PLUNO" viName="PLUNAME"/>
<TableDataDictAttr>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[商品]]></Name>
</TableData>
</TableDataDictAttr>
</Dictionary>
</Present>
<Expand dir="0"/>
</C>
<C c="2" r="1" s="0">
<O t="DSColumn">
<Attributes dsName="门店商品销售" columnName="SHOP"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Present class="com.fr.base.present.DictPresent">
<Dictionary class="com.fr.data.impl.TableDataDictionary">
<FormulaDictAttr kiName="VIEWNO" viName="VIEWNAME"/>
<TableDataDictAttr>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[门店分区]]></Name>
</TableData>
</TableDataDictAttr>
</Dictionary>
</Present>
<Expand dir="0"/>
</C>
<C c="3" r="1" s="0">
<O t="DSColumn">
<Attributes dsName="门店商品销售" columnName="CNT"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.SummaryGrouper">
<FN>
<![CDATA[com.fr.data.util.function.SumFunction]]></FN>
</RG>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="1" s="0">
<O t="DSColumn">
<Attributes dsName="门店总单数" columnName="CNT"/>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[COMPANYNO]]></CNAME>
<Compare op="0">
<SimpleDSColumn dsName="门店商品销售" columnName="COMPANYNO"/>
</Compare>
</Condition>
</JoinCondition>
<JoinCondition join="0">
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[SHOP]]></CNAME>
<Compare op="0">
<ColumnRow column="2" row="1"/>
</Compare>
</Condition>
</JoinCondition>
</Condition>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="5" r="1" s="0">
<O t="DSColumn">
<Attributes dsName="单品总单数" columnName="CNT"/>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[COMPANYNO]]></CNAME>
<Compare op="0">
<SimpleDSColumn dsName="门店商品销售" columnName="COMPANYNO"/>
</Compare>
</Condition>
</JoinCondition>
<JoinCondition join="0">
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[PLUNO]]></CNAME>
<Compare op="0">
<ColumnRow column="1" row="1"/>
</Compare>
</Condition>
</JoinCondition>
</Condition>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="6" r="1" s="0">
<O t="DSColumn">
<Attributes dsName="门店总单数" columnName="CNT"/>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[COMPANYNO]]></CNAME>
<Compare op="0">
<SimpleDSColumn dsName="门店商品销售" columnName="COMPANYNO"/>
</Compare>
</Condition>
</JoinCondition>
<JoinCondition join="0">
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[SHOP]]></CNAME>
<Compare op="0">
<SimpleDSColumn dsName="门店商品销售" columnName="SHOP"/>
</Compare>
</Condition>
</JoinCondition>
</Condition>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.SummaryGrouper">
<FN>
<![CDATA[com.fr.data.util.function.SumFunction]]></FN>
</RG>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand leftParentDefault="false" left="B2"/>
</C>
<C c="7" r="1" s="1">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=D2/E2]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="1" s="1">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=F2/G2]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="1" s="1">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=H2-I2]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
</CellElementList>
<ReportAttrSet>
<ReportSettings headerHeight="0" footerHeight="0">
<PaperSetting/>
<Background name="ColorBackground" color="-1"/>
</ReportSettings>
</ReportAttrSet>
</FormElementCase>
<StyleList>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Top style="1"/>
<Bottom style="1"/>
<Left style="1"/>
<Right style="1"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#0.00%]]></Format>
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Top style="1"/>
<Bottom style="1"/>
<Left style="1"/>
<Right style="1"/>
</Border>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<IM>
<![CDATA[m<WJKP@rUXX]A'LLX%^\B[>LAQ.7IC>#`(ao:/qWLW@/s+WX'1JU**)O93\ETU8@uY=^qh1'd
;pP9-Qft0n]Af<!C@FM":-/9pAK?4m>T?ccLf0OVg[UAE<q-Y\Zb>3QMWeJqnDX3YNLX!hL/n
YRPc%s5!.]A3B$G*lCY#QrrL\5J-`92dI"'>/Uf1S)4uo34[)cSRD,hcXKZkkRIdbJM%@9:a\
K,\W:qGQS5JQm/46\u"If00MB>;4YeOT(16E`go5%nS7HY9?)-.D0`9CWMX+#dKo\:+)G?]AM
i8^[^-&2TM0!jqi<0hq@&NR,@5,[81sR0!O"115@q>i`E+63GenM*bh38O?P#55IjN.l:C8_
jmP(3]A_Lk5(E^BQGnIC%0>'*Y'Q:`/R&s(a*uL);TbtPG1(S8H,/p0uoNGgLbfhRMDp^u":P
cKjG^hnsqeg&2@X7snYcqt^c-UAq6Q,<7M=+_ND$>KAcSm'_F%^4PFdV_2Tc0&]AK[7(b:TSp
+$c=15QNNW-4)'V&4sjGg$Y>fR<`d2J"YO>,EYQ]A\SJdBNgoQ2c^*P/!:euSO!I3AK]A4%E0r
2&+C&!P_?(D@rr>?X[]ABC8)bO%fYY"+d?P^$fOE,#9;gc@!T=e!6;b6nQ'ZBB*mo'"EE^H[]A
QMQ$9PS4FcFLWPQ)[E1=JR]AU:8TMf%(*!%V5S:C]Atdo@r%A5&!q;#`s8eX;'`Bk,QR/X:27*
3gQ"smE[^N:]ATDO&RBfe&T@`QEu1V*&*@^J,\-G%#o3#?Bm?9F!ft88[-E]AFkC)LSp`!?6k2
0itKbq*E3Gf:pPqD]AR8C*R$,"RLj@E<C.Ho&#rTSBmAnWi;1o?.iaD`3kfq+AHFC;dUlR;5*
hR9rLj(Yfg:MBYerYNh-F.raTTCa:IZ8#M(@<j^'QhcuD..mqSf--e')p3iRJ+1,^]A,T"p/4
0-",6AGW"'@D+ZnU0hf#SP@@Uf-i'&utV[jWj6MiNTFg><t27$q^$.RUi`[Bh3ml>H8o^OaH
JVKD3IU,@6/Y4H]AKr%e-1gA$!CHcrtWn&H"!RF6G2>?9$+A+o`ikU,^_om#l/+86-BAF3Ea(
4T^(jn>F/LI@3FM\0/g^`V$n?h^uufauK_'0MX7!Eo;sX_R']A`<LO"`[J!KUW1c.2=Z'Q;@)
ZPf%Dd#B/-&6eEf)]A`-W4>!(7'>83'H0;k*PSTD-*!>mDWPYCYUsihgKJ-3-HZW_]A*WD+QjU
l8DR=N:,1Q<NT_8*MeuA[S+X]Al4>Rm)A76.P+G&L6]AYHe\SX=aE0IrQFBd+0G4Cb>K1&CMo>
QbXDU<TJ^13p#2AD[O)OAI@+'kN+kIc*(Zhh]Aqkd4Fn%TW*D";$J@=Lcb9JGSSt;_=T4SM_u
Oj0:qcgUu">ulWW`!q_$Ydp%IFK[<3(V8&VMAXK$U"4iP=f"(j);ka>'?^IAD[SSK3F[0ja?
Z:dFLM.=LJ.!^)@Q-oDT%]A[d&$0%#WK4[PgmVP*`%%lEQO$,hW*tRtW+fdr&.pWs,3[7R]A#'
;?%-k2Iri+6b.F+6;_IpAq]A-$&,pIJ^I<^W0NJ\;R\PCdC#dYjo/_#F<SI(gAqa8u>8Hh@/<
-_F^/e@*70Eg_"[m]AFqEla,`ijYK7JA&Bn';)okZ'DuI!T3.AD@V>@iNo]AK`XZpT+A6@qi=9
QhG-.TLZ.1gN4-Ar0k[^hO&3+MeMrV6eq;brng(/JCd']A_7Ne[Vr4D^)A)*<]Au=MS'LE.[kc
?T*)?%)SJ.A*b-/m7U"s=kYL6=HRMX+ZlL5I81%)<RjZpPgU4@6U6Esfre*hou`e`F">]AsI,
7R+'V.^sC-:JGFK"sc;kl?Pe/01+)SZZ!IZ>g9%RbECq'>jXT-_(e&'Sncf4LB2lq:Z!M0c(
cL;ioO8D8N+S8bou0^9mB.#Lm9t11Hu[%^OcU9^p7,`]A9]AVf,NomKcIc-4lp/1aO^O#\S4TT
Vfc:."P)e03VEY9I*i!@u-/Von(q0R`7T%T+=KLK?%3,M;N/k`gkn[VP`14L;Ho9F8Cdm6!*
F(\SO4!L&A>C?8]A3g,*$W."_ZX9EelEsk53$+V9Si"E`9U`U+lMfDnLN-f0DV-Oa/*O6fW4/
tM1n&%M(hp]A5MCs@F-5_.mn't*2D]AlNgP3!VTM5(%gE+)<Ta))PWW8LA("$DaN?;oi/&mZ>*
WdLUrkH^W@[B1gi3Unr<F@&T^A7'ui(D(V\CP!'p4>83dn'HN4=o>7ua2R-T!5-hWnoUU(_h
W1u:b,gnY*R=T&uG61'u7ZFHoagI!SZiG6=1F.-^/_UeoirZ0ane%G828+dS1.q/`oVJl?W_
/UVQ+m&qHNm04*<>?`1(TU"LXGP%\>BKMFX*e-``IiC%LS]A=><^EnRb[6n78HcuV),'C+D\^
-3B"8pib1Q:]AD<N($ZUqV3FHb?XF4ZK\e>J[1#a4F3<+D%U94>&2D4P.s2)+1/^2_VGq[Go0
2u,Fn`5*Tl1el8j<$.>ect,f_"I,L+!JZp,*n3`<.Q-*eEoBfjA?Oim31%O&0+#,WDmD90Cg
arMC><nX_cEV%J[@9on#eUZ7C.U6A]AJ\6+:m";_#*fjYJ4Hb`f@ar9eL^5m!0OE=,YsIQ`@&
eWkl@`5$ZsEua:YoN;WHf,JJ^gTOLAS>DHO#c,a3\[L.L-W,7W$2aC3m,PMF=j::+.Mf4fR'
>)<P\tgdP60W%e+?):Z>83O'@,Y8L67hS&^Uctn'=%sjo<m9fX>N=V<,5&6L&ne\C-!kU\Yc
i).k3TI'c,h%go.(<EgRJ0edS[pJB>i5$-Y6lfV9k$cg!@\b/KVq7QCF*Y]Ab8+/FQ]Am&R(1j
O_o@L=bU*N,GCFZW?i?iM^CG'5(LBCrrRbp,T"S&'%>0#:]A;_)*V/*>UmjM6E=f[l8nkKCB-
*a=4)@Q9j!3lcDbXeV&8&J3Qrn*JA9KTV"3iU<,m]AZ.$bjrgTgSKa%;:J8aoB48C)$)TClD@
f'V=Z_?cAl@*D=t5WiN[;;5*baWcBc@BBf]A>g6opS9=@3bLSSm(DS:Z[o3FScs.Cr_87ogAI
Cq5'nT;L-!<;lsmLb!ZIHPg0W<q4\9[J/LDChKgZF@g$jE=NHW[Z%Of([n2)9keW/)\1DCia
N^)TH0<`@p1[u2q&/kD.7$"T%MMEOc_psLO9YZ_E'W'.=mXgd[R+:Kqs&)8VEa[H,Xm>(P^e
hro.dMrg>#2XMs.V+g?,XXhsf^5HU#K@aki!F6:HW$KG$&"I"\AYqU0gZk%8nWVV%m+X%GPs
U<'D.KFQ[CgSS3#^j0`9e\mu$`j0^g(*SYh=Jnr5d$g$;5djN(^H-6"\1De30a+*G`b_2p\j
;hZ.LX=ifQ#lNOs'lrqSg]AV>pfuA`aVYngj8;cMGNl]AVr5=*PQf64JI&W".m*Zc$mY_Ra$$`
j6+^m*dR7G0h[WQ`bVRd&S!qD)DPHiNjNjH9gS9#R;)&ob:;5Ne_@!eQjQ`>*m/]An<l%.V+[
tR/tc\ZCNdeZ"n!sQ)kV'QA5"FA,Q`VuVt+YJTLl3%FfVoI-92rG@7]AlgdDXV6CdENa-@e0%
o+Qe:aC^MoV:5'@lBs(]A4#58l4Bs,h+t<ll?!mR'MhKWr^Rp*CQh*/e)<aEFgB;q@>b2<WeL
%>+iTG.n301'7[1<1YN>IW0<F5Mu:UWDVJT[#c,W^]Aa<!+Qita&`X1BoltQ(`kcX]AKbj<YR!
&^i=n$;W"!aj*J_@O?_YXY<fj3jpO7&18%?rip4]AsuZ,FJOScDt[rih"RbY0$ReQeT.`PtoF
`HdS]AZ$3QI\'qee'_/*<3BM0<TbKWWfP/hV*`PNn0&(&)s[J<_R7C9X+Vb*Z#a3&&;XM4HY5
=nSLXXp*t$"7-DbE`OsN%#Xg/Pb2CPM+6&12-tKGbN!&egB/q-LVioBEn^]ATH;N7.Ah7AZlK
QVISg?(bf0qL41F/f!\Ak]A^).'sb:5WKntsQ=QcSG<Se-HI93>rfD_rOOE]A5EB=<0Vsfa+Wi
O^[NLc#)YW\;)1\rADP60p<^a3_EnGqGb!I??55&JP2cLK-(-9-G(K!C+dWXh:dm/7iP8*8)
JbX['hS@L7oUO!@L#O4ud$V['ridm&]AcPLeB'2d6ZW;.Y%&g`!]Ad!6FRsI&"Q7dJ'e31@hm8
;?L;3SFmaXc0H:AtRC;*RTfuG!*,A@2mRlcF)[n9X4FP+aSPKb<U/uO#YnNP!F<XjkeIg_1?
LT=1@qGfs&^.41cj)/'O*5)FQHBKj7cjS#(_WeXh5ZbI\*-^?HE:6pGA6HB'B9*bplf"4/7F
o``YsFkc]A-NQb@#WF%"pYYQUXR4g(h&#dBnQoc"p2EGpj*r]AP2et&:@##^Y,ETo2F]A)P?-O3
RL,^&CP&,k(j6KLb"dbiPQ%">8<#>%VO%f.)<O7EnC_T!na4s14O?c[)[!U\=hq1F*R'QJFs
6RN>_dT;nT[V_!li/g*L)=X=^LF#![3L^>/ro;ZuC3"3ngHB&8C);I'MGR\XfWlB\)=k]A9$*
sVc-:K`=YFG,RCg56,2ZpD6t^23&$ooBcS+kAp.rZn_2A0TM"SrWX2)@O\YZu#/Y/k+U:8Mk
?Q^B5pl=R0f;43Hp:Z'm()b!:>P-_,pU(M//dq+$m;b18geRe@2rS9B*"]A_6PCZB8@;Z`"Q]A
I'R\=q>!0_Z3NC!5q=5cU^"_$9%C&pCT=.jl(o8V15hf9ir@7qgee0M*B0nGRH=J.SH>g2@7
Mq6IWqM'Jfhe[;`TT)oZW5XgNqDH+,C:h*mlA!HE.-bla=.aQh3ajSZLFUNUA<Gkh'"Yd3jZ
C<&qdI;pnj</G!9_2'`5r8R(@[tD\V>ep=":L9EB!JX(CL?!gK?;bOeAn+KC"ZK(QCks74tW
jW`-DaS>Eb3EP?s;=8V<p0eK%3]A;/a=DaQJLKY.,+-17bBl9cjV/X=Yl;bE3BO,c[FYki:?`
K,T=>1m%]ACKo7n9n/oL415^Y^!mb%0^-!Dj""dkIV-)9V^QS7+"`"G4\9g7Dq-kR__]A#"9ub
L2@.qPeHAI(M<tJCSrnn`1n&s0,on2Y5bdK!maM%!Dh'NHfb=]AX,?fM(GnQT?F#V,+>c!\T7
+,&2*&&kh5U)$]AiLk)*,R@Sm7k#J#MDg`96BQYlcZ0LSL$JSde8JB-HerB[/77jVhSJ@9Nf@
1"uX)?`cprs;oq\0g8Y8&l%]AmRui/Ia>(o*:1N:,?mX%g-s%lJ#NlX71T?Gf.5;l3[g"@f7-
R!_u-r"j[en,+64S[_YrTgR'3'3HaDt%PiE]Adia:Lgg<`jm%]At[mLO]AO"pd@KK[fF]AF<:HHD
?"(;ji'DbraBYM?,56#.;h`;Ho=/uC]A%gmi[7l?pS9;i2gRBja`Areb:chOU@I8M=UiTB'-o
h)5?ob#+V_g#@DX3D>JnuaDtED(0do)iIRMd]AEANRUA!>,OC736t=7->rhi@Y+(V!FG,G7?$
47]AlMS(2.:+OMB$CgF9@2&"3.J*7T6*K`GCc<3KKf[]ARE$>Q-hl>>ih+jks^/hX_,_@#C"fP
GqUN['au0(WO$fRuOo)`dUtr*Tc#Semk\8D-$fIdmK'Gf6EHSmfn!nh&GN"SLYH6#b\cdO3V
&^Q_$f+1`oRH_Ua^a?3+4qBR>;m\H1lkbg(Xe5^6bPZ[#[-)ca:=f_0X,1b:SaD=W4(oqha-
^_Gf9I:6HiAjLojL`5L4Vsu`egiL*<?[Ka>9VfLA?o7Z"/P,Pp+c4DFgtV*m&Sr6$tM3fW`_
Q:`LOZXX_k@@Jc'g/Ts0IOod--'fZR=\(&G#QXm;&.X*gkR?/^d0Aoqf-TjP]AZ;d=`kH3BFd
<F\UP%>^7o+^hRt'Q"i^j5dS^mAH@ppWL+IRH-(<j[]A#jh%Uf4k?=ROX[4EXh;b%d;;!@r?f
?iH-nALM.sGQlESWg02T7n`N<JIr"HJq]A#8Ki$&=b;W)m#\e$*0!#qR!LR$K3+2'a@"*;Bir
uEq!A,B5)T;GJUOAa8Lp]APHjSakWcM>BO10qL"R+pVBmU6OqH&]A4F_P*bq>Y\IGpK5L9h76-
/;Q4@j^QAS<&('Th^c'6<g".a<66eBAA@r!\t^QB>I5CN\p-M&)g?fb8m]A5AJ7%_"BJ)pH;U
a"BYV2mXG1IO`4t-5p:FGuXRlMai6R]A3O4U>eJuP(E3Qmap1a3'c(5t7t$P+=(k0HrEEJSq,
]A!o'q:_IOeF_bl_\(E$^6'c^p(1d_OE=("[63;aJLFc<+ggf4bBuR[50c&FX*u2i+mmI$e*Z
7P6`b$f>BsY-u#>PHQoO@KgQ-u"$7$=\J+RuBT_lPq]AZ885.OHMi/bn\C9iFQU8pg4Qe>p?@
TbuuTu8*Q+((*;6d3G`AV&2!bc*A4!fZT/V&m-sd)#EiTt=!^VOXLeGm4\>,1PsFP=k^q]Auo
#ragD/JJpq5=O<ETN?PQm."nkc>dhE7h8(\E$5_>TAQLC_tDY&_k`HdMLRR7KIG1YdLL@:rj
;+<.]AoM6p;2;WXDfIV]A`/,P5!:$\-LpPjWdnd'h,/i(4r9_g>_%6DFVc6NHB'%d/bQ&P-tOG
mC*8@!u\)U'eU>fcBj&%"EXs_1a.SA``8I<@Q4Tie]Ah#o9c_`h_p^IWk-fs"h>3A@W!]Ap*ns
27h]AH.6dB)R;J#X@Rc4,-$/>!'bhLF(48)fn>PFRFU0%8qrA(FP.06"#ZPs-0jD=#b9.VR2C
IBNahser&dDm#e<Ee<Ha!`9&;l2i4bVjTd&Z!tigmWDFT_,L4EM`L)`i/Ni(5M#IHN?-H:ab
B79M?L1W^8>H$7`O!0rVPA48ej\bO_A5n$K=1I>qcXq/[3?^b"!*#*s+uAC!oPJT#9fhF_1f
f7m>Xc,L+uAB'm9'P7u"XckrOVhGr0di0/RCm'<Z0/eI:9fU(7L$/N$\Z/!$jjhs6Y\p/ra)
KH0lUcn1Z5<2i4kp+olF5.UcB6V(8FF7Yc3$)ah+n\oOXqB,hJJ'B/Lf#ZPe8U2T%cVDs`b:
hjHkIDg(kGhKh1Rks81C[YRMG&B7FQW,pXf"*XA'(I5CoD6N!AB7\VMuVL!X[UCMtA%=:N*_
h[L^+<H[]A=,+;+TjL6$c+biS.5Cue7m`LY"%Q@jD-C/6GP`VXuq=GO,VTDq&"-bZRI`TQ;(-
Wc[W\(R>I^uKeKT;iaJ6X)_Oq.EG.jFZ``SU#[ko7[h=*=mG-]A^_YgKnt(=7OqNei<B)54K8
0S]A=^`Di?lm!T:pnAg?Fs4OJ3iUj9\ZDULWA56@SGp)1c1X+%@>3--UiqWL1]Ai79^nh*%-G3
ReFm9ki!9EcNc38@N8,QCJXbYpXd()]A/Kr9f7)nD,psJGDd$MKDqFOsaf21pm%,CB<=pUQCn
r@t7(ptn%!p7.p-mi9p1M4`,Gi;Ug^(!p5SGJO+ei>[#KALT:Ol(*@^t;eVo(42=`"%F/j&g
CG*%(hXd3\k_&RaRos"B]A5&rM"Y:73r_RiFpZ-0V^Jmja,Ido,iNK!A>$YaetpT=G-?'"$F\
NAJ*eNGK"2jIO>D&78pn$GI-a]AICH1j<EqApMB^eDB,5LY=ZKF[nK.8b-k)>98eE7q<$"J"Y
V)ke0LMk/):FU&ku45N1bB=,+>aU,Y+[BVqdg5)iX6G)m6dN&W1:ObGmDP-<ln<1Di8/$MBL
9O6l6N"N`_]AL$V$d5(7bHE^$Qh]Ao\=hH\H'CX[&HACnnB&KCNlBhK5e(sT^ZU2/6k-a=sQEV
1$UQA0TUTL[dJ:gR2)Bf=,S>.fZ<J,/+A=%3;a#*CH1Jps2Z<nGX^iQfIjV[a7CeVfTr#/S-
g^nH.*fQGMFDn:9BdD%OsR8]A'MaO`V?_]AHTh&-@,'9?3:Xg-KOuS(=G3%Ba:-@i[0rK@'-"]A
(p4`_%Ok]AQKqJ8F7Tr:X^%K9#;'0qhp?f:dM&(n:=NY7A$jqKkq)@kZ!g&hN*RapEP=&)XMt
0$qns!DSH9[J*^?C@^tgu.3R?LtJ$Z!'2$:PJThm>D(>&ECI9u:$:>ddfIC[qs%RL&#^&NM6
YJ4T/lctTU47+4mRe!=:iMZ17:q]AR-SQg,??q6RLV=V+=`aZ;kP^$;M''P\f/^VmTN3o`^!N
6^S1dqdC>]A(-;f`l6n6`jIsj9Y*3p$AQ8>:^#$ZtU]AR!rh20Q^jU%I2u0E/%/N3G=Nf"N0$,
$g0n\[UK/I!C8#Co[>4]Ab[qr$M/%dB=*9t6')sPiaM7S&2p0e/8&,OhdSg;bT,mTF()[@+d0
j60dmOR"KQfb6hm%8:7m(dtXo!2T*aMu!D^[eYP"?t)$2*:9h-Ra\#(qnLR(J8Ka/hFq)O#@
s7@ee8`..I<HI=(L0*>/./?cQES7)rMY%>5=.F"Xp!qH3EOQ"#?YfCOB-MnPBiFPOJp@N5+W
5f&qI.U!5pDJ^B-WV<R]AS6)]A@-Xf$^_IOYQQ'Ja'N2u*^;u9(TF<ct\(MLtTpPpK8+i>`R/a
S5eS*/Eb/']AIqnNA-DEi/9ZCN3uN2p]AY#5p'698.?PAnJh7-I%gDPK@j&TKp'cS)r1_]AA_jZ
5P/eQJ?Vd4SZnC?$)m=g.)[I%aRPAV';F"W0<c009WgX8,aib\O/ephFh?h?X4I>.!$U%4WQ
j24pAU-H#EP!>m[!uPRZBRn9Z#<jJMos:"cZ0u6IPpP#XkXQSI00*[LTn>.G":e_brM-5G'F
%NqF#1\qolOA(9Fu`^?l8LP!TE'jSCc]A.hPpteFENQX.VL#9_"=#F%&Z8FFm[e">)^%2EF[q
S@$-9L'OtPfYk@[:cAtX<Q]AU"DP"o.l==JfAX@#qj]AB0,e`BN;J,c&<4/DnjYRf.Yp:Fbq=o
I'2\o2Y56k*L8hBVp"<l25k#uap,ST.cVFAM<`!'nA^@3:kOTHiBY-(/ft4&o*G(RN4tH%9T
`*'%0iA;XB/ROYsaZ$ClOD4Hr;c)UN3I`Zn#+_sTtV@<[3of^u)0Tu*[SJ;P)oVb,)#ACbl-
icl^Bj^,]A;J>4)n'o&A1Fs4/nlNI0LU=jM`S)AG_jDkZeRfW5e6Q4Fgj8UHA&1=Z?<PZNm3e
^=Z3haW,n1&BH'k\bMX]A"O9#EBFX5rfK4e0SOb-C^G5$6Z.pC@OH'Z?$P-OTD4JGS,K6"ejN
QJOdP))L>@Pm%g=qkgQ>"9^Q$K05lE7PTnOT7U%'CPaW.p[!>FfHi"kK3#b3GV_8dU`Sd*[E
8RS<jQ)#CS.$h5::I[5<n!70>FO1bafGi>((?p9=_*<Y1,kCTFV^M*`jf2Y`$/p]A;iVM?kHO
$QEHB&gp7pC<Ll[J]AO]At0;a(Pm[BaJ$rb4K]A[$C[fbDc[)mq<V905J\`<,q#,7IB(u?7AEl<
ik7I.'?aqTF%G_E[sdR+gZ=GpL>M@fY&\6+bJM/Wn3&$epI9jPp3P9L_1+[aM5D2?69pLn@C
Qc*5qKM'@tRth7g*2:&=\!N4k>'m>ul1jQnJ0Tc65[)-[a8SC:hKEhOoG-E%m*mF.AC#OR%/
TXXlL`ahk_eu#^=7Ue.YU)eoK<jD]A<o=]AZsau=*+fA?5P0_6FUmY;Yd#G/9.$D<NM6Pcnja\
2EE8cCfIrB6j0Lu\"^r@k*hE$GD,"6aS2U*O=8MQg&pObaKJ]A)tV\r3Sta[FoBiinD>bnsN@
*P]AGu)[Ni?]AF$m*'".'tT7t&6TZNSPjeB`meY*7b1l%5>AHBBAWO),q<k?Z6TgAN\8)5EP;q
G<);RpoXf"U'\mZD^ifJHAZVL#Tj+"eN*3%1)d@a*rA!!#KL%!M?raeb&/*]A^N^[(T)QO;2)
rSo;)JEBK%g$@/,qP)\.BVn/%IO;KBH(<RD-$?+1KD%30C"WatZ+!5@(a(\e'Fc-JRYXQ_Qq
B_:a;fgiMrK^0L8TdiWg#+hj+qf3VfC`dE3'!+Q,\-]A;%Y=odo8-C\86gMbN7cuTkm_%Atf@
lQle6)I0;J+?A/MDqX?9Sn=[N\_(Gg9@-TeI@d/uWE5gQ[R:#[$6565-uo"H_0'\2V<[1&$S
dU*!$H7/'">)W%%%\,qpP)b_lV=aXA!)fEb`p#RBF0`>p?HOOnpCRr,N7>GKWoRQR=(C[nTI
*2/G/^TR<k5X\:;q-0:9+Ioh%7fF^]A*Rfo29Puf!#qfkKW#hteJtc>$Y!o@2@`p9%_n#Q>49
gEK:F^7O0gS8'D?oaK4K5Jhc-`?;8tsUFD[aJDj*-;KgFk!K>%.90?JWqO@pop4hWGrl]AkK4
^UG6IL(5dk=b_)YqMGAuFr+sOjC8/*E*?m/\3#a&.Hf6'DN(QlkZ#3a37Q/&51G#u(Jmiu[3
3G@s0U9?bH.dm`lksg#te6ZpR%>elS\UWE1BGH^%*$GrMkJX]AEH?Gi'Wa^&6G:UE1n\JMj?F
:3N4_>oAt8CN&6Ri%RsZW6eJoKdI0jf/^Ed:Ie^cr1-^,@=6$o$fst7?l&jV;QMkA9d3/]A`A
950U<6<u:_p&$1c`R/#@7rY?@Q:o!RgZ5aii<+I5I:FF=iG;b_%a5GD?ASB,+THhSWKmOCP4
_d&iWM8(rdd6M*g2n+sg!6ZX==Od=*N_1Yf@YF<ENS)U;n&pAg4N0EXJVS0BQ[Xn0B7p`f$o
(Tu:*JeA3&<BaAA6p4-a$@nflcrbrgW/gOZ2$+s'$cq6S?e<u$=N]A0=EU\BP/ci)Wn(V4&Z>
d"Q8_XZp"8Zq^4TiZEU`]A9:*7BcXZp>"-\r18Zje0b8]A7[3KE`d)$5lo%;(+"$`-E,O.ZV)Q
TPJiXj1^2Mu,*m"IL-ou]AeGi\[[T8-O+,WfR''.l%ekC]A-IBNLB81keYm(S$?b^`CRHA`X,%
A%qfH58(-hUHRk<DLqW3t\lj,qVX?Qb3pc;oXKJ=7!$HPlJ5q'pR$tSYZcQ@S`cmH+qeeQSu
p7Cu-i49@rR'A!o/$jauVeaQXN;<pMt@.eCmboo*fi)(@,lAj629/9Ei"]A&:b]ATqQ?G8hURC
cK62flFgrBG.,!OMuc$44lseTnHE<Q?29tuJ5K6DSNZek*SpOG-hg:V)sf;D<;gOK6kuQNkD
4Vt:M^lO7\ZUX3VTK9b_^CujXZaRJReC8n>H-B)Y=<VOM4L,]A<F%Nh2?T+]A([YM?b&6?DLaF
FG-]ATN*fMSkLRp+r)CC#q?mi<)J9uH"UD+6N1(8fPCQ;2GE8;7QSe:e$bGP&H`U\^Rn<FBoV
n?=*6rKM<j%@!LZ92i5!<W#g>4;HC4-a+^d-*$u=):fQq&*dQ5PQ5L+Q*ZD/5n'=@'mNj^>0
X&5E\t?%R7_0B45uoVYSaKk\!1UPW]AcUT!"cS)=k^u9Cecb`[LeJS76kSA+QeO]AaCeaCdt7`
%Ak\DZ&SdgSV#JSj?+sc1AYrqc=3g6=GDpaHT0Z_"pg0Pp/g/PLFeB]AqBJ#^Ggb@D=fDp"`W
UT8OZ!S/AHBI(:51W"na3?e_&c*$2:ED=5E\s7D69n2Fnhp37U)oOc8F9(or`sp"bnliTODN
Ur,fYnVTTgQ5E\r`k%=QYjr-^AEjJ(ELX\38>H[ttqbQ[l&:V/"0P-3k+3CL)5$l!c\Zp4!5
1F>6;Y5e5;:3'J_]A"`l!PdDR0h085f8WW_b&q3YN,m_k-)4^(7`d(1NDVIRF^pYpEnqQYUKf
`IaXGc#%DjOFNN$QTlc.F1b&q4Z)<JFaoo*qIR!M64DNsHV\SdYt7_/MJ<j!8(.@+jG2rFG'
dsk@G4gbf,nbsg1oV8`pig`<_V1qTG'Q>bjfclI76L]Au9]A'OJBGC\ciNqd6(<,BPr!I9!NH8
QQK"45HV6_AW[G`?\J='E&B,M7Mci2<`eigF(Lh=/7PUOGd;<<**RJAkXIZ"L<.SZ\TWrm8Z
EC@Hoa!"'=m49M6aAQ3[n-`?`u!U:O&)SGVocf.;nS5\hHIcO^G!%f7J*!:?V):FWqBCo6*#
jY>T9Nr4S.r]AIZs#kSqgnVVr5Y7?D2[6s`FC'<ppdG)0H&\VB/n'Hb8i7gdHZt6CqJ1HP+N<
MW<-qLj<P.%d,+j&Qq8@a]A'OE5V1*ZERG6d1(.sFW\Sc)A6NKF&`%7gi#5G`7MJfbh8&Fk.7
&[C6(4.7,'$8[P"dEtqpD=3R;Yh2c[=J3!PGn?U)jUGf?&c8-2UU9rAl7tSRX)s)af>!m`)i
\kFIQDQoA:cE*]AbM;P`.$n;Lu&%b;B=QS8L6?\>#\Gc#,@ZZ:/o+^d.Y%uW.P\ehmkiHjF<\
d<!;!tK#%pWKO?#SL<_qF/g8oK68X_t0I(&AF*AIq%t?_NKbCgt;97A+RWX[=/"\G%'[B2,C
b-I!E&K%n;)fL.^aP_4$"+Im`WRt&kPrk#;^='mlkqLZ[smElAH<+Pl;(!YIRhfY>nM',%;U
KD?3blh<<)?DYQ#[~
]]></IM>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false" appearRefresh="false" allowFullScreen="false" allowDoubleClickOrZoom="true" functionalWhenUnactivated="false"/>
<MobileFormCollapsedStyle class="com.fr.form.ui.mobile.MobileFormCollapsedStyle">
<collapseButton showButton="true" color="-6710887" foldedHint="" unfoldedHint="" defaultState="0"/>
<collapsedWork value="false"/>
<lineAttr number="1"/>
</MobileFormCollapsedStyle>
</body>
</InnerWidget>
<BoundsAttr x="0" y="40" width="1020" height="551"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.RadioGroup">
<Listener event="statechange">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[var val = parseInt(this.getValue());
var dom = _g().getWidgetByName('para_shop');
dom && dom.setVisible(!val);]]></Content>
</JavaScript>
</Listener>
<WidgetName name="para_viewtype"/>
<WidgetID widgetID="8294ee99-d24b-45da-97d0-6f276745bacb"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="0.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="radioGroup0" frozen="false"/>
<PrivilegeControl/>
<MobileStyle class="com.fr.form.ui.mobile.DefaultMobileStyle" isCustom="false" borderType="0" borderRadius="0.0"/>
</WidgetAttr>
<allowBlank>
<![CDATA[false]]></allowBlank>
<Dictionary class="com.fr.data.impl.CustomDictionary">
<CustomDictAttr>
<Dict key="0" value="产品星级"/>
<Dict key="1" value="门店得分"/>
</CustomDictAttr>
</Dictionary>
<widgetValue>
<O>
<![CDATA[0]]></O>
</widgetValue>
<MaxRowsMobileAttr maxShowRows="5"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="1020" height="20"/>
</Widget>
<ShowBookmarks showBookmarks="true"/>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="para_viewtype"/>
<Widget widgetName="para_shop"/>
<Widget widgetName="report_STAR"/>
</MobileWidgetList>
<FrozenWidgets/>
<MobileBookMarkStyle class="com.fr.form.ui.mobile.impl.DefaultMobileBookMarkStyle"/>
<WidgetZoomAttr compState="0"/>
<AppRelayout appRelayout="true"/>
<Size width="1020" height="591"/>
<ResolutionScalingAttr percent="1.2"/>
<BodyLayoutType type="0"/>
</Center>
</Layout>
<DesignerVersion DesignerVersion="KAA"/>
<PreviewType PreviewType="0"/>
<TemplateCloudInfoAttrMark class="com.fr.plugin.cloud.analytics.attr.TemplateInfoAttrMark" pluginID="com.fr.plugin.cloud.analytics.v10" plugin-version="2.4.1.20220120">
<TemplateCloudInfoAttrMark createTime="1633678816517"/>
</TemplateCloudInfoAttrMark>
<TemplateIdAttMark class="com.fr.base.iofile.attr.TemplateIdAttrMark">
<TemplateIdAttMark TemplateId="1e81fc40-edde-4330-b1b7-62f527985fa3"/>
</TemplateIdAttMark>
</Form>
