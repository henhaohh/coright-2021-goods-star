<?xml version="1.0" encoding="UTF-8"?>
<Form xmlVersion="20170720" releaseVersion="10.0.0">
<TableDataMap>
<TableData name="门店分区" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="para_companyno"/>
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
<![CDATA[select distinct a.shopgroupno,a.shop viewno,C.ORG_NAME viewname,b.shopgroupname 		FROM "POS"."TA_SHOPGROUP" a
inner join "POS"."TA_SHOPGROUP" z on a.shop = z.shop and a.shopgroupno != z.shopgroupno
left join ta_ShopGHead b on a.companyno=b.companyno and a.shopgroupno = b.shopgroupno
LEFT JOIN ta_Org_Lang C ON C.OrganizationNo = a.shop
where a.companyno = '${para_companyno}'
and a.shopgroupno not in ('001')
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
<![CDATA[]]></O>
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
<![CDATA[A08002]]></O>
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
        ${if(len(para_shop)==0," and shop in (SELECT Shop FROM Platform_Staffs_Shop where opno='"+para_opno+"')"," and shop in ('" + REPLACE(para_shop,",","','") + "')")}
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
SELECT * FROM 门店万购率明细]]></Query>
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
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
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
<ShowBookmarks showBookmarks="false"/>
<Center class="com.fr.form.ui.container.WFitLayout">
<WidgetName name="body"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
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
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="report1"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
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
<WidgetName name="report1"/>
<WidgetID widgetID="cd14ea59-07c4-4a13-a410-e2a2283c543f"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
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
<![CDATA[1296000,1296000,1296000,1440000,0,1296000,1296000,1296000,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,2016000,4032000,2705100,2743200,2743200,2743200,2304000,2514600,2743200,3024000,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" rs="4">
<O t="DSColumn">
<Attributes dsName="汇" columnName="SHOP"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition"/>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$para_viewtype = 0 || len($para_viewtype) = 0]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$para_viewshop != $$$ && $para_viewtype==1]]></Formula>
</Condition>
</JoinCondition>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="1" r="0" cs="10" s="0">
<O t="DSColumn">
<Attributes dsName="汇" columnName="SHOP"/>
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
<Expand dir="1"/>
</C>
<C c="1" r="1" s="1">
<O>
<![CDATA[序号]]></O>
<PrivilegeControl/>
<Expand leftParentDefault="false"/>
</C>
<C c="2" r="1" s="2">
<O>
<![CDATA[品名]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="1" s="3">
<O>
<![CDATA[商品_门店_单数]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="1" s="3">
<O>
<![CDATA[门店_总_单数]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="1" s="3">
<O>
<![CDATA[商品_总_单数]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="1" s="3">
<O>
<![CDATA[全体_总单数]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="1" s="3">
<O>
<![CDATA[万购率]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="1" s="3">
<O>
<![CDATA[参考万购率]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="1" s="3">
<O>
<![CDATA[差异]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="1" s="3">
<O>
<![CDATA[得分因子❓]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="JavaScript脚本1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[FR.Msg.alert("","根据购买率和参照值算得")]]></Content>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<Expand/>
</C>
<C c="1" r="2" s="4">
<O t="I">
<![CDATA[1]]></O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[row() % 2 = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BackgroundHighlightAction">
<Scope val="1"/>
<Background name="ColorBackground" color="-589834"/>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[&C3 <= 5]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ForegroundHighlightAction">
<Scope val="1"/>
<Foreground color="-8388608"/>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性3]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[ISNULL(C3) && $para_viewshop = B1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=&C3]]></Content>
</Present>
<Expand leftParentDefault="false" left="C3"/>
</C>
<C c="2" r="2" s="5">
<O t="DSColumn">
<Attributes dsName="汇" columnName="PLUNO"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
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
<C c="3" r="2" s="5">
<O t="DSColumn">
<Attributes dsName="汇" columnName="CNT"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="4" r="2" s="5">
<O t="DSColumn">
<Attributes dsName="汇" columnName="门店_单数"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="5" r="2" s="5">
<O t="DSColumn">
<Attributes dsName="汇" columnName="单品_单数"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="6" r="2" s="5">
<O t="DSColumn">
<Attributes dsName="汇" columnName="卖了的门店总单数"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="7" r="2" s="5">
<O t="DSColumn">
<Attributes dsName="汇" columnName="门店万购率"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="8" r="2" s="5">
<O t="DSColumn">
<Attributes dsName="汇" columnName="万购率"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="9" r="2" s="5">
<O t="DSColumn">
<Attributes dsName="汇" columnName="差异"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="10" r="2" s="5">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=J3]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="3" s="6">
<O>
<![CDATA[统计]]></O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Expand leftParentDefault="false"/>
</C>
<C c="2" r="3" s="7">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="3" cs="4" s="7">
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
<C c="7" r="3" s="7">
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="3" s="7">
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="3" s="7">
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
<C c="10" r="3" s="8">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=((COUNT(J3{J3 >= 0}) / COUNT(J3)) * 100) * 门店结构产品数量.select(CNT, VIEWNO = B1) / max(门店结构产品数量.select(CNT))]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="4">
<PrivilegeControl/>
<Expand leftParentDefault="false" upParentDefault="false"/>
</C>
<C c="1" r="4">
<PrivilegeControl/>
<Expand leftParentDefault="false" upParentDefault="false"/>
</C>
<C c="2" r="4">
<PrivilegeControl/>
<Expand leftParentDefault="false" upParentDefault="false"/>
</C>
<C c="3" r="4">
<PrivilegeControl/>
<Expand leftParentDefault="false" upParentDefault="false"/>
</C>
<C c="4" r="4">
<PrivilegeControl/>
<Expand leftParentDefault="false" upParentDefault="false"/>
</C>
<C c="5" r="4">
<PrivilegeControl/>
<Expand leftParentDefault="false" upParentDefault="false"/>
</C>
<C c="6" r="4">
<PrivilegeControl/>
<Expand leftParentDefault="false" upParentDefault="false"/>
</C>
<C c="7" r="4">
<PrivilegeControl/>
<Expand leftParentDefault="false" upParentDefault="false"/>
</C>
<C c="8" r="4">
<PrivilegeControl/>
<Expand leftParentDefault="false" upParentDefault="false"/>
</C>
<C c="9" r="4">
<PrivilegeControl/>
<Expand leftParentDefault="false" upParentDefault="false"/>
</C>
<C c="10" r="4">
<PrivilegeControl/>
<Expand leftParentDefault="false" upParentDefault="false"/>
</C>
<C c="0" r="5" rs="3">
<O>
<![CDATA[商品明细]]></O>
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
<Expand/>
</C>
<C c="1" r="5" cs="10" s="0">
<O t="DSColumn">
<Attributes dsName="汇" columnName="PLUNO"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
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
<C c="1" r="6" s="1">
<O>
<![CDATA[序号]]></O>
<PrivilegeControl/>
<Expand leftParentDefault="false"/>
</C>
<C c="2" r="6" s="2">
<O>
<![CDATA[门店]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="6" s="3">
<O>
<![CDATA[商品_门店_单数]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="6" s="3">
<O>
<![CDATA[门店_总_单数]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="6" s="3">
<O>
<![CDATA[商品_总_单数]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="6" s="3">
<O>
<![CDATA[全体_总单数]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="6" s="3">
<O>
<![CDATA[万购率]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="6" s="3">
<O>
<![CDATA[参考万购率]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="6" s="3">
<O>
<![CDATA[差异]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="6" s="3">
<O>
<![CDATA[差异❓]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="JavaScript脚本1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[FR.Msg.alert("","根据购买率和参照值算得")]]></Content>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<Expand/>
</C>
<C c="1" r="7" s="4">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=SEQ()]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[row() % 2 = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BackgroundHighlightAction">
<Scope val="1"/>
<Background name="ColorBackground" color="-589834"/>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[&C8 <= 5]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ForegroundHighlightAction">
<Scope val="1"/>
<Foreground color="-8388608"/>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand leftParentDefault="false" left="C8"/>
</C>
<C c="2" r="7" s="9">
<O t="DSColumn">
<Attributes dsName="汇" columnName="SHOP"/>
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
<C c="3" r="7" s="10">
<O t="DSColumn">
<Attributes dsName="汇" columnName="CNT"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="4" r="7" s="10">
<O t="DSColumn">
<Attributes dsName="汇" columnName="门店_单数"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="5" r="7" s="10">
<O t="DSColumn">
<Attributes dsName="汇" columnName="单品_单数"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="6" r="7" s="10">
<O t="DSColumn">
<Attributes dsName="汇" columnName="卖了的门店总单数"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="7" r="7" s="11">
<O t="DSColumn">
<Attributes dsName="汇" columnName="门店万购率"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="8" r="7" s="11">
<O t="DSColumn">
<Attributes dsName="汇" columnName="万购率"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="9" r="7" s="10">
<O t="DSColumn">
<Attributes dsName="汇" columnName="差异"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="10" r="7" s="5">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=J8]]></Attributes>
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
<FRFont name="微软雅黑" style="1" size="80"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="80" foreground="-1"/>
<Background name="ColorBackground" color="-13395610"/>
<Border>
<Bottom style="1" color="-1"/>
<Right style="1" color="-1"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="80" foreground="-1"/>
<Background name="ColorBackground" color="-13395610"/>
<Border>
<Bottom style="1" color="-1"/>
<Left style="1" color="-1"/>
<Right style="1" color="-1"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="SimSun" style="0" size="80" foreground="-1"/>
<Background name="ColorBackground" color="-13395610"/>
<Border>
<Bottom style="1" color="-1"/>
<Left style="1" color="-1"/>
<Right style="1" color="-1"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="80"/>
<Background name="NullBackground"/>
<Border>
<Top style="1" color="-1"/>
<Bottom style="1" color="-1"/>
<Right style="1" color="-1"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="SimSun" style="0" size="80"/>
<Background name="NullBackground"/>
<Border>
<Top style="1" color="-1"/>
<Bottom style="1" color="-1"/>
<Left style="1" color="-1"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="SimSun" style="0" size="80"/>
<Background name="ColorBackground" color="-13312"/>
<Border>
<Top style="1" color="-1"/>
<Right style="1" color="-1"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="80"/>
<Background name="ColorBackground" color="-13312"/>
<Border>
<Top style="1" color="-1"/>
<Left style="1" color="-1"/>
<Right style="1" color="-1"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#0.00]]></Format>
<FRFont name="微软雅黑" style="0" size="80"/>
<Background name="ColorBackground" color="-13312"/>
<Border>
<Top style="1" color="-1"/>
<Left style="1" color="-1"/>
</Border>
</Style>
<Style horizontal_alignment="2" imageLayout="1">
<FRFont name="SimSun" style="0" size="80"/>
<Background name="NullBackground"/>
<Border>
<Top style="1" color="-1"/>
<Bottom style="1" color="-1"/>
<Left style="1" color="-1"/>
<Right style="1" color="-1"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="SimSun" style="0" size="80"/>
<Background name="NullBackground"/>
<Border>
<Top style="1" color="-1"/>
<Bottom style="1" color="-1"/>
<Left style="1" color="-1"/>
<Right style="1" color="-1"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#0]]></Format>
<FRFont name="SimSun" style="0" size="80"/>
<Background name="NullBackground"/>
<Border>
<Top style="1" color="-1"/>
<Bottom style="1" color="-1"/>
<Left style="1" color="-1"/>
<Right style="1" color="-1"/>
</Border>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<IM>
<![CDATA[m(?sr;qi'?MRjNaW)P4^D*asjPEsiu;%QT^&.jpM"G?cKKV5'6J4)i%L29+@\eILZ(*HLB&O
Hat!e_=U#ULW#]AYH-ipZ@ummX=Q[+7J%`>a]ABQ0ub2MN\S<AoW"%iY3l+qoC;A<\p33#2*Sb
!npGhS^g";;T"sCJ^@:Zh7UA3(lFMJn<7R"8W>iRJ_=r7/aP;)jkb6u/XTrD#Tas&k$_DLUp
2K`@X'\5Caa>%V8QD."_):iHEa<\[;4D>N_Orgur%FX'V7o+j]AZIEgQSb:i7"ddLE6fHa\\N
)C`%Z4PU(PqK$T`1Ioe[FVD=L!!5,C"_^Id1*VH+S.\rlI-htoRV<^-2cV@J=2f)!0p9k5S"
T6D\2%6=mZ.Ne4q=rXeLXR;\/X%reQR8<nHlRsAB3G#Pa>E(NFJC8@MRh`!M*kf9GiN(;6"@
,Z;\D%MoS."SX(32/[Eag0Cqo8j]A?!87fcWb5N4$RWhnhP-`H?Yhu+i.68XD'[VV.A3W=9%O
bb6kmn0'l@BG'5^+raU[u5L4;-2rab=2\:I:nE!.IS5*t5*XZ"Z!AnCZrmtpeF,KGb5PP*4[
`]Ai%ni$,b-J`<%!KY74lOKA8&)QL<<u'JXaq'$K1hS'=:/IAra//_>n!@-E_)UHmk[gK"Od!
M:A&Bf:"cj/02oNdiP"8>]AEA]A,WaoMX7.tae7de#+D`1kn\%FpSiKoI8h,S0SLojM^=93kUC
b3f`B061!_g6M=+Z,a%]Ap!'o>',Ss!e(q(e]A9(Hih0&nZ"I*R3ME"EW%^MAq%E6A3p8%*TJ'
%&^rS,R:5!J_P*&YAM@u9GmnRbPX:q4/9`BoX?5cef%W,Z;]AF>C>$>$mC*^[_1tD$1UeNb$f
R[2AtS+)VbdWd.(ENP^L3YsEUWHcfIUm`,b=NROan(>@ff*C^c\$D]Ac:\]AHefhtdJ9Q8M-ZD
?A2enEbOPmMr,C-QP#YX'@R\;Z?6/oT:YTm0XSe(>T!':M=H-[Ej)ErcXW\I!g9EA*_^10n,
3+oJ4D&FT[G\DkD`3\1aDcli^9EX6[Q7+JCHFSdSIbCa9o1A*G_=@/V;+ed8*5o#_Z&<[-4N
8PL/5BPS@U)7EI#,%C+C)<le5TE.JS9q9S8BWBM.m_t<5Y3kW.c1,N_TN]AEQ]AkkD+`q%c#\U
8c8cE&7rbCeABrh47uVLSq/HH7R+n,("N*g[Xae*^0d<\ILU,eG^aq[fYUBZhMG@b-P*]ALWC
2R:_mr&b+&`+BUiLFJOQs8/tc4%bUK/huKY^C3/?Y7gA0g'A@G*)9\E_f]Aj[,GAhF`mM!9K$
6:(dpO]A9?XE'K2Tqc8c&^Vm"10^W.g9c+q#U@E9@3rc\f2OnXpk;#KO>?&;fQLRNJON>0`Ea
NR^PMB*D<V(KSIG'c\&hLFOJl=8GrHnMF"I`RH>Zf#Fonr\c)oK&p]AMn0g/g;,3Ok,+BQ.3I
??)(!ml/>hqmWX/M79_nJ-*o/3(nEBb<E>X5rF,L#V=D4\'EWEZucpV2>]AM>&Df<'+U<bf!<
Y["7:*I8Q!h,VY']A;Gp)0od*$%11K"/KX$nC+8)9g-FqTQO>R>D$!E16%PPj6s,mc)"h2O_7
*U-d3"Z9#E.eV$/5,-%_r:-1WND!<%07F&]A[9,fg9PH%h%5b+5qf_>IK-a)!d!/A$b:-DMbG
t%9d?i>*d?`WdE<r4_o\nq)``V]AI#"l9t)$Wq6%rh5enUXNTK&VtJaR_<V7<RXF4kSW]AiMt%
Kp&a6Bs:Sbkia^nIAh^dLkS9<fXH:Y_V,<.1C]A;8G8eRCbt+GI1^n)VL![re3'*Afam>OqJb
Z^W$?pce[t,ghpZ=bABt<]A!a\GX&-K`ei>I)^-+dRW8Mu7=760f'@m+e?]Amk*(u:4CKM0:`e
UodP8V2q!kS@t2d(=:08_`m&K[^urd":``TUiT<MO(fei'pt?8#QfS.2E?Uf?+rR70WT68l$
^Qa\l-fS=gmg'!H-2oBpL^GM'9&Ajtc@!.GZS$SU^7NKRFU*$)=T&g_n)VjVT9Tk]AS5Mc[e)
YU#RRN<h&\O;.1`]AMqJPq&.g&YS,QV2ATgn>)`A1()HnkClM:ipC$@mGHVtO?>"k[]A=ieq=I
<uEr`=Wd7.dP(cZpq8)<J:.7rYd=P?oV_/53^::tR7N+5cT!YKk$^H/i0=+rah\:J5Zp$QNa
n)=5<JSQY+q"R%L-pQb6R3-O@2pJ$P"mm6@]AQoF>XA9/c,"2:G+j8Pkf=L9_@QEm]AMDj(&if
i'*N`^P@Nro?2GqK:n:b`t(]ABAp6([l&pE,"+$`W)^K1iMl%gP"WH$d#TrE1Jcq`+-5JnTU2
XI!/inZtn2<H.Qn"S.@-ID&[J>euF%)bM(OlF;XW!q_sFM.6[]ALN6J(aZI=l]A=jdFFV%WZ&A
FkToKS$M;=_&Sp6^u;_-aT6hlZ"ZT".FL?P:s5+]ARK53d4QCc[b!1k6Mb)/@&Ah&QTlIiX9+
I[X#U]Ao;QmPQN(d(Y(i]AcpGq#`P);.eFOXbMX3UU1@"hd`m34.bCNPU+s2f\GL!ucDaMfL(m
1Vp2<HEu0DN9X^6?3&a$WjI<frFW,^>\F)7GTT-/BlJ<U?ks++APT'9)(00c)I;TS(n',FT;
\4fX?<dMHXWN0I%=JVXmE+/8h,.UI0>[7UQbAQ^5TY]A,*1^XNU&k1UH8.=qp'%`R_*10nG!O
U2R`BR,1E!Ji.eClV!Mo0q$G^*m[hK$UIntq_83>oEJR2)ecjfApenGmOIA>ZDtN1tq@>EkN
j$/%n\]AX8^l$Eln/+m)Ld0@iI3RW),"KmQ^[is,[Muae_eP@r8a.j@V&$&j(eocG#W*<#+YE
_2IUB_WEh"dPNeG<<lneBi(Q2)']A=+*r/uYeV&#Y+Q`FVo(K=)!>KIS0pR2^YQfja+dQAp@>
o<p"Sp7D6ph,liWcrPCV*Wn,K2K&CMf6b<L9s%0GhW;=X;MmHIjAiWM.k`Fg8uP'%P\6--14
s`bqc8tRAn4[e"3qH8N(F(-Sbl3\J)0U4p@Yjolp1E<!(>D_IeDtm8GGLue;+Z`]A$>,fQf-U
g/mFKk?7i<"ZbGGtE[mj;9qM'<dL48l?p]AU<Y@g<lX+M;VSmG*gZm/!oaQJtsNtkG6RsWcAM
Qp+g<_Q>t"IGtD=m.eu?rVdsWgZEGFr6-X6huMaBCZKfB4pdP=VlHHOB>pSrdd[1aGK?dM!>
9S+p<k6PQd3OK(7m_`a?@8=9C7nB5Bje\P27N#%Jj!)mEsM/ZWu8C.UoJ#is.d[OdXZlaJP>
JRu#[.ICusLu%Kl\k3D&`AYZtdfo-:7;Ej(E#<h["UH_9alpb:GM2BMo?,mUO'gVg"d[a&Z3
Le=Af_9VJkr(@(/;59c8E0h0[td8#\rH1;fb9bMLBXZO:ViG-qAqD'\)"3P?((F86<<r0sfP
s=a:&oqO+BfO4.+:+9J?MU0E(!k%Ma%E9SRh4)!)CWqD-R9#@rqc%'.b#m1>(/9oK6ffkf6R
7eDJO@;Cu)IQOTN/.'::AqaFnIi6re8Fn!Nj&*ZW3PXSB."&4J=8ZmC0N/RN.5hlF9tPWWPW
[;Sb/<*#9=ko1i(L9b,;CP4Gf>bMBgVdPfbLIGr\P6=bBHY$GM&P=g'?Nk?%d*:TTC--8B;U
FblRUT)@i'SgL1='^'_B6S-0,0j)puM$%,&`@=pOOVb(HXn25eAFo#g:]AhEhBXGg#4gd`Olo
I5sP&3Ki!!7.7IUX%%?X`]AhX[-0W%:ZT29APMtddh$fhWHVg)Ic)#*TocB[&6BpZ,BJ]A.&ko
Zs&j+!SU_2^erWNkU@IdjShK\:U?itmh_Vn:@P!/sQCSE6oGZu@]AQ.*RI-5&+I*[8>ar>.`n
1OA`-[:)B*k6"B0l^Zki7eVbF[#cN14,f/cDVS>;Ef#,9@mpbL!N(*8;XnbDT)W4^oH^M1\)
RjZe'V\?)KW]AY<5!g5qLmL;$tDC1>`j':otZ2M;M?,F/>t4>.eUDK-hIhR$fWmn$t4$fqq3u
d`.7;32FBBEZ6mojQpF;."nDd<#K)J*74Lu\2VAmShU7?;T]A[*7R6g#nd)-F/'m/iRkkf(I9
Qn>XCSkQ.V'O>jY`2:a;nK&i4P[n9I+$n>7Yplp/Eu^*OuUa;Y&#-Z[993"/6g>5h.b3Wc=q
/(3M.!XQ)iTCJcgnV&imtoLA0"qp8;$/.Cg]A'u3G:i6@p-\W%f5keO%bYnA<qK%!3@OfEa\[
;8?O=Fmg=5`@M1"&$SQ@mg%totY9XeT$(S+JJ$_*ish\l%(dM8fSp+4jM[T%S%%#Xa6#F)q#
!745%9*nI/A*Q.st(g,Qak2HK^E[bpWgj<0bp1o4XH)c_pqi75tV\MFBrCS"0BJZLW,65TYn
G-OKObQKgd)8;?GXg(InIL(^G)d^dQ[6[>k-gM@K$J$Yg<ZtbKV))1d?IDX!%.NYCpXJS&7D
`OLnZ_XtE6J<k[]AbZ4l[-Wa:,lT'fsn6[$r0:%Q`$7*h!8%e;&V]A3qQsV#nt*R^Sk(%bDO8L
"Q6[)<hQXg-*_dCkTe7]AsJQ+AFnMDQC8%6SRg\UqaM&l;.b<fi?Du_odMki[)1MbROH68"b%
th:i78[J$SEM>Y(^?cR@[H=hZ<5[<=jU0BA$D$,J?F&(d1Bk*A./i2k#WrE*pO(,*[.$ZgCo
6lhCcp0[N_#?Hi!tceU9S\YZj6<4+Mc,I@:6;L(`]Ad*re!h8"@cBgIgX<.7"R\#_8r^fX&YF
&U4,@AIbVM&M"/o%%Wa#194RchB(#Kp3tg+@W%rQ9Sm0nI7Oib#ZeViJ)8YdddS$q@_@SH4u
=_s!ff&/CQ;E=m]A!'9[tZ*!Xb>fBn4Xk\H>uAZd4D!NTP*A^7+^k#nd<^!AT-ig$@-oUY]Aq4
-b95H1+OT=PW(!QZV>?K[`V^2]A-<Hl94]Au+C(6&1^`9J]A6dG9/^luq7X".#sjc]A0eZ;Y:c;*
%_8?@$&fZ8?]A"e%E<6,VY7X0c"8tFaPB54m?W%Q#OC\PZ]Ao<;5J0?C;,M*O`<EN7kJB]A.rWp
dp>&-IDY>5mr%1U10/ja;*O*a5emT_6n_g3p<.5HRT#G2@O8+;h]AB/#5%dN?V<N:QLl4b4OY
:7Ij:`L5pu\'t\sdj;gNd'@1uIJ&r[BWT[Y,YeGgUcP2KD.UTle("/oD(-ENLUF9j(0e<6pl
:eQM]A/'#\T*-`('j()eTi^4(E`=@MZeoWk<@Qg"omT+g(bP4_d'GIq[A\R/tZW52HEKtKsal
S6AasgO>jSnN:g)i4+\'73<Bi>p)pXC4318^)Jp@$%4u,ZjWj-J*QFY64d;GY6.AdW#c<2rW
0M2#5Md@1>dM39+8OQao\'Mo',.(!Bqk)7hmR]AZ._@/$cN7*F;s.4@DCk$^^JRVHaDkF,iEQ
[rXW+8NI9(QM@>_>'Tu:t6a&&M2cO3GmI)V=-H=oPKL>eMGNG?'D)i>nq&D@E./8cU*_eg$_
55;;@Et8T!=,a+@NnQ<Y<H$kOR)KNDT0Bu*=751Njj)3MA.7D?*M=*!Op"eJ$`J/)4kP[>s.
!XP4koD*7"Y;=l3JmQ#3uah$1?rT-l'!$#9>mG)JuOmF</VQ"tVQ7n(%B3AaZF]Amc06mS-b.
epWQ[pb"*mVE.d70p>Z*[fp@NZ<,0#i\.6mb9^$\X?1?RD/sb9qlX9H0c;$Ls$'=cHj#ZF2a
86XXc4+MFZD*I!2NjY5@]A/fp!27[ZGABbnD[f0p%q`a]A>W@SK3>PaZo>b9bgQ'u\4+uZ*>h?
XpK_Zp7(;Mooh\ScYJU3u7C9@poQWE"m$)U^P=tdpdK4^LZ<W>VYS0Ff[lQHi*1Xj_S*a>e[
r<&[qS&8`&5KP_^Q.+m`^%OUE/!.VC`.?79:%aK)'nX[rJ4BbBTReJtAo/X3'YL^c7ib3@Zj
m"HV\8f,G-IO';_6-79SaEI!3**H8kmY)mh&_b&=ia;;_nqDlO>oP>[Spd"a4aJ$GF-m3'W4
'1[-T\#I>004([Z?P\'=97tI`R_)nU/Gp'@QA2oaE'=lk??sa"RIu;/8SSRoP_$osY`6Lss=
i6J)9$8M20=;AjOn[fhHhRF2MdF&%-aA!+$bKeH:cL$AH_\#H8!SKbo"<Up#tEUlk8bX6d^S
mcdomLJ=)e90O&'>rZ[$1QUtG.J,**A&-S:2N,:Wg$/B)giL`V&o-+^S@6nttkP,o`$@S_6&
Vn9RVQ=m%pG'Bh&J*Uts4hLGss#QIHc0<A@N+RhipJr(F^:+Z'-H\?@F4I\Qi_:)*qi`&THg
::nTT(!K*ED;OXNd4ti/md2G:YDM1c8QcO\a;TZh912Tq>pZQu6>hWV"hA"PFh.1EKqcJ(7O
MU1<B.CVSBs;JbWkeIX?[ATeS9j&g?Q$*3WSl;lpa$9'B_O-@J$_Kc0e[=^pCG=r*IXkf1&T
W]A.E>W2Zd<8%JhKmf-`ZOG-,ES7Jf;XC;SS_gV\B8,E)k`IbPm4'=NTmQ"*7a`>E_T#.ni\s
-c==g#b/.:HaWS&OS\#p_MKjH/KODe,SrN_OM;)[u+JrJFm`c[e)\<[:`MA\`fcQmbWku#NG
WLb">G4L%^j.D4c`A_jq+Z,`jK`pLo-\SD9fPS#*nD6"nGNrgHVfnXp>>tTBa]AS*n?f6F96q
juh!GAnY=]Ag\pCpM#aQ/;K=R-A26[)"cEX)?NtP#Q_br.G99E"4/uhJSW;KU_.0JaVYIA4d\
@@N2uW^3T5!htQa=4$Qi+QR`MU[O;11_7LtK(-)`\_/n@@*h,Q`+^9qLog[Zahb7!TXT/oS'
hCr/jZ7T4gdW2k!)WaN"NuM#<2rhRF%Dr>M.7;KHL<Kr7;GB2>iD-ZNbOSH/WSW1QXl(f'3u
s`iD6c)[<LuU4ma[UFLhJ<r-%r6jt&qdDQAmh?Xt;Xc(t;BF\m4:g.eGp49Ydm<blt[[Ep]Ai
c1H$'q,PeAfdepNkX=5cq\8Kd>b;rqYN?J]A&3&&8l%256-N1%%C6`MZVR=rZ*/j.o?Tsq\J?
W9"q9@brCT*4F[!uk!i\AY+mC+A/rIF65:X1fA!/c;c$6WNQebVaogD:N$m3Ob\H"GC2#.Gf
i8Ae6Fp5ZG2\:'Ei?$Rd&F"QIK$1kg,cr/V6UmXlqQIRQJIL37#o8>=q=2(r?"PcC^+B/P!&
0dc]AQXj8K3=:*QV`XSN96JI/a"iFXGkUgp)prZE9B1^A7'e:t:ep`2>t))hrNQ5Fh4&#t:Hq
p]AoA\Ji[61F*43pcAkINJga;:=`dRpjm'7XfdBN;*%n99?rQOqNscpr6r:%[_VF:QkfkUFI]A
-u&G=E;\u1*lX#0YTEO3:/rED!=4sg7HH%[>*ph+#g41@S9a6[[GgQe>E,?^fE%V'FK'>?."
'bqTN'"oI1"JBckWn;KepoShDackT4-41WZN6;H]A?1(HtsRWR--3F^@nNgqR*'J64D>dY6cV
9dtK_.BZ-3-`VP/$U@Ms$:=e:j9QQX,:t?khH3X'Vlljp/rRDcH]AS#WiLL#CAKJNkPH'3S<9
Y#?lgC.=f.q6I`Cu#fZ'fBCfolbPdKA".WV+VRWC:%=C?(2`L/PsbI;+`ICkqDHg<,:8jH!3
a&48eK*lCI)b2;Pn%H]AL)($T+W#(I^uC]Ac1`-E>B:<e=[u?Ak,k[OfA:m1D!YVr\3f^eM#n<
#bK=e[8<%C10Ha\A9aZWQpHuGg@Pou^,n8'QGAiu*KXNE%VOGTQs"a?&4=(NWB'G`?@S))0D
D#:Os;E4f0o#;riF3(H1?9K'e$<bU29<"RqcFtE#W\p7?>hQfj%j:#I7'pQ>?13F&M&+fPfF
=ZX45h*hO-DZ7c+*PZ[dFCC:JQR'PO47*0A3$:<'7'!Ml%<2#&.cg>MUA2o+(H7i\'EYVHtk
3f.lK\QE9Y#ZnO'q/Of,%Psc5Kq8D1q0im.CqD/We/BU&ogXL9="4VfS0RUFJpa>p3k%Ek##
jbjD/R'Bn(#<!SG5NC(4[f>G<!.Y[DT)$@8Pnh52o-H0&l$oV6NigIi>9IY+cUiT_sPrD_$i
FFZgPEX83dZ=)pb2MD6$lQkrMM*(H</aQ-P2UAjhN^piT$CZp+f\=@@e.bVdjA*'qQMD.:\7
>Sek0q+EZuJI9<J&)<]AG'k?iTje^OEA.Lhqind?edI*/ME80-%1UJ+=5QKqdn&fo1=)1\:uP
40B5\Tk"\u5>"Uhg>af*Y_IZl7>n3U9N2+KUPE"NN?t"*6GlZFt\sns-Vi0bL61UY]Aj;qfIA
X:j18u(G-Q^<X->/8INF&DI"L<CTCSA!_$%)A)'JWZ2.g;!5m`tj`@IuBYVFZ_M-2W*@jBJ'
^Ed;)0<N[",D58,_c:/1`DL\%h>-Ntb'Fk@sj@sba?G:0JEH&dRpA@c!UHMF=FhH2f'&CYk>
%e6LElIJ$@M6b"2H&Oi2]A(>H\$?*>*<Wc0;'<san+]Aa6:+=QXg&lERP?<1tMYn.gc'K.Zgc)
BDN;,7S.r6(r)>g&qA"e*a=nuEPKFn`)lXu&uR#(dXmSpFmR->8a13RB`aYX]AUPAp#,nEsJn
0QObTp-H:-*0&&<U#C1\H2!U2R?<M&Yd)g5oG[`q`*I\+OZWZRJ[9TD!6Qfs:l[%sf"+qCY;
`*Mk:?#8G<<%+n;Cs9+BjdhkU2L"WV<=m>;a;^"E#>,s7.N-.^Dro%"o$ZCeQpq)EK\Zq7?^
kR%&QuZ4N?[5,CI9dHnXSU'-d:L,LO>0dA"fapX(N?@!5X1Q&_(fX,C+#'+9]AV$#+s//O/MP
kMI%1)*FIf&CF!SV'bP69IQ-<IaN6A,YVt1hlZUNR3-sak)U#`ONPXA]A#tPGq.!i>UNgm:nT
BMk@rA8gG`6CY*[j>[Mj"Y1*(%He4(5,94EBrN?)X,)Xs]AOIJ:.ctkgX9n8opB2+Y>E8g,.:
+C>=T'*ZY5T#andbd0`bG+M2sgN"^/Wcd6]AiG;$ge^*BEObZF0/'sc$XRbV*$;)+h3$M^9S`
;[:`Fu]AEWe802Nb^t=R*W.#IHkEID4+H;ho[hsjqKbp,9D]A=G0M1`:e8\4`"gpniAKg^p8^O
WfQ3-g+X;g<6ZVdWeN2P_.j@]A:4R`HnWq+-'.Fe6jRK!H,il.=aI*dWU0LG+3Ds%Y2F"56$,
K9YtZbcQ``(js@IMWWL#rC=Ur@-[!5S6Qnar&QL4&.<g;PLZDdH[:pQ8Ydq/MaV=(r7(T>c,
(4KWA1t&'/\@?Qf:K$&@FVR2>gN8E$!8c,oJ.UCP&r(`nS5]AH*=ADFo^U7*MSjY=;p)%fEW>
qLeqO0%tn]AZIJE:(q(>98Lu]AogUR:4)bg02gdELEso=E[g<XLeS&Eso68P;5TE?6pC?Z,]A#?
n"qgkgN?PkI^[L$ZjoG;7J465(GJGlS(d;=\;XhLm[C[.fn<=:kf%DAcBErai8Thhj0Ck:^M
U`HoYI%7"F2h8U@XjE.18W0[DPF5fp(5.bB!<F[u^4&OWdE-5hXLkZ1^NqY4"Pp/DCQCpmYX
#eZhA8aK,Tq(;uuhj_)O8di+/OV`DXLoOa+@!8hKV+'Vn(,J]A)eqX(UmVD&-MAD3O9J1MU5e
pD>]A)2"?Jq>R-]AA$4O9b*V(O`+<SHF'Wa>EZ?0S!3NuZ#g0a8c_/[+U%"8S3apYL#;U*TONL
VKaspg#LuE2H#U\+f>;``1hq3J[UcH'2\BKHF:j,:"S6oH$),DQ0)S_1na6LBH3-(*DkE)Ja
PMTIcCSfBLR<?31?*WFg<R\"DpIL3$ZSfN_R`HGbqJ);<^,esJVV'(LoP9+aacX?<(mK7Z/e
Sjks(Jk>pii*:.BPYs1FC)W^PMp@o:-!W>0+:kqq,>-0\i7*DXDlQIp`c3t\$ri:%F'0J:8h
nR%H;W63itn5R9P(!X>JaEPBt(*4NRfm'iEhJ=p_707=U-S5;F:$G$8grpmho@b.;GnW#EOu
DIp/0Jl<@i)kB?7.Jcqg"ZIYE2MjhTprrSl[s6QaW2rhXC+RJfU8:74AHgJ$4j>p9#3D^*%'
![@.AJ-IuKAph\T^l;hPl.iR05NQH)%bcn<&JQR8GlpKLa1!b@AS+M!B(PqdB)mF4l0Xc#dh
ugG3a,7o7El`a"\B/DUf:pu]A=Z=5%TiOf2rg`!,%$(k.a!g'Jekou,UC5lqIS+mtZS52so2Y
`l$b=Y]Ao+Q\='-CcM^-&q20G[hom5(dQY3#+a4CbuaAmbeTR=a-pQ>+m=H*#^Tr/`@Q>a=oG
:;6O7f8UdECbD5^]AI1e#p6(]Ak\&t?F.*^@JrjQ^\l)Ojj[j(H<\l\>BeD+7iC>E.Dinm\r]Ag
M$#pXEJq(oJ,Z1V9tY^A2a@gp(NlYN&V4oQj"83@P"?:'Mm\>/l?okt=4YoM1!Ho9s')8Y6g
Ypnti5mF4>QYiaPp:D^B&3">/@D;.f#qY8:e$\qSga#U6WS>\_GJl9HqXt4*U7%DA5.JrhGc
T*Cs"QS'<nGH%&RCm&u-Fc\/:.[/='2nP]ADW^3?Di/2N7$(\7QI#Vlrs?Ute#TLijB=iX$XM
2s\#!,K6-"m0Ec)N]Abch7+BQ]A_(o0KVCbLY&?+Ol1C?4)/L-J*1N4,Qm;b8P"'2Bm3,R[JRT
(@Gk'52)M;/)0UQ%eb$@[WerDJU*Z!O,,XY-?OQP(mF,VT$UJdr=<NFf`N;He%Ne^2-GS_;K
.t<OU0=M$NTTJNPlM=ieZ?gaKRfH5flNo<c9bGs6aZCYN?Q!er%D]AMbiYf?Yc6JP>CRP-\L=
S#Z3^I-N)mYs.@0'Wi5pi$SZV$gq^tN(\m'ifji&L]A[iB60f3LCo^<f/^/iSnZbHU/7)+L@n
CcfZ?-WJ=h3i$k'0n*cqn7eqTc9'i1t9048qM!JE%l-V?Z8qH_kmuI(AB(Bbj@fo`\01SK\)
1BP;.lkCA7*+s5GBKpj-ihhrBVfr>i1:ER5R%jlu*tq`QE7GK&@G4um\#9kpA8"AaS,em@(a
AMj6m_a2#-d;r;*`cJ/E@fi17b_;)?f`O92N;QJV32X-7ZSXXCk%6>6-:-*XOBTG]A.3G^?MX
tI!L:YkmiWrWFoq%+?:HYo@3eraOpYAmpYqt1oX0NN$0lk6P*]A*5.ma[-2Xdni0?%RZ:fDdD
S4T)nERtGH:\EQ,JfTG\HA+Z-Ub7//tKdelh".%acdfZ#(=W5VBTS.tlaop;af[@3+[-6C:X
"Y>\Sa=sWZ@)Cn\q?R[Xb]AOW*G[eSl9Zfe[n4t)d8`A^<W;YHJIBT\7nl1Co%F;PP<`lMLXN
uToS5i"`ZiD_esl\2M;/d&I$%P5Kj4_7&3#B)%0lF5V3P<R<RtI?,4&(\Zm^A=)<*`RRGQ*_
9\GuJ_kt4,hQ=T*h2GTS<7KZl@eg&Q3=?)77;>BEmGBnqI/BPtVr%l#%os'<I(tBZdAo$ag>
i?3!"?FH'R-%fZ&@8_[YpFVXP:PNhcWOr#1bMKWqc#A'o)1!%Ys/ihj.djlI)WPhe#XY#!-\
nh_(&N$W=kj*N<`7TJV:>Qb+@Qa$[m>[*3LnoA<<f2<'>]AfprfsQ?!t1DjmG]A,[fF2+U,8/4
Y)hlA+fYg]A)V_$4D%8mRLjCZ6(iaORAFNCCo"(LK1pOrR'+?ZUt_"48]A\B`;,:@HUpD7]A^bi
=r\2buJI.rr]AE/ViRdE"!Z6k^CtC>dMo]A%@)s$m%'lE/6jcKIg3T:,_&p2WJO5=B#]Ak,Pq4n
Wd4rr))K13=eaB6eK<anU#2:$1f:"I^$Rt?g;(1.!#PuFMGo_Q\O`;l]Aut@>JQUN,*!mS/-W
,HD9]AX:^`Q%m^(W8o.q@0-.j8$^.F]A/bX)PE/=8nt";#!F6GZnFdL>ku$2m)TY^/D+123D"?
R<8[>(.)kKJs2=aER+_p(VgPG=#"f0q&\ULp<_DriE&%1<>UXVoWc<1N:uBGn>t&iM74,8+!
1<ss8IKZl<&QN8,gZ$[Fm1K#SJ6Y)!8ZJ1fh2.f_Q<F&!&8[W6&1s$UR]AHHNp.^SBO!*^XQV
XtGe:krY_'pi::tkVAuNpn=^G&U^6,0EnL_bI0>$NSQ/#$^/:03:(KuMRNT9'ZVBK[M_+inj
V`9sKB;&gt%ZQ]AYMgZtE/5JAjV%*m.e)'i9OS$kBIM.UJBgT,^'>J)Vl=Y,bX-\`?c!?m["Z
5nc?LaVQkm8i5lQ06r%M5^^@#]AKObU_BkXK.Xm9Rp@4p@!1W[DD1Gjra$#N"oMuI]A.@TWbk;
@Q/8O`GB.8R*+TJ.et!BU$&#g/db6u%.K5-AEfE21^0$mc.=(<A>InnQ<r9Etbs]A&Tp3V>"f
a7DkhHtZuHtr[a]A5Ad\$jr!eZJ`AU)V1H(5t&Gc[Pg"n0q''^_d)`aW)J)e2<.212Ba,[?!!
[G3==lpG-`*@$IVRo7q7gV9P+Cjbes,).qc:q,5cc!4D2ffD"FTfrm^qL:Qpmc(;;Lg0V#Rp
%gan&[uRM;oR+H[*YkGWGPO`=q)LP2X=%-eL;Vq0R/&.\_(Jg1mc3^.[^!s[Dh$V\VYI@\fm
dcRmN^c'YZs)@(NfEMGJn3)M[Ch80#\%,PB;9jA,bB(GU=A,(gOF7CCV?u(u:H,DC(BjE;?Y
EnDZiW8]AZG#WY93/;K_F]AJEr1]A1'CJ]A]AF_kam\5b%`Ri<,9g9?JRECG$?FK0?46\H_.!6!/A
bTEo:ZT*/)IklGE+-@WFn;HT@QD+W99^Y"[\C`I38:u8o'AV13`5QirB+rs=aZ9KV+Vr6PDi
RL$)@AYoaaQ>Yd%m3ZP>(OB6ga5h/Q_'/`8fNDL\7%mQu/WrhlBs-HqEqS*blN%/1@tdsH\'
\#HC%WQse2Hos:\BFu"c;._]A?:u\(>Kgu>n"9;LO``q0lQgHj+f$cLKGuW!:?.+ju<j-k"1Y
LP0\RWF((g1I-eA:#hDgU9?N5_;#Yu91:^F'euo#(i!Om_3irJH6!e8/G/2C29S;6Bo>EM%F
U=P2!*_ogg#q#AcpcC<,TJf]A\"8t?^\=81u1?egph7<_L`3Q=p'UNN.J0g;I^1P,6k+a'N$e
DE5u5^ha0/:ZED>g;D!A7f:^40*rLB3Dg-"Qt9(9)O[VHI;\A.RuemTE?&YRU#8E<'K/98(2
PRhC12%4u<SLIJtc6PJh;/@0F>#4lVm6JrHX<nG#p^e,=3Q@Q9&<GGGVo(^tfA8t_du&RrI9
<?LAg(O<Yb@()4s8k1q.Ye4S<4[@1t[)Y3'B^)i<:&X?Z>RNRM/L.qdTm9qaEn'IJHb\rGS+
u--_!8m!<G0#);9D6!QF>+f>0W`%c7AZ$3q60hLRP<barGuImBr3+DoZN7A=3R[%\#Cu/2?:
Ih9srKj!a7K"G3s-EV,.?\)E^?6s=SoLmn+R9-/Sk3=!p0H$OJg_t<,M+gshBXGGN"WOpMd/
#O"F\q,H5UNfLpfb/_u#juKK8H/RL)>'4QRu1LNSgudgV&"\EoYA[m1ZKZpN3oG+/'RV"h7%
%PVER)%BS#P[qbn&fOe4:Xh</WS3B\+jV<s1X&'&.djUtPD52'GC"=&7qbrHEWDBX8]A[.26T
'?BK8?**U#h[6OK4M:?nI;b[L#`LqdGUoYX+i<RQj):E!n<A=c0cbNm&O<uGX8:^"+ho2k/@
D,FTao4ULo:Hp_:o&/P9WJ!M>D^g`;D\Er0t[6:HeaV;;in9S5DBFNrt!D]A\."Y']A";p]AuC`
Bm8)aAm`\V^FP_#6'mN3nlu?@eV'BbPQQ"g?>fjgSC/T0d0ql"_>IUW2fAU:YJf`+'V;lcr3
,Db=qKuqSrkHU/n[%q-mgU>L`HcO-@EN#[F:BPek0#eNQo?_*KT2"Y`o>R(SDUOsk_I;nU8\
"P?Ogu^O'2>nU!io$?\P5!M]A<nVkN]AAUQJssRCW)[ss04B2Pg1N4etJESnn2pBk:o/c4$UD3
hTFIG^YpMZ@*>'cjcD1m.DT%bE!IIlUt@^egujhs!dZXEFgm$qRMuYMW+LH62<H4hf[Oct4V
hb-7tJ0k*?a1g/nt1DpfSr!`LpA"H&mVE8Q0@6Fcg*j,Yota#%(8hG*pK*6-R%BZC>]A33F*M
Hd0]A1BDUWLi)Mu^H:f+BFS.nk$EV+>A@c(YIOk;i^&iE%Wc_j-slq!;1/5_tNX@-]A;hUo0$n
(--;Ll/Y@!W]AP@s1*Uo!2C(h.39=_\7YdISg1mi1i.c1isThSlk)U]AZJk3J^9$//Dd7';30q
YMGkTfP(/>/nWZFJ%ose`_3*JU3FIMV/;(-RV*Nh>]A@o;l4!@u%_k[\m>W?p\Ngku3j]Ap*Xl
_k4kOg4qoj\%!6IL=8.16p,JcQ)P?'?ER[^'HZ13+WBeT*Gm9)/noL'jB:Ril1e"5>YHW1O.
u)E$i.;`+0LR$[OQB[P.Q0r"FfbN["a!SXXMtnbf=qid;#ZG`te_t_nBSo?5^+MBP*'`_%`"
j54SS[i_+14]A:S7:=tgC99<.h'Cj%D.[pL9j(qasp%&0`eKX)[3Z#Z`I0t^m&NhU/OA&p/kd
%<iG=>*4O;#nZWUtpKZEdS<cYXSVEs))tn-W(WrGG=mE%M]ArqUZU>55>(R,MT:JX30p=A;7P
?dRZD$O7G3YI%s+snkFEgkg2LK;.#'_3lV#EXb]A)[1nnEeH;fJHB\*C3XnKI(n98f7O)>&W[
_TbiAZVj@D,bC=7>8MK>UM,qnq!I'm"IgGsdMNqoq76(9"PpuC/4dCJ,A7cPoMd_7CM[3,4r
%fb/DlD4FdSt#kVXerKgeNPhY_Lg[0`*nKHGE!XWjh!=VWBi;G`"-XaDUbf7TiWI3Tt&bG.c
-eH,Q0AN"C:TH4]A."A\*]ABtIn4l9&=G$CZM=q%CL?Q%L'F!&p]Aa%7g"n:raM(EK6gVoo2gTM
g[9qB2cN=<T#[D4&1I<f]AT=)(eRV^-%bqU/4?V]ArVWW(qtPUR?&.6:Qs$"<lh_V9o*gO4nE4
]A7Wc@!g5RdM-mr0,35N+:T0N[u'+N9nCP[QCt-i+ePbSkCHl&`^7J4`7Bj#@OD'll"'f?N5<
i%\sl@&!cPLfP67<3E`^n+!R2!n`R9R$gZrqTcFZFf4Y:%j7l^g^:\Y4kL/V5MkV"A5gSq3S
?/obad@g4m^4N-aS7B4=:L0\Zm.:59V;5?gX9t*L]AA7'C^i^2!9b\o#VUoi'p-)LgF1'1/p(
XnV,$rfddAMDsDb#[m+ntm^+-c8M2&nlg[%9k(edd)lVNd<3EF2-"GXPp=gbj!A<DPT!;e0b
Q6]A`m;[DA;#4Jt<F^oB7DC+.eeF1a.:o"2.'UH6a+;_?c'fcb"#)478JTimmk(_aI^rZLe(q
mHd,PA49KfO[3,f<Wis>SLTi-&iSLjB%5#5_Df+T%`59a[G7]Ao3NPXVVtWo)\)k?EEC'qYX]A
(eEn'nQ<t37eYcVYF7tuL;SD&'kO2mpIM>Lk,JBa4XV38F5gc3X[]A?mQu9C:2HtGe`@!+k@.
jE0phT=X-?f"Y=q18pC=!>]AU<E%I#4qNp7BImPCSbK[0J<^3+I<$<G38g4BDrEbk'mt)P:_i
uQqV>>#0o^R:lq@GgBTQ(f3ek&0Y"..n3G1bA7H<Lgts2O=KF%Y`tDa-B,&gc19[<)#s@,Wm
2auqYUc)f@=]AEJHOStk5Kn66^qUg\.%6ZR1W=dk]AVnJlCgX\;K#(82$iY/A1ua.A[b/lq?+2
P/?SLE`=WLM7F6b&dHq0D-H/Th#GI*3NW,WX;#,nZ&6r3M)6da%*YlmCU5W8mXVl*I:Md,j/
b,-P/3p04qOc!Fu$l?M>@^dSo35u_MmMjq%"aEkHWrB*D25kj&D\E9LE/s./FY6GH!9N_F%O
Gln8FReLUU$W#C!>$i.qo(JOSZ&b`QQB1F,$?ua$u$W?ZlXfq0Yj%086raeBCTg.QI>TL0@]A
+M*SHiEfJWYO)`;l2`r-9$$<c-DDtSpV9^lkl:sc_0H>JF=Wd%1'191UoH`P/P"Lp2`k;l6R
e]Au*W=I2i(agHPJflsPkFu\EM5@P]A''L!:fgL?*]A2P>7Tqmtj[\M\XKb/HBphR<KOl6GLYa4
4jq(f"J+NkZF7JHMf)SNY)$@,on-i'qr\"@g)_%B5q=LO=h,g\=Z'-77LOeGM;@:!D@drkbO
*p1G_I/1uA6Bu/-HI`A__\Ej,.o8]A`86eHK,_!]A.9-s)7%;7E(3#M5&\)g.%]AI/,3*q!=,<4
S"=QcP=O/*6U$dg;/Dq:6(9jjidrIGFBAX6=tjq%H!.AE%_HFBaut^DS$Gq=r9WbVm@YgrE!
r:rP5;7j@@o&Lf36TQ!N&4sOTlrKST^,a/;1D9/`]A3.*<T!WkgoYMkQ+,NQ&$r.G1ld0'EXJ
M7=45ROg]A[p7D0gkB;akgR<8Xh._2%XZN-&eIEI+(8#Z8X'jE>'n;EMX#nI0r.\QUj.+tjX^
Eu)]A`,a+S9eY#pK2J@MRAbkN=lG#'.bMedsQZI\dcXmjKLQ4h1;$0=Qg+M2)R*DP[t#BVhX]A
5T-</.5s3RZ#?F6"im=#E=>lB&+`_GA/BJL*^2E+4=lQjn?-scHf`o.S,`Qr@AJuM,[ZU.r;
,#o\dBGi_kKDL\$2:!)#jHpm'6BqFMdo%c<_h-]ACL-h%E(]AZAXK6/9*`,RX&R7img#\[;%E/
^Q)[d2m=j'GFKVQJ=i_M.RXq%47NFOnlI>]ArD[k?=kEq;*Ekt.oW%.G^_tg@Ga;4aDKL'I'O
9`7l40W51HM0P=0>[G1Xk&-A>JC"M?JZH%N*ip4@8HUoK!s>,!(dTXlcgDlfN$iLoAEj"9@J
SOD;4/u==P$'Qu:<.r%`7n+K['F"#c*,lRk$.*\YHb,[IXH%fSnTVoJ-I8).0W@nNM<FqgeN
8"<4'Aa;n3>^V`2%o-j=q*]A\IgkA7j<;uQ-%Bc)u63%'h!C7-%@L7qcQn(BD?-5-V8%O4?dQ
A>C<W)\K4gUh_cFOFJ,oUtCf+e]A`l>A7Zh"*W(kEXO_X<%]AaXO*^N@L[h:f[CIjf8`rE5<m,
n`65Ff5g<k*kpWL2U8>S>?s;qfNDDpu0=_,XiMrVH'`J0F[#D'gFQqt&N__*<XLF*Ic,&.lE
%)qR[H74J?3UWMoC1$;#I+Oh01.\b)DWHL0i>KKc8^S!+5UcOX,;;H2UTK1ZAKbm7,"U2\"m
q:npdu/T's(_7+IR?Y4b8G,n(F:(!UQf370Rb!M<Pn7V)2=]AE<?;2"WPfs#Vuhb;_.Tf.(?,
Y^hhpBIe$KIGgMWG+*mn\,GuE2:eBkGZ6/lV1-4o$!hZ>Yn*4hVQ&)uack74DJ>s12fLP)f(
gWiMU)Z_0oTb<&qQ`F1bV6))E!5EK9j:>CD37Fc>S8'r8%@TMob@;\]Ag^U0]A\?u@H!sc<.;U
*#-FC%QsVs+8qrJ*MdC+M(u\FPCNdWtY-d_sTn1G-![LbHqn;t+WbT;&pj"]A>E@5)^j189gl
Z$XC&1Ufa%.Ib<kH`?QUHbe=pr$C#--u=opF&8]A`"PipJ5gr7ZGZ3)Io2rc%Vhi<l73QdKQC
]AJAkMdI5"9->%NX2.#3n4%^$tQ1hCR:8Z%J@;TOZG?#FE5tQH<EhLk4@[`ZJuhbT*-HI1$>Y
d[gCL&4e'1du@%Ph?iqfKlGT:OTaF8?_r"f.jp!o4Y'=P&j*dagN^W!,NU#*jV4Qr`;1haDY
LhbS(-b+p'p'H%3uDO+&K3IFD7AN^Xufe5i<_jlf$;#8'UtcluoNY`NF3F_CIRt_R7(;S1d(
e$'/tq`pa*gI\t)H<cZ!)_LY*upAalDMU7#6L,DupF6mMqVe:aI#?LT,LHDF1"3NtTfK4;j=
4]A\sL#),17qC=qh;QCi]A%W*FH<'TLJbD<1p(4_-*9h<MGpMU5K\Z#1[j=Br\I?q7V7`mq.@s
cf(sFhI?Qf'/[JsR!IX!6X%YaN!lB)7c@d*rR=2:D7<^B2-$QXnr1UoS@SG#auCB"<d".u15
A5OkOoRC3b5XcAcXI\+Dls>,$^$!#W*uql;U9`enUQ!^\MBD%&\,$,Ne&i,u?^K+7hXOYL5c
h)up-YI)[2TZ5BgcH8k\_i%0npi90;\7dRKIrhKd]ANH?N9VAF:[2NJ/WNuAT?(0kK=r."+G7
iqWZ,%orjt-oZmldIn=Lrf>3_%B21h:>T^%qRUGf='.S9Okb%V+*=uF!,5);:q&R*N;WhDC8
&jL%2@bFIeeK!"+8Y"5b^gETkR[]AB+80R=V%!S/K`r:P6\GRgLB#2_n:j&,PC?1]A34\Y=[_H
/_j[HJ76[(^tE1H]A0Skch>..K[s]Asp#q,WJ!:c73:!k.A:]A%oQpa+p)T+G9d@^8P=)!#)g#$
r_uL7Dcq&HjQ0\,NV>Y#nTW)Gn9?6qS1o>phtVr_%BlUK+1eGU@:t,YN/k?q,I`+l<T]ANL(;
cX3m*!i?Upj?!4nhht#A:dNK<ujinsaDU2ECuR!N_(_$=#6E^@14o97,hd<8%1e8Zi(iLc6q
7r+b"XI83@;rV4`d8oi:aIp]Aa)lmi@C;6e&C&u7@]A,AgH=rJKoJA!'U[O:Z.$>oR0:e?N9]A`
.\+qJeC1[fXj=!Y\&o\pq*3.qufEeYS\aU8aCYNs85Ds#kplT5KTs$>jIY:Ci#h%S%uBHosO
Nk[!;9E^iR$1g2h/r*g2O6HZ#*ooR&MnA,^P]AI_n%bojj#V@TGcG]A,U-*j;G0q%Jg=uOTkh+
;RopRkXM&6W%FM\2M?.%pGA4!H2@pJ6qCXYapChk[XD(*RI;'Eo:PH/rJ3:]AR:0]A,XXOf1OH
,gjg?!$:0+l[Bp2qH<3N69VK>fpoM]Af7n)GG\2j&^@\-YN%#\30L5cGVFLYUO_s2rE'QqH`S
i3rLg+B>/o\'b74)1JQK-_13i+HBcW+d5sfo1"U6kM#Pu[(PLjls3n)'NOrra[F$<o@f@!rM
-`hJ9JtAW_n:<&3H;<[l".Y\j.p(Q)!uda0WBb2NZWn*a3#/)AL5j=l,4Ztn#Up1_"WRo?L=
RY[S`K(&DqtFim+3\:kWZ=oc3^Bk3.8)Y+Vatrlq_kGS=>a7;"Br(l-$MArmM_&n;-1=RTkU
;]A,_W),6I:(UN0*o.bS^dERkX,8bdJHFJ)F;>P\+nC7:ISZ*M?[.YfJi2&GdQcMuU\*j0@!M
,CZ`Vq"A[EhI)k!af/IIeWXf]A=EH_<0+M307-kII2eAN65@0-^G;+L#G^/iK_3-VuNm_Pb&a
@CEtfKE2j2YI%A/`WU@!O>5KRB=i$[jh8TfEKgkW#Wb@YjnF>[VRo!@:S%/YgjX=fE%_gZfE
3GXq%[s+^1VI8X:slZ8*Z\*f4.r=hV$RlRVfNpr^b9F*3BH^Q-Z45V&prL7Y@(U5l.CEFr`;
B<4YoO-TU#Hui5$'$;Vh.me!F.Of=I.YXK"cq1JiP]AK1N]A/oVOs_B\U3uM8m[$GZ+N\o]An)l
PbnSCantpm]AaW\,=)PtrpPR]AQ';U#QK@VNGnG(MTc(`d5YO"2R2L=4A3&Y.)N*h$\!3ocmkJ
-`0YRYE3Wj0kE)s*O.`VLk+28m\S)W-[(:u,J@MV^gY.PG:65g8NVIc>4+R;<t`WrHe5e?4h
`Jg<[%DrPFn8rm(O^ROs@O>#X]AI&+NujWs:-'_]A_RcN<Z'fJ-.oDY@Imh=RJa6Th(7%$:/>/
njRq/6Ou4e2?l_9eVmX&"kdmBorfdBI/X?q-)Hpq<@:\:Bo5J_muPiq?E*h2-NAKd)T#slNi
MOc!FF:k[bOu3OXXfn?kTN,/W'8E1+ZuH2$?.46ln[JTfYe0+0t`E4&W4eME1h#:ot+/`^Rb
=\%5@YKdE^+j#&Dh)mqcc7k4.]At>1W4@o4[?.]As=>8O:Eje%ofWGA>uXS2;`o5mOlL)-fIqr
WUIi%fQfbIp6E7FTYOpfFU1"hOH':JG5%ft@D#P\50/;A\+2fDfDQ^PX*R&O)F^<1UA'j+_<
?o3<54KCV,h^6!/k)Hc2`9$BM[I*UP)i"*<CA$S2oFCD)59)P4%RlCWG*+jg2LGicQU1iRib
O<RH3VS%"8CN3'I&+9@[*l-(I0EBa:30Y-16^7OW,]AEBUMQ>\'_dak;I_k).prhLIHXV!KGi
6V2nla(!b'/O0Alq<L2)]A+2i>H."H$qZ/=i:Imtcn(NG4N/%8/#DU4aX$$REr7&0#lmiE0mG
SB8u,0iXR*k.RA^c&fobma`1KAns>P8ZuT>c<$r'Qu@<LJ@AT#&(eOKA@-ZB]AKR5!dFMUqS)
qLrL<9"Q?d\Z!hF%X)flS01cFTWVLTC54%S28RTE<S;5^r/jYc0."n]A%BmX^nEN^9e-PSBKk
EFC.U+bqRAn6CJe;?$I)V,LnWrR#&?7HP)t7;Y7afH'k]Adb8JH5-0Ga#m=<&C?D"!R:ni*c:
<m.p3([C,\h&i\GsL,RR+Q$rf]ABTMcRFZN[>5g>Z!K4Th?(u6CHp.U'DjF:9L;isLg-1YpSY
C%^N4DV*Rqmre#[h8^h>h2LC=cJ"ub0&r[11UB96R_RV#eX[>"PFC>661E&@?9r=[(0jIL?f
Yq%`laRX7$F13b"cjfJth</,T9aHmZ7a7EH?qA=-44bC3XHrcsTa?EBJ_noniuKa2oKs6RFC
!YYa>P^*S_o2SC0/f]AW00^r*Oq\c-!?<%e:g3#eu+W(k+l=t;aFh-GlK7LAi1rg:.h-b&?t"
4V6Ro[(_X-("Ji8M2Sj978->uhbo2ThS0J.2!I$0r*HC'omP*8oAJ@#B:3jE8%,Z#bFoUQ,C
X&^HGq?I9,VpZjWJjFClu62;LC*qt,S#k[ll&B0On1!%]A:AQ^Kso6>KrikKRM[UJ=)KJa10!
nk93XLDEVSlGKa:NC!EtL1i0-j7MN7QZ6N4h'c&8T"#a,O,*t6WV]ASO.K.?j/Lc7s:.qu[Gi
#2e6m)ObqT[;-tsd>OPnX.49'i'*Y1g!H@)TJn>dj)8E>4I;`Q+6%5ZoSk=![u@Wc0m^7,*l
Xp:WWqDrNapW"iJ3pRpDa9QOY4df]Am)OW0kMs0/4>ch-(F6c,`2^WNTHdj7n08I/_Y)Q>jUh
]AI<mO\cb6HFg^^gMnkF0WL*n``ZKB$l3fT@@:+Li.XHr1@(s]ATVT5DemoOsKu@'X[nMl1!U\
_A\iG<3(k8X3%05A*TZ``RQIDD-dAKi^A5,d'&j((rrLZi"'8j_#6K)B69kMOoKqrA_bN<dj
SRE2J+[!Ra*848c36/R7.iYRlmMgq2[^bpGr=5##n4Qf\+A&g]Aa<YIN@(hoo70h_6;d2T_d?
,XF7(#,A-p%;(g0$cLe'-7Ia%<ZP#?$/9/70G:]A9ieUFOV3(?g3EMiY&EapJDq7*!fNaM>3Y
^G<g8#.YX$"\aO\j@X+-!iDLMT)P'#BIsqm6X_Dfc<E7=lc9n4C<4"%PRKDuNEj^NcOLnVaD
Q3JJ[qJVgjeg^fCo-EicE8N)/h\31%ZoOfeAn(]AURamQFd,2\"hGD6DX'"i"+G&Q`8Ea8#2b
9QXS\4W,0?)^A((EaC-6.?E%q%M3f+a8eg9WP@-RL1s;4?>jPGnT"M1<$'8R:c5<4jG]AF-\P
0Q^]AV2polcklR]AIB0o%#`h6-FKS9<KjEZJAq7r<juS%UqOSR<`Ef*"+NrCqg%q?\;!8>CgIB
AD!WF">l/:h9*2Z'Fd7]AB2gA$.fHf=W'EBV5>_Ab%kmcEZV_J`"4P8I7iiS10-dWnQIGq3Zn
?/uGn&'U(ffKam9)PE5$(h$R`qh"^1QZ6%_I/m2,8FllH"I!o;6R""BnrkIaE[%R6jKcW<&7
684(-e$GLL;K&qk%n(da#+<j7ff$:<>.5Y="r:#6*'B3\R9aj[).<O,k*O)N0QVelAMSMeJT
TpLohs^95%VG>OhmhR>L:kXrNZo;4+'e"Y/(L%2.]AlY\'K9B6Ta@-M:6^gaI^h6g1ZE[+H3i
(AS@uR_@K[8**(Lr`;7(?Ma/+.&E+ETZm;RhRPnc5u#(JbXSo;Tkna_f<)PakD1*sm$IJ%Tq
^on8[7rahH!b2n6G=2<%)p)#;m8gPIC6Bp]A&m!g&FMmAT$j^NR`EpcVM?JM+JZB%tX.1/q[#
(ra3BrVtIn`mA17*.,Wn2%DR9h_V4*lT6SpRMta,fHBmoA\b<i<lB]Ag%!NEDA$_'m2+gcao>
)pF76Y^,PmQ;:]AKMNA@_8hQMIBn-ln#6Z[j$s.aWeIlDe!4`A!r`ZHSq\gK^CC6aGl]Aq)V%d
e42;V.XBT?9*4/p"QLUX,=W+L0_ufSj)?2Oi9+o?-QDTd4XXgAH%q.X0Q:q*nGb2J+_j!=Qe
^Cgi;^&!Scc2dQLR]A[:?-$?Qn/bS%i$H(PFu3\N]An4@1Cgc\_fZaXu]Al@>Bf_hY3XJ:pQZN-
j)WJ,h(*ZE6:)7@*d._YdVeBtUZUDH;c`iZW&)"nBd@V!8mN+Hq%RO!dSKms^H[?OpZYs?ka
EDO5@r!VBC6VcnU/,A2[:POk$m\%idV2tlpM!*Ki(3,%3]A9'1$Go;0JI8M>/M"h346d8;A?L
RNomTo^g7LMm=NF2)4r)J)KmUU"Qm:IG$ns6"]A:kM)DZ%5+[_4*f!$:Bo/E2&Pkq+iA]Ag=2O
9-8BVUPoAq]A1HCIHr4J2)lOQ%3e9i5;ZRHX]A.WOihM6e)FDN,W>h%#iQ89sGG0i$F1@:rij0
IZpd&%j]A1rpbY.O?3go_<Fc)s0COMCCKh-T:fU)>Y"aJ^88%-\ASAq[(s*1iu=P.Qma,Y+=Y
UP@.7&5Yk"T)94a23+9>+<#WJZl(Z7#^m+Q53djcHq6W6[^hAU@q]A8kci:I5-;/P@.^1eTYJ
8L,cLfc<AT?&*l!*UZKZRN%af8\?;r+P;a+oX1&,Xo4q"Sg7KY1U8O-&?Y2QM:5q%iPS5Ng(
BLWRR'F+8"NHoTpn./.03Z\ZbccR[nUHoD#ELPLYGVt!o>9K_0\4p`Y30_k"S:Fi"?h[Vhc^
[^:ApAVBRAWI>qn]AsE,PWQO*<q=_TZcfg0T2hM*\=HuU[cNu'mBZ;+h&h2?rCr?F>!0tmfAH
6#OZ%Z641!ocSc%&^2.DVt9'9j[9m&CcIqrBA^J8+.$ZhnV&=+uMq4Vj<BT1bI)=@DS]A</MC
rs27"?$PC'U:T0M+!2\RJ9!NJCl`pg:/V+d>uaZFIXXF`ZBH'T=H8X8*)7QGQb69$OuQqF(9
RE(.qr)/BR#P`'^X6=)hT9P`h[`sQ=4pDL9^&6_fO>&+HLDg*h`nB;o7/0B^ah;6SEgD4@_O
Ao'!482,bX:`fem2I8f1dIAX1h%F7n4Jirn\1<^,(Cg=QOIJhT@rFMls_fO>&@#oc#d8ktN.
5,%&9n%Cor:8=an/V*LfV?uF;kZq5P-:cAIX9iKZ=l'W7m/mo]AJ8^!dG^)4KJP[%0q*&NLGq
[9cKOc;BYkW-hAAsHUVe%G$"n@)@l3/'%W@;\kNMETBR#OIDi>0EN-]ASfG[iShN"0cb-CiKB
NR<D83kR29E(5UA7MF)2nA]A.Y)'.QNCi/\=fD-dZ)r^hUor@Ho=Ka;tOaPCdc[!^J:7;@?5j
7ItkH`A^Ta:]A~
]]></IM>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false" appearRefresh="false" allowFullScreen="false" allowDoubleClickOrZoom="true" functionalWhenUnactivated="false"/>
<MobileFormCollapsedStyle class="com.fr.form.ui.mobile.MobileFormCollapsedStyle">
<collapseButton showButton="true" color="-6710887" foldedHint="" unfoldedHint="" defaultState="0"/>
<collapsedWork value="false"/>
<lineAttr number="1"/>
</MobileFormCollapsedStyle>
</InnerWidget>
<BoundsAttr x="0" y="0" width="960" height="540"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
<body class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="report1"/>
<WidgetID widgetID="cd14ea59-07c4-4a13-a410-e2a2283c543f"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
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
<![CDATA[1296000,1296000,1296000,1440000,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2016000,4032000,2705100,2743200,2743200,2743200,2304000,2514600,2743200,3024000,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" cs="10" s="0">
<O t="DSColumn">
<Attributes dsName="门店商品销售" columnName="SHOP"/>
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
<Expand dir="1" order="2">
<SortFormula>
<![CDATA[=J3]]></SortFormula>
</Expand>
</C>
<C c="0" r="1" s="1">
<O>
<![CDATA[序号]]></O>
<PrivilegeControl/>
<Expand leftParentDefault="false"/>
</C>
<C c="1" r="1" s="2">
<O>
<![CDATA[品名]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="1" s="3">
<O>
<![CDATA[商品_门店_单数]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="1" s="3">
<O>
<![CDATA[门店_总_单数]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="1" s="3">
<O>
<![CDATA[商品_总_单数]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="1" s="3">
<O>
<![CDATA[全体_总单数]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="1" s="3">
<O>
<![CDATA[万购率]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="1" s="3">
<O>
<![CDATA[参考万购率]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="1" s="3">
<O>
<![CDATA[差异]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="1" s="3">
<O>
<![CDATA[得分因子❓]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="JavaScript脚本1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[FR.Msg.alert("","根据购买率和参照值算得")]]></Content>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<Expand/>
</C>
<C c="0" r="2" s="4">
<O t="I">
<![CDATA[1]]></O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[row() % 2 = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BackgroundHighlightAction">
<Scope val="1"/>
<Background name="ColorBackground" color="-589834"/>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[&B3 <= 5]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ForegroundHighlightAction">
<Scope val="1"/>
<Foreground color="-8388608"/>
</HighlightAction>
</Highlight>
</HighlightList>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=&B3]]></Content>
</Present>
<Expand leftParentDefault="false" left="B3"/>
</C>
<C c="1" r="2" s="5">
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
<C c="2" r="2" s="5">
<O t="DSColumn">
<Attributes dsName="门店商品销售" columnName="CNT"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper">
<Attr divideMode="2"/>
</RG>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="3" r="2" s="5">
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
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="4" r="2" s="5">
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
<SimpleDSColumn dsName="门店商品销售" columnName="PLUNO"/>
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
<C c="5" r="2" s="5">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=LET(A, 单数分门店和品号.select(SHOP, PLUNO = B3), sum(门店总单数.select(CNT, INARRAY(SHOP, A) > 0)))]]></Attributes>
</O>
<PrivilegeControl/>
<Expand leftParentDefault="false" left="B3"/>
</C>
<C c="6" r="2" s="6">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=C3 / D3]]></Attributes>
</O>
<PrivilegeControl/>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=$$$*10000]]></Content>
</Present>
<Expand/>
</C>
<C c="7" r="2" s="6">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=E3 / F3]]></Attributes>
</O>
<PrivilegeControl/>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=$$$*10000]]></Content>
</Present>
<Expand/>
</C>
<C c="8" r="2" s="6">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=G3 - H3]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="2" s="7">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=1-I3]]></Attributes>
</O>
<PrivilegeControl/>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=$$$*100]]></Content>
</Present>
<Expand/>
</C>
<C c="0" r="3" s="8">
<O>
<![CDATA[统计]]></O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Expand leftParentDefault="false"/>
</C>
<C c="1" r="3" s="9">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="3" cs="4" s="9">
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
<C c="6" r="3" s="9">
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="3" s="9">
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="3" s="9">
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
<C c="9" r="3" s="10">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=(1 - sum(I3)) * 100]]></Attributes>
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
<FRFont name="微软雅黑" style="1" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72" foreground="-1"/>
<Background name="ColorBackground" color="-13395610"/>
<Border>
<Bottom style="1" color="-1"/>
<Right style="1" color="-1"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72" foreground="-1"/>
<Background name="ColorBackground" color="-13395610"/>
<Border>
<Bottom style="1" color="-1"/>
<Left style="1" color="-1"/>
<Right style="1" color="-1"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="SimSun" style="0" size="72" foreground="-1"/>
<Background name="ColorBackground" color="-13395610"/>
<Border>
<Bottom style="1" color="-1"/>
<Left style="1" color="-1"/>
<Right style="1" color="-1"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Top style="1" color="-1"/>
<Bottom style="1" color="-1"/>
<Right style="1" color="-1"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Top style="1" color="-1"/>
<Bottom style="1" color="-1"/>
<Left style="1" color="-1"/>
<Right style="1" color="-1"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#0]]></Format>
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Top style="1" color="-1"/>
<Bottom style="1" color="-1"/>
<Left style="1" color="-1"/>
<Right style="1" color="-1"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#0.00]]></Format>
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Top style="1" color="-1"/>
<Bottom style="1" color="-1"/>
<Left style="1" color="-1"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="ColorBackground" color="-13312"/>
<Border>
<Top style="1" color="-1"/>
<Right style="1" color="-1"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="ColorBackground" color="-13312"/>
<Border>
<Top style="1" color="-1"/>
<Left style="1" color="-1"/>
<Right style="1" color="-1"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#0.00]]></Format>
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-13312"/>
<Border>
<Top style="1" color="-1"/>
<Left style="1" color="-1"/>
</Border>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<IM>
<![CDATA[m@8B"PM+OVkDh>RNg+_lPto='<dKsm>[*G4+=[Fb'bMl,!n'Z0)&3?AU7rhh=(tPW;F5%/,"
AD>!$TiW$kOP7"9L$JI0$6jkJ$E`f)!s'h`n<j+0:`?jk4:=Zci/-qs9DlgA-EEf@jS]Ap=X(
.N[KmYrTpj"q4E*/\]A7bj'mGC2n&BkNfst5*@u&CLjflc`4c48KcEOJ4IIU%oL25Z`mX"HhD
`9;?;r)N>A>UAn-gk+90=obfIXZ&>55+%kUF1H@YuK1F>E6GqYH>E:D0G8;4K7+GF6n(gOaq
CigCW3nHL'+lZJetQW?9Dc>eq+7N-Tc6HoV#/<mglAi=hm7Sg3uQ3Sl9rf%^L*\U&5eNCQA:
Yn$o!ed7A6ZpZt3gU3CDE:JYb;ogPY;^K\AJ#?2&]AVp)9ls)C<d0(ofiMto"B6k<Zlfea:B.
I,\0*&fQaTlJ0*dq@oVN)42p21#$&+fgu\Dp,)\)R.g)YQKbW+N"'mqX//cE3PB-;b7P7-je
WnV(1QOhj<$Hh5bU'd)k`)g*Gm&;f_ibUA/hDDK1ATAmcYBn?Kg\>TSfXcW&+5%C$l#UDPb(
erp]A3G>tn12T>J?@sZMKgML#6-Xi8W)pj&Io=^Ul`.bL&e]A)?LEc;->HJOg&/-#D[I;AiFCX
Doa\/i%;oT8&:I$&MAGWfg:fp_f)`)lS)5"#Q3uS.(Sb^<K+;Ko3$++>YEB)4aG8"TAq@PBq
_'X7ok4/"Uip>dW/dM@uA#'u<hXsS0?:!?BbS45U%JZ.T`!ur]AjGq(<=rBL1Z`GF-`FOecAA
%%A=tV,TKUu7gONp1Kb?<1a;7^V!b"]A.LmO>N?_q`^gi"0/-HR`suIPE&EZ=\/"IftL<E33<
0*oM(I-B>?M6s1nn,[othHV4dJ!\XrD4;S"1R"XZ[6XB7!A[gV.lqNSO2KB`LefpQk*bU8IM
CI]AD2@LGT8FU+K;+W_E"\:m'T#-&C@m%X7;j>p#^EaRa0c)]A)A'Y@:h'hs(BLI[YVt'>*8$5
m:Ta9Y37PqFZL>lbl0KHoPgW/7U,_(WlddT[V&t17cd=`-'kR0SYC[[`Wbi=s2\MtFU7C."Z
BkA\7cbVN)`^'pLGab"_h91>0iMgIY;+-?62_g\J84d$$4OLU/-o99-Lbg>1h-2Y^p:7:lo&
`LAPlu><1t>fLU)@mJQIOC[*WLTS$:$h<g_r4<#T`G4dmG87:GD^P;[N"IaJ#U17(!H2UY_G
dI"cDU/Pr1+0CF7*6F[RjHo^"S[_I3>;h>JjYd)M"$6.j1M),dpk609)BmF:<+N6p-ES`a`n
OSN>EU-)nalPpLJ-P2XB94Nh%h#Y0ieqabMJE\DD5M9.Mm%6BD<&&KqS(<Hhm9Q`h-p%iK^"
$]A)ca?sVUCug-O,UAKAjdYPtDk_8/-6X^sLgF.#7YVLB6gLb[A2hFAYd"gH6cD/9IFSiAUBh
8a4aHigUtb#]A?\jbCJ+U_=/TWm86(Tp#0Ho<<;,1Q*F6`K]A[kV6g*>tJmt!mP5?J[rSl"!#u
$_=:bkc>]ALNTKG_NWHqhIIq>N>+60_gd77_h_,`KjMa<s,0/T4:-Hg=a\VK^`QGk(EQ/cB*X
20giWJZ>'m*1E[")K@mg:;[YBLFKgD$$QoTO0\"^j/9ScR'`hZd,f@%p5a9B&_LXlajd*Dq:
Lie_fhC^O"Ks&4'P*Cu[\#I#<sI)>_K?"YOY+9DRs*H9cQ@>Tcr"XtmUNVdl2;XX`<kZ1JTe
AqL2Mcs/kkd1!5\epjF6@sXR&%Lb^%5Yi%?)$?b/U%1Q%,($4G:Q'4?;iqfYkuM<7OIZ=T0b
`??2G:nbV*A<amR'>)_]Aqaf+RjqrZ\m=]Ardj:pGC%G>/5!kUrKs28d)97D*W"P(K9IHi(?r?
8"R<NH._ajn>sK^&HCj>;qp/a]Agrgr2dbARc0K?6j`W3td>ZN6;X]ATo[-fXMDQG4[n#N1JU'
ZaTJ42Ol:7TN,IMQM1VG3&MEp?b.aKTTJqS&DR,Vr$GMsQMFUagqOK]A`A>p*"*=a\+gc2rJ3
S>^@&3_EsBqY=<Oh><P<UoWR5b#k=7/o&sMTjjX=uMn'[C&`j43O<a?:OhWrl7S?.jYbkhe+
&'J2@iGZ+!mc7=<kb;%o"2ioffi>?6:._12s_8f]AR#aan^k^&IC'0)&Nm]AaCHS,16/P(0'U&
iTLDN`!9GO8"sH_6Lc$qTY,)R`fP<Q>0o5]AeaX1)ht46CE_./dN8NY9QpO$.o7@"RpZdh+4*
A!X0<106UQ$lc`NDXVFhSYMY!O.ejJ%;d_;pA8#=n)2^&phoBc\6jlDSs(SF:[Mr^g(d$lcO
0fH1ce/p;sSe7^%(_Hj@W)d,D3@HKu+^'2Y*9T]A2NHTmBIG4Er\Q&8&]ADS'OYG"RUUcpi1!-
ne3H_kVbC'&ltHLr7@sir1XI!Gdd=\^+BGM4XGHM#2eoXs&%ma?+Q]A"o^0UXp7_54qW't1o"
[d\gCA:U.9]Ak..US[gMDfk\Trq4<4@m;X!]At?,'qVR9[cj,C>b!:jaqJX4YUT"6P9AFHpClG
!K5QF)&D,QBUXU:nD@YRJ#$k-VZK7l("u2:NeAY@Pg169f18SP=`DA_'(3@W4M@o"lnP'Ibs
nN$)M:[W;t[PKTVY3=^&.!leBLPiN7V&%D!p'B/"L`/L2pi\V\UY-4_&t*SPlVleD<kS3FjA
d5>K(1W<a[nMe)W\`J>i)ggZn8fTF1B`,Y/aCC.W<[Z?^]AOh4,8JBm^q)CP!ElJ=q?.#]A&*L
3E>tAEV+SKcLdu\6Z-I!\p5`fWnG=H:9eIaR)N7gL#DWQ?.I>'.ap_Pk,.Y0sDq.b0elKaPp
n#HWqKu6o=m*H?UU'N88XRO1kC,@23Lraa.cKBdqh0ka=r]A<s'gJc+A\_iL.HrqP5+MG/81U
Lp-4a$H+-">WtD.Td2j&-&ZoeQ?<DRR9$h`eN)n1(@g2(]A3^\$ekQi.Ij=dFb_)M=FipN!$!
?abp'[Ns,>:'pI,0!JD8>>qSW<\3Y:MQ4:c\R4[G]Ap?q.a8ts/[e.R$s[1f5:@]AN4OfqhT!F
g$,cd&12buk/P\-f6*(dAP+/TGF$R<EJCV#D@oon3MLu(!b[$tG-W;2#nK?]A1k$e#qblU/UM
oCmn07Vlm'WeSdoCkqRpore>_%eYGq0*LT&PVBf42Lh*K.%RP?SpfOFWF*M3TR3%lWA#2)AU
Yr.m-Xf6VCPsJEo'g+.B#-B2f:0TC;Z_l?YB;Jm!jhg*`89%'s;''+-^=X,9YEU,5^n'@o2!
Ouc9#gP1'K^j?2s<&eX$0e8%05RH'7c>9!Kd2Ejkn_r0gkf*+f,J^Z<rhLesCckI7R-DEP;[
=>!R&E4%=GQj_fSc2?&D4/imN2X&ZSuaQ!@!8<.7!akf+Te=X("C]AO!00K2,?W>H"q%FEc,"
XL_W6Yj/[`IHZQ+X-d!b/0^8r;RQ$m7GV2hA'e4Z6CNr3$^L3e`lAbH'f/I*lLMN_FJ5ZomX
,A:[-D^hBP$.IdnC#BOa5TVKA4!VR^bWkXRs\nX_$O^;*HOg0Xofi8SEkOK0[kepdPOlrnu;
B>([8!`=KBd%Meu$]A4[t<%%<"3dk>S^^i(b-A>qEG?TTG:'%^g,u[0;;::hKs<f=[G_6!';Y
'J'*ao&PHKZ8<I[ptd=Kmp$%NV9`G]A/OFW2m#*'2#Lfb@opAGUg2K,$6tr%g)%8D.d;WCo\V
f'dFJBIfF7&sFj3D+$rg_s`]A@3`-04q"1248D`AB$;AT9NUg*Ob>FVO#$(qtRQB`nAN",n?l
[]ANL:Q2;CBo&`s2[FKbO^0serG%kE6Q\j,gjVB`Y:A@<4"E]AAB*G,8,L[1\uPG/ESU`)[?fa
3+>7f@Kd(qplR/mts:-1mm:kM/bd3D+@dKRt+SsW6sNcX&+4V9uf>6f$%)*dQRj*4U-6CdGX
QP:C$pDDu$!0pR.nhV9Snu,jD>O\=TTmf@$#?nU;66/I>>Q/%:&J5^..M-3c,u(+#r3<naCI
BrB[Y7n_ti[K96U@eq45^WhWt\2\\:]AU]A]AK$k"$iV(^J,#pfkPC5l8\!W*Oq<>!tPgim`GJG
ne_&8%_G$7)g2'b['JSD`]A0?\(*GFd%-/Y]A0;:ZmUH8BY?j[^CI#%L<5-Am7p'C,7@[Y4l%e
ujG?2V1E;s`3\6Cp/Xnif4"..ucLI@[PQ$n^^efC-[Dh3OjfV6'ZO&`ui^/p\@PHRsE03%e[
4a9-OnehSH8D`OC\h2E5BaS$-cY36,$:4inudcgNL"ol^pD+_j"!&C)Bd-5k#Sp\Q-g(.1-=
4?A^e80.t=r$?(m^r$#,8GMf5@+-EJ5FlXtT24p^,W]ALo\C/R?^*$D-8EEV956S-Gcd=?\u5
(YH]Aj=H/k#Nl]A"Bd=Z'a+^K/eK@AR!S?&nL\IHOJ_Y_iK))<HGfU!AP^Te.7.TjiKQ?[Y#A)
l`Joo"&O5tRMk@VVllAcV16:$K(WkPB3O2/C-pX!"OS[h/m=6<NYH(B=;2hP4)-5h:>WkasT
Y5Z#^$:[ISI-(J02`R?rf.6mG\kB'LrOb1S\I7Ojqqi%>+/8pWF1f%SI.c$H3d@HlCV\,sPi
b<`gV[m_t#o[EFWX;<&Jef9Q]A5_e!1a[<h--O#Y2-:Na_[&&GF_G1/X5_lEaBN%/7c=>IA0B
X$@k,+'/</)rc_$-J>+M"J(>X8VP_+;3)KLng"ML,/@LD*K_VUc;;<Dt1`uN7\A&E94PSm.O
$JH\:+!eG``qEq8462Q[g"?c'/BF>S"cK_s41B(km7[gOaF!q;hO\DucS[TbMJc?L3$LIq/#
I:fI8I4pQ@&V"%bMl;+I5A=`ZVKKcJi2Ri7DW=gX!Z_dh\G(ZI!\B"_6_a$gNhN20+;JAWbY
@=,61T91MSu!S,n0*J$A2fKgF7Fk8<fUU%s@(f\ZtZ7FUK[OFHn5G)c;Xu]AoOh(Ytk(&R]A"c
Z2^f/nCSY[-kAOMsHFchQKYcKqSt'".$b<l$QDns&,e)AO1CObW-0-jR1ufN0B[ZPE[:?QgM
ggnXSVffIag(RIr/!F@N?aTHH\I';Um/0nTXpV?Wq;Is":.T5LplqPths@riZ]AWU7$Z9O(th
Ot1L*ZOMIhi1si&$pBhV[&i+q9WT$l'O2V/(jT7`_9e/nG63>-lcTL4pL*"r3Kdat^lHLWN"
S"0HR<U)]Ah;;?'O1^Eb:dUTdFBE,dQFUnpA.P1jH`?aQAS]A)_-kO7\T]A]AZmZQs?pt>(imKg<
if<[K<ln%D:Ghs<k]A\%NLW,YG)]Ao$<l5E!D%rWr4357>TsHUSXp%N[OO8`[s\:?*>$I1pH'g
[[2(K5#F(?]Al8Y,u"[U,6anONY7I;J/-s<ea%9NkinI.<gYl,QND"E@*3MHmHqph!g]A*=OT?
4BNE[HObG9q1?-!W$1,:U9$f]A#q`h22nK#r>?Eq4ieXq+&bb+Po]A)D:'M_AH#JV.b97LAhD/
LXl)&@.BDK]AGd@,!X]AJ0DqslHiC_5-MI-]A9g0?5%4our]AP@2\a*Sasp'1)EA=sg8e(ePCV1E
(M[o=1XW`YdC*L:<%A//P)@-M^98%;`hi-+%.Bn#_G.7UTS]A>H6?,@^U)>qL`(c:J802Ra78
2\5Xu6]AM_Frl1bD=5gh[a1k*ZsGpHlmKu'J.7Y>/S[jj*D7t1&iotuL9>h5tOQ$T&%=H[c<)
TrA:<]ABJtIN/GkoYG2A1/K1t,r0Zfred(U@J?Oa*+)d5'komi*pDrdHrRXeiXtRA9.;u=F"m
/,O"U1@N4;^;;&:3=jYKd_&k%j'Mp$0VYrYFU?O/@46gl6'4lFi%PfLsar>!P6!;-ekQIX<M
(0n03hL:[$:t%_%O'f'T2Gm.YTp.Z?cs4[;eBNK5)!t7+UccFVT5-g.@Grt+VAp>eOuLuFZ>
]ATJnX?^hTK\>SUPV-IWJi=@kou9eONd[O\',8BYJ?T2FPc.&r#_BTR?JE[khZp')TSGA-kbT
GcJ$k#@#,eN))b*1E_\Op"_4E2KI%\%rDJU1ZiT$pDfJ%klkN`$n"3`q=Q7^MrQ)[u\I'QBX
q.!\).'IYjg_e(K*?S\8"/f1^=''&:+Buk.c4,uXT4VOC=i4@m!)7h$[:AieV$,3'.MeIO_u
NMHmWbg7Q_Oo]AeTMO%dL^?`%57#/PE8kKdoEOTT\b3_stIBRu8iNinU6@B.diB`i(+Cdjc87
XJ,hk&S/nGkPHUN8Rbu"m9G(==%$0nP;19M@;nPY?d#MIir]AdW5ajTW\1j=N%Y^#ZBlQX6La
d+N3i4]A2@[CH8J/jKUDT7t\M21ttrK\PJI.mcgSc3jU71TV3kc_]Au:Ur['SF`<^!tsZ>nU]A+
]A=a_X7rGBB=M@>P#b^G0RgNp7am;_=pV%=%XTXs?t;`_m\5`)-g_VbN,LeICEW\oNY>&G(LW
`<mX@p%]Ao[ELnd*)<2/R8_0[RK/)ir2//#=(?,X0(]A(/nm[W/reEGhdf_J'?acD6U$26;p?1
Tp+UOgom"Um()f?u4P4$c%D,=*<JG/@4JnF>S(L$.D\LWRjJS`pHm,`.(q-^Kej$D"a\?q^>
V;1"UJPt63>;?aWIW5@OY/t`!>6au1]A^"@@G-4#$)eBIdrs=8aKl;T3%!qEAW9fZT\`07p0O
A"g%Qs.5A-Iu:ruL>RSscPo(cH_jR9f)"2"D<U"h9o1#$O/35jJdJ8B]AbKJC,&$'l!-D)2U<
8"`hr'Y:H.(UgI:m]A59#>#a9,8]AU-4$4qc2kej2@VNXSZdbUuVLlm$\5'pX_?f+Uobd]A\)sa
BtXJ'USY-"A0L<VKRq:m/D&A-U(oW<4iP5YtCjg)6R+kL5pjR<scbJP:m?lfIa0P&:%:&)S/
04/%U3PTrF@`2RZ9"/KK+"Zo3GJ[D6QpJ></C!7\[]AH;5h&9,hKmS_"/X9'*+WhZ&DK.il'*
-7(srd634El\IXld5jOpBlX.EaZlqPP3$G[]A]AlI+2f!;J:!j3(A"UfSTNVLRP&d2,H&69_XG
eXr"+$1_rK/trj`:';(u[2Y5'r4"IenuAOrDF%5'ZT6Bnh=ogrpJV/+F(Z7]AK!CP$rbMLckJ
n)1T\)0H`nEKqb;+-eFn^qBBeRPeHYucWBE0*!WCPP\sql$l*7_<#u#eKT7I+j^3n7VoR,'#
L,,u1qK)!d)`jBC#%BG.Th9VW/5!1*gd-CTgoU\QXLrB?[TEi-\;BE+_%Id8.."Hh5#DiD1'
X6JIdHRD<k/i<VR;u?P7:Z<FikOPAm/;9XJNL`EZMMm-!Fr;t9EV##UQHLM\!h7XRs[E9+%'
F#*]AJC$N.>c9,=VLps:[:?-jL;[j%.lu<1K'1;H#bSk:NDY_I@H=2cTqESo_r@WBn%.l4R%#
JU!cmo.:n=`Bq)l).T`>L8NK`F"#(>?!d'k3W*(hWD[=_5Jj>!SkYItMsLNH<Z3-3b7^eSMr
@K^L>FT&6dRI.r>/5n;T<Z8]AQaaNZ8@121EMO\,RJqs37r8Yi#h-e^iKM0b(1fXDf;+to&[_
glBu%^Q?'1n@$dJ(gU\r$`]A+T%=j,K9qf1?Qc!n-)8;q\M7_bObPmTD.7IO^^gVk)55_gUWl
\bdF-8(nnJ:c4_rJN'AR9p$_M1;C"<:^QhdZDq^Ze>/+oE%+6A;"#kCC01RdK&i=Jrb2.X59
D]AjmX&f-YX@=9Qk2%5d&#2Y#5jjZQfXR\\_@eEX%5o]A)!JS8,NOr_+Cde4$/eP/a<nQFhVl/
o>giVO=H*bo+#MGk[Y?I!G"icXq<Hj'u/k#qfcQb+JcZ\Kt!h=)pQh'KR<gskoNAMHaqHXp8
)j2\#5QQ`&QNtq?W4T&\t7GtCrq]ALSBdZ?saDIhKd53RobMCX6N3X1MkZmkSuHgmjP(<p,gq
S)*$$\uAbI\m.u;Y',Og'-4j34>0qf-/M0hblu&S7[&\+=<jB*mRQ+[l_LnRWEoK"[;>`\hO
2c$672mI5H"C&SqVT&Op%tP[:[qUMo\Oqp4dh&Qq-./,O!;L'8mi^0B=2_^GW"-KFc/^[7ED
7uV!+M-k:b70H6bD)rVjMQDusRc?:D/e?Q1l-4KS36"s^:<I*nYd]At0'(?V-9C+)K]At-Zn^F
J"on%1F7:Y6D_,4FOEoTpAQ)eY7RcPD"\57>=5j2[oi#/LO3QIIf]AG>h\'6Y:A2%sVa1XIlW
F6*'`:RjG`'>:bnWAW#D:-"[>]AFs[NRo#a^C:cj0$oQmmI'h]A#V,R#2*rAK^0DG'+sIdkF/l
H'9#&&oIm[NtOYI_:*:b+('=<m)q=n$4G8oC#.U`a,4;'UMmF-bqb/HmJc/LfMeOecB$&^"l
tHKt@Qo^q9j@U<=VX3_E-g(R!-lBL*Pqf76NB_k=/h4j(7%0uT<DZ:MM>W3XGO3?<!e>G<as
P!+)20Hnqip%\&+hhs@N_@3'eeP0!`C&<b-8\T3:RkW)6\aYHpKISHfq))79Q__Zo20]Ak,>n
*cl?E`crr*cC&D$O_NM]AEs*S:JFGeXm^a+3a8cS&tL\bCFn3Xj;/=-"cGsoaU[%i[tNWgp(*
On$`@hQ9qVlO<iYLe:!.@K>3Jbb@P.iBb#ZZei;7W.fiQ*H00e:b*uF/m+r'd:J;G/puY$BA
h4;He/21tDSR%=rk):=]A&:u0%48o=,hL(Ga/*sWl>_MZB:e:+1WBID\6ekjXlj)ZEQmg7d:-
)rb%+-Vr^&LlPd3&Hj8_)GF.P4Zj^l$M*t2hm,%U5gWorhrh?'QRVEh%d":"mLN;1aNFb.?P
)kUnh#]A:r24Y+/`1p8Mf^qEK[%-qPl)1gG@OU9(3</TT/0eu6VfN)hA>U;LplqmlL@q:`sZI
0oP!Ph[m>Wj<+r9NN":qNPYPYJA2pb2""#2g"s]A(r=cKRauOopBe!$F[r7U!8o%gf<8^=EPO
\J%b93$Q[jA)!Z'n9@h7#/LKs1dW[3bld]Ak)gVgLP[TY,0AA"M8%nDFKb:6T6$RrX43fFuj@
b3-lmAn7sV8u+7I$=ZuJW!kr@KEFSY6FI_>&$\t4TkSi,a)gN1?`&fF8(O:H#%]A.2RO<Q8eI
p-m&EX<A.qG;KFSaeHo6Umgc5>HRd"HcYucD%Z9rBVAlt:eT]A`WW;"cfKH"EYP6^>qVc=maa
/`.>d3hQ7OKUj`T*-0!BrK%Rr37j5Ic$%u99[f_0dU&>T_`dI3,tNg5lA_=>am,M1hXbJWfY
@FjbAM4k`(:V./iq^LVKmW3?8%Z0$UF]A;=:&+ZLgf*((_,WY%k]Ad1]A&>aWHF;((S&RGgeT[5
EFuth;,4n*n!h73?Qsm:%<6oP@O<j3?4W`ufdZ9m%CrQip<dnRe5Vg.I`O!OW8d6N`_[0RN/
i0$=j!V2%**%&^2HM&>$fdh)\#i4Np?@?rj3*nJ00EQ$7-Fp_[ZI/f0Q_4uG#O"gC^ZVoJ,=
kd;PJ:&1rgA1Z8IZtD;Uj@0Aa0AI^,2gd;-EThb4&q1sCGJ.,\4I20PtQc%dOa(g<]A`4jdu[
>T&^.n6hbTe+bUD=^*LYP7Pk^+#`Z^'Pc1`brrA)FbDT9$UgfZ1QV_###8mKULJ9_lorDFaf
qM>jGb&W*srS7"@QL?@o?L><fGildC6dQi`HFcRZuAGkaQrV4mQR1J;8-s0j?FliLHa"ET:X
#flAA4HYC!%=RFJ#D!?#P'T@rWf%e:VI14*g8\<aU#+b/6bL^GQNT[s3#-'5N0`TPa/#+OPK
q09q\F#0?(8V`7DkWnq+0o8O1(fZNbf<F>-Uc#KXr&:p"Hh65Q8`A\:.PJB76Tb)7a?:#8g)
28V$%:KLO!35`_DWnRgSQ*U'5,XD4[H/r=j)e/2Vi$0%C6QNm/kAXcVZ-ZEC@$YS]ACaULLda
[id,c_$N=[B\5aQ5%6S*2Ya_Ee&*Z3WS[b,Yt'`Km"OOq/ETe$"h8i?M\>h\-SXKDpcGebmo
*ieX,d7+RR[:&XHiu"b;e\)gD>ri`tUO'(;aKu35oG*-D5@FUs+:9OCh57(l\RS4X,6$itos
3ZCfp4KuFXNTR#M=R/,spS"]A&ff?>caa%JA=@HfDAWDp[2.KP@aiAlW?oKDAc;Iopq%V^-:?
lh/48TI5gVj4Wi&rRkC054'#^4Ot<]A_G+WY`ui=F1aJtSa?G!3nKl@Lfb:#o&ng*h"MP_,kp
g2cJVDWIMVON2hkGV!_mJY(re4Ug0"s(LshT1jlfVVUtDqc.`[BBEEe8JSE=DiR_(0n[*+FM
\,\<++L7WQ;-90(:8FT*NghWEBL+XF!Ar*>Hn7+7aLel.[T>VQHNUU>Kkk).U7.,.HDW&&J"
:XuB4Gh7Y"(uoTn<uY_7clO`nd0]A;/Fapo8@WOGh&Jpo'hp`XF$udHuObYYHpt<F:\[RglVo
n]Ai]ABS.2c!8(o--2eR1rdRp\f-JM[*K[VlgL%HS8EdV.Urj:#D]A3/C$5#8_`Z]A.ZfDb=#&"E
=VlD^%3j;r:V'P`b@ZS)3Y/q]A--qZFde&W<cqu=_)GbTmA.:03*82\I-?i1I^K#l#`TOO$Z3
e!gP#B:-cUULM+/h`>oe@RLElWX$Y1r(6EZh7PE1jFocY'OeD)fifDN:QZ%"6L+nhV+5Y%ig
T:$AGmJ3uDc^!*PaDi[%irkk$RUBPm)gs!#oIP%Ma<iIc^MN7#=a!&<#K%&:K:Z-[TCZrG%r
".F<=S<ja4BVU<#bS?+*#D?EG]A.(=?_=fp\aR<o.kO$>k$bX<?^rd&$J]Ah%2AAr156EpZAIX
X,)M'.!fYpW6kQ1V0b/!@(C%p+e6nUFFU]AsV=U9/!,b[kE9<0T`aLpncS^R[54_9cD'!kXee
P;6pb3Vp^>aUrahC[Psju46Ro#[+:[erF@cmW/sF>ke5"V$At450,N`kHWVY+><Wl7a+TU9'
V>$42!9qjE'Qd,=I.*4D"0Jq"[4lff=-AO<(TpZmhi,b>VS^0Gip@oRF1W%+Jab-Or&X`+F]A
6>Dp`fVDR6er7AH;B`J59b,7*IXijRiJ=ui*o[6K?R9CZ3DUU<R\)2$GE15_IJhFgG[c`Mq8
g)0b#c*Fa+JVBejRB#3?`$G!InFI563L%^VBH_Y9qi/L&+oF!`:86eJ_7C*7i2#SSP/`Qr*-
Rn-fpjkUtCXMKkN6s/tbb>pkbNY3BeM&u8fZffV,d-Vl&')J%c<YB]A0pr>M%X9aV<[!bYm,U
A#=QM-g@oTT#IW`WoUJ#lc4p'or[hqaD5e.ga[d7-;"X41:t2b'l_rW)"?d.U.?@j<?2[0hf
0^]AreTA9!(aHIuj^D+A-4BJQ\"Cnnn@t4gso!M^dk'NW5aVYPmYaMJMM=g:2#Jpub[Vm]A?O2
8_qQ')4]A@9`VVpMi$4i$QJgC]AanoV[=:'N9JlZPA=El/jc$&4kPQtVZ;]AKPKD#@]A\Yh%-E,u
F?d"h/b)Q]A<H1c6CKhb!Esj&NIJ9bZp?Y@66AEh_M1F,V9q#5Grd\^rc.I%hY)!s!nA!^u"+
#2I>?[2K%NS>ZX=p1D,a@(O7VD"!q>!S[f=K"tZE&82-hl!?l7a)t+[)n2:oSVCJcZrSXg5(
o-qaT6Y9RjhCjKTAtUeWp'a`#c?p8NV\-QDLFD7)BrX*3-J'MX'/qj^uNKIRC-b]A`A4dDQ2]A
XgN_ZNb7>,\5dd?;6H@q)n-N'-ShP/4.n$5hL!FsqIATXkQ&;,+),aC@BZX2:SEc1golDuk&
+RoM93[oM*qT+"kU&UKj.k\"'9=i-gAmr;+.PO2JN>X43`(gfkMQQ#>2PFJ@DL4Q"'6E7%iB
D6B_2!-uDAd8`edKR?cJf9u90$83o'(3I!TB>+TNLm''[%@8>s6dP,!1*]A-[';$#=>MZ=?B?
-ps?3Ve%gB!LMn<E9#&Bb[6-TIekermSrA%Yg/8Op58[iADQ.Rdb1GWJ:5aJLmjFo\1:1%sL
i=tZ)@t5r#3aV);lY6+:,'R^/?jNGp8Ne7^37]A@M<^No!d1.1^(2Hn@MniBb]Agid`%WV053i
O90.us?hBg!0]A2%#e0dite.ndXB3[\6'P\2&N[$Z762qnjr247(L@grCIMMm@7_Wi4m<6SG_
WWh=0TLX.d`e6p#/<Eua7OheM,B.,-DL'!I=DJ!X_:G=lpY;dd)aaBre=^nFI!D;VABbH+W%
kr9.Ld>fOP=2Ia9UHAkgZ==U!/=2a/j9#n(Y(mQlhmfk-iP*7co&!,D&sIdT=\XI06Kr_P$-
bgY0h[K&hQr.`1CH.n*$Plgb.W^p2FG)K-SgndF>P]A%g&_*d.a=8EXImhR%KU+s,B_+u\E-,
IcP<@l3+rUbgVp('JGn:@&;Ajuhc"m^n4o(p`24`1FNs:N6.-@%1-_A%N8;Kq"pY</2u1dl6
tO!]AN,!dh5u47*Ogma5ucN6eaC+/%.@aC8D@+%)86ch[<<+aKJ02&"i/FgMBCfZJJi&U(Cla
hR-l]AT^RQBk;AQDV>Acb()Q<e[\ERn>%-lj-\Pn!<4>)LCNrA_NOa2l)95Y\F-Q::%cj9"4s
6%rgk6"PnbmC!mCYQ7R#FN\81XTh."<^0lgLfG>E(U&k=34fahC*&C'S7$V)DsR*AQfm6h,u
3%f?!UU$YF90lB?fO8\NYY2T%/fDTnADoo5pF5e';/^\sZe0AErakD4!,V/BY@q#0/anNJW>
`(2ID=?<Jf8mB-Su`t_K!lWY7_'.9dS,5(Vaff5Xi/q-\g*]AuNcUlNIsn5;48n-6$ZdRCFtg
!a-qgj\WcSL;b1Gs[$=JNq)u)?eT+sjL66S6jD)R_.,CbtEgWA7r>QcK(n+X[>HbFCmI0e4+
`SORA/5]APm;oTi60`+GH%&6.o:7]A,gVm3#MRiWC8=mr>8iSS!k4`MisP=RGpK!t""iO2pbC8
ChTl2P)IDgClc;q,$1Zllp(gh"`fb&q9nX]A!Wd"3HS`c99@6=2$ntjNhR#Hc(p2.?QLoCCP@
!eMaa2CoB/4q>KV_Nu^gW.:VRmmEXC4Ulj?ln;6FCIsf9eZ);6H)8a+n#d5jtJ%&Hmrb0."H
P+uUIWlHH[J[#=>oPr/G\o3+RTcR(q>P`_&NGHMp=V3n]Ap>WP:W#Dck'@hsT,+s'_bo5a8S:
lfiCMp:!GqJ<rXYe`s'CZlC$/E=Yas*I#(QS%ZQcW$.iF]AsQ1cn]A5mn*pm1+NIrH0>d.cOc@
+1R"OKM*WMU@;dk'H!WA73f!8%)t#T%#a!H7nTo',&h71/UC;d%IZm3,AhClER%)RZ.nPapr
R/%&RiQ.*`YlYB_tCk"knE*GB";9@t0EpVj5.m/&pcHo,GZL,5Mp8J\K8,lEdTiTbVRQ#Sp_
V-T8U$0"mW!L\tR[IV;*_PP1+o+A@uIqVt09IB7D]A-c]A:YLNPMLj+\frVQ1kX.g<Z*#%2s/R
RFVS`oT?olE*m1Mj+h1*%l@:A;DHi%EuIG\'\#emJ@l_9(_?<H'LT&K"b,=pRiln"4qLW@9f
&LZb6++@aIM#P"uWm6JIWm(:X*P@ieW;7<gA>Xl1Fm!`X&SACo;Kh*-@-@n0B2_?[VNi^uo"
&@V]AO!6-Xr<>uaW6eb8prY7>ta`smVV1o&\(d3.A6B=RSCY!qKMecfm$Ar/NCMQ&6Y@=oaS=
S)0@r-.Spb1s7Lr7L]AVGZsYAaFXV?.>4=hQh6Z2=:L3BgLKp3Ak\K_H@YiQ[>e,'%S4bGZF>
lkoY[m@ublP#UkpVgDI"pcKC>ZS;!o#2ZV!misK1B\JCM:Zn,2Ip%J@MJ5o4OX\.X;ML$n0R
e0'(DIO+lF\O@Yoc_Bl+i#S\U+n?jm(6bc:T-lTAlL"SD+2apA<G.'NP0:o&G?O#f59O+]Aq,
N?c3JqaV3aM*SV[=,q-PjM!jO(:-6BUWZse0QV0nm-:`T%o1.OOC1cMRXFsTJr+6T;LQ3'gS
Y=)r'KZS)"Sg7/"+L3u\mfE$`q9q`So9*c%5!TO4'eVBte@A0IB3D#jJ36M7P40WeAKus-<P
@M]ANdc>:U2&tqSZ3.Ia>Fc.#Nj#)dlp_4Km^;?elRLF^QH5nQ'?o;_`&sS)j@e+2"sk3CcAr
AD8(n:b*5a]A^JF,LLNpnpO/3eP)ob&&KO/Qh5Nj##8APKmg;qH>q<@obHHRMW:A+dr8_fb&9
cDR`%F6E'`=<3_W$dT%k24EdCUH`5#]A5V^@F=:DO/Srk?o7<NO-t,eO]AbnB`r^aO]ARS'%CFr
EHs(>?8Dnt3<pl@PM8t(<]A,4Q1U+(bU\&52g="kfCbla$5-nWG5OTMh7bd:J2P7b"1gDH,<!
FLU6s?eNmDIS$dK>uXaDlX56T.""Nk?s-d,CDUrlJIQ*,H.!6`0B<?+>XP\f^YPAMLFDSmFk
2E<T>)l:despA2lU]A(hM1b?\9j\T&0X0>i,R/f[.U$(kE+cu6o=s`T^sOb__]Akjn,@Nh_h$D
9(%7\$gIhkl;.$^)XBd7ci?tZ+J87,[]ABDa[K'6m!"0g[[I(6WdMmu/]Amqj$oIX-d7U]AsZB\
fl69EP2sI^UIs>9.,k.%WUAC`dDH57"0X$$6eJ2>u=$A-0q[W5Q3;P-XH0X]AiT1?PSSKhmhb
+_Bgn\12<6]Asp*QghX?-:UP?\&W`NdqDH?ScEHJnVMA=.kjT&LON:mQh5c)PuX&IPT4JNp^<
IoMpkHG-"t=39[Z`1B$-p[NALX:,!ul6!*r'_S&nYc<uA-b')9MHaA).Gs5Hp!>7tcJ]A^7[A
t[OoEt:NWtqW9'NV?HqoPu?UZ/5&[ANq/Nr/>?rG(!,EHr;:$#Z'gQQN<?4]AhE;5q9VIafYT
<i`]AmY5HA`c9.3cb%u%[W?0r`4/fc_Fc)S*'P8%%,^&6!Ss.eRSP1G*7icsqZ-WL,!lCUoO'
<6OKohVOcafRe$qBo8BjOTr"r=c2\6M4-QrX%+>U&$-9s+K[0;#QS^ImWg(W;ao@s*pcS-WL
#sHF=aXpg?aUK_>@7jk/<<QN&Q(DIkTG./V_2MTbP"o<HF_(OuEK~
]]></IM>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false" appearRefresh="false" allowFullScreen="false" allowDoubleClickOrZoom="true" functionalWhenUnactivated="false"/>
<MobileFormCollapsedStyle class="com.fr.form.ui.mobile.MobileFormCollapsedStyle">
<collapseButton showButton="true" color="-6710887" foldedHint="" unfoldedHint="" defaultState="0"/>
<collapsedWork value="false"/>
<lineAttr number="1"/>
</MobileFormCollapsedStyle>
</body>
</InnerWidget>
<BoundsAttr x="0" y="0" width="960" height="540"/>
</Widget>
<ShowBookmarks showBookmarks="true"/>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="report1"/>
</MobileWidgetList>
<FrozenWidgets/>
<MobileBookMarkStyle class="com.fr.form.ui.mobile.impl.DefaultMobileBookMarkStyle"/>
<WidgetZoomAttr compState="0"/>
<AppRelayout appRelayout="true"/>
<Size width="960" height="540"/>
<ResolutionScalingAttr percent="1.2"/>
<BodyLayoutType type="0"/>
</Center>
</Layout>
<DesignerVersion DesignerVersion="KAA"/>
<PreviewType PreviewType="0"/>
<TemplateCloudInfoAttrMark class="com.fr.plugin.cloud.analytics.attr.TemplateInfoAttrMark" pluginID="com.fr.plugin.cloud.analytics.v10" plugin-version="2.4.1.20220120">
<TemplateCloudInfoAttrMark createTime="1633746075224"/>
</TemplateCloudInfoAttrMark>
<TemplateIdAttMark class="com.fr.base.iofile.attr.TemplateIdAttrMark">
<TemplateIdAttMark TemplateId="d38f76eb-ba75-4b7c-9563-101fd36cd995"/>
</TemplateIdAttMark>
</Form>
