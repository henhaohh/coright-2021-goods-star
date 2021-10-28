<?xml version="1.0" encoding="UTF-8"?>
<Form xmlVersion="20170720" releaseVersion="10.0.0">
<TableDataMap>
<TableData name="门店总单数" class="com.fr.data.impl.DBTableData">
<Parameters>
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
<![CDATA[]]></O>
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
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[NRC_DCPS]]></DatabaseName>
</Connection>
<Query>
<![CDATA[select 
    b.companyno
    ,a.shop shop
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
    b.companyno,a.shop]]></Query>
<PageQuery>
<![CDATA[]]></PageQuery>
</TableData>
<TableData name="单数分门店和品号" class="com.fr.data.impl.DBTableData">
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
<![CDATA[]]></O>
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
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[NRC_DCPS]]></DatabaseName>
</Connection>
<Query>
<![CDATA[select
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
,(CASE WHEN c.sno='010101' or c.sno='010102' or c.sno='010103' then '现烤组' WHEN c.sno='010201' or c.sno='010301' or c.sno='010401' then '工厂' WHEN substr(c.sno,1,4)='0105' then '西点组' WHEN substr(c.sno,1,4)='0109' then '水吧组' WHEN c.sno='010402' or c.sno='010701' or substr(c.sno,0,4)='0106' or substr(c.sno,0,4)='0308' then '代销品' WHEN substr(c.sno,1,4)='0108' then '裱花组' ELSE '其他' END) cat_name -- 分类
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
${if(len(para_cType)=0,"and cat_name!='裱花组'",if(para_cType='裱花组',"and cat_name='裱花组'","and (cat_name in ('"+REPLACE(para_cType,",","','")+"') and cat_name!='裱花组')"))}
--${if(len(para_cType)=0,""," and cat_name in ('"+REPLACE(para_cType,",","','")+"')")}
group by companyno,pluno,shop]]></Query>
<PageQuery>
<![CDATA[]]></PageQuery>
</TableData>
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
<TableData name="门店商品销售" class="com.fr.data.impl.DBTableData">
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
<![CDATA[]]></O>
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
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[NRC_DCPS]]></DatabaseName>
</Connection>
<Query>
<![CDATA[select
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
,(CASE WHEN c.sno='010101' or c.sno='010102' or c.sno='010103' then '现烤组' WHEN c.sno='010201' or c.sno='010301' or c.sno='010401' then '工厂' WHEN substr(c.sno,1,4)='0105' then '西点组' WHEN substr(c.sno,1,4)='0109' then '水吧组' WHEN c.sno='010402' or c.sno='010701' or substr(c.sno,0,4)='0106' or substr(c.sno,0,4)='0308' then '代销品' WHEN substr(c.sno,1,4)='0108' then '裱花组' ELSE '其他' END) cat_name -- 分类
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
${if(len(para_cType)=0,"and cat_name!='裱花组'",if(para_cType='裱花组',"and cat_name='裱花组'","and (cat_name in ('"+REPLACE(para_cType,",","','")+"') and cat_name!='裱花组')"))}
--${if(len(para_cType)=0,""," and cat_name in ('"+REPLACE(para_cType,",","','")+"')")}
${if(len(para_shop)==0," and shop in (SELECT Shop FROM Platform_Staffs_Shop where opno='"+para_opno+"')"," and shop in ('" + REPLACE(para_shop,",","','") + "')")}
group by companyno,pluno,shop]]></Query>
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
<TableData name="单品总单数" class="com.fr.data.impl.DBTableData">
<Parameters>
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
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="para_bdate"/>
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
    b.companyno,b.pluno]]></Query>
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
		and substr(b.sno,1,2) = '01'
)
where 1 = 1
${if(len(para_cType)=0,"and cat_name!='裱花组'",if(para_cType='裱花组',"and cat_name='裱花组'","and (cat_name in ('"+REPLACE(para_cType,",","','")+"') and cat_name!='裱花组')"))}
group by
	viewno]]></Query>
