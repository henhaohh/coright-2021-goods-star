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
<Attributes name="para_bdate"/>
<O>
<![CDATA[]]></O>
</Parameter>
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
<![CDATA[select 
    b.companyno
    ,a.shop shop
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
    b.companyno,a.shop]]></Query>
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
<![CDATA[66]]></O>
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
<TableData name="门店商品销售" class="com.fr.data.impl.DBTableData">
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
<![CDATA[66]]></O>
</Parameter>
<Parameter>
<Attributes name="para_bdate"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="para_pluno"/>
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
${if(len(para_shop)==0," and shop in (SELECT Shop FROM Platform_Staffs_Shop where opno='"+para_opno+"')"," and shop in ('" + REPLACE(para_shop,",","','") + "')")}
group by companyno,pluno,shop]]></Query>
<PageQuery>
<![CDATA[]]></PageQuery>
</TableData>
<TableData name="单数分门店和品号" class="com.fr.data.impl.DBTableData">
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
<![CDATA[66]]></O>
</Parameter>
<Parameter>
<Attributes name="para_bdate"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="para_pluno"/>
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
group by companyno,pluno,shop]]></Query>
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
<Background name="ColorBackground"/>
<LCAttr vgap="0" hgap="0" compInterval="0"/>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ComboCheckBox">
<WidgetName name="para_cType"/>
<WidgetID widgetID="09737fb5-8508-46c5-9695-468ef070a899"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="comboCheckBox0" frozen="false"/>
<PrivilegeControl/>
</WidgetAttr>
<DirectEdit>
<![CDATA[false]]></DirectEdit>
<watermark>
<![CDATA[请选择]]></watermark>
<CustomData>
<![CDATA[false]]></CustomData>
<Dictionary class="com.fr.data.impl.FormulaDictionary">
<FormulaDict>
<![CDATA[=['现烤组','现烤三明治','工厂','西点组','水吧组','代销品','裱花组','其他']A]]></FormulaDict>
<EFormulaDict>
<![CDATA[=$$$]]></EFormulaDict>
</Dictionary>
<widgetValue>
<O>
<![CDATA[现烤组]]></O>
</widgetValue>
<RAAttr isArray="false"/>
</InnerWidget>
<BoundsAttr x="431" y="7" width="80" height="21"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ComboBox">
<WidgetName name="para_iscoupon"/>
<LabelName name="结束时间"/>
<WidgetID widgetID="fd8c737e-b137-42a5-9cb6-cff882006d43"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
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
<![CDATA[]]></O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="330" y="7" width="80" height="21"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.parameter.FormSubmitButton">
<WidgetName name="formSubmit0"/>
<LabelName name="结束时间"/>
<WidgetID widgetID="fb4c2f7f-27ce-4482-a924-cb5b65e9325d"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
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
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
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
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
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
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="dateEditor1" frozen="false"/>
<PrivilegeControl/>
</WidgetAttr>
<allowBlank>
<![CDATA[false]]></allowBlank>
<DirectEdit>
<![CDATA[false]]></DirectEdit>
<DateAttr startdatefm="=$para_bdate" enddatefm="=today()-1"/>
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
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="dateEditor0" frozen="false"/>
<PrivilegeControl/>
</WidgetAttr>
<allowBlank>
<![CDATA[false]]></allowBlank>
<DirectEdit>
<![CDATA[false]]></DirectEdit>
<DateAttr enddatefm="=today()-1"/>
<widgetValue>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=DATEINMONTH(today()-1,1)]]></Attributes>
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
<ParamStyle class="com.fr.plugin.mobile.top.query.pane.style.MobileTopParamStyle" pluginID="com.fr.plugin.mobile.top.query.pane" plugin-version="10.4.976">
<Attr autoCommit="true"/>
</ParamStyle>
</North>
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
<WidgetName name="report_STAR"/>
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
<WidgetName name="report_STAR"/>
<WidgetID widgetID="01205e46-f63c-4e2f-a895-563bc612e6a4"/>
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
<![CDATA[723900,1296000,1296000,1296000,0,723900,723900,723900,1296000,1296000,1440000,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,2016000,4032000,4032000,2705100,2743200,2743200,2743200,2304000,2304000,2743200,3456000,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
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
<C c="2" r="0">
<O>
<![CDATA[]]></O>
<PrivilegeControl/>
<CellGUIAttr showAsDefault="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="0" r="1" rs="4" s="0">
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
<C c="3" r="1" s="2">
<O>
<![CDATA[门店]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="1" s="2">
<O>
<![CDATA[商品_门店_单数]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="1" s="2">
<O>
<![CDATA[门店_总_单数]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="1" s="2">
<O>
<![CDATA[商品_总_单数]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="1" s="2">
<O>
<![CDATA[全体_总单数]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="1" s="1">
<O>
<![CDATA[万购率]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="1" s="1">
<O>
<![CDATA[万购率]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="1" s="2">
<O>
<![CDATA[差异]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="11" r="1" s="1">
<O>
<![CDATA[星级❓]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="网络报表1">
<JavaScript class="com.fr.js.ReportletHyperlink">
<JavaScript class="com.fr.js.ReportletHyperlink">
<Parameters/>
<TargetFrame>
<![CDATA[_dialog]]></TargetFrame>
<Features width="600" height="400"/>
<ReportletName extendParameters="true" showPI="true">
<![CDATA[/ERP/定制报表/2021/hh_产品星级表_child_info.frm]]></ReportletName>
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
<JavaScript class="com.fr.plugin.mobile.popup.js.MobilePopupHyperlink" pluginID="com.fr.plugin.mobile.popup" plugin-version="10.4.976">
<Parameters/>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<PopupTarget>
<![CDATA[template]]></PopupTarget>
<ReportletName extendParameters="true">
<![CDATA[/ERP/定制报表/2021/hh_产品星级表_child_info.frm]]></ReportletName>
<Style borderType="0" borderColor="-16777216" borderRadius="4.0" bgColor="-1" bgOpacity="1.0" mobileRegularType="auto_height" mobileWidth="95.0" mobileHeight="95.0" padRegularType="auto_height" padWidth="95.0" padHeight="95.0"/>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<CellGUIAttr adjustmode="0" showAsDefault="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="1" r="2" s="2">
<O t="I">
<![CDATA[1]]></O>
<PrivilegeControl/>
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
<![CDATA[=&C3]]></Content>
</Present>
<Expand leftParentDefault="false" left="C3"/>
</C>
<C c="2" r="2" s="2">
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
<![CDATA[IF(LEN(para_shop) = 0, J4, I4)]]></SortFormula>
</Expand>
</C>
<C c="3" r="2" s="2">
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
<C c="4" r="2" s="2">
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
<C c="5" r="2" s="2">
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
<ColumnRow column="3" row="2"/>
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
<C c="6" r="2" s="2">
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
<ColumnRow column="2" row="2"/>
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
<C c="7" r="2" s="2">
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
<Expand leftParentDefault="false" left="C3"/>
</C>
<C c="8" r="2" s="3">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=E3 / F3]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="2" s="3">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=G3 / H3]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="2" s="3">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I3 - J3]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="3" s="4">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=SEQ(1)]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=LET(A,&C3, IF(A<=5,'<span class="ani ani-flipInY" style="border-radius: 50%;width: 2.25em;height: 2.25em;display: inline-block;text-align: center;font-size: 1em;line-height: 2.25em;background-color: #900;color: #fff;">'+A+'</span>','<span class="ani ani-flipInY" style="border-radius: 50%;width: 2.25em;height: 2.25em;display: inline-block;text-align: center;font-size: 1em;line-height: 2.25em;background-color:#aaa;color:#fff;">'+A+'</span>'))]]></Content>
</Present>
<Expand leftParentDefault="false" left="C3"/>
</C>
<C c="2" r="3" s="4">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=C3]]></Attributes>
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
<C c="3" r="3" s="5">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="3" s="6">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=INDEXOFARRAY(ADD2ARRAY([]A, I3), 1) * 10000]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[LEN(para_shop) = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="9" r="3" s="6">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=INDEXOFARRAY(ADD2ARRAY([]A, J3), 1) * 10000]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[LEN(para_shop) > 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="10" r="3" s="5">
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
<C c="11" r="3" s="7">
<O t="I">
<![CDATA[1]]></O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=let(shuoming,'先将单元格放大10被取整,然后除以2并取余数,除以2的结果为整星,余数为半星',a,$$$,b,int((1-&C3/B5)*10)+1,full,'<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" style="display:inline-block;margin:auto;" viewBox="0 0 16 16"><path d="M3.612 15.443c-.386.198-.824-.149-.746-.592l.83-4.73L.173 6.765c-.329-.314-.158-.888.283-.95l4.898-.696L7.538.792c.197-.39.73-.39.927 0l2.184 4.327 4.898.696c.441.062.612.636.282.95l-3.522 3.356.83 4.73c.078.443-.36.79-.746.592L8 13.187l-4.389 2.256z"/></svg>',half,'<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" style="display:inline-block;margin:auto;" viewBox="0 0 16 16"><path d="M5.354 5.119 7.538.792A.516.516 0 0 1 8 .5c.183 0 .366.097.465.292l2.184 4.327 4.898.696A.537.537 0 0 1 16 6.32a.548.548 0 0 1-.17.445l-3.523 3.356.83 4.73c.078.443-.36.79-.746.592L8 13.187l-4.389 2.256a.52.52 0 0 1-.146.05c-.342.06-.668-.254-.6-.642l.83-4.73L.173 6.765a.55.55 0 0 1-.172-.403.58.58 0 0 1 .085-.302.513.513 0 0 1 .37-.245l4.898-.696zM8 12.027a.5.5 0 0 1 .232.056l3.686 1.894-.694-3.957a.565.565 0 0 1 .162-.505l2.907-2.77-4.052-.576a.525.525 0 0 1-.393-.288L8.001 2.223 8 2.226v9.8z"/></svg>',let(c,int(b/2),d,mod(b,2),REPEAT(full,c)+REPEAT(half,d)))]]></Content>
</Present>
<Expand/>
</C>
<C c="1" r="4">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=COUNT(C4) + 1]]></Attributes>
</O>
<PrivilegeControl/>
<Expand leftParentDefault="false" left="A2"/>
</C>
<C c="8" r="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="5" rs="3">
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
<C c="3" r="6" cs="5">
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
<C c="0" r="8" rs="3" s="0">
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
<C c="1" r="8" s="1">
<O>
<![CDATA[排名]]></O>
<PrivilegeControl/>
<Expand leftParentDefault="false"/>
</C>
<C c="2" r="8" s="1">
<O>
<![CDATA[门店]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="8" s="1">
<O>
<![CDATA[品名]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="8" s="2">
<O>
<![CDATA[商品_门店_单数]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="8" s="2">
<O>
<![CDATA[门店_总_单数]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="8" s="2">
<O>
<![CDATA[商品_总_单数]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="8" s="2">
<O>
<![CDATA[全体_总单数]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="8" s="2">
<O>
<![CDATA[门店购买率]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="8" s="2">
<O>
<![CDATA[全购买率]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$para_viewtype==1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="10" r="8" s="2">
<O>
<![CDATA[差异]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="11" r="8" s="1">
<O>
<![CDATA[得分❓]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="网络报表1">
<JavaScript class="com.fr.js.ReportletHyperlink">
<JavaScript class="com.fr.js.ReportletHyperlink">
<Parameters/>
<TargetFrame>
<![CDATA[_dialog]]></TargetFrame>
<Features width="600" height="400"/>
<ReportletName extendParameters="true" showPI="true">
<![CDATA[/ERP/定制报表/2021/hh_产品星级表_child_info.frm]]></ReportletName>
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
<JavaScript class="com.fr.plugin.mobile.popup.js.MobilePopupHyperlink" pluginID="com.fr.plugin.mobile.popup" plugin-version="10.4.976">
<Parameters/>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<PopupTarget>
<![CDATA[template]]></PopupTarget>
<ReportletName extendParameters="true">
<![CDATA[/ERP/定制报表/2021/hh_产品星级表_child_info.frm]]></ReportletName>
<Style borderType="0" borderColor="-16777216" borderRadius="4.0" bgColor="-1" bgOpacity="1.0" mobileRegularType="auto_height" mobileWidth="95.0" mobileHeight="95.0" padRegularType="auto_height" padWidth="95.0" padHeight="95.0"/>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<CellGUIAttr showAsDefault="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="12" r="8" s="1">
<O>
<![CDATA[差距]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$para_viewtype==0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="1" r="9" s="8">
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
<Expand leftParentDefault="false" left="C10"/>
</C>
<C c="2" r="9" s="8">
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
<![CDATA[L11]]></SortFormula>
</Expand>
</C>
<C c="3" r="9" s="0">
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
<C c="4" r="9" s="2">
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
<C c="5" r="9" s="2">
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
<C c="6" r="9" s="2">
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
<C c="7" r="9" s="2">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=LET(A,单数分门店和品号.select(SHOP,PLUNO=D10),
sum(门店总单数.select(CNT,INARRAY(SHOP,A)>0))
)]]></Attributes>
</O>
<PrivilegeControl/>
<Expand leftParentDefault="false" left="D10"/>
</C>
<C c="8" r="9" s="3">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=E10 / F10]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="9" s="3">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=G10 / H10]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="9" s="3">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I10 - J10]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="10" s="0">
<O t="I">
<![CDATA[1]]></O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=LET(A,&C10, IF(A<=5,'<span style="border-radius: 50%;width: 2.25em;height: 2.25em;display: inline-block;text-align: center;font-size: 1em;line-height: 2.25em;background-color: #900;color: #fff;">'+A+'</span>','<span style="border-radius: 50%;width: 2.25em;height: 2.25em;display: inline-block;text-align: center;font-size: 1em;line-height: 2.25em;background-color:#aaa;color:#fff">'+A+'</span>'))]]></Content>
</Present>
<Expand leftParentDefault="false" left="C10"/>
</C>
<C c="2" r="10" s="9">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=C10]]></Attributes>
</O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="网络报表1">
<JavaScript class="com.fr.js.ReportletHyperlink">
<JavaScript class="com.fr.js.ReportletHyperlink">
<Parameters>
<Parameter>
<Attributes name="para_shop"/>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_dialog]]></TargetFrame>
<Features width="360" height="640"/>
<ReportletName extendParameters="true" showPI="true">
<![CDATA[/ERP/定制报表/2021/hh_产品星级表_child.frm]]></ReportletName>
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
<JavaScript class="com.fr.plugin.mobile.popup.js.MobilePopupHyperlink" pluginID="com.fr.plugin.mobile.popup" plugin-version="10.4.976">
<Parameters>
<Parameter>
<Attributes name="para_shop"/>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<PopupTarget>
<![CDATA[template]]></PopupTarget>
<ReportletName extendParameters="true">
<![CDATA[/ERP/定制报表/2021/hh_产品星级表_child.frm]]></ReportletName>
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
<C c="9" r="10">
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="10">
<PrivilegeControl/>
<Expand/>
</C>
<C c="11" r="10" s="10">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=(1-sum(K10)) * 100]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="12" r="10" s="10">
<O t="I">
<![CDATA[1]]></O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=IF(&C10 > 1,CONCATENATE("+ ",ROUND(ABS(L11-L11[C10:-1]A),2)),"🏆")]]></Content>
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
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Top style="5" color="-1"/>
<Bottom style="5" color="-1"/>
<Left style="5" color="-1"/>
<Right style="5" color="-1"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Top style="5" color="-1"/>
<Bottom style="5" color="-1"/>
<Left style="5" color="-1"/>
<Right style="5" color="-1"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#0]]></Format>
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
<FRFont name="微软雅黑" style="0" size="144" foreground="-236032"/>
<Background name="ColorBackground" color="-1381654"/>
<Border>
<Top style="5" color="-1"/>
<Bottom style="5" color="-1"/>
<Left style="5" color="-1"/>
<Right style="5" color="-1"/>
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
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="SimSun" style="0" size="72" foreground="-16776961" underline="1"/>
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
<![CDATA[gjEa:;qokUaAu7C<)aE^=@#B5<2E#_5X[j?6u#,c'2U`@&/>A6&eu.\;1`lq]Ab:O5:o&a[+:
pq%T`l'$l:oq!IJ3K^53L]AcpW*71j^Zl1F3HYa*92J!I"s@m)X6e\(>[6S`Po$1mHQ8U/fl8
Sf/B\#44sQg'_OMCMsGAQr`*gA^nge[>oVcaabtb'3sVtFH,F4nRZ%&fcK/n%[[kaX[o\%AN
N78kcYr/uIXH@ecKFa?*aV!Mob+J%^50ALWCKC\lI[1C)At5Jj$UYc-N_8^Q8QQ[[`M\b9F@
d\VqNQ7!`ol-BHX08TN+Bn?!de5'DgQ=PhLaLbI.$+d04CQEhiV>W^Rq"^2AT25p_`PaBX0E
6?>q&2o:(a@8>mUJci:;]A%1/P.S%;Y#!F=Dc;!g%mdaQDKe;o)c[5g/881PYI<5I)&)E4<f/
qaA,+'fIp`[`V+dde>"Q&NNQ61E^<4^71bVha2l_YBcUJW.H@%`F\*:o<TPsuQR[9f+TIXbE
ig>ulA,IK7Tp8cDuLMJhnenP]A$-]AV7grq@'fMnb4+/&BYG?gm\miV=jZYD=SKD$U!pOF)-GY
H@*gSLI?/Ge3.Cs(2Rhp:ZOds-j33EnSK%8^@qX`6l(A^(@,#;dFWIW?37ob-gqFV8S7938E
RuKW\,.)Vtj(g7_!Ke.s]AUs(#-1jBt\FJ=a_qV7Q?`Ti,W8VNnKMg>_>Y"9.M`Zu:+/[S&`d
Y*_dT1L*[oAi1;R&Q"qUT'$-dU<qCM6?X$\.DfVd-]AamYG=U1YBm,]ADl)4qo%fPtj0ZSf9]A"
IUm(5<I=eS1>L>OPiq<OM:,*-LF;h,1;MGmbQ3p'Mp\h]At[p#OmliM<!a'QuB:5rR!o9ZqFk
6H(4AGToVfiR;>=B9TsY+i!9'tp;XmnW9k9sG0BZo3$i$t`Zs\;rgA3G&O0[B:j?TcX<HBCG
PpY-mu7jR*O')`2e.^`fJi?)clg0N6/mf'f+)/3fr-C9*UqV9X_=k`\9EWSEL5#;Bou5_!j]A
R2^T*45Bkg0Yj#b2#cu1<K;`8A-%0/+pGQ,i`P3emd^cHr_Won*XKQ3V$cJ!YYjr>g3"eQi^
qr%IDR:7A>`uh1%UTRM<:-$C-rf,CJ#MoNu'(1mQa?==jH/G4k[3YoHN1=nM=fRf",^[)D*1
54B<h49>-J+$e0k&9fX,=gU8AZTg]A5ts"SGZ7.rb]A@)m%ZLR^Dd`]A^$St7hLQYtYa/@jc"e@
+@Q)(c3F8to1r"8p+(L8-c\hYd6;Bot$qQ<6I.PO:2fXU'dQ;@5f?K_;,s*o<e3\q>)XI@R\
U![7*Ht`/db]Ac/FNDcE+j`fMm_fRd8>,b@;&]AKb5ss41^Y&->cN*F\,L<87a22ZY1=J^O#`+
<_T+2M`7#8;s:FddF,$;t#5M'_*T$pss\[<f'GA17#0&J=l`b4`61p7%@cZOK?:d(GUE4@s@
hm=IJ4HABSWEl\H4Q<"hGX(nh$S$=j1*[i@:4Nn`W,(F4@/cj@GA[U3`n>UO:n(1;m5:!+]Aa
qM"l'p#(S)U:rn<gsg<Aj+sp8XtEp7$</(QJlX+&$R9JC-r+j3am9M0\23$&["_O<9O/7JjC
/m*2!fQL@-Ig\SW*o'J0uRia2AOEYBlU[6WZ+GY:V17d#nI2m.=?lM0`L"C3C3i6A"#>G\U+
5\SKX0;319ZqNr<iT4tRt1RfcfF[A_-=>S0#p(^>BX&O2;C3s_"K"1Te]A!(.^*@CM(1RBaDr
[o6eR3)ch:lTnptSCh^*\)::ag7/g'W0MHrloHonAs9>c2,q"R!+DiS2Yi%1JOUEqY"$%R*d
m*o9!>9AR8!nDMk?V/AUoKVK'pe[N%+aC^t&#n]A8,-'r"RsGC.nC>*?Z`aiE,,tQnd*^B=+H
!sDY3,r;&oHe]AVc1Nknsr^2F;N*hSoYq;9-p;ko)f9O!?2[^IR,r6b`]AA)hZj1A0J.mZ8!qu
s7kRk2o%^lP!^uT%qsP1?RUe'a[#i9@JW:l"NhG)^ebQ1]A;Pb$Z`,]A_)C8Vh!GN`o]As).A2n
MmM4^f1RWWu#cYI'JPGNj46m4ugL)K'I$-eU8C4n\,DSA!U99??i3ug44g,\8Y3pI&rmXlD(
*DdM^-ZoHNLc6[;utgOSuSePIjoQs`[`(YUV^`nVOQ`/ZSg"3)>AC6gMkCu@gOrfl+_W18op
7^@LFA1fC-=*&dl8BZoW_0MG[YX>eQ9P'lPi+c't=s^8F/S%+[NLKbqI=e\_`apV,`c,#Q,%
sdi9<_:7V+O&c\5o&EI\a!`*J.EY+-gfi-pbKua/Uo.W2`t:37tRXhY3;mHeX!jTOE7t/j[`
@K7]AO<of0d2`%0fuC;7Bq?Z<L5[b^NPCH[M[SK%)Rodt$Q%H>6EFfWVWR6$IcT&K>"'&r`,+
AgI6rJL&aYYBbu5ghef0nOBI8r<b>7>UhjT[$]AiAP3r>jJ'bgjcm/\,^llKeOQU+M'<@"P\)
_MFk:#WY.6e)5d)N\j`s.5'%g38qFrSa?]A#I3%c(q'#ls$e9PiJBTk*5:pe%/mQ#'CLL.pp>
@e1/6foP1p#PbX/TF&]ANl^Q1kV=YYa%X&:X#r)bC(lR>.M@@TXcJ`UnQZj*)h3sB-S*esIaL
bbG,A-5]A27g_YPs/2,Hi(VkAQ/mX%GkWl\-:?+Hk>=a-#.OW-=QZm7bg3!-1%pg&F6^8(V76
4G]AXOt62;*>Ge9!iLM@qm?t.?V/b8Y/J>BA8p+AL7gAnrng1,u!Z''jNJ=A.1%E2Dk7mhoAa
6t$BJ9DSL&pLA[<N\C2*m(oal#drYT2GMS7@&O-<*UZ>H7gFa?@41u%qZ4)W#,(1L?90\Q+6
P[<]Ah@?38^'7`(naP=n`:hTpq6U?YE06k^<L^L)Np)M[!Y:WKF;^^,E"3W&1MD@JQ%0mHXRI
BHPHsEbe[Glr!n9A.*Y9H<I&n>&kd3WapEj"JPZo)6=/dXP"?dHJs9Y7V$0nV0%1AZ/MQs>G
#s"d(D*,Woneg'k)u_5!Ld'Ug$N@BAPF0#o+ZiY/Y[?8FA2VdE(ieN3G+6nN6gW&mte\#MO"
%BHW=5qo]ArJOAu'+JlT_:JD0R[#_PH;`$$q/`pVTsbkrl1I:Io/$D@0qlc$l*`"_(;i[CA*@
u60"U[JtCb%=0dM+7QGY&1N7l+,45=@?4$TX8Y8.cOF"&(@\Sf==\[QJDEZ]AML=(1Ih&;(^k
9QS'r,B1H6+]A.p+WJFCCt4Zpsn8m`rDJO,a,)<1t@u3uu)r/MXg6gr!ZnI,(N7O*YIMmjIKY
_)GR3T>jM>K,Z#AIN#6<,O4N+`0Q<ZXSi^`(!-]Aa&U,FEO$'qZd=u*`2D$<h>^"a]AC'!&_3P
_(`2?-A&:'<_L"'!Bq^"#E=klk>VD4?)h)C;F5LFD#18JsrF0M(?c^JX&]ALmKl)2jR[E;'*H
qT<WQZX,dt-7,L9L59K&6aY#hk5K0QgVIq@biiu=dg0t"HF7m.S,N.@=I=ujKU$B^MQpUD7g
KEnnpi@>`$)O(!:$5^BK\%RtAZ8Vpe6,ah-Q+dCG65C@3Vc@S_1bKiTE"j7<MI(5`69_4(A2
-Yf2dRAZ1Eb6><Oe)j,p<X_Qs`#p1CD+%';%\j;qgI8e@^0$X=@J1PRLF(o(54?;/J0]A["(`
U,H0Ojb/OUkuCD,Z*>om"tDg5\J,1M=sjG3r^_g4h1XT4?/P=C+LjF1Hs'8#cYRFqkJm^=%t
6k*A+L]AYWfurqU\2n)2/[1247Pa!l]A/.jN47BlS;82<gWuHeocbm2;@sOPplW]AO'Amm.F[p<
YhHf.0-EIURZrbt'YL;*t@]Ar2smNPD&I_j<b5aSKG97.[5@b)dhJ62%T`fF]Ak"aU:#C!8\,0
@_s,\3%?5YO"sfe)['>aA8L!M&q2s#`Q`Y(sZg]ALTZ\KPRY1bfT3mq7h^Zkl50u'\3</ShY;
VIVA"JXQ,*9?"AgD=)uQBSC<j(Kf+OLt`gY()2bN'qC,H&^.u/sqV0@(rVe:o(KCB]AAbDhL]A
^n1TjceZ?2.'[EFW[#3Mds<.q-1dr<QFee4\U9I'o87TdnG6$3cL.'rIE?WWWN=s[gP4k,X4
WLA?!L,hnCL60"d?K*g$>$54cTXpQopXhS<$Iti&?]AN@0iK)$PA/WYm_NgPVU.fdd+R"TgeR
GHkM+(XoYdc?8C>D&1/r:r49mFZ,Bte[?mu:X8Ra^Dlb@%2Q&+PKUVdni4`Hj>nXp0/i2=?!
5ur5%,.RWJis2HfthI_+VQ6C0EFgH`;Bip3Lq8SIO(-a0TmFn@9-@OKuEu:@eRJjn+NijX,b
niHT*%i$L9pL$^PH>]A*ZI^[ET5#*Ndt^rm1.Mc"a[MpAnYfWqhW(r*m#Vb\"PPZ?C!3_5^l,
KktmP$*NJOoF/GiBmMA9rOac,N,4BERVgP`#Z0fCX:on7AjTBbB!hACj,IStBH;/s9snlFrO
^sg@YC+]AKmhmQCT-51ddU4i9?s2!X^NSQGE_Wk6ZDr[J+Fu?Q]AGiW<Mdcr<Sn>#!'VB=]A5PH
\1POq.`gZ.]Abs4fR#qu'1dgN@9pdOo+gL5PdNr*ogN5K_JD/j,.*Na%EP4aYh=qti.YdsFc)
pMi!=Z*_%CqH9V\rgR>?f5ul'(5k"@WD+Kq5'%I0]ALZN^Bd*k!Sng=8ln!eG>i6u'li0?A_i
jKl/Wu8?t(UZEgc<+8k*mcWsn/mPf3<*BiC>ENh,Ea6,c%N"\!h)cE>sMnTE<ZOGIELJ`id!
>7>/O_8X8k/S\s$<iq'2R!>.k@$6;UZ!_D;hiW1eb2INXK=8CS@($5\9#e>iANeH3X`mXVQh
7mc*#uMnF7XD+Y2TW/[d!t+p`Jj*QAkY=q^guph]A;$Y/1,CCKc=:86G<G-%+k+N(%HKB.3aC
p9%^1eq#-@6Zq%o.>0j=#-!Il(NWg25+&C1rId).=.K/9n/7i9EIq,nOJPuliedj`u=n4&l#
?p/r;DE-j^$<8g?%<:ngV8O,h[,h(LSUc(nK%eD\;SF)?am#^7`4>m3rmG@&BsFSo:g_1'r0
lGhUEJfPm>u(`\$8i@C?]AWnp%Tl[2-1=-/BSQVjcGCQ_+G"UhC/@!PWs-1dNIjF)u=1kmPD^
-0`%]A;$:BWF>PGs`Os]A8ooQj"!\q_IQ_iS\U3'G<2O@!>_O3sTNYMD-Jp#-$bL+Q9FdOeaoA
<6A4Yt]AmU[9jh.!lC#`cu>"4>HAVX)61F=iLhf+CXK&e2heA?9_u8Y2PDoH?;[*8H^-N<8.7
ABB>l>0hmj/$9\L#^<^Xo!=')2j<pBBTlJp7!uPMp/R5t;[O3_oW)`EVl9Kt9]Al8sT3?p;Q3
aES'`Fn(T^M?u$82(@`*Li4$+Bpkb+N>D)[;X()l+r0Cl8IsUiAfF))'"&Jd>pn/"gN"tW[*
VpABaLYnI:(Vb`9MY6c@0U'CO6>"gX]A2(+%-@S:N+SpQjRnEb0^8#6?f_MkVd`_u25EG0-eU
HpBi:2&Pmp=(bA]AF)'7>flF4#/o^2jUmtJH?esPRjHs,n:h$XNF_7HZO_1tNS>e0Op7OCDk5
2aebBu<oYng#Q5%^c!V2V'C81jKog]A8jWP;8k_q6VcPWYo<:;LkG\doX%&ZfRrsj%R:U=mNa
/6kd&1EYC7@?D/185k6d%aM'@-m=*QrhQ0m:5P]AA^[??je/>njmMP"1bPoVCLOU=:11iA\(!
2^Vddf3ed6h1PX(SH/T:sJi.s-u.&lo/>a4g@_a/d/@YhG[-n#FE(d4*n#N"ffjW"DD(8*jX
&3N]AVkmoK&LEoo>7q1MFZKR3nLIr]A6,krA>)N9SA%LD&WR=?mjp\$8dfr.9*(W/E3UV=KT<7
N`;#`5gI"A1g&_&;peoRkj=k-4U/<Pj]AN1AVAX0ZX?">PE,6+B+XOSH-@XZr1>(/Dd4;qe=O
Lj8=)kAJ+h>kIPe!K]Anci[iMR!bfSp6gp\sQkqT9Xh>'!'im,<1g5;X0$Epj7_fBu=2[,_'_
JhCnbBPZ(DAIr27!h0iMBB@nE,[%[o;l!aL#NehZNFPMK<+E_bQ(m!(`i`amrV#NHP.3q"6;
&l'sqm;)&b%Q+CoMq+U]AP!^,5Jo8MIa;)TV+nua@p?e]Aoer4;<1_QMiQ,1OF#=-@ED0Y@6R[
oH%Lq=a3e-L=rp2S^iai_`_^@SSb5L1A.U&F@)>R_^,B*3DhDg`KjQG)WY$kSb0*IFa1+0"R
h/_%.qSoVs([t:cg6D@H&.[OZ%m(XD>lu\(`Z90o2>"_IIi8P3Mb;X.?Y'5[GL;S?>XENHS-
gM(H-0^;-E.G@Cj`puS&UBQPnkM)p?AlXDrAL.]A]AQU[6N1QC4%@L,N,>JYar=OB&0n8`n$m5
\Y]AB,#O6o]A<ACsh0s3]A"EZ^!S736Tqk"X/2ld"Am0ak80Z1\Wc\_N%QPG9M*nb>(K#C#ZiJD
6s#e8Z&C@$:i6ok2;d?-bM]Ab78"E=Tcn-b6I3Hp^1?BdBqLGT(G!]Ae07;nh9.)5=><W90'0<
4Rqmh8a:r?]A>jGD`ZrpeLjLHSU(mLr7;'%''p(G_?Ti9c\FT]At"8>h&ZngRtrM(H\_91&%cH
U09?[Ap\q.q4?EaRbOH<UkU/-?_TLJ-I`=hp[6>9:eo+h?(\a$@-7A\;[d!f&,M5V#JVR]A?h
\;n1$i%Ym;6gbjo9$Wa;jEGD<JFsja:8L3rd'M\AA&`Po9C^nsf"%0&'*Mh0@&UGNq]A"Eo;i
9`A40hcc>aNJXbh&G29-;_5;g1Xd6lHHPA#,(PaP-qR&2oNdQp&Od,BgkU1#_0(#&_1j(3a(
@h?^b,4YEH'Mh>UDVfQ8kR/s$S\o6e::7E&kTTQp\`15S3i0S]AF&o)*Uck\^04=cmb#i/Q7S
"&%5f>d9nu)EY8.6nUj!pq**\!]A8JbGYK9p?)ZR*_f;gEi1p5*H_6H*X?!#g5`mcF#Z31T(I
;GCFYMP&[cNbGFkZr2`AA8C_(a1/6kVWJbgYh#B<[?KQ@a4o%]ApT+p\YK>crid+t1D8sBYHi
7eml">m]AnBd[fju!`*rOU)JlJjRWDC7^5_:JiK__bUJ[.PN2SGhF6rIq&]A:stQ@T;W?XJ?B'
HX#OR/[i3A0B[e+7#+[=eiDp#M%p0gkKXHAVr70K5'fPQ=nA5<ZiJi`=pZd&m:iNqffNiR0Z
/UBM%leGHFl_mAUuR[9rTZG07/>GG*``7O?>r\B/YB]Ahpp+&EP[cqPe>&YJme]A8-BJJ7ND.Q
'&7?sIA\$LY!BkTC#okN51VTS&rl9I.9Ub+R:Qr<p^@hq-T:cJmgfZ&k6B]AKE?=eW\8e6Et8
"C9RO;CNRWgh5Dj@HrK_,/47W^20BBX?Wt^op@MaYN=!<D)X`*Hb&'/Is4<cGh3AEFXD?OZe
A1Gg@fXMZ67/`jJo9Lr6D;aQDs:3.p8HNo6MeU#M]A<fa6,F(D3=grG^'.M/T%JIe`c1M]A=f\
^kckcj_u"b86M-5q/5-8r(<(,Bp[[R)=rBL5fQAGXl<H*jW5ZEc.oJ&I)YS*5EP.^E!&JWNa
I;i)h/tTo>2V9oiu;Dl5FUi_mkY-raU]A;5!I*^Rh+j/<SaL$V57"jl,1Pq-Yq98oaTf.p<QZ
$<Z8!>I,3W&E`0:JM[)3DKkLJZ$QU,]A\<S-Fmg]A*@ZX7l>!rOcL66>UYd7sDUeiZt_oo4`R/
RrnoWl[6AD@nZJ:q"O@%&Ppt;Q1h*`TX#a$\_kAt>2llLs!B^<Gf?@iNc`<YGg%#I9Oh"W`5
-?2$Vd#^(Tg"tfe)qZ]AtjLMWbrBu<aK&DfMlcnaL?>m/kZa>GA$a6K2!f]A!aLe2&SYV,_Si;
2d_4Ml>o8^32\X9m8"(B?g`Yb9EnKfb&*u`c.`6^pZlXTl^b;WXmK-sb!d2-!^i)?R..qFl]A
24f=V--efA_]A_VbXo^G`'$Xae=b^3TQ1b/f!k^8jHRTIi6,eRe',#"0.u;895#4n(uCjY8Q0
b9d$'tX7VFO#)^2doJU;c_[Of?6C>HU2c/W7<kr$jugrRqiQC3MA.MJ$?K&&)0fpJI^h*HL^
V8M;P\dku(]AG7p6^C0;n!Z$V6PuYKL"r[D@9fmJp!P:P`IO6`eOr_Vblo7jW+F"s=g9(cLTe
N^W>1A195pVo'S/o:U_^?;bMNS?bRqX*D50@8'[psF!V5I1t%1J?/;!<F<:04`h;rUI?X'Sf
4l#OFV51#g%@Y2mfZG,)E[@%;2m1NOO!GJ"$I=$O4D^b%?SLn6+6FamdTjU+5OJOk.2%$ZC`
r^t/[kc@JdVrlWM@4l\FB[AS<`<Bg1tfM69L./Jc:1YdAeNYBTm8k=)V&7\:U9C_cK1_GkLV
U%>=D/?ePcOfqC.(20c,;5;t5:'nWIm1m"3$nTXW-`G8Up.`VgV==A7tt/p@nphd$&XBp<IM
TRGS1!ScB(;c0ZhYjr*3<t=c@V_>t]Ag,d[;O]A^JND?oi?f8cu=GK2%Dnf<N^<\W5@1[5>79Y
0F$RTol'HsO^=>?m=gbR`&o\GLCT-oXP-_E%[ko8(L([XNXZ>('POPcZN^Ys28)\9mY[6rPL
k)j\Xkfhcic+H6m)g##*.6'^^X9V41R2d@AD#krZn%[YU(B&E;qYjK+4bqgX+F,a]A_mAl?=3
=E$T=V2R;L]AV-pO&;ff_+)aO`>";a?38$WLEBtB(FhcD9^t;lQ0sa(P='ZW6H6sfNRQ*)M5;
Nr8/:"L&q&%ehWTA_dN*b@H,$o]AIAo<G&U+D2g8kT2QQKIsE>0W1Mk/>5e$Z@UC)&V,!a$nf
Mjnibg<+Qmk*<Rb21#"Q#niJ@3GPC_S>`tW*c0ubX?CaGbMETL*Ptr+Wm-srLj,bIPb([mi6
=XuM#mPsRZ[2m;9W!dqg$VTEP)<Uo'1EDElNF_bD*.GQNGK/"e"7,HJL4[@ZZcE?/MP_/FcV
,`#5RCoENVV2p4B]Aoei;6]A.!?NpX&H*qMu545lok-S7gsVLZ2(jla',mKPp`;M]ADWS!Va;b&
/\O!EcgAh93?D,5"jBD#LTEjNR%3O-Yu!pVX2kAYfOLFg3uj]A34Wk!7eD-O\mq\j6jg+i\A;
!dL+Sh#$-21_*n]A#@fc$X++;OhD^1@ETYE9Mr3[><A@9O%TR=5ro7FJm'[<$I%J='&uqCA#O
M<j_mUs)F?-tDp,,*EH1>m5o^RnLOu6q/Lo(]A^Ur^_$)cW3?(j<Re#eZ,S586k/g[]A*DftG-
]A6fQul/=9+L-Hj@2Y>%Ba9eS?/<s?R+L:dU4,'@.(31,G@\_h.t3,\2Lr`d<6@R(]Aiuu`id]A
f[?\B/9;\mGA+ZeLftJhF<:=BsS6]AqQ7pr_d(I^Z_BMQ4)cJQus&6,<@qNG&t\d4*nWUBj_F
]AG3ia[SqQB(:[NYlf8Y/4!"W&fn:2Npb*M=#P3i4>bM&5E:<$es/^Hgg9Z<&%S+n-+EUJR#!
V3CA4d2:bBcd#munlMUQ+B6XSl`MKj'#Jpkpl@$7gBIrYGJ@Nd'`hc#f.E-K<m@k_I=Ft1@O
(aBhWYF%i&8<ZF8.(@t)6iolMah'!,)n<M/a`tt<!:p4\bU^.9Z\>`g6:9`=%-$t"rH2hai,
`YPA^4Xh@fqD)gPG?tcuWbCJpP5eKdPjm"J!p/djA"2P<nNSWq"srp?T@F*i7^T"JC5mB<:&
p=+"HTSNiYANomFJCIO1cI)"[cUZ[4o=>"A*I,0p?YH9999Qdf.f^4n<.Pki`A\o9VU2X$Ps
!U@arI4KqW\a-(:))aip#T6FnZk,3fP\e#BE&(5-UY0m<$PIP:MMtT!sh2A%k]A=E1O]AP3Y<Q
YVI%'>Cm7FK5RnZ[hb#U2PW9CG)91sVg`"-^jeanP5he9&2l:]A]ALm</EuLKRq5Lq/?l-S!XW
B,_E%]AO4/T%0]AF(:?CiP#SXf6%\Cj#*E7B$R?9it`$^dtj%&F*W>.[%'L%PWS4Z&kWMU'%cP
OsFn;0PlO.FX/s$=]A8$jr6QmDLW4V9H=1oi/-MP>I[AV:#RdPIBeLr^+k9("CtALk$T*WDV+
\"_oojk/%2tjt='Rjfq0oo@i^RDg0r<*_W%D0C5fS6pTu4X.R-oFa-$EkujU&]A<6X,WE2m.a
TGHj[jb-oaN7@>-?d%l#]A/7DkEZ;ViPmjlkr='[:FU05@lr_6,)!nH,QF!Vmp3@&S<$0VKQ0
p?9XV.qC#<@P(I&%jHfg=`W/isjoQtB_)I-f;>uVGrIc'a/e1rZibO'+CJM'FgollHDa_QD(
!h^Xl1F9"GRb)S,M5Y-l,V0k9X&sNb&?mQ4,^JDN+[RI`\Db4>Xc$."hMDsAKQS_(hG/&L-i
Os-_RX2i&)D_jed,[+lh,*?k_dGt4K47D3]AudS1Lp@nd^uj8gQIW?qa.FWUYM^,gg;^[Q2+.
:K,j$6blO,<=)6EBgj_5+e*DO8nZ-?b/CbgIQ(=9s1*U0&5s6Y!2Z@c,JlsoGl-qO9p8R6+A
\MN$XLqPH!DW3$0mW4f]AO"=o,2Z*DkmM(hjnCYZk4*,OW#da8HdDM9s4*]A`mO'UqLY))aq=T
Y0HOY>)lig%EVQ0X;U>8U#R1aBfAQ+^6qRskBg.C+f,?[e!5C>67g:U5WY1T/.0-,[W6'm08
eF#<'Op=A,0(>&C)\bf'H+Z1!LU;EfZDMbYDk?I>:?9:NGr.04:#_"&n-`59P^DitG0D+U4^
r*%r+sDpai;.j'4gR:La/m^7S0!\OI8n^&'CEr'BEM[5hANg.`PslXhgk&+?s4(L!'bdNO$,
)jKc5c*Ql;#?o<)umk!h2QkRK`X0qSb[`U=c0#^f^m&B/H90Bst+kWp#98"[+Zg<LC6Z,-Cr
BQFn/F*\Q_j3)XW-L&T;sDD:69&&%SGOLei;)slc^egXoX4p>I,SojIMC:$%\,2joEGt0,rD
mhWe<XuOAd>_4PBB3T<iBq_;=l_hOUX1<&+95;dm)gU"[Ke+,rT?-%#[G8VU0\2,?-Oanj?q
O02V6_tQ@PGG7%Q3Q:PU''I0DgK\[JZ\J6(p!M#$[E5nT]At.\2ZpcmE)rC7,?i,:Eg"i+Ff*
sR>4lMu.Z1%Fg*?oFR*-nWoamI^VfR]A+Z_\c(U4rE%Gq]AO_#bem>S$dDfC&e$rO'<'$IYI]Aj
/YZK]AIdf^YSO>1M%P=)=U9tMI8F"S<$OSX*D_]AqY:8otpfb)upDqCPuqpX.o?qfT"U#->Fia
hGD-3R8T"(`>4u0?&7*hb[HmLhAWlYq,b2'\cs0)<GLgcn_dqR50o!mu_YS$Vr]A^W#cW=h)Q
0U*5#CAEUs5dJT*$;>ihQ1TNkb@F0_RdN4&LCbC8oZW1d#eBu^?W$Mu+,)Cs,I1kNA!:&nLU
+13ZD![s@7^93A$,g%+jF5Nm@cL&2CM9B\U8rH[@=KXa(>+REiD(9K,;oa2R/b_lZ@nu3u1A
5#j.Fh@6E&#uWbX[)EZ?V5$d@'q'B*bl?T1O'7(Xm>MJGMV'G+2C=GLS?5=D!L-eV.:lEgQa
<j!Wh>1PeJ!bS0VP.>e`C?*<AXj5rM1G=QAlK7;oc)%eOk8KWqqNRNF'%r"^pHJDh4hFml_:
8c\Sd]Aom0ppI\$.a"Q'f\=2[a>G3c)$0CPW%)6\XS*d(j9"fZMlJN*<62]A!P"jmqU%"WFn]AE
Zs;&;^@H%FC1=UfFGkYi.;h\/jupC#,.asF8jg9a>JIn>kEjH80YSpuDb,4U@kXO'aG=!K$H
G[C%@Qj@(P`-24X'O0I:r0K&ff0;\p:ih)1j-(J+U>M.e$f7-5r+'p>JHn\_'HQJ6B`e"B4F
F1-`>!uBbcUEUnnJ8N:3,L*elXTH.iXrSG/cA0hUDGVTFSA/:$sp<43X.-;T@Ckp:1V"K#DT
$s$:9#,PfA``EUL%(4uTdfBRk]AW=sQ5E?%,XW&d8:r8I%b%iK,1hNq^Q3Zk^a!D>HAd+%bU5
.$T'9^V?9(eYIbQZLOY-&Mh19"*aYPtk:u6@G"p?Z!E=>k0W#@V:oOFs=huFgh3%3'DIbe-<
%#GNd:#K>eXbJ=J,B>tr'SGt;-f#76BooYo(lg7l81-f5T0[&q=\X&iK$lOMT=LfSj7)P6I"
UABR0CVN5YF/%uGW<G1;&EJhWhXTF)b[W=L(qrhr->UgE(X!IJlC*i_]AC[>J'X%G_#lJT\n5
`NXc`PgcX*H4^^#&6MlNGs1BreWp)a7%s1olA=8(ZAF@D3H,VO?`5UfSVr6'UmHC?)@e/1Jt
-\X4cg@r5eIfWmjB(a`X5=9C-^k+PZ1ouFOmJ@n[m&c/gRDIsma]Ab]Ah_<Mj<,>WfIiB'QCW-
Mt#XOY2KHHi/?VAQ#NkH8A9'2MLn>#sTRGfD1DuhJWAi6AQpdOgK=#!pJ@/"uFKtqAi2+R#"
sp)70(>rQ)5$LKM5t#'rJCGfDb8^NW5Rh77RRIFm(7rR68<+8JgfL.9Lidk5*Hi8lGtgbdYR
6nE@/WL9l7G=:]A@k5ZeNNVoe"VjKt&;t8LO1`!(214F1>Th<c@(8+Wp2rd`4dh-.Zm#K+E=-
J4se_*G;oRP3MpX8R0J^t\ngAa\f;ioM&M5M'm#t"$D5kbqaRs=:J$OX(oJ6VH-#;3a+:4=R
M@p$RBbGpQ^:EDgDP_J[*-GU,2TGUK,0!Q#8B4r=M(BRnqfHq_sN&V&/e#,UU-#Y>mSM\<%(
+#uoiW^fV]AgKcpH6!86b9EQj[I'[Frn[VJbl-)R[IZS3JBbh'N(,1%(nETX"\i4&Am(,!$c>
$h0]AV=?Jt6^.b;Isa[EZ)Y,-0VTX&e?@kTMJl1)b#)9'&h&AB1E$($BW>Q*FhJUIi\QVDm.;
D18_7`#Y5J%\o2";-!Y]A$Q[>k+D\<iYFZPlbGi&N+;f2n$8W0""Z@m@+uEU-6eN%Ag%qeBUS
_*0^WK:-,7bhu<I-`e@18"4SC4lH6EW!24>giom/1Uh2/O-`ihng>Dppj-1IBV)^G%9QAc[K
]AU9Q48En0bMf&Qg*jQ-.plfgW!DADgC:LlVCLk0N3]A4oDIeM&5/0Z$L-`;KoXoaC-snDmAfV
J8:nhkqX?bJ1a[HaE;s46q3?Zg3KVerPea,P?a'q$m2A-mP/V<D)T+'*i%_Mb/hOR`Wk3H]AF
dufSLo4NN*DMTkf:?%>4"F-*f:YKP01:62KWXjUL^tI`.q?Wq>lLC`aZ?n1+B?dKt:SN9#uK
&KXLdD*YV/-T"ps0(JlrgsR1(q2[<H0DPfn`$^F@^;EHKrKb`3-Xn^`]ACrnf$A/\^81QcM(F
d&lD0K]AhJGL<NB+dDkG2B@kVJ'[iKe((6cakt<]Al`@#'rlGRf1B/m.ZT06I"^#S@bq0Q@!/)
!%.XHY[$:_/LR4uVgn6NUr*2=s4k?,YhuM(aAahm)]Ak1I>)*g%i.$N_)kf)/l:5^u]A/j#221
V0+*i2$nJl4O&_"X/#`DopN\2\aWkpqJNPq/r.AA9"MJNoZ01+(ZrMhCPjI:*Y;Ua]AbQ/-;F
P7jD)fGr]A)fY0CaiVS@7m/k$Y@,Rpt\AqR1cJ*Rf'b4jd3qjAcPU3,iFC7f"GO!M>(\T>OS^
JSZ=)4<F\21+TG@!Xh"t$HQ]A<oPU>"(!PqRHuUYJ^t"OWoJMberg9CnV6p3-A18FgjG:fr'K
\1""rL=#iBiKVqT5e9idrN7=nG0(<kQt.HqhdV'UE2EML_jtA0=2^F-'M6YiYoXpb5SkkUGl
r$4.3KdG4L/G)V=V,j&**#h^&Qn7`l<i'=5.Z8NN]Ap\[^rkX,Np(htXBjC,P1RX/cZ-8P=f4
Mtaf)t:<uFtip8*,AqTFhnt[!XoOk(l`TJ+lYipGf#mV7gS98^_gXcQ.+AA";BE6=3._1*;G
tcnZ4^"(0o2-Jns-Fruo0+=%cb@4cE=&8g(G<Vku"R"5!?uqli,N851Sm;!*%3^RsgE(F:Se
]A[u_dB/tHg4[gsYbuM`h7CRBFX#M<dNWf6XJRHZ3Z*iKU.'?/K=cBDHYWOjaCt`8.E+h3%7j
jY9.[ubBQ<Acb+SJDZdrU0D\SLJ#YQ(.K?7'Fe<JP@!*,WJI%]AF:'gelP.3NR7-5MY=VbI2m
FM^QVRheW"*'_TIdlqnL)W=41R)l\(e^picY$,F<Fn5tq=X!tQAk,hE!4M8=ZD'c86b)Xaf]A
G%h#D=b[fm$;]A[?4Tk!$H'SK1h:X=19^Z$dN[c.0)b7-L;pRM&^dGf'.L7$R880oZFI*qF[@
Ua:X,g;jIOW.$gO:3/2"(YijKco"9,rBr+1SYR-o'RaA_,Oj)Flg@-rI@SGk/%D^J^o4(j$Y
f)4S"`p^M=lc7\=jlZDQ]AVR[aj1b'8@d_pa4h@,@lcRH/]Ah%;5>rqM')qUoFZ4_$)IsuG8eJ
n#-%t[#uZs@;tE(KHd`m,:Xijt3Lk&Bu8GLM%Xe8JSsQG+UVlp!\,r8A0(Y"OOd20=9Hk6aE
kEH/\?&VfcOs*U7fk3jlW^AJEmHjuK3XcF@9s4_lir\o#9Lrs8Picb9'"Ld/cY,Bk[hKILer
)F'inEda<X%(=p3HO55I!lQ6B[<k0rOYJ2-kRf&*D+D5,),>O<N:u4S.C""pNUg?A"He:qRn
Ke1@M_(G(l/M.a)kqeZVCAl1T/[ds'^Z/oNfJ.S\hWjZ'm1p>B;9)qg&fP^hN):/-OFjT$+h
co9@^O/"V(gXD8Z*#,t6+O<@F<7K*R_J62;denT>`Oa+HN#XW?q;Vi/)g\oI^Gs"`at1<ub%
dPbJ&Q>Bc6@U7HmE,2nn5ac^>Q2D/'_3!PoFG-<1)Y#/tRUa05N\g-FuCrZSVPl+q%cX3inO
,DWD9&4a"g65h&ei@_Tn-aIBKBGfjt;Z,@7bY"KH4U8^9\LMC4Fk1-B)r123:>-A@eUlb&6?
Fa!%-;D,@p/V)VB/UKefefO18Vnrd/"l7X-[DCCg!aM8#kM\9cVipLoTBf>Cem#XgAOQ/"$"
#6Gk*st\b=P>n&G;nCUUW202iA(L^@V\&^m@5$:-e=b!.,p>t]A$o&)-\`$k6@]ALb,fD[6h_o
jl<*,UL3*.b38kCQ>4>%YhF!_;u484n?u4o\6R^dN]AhfGmhWUg[gmi:E\kGfB.>)V7HUZd0"
^(#^5:;a,75KjHh0g#3\Xtsk>pY82Rl!ICOcAX94Jd8O4LMrh0b_t\r'3srSC_4bI`b>e2li
jIe8eAM#;/ag16offfJl2Ap9emp7I;,7,a=>Si/9`m8@^NBFCY_:SI@!1Lulemo8F8AbIE++
pEDp4@822qL"B-\#7`=Z$47-l-*7>Xi_jUamkDLVSg]AI4\"]Al2<``c7"N@7Yu>X#WCCX/-Rm
jUEYi`9.ugP3MOiJ)T0he2a,n`+As-"dL0rfUQK@CaqWt&pGSQsoI@;_327P)"S+;ksq6iSh
hc`b"[F6m"7Lc7=1,GpG5$Z28Ni[JR)RqiY0)!661Y]A4p_5Ad&)Vuk0,'.8,O%h!Cfp#E6ft
$,KjU7-BOr!IfeF(6G.e_rQ8D2gYrVtS1'35]A2X]Aip#R89$g1CA0481`!)"SVV]A("M]A^XM%M
&=IAS\>uUuoIoil96i*3I^(0gQOM2l9gMTf%%k`27Q*l<ISup78Le>->jOeSr9D4dc;]Aa%/M
-;jA[<H/"h?>7KWq?-S'et2U)TW8S3[1t^AqOq6)7u=E(p+XkaG&RBKQOiQc,np=dj32G!@4
XBi-4iG+oW=cP1"8#GVLp?DVTN$%.+2'C*5(]A.#L:3&'3bOH(1j4Ju0$Ei]AX?Ke<aorgb)S:
#D#[SFPKcM)TkJeDVUA3m;0V_M2iP7Z<Td+m5bpEV8o<J.p$<e(YMV[2YT;k>=tZAL,"3UqK
Wt*1YsnHfrCJsht_a?@i\e:5s]ALnD1cVpAPVItM7s4g7f@NVmaL\^GqY)q9=#f1dRFnWepu6
fjOiElou.8njs/1E:UXWp>5s=Zhs?#1m<N1MAGEIW7jkUZ"LTk`pXiDS*ueunhH$n@Dt(rR@
oB'`rA\8$Nrgb:a!LbNd.ZBpRU'XKk/q^E8hOm>!k8KSU>kG@N#=>Cb0))Kk5,gt6PO*@b<f
P4Q0\P`HWM_10YTs#'$mKc9VK@p%#p,iN.^`<HVYGJjh*k@KI/gd[B0%j0d;3q`\Z>:HPB`.
(4tRbR[EP+SAm=S#>'g=peG\[Rjs:%N\b3`AJ@GVWDBcTRnEXPIu)(o3b@M;c<4_8buZ>=9;
*,k"p`/FnPIXkO;<8TdJep@e-Cb82W%L.W+;+eVlLGh%3W=rGi*RJ%nJRWkhrhTE.X4Ihp:J
6Q1>3j2W/P5,X57F*#h4X<uoO[2b)lkf</9P%G405$\Q+OSogG;s&uSPG/*aL8+f2Oj+BJ3>
KJrj[@Sc@-F\`!oSd#FqBUf0fU!#FX\*3e2r9!H3@=h1;_XAc!c"mDp^DlI<U)Y1OEmd4&Su
D-*gC,"U71q=[%Ns=D8)[p>)?gZcO!ST,J7KbUGbVE0`!aO7mC$0X*V$C\gFVhRG'AOk_oMj
m4t)aZ()T*3As;bK\ADP]A(Vq44WJC_ieT(6H1+h@b""Lj=X>@/pU/C[$!l!TQmd0E#j7U)^4
rXjC&Pot3n`J@-!ibS\6,t;7C:3I#H1Wl8b#<oF\J*FPcASTG,'uiMQ(O3]A`]A;5&^R/F+JH4
'Ga[(H>bLo(U:[nZeAK3??X'Cqjr]A"%B8#>ijB7q%<]A"!$>j_*,%g0`35s"):XQ6H?*MT+.8
"/fgMHX5;#%EiMSQ"t-)M?L^ZfG`jP7(Mm,"`EtF4jiF[>(pXDJ&_aXR:OUVMVueF7<XtqP&
es;Ri+W",/>A]Ar=O!c?@rtPm++ubG4J>*nP@!8Wd8K.BSNCeT.0[qY>CA6%KsPS=5sBJ@_H[
+e1GJTB)=s\DHgOM>=$_+"*>=Su#*969b[/D47L&E7?G2dkZEO0)]APKWJUW/>sB;JbQd1bKN
dR*b+e:mo+%[1b1#;XC5res]A8Kb7Ic.++^p1BJDe<4L&8%dW7cN:"SBHi;$!"/s0olD'MN.u
r%jg=E@E*!pO]A-cbLnN&S-m@CP\^fgUnB?SAI)gsGi,VMhhc]AF%HqlB#@=[gaU*uZ^rJ]A,&e
SWoE0>,j-1%X3`%Qt\P4'8?UH)DtYZtX&#53qdf;8T$Qf77<d_0)UJ"B0?7[9'Ij8!S7/Z,b
O\P.6rFXVBh@rd3g/mGiH&f*uCU?$Shb8!WC@_\uLc.#RiZ$6=rD-Kj]AMTM/]A+Fkk!>,UWj?
/U9:8$frIK;o)X><30o8nNB:/Wu%m3$"))7p:]AA7&d=B"EK304"J<ame:L_OB%1#)dhn5=%=
q:8='#Mu5T:0Le8j2fok;qB'7-B(Fn0RJTHMFgA3EWDn;f7Lp<9oq.5Won&2)(%M.o#`Di)R
qJ*5+L]AYKNIU;5-;5Xm,B^6>R'\TA74;4D,+GG!raYmXktpu\5ec4NeiSX%Mb,:_t5)NDm*j
?Hc)@@Abc%i23LY4Gl6C]A*&[bNeRb8!4jF)A4<K<#h"OB$MhFb3Aqgg8)W*a*sCQNE]A+#pb<
3",7ho_7\T0`+Tlg,Q3=gW-@M?J6i\UWc]A_KdF%]ABojT`Fk4ChWD1oi(jYRn,Y)>Qd6?tTn-
&Cm!&^%h*hr!3r?/2(&H=J3*Gif-5+NNB9Q%7\oDD]A\EYa_1']A3]A04?SYo*UYjUsc)IOK_LV
)FpZXOM4>VK9rPiTFD\+Nf5qXi^rO'>AeZG^`A]AQoM89rGn+,)0PB/K!>M*eq%t1/2PMkjP,
3\PdXQDXtJ`p'J6`G;I.prAg(#'M(-8oM)h-?OOBnc+Wt,:\K>Tid<h#gE1/>j@F6ss(p-^f
[DMURp*NUWPMs-^7b#0j;Ta8CD<I]Ab\JkI[Gf)mM?>(u[km]Ab7a5kCkq906h44--QrCQh.+d
3CFY#1!7J802]A*m!=kBmHE_95^CH]AfKT)>kJ^56h:VV`20q#2itB<A2@EY7.pp$$+N(.aEmQ
:U-lU$Z*)UNdFBjF5.Vt\Z4WBkA0X$'ig-+g2llsqW2)Y10'Vl"t:(aL\bZk^P_RZZOc)_h'
Ru'*N;ZGFkjf\kSHK)_c8ainaPI@)d3ZD^WS-WH<W?%0-(dK'>.>APj^5JR5;<?^hcBX;*]A)
aUPQ+ZDO$+?^INORp.?tR0]A/o0m(s<T*C<F>p([f(/I[&p8KbYh-P@pOq>R4gick9kR3XCjN
pfO.58I7"cV#YE&1Z^-!3Pla43ZTs!S1.BTG3D+mf]AQ*A4+#M[Q7'_?+U\;?K(`d_`Rk2NJW
WI?LbReYb,8F%04Qg(i8EH47%RYbC;Se5>haMD)m#/K3p$"A`FAa8aUN'Tf%;/KQ<`o;f"(c
rM=:>$d6TDQRr'[:&mo-ElgNfZ;qf]AAQ,hL5KV+"cS#,FCl"R^M_$G79[TeD((=dgm7YUnFY
%-R#+)G2npp[Cq<LT<&<=t_h?@Su#g0F#RkP7]AUjfCM1rb#2r+'h&I8/@!rV]A.(CLE!_<NSW
oHpV$]A3;MQ$/`DAAgY'=bgpI`AZWK]AS.`-(&0CrJ=<>VkWeH=1AIMZ_S"akd.kiVWX;TgsH@
d#c5Jb?eO:FIAcXcG[WT@uDP2.C0:)6h&/,mLJ;[Dif_:XIgeae<enJOQP*B5NEYM<G4uP8m
Z2]ATnpc4K)j<!)'%1=:Z8&E[i\Ph@r9ConVlW)F3hAm6fWq*uGMY,+`jd+aM/t=s0`S[l=<a
8E$<)<H`L<J,?8<Eri@<pLoB6Sr7Ghlb]A39+f'&%rIqYrTFfOD"sT;38>X&0p>!=RAt.RI5i
la93_DXQ-XEB*?3CT.K$j'=Xm!7Xq==D7Dh>Uua&7ls[\91qIXSijc_sFJr(T$\dhYiJ5!pn
OHQAhHK[A+:D.I;n;SXE.6mMBLq'_m\rS\$#q\;CkZ:4_&RCV)J"dij@R%0lM%l)[N;":M4/
hSRqD;XM*G0O-_O$BLb$8_=6S=D[(2Jr.&D0%i#MJj_/:-B=Ig+[d`oH#$q\VdMA;!+RG&B>
gFg1u1#iFB0:b`Q>B\6VO+F*I)7k?SUY'n']At`Vuf]AiB>NbZW.+TcmEC07A`p87LI<n?0TSj
jku)s"S_gg\"uE`:<iI;%>TlfmoJ0ZPf5`r95*.Ib`O2TR9bY^>VK!`01l(sEs'BDIlDc62N
60,.>QbVNFTl"91p4!p8]AI07)*0oq?TdM-M0WiVW<dcO*UghBD1SqHs>L"@?kqLd59:V6r(A
-Cj54NJiDl,WVf=,F=t>+"3*qK<&W'aKg%(#?tEP"q1DG#hTT-uqn<Wu>ro:`1\Ci+(Q$GT.
(Gr,E%#Q(8!XG[q*O@pNp>j,,Dgd,/aS'9EDP;k#SF2<T*1iD_()00T$r+cM!1SJp6)q!E>1
<SZWY-!nc?[Ahp-?Pcul_D`O<6/]A]Ah7Hq34Bq<`#`<0^IQ3\5(*41rH5.2dD4dS^RuDh?Kpc
%F"E(dZl\dgaa+#F'@1rR[aWjN]A>X\ip;Gdl\Tu)X-`uVhYkTc<Pul.#3N\'QGJ,FJ(t\J5c
oO:3C1@89Kk)oZ/2Vd8:]A@T`!<)([l_8aO7d,JV";cU!`-'ES6Lc;DUZ>W6K2h[K@KP^D/.4
6md2-fQ"/c^kg\+YofXglqtQ&Rn^qrVAD`s=f)DD_Xk'%r&!@fZJYmi&3fOUPT:D^?6^ALI1
qcft4\eN,p^`(tnF`l7T,>OG2lDU5co##$7t=@l5Ho%;G@n!0WaF(^eCB:j1HLFaUm;h#Ojk
:S#ac,bIl&LB9MorJf`j^tfT$B*X?\ke08PC$Mua)niFT@`cVS8OM8m>6eTXZol\$7cNts*%
:@S7nhe+Q^!t*`.QoV03HnKub8#Q`Grt\[qO[sl@-3b[p)p^p3#8tY<gT,ji:oNO8Q`$EaZ_
-"k>W@h5B+>!X#C"e!Blr\g=:,M%4Lut%0-D/g\'j/@SdLOZ[=*cn98b;Z9Vb^l89rSnP7?W
8T]A.O0o0$aB3#V%i&]A,ILZE-eJoomRq:-O><\B2A5o2C^%pk33Gj=BgsJ!i`R9feYh9"$3&%
&k/4LDI4E4`t56,FMS@78'P'8u2[i'RWA4aN&+G/>$<T;n3`Z!P*)i&n@H+Z&&`ms.%;O(_2
3S[T(Kdk[JWtX<]AY)bo#dU>pH6<5l2uLR#kdZ'l,U9JXWFo7\io199$&-nsKY-92#T(.8@q7
%j=bV]A"Jj+D2\4b?"YntpgSP5fpfD:h23d7(Ms!<gVM:.Z@Xg&E;hqn[X`e6qp_q-%"h/@:.
@tNSZKCg'ChJ@o,i"t0X%*JiO7l*R--l?NGZcMCa;]Asnl6<[aV$epc`cef"%96B_Y02lpX*@
>E)+$kLbO_a<b'-*&%Kjb@b:XiUA;:`GtJD*Jms>/8S`or\h2k>Ab.Z1Et@>S<pRtD[6hFoL
P,.(rjCGMVK#ooR)k9ApM#Xo(8"F*9_/E)+(I3SX9Z20I*k/`/p,6OHq&%R4!fnNG+tPQ7bE
s!)=$OoLE7QQmmkS7GpNNAaRr@qDf[:9mE@JDiqm]A891;fCLLF8l:r9Y]A7EGR7;@gU;:@1s*
U)$>Q:>(T8K/&pY;dhr[UJXrV?MUt#mo&!J[5:2M5t1]ABOs71IZ%c/7)KIiW>DcO!X>;>5OI
YG]A';o%&4U*qU#Hp?RDI;Z1IG$^IACEW+f04.ks*g"ge7HSbV@LkEg1tcHGffTj-<\ZS_PjR
ERGA*B9kVuf`$/te:L)ZSX<Sc!57k%Lj/Z)MMiK(^goMAkEtb8piG..(@+18*$IJF\q$kb3X
1!:j\eDoC556\E]A%*XP>Q*O,Y:r-H!'hm(MYT9nh$+MrLK*a?1U[^T`fY5V=X'N>DBf7*(Tt
JS!Q^\FE?R(+JBo*?,/4bpg7QsJcUfFY=Em'0!L(QX(lm\B[g<^3Pi&X^4tH\K/egLldu+h^
ko)<MZ]A*bsfGMZJQ5B9Wm(RpNkcAm5iMK&-6R)/$F&CVgZs8Rc;]A2jf+Z#Q*!osK,>aK`Ph"
+)&KYLC)3#2+'b3\^;kntoQa>E?^ju.`W9Z+I7[PD!JYAfJX='(db%A?hAGO(kh4D=o3n:YL
X9cq)<\\8/(ECls3MI<di)=r#`H:kTSS0Bo#4jH*d'VJ0C+cC9B*=g,9PMf!.F=Es0A_?30N
oWTL%^/BW$JYDdo?KZXD?3VZUSs%'S[/?(S\KXsXh6bENIFkCK"[RNBC3C/c*/'K`>h^jH`Y
Y<`P?#/>F\r(V'IPtGK)e[B)0]AfqqW^P?WkF'S4pPt-Os+=jVA2E$_56Zp/?%R"!u>%"LD8#
@%lnJ?+e]AQ<2heS$m'Ds+k)f]AE\J)/lE[YS$i0^b9Ibc$$PjAa#4>^8DELl)gP6O!+`<SH4*
>2:NT49_n@?.kDuHj580?Q#mdfakEAtU#2r64UiYU#*jkB)7LC6ea'/p0)OMYFN1^M*oYQC-
g9850=h)lD<S`Cg]AbAij3!):!KIJ_m8FNa'NbQ"OQ2'`RBG/8S4Tg0=(5PjLi>Ub"'Z[@5eK
FeJtCM`s/20Y[r;2#SZFe@MEmW^gV]A`*L,<Ldrc@(MK<Mm(Z/:Gb;c`9P%034r`a1Yg%H?[1
k1f(DKYdXYOb3f;#NHMQ^noG?a[q'n;g6,1s`=*\7l^]A?&VN\B&urV2Bo@#4,9f46&;@+<!7
3(5tg&R74B*@khp`Gq48304<qU<Xm1MrRa3#2f@#\&sJrjI:SQhfU;,@1Q9!]AjYmMR3fbp$1
BWH+rQZP+ef@a9fB5B<'4'-Eq9DuM#IIX7?5K6nbbd'!R,(QjZH`.AVV$'Q1)RV6j.Et%0=r
6'0N/1:W=#Oe/tK=;9b%?5MNBn0sA,NW&10B\+KFfPD.YCg@^SY;8$?sA)8(oUH>c^B;?9%1
fVP"O^kM("cd13,u\MB]A\Qck:O?.a&,!O6:Q(M`<!mVA&[sgp/VBH:<3es73_<58'ZSjob#T
CWd]AmRsZL:pC_A&]Ag1(6O;O_pJjRtV_9o:+,jpR^fRF70#$hOd"qYLiOGq*(GL1XGssW2;f?
LapO!jpK=3*MFL?e%Cd3-/(<Od[:"kMpgRW4]Ah;'^q`U#[m^RJLKm5pgVHq\,URg9kY,@k$d
(/g>[t[kc?eQU.jjTYkUPEm?0A7Sc;Gi^nu(;YN=uh\as8+JTf3/o-hDTcU^%VR_'kZRI0b(
X"/uijO9.41V&bCsP1!N\b?aDqYl-_"%qa6s22aJtC;83SIuBfOfACe,H<e`fd5#Y1d`$`rY
-6Td8um?<-3r/b5101Y^3N%NV-0F:LI;UWR/<KdNGXaTZl3N4^YiK,X4<Mumj>(rN'4Yq!Jt
[A+[d9Zbe)C,mR.^!F;!=h)9*_00q6o(1a28#@B_>+o]A30.&U(?/j1H069FP-ZQ@hQLkdN[R
8;AVYENeO@c`A6%8q%S(+*#:V(-F*hG/$IlZ4C`l8d(A`EX:rcI[i*i.`Wc,Y2<W9c>*OVg#
a)sJ,>+YWi=OCr=-k_$@[c=qUPsudX/+*3SVBcR`rfr[Vq72A*6[Q(^gW%l2VS+TlbB\G2Yr
b_!//%=V53LAZ1r/.\r$U-6\@8\$<9Z.@gdI!\q">b8m@:Auu`F;<?[8m>^P[>=\RElh)9PL
(ldbjWA2bB3Si;TSnl$R"%lXe-$Q0Uh.#+Ebn;QoAl[S%1;aFNRqi]A-T4;%^g4;1AO3;#p=,
Ge7q[l@?Ghp=;rl70Pf;r.78R3ld/#t&inoD%75G!XCIj,KVC=]A2aeY<;c$)oANJp_*d19@_
R<mM<OsaB_Q68*9@t`:8..8j:mg)WSU>fol.]A*mUMAKVGZ(Snk]A3@9KLB.`\&8quHc7L8o;V
:b_>THk>I,Y6G#It$,jPOQ>$Za]A6$KrfDTK=uVoZ&uj*pL.;UmXZ:iJKQX4?:@4ba<['45L+
8(UWs'OaGk#1S)#U.u?5%Pi8SlQt/OCD'.ud7f>.tZ-!J7"Osl?Xki&1TEOb=n<KNfn[/0jH
*6"\P$Z<i)'JZCVkKs*K9Z?(03G?b]Ai4'p%<?=3@BMLg-!b:iJa9gH:0.tm2VD&XXpHnaHbV
qj'P+8t5@=/9T>IQD1)1JRkRY[j^"1)5-#R!Rf(@BZ.PX03(^`&^pg/1KH!^=i3,GJ7ZEO[(
XrK2#/j:=1f<QA!fjO/j$8Bh256$"("V=o,2PSB2^0M+g/4N8M,guKMo#gH&ZoacfErYnKQE
'78iK#Q:*0MVR-IR8\>egUtoJfj<<4C*N2Y,@Nm[.P4gjSo_qd7NG*b$IiBXCA$(TgW%Hf<D
!F:_0h^iRLPX:`<JXuTTdRA<!;r@.D.rN(AE(3-#Po4Y5>oHCkiYkJq.`VNEb?Dc(hFp?^_d
`6cB'XF/EKC[O3U;lQ/?[/#t"$o*YGa"Al=\mf#X<<ht&n!4m6u&7.lr^51)<X.Y1oo5^c(&
PRp[tM$)^h23D+"-TghgM<fGqD!(Tt@P'd8#hQtXV&k:9^Vkp-=e.spttK.NGq[L?1A[S+G1
IG]A+(9Sd`242YqTFDHpm.%@k>?nE`cUEIkGPJ?M,/bUqT:nnG%XFTepq8F,h`*`OF<[*la3R
m/!nVnKWm%dH3Sr'!]ACcE1$Nq#+uK7n`i8soJg+$2l4]A]Aq<iWbEJLKXk(5a.Z[fP)ae#dTUZ
W=ohpbh$N6eSd'"#3X/id*.^mZ.8LiUQ\V*cP=<1E=3\;Hn6oSVe+2d,;+pk.rE$`FV7K;S*
+lX+X!D>uXQ<sJ'7S6W94BeO+,`r+nSqbI7d<poL^P[A1XuR:Hbqsr!(Yt)67u>oZhNSq(-F
Lg%@&sg.YK*1dgr3L'8K#"jC]A:/3a>si,jfS09kh]A%kr\dhG"<I"?Y0QPS^=TCCoAUR+XRQQ
&VoIDF#qCC.nd+[:=$^-k[cZ\FQ_GSQ\0hsR-)jd?4O$qO*]As!r]AZF&Jj*#DmR2(t`2?=I%&
dpcfmoArLQC0&GRr>#\AKHoJ0ssC+;je&m.\0'ls2*d4n:BZ`aJhC7%Y^n*1EJf03>4W]Ak%7
+%?L4)@bq,B)sYHr`[5=l>0`hsUNei(S[3]AKmW`&)l'u!;n3"*1$K*+TB"@&)JF<'7P\Hm9R
*[kc`(LBRff*=P^E#@k7tqE.R#;-I^.<'r[-i+<Ak:b0+Z1(k0qn<_*(+-ipW:9'(6>@HJdV
0!LfECD6232%-%ZaN/u_9/*!t-r]AmVb@IYFhT"T]AdKdQt@mWkB4Z:6*W1qV[\I^scHElg=%S
Mof^O*62Z!Q:u;FaYubSYA-A[&dj8K>CN+a!qG$nfUc=6dg6@t05kLGe=8(=gtbHcE(0;a=7
M'n1&4m8a$iB[.!fsK[1<`e=$<&]A129B<FSf5_%AKsMT]A9gWY,+AkVV)PT[o!ZfQfTD]A*@>l
R!1?1h>8RdKDr>d'GtRRrqX,X*77-(_3J"L1Jl-CUb(b&M.Mi4EZV4L>qAQ=[M]ApZBK>9_tk
PbU*Ja'o&;8<L0=%&1\Y_DS1#b_?U#&bbu\QrM6%1O=@"oIs0F.;3,^Vj+`rW5:`i</[7S5A
*MdUf*2j"H_KYsF4o6JkokOPM]Ad2pCfSC7J6gJ2k_[qCI6)4!0MghuuVf:)3Zt2.u-n0S:kP
&rYY8Heo+Jc"9o1O34YL?48IGF-3*GQfd7J6Hj[301JsI1@@gmp'XC]A`<0+q(4RNf.Em)+qH
W^:#6#26Ne/QdEL7PVFWeuC"J4H)h!d^'"5n9W4f')uZ*a9t"e=de@bFoTHF?jhG6dhWnB$`
A">8pH)3CS3hO*fP^?j9PUUT:)PNX]Ap-r@)*/Cgh9CJqn2)o?"fibY(]AU^!un_O>m9LO)&=N
`F[eOVJuT00L6RPXKUc8i#jtDn+%B"Sn;V'JO\II.c*rcjIOmEq7gdBu8rsC\qmCeY;[Hq_@
q:?d#4@AA+]AV`+4+lD5O#iUdWa0i8aW4Zr3s*/Jr;H15P,!?.Gt9f.P"NZFW+lQM;Go"VX<!
h+gXkWptn\fVp>]All;!39eG`g\SDT5>/mpf)Z?JQp!BH!r5urJ+c&t7&/*9M.tj/ukY6VXgS
(]AXlNQT2o"Pc%^EM-5Hgh?.6oN?CEb3DI<16iBlrS2)=FE'gmu5+D[Y2b3;;b\=gH,'2(,d1
m0_Wk%lo:kK@!t+ih=@H9nc8Q!5YEM?;U:gaqt)&plEtSFT^=oV8mcu#k5&k;PU^=]AnZP\&4
-B(EhE@mE3GH*8_,qchFBjb6W9,XPj3,:'T-_07PRh^LMUgO9?j-YrT,W*q?$rJS2.t(t*dN
JYjkY=r]AP:((P4;g02>$7c5N%(N(qq4;I*MC"iPYZa$P(bMlK)L-SQ"<"cI3/73bQP=2Q+F)
S)mu5)RJ/Vq*onf)G)gRaMMc\+2T1mZ5CXW./F`&58;tHS=`Hq-`j?HK$&AMQFFF>!$S)Xb)
2Z-:]AWLpiD[Y?kcsSS-cNQ>cj>i43)O:/*1:h$)4)ttiq@qL(l('u0#q3"[lO]Ad]A;$`b:NaP
(?4bPG\(1"gmBsg:k+c)HWDDnE&cg=ur]AYbngc*qm5^"k82YZU#.#"49`-gB@T3ka]A=qnrj4
O'&+U1Ul?CdNHV>Y,Y:E?jm3P)uY(;dRgqg#\H!ET-8:i*NV&a99_QI%-#;OqHuITDgSE2+n
h:Dn>^E"6G!!#q@c]AbU_qs,rR25Jk(hG(\Cp;U$^Fm(tS@5T9L"t3G*3:_k(JsYr0ldMpkim
4DY<A&2P&6s-'Orp.>>fhoi(ASt,PuCB5MaERS'`F9c60OCQPkUUp)Yl%^$unK/NW@P@ZL17
W9t786M`j$&8?PE;m#-WBt"El1gacCXi:JUb5j7T3?n%H:_JEa2^;G),>5FQ]AjOp@qs@Us>3
?m$fD"o;\7nnnNbu%I<]AdN8NX'?Onjb4l&)I_Q0V*YBN(.VXp6F)?H(*cg.$;6u`o]A@t0#pM
R8D3D\m52B0Gb%nDr)QO8P$hMDOfQ@riJ(f^".[B9Cc7^*"T/O7GjATi+6mA<c15aik.8r]AQ
/-911;,re^X&[_VAmMcOl+oh9C7(uF,T1%4O/<O0rrRAoS*Q90N%VN_"0!%#!Gl/5jlq.C5d
$/89/>HuMGQ-F6e?>'\<q?,s1-U$6l]A(ZA#aq^gTY"FHJqj3./=mn,IbV]ARm4ujb(b5MLM'R
bnm#.^,:5CdMI!>`q(PWH&+O:hq-blX!u:lQ/$rV8MT`h7el0&J!cl^LMl'W1FX0V"3j(P,=
"[;[hL/i3'GPDC7Z)GAY'"bPFi)_O`2`>>;SNliMZWaBrL!9)*#%.2/GLT3-o%4`+Y9A33S!
0)IOU_^@MIm<'&VHn]A9/?OJ#?OG74jcVBNScM=KbMc@,]APuu7151S-cB;re1=<i?rfr:Rk[F
VAQ8ehhEp92q0^0`be.I':4?:C@=h[()JL*L8^RgpW,GsP+kJlgdg`RdtLeekJ_Tt*DDX]A)n
*4JbD:e,jh6k0\\q#S-0.[Se1D_NR+7d?Dr.D4GN2oM1[R[uNS_?mmCeho*Th>O%C6"n'PdO
:PRl[Wu@4MOj%5CagI1Qtqk*k^0*#1F^u]A3XMrr?JBhU79j.!L;2,*sYIUPMZdfqCSAO2[3X
f#G9u2ThkZ%)/!Gn++sNRTNI$2%H/la`MU`l'!g"5A:-%`eml/n_r)al^<UtgemIpGVtHpk]A
0"Y`[K<)q3X7Z4=>OV$qU&cTS8%m21fc72E;A=<Ngh>6ji*R%W&Sp,MMVH=rWD('ch711XeF
HABFNWC;`-!XOEP9#YSD*587F1u@0T.eN>j733^Bu'pjla.12OC2^)GY;:ZT=s%]ApP$REP%I
!7Lc"U71Y+gH0p:mpIRDK$TZ6!cR*,)Qu@6nGQPY#IqpdDVsc(Mr(oIcs",EiQUU%%2@_1Gs
<Ebed924on7GkqcVZc"BF_dIt`du`26:^kL?<HJqbCk>.cJ3Id;WA<*4$-i&RBm>6[Ha+7B(
GF=I\R<DiU2eIC[NUX.#bM<kk2`6?)F3CKZu9GlKY4[$Pg5"[-LQ$,r"\P*k5J^Z19=Q>am7
fZ*8)te0R@$Ygl:*dHjDt!HL'/XrlgaK*V%EdWk1W3.g1!f75]AGXK,No;[)]AVJ57VY7BF-`)
Bj]AXEO3-8)dki:qO+@,T1PP%+po$MVXinm"5D`MY,rEG;<LUp`+":.H?1K3^sf:AL^_\*Kph
jmJT.3-o&^Oq=[OO9V@_.QsQ=5b\m'ge$`NR"YHZCb;k;W?)@iRUa=$Qr,pS+R04/^a7,!p?
X+#54WrWbW2'AT]ApCE>:h/)$ZZ=Up'.6d`0UOg[8r.mhsJVMO_S:MH+X":=E1tjI7s8bB*pu
q\MBr\YE%DT:-me8g:3D+"Z[,d*db_8fSL;CAbse]A\s$J?6#B%_WYX;ZK41Ua7paa5+"l!2Z
aE.B2\IL]AbC&KA28X>3!BN5$LOB0Z;K$\'/jf?gd>1inQ:(i"R@8g1]ApTZQ"HisIHWQ3HHWG
Ff4<`b?s,$Ij36%Ni'V4AR(#?<lArL-o3j6u(cClMir!/;1AD`E&VG>_=96X6P!e9pjm!F6e
+LI;g**uag+gq*6D?qZ%\f+83/#bR8@$?iN`tY%5.9#/sMoQoi=!R&^E,/N@YQFRDncW\]AP@
kmp<l^Qji=FFB3.E"U,u(B:o5R$U/$/Srj!=R+'mG^+)q8Q1$JLI=`el!RI0CB+!1$m6CtRt
dIW--XKoc9fnG.[nqjP,s(nVLaJ!Z[4;@"q7)S%pb!"a0R/!UJgF4iN*[tY]AqH,S5>SST04G
Tb=1]A'$M2AIS5;r]AF9?UjD"dEmIp1"8Z9ES728I&bPd[>eQTm-uA%BZ(P\oVT$XN>;"]A<d.A
'p>sZL*e$I;^$>TK13QaCtQN\buQ+df-7W/./O_n*"gE[rkjfQpp_b8$T/*24b`mP2o$T<tq
Ndp>Fn'f)>[<(%jY]A-*Q:BCp)F>ltcqXp$)>"Zn!F!uiHI'kR!4S`%<2:G&/#g:SACjK-EXB
NHR?#n?>3jdJDD6C1lG@f@NeJ?]Ao^k_*8Gu:cES0hjBBT\m1U"EeW$U0EnB;>FELOE'CLos\
\pl2tZ&'JP8![CTE3VcU'(]AUZaOgV3<_#KNH+Ct!LD7ZGd)K/^B,5l>idU2C4njrM>`"9,VX
ka'H!\V6(]AI]A%B7u3Vth>;3[Xq=EcLr<?$"3dS>5HBol-,Ya%^o#`/2[Yuk=@gYPqZ.%Qc,$
Rhn)e1+hmNB6aQ%fPfpF=7^.3#=!I\O]AP>TY4lX^"]AKn#/N5KSJ+h7NS0E$#$MPF5U&P1rjk
QkDS;^"t=6*"3KZTEjqffg,Jo'*fRo%sSj?XqMWN$cRok>Q=\PA)\]A7nIJs6X_[3O7uX9tab
F`r*RWYZiiG,6/[qm^ruEhs&d$slHb]AHB"=3%,!.8'Ns#X[6?2&`QmX>O(<ug;Z%?5L)XV]Ai
:K<,mGFbBTV.D-WS$Z]AVBoM7qk!HTsc@nEfT4]AX]AR^e6F6<8VC=-l!\r!JZoJC&k=`2G<k4F
/@Ghs2.jb&ptq]AJFdVu*KpT2$S"(#>$8>YqWbY'eh+5B\o*pYbH1#Eh(n;sl]At\_b^[V2M$$
u6-?9SeJ*lar:@#bUNQ@2LQHqb>_s"kqo)CghCiQcA`2.h\#6~
]]></IM>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false" appearRefresh="false" allowFullScreen="false" allowDoubleClickOrZoom="true" functionalWhenUnactivated="false"/>
<MobileFormCollapsedStyle class="com.fr.form.ui.mobile.MobileFormCollapsedStyle">
<collapseButton showButton="true" color="-6710887" foldedHint="" unfoldedHint="" defaultState="0"/>
<collapsedWork value="false"/>
<lineAttr number="1"/>
</MobileFormCollapsedStyle>
</InnerWidget>
<BoundsAttr x="0" y="0" width="1020" height="552"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
<body class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="report1"/>
<WidgetID widgetID="01205e46-f63c-4e2f-a895-563bc612e6a4"/>
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
<BoundsAttr x="0" y="40" width="1020" height="552"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WScaleLayout">
<WidgetName name="para_shop"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="comboBox0" frozen="false"/>
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
<InnerWidget class="com.fr.form.ui.ComboBox">
<WidgetName name="para_shop"/>
<WidgetID widgetID="8ea17f14-a0e1-43a8-ae39-8f6a3c84bcc3"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="" frozen="false"/>
<PrivilegeControl/>
<MobileStyle class="com.fr.form.ui.mobile.DefaultMobileStyle" isCustom="false" borderType="1" borderRadius="2.0" iconColor="-14701083">
<Background name="ColorBackground"/>
<FRFont name="SimSun" style="0" size="128"/>
</MobileStyle>
</WidgetAttr>
<DirectEdit>
<![CDATA[false]]></DirectEdit>
<watermark>
<![CDATA[门店选择]]></watermark>
<CustomData>
<![CDATA[false]]></CustomData>
<Dictionary class="com.fr.data.impl.FormulaDictionary">
<FormulaDict>
<![CDATA[=if($para_viewtype==0,门店分区.GROUP(VIEWNO),"")]]></FormulaDict>
<EFormulaDict>
<![CDATA[=if($para_viewtype==0,门店分区.GROUP(VIEWNAME,VIEWNO=$$$),"")]]></EFormulaDict>
</Dictionary>
<widgetValue>
<O>
<![CDATA[]]></O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="0" y="20" width="1020" height="21"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
</InnerWidget>
<BoundsAttr x="0" y="20" width="1020" height="20"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.RadioGroup">
<Listener event="statechange" name="状态改变1">
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
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="radioGroup0" frozen="false"/>
<PrivilegeControl/>
<MobileStyle class="com.fr.plugin.mobile.widget.radiogroup.united.UnitedMobileStyle" pluginID="com.fr.plugin.mobile.widget.radiogroup" plugin-version="10.4.986" isCustom="false" borderType="1" borderRadius="2.0" iconColor="-14701083">
<ExtraAttr isCustom="true" leftPadding="0.0" rightPadding="0.0" topPadding="0.0" bottomPadding="0.0">
<ExtraBackground initialBackgroundColor="-1" selectedBackgroundColor="-14701083"/>
<ExtraBorder borderType="1" borderColor="-14701083" borderRadius="2.0"/>
<InitialFont>
<FRFont name="Arial" style="0" size="112" foreground="-14701083"/>
</InitialFont>
<SelectedFont>
<FRFont name="Arial" style="0" size="112" foreground="-1"/>
</SelectedFont>
</ExtraAttr>
<Background name="ColorBackground"/>
<FRFont name="SimSun" style="0" size="128"/>
</MobileStyle>
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
<Size width="1020" height="592"/>
<ResolutionScalingAttr percent="1.2"/>
<BodyLayoutType type="0"/>
</Center>
</Layout>
<DesignerVersion DesignerVersion="KAA"/>
<PreviewType PreviewType="0"/>
<TemplateIdAttMark class="com.fr.base.iofile.attr.TemplateIdAttrMark">
<TemplateIdAttMark TemplateId="9fb12f5d-cb70-4c68-a574-e954599a661f"/>
</TemplateIdAttMark>
<TemplateCloudInfoAttrMark class="com.fr.plugin.cloud.analytics.attr.TemplateInfoAttrMark" pluginID="com.fr.plugin.cloud.analytics.v10" plugin-version="2.3.0.20210831">
<TemplateCloudInfoAttrMark createTime="1633678816517"/>
</TemplateCloudInfoAttrMark>
</Form>