<PageQuery>
<![CDATA[]]></PageQuery>
</TableData>
<TableData name="门店总单数2" class="com.fr.data.impl.DBTableData">
<Parameters>
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
<![CDATA[]]></O>
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
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[NRC_DCPS]]></DatabaseName>
</Connection>
<Query>
<![CDATA[select 
    b.companyno
    ,a.shop shop
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
    b.companyno,a.shop]]></Query>
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
<O>
<![CDATA[门店明细]]></O>
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
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$para_viewtype = 0 || len($para_viewtype) = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="1" r="0" cs="10" s="0">
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
<Expand order="2">
<SortFormula>
<![CDATA[K3]]></SortFormula>
</Expand>
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
</HighlightList>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=&C3]]></Content>
</Present>
<Expand leftParentDefault="false" left="C3"/>
</C>
<C c="2" r="2" s="5">
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
<Expand dir="0" order="2">
<SortFormula>
<![CDATA[K3]]></SortFormula>
</Expand>
</C>
<C c="3" r="2" s="6">
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
<C c="4" r="2" s="6">
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
<C c="5" r="2" s="6">
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
<C c="6" r="2" s="6">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=LET(A, 单数分门店和品号.select(SHOP, PLUNO = C3), sum(门店总单数.select(CNT, INARRAY(SHOP, A) > 0)))]]></Attributes>
</O>
<PrivilegeControl/>
<Expand leftParentDefault="false" left="C3"/>
</C>
<C c="7" r="2" s="7">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=D3 / E3]]></Attributes>
</O>
<PrivilegeControl/>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=$$$ * 10000]]></Content>
</Present>
<Expand/>
</C>
<C c="8" r="2" s="7">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=F3 / G3]]></Attributes>
</O>
<PrivilegeControl/>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=$$$ * 10000]]></Content>
</Present>
<Expand/>
</C>
<C c="9" r="2" s="7">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=H3 - I3]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="2" s="8">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=J3]]></Attributes>
</O>
<PrivilegeControl/>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=$$$ * 100]]></Content>
</Present>
<Expand/>
</C>
<C c="1" r="3" s="9">
<O>
<![CDATA[统计]]></O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Expand leftParentDefault="false"/>
</C>
<C c="2" r="3" s="10">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="3" cs="4" s="10">
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
<C c="7" r="3" s="10">
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="3" s="10">
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="3" s="10">
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
<C c="10" r="3" s="11">
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
<Attributes dsName="门店商品销售" columnName="PLUNO"/>
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
<Expand/>
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
<![CDATA[&C8 <= 5]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ForegroundHighlightAction">
<Scope val="1"/>
<Foreground color="-8388608"/>
</HighlightAction>
</Highlight>
</HighlightList>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=&C8]]></Content>
</Present>
<Expand leftParentDefault="false" left="C8"/>
</C>
<C c="2" r="7" s="5">
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
<Expand dir="0" order="2">
<SortFormula>
<![CDATA[=J8]]></SortFormula>
</Expand>
</C>
<C c="3" r="7" s="6">
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
<C c="4" r="7" s="6">
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
<ColumnRow column="2" row="7"/>
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
<C c="5" r="7" s="6">
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
<ColumnRow column="1" row="5"/>
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
<C c="6" r="7" s="6">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=LET(A, 单数分门店和品号.select(SHOP, PLUNO = B6), sum(门店总单数2.select(CNT, INARRAY(SHOP, A) > 0)))]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="7" s="7">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=D8 / E8]]></Attributes>
</O>
<PrivilegeControl/>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=$$$ * 10000]]></Content>
</Present>
<Expand/>
</C>
<C c="8" r="7" s="7">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=F8 / G8]]></Attributes>
</O>
<PrivilegeControl/>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=$$$ * 10000]]></Content>
</Present>
<Expand/>
</C>
<C c="9" r="7" s="6">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=H8 - I8]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="7" s="12">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=J8]]></Attributes>
</O>
<PrivilegeControl/>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=$$$*10000]]></Content>
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
<Style horizontal_alignment="0" imageLayout="1">
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#0.00]]></Format>
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
<Style horizontal_alignment="0" imageLayout="1">
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#0]]></Format>
<FRFont name="SimSun" style="0" size="80"/>
<Background name="NullBackground"/>
<Border>
<Top style="1" color="-1"/>
<Bottom style="1" color="-1"/>
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
<TemplateCloudInfoAttrMark class="com.fr.plugin.cloud.analytics.attr.TemplateInfoAttrMark" pluginID="com.fr.plugin.cloud.analytics.v10" plugin-version="2.3.0.20210831">
<TemplateCloudInfoAttrMark createTime="1633746075224"/>
</TemplateCloudInfoAttrMark>
<TemplateIdAttMark class="com.fr.base.iofile.attr.TemplateIdAttrMark">
<TemplateIdAttMark TemplateId="d23886bd-67fe-4aa7-b0ff-ce9e39f33119"/>
</TemplateIdAttMark>
</Form>
