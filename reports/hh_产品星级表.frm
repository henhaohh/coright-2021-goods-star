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
<![CDATA[2021-10-12]]></O>
</Parameter>
<Parameter>
<Attributes name="para_bdate"/>
<O>
<![CDATA[2021-10-01]]></O>
</Parameter>
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
    ${if(para_cType='裱花组',"and substr(b.pluno,0,4)='0108'","and substr(b.pluno,0,4)!='0108'")}
    and substr(b.pluno,1,6)!='B10601' and substr(b.pluno,1,6)!='011002'
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
<![CDATA[A08002]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[NRC_DCPS]]></DatabaseName>
</Connection>
<Query>
<![CDATA[/*  产品星级表 
    参数说明(名称,类型,默认值,说明)
    para_pluno      @String ''      品号，多个用英文逗号分隔
    para_iscoupon   @Number ''      是否含券，1:含券，0：不含券
    para_viewtype   @Number '0'     访问模式，0：星级，1：门店得分
    para_shop       @String ''      门店号，多个用英文逗号分隔
    para_companyno  @string '66'    公司编号
    para_iscake     @Number '0'     是否是生日蛋糕，1：是；0：否
    para_bdate      @String ''      起始时间，格式yyyy-MM-dd
    para_cdate      @String ''      结束时间，格式yyyy-MM-dd
    para_cType      @String '现烤组' 分类，[现烤组|现烤三明治|工厂|西点组|水吧组|代销品|裱花组|其他]A
*/
select
    companyno,pluno,shop,count(distinct saleno) cnt 
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
--    ${if(len(para_cType)=0,""," and cat_name in ('"+REPLACE(para_cType,",","','")+"')")}
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
<![CDATA[/*  产品星级表 
    参数说明(名称,类型,默认值,说明)
    para_pluno      @String ''      品号，多个用英文逗号分隔
    para_iscoupon   @Number ''      是否含券，1:含券，0：不含券
    para_viewtype   @Number '0'     访问模式，0：星级，1：门店得分
    para_shop       @String ''      门店号，多个用英文逗号分隔
    para_companyno  @string '66'    公司编号
    para_iscake     @Number '0'     是否是生日蛋糕，1：是；0：否
    para_bdate      @String ''      起始时间，格式yyyy-MM-dd
    para_cdate      @String ''      结束时间，格式yyyy-MM-dd
    para_cType      @String '现烤组' 分类，[现烤组|现烤三明治|工厂|西点组|水吧组|代销品|裱花组|其他]A
*/
select
    companyno,pluno,shop,count(distinct saleno) cnt 
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
--    ${if(len(para_cType)=0,""," and cat_name in ('"+REPLACE(para_cType,",","','")+"')")}
group by companyno,pluno,shop]]></Query>
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
		and substr(b.sno,1,2) = '01'
)
where 1 = 1
${if(len(para_cType)=0,"and cat_name!='裱花组'",if(para_cType='裱花组',"and cat_name='裱花组'","and (cat_name in ('"+REPLACE(para_cType,",","','")+"') and cat_name!='裱花组')"))}
group by
	viewno]]></Query>
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
<InnerWidget class="com.fr.form.ui.ComboBox">
<WidgetName name="para_cType"/>
<WidgetID widgetID="8667c77e-c270-4583-9206-262344ca040f"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
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
<![CDATA[=['','现烤组','工厂','西点组','水吧组','代销品','裱花组']A]]></FormulaDict>
<EFormulaDict>
<![CDATA[=if($$$='','全部',$$$)]]></EFormulaDict>
</Dictionary>
<widgetValue>
<O>
<![CDATA[现烤组]]></O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="425" y="7" width="89" height="21"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ComboBox">
<WidgetName name="para_iscoupon"/>
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
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
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
<![CDATA[星级]]></O>
<PrivilegeControl/>
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
<C c="2" r="2" s="3">
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
<C c="8" r="2" s="4">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=E3 / F3]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="2" s="4">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=G3 / H3]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="2" s="4">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I3 - J3]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="3" s="5">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=SEQ(1)]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=LET(A,&C3, IF(A<=5,'<span class="ani ani-flipInY" style="border-radius: 50%;width: 2.25em;height: 2.25em;display: inline-block;text-align: center;font-size: 1em;line-height: 2.25em;background-color: #090;color: #fff;">'+A+'</span>','<span class="ani ani-flipInY" style="border-radius: 50%;width: 2.25em;height: 2.25em;display: inline-block;text-align: center;font-size: 1em;line-height: 2.25em;background-color:#aaa;color:#fff;">'+A+'</span>'))]]></Content>
</Present>
<Expand leftParentDefault="false" left="C3"/>
</C>
<C c="2" r="3" s="6">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=C3]]></Attributes>
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
<Attributes name="para_pluno"/>
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
<C c="3" r="3" s="7">
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
<C c="8" r="3" s="8">
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
<C c="9" r="3" s="8">
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
<C c="10" r="3" s="7">
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
<C c="11" r="3" s="9">
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
<![CDATA[$para_viewtype = 1]]></Formula>
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
<![CDATA[得分]]></O>
<PrivilegeControl/>
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
<![CDATA[$para_viewtype = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="1" r="9" s="10">
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
<C c="2" r="9" s="10">
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
<![CDATA[=LET(A, 单数分门店和品号.select(SHOP, PLUNO = D10), sum(门店总单数.select(CNT, INARRAY(SHOP, A) > 0)))]]></Attributes>
</O>
<PrivilegeControl/>
<Expand leftParentDefault="false" left="D10"/>
</C>
<C c="8" r="9" s="4">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=E10 / F10]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="9" s="4">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=G10 / H10]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="9" s="4">
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
<![CDATA[=LET(A,&C10, IF(A<=5,'<span style="border-radius: 50%;width: 2.25em;height: 2.25em;display: inline-block;text-align: center;font-size: 1em;line-height: 2.25em;background-color: #090;color: #fff;">'+A+'</span>','<span style="border-radius: 50%;width: 2.25em;height: 2.25em;display: inline-block;text-align: center;font-size: 1em;line-height: 2.25em;background-color:#aaa;color:#fff">'+A+'</span>'))]]></Content>
</Present>
<Expand leftParentDefault="false" left="C10"/>
</C>
<C c="2" r="10" s="6">
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
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=count(K10{K10>=0}) / count(K10)]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="11" r="10" s="11">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=K11 * 100 * 门店结构产品数量.select(CNT,VIEWNO = C10) / max(门店结构产品数量.select(CNT))]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="12" r="10" s="11">
<O t="I">
<![CDATA[1]]></O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=IF(&C10 > 1, CONCATENATE("+ ", ROUND(ABS(L11 - L11[C10:-1]A), 2)), "🏆")]]></Content>
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
<Style horizontal_alignment="2" imageLayout="1">
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
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="SimSun" style="0" size="72" foreground="-16776961" underline="1"/>
<Background name="NullBackground"/>
<Border/>
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
<![CDATA[m(@OAe+jb4Wl$5#5TL!'Nt$chHOVl$C1mVm!`BX><D%d<XWUoG'8k42!(h^f;*(CBn%D<V6u
",'_)_8R*7)jaHf'/8^%LeX/=1h]AIWtVSqV,4=9arE&;_4i,*'$?dI.t)COX%mH7ugC`SiBL
E)in[(l6Ag!e!+e.cuk=R-pKl5!%pKL1E7@[F:^U]A^^trqS>#)d8]A;gsgM0#(?U-D+'Kba2n
mCW8MtQ8F>S%<n;le9@7WU(U=74d98gs,fMLQmX"!KJ$>EAHo8mm(01XW#nkQ4l[VHZ&72d0
P;*Tf@C.dl0RZ11(kDg,65l,:OWB5de>,OA$kPCQCJ$gX=M^k8\2ATX?,:=_OGd#hCgIn7Ph
p!G_@NsWmM\nC-h)3;%u1ppJ4)a-hgBm0+F<'pL&3f<H\Meg)5DLJ;beu4k9#X^fNOO$dDb!
T_Q*b2UMqp/R5A9e5`NT+6m4nFE?O*kj,,&H7M8E2LGb.4W-4It5%@K>rj0Fa02UJZsn)4*V
SB9CMR.K=/*A[E2kGH[J592@q77H-T#j==$NEW,j$$^<.DKE&cQgmqEd8#+`:o$A7V$C(6o^
8i.S1=N^`hO=#X=jbd"HLjo`5`0*dL<XuL!VidWUt1uGP(e,W^Bj9g":k5h\T'O.2#T"U&,#
Ab*)R*Bf6rkFp.Fc%E=*GtoR\-!N9G9(b=\Gk<bcFUk4ljkEiK%Yh7'7V8l2I2(%"&"L3Z>5
8U8tumf\RVNt=P(3?\g&b2Bc4qEQ4r<ccN"cHp'%PTq^G3iU%nk^<$[amoC#&M`GiB02rgok
"fC%X__hZcl.Slr^!Q.HiqX8)QJZp\]A5A9em]AG+tUh@i`DuO5+OWs)oNR@K=De_"\JdSkMKi
JD@aAGci2AY#jI2Ji]A<6jN:ufmR6gnm2#Hg'O6U,e;i8_uLcY#\e[7KInR9,?PULS5;*TR,e
D?=IUU1&T191giNP9\P6V0+H4X-X3&-"f%CjQ@d&4t7\6qTJW=%J\Kf!X-+\t$=!EWQ@+Z$]A
oXqP]ArAhkdfJ7YhKE4e]A*G9/[epZKVXq:GHt3]AhFZ%bFF&?6**paOalp#(GZVfSsC\j\:UXG
gJal?LR^R.71h7P&2jbT8n$;7Cf8*RPiL^CGE&ta+kK>dhj4UR"+k!G]A5Cp4V.f:E"!BBf+3
_Q3it#SR3P%I%F%oSWeke6XQLRe:qPclm*LVS=/cQb8`)0'=fDH-lO>Pp*UWTa;/S>is+N@P
<Xb#RbZpg;h2Fk.!D69]AmF$iG>)"I>7cC):-iPu$UAPXhf8EoghX.Ank%<K/4W9GZJ1ng4o;
,9lU@9PUK,='-DmbNm*j#Dh'n+#M:"-(+;#PgJ9a;=+PB>2$jXqg-:?X#)T%47F2nZGDOKZ3
gAFM<EkG?]A+]ADmdnb(V>)$S5\cP#iX2.PngsWa4jNNcgqP`]ApP\U_&)fdF\Y'o#&!io(pp@q
Ylq,ljEh8CW9FmiJ\liofX7D[%.YPX`/Yc.)iZC]AAm/m4Dd8hc5\HK`8DUktotNh.39$;[=C
8pEO&>(*,aYX6@.-`g]Af&c.I5M[&RA_anFAq.TkB6'"raa+@[&+hSJ2B.t]At1*@&7f[*KR#u
jg>K5;1b8ateh`<#@5o)Ji5$6/:DiLBHno`.W<Q7u;'Y4$,5o!-ZV2V(R`!m>Gh]ABCXnVgYq
H$:7YFan==k@36iPR%8A-&*o)DK&MoG&"d8`>S<9T/uFrU5C2J@kt,p8r\S\Ppq!1b<,#EED
;Cnl'&`a3$>2#"*TYVa<]AK4?BI`,;U0M;b\-m=9HVrHV5iGP+3u#;cS'Dk4qcSFrg.$Y=IBJ
kEQNJ^-Hog2R5$T+T)eWk@ZjdI>Ue(&7BN>r0!#38]A%:I-.PNeL2%f6qBVmKgU-KchghV(e:
h0B%cAuL@uuT#/8\)4ig$R(6HUL8"A:Un@F&T;c\PRaOlj4`>.C;@FU:<sp)AA#8=aoW65B5
=7T$\311s)/9W+p1ONh3HjLGb<-f;(-s)=Io-gV[gq9giY,`&oD^UqmMZSTlgfI-L78A[^q'
Pebc\UqRo@IeaYpHLTI<,F`l$o\ucQu+<pSU.'l+2fWX!N]AP.@pQ/9$kBDjF6:Wa?dD"/pF+
(^*r90(F;6hj;ZFK'B@6g13;Wf&ic^7&Fto'M@P*f6H-Z@'hceIL-?-BXZs^U6Y@F%a2kBkJ
brk1.JI!.%9N_Nf`9oE*hGbRos1oJ:U>+Y)S4,j0)C=q6+*N#uo+@k(el^._d&F=dcHHqeE+
))TC?#f'"2CqoK1I^"?;OY.2M/-E&pK1L!W.5>1n!AL?cUi#L(K&ef@"@NQ_bk)<rAt2X&Ls
W1!V]AFOd-Z0!bl>V$u/kT-t,=RD#oh4?p*Th2Z`>1dkG1ZR?R?+U%$9OIcenh4L<5ef(tmA>
P5CWm]A>.,8E5i,P-sshA%Q>s1@A8#+]A8t$<^RODD^4A8C;UM-!E,&8&N%>_"b^#4pO#'NDk;
]Aj^;!fbN4tXF-nM$O.p]A;+(#I7lhG[:0Q-pR;cGoC<%E$-mK2Hc(FbMAW/m[[T8#p?Rf%'<k
h\d5b#0C%posnU)!"9tc4]A$+,B]AE,,M]AK.;Dg*gB,=s^X:G'3fdC+c:hingOHuLKk5-kgjS-
s'ea/OJ_1\*[94SYYHn=(i-q,*g.njn$I:`=#p)I"S07Uc$YPe;A%<ir%H`JTY,>edhpZiE2
6GluNV:QA2o)]AuRammYCK)F,$dDrWtI+#<h9O\-492Wg5`-su\lFe+d<jk9GjGF??Yj\oI%U
;Mdt`G/5?LS=+?1LV;VVX-OYPE]A.N!Fd)>XqQ7J]A5_=:@Mr[F;jB?[1XEc-?:gRU&E(j/MsP
QAEQ,T%'^Ja>DT8%=kk$"3Ug?s":(FBWRY+Ac^p#"W&t,q6>9':q:;cHJ@4hY%0W'W'Bsu+M
V&E2WWu`S!<0UokZG!pAH>SmjGTg->Xg,!>0EEFVrp+<_nNKEe"D\%\K6O3DD3=4n>A/F7iC
.CZ]A%&F=0@s=BIaiF;4QfW,hSu3:-W@g]A@ZAp^-0hI<C4N`!l$E4UP)fGAa;K8GHJFicTRn#
i/-]A&r2N%b_Q]AZ.QAVe%'BaQbG8L!]AV[DM=:s!3,6WkE:uj5DXe4>oi&D4G."G@==gqtGK9h
YV?k2H^i,omhO-^ab\EL[5>A<<:t3D$S5o?!f=7i*g&"caRi/;;p7A-VLkN/sP(6:=97m0Db
1E>'rp0\*`_,9XhNELi$ubN<h1^!*N:,!8>cJ)/r_rb>h/$>#<<R/E#=UfU]AVE%`7K>1#]ApC
qAp4_WpdN$6!@G#`c[r2Pu$hp<Go:u8^r$h4QdC\DCuA;aK9ic)VLW1&mI*]Ag4n=*.!(<I0d
?^+Ha4)_ou!KE/#ldi]Af[O-Una#;Wu0/uD-dh.'Tf7/dRSY2]A:Uk*(tn(Ja;%h6/Y7rGB3A1
hK(?8h95`gOI%rnZ?sN4%:,X)'"#T:5_o[+I(E"%]Acm!%*3g1WN[C9'^qDt#^2sNguBQe693
0Oe`V?>.Y&[Qd3)t_F@'JNK-mO,%D&s7=bAga*VPs:S]AZXkb<,cSYr.F*F$%=0\E7$#5sa?E
-mT9Q3H1ahVB`[/t9W04FqWF.)r-L<fgJj-;3ek6q/?-3li_dW)^.K7Z>WR'5b6EVW!F0!J.
h=JT\$'p).n/:CIG/cO9j&JX%#_.9.I5E7?K$\C"e*R6P-;U$M24$J2+^MdFLhR0)(/6Zk2K
Bgf)8npNEufTg&Rf&TcS+H?."!>Ud?eBNRt?^t7<(EXL6B6c[u>S."BNHsCrd,#C=09nhHlD
9gJU)>=:pTL5%h),UHsf1[scmh>W+SIcC>0B]AhQE(%Ddb$j0ADSBc1OMYS</IH"CpWq^iFs,
RoaQY8Z;d:#P$T\tgD/^";Reit8!Rc0iqtOk.a"Wo;2j*NS#ldKN=[Al3fNL9.t/hhUqQ$]AU
8nNJ$[r/lH/u@[D-r:uYN%KLsWDiElKq?ID^GJE;:_'kU$E)Vb>Bbh%rJ%]A]AsJhhT*n@R1?J
:6Sa:0T-BWCSup/+\:%[.S1u[\sA]AUB<=Be%/E(Y=[:0sjm<i]Af\jeFVoM,SUg,b6F2RLVa0
6D@b`Z#/_14)5Np[.O*uaThG-C4rH\QDaMZZ;8Dm5`-PAL"Tcs_*6&V?KV?"q)lPP?oND6iK
6O]A7CHh]A2<l]AHD$:gNQ[05:`E>03>gOClMC_0\;BLRH9g$AaUOlCf34PK2kMtg&bBG5mdEs7
'@[me;L:X?+f:jC>&K7'SK^9(iRSB`H)@[IS&cP]AZ9Xl'hr%"+GVg/R0&S^^+28BMZt9-'Pr
)<W74C#0D,'&4$KdC`87U6#(^#.c'7lMN!b@$NdXsk,t.FiWn8O?m&chUN[.;7:R+ufg[644
Jddli!8S<cf*9SC9?"4g1IH4t#tsROqqJHb=h,7L74aL$-Yb$MZ-H)r;XgXWEZ%`7?4dI4-K
cgN+#K'O[rRJNbM'>g7m>-_2iS+p\c,pe#PNDE8-1aF(TG3_R;LCANoW9uTm!Ui(GJQ7qO;^
9A@j%L\F#^,q4(=u:LdpPMO4OV><t'(S_f4na8AAemd%/o]AkiZMGPm-qUp:8VfW<duG#l\]Ac
:1f2,=\un%T%pH!V<nU]A^o!iaWF:Agi8HA&s>l"13%KP,pYiFeKW@m-V=693g&Y!_!N-?2)_
e?m"U2,"Uim>6YhZXS=Id^!;Pm>TY=Tod/2AU448l!qpXu.,bq?%WGpbCV%Th#9B"m]Ar-G)B
I;PBkY;jMuQn4-?kK,Z"hUbaR?&+qjQ[jhXNhV&qDNje/3mKRS@l!b^T2^(aD-2@\HZiTNOd
rTu=RBam-[k4b_sk15+k-5imUh`,R'N$+A3mYo52p.3kYq-Zm(/3Q5hd?IW$g7K+f&OQJg>i
=91);H^C->9%-Qr9[[b8Cr?l:%1RWlP\R?_Ao@NtW3o"r`/(4@]A8Q7@7!@1TV=BC;]A4/ENel
B'P2h1<uLF;.ihVMsW<WU7XmKLT'LS^g%0$OM4TSlY`V7u0bPdG3V&h&O!c7H9?_H^`GKiq3
*t#pBY[!I)GSnSN7<f.pH>SMOZ^0c`>`%0#EYd=8of;K%g;6's67qT\[=+--KTVj$\#?Fp*&
#627#9CC/CF<A_'LS`@[8b!"jr%F06B'+dmF@OPdWj4O`YY0C<X7-[Ypg5JBS163:98Y+4>m
<u)AT@";/lYC,RQk3n*+#h)16"7EjloO2mmd"cs6.gO>o<O,*iJ1kp2?]ARQQE>s?lCP]AdKc8
m72TlV\s3[-:0KFAoi\pN!>;efV^^^jqtY#q`13&VA!$0W^G)U[9t4lhK$VJcNIZ8[2fnrd0
_X*MJffI9gA.d&a`Z<o>K8!iSqd0;`HR;^;N1'/L_WC^9m,-KB0SUUF5^CBh)38m#su[gqSh
-WDYQ9!@N4:O1Tu,rl8\jr\f$X4YKkue+b!Ds&5JV3gbRIsk3((tB^TtK`>Q;cL+6`SmE[3=
he2Hif2U56h!q1$RBs*F"O#0>m8]A>I`%B<gFe`h[^#T$`WUjX\.,E0D#*8MkDI3fEDu5[phg
Y$,-AVu($]A<:*WF's!R#tmFkrMel7%Ao>QbH?.d-[Y]AB[b@9D&Bi*^Y]AO0Nl`oY:%sUumCf3
CXBA0\'=T7MYFM\+L&=DE?N@2:ht=9C:227e4%-9r_fR1O+beMGgb*s(5!C@)I+&SFG%>`B:
Eu;i@h&&n]Ae/61p.!AQcXu.aF-m51Bm`W4_]A:mbM7"rW)u7FDaS`Oc]A+tbX;Z@f&2<*1F"OZ
LVcK";8HHu+_baT._iB]Aq!O08turnk,ZU45ljL\/'i7\d?e"7)d:)Mp$b<t5Ob@e?0`8>oe2
!sE`U"hTFR(-0??#Z4F84o=ot.:n2IH&.@2_K9n:oX5@EQ`2*@CcC2L5]A#2*(u==/j43TSrE
=e"J^8tm^.!N=I:8@7!#'=lhbipUeskAHq46`'LNe)Kd_API92t<V23b^]A%81Ye+,hHNE(&#
IboJWo<q$aGGo"":'r+)<WV)!bB%THm^><&*\s!4_*gfqZUGIYObFF3^58ENt3ikjgKt"VH8
Xdn$\(NWZV7e4TDsY%&<B-/1M05-%3cn9On*VUK8eQ8Tm_<[P'*4EHI.h^\U"jgQU6K[6h3!
iP1g9j$M'`f[[O*aB1u\]AY:T*1\*P<'E=a2,*&c#c:g[Ln:F!S,tN7dsa,,;JYF@uK1Z;NLj
d?K;j0!.\`"rEkQ(mQP8CGH\2@+WnP1qFYL(&I)P0a"X'&P-iIA8C0)1h&u,,TU-ZenT8O$c
T?dg;D**%lJ#QX?Fhm=^-:<]A='0?;%^16DN18ks)HkN3I<C?Gl$`\aZ=F$SlSBg4?CiR9u8:
rJq=k,UVe8H&LfUon9RWY@%uTp:B`7EbY7GfLQ``/g`+TsVPDYeLp^Bf;DP]A,3UpBB<VZsG4
O(5m6Uqh$"NS4oLV=E&0@%^FR]A<md"VmaF]Ap=n_'R`]Ad:46dhb@1\#CMDd8gdNRn]AZP*DWO3
<AmH^od3"EY@oYs:a,(LEWiW!2(Y>8Rqg;)M589M8%AEhW>oo^/]AW=!VuW(=/GDZq*c%U,FL
k>b[,RHXh9+cNf1aM:ih,'c2S^i$<_r^Gd+S/pX9WG.<65_#KnGZ(]A/rel8MU%)3eq]AL:;@S
X`sFqZ`:X6QqZ;$GZ5R@1_3S[TlfD5c@Rm-Q_bmId\-en*I;=a[ZM[c'Y(rE_X(MDb7mHi>h
3DaD9nG91gs6&eumWJ19S!2<oK%[YHK=1,PF6^hNU@K*Bs-j\UC.6rOe_nl\oOPFNnJJGEr/
;X_C+'$ns1bkOWmb$mmiEiZX!@5bEJr2\P>:PSS8Jt)ai?b1t)4r#6_oF?\eF<$9.Z<S#`]A'
Sud8rN]AGYY@*Tgu1=idgZ:pV<A[Scu_C+UtKD/(k8h:]A+'0&_6]AoL%t4m6AXW!e#lcj3cl5%
1i%8Un5U5em&KR5"YrI(F55<$*Gu(BKc-F7iSiHb+,I1:<tH=A;(0C%?#BkV?E3eTd(h%mR]A
I%#M%7'#n[^Wm6VR0)eja)l;82a03s"KKq*BDZroU-\)_N'q<IqRU!kg2WCf#N4HntrW/JUX
+AcJ7]A(9OjiRpcJ,ZkOUMrG)JNI&Bj*YW$ofZZJ:d>]A3)8g5k`r-LTJg6^J)T]AV5c6Q+Gk<Y
SPJ\Wt.!]A[_[76jkornasLkNSoBL)_F0qr*L8,SG=N/9?3VQpZ`Gr7;=K-\R9T[bN<,i2?k:
,1"=D0#Is5+Js6]AC2FAq;fJ\4j2AN.nefZ#IOhLHe%PqE<KDM@W*bAU11E^'1g;ee&dnF0@]A
[Pb3g!jV^o.Fj!6_c-`%KQZ0^)hq@qY6I_;P1k)EHQ1\qSl;tAOQ?+3&9(imIhCS(D&kWNLC
i,p^HhUt;"6)IfRqcp"smbqZ(rU&lB/3?7]A[#ME#EBq.Y'q)qEG+0`bMbCd'2\0D$nNmI-nY
.bY03Cd[MtM49^E17(S>#KSQ))\_J=>=E8^sY]AJ.VN05UNBlFI.Qd)3)g\U\:dM[4hPtqT.B
]A=r6oNZFs1o8<B[Ot0S]A@+[8>`4'ce&#s<$=:?<XcF3]AHs>WA2jaFi(?^%%>I<a%b.Ne;_Ve
DTV]ANQL/GE,U59NceqP-[.S*IhC5:5g9KC:>(Xbrdr\i$4UhApf[\/G;iF>/3V&[S)>:!slp
9M&lCcLJ.uX#T0liX+k:Q;"smfKGIV$jW0QR(9:*BG$e&:VhARBR/!=ELDSWNH>su`u!1FdA
7@3]AnS/2!1SjFF]A;coF/rIhCf>4J^&!VT7BCpnEJseG$E/QJI@83gSb,HUE<sKeJ.YB"X)XH
^fAl9%q,"rE(Vj'Y93N1]A6<O!2#.M'S&T>(l8n8*@c)tD[1Cs.sf$VBAR[4<l;UEZ%eflV7"
aJJe&orDB3`nYB\71ZXI3C6hU3sIEp^E)5Qd++%&"?#)CKRtTZmT$<NiumZRe]AA4%J+JPMu-
A`mP&>#>RU,Oimhpa33l[U`W^>tRHa#j!U/<u.+GCNb,TN7R3e$&*mD'<&I)1Ifa8uV,Y1_B
-YG7^.u/GqdA0p@DqZBC;4DfXKdUSAEM72gl^(?.+<k`sAH%%$*D1A$I_H8@a_obG:S@8`GN
7:O'8jEY3<aLO_Y_a*V:P+8fh*;RKPjCf(:/oDnr5]Ac4<GT8m=>4b)kC+>(86/@B0ZnIlqM$
*&5U/)4?/su\::]A%NEWrpcsK>s!32fJi[^.H=h:^(KRio00`1ff):$XS1oZisPiU'mfAQ1X*
1k7L*$(-rC5mF9nSg"S&1'>(Y'I.?I?pE=N$iWs9PRXicPtap6P:S0?ZmuhlM[Y!,m,\F4`i
It_8pG9FJ*]A"j=&O?E\"`So'o]AV9FIlkR^:dK"`N[c`S$h%h&?QC*QXlZhe)Y*dC!1-BXZtb
UY$!G'F=:kb-5bjo;6kUf@$%H>XC4*KkG2#GB[lE_(jWk>Q`bZ<XUZS.:bZAcX(`Cq>Do&MD
lX:"dT4k;P?IdD.@-dK/ONYNaZ?J4"pKt]A15U9\>]AVk6;"S8_#m'*'ausuX%Xb9SOG4Afaf/
IE<-VAS=0Mccf#,50f)BrRhh9A=[)7b/L'rjH^IjfEPh^%mGHnbIViZQS>N$XgRW/*F4n(lK
1U4%7:M'M\_DFlK?'m&a'9n6&>T,#m0]AF($iLF%hCdPue"`V-diXGLfd,kC7$N52<.[cth@_
piY=@r/Y\8qZnEbp"%Wco7/)c4&RNuC`\,=kGhi$)<oY'=qCq90&gh!7:d5TM)[Z[KpB3Lt>
XI1:*MUNI-EjteUHs/e2_9<3*p5+_g4N+JNG1`qYa\f'dZ`TM_6'RF2Z^n*b5M]AXKX7U4El0
UNEl3,T'AF[@[NIik1TRkYDVLq/U`%[p0GQCgD=a+T,8(:2.WanMK>S!#ZD=oo8X+Qbt\A=Z
Z_c*XRdu.]AV1kS6jPBbpjogdlc3`Z6D[B("NA?uVo9S(r)(HL,%@50Ob?6V4jUs8[5]Ae(p#-
JX9f0V?P$A)jZq*nqnG$:JQ^7DDut'"BMS%%s'skPF>@`^Bh'3P1!>EfGDRPuSLnp60WG]AL(
`VA#+.k:/o\DgYbuti;G[dTuG!I<mh@;_r^HK!@p76\,\]A<Y8++Q_^L0a]AQN=hd]AJr"BZC\;
o%_Z6$0)@jrKKi"/N@51;@EJj[En;!5)g'5O7HPU95IB%J35iQ+5iM<k3=W-^*@kes%E=i#/
f/&a*'pUr;DQ!7QfMFCu!*[!Kf_%XftF0'LS^g%D,OFHAEVu`UH"7W)!)ADS<GDR3I)^Be%H
8_Yrb"&'HK\)Zr#/&j:R\Yi%M5[1&r'L3k0\iUbWC3f"Iug=eJT'=+T4]A(\2<F/+6YWeJq;F
4Tn2YbUbsY\;H=5eBE>N>">Fk$X$XFABVkV8eRfPF-3PDSS*Bh=-^lI.@0%Tr+oSfQ#>9>J7
5"XL^[FJ0nB%TEEI%2@Ko1(I>Aq!7_5GDQ\i#!dP6>KMACY/-4l2f%^/P.&25(eN+[PEZ%aN
*45!.2.4Un-0FIl_6#4-1e^Y8\S;/7<62k"+d4DPelf=6*Pii)b&7Q:5?F>P;2i3lTcJW,S<
i9;]A7lK2D)@$\gTLC)l^`i(!CJckO5e9YdG2"qg(7]Asd_hY%$Tj\gUV34@'%Y@4<,1,kGP72
"4FSF*In99^=1/.T)f8ij&#aMWYj![.FC=P1ai)rKJO.TsTBH;4U1k#maF4.0,*lt4p)-G5H
_6]Ab!]A!$;UCf.3khp!\cF7e3Q1OfrFu`W*kZ\$!&V#q`iTX:1m7Vl7;5A'7"27F`D(<Ei(RA
O;nXf2mnrmq#UV`YDH`T)N__m`M.h<7Tf&;VrP.fj.!.aL*O`',88>tUR;lA]AP"']A;7\qD[q
(pWCP[h!T\IZBkMrJUcPW.:01_FQ\$e?d9+4(Ho<ok%UO+M3F/2#YF#rZ126`ai'H.>[pUEr
Y`eW\+A*:a]A8FIt;3RdAs"]Ad-JAhZrKlk9PNh8M^sKWkELAEQ<B_*"H7j-bbd'-A]AE]Ag@l=I
dF0Lk;bTYOk!;+WaE<0aYH-#P;#Wb2S\`.s]AE+!'\P]A'-p3&&8.WjDaZ#i[8n]At^%U-i7qE(
]A<2Z_qTfj&u^t<*f`[71cQ5u>_HFjmn22HPHD"]A+J(T-gNtXL<jT8NOUa@aEcU_Ff@"!5(b&
:u6c:.CoInX6PsC7'BF*1)S7_AtfHjJLclP$^Z!;IjA,LYo8!0+J;CRph8&tI9B8s9'P*:!B
/N@nt,B:JDGMn3C8d0/*[<TRb\5Dk:lTGGqY7XrXV\P=7(H:BA"<P)Lp9!3DpS2>Ir6]AD,c?
!ZEj.*2*Y[*DB;TgC-_o;i2Mo^ea40FOlf)lLK1]A"]AFU;_M%@[1G<"6l3YP<@X*K,iCH1(B_
WU%H`ger)pn$C7-j)_Tgd/NXBB.Q>qKs,6_FOdRBIW-^QG-,qphn$<ca'Z;Jh6Sl5::gfRSk
]A<0Yi:e4LNMO=tfkK*t2dtVQ7pd1s[2F#C0QO-kpcY`V;@PiR,cT)Z--Ib`/#S&n[s`\rWbT
K?o`\F'r)fW0E!aAu*(Oj*&Ec:-[*!,f1sUe+9l_UunCSu`n:/B/QuL.#CM6u8!34<?2[E,t
]A$/@c]AQY<CKpLP_G)Zj\;aC^)mG#6pdL%e?PkVZNUo,?`l?'uB6Vc%jC#UA`+*9-Fhd9557e
:$_@=o4H6RjE(SGR1J-M.Rb&$q.?$J:DOMBOg>fDKWC!VLPSqJ50?@[@olJG8/dqH!8BLnR5
(*ON=CB,62DaNd6.UT2Bt3hg8glP[cm0^%P)@)Teco34[/fsWPOm`]A8GT+XV]Ad\]A0L%hKUW1
SH$`Xt-P&6P7@m/S:/`a</\4<W(p@s"S;2ou#Q0M<U1mXg^Ml"8Rf@ml1d^R#GMU<WAWoJsN
Z(VVr1#kdGs#\_,W4h7_]A'gck7$0<WXJJnI5;(aTkh:?["=KV.(JYA5QJo'5T9D+^b7Z6Mq;
qm+A95=$JBC$4ee;Al%LC#DT.i7,r>>$=kQQZ&J*fG4)l?%_94Er$5FGcVj#*Q-b\WY?etfP
P\"f%ujCR0ro9S+"h0AU9R2cdr7/>:Ma-;;nQk.bo</\Uncpgni,6L,Grf/6unKXX2jY4H%-
b%H_#C$A&dRA:fVE2ob&s3@02\,9B8Gan#p/DpJUDBge8CO]A&>(7jqZ`45.n"%Cq@RKe]A*.5
`iIU,'%$bqccS:p"4Ke;W3]A$Jc=.jg'ZR8KTb6E_Go1saP;"#A+)S1FV[lMOlT6*W(j0-V&&
%o=9fBcNBX+5hfUklKQsOF5,EJflmJ))]ATSc`Xe'OuA")$ohm!RJCXQ(Pg9ci2"21Ro2?LPq
<r0ZS>E=KOpH;Q4*8=f^1^QeC4m1UK\$a[h3F]A:\Yl?S_G,X&U^84d^&2-ruTZ(/bk+QZ\f!
cfeePk?_0hn9R0aEl`2ZAj*WUNP@kqk+IA-8RhNd"4q15O-@.ml@lOZ8iH66?l2mBDO43Kj9
1]A6rdA>.e'O[>7oE>]A/5`J!:5ghfZ&`]A,[iCo71IaDoj;5E=c3t_Neu6"i7_Vo1j0E%E(=^H
u$rT07q@=*7aea%s9K"]AsS9:DT=j6R@P[W-)OAJ-@=61T*7c%(,]ArRI;r_mqM^t6lEQZ'YnG
tiH\b)8V*K[_$o450A"<k_'1%d+B-g&2Y^J.!T!Ak^0#44X(^9@nGC`Ps+?A?UjZalAW>fi>
_u2K)=RZ1LDpVTbH.sr^h=j5,C:&nOl_"^4:Va3qeS2iTT`QLbIe&N'lcPU_9O(YTf@S4>j9
5#'Yk+OaOS?Rt"qCOh7/+=a\b%N&&PMfp>''SHBE)l4;AbnE;`Yo9';"FbKl\c'/,-]AuS_MO
Eg&[01Q5<d@G/qqM2P1bU1%JFHCbL"iFDcCJ?eq:]A_8?+F$P`PG?t*kI`f`!s*aU&*]A+f-=O
Xo[=Dg,?1oo;QersZg&1Nj7O3u5qTk6G7-\BLu!NAlY!D3dU+N5`C^p"Mr+)LE4>m5?h50lQ
cRL%lcrg>k2V7F\C@oUg&t-G:G$hU&Gtkh-L!+t5]Ag]AlOnm"h$4Ard^qQ7>0X#HB(?O;Z#_i
%DF\9bBGXZdKu&nLq4`$nG;3GYtnLMSe$P_`^)dN]AWiTb^Q-?;Wcg";lPhX9_OAeK^2kY#Mc
GL\Nr>5gl<<3TgqDOWM2UoHIZS7'Ik'2'AD*.;%3=?B(mP"[gO>+@OQYcq`7I`q;pq3Z9+O&
aqQ^UU$?h&Zk*a'5rBf;VjUesq_6Q^&5&Zf>aOnTt^8S31=@c^H]AcHZaY9q(IT*C36p5f""I
_krZXt2D!f#<rDW0(eEZSfuZhtV%Hc6_=iIsY33%9R!J?DAO69[(R[:KeX"@\cO&=>SZ\Tr;
D[GP/sJ6a(]A<`&!PTUZM=--m(u:k\%P@/-Ri\2]AFCUkX<"FMed-]A:7tQ0)%7sRJBT,S"s6&r
ahtISpC/&l,lS@A-m+8N!M9j+mb#:hRi1PcV@Y1fjqjK2!!l97-2Kf:9"7;EhR"Wu(hII18B
]A"8>t@]A!pXo)LVkKDhU;HM;7=GrgeTmLgO:/o=dncsAp['D0*?O&O.<lDRd.7a;V<?NB=;^T
OPu>5Z]A<4nJ8gh.GU6iW:BBbJ++iuUK0//=$jLuHa72XZpqhVNqhioY5D!K-6LcJ(-j%[E?:
hVf)[gQE)^?+rYEcY?tlq8J"rETmm?hSYjrn23B'<,+'k'`L+=X5hjpqnlJ+6mu&2Z7=[O_U
ZMG>^ijWnLfQ43e7/C+StTX/(/l/4SD3Znn<)3!^33M&Tg=NO[6^[]AZ]AkmHEXofXA&(I;:c<
PG+0ESB,EF>]A;'kEkoIT=NRX5G2qFo]A')shq\R5%RLg0q:AVES4:S^JcKA!Q!W4KS"^dgK)a
X`-L!"KD&`!h"RIeaB,ek$BTPddJ0TH&TRd>6g1MV0kKpm9oQIs#Yd:ToIHJfDdd`'LO/WJT
#k$4ahO)J`2TX+]A;YQm^&+MJS%qb>E2A,c?O9_;jW7&3sV*Q9<J9ha;u=D'4Z/ugN\FCDDs#
ep)h'#i[KqgVM99SiM97F(_cg]AN&ROX;Of+n:efNC=JD7:6#M:f"66V#kdXDj"!hV'!=`Gp2
CF'%VU_D&7;7oaq^tKG.X!_Q%nE9r`:?J:#8-#<%:Ms3<n0OXQ[9_fLF+\&P$"L7C<T8&'@#
/X0Zt_V+@H9AV9bL;RlGdoaEW5mKIOa:UI]A(6sMY(br\hCh#[Z9<qk=[I?0)/SqS(6Ssl'01
MYDGSL%`n6YC@n]A6)rl%+a,-9HQO6%2M9V3WKrX'q9N:212M=2*POYYClJ9B>:RUWHZ!Z-(b
F&X@]AmlPJ6AE:06CH):j&pDI.+28n&\U!`dB*g;q+K!Xltil%(*[1S.f%7P<]A]A`7]AJrg&mh]A
egl;rX64(?dj#pLed)ni!J!7m\?pmF@GHSnLE4\i5c850NbXInA2H@iSJC'9sD"fA6faS=OP
6:%+?Iu\k"9ccXC"BXa8@55Tq).Me@s%W3`i#B@2YkY"mpsUs5p+2_c9[?f'a2)-'PP4!BQJ
k@AG/'#^<g?#TZhE@NNlnYakVB=VLo5GR9?A7LUXP-Rk7g)P)SjJR3^I-&%[kVCp6`RW/9?G
=0E$CD6feZ^+9k?6\:?MA$n.]Agn+iSLOK]AlCD^V&B;GI!*$Q'oi*`VAB&Hq9jt<p%(/]ALgA\
Dn"7oT?%TV'=6LSI]A!KL9j3jC"Dmn]Ac5XDSqop_d\*@b=,pYAk#Q?S5Z8U1DaftWNP887MGm
l9E+P4d5.QYXt\Q^.K:@\hKOe=&c'^'!1+Am1Fp*@"Q(eJ*$^Y#hQ>IrTR;h1MAan/GBoF0[
W*#G\C+$Z2uT&):R;;&=jr#hSXghMQ2_\4NoFkjr>@Jj?D=Ygh:N[rg=hpV!@$7o4BhHsK04
=T@GaH2D5&?$2[d>_i)7U5Q\u]AQmEe&_YIK&Z5D7^`ntS&Sph[2&kj0UK4o_&Q%4%/P;m0CO
U&&d$r)Cl^*N?M\DnM>PUfK'6c^#i&A0Z4Au/717A@O9JM%BYQDC;V=kBsZip7F'*Sf88%<U
1ro=]AV79Fs$fQfL4^:^B0jRh.]AaW%T=9bCM4DWHNH;<G@QcH%VcE5i2T<c6Kng:a6A?"=k=.
(NF!/9eNhZVV^X&a]AQJ=Jbr>>namh-6$C7TB"-gf7e:1*J/d1U[js[jJ9(N<Ns-ZUa27AG$D
ZLK7t$/@$d5d8cY=RA"Z,)jQm"PC(U2g[.m:'^u;)nRodX*oliFJPOgJK;Xu1G6FNp5Z]AN(I
K^ZHn*_,eQJR<kp>O)g&p7\n"^ka?PoS(819o&%-bVU5+:0VOEU9p*O+LXa+5sQJn><Mp+]A^
P71Q(*GDjnU^,s%83VQ`3_f1"LiHNKBEp(@0mcZr2$M<\74A(l+W<?;rEp'-Tl/QjZ.if.Z&
`/I%>aUS1DT.%qRj*e-6ESfE8GfR9IYRR1*G7s6Z#lbFl7J0r9cP/4;[4[7t&Yt%fFinJM7I
#k_`+G?7!]A<$HQ$E8r'OW8@8MNU8-q?"sn#I2PaQa#k;R"`WUgr#DF$GjDb^9cXSc(cp7OMX
5Wl1A`JA]Ab'Ig4aIa=K$[='J7uij@7670bci<)$d<WGBr*SfWJsAFX`qASD[H#<q`)ZjLO@V
Ojt1+Eg9oXnTH5gnf<2<SCb4b%FkBKbO6Ha6fuC2K._ekLY?sDs'jOZQ&V*chlH2B3/+e'PH
S*fK,[`&aR$Ye3uF<XLd8@`I&irY^Xp-<lVA?$rk%7>W^bke(F`+7"Y<cfUlqe2itos-Y+7e
RW2R*_k^3$c>sU^3AsIQ7:a$jqiG0W,dYKC,:%*(RAfG60mueUhk/hadi=!(YP(b3s_"^E6]A
gPZkU&7p2MPLVlj?s=PK?^>CLn>I\n_^Kp]AqZQgrS+HO9$4CXIsYBLjd>Vr*n*ZV^.TatqgT
B\rkGjV`kuiXk.eA9dlf\^F;S+9Y\KA6jBp/ZPEnQH$db7l4I327,R[6jm#Y"WF0gTp(Y2b/
Pc_=Ys+Kr:G1cFfEFPiqGc(Vdn^QUb[n^1%er\g'ZMC7?p+m^pKO)94p#_,*51X`dK7>^$Ij
X#Z^7DkAqO@A4f\_j@]AD+]Ak[bm>\pIC_AB+ca2m+_O<nE"kDo.g^%X]AKfcge2e[`G7-Nl93l
d3nceg'3Ui^k**Y^InUEEqC)cm;HI\91OJYqrr#X#8!^[bgS"BVru)XK.58jV3Id;OjP4+@K
m/NXi+jeT*1*f-6>f^La[-BAQFkW?(SYT9-d1gZ^MDb_^Q@e$DXr-XR+2Qks"=oteGo<-Zi:
4jn#4ZdDXAGG?g$#?T8imNprEET6q$:SPB2M[W=>UM]A.:]A"L[A!^_3)49%q61]Ah@!Z"kg`(0
?j]ATL3taESKb]AFef?Du*FL]AXE!^1b1jZ[U2p5K%dke)DLi]A7]Ako)tFflQq3S->9XHL1.<KmR
Ebtn#'LKo]A)tXje=ld#Ycf/.%qnCT\q5I6LI+g,Yb#1'49naBn#QppKA>s'[]A^['2:hjbljj
=Q*&<(m!=Wi:t1cZ0PJ1"4%8p*Y0DpkqDQUla,u5bj,Zq=J-sWajiJCT;&a^jjIRth;g4Yo5
2Jm')!*@1.8`@Wimoqt]ATslEpb"AcoHb%mOtS;tIH!.8ji"[56'lSBE'<e,6au7+cL.3X\og
EC9&iE(SLs"8Wr\e^H7Zt79c%m"JJT.dYCe90AqC"N#`r$O-UGlSWlth!.kT"t72l5pUgI$+
$pUQnc6dg:Ib%7_nJl.[Tqc;+MTNqD7TuBMHok+Z.D>Rq6d.p23s"t3PXf'2>AJM.f<JJ?$/
I_@(0O5&UAa%p=6Ob#o+V/qMCDt!BC$;7Z=Dl^k;@@!2uRjtW'7"/I2QX1&\gMpm/gTfbOMf
cdn8&D'K`b%=RBWN;!"hT'.TTtXYC"=?%FO7hhd9\a,97%+%8q!E::%jBdKbk=0NmNCp-6&j
!FX$@uS$)&=F;;>c-ZqHGa&aZY!=;^<4@pPIK;o.K"fc>h/q=8S*`)Je(Kq`l3]AQ-bYJ;ZD)
.qL[%gDEIYjsMsPP@kr>KV#SPrFa4k%)@ZW+,H7qGhO^XrK2e*+Sa4Fk(J=&#`U>/H6"lgnC
D+.f6MpaB/)J0U;r1MH7oR-,)lF?WJmPWpA.sCm?CH>gJ1@efD_-?DO+Z;N7-G3GX@`1ijMX
\u,5$3KQ>G57%A>"kn=uY'njYU\+,%(@$'cJD=/XG43:[P:/.P0p_qFp+uDmFS`V20TfeDXr
MVbhEA$)J]AUU<8'&Ba]A]A.)n#<#:l9c1!JnFSblDL3NC(`Z*a!$jfE;C!5htnRI2/UXk+COW+
"JNM5F\'sk/A]ATlf8.8g.EDWVd#;;?\W*8QlP%doMTP)OCf,_Ik?PBmcVt*:-P7k)J9<rWe(
Ytff!),Fl)0KS+\)J=n+O[>1T8aau#7Y#$`r9-uL9j1rFEA<%N7#0=bbEaXa$[=Laek%')f%
b1nrihk_%cM^$=#A?ZdfXB1dIM+?]AG!A*=UgZab5&7]A<TA/TPY7DO9J+Ne9D'GGfhD@5(AP8
66b*l+TagS^b3WL&a@PNG)C=)!KOCT.S'eJ%bo5rm'TbAsTVN+g)=fiUb(dci9!oH:]AWM[.5
W?DPQs)pnU!'n#sg6p:B4M%dN_OB(/^8X>YUpje)nl@T4d0P9%u>5ctS0l9:icF*8W&P4be_
f]A+a3b4@2Mk+UjntP`=Zut\R`q#Ok+HQkY#p\8XKT[)3;JRj&9M?5-\IT-*IUhau#,q6HG?^
fiG@[C\K3GIGQ_%C;O/<C%\3#4l#$d747_=[DV7o>!RWR7aCr:q^2lr@&9GK(u<c_Ng<NSbA
%$>:4CrG`t6?eapAB=>ofAG?$B(_g4)/e<a!@o^VSsA8R@2f.[NJ'd-/X:77/ERo_]A6++&jt
I>h=E+d@/oq+QbEk@>?8<B]A_WB"]A]A5+X]AI<fbB3)D<e,3?!G6`5$%l0>p?P;YKWX@?AC(G0'
KM!p-+s0R*snN&O=*39Uu&s`fL9,)*JWgF^VJW_cj'9]A6q*klePKL^V^8GC.lSYQ!OqEmU#`
F\@0-uAGuGA[,0XHlS#pdP>Z87G[e3Fd;O+N7>cf*P=,0=i9?)d>-:/3C*(RAq%YU#?Q(i,6
3B(0O:5\r?C=JCk=8g6GsnO;e.aIn<,1AS6?JJOt\=&a$Z,d!Ki"KTrEb*gegIAEo`ar!,4n
54Q1D"j4Q[37qGI!pH=""fdI*/sS'D"s+?J.kQNo3m>USoO+]A,I`:ETLSO#s.jLL*66-:85;
lY>JnH%aR03.rK4L'00q93#ATtL*TXr@F1C;Ik]A?h[*?r8dI+$jY&"p%V%7S54bj8;>$mUpc
#OS#s6i"L[*Dn%B\(O"q<>Th+8<'^m/Xu@T,7k@noG)5;1WUMj2[C*-e&8s`ARCOiY`oh^@h
c;7IHKL^PNOQ*$VS+9P1fS-EaKg"eq>aU-QebN4&WTVkT9#L/XF-acM-?A800AlX%b955oM<
40">Am]Ak`)MhJYVRmQ+NtaWYD^.hj/4i:raF/(&'9X>fq@P6a*b=GneWS/]Agj;P"t6]A0-6*"
oSY5s#9tf8^DUcF=tPIBJVfo1EY^/\/2O7pdg^X81QAkD-s9KWqKct,cp-Q-JHc6Zh[Qg&Y>
o2]A?b*TV@c&00[AR9@oPcdH&2(u+*Z&!>XAT8a=U*`06ZM!n]Ajt(DG1PieQV-C]Al7<jW&Yd/
FQio9/"B%@@-L2E?m3ui)]ASlCGVYh^s29TkmV=G,?PrJPL)<I5LU3-KJa!m,[q=<;.kjP?0K
Ig/=r3Fpdl/Fmf295B)nk[,L?Of`;oP*e>/_p$%pXO3S+jDLX6+,Cs361Aigtgs4PCnW_lC1
oc'S,'W#<_1PLP$Y%2Flm?dMbZ`ITFGuMqM<.lT!!622C`7M,F2t<M#Ae0?r:\_^8+?_XHp%
5jf$4#>R7_7*b*-J,gknQn@Zh!7*!^(ggtJK!l=+4E7f93nUs_2*e?X@mEK@oO//g.9Wc_AS
iBB&@U4L,"`O"h"PG;?06L>m76$TjR>K,#td;d`Zlq4Oe45nm3FrA&iP#_]Ap:jeRC=R`!PqF
>Lu3YXZLhr3HQR]ADqoF^U@T_mV3SAHX^@oF*+_p_GJZ]Au[=$<tq3otU0>%+'-DDJSRajNYcl
,;4eL^^e:,99$,>I:b@h:r)<HB7reU"r3?GAQ"G]AG$<6-IML"0kCX8!$BEM%kA7ofAFBb?s9
fYcu31%%EX*pY9uUKpbWh=@cDfE(q]A@H',9s#3Ah:H=O5qYB$6sq*m*0CL5_lQS%hB)'0qNW
IFR?)nXP\*>A4(jkKN,:m8b%P1HA=km#fAC]A_\(FdW33*\P1L?7&s),.Y^8CRH')GfI;laPt
'4qFj.Gd_LF/S?A:c;oW(p2fa<?,MXQkN?(/!CBlcKb_r;MBPN$7".TF%&.0"!K@jj8G`Kf0
ik"Wo*<]AXiHS1jPK2[sP8omf>8gN6$QpNpE\(sd8O&$kf_89i,MT_DsM$JMe)\e&*>i5D?(a
INnD7m'RN=B1AR[laq&f/]A*eLWg_\a1%gYN]A6!,rOdeWPt\0<Bc]AN194F$3[r<q*JkU8GDkV
.OKNY&&nk6*_Us5L[C`nCV`!+Fq]Ar!`P$iis_10(K2kIN!6MmAR.0+PLl"VY,sc2!@&LfsDD
l\J9a_qHFJP$GQL-*tVje*5h`/s)Y$QPI6g&'qBSN_1l5L*Ph&T2/%Eo%rV)n1Q=DXP6VSY+
<bTlFYE<alX)GFfitXNf]AjNi\(?=YU2HG$qmZ[Dg"V&VI_lEOJ.gdr@uP3#g(osO6NnP:@u3
`mSgB2c$6%7<%H'1]AH(ASVCkQEP;+3TL15,b>%bFX.li1[*GsTRG0o./`<C%;C;2H+K!=h=$
M)QrXEo0'2H`%^5TX\@o[O"Pf2<fPZoLD1BTVSTQp',tF#hmO!4.V@.d']A,/Cgeboh#8i`tC
-dHV7,p*i1-G7Yb35fk_*BX2-EkG$1_'S;8ncKrAtbj`2@&HiEV*%((kf;ZjOH^7<POK)14p
jB\pSc5RU+Z6,CqiN!<$1`/C;SL*!jK\4b]A)nc;PDW6Q9KAbrF=:.d)To`OWDYenT3?O"^kh
B_I#A8eD;?-Ceij0^BVl03+%%!0+g$@/L9*YpD<k7<L)/8UC[QCbBN]A"e^nGjf;mHM48RF?&
<%jX/(';q`!`(2XkCp87UYd"fG10J?E3OB!lDqJ=uoce6("t_@I@k4Y\e%0[-(^U<)f;BO0)
mp%rd2S*5-g_ZAbHFL'3fP4Q=PG_M5&)dsBjl+Kf`7%BL:SD+bf)N>khn/dRSthS;qVT*o,=
,.Nt%DWp0$\r?:'foAMG4^i@1)?p_'%qN#:VZB(#1t&,l".F[GHI=5F]ARp1>br-K7021.SOi
<%iC(ZGVJ]A;IWZ7Ta.Jg2:6snG$M8%%,<j-=;6,]Ac"uB-2K(`h,O<kWdUDB]AD#UJ*k(rR*V=
/8Y>k<&rJ"X0VhkjM=e)&c*Y.OYui2b[hql(kkigepg0pYHi=[E'=l$"VtLpT3O)UVhdWB:G
\8er:RVniQ""p\K4o0bSY#1Z,q.HUSL8XkkU\:r]A1=H:/4-_(.(63/&HNf:0$E9^2lrO1g&%
$XU(kHq)F2QH^V+[&3&*S*`Y^.1#j3-(0Cr&S6B^5^12%p!h!i;@dS`fcsVWG,5X#<-\L-X>
c55sPD4`K68d!7c1\=]A9qJ1b[OBpH>%`/:e>Q8[\Tjs%n_XT4%Zos+5mA/2HQ97RTL*#c[Nh
J&ulr(@(XDb)7$?O!(*X5Q7d!&of3VIHbj<^qI,.Ueb=c;nhj/PjZA3V/)&ofi>eVm<Rq@5>
]ADmo&fi(&P&g\-[Vup9'LKo\*):_A<i\!r]AVF.(<^agL%SZmP[:ZX2)e!8ePmCM`Qfn#iY2S
<.#@@?m!RdG8tLGpAnKUf;5f)i[cXt1b*a@E\]A>Rg\%SAR>V8hJf<87i$*h,_&7_Nf&DE[(&
,t_dqQ3cYNfni4]ATE'3*3!VZHC-?a>(q^T8`8Ctmot2VIPt`J3WT!;%[>,74:pto]A!13f91u
HX#<MXemd`nIniSDHrEusXFIU(ldRCbg2IkTGWA_\5PAP^c'\C`Rg!WfEn-tLb>\u=+H#6q\
9bMifCKNpignh,'6nLd`ZNuoqU<Irb]A7rX2rm`7ldsRs4`"T9P-i/Ed(dg=Crd#50]Ale\_rq
86]Ao<LuaE-&-Qd!0I0gZE&]A]ANig!Pl#6@@M6!Fg[o8qEhC_^`kbr;c+YO6qRgu^UZ5$h0t0#
%n(Li-#(6YB]Am*8T'UpoJ^iDFZ<c/VU\<C$>/s]AF`.A>,"+/>4-h/'>1Blf=F?G4chV1`6+2
Gf,R1<#6"JSPGrG!:@>T2_@4_#>7.5@3Kl*54B5O*S8/C]AARMU8$g,=?U50j)3;QC1.j@_18
V;Y'u:^4]A)U=4>p]Al#)<6)[_.XRNlWlamgmLm3WM!Y*b;Y+qs.s9X28p.po6HF7HBe7RY7V-
c&2b<6o@1*N/%UgEg?msI2LGchWr3c*"49@;H>u;bI=eLZ?Pp\8"c!!c7&,nBl[das0,b-am
@$bJI^IkRh[^%*nK3f0W(WFoC:hj[E.8@!`ZW_^u?Kk7=_\Wlg;4=Xfq1)I^_ZI@]AQ_N7@=T
Spi*emCd*#gRIiKPCb>ie&:-J4;*cF!B`',OnHa$^b<83FcUInIhY<C8Wqmu_(>bSImGnF?@
ceN*7CF$?e4)PR2MFL4+02tK8!]AE5K331-D'GWg0L%k>KX,a7Wj>iH5oT&aQ(n?.&imYfZFu
5`E_)C$n'V6dZmm?5*ER.b#O$LD1<6$%2u8KcVJs>qh^*#E$/T/d$iTn6Y:F0`Z\pa`6d$[E
$g5+=Z]AH`j@Pa<kY1S)toFjJbFlAd<7%.44?<3bRiKhS+jbQaRK?^1mSS2mqRAb(8:,Dld_!
dJ55uX,Y$Y:$RUXA\XX;4ut)!fQG(-m3ciJTkfQWC8MQF/q_Afj)Oq.%3R!`bVRZrn*[aZQ6
%O'/L,Ib]A@"q4r@sMO)N3>Q'M(ct=K>T<L.(QoV@@jm"MiLe`9]A[Dh`9I,8)g(lY[CarYF#]A
HjK<l,d>_Z(9rXZIs)!1<X/Rcm6Ga<=<M=IVY[#*0hA7CaDp@M7\\2BIVm\;)e_L+U@?oF>C
_(hgF6IY;aI#Q4T</,,X2Xh7dd#qWnr*NWXZ$_eeUu@_(`@Kfc)DYW]A-aQ=]A@/7Nf#c#E=Mp
<aVG$!ja;Vfs,\C#ZBllf#XsI7KX8;8X"<I/p"e<5?DAnm:4-8WqYqZ1mpSGMQ%PW!L@5mN=
gu1FkNtZRt!Q4-uD1G;]Ae)=;LtoEUWeTO0/8<'<TPJ1`c)?37G1m/K0[<16m-#c*)KcuaGB2
l`ls!*Jc41I7@LF?9mm@#"2en#"EF6*@Z3o;AZL!K0Uga#B#W(Gi+*m79@Zb[RTJYT:QL6c#
;G`;fK6Z'7IZMR!6AcY29%4K-DXXEP+PL<L?FgGrnap,O9`aQjVY8A6B0"j8"/&3H_-YF97-
&DERtCFLn>hh]Aeo(SDhT7]AM>K<7!q4n_V!LAn8b4T;inm=7X3WA'.RD%U$9LAK\GMk1Hi(2?
<gCi29k9CbJ^'Dp/hATQrI`n4a9t]A>X#*2#TQ*F;9^X^skeP<=gY(BW5!K/0JICaP!+HY1]A?
%1&QjnM8XXtYC]A83Bb$09Op0'D$LR@%QRCAOV^H$92-oqb+60aOhE$HQan[4!^&P0cPAen:J
irQX!bMVpR4:7lGAFS;(1jMOj"j3<tjRTfGHAddqF1RuVm)eN>4<_7eW?1l8W@oi0++u;BP-
42nM67g!0%%Qu,\QVuLg(T=tLBNKcG;1snHF=`mUpA'QK2G`8Qk;9c.lPmcXY;tdB``hT;C(
tUJr#_b%,#;q%/IY;qEK/V4D&(YHFb:mag*-\ga^@@*lJ&Sl7*m[/R_T1hjWVBrQX[m6SgZU
"7FNBlEXYt@dRW3he>7>8ZpkbP-TG=h=mlJfEH#1-EuSir`=FZ@A3'ViS(3K!IOZh.TcEZ`8
\`=D$#-_GrE::i3^rTkeH]AE0cZk\,kE2/=t5mj/D<,%XhITT%hRupJYO>EM/kf6=fYUe'l6#
4YP,[mXJpP^\#iYG'rb*=LleC1-n'nm4QKJBe,c9f+<mUR!>-L!&2I7eTW"ZDJ;d?&"#:2(*
/GLU(^R)racHW2+Yk>h!A\<FK\E#Dl?C!is,W4j7A%9fqRpZhf@k#B/`:qFZb$LHRWcR&X)j
_YHC80Ekb8k")gRabY8<c%Cj5O-h6\tjn(8G"hlOqMlQ5f1>3:>TN>Psg`n\Yi(aGDqRhl\M
!b;MV;Ra8/+,=RXeVFXb^mIM/iSY:%1eor-PEGd[_KkFYZ<NreC:#X.aSY@lfU;,T`.,>1\?
`HtZPKtsRY1F`h-m5;D<D*JX^$17p\8or=oRLiS8A4l0O8qWPuG!uJk'^uYFa;ClV_&<@meb
!+QfmjMW2')nMcDZf_2'"iBq7H=2^DR=#?@c2*;DWR9BW8.4W&W@h23Df!SH;Ns<'d/%FHj"
Zq2J9\(<Y)oiB#WAP_Sh<F1t6aAYok<KHs)1gZ]A#]A\oalMr4ail?E7mW>e@-cJ"%bej8BId`
;<=c[s1o?j5\@M;>QP@[6.hs,6A_<ofm4&TQ]Ab2@g!Lm-e+e!d"c*$>G]A)8/60",5bp;a47h
X,CljdFGimC1?4Zn&2tsIE3"ej$?ifiTmGK,G^b`ol/NnG.aXr]A<]A@)FK"o80";c-A"lAin/
?V3N0M!#`$;#p!mc4\Ibga\iQ]Ae`]AI+r6f&MP[N[DuBT`..aTs"dlcP:YNIGI27jNS<+EBq;
%N#R"og$a'JX@p=Zf:"kKoN7IYjmIJqUu!Y8`$"0gYJjenj)2!r=ST$\?N!Yqr5S_]A?[I34c
7dr+TP(FUHesE./`rj@>Jl]AgRgIWZNU[?O@:d?<dF%%:Bm>N.4*gF'J&uq?%br<!G.L]A>?:h
o:.Q:b>^!1gua&Dq6-.C^HB$FTkndj>U._B'W@YCGa7Kg/*I]AYQfS[qLQF*]As=D</39A'9sl
'Bp4+h`U3&n('kaXg`1o1.JfVE[0>:;fD"h2=JI=(C=lUkh:7OGa7Fs>+d!0?(,k9n&.^PXL
Ro.ia\1aT'lit^32WWK<&Ts^[?J-e3VLebBLh4q22\(JEs5E"8?CtR5,Db%&VMsZO%B0Y`9*
2,u>d(j.o:,%0V*p>Si&adri?(^jH&i#p!C1N_`t&PYVm]AHE80)0.;/>;#0<*dgU$"bYRW3d
boP7'-QQ2CjO@2;893S=(INt'liKL(FbC*]A?rB]AZF^\FAKObiTlNZSV3o9\BP3Xm1Uo/l5MV
VZ4Fl(*n-NtIBlVD_Cj@pLU?8aYk*g7a'//O<F&--P0r*$B.61Q]AB()U>c@,jXcOR(LaR5Q]A
-5+$9Di3mh;;jo_Mcg_!a5)qs*&H)4(IBh(Y!>E4a<>GeQSUDp>DU#Tq;uH1#8)]AQfA%4Tp)
9I4DVXZ'k)*U7V(@kUN&3ctQ>H;V)mKL#dc?`W1BZEj67f)5KDnFAfrnsIrpb*P^$U-/GO$I
Y'YAsI@tSAJ3-&;-rYiUi7sAuWPuDhUo!FI4a1lN=EhMjnl=_'$5A0[dM]AG2QOaZm[eHG"@C
Km-b.9DgL8Ps@,A'2;HE:IV7GW!r&L>PL>[&\<JaZ`VqT4sn-,N4t:*0HhTldol9rF)dH]A<U
;WSMMbt(su+n,sA_U>u-!8,:g93po<+tR,=O>FnTRrg+mp0e<oc2EF)V]A&SsP^:s1>\l4=jS
\ijD,i`L0on*;+e<LNaZf$-]A^&Q+nUO%JoS24'A1WSjs8P[)pN95PZIaPGXdBlOjX=.*H[Va
<S>?B]A\&T-ap1"RbkddU(Y0:(Oig&GM[E(5V(/2Z`n\7:19U6AO,\g/XT6R,+/9RFS1cJo+W
'biFn1'KJI&s4.UhqHd#t`EUM=&P&k$WYC"IiVk.UOI>PZIl*%r]A7]A[ueYBSe0oH=0U4/;%I
/Yu)f(Wj((X@*=WOW>)Y>e:-a$eK!26@fj&rc>*PD)QllYoPc+&'[3'V.uD73u.$7uI`?W3<
`5s(3:aM5uhNCq72ODZ9.HTMGTb2VDnrKqkV;>=A8j,31AQ]APW,Ah!D._W;",TO%Ll/$W-0R
<Ye]A$ic!TA?O=oZ<VuJL?-#7hkM>*8!.FN.VA(fjoum&o(4Y=[YH"ne"u"S`/+#*G)/!lJKt
J((r)"/k8EH@F>rQ':*h#.8<m#YTQg*4V"A/#A2+?N*q$X1lLsYU24]AJCUYS]AdiNpYU-cYmq
L$1X>dX(QDNqOro?]Am=^-MCLY7\Wu=;cB:D!^1hc;-`3Mq8T><K@:Gj*=6pP`=I^;kMRi#B,
TUU<=WBYJ1-80\\';Th\\XML^ph?$G`B$8lu_TA::e<TI0\]AYE*r\G$>&b[)lnBE"MZcF(Or
`4FChK=OAnM;2S?U43H]A]Aoff7tZossNZp-+PNFQIC%3OiRQVtLXEFS?8hg#4!'\*#F&Fp7[8
.rt>X]AdS>I0qL)!Km9$6S]A@:*P1A)e"pNQ]AMK_,A_T5/)9d3H$K!gU:s1Xen]A=#/D5/aAZLp
Q%NjM59UYMc[[K6Bo=2Hdfal,9sLXl9;!nb&Gii#dRX[>@,%kps1a]A/SKGmSl*%+`-l:<B,H
!+$%!Ts2/5Y);A<IYU53D3U?29))UX'_&=Q,_]AI=&IAoDZU>1u#[V&'XQQhG#gK.@+:\i9Qf
1^;sp6<p1I,U?^L&V4+1]AuEa%>10L2G"Nl]Aq*(3I*XQT<;ra'm(Y341E-"[Iu'4^pK(h65j>
*k&bVWp12`;qCYd"bXI8J7[S]AeoFO+ful$ae<%Joub\]A!r;1d.R]A2`!"I<HProYL,?SiWSd_
d&f7H<(a:;hGV8T_5M8OWSWfP2Xn+/M_!J;B9%75m2EWmlVj^F)/\hgLYXlI*l[492o=I3cZ
#IWBW$W-M_UKXa)D>Z'#?Yb6'OYEJ09tQoOTsmS8$l5I>&^9F9KY=j-XN5b[]Ac!Z+sI2iT9O
60ssn[J*#6f`ri(NG88g/GWEhTF-G+C`IrDTcd;u(rUG*uH;TV19s[oHbp[Tb\83usC0/1#$
j5D%.D2>i8H&c:/aEhcq/qn'0c?$=V"f,(B8^i9VSYNk1-.3N/$UAP'0aR#:\Sm-QU^>q%1/
bhI63_eJ`N;bX^3:K0E$[Ok)H'%oBuXW_uHqR^bN"4)9/0chqOOC._S!&CMK_&\6K)'gcNgf
/o+]A_J*<0mr5M=e*PAG9f34?P/eYq:.Qfi_kM&u[SWPO*5uoqn4f_XN#?M'4kMkJK$eKMb/*
VQ#N1VS.HOXj\-BIBgr/I!%`I=:=YK>PFOhKtR=f>t?j?Lb.K23qo#=BGBVOHF(Gh63bO3^j
nnos]AFCZEnrrTek#GPnsLV,4&m4Bt&N$R;HE'O%t!ENfY-;X<#QN/tW?It3#0S(*Z@U[L(NE
=:ns`hQDCT@95<VbG6Rk"KT7:Ep"UYe[ajL[$$j`LJJlUjJVQ3-DjmXfcU!eSIpmD#O9p"6k
G7`YjF"d`kDMg3.2t]AQ*MQ6FcQ2^kR!\_TIVO6?P;j5MOmO)YIU0<W$WrIoVNr[,LjFk\7E#
UX$TXVu*[CZO%`HCPp]A#SiXFAW4VF()1$fno]APLi^=<b_<eW*-%[^6Y\X'k`kCRoRV;6.HGf
bq3ePVmrkk#JA#+4#f<:?d@lf)).IDu.H9<M8gCm'6>l:\`m:F^;J6M'rpoq,;KP2=`E>o\p
Fef8t[>QGqhLo&e_Ya6Mm5Q@(X+3Vf_NDGWXKNEPLHlIRZZ2>)kq5q=C/o&gS0OG7IbphLDf
h=OrR"(@On)Z2i>(%A"Hdq?`^(O_as%@`l0OZ$0'q,b(erN6tCSniiQ5:b97VdMCRFeu"9:*
<_Ag6Boo;tLo?R@T`9N.I9ZYl"_(r#o"F6^W]AaEV;1$5dXS.mkh_MZ0&BT.qLbrOeK/CW.T`
P&i\73CbRn4uEU<d<G*kal^1L<Lf]AJ.P9?)I':9F-/QWjI'ArDgsMe^iU>0o=SNNd!/%,g>#
13VD",D,*H`M;\GT[*fg=;O(f!nXs%qDc6'+!j?!EEH*Or.XM-pG_[IM"3q>al/<kQRl(/_X
IrX198Yd?:jN%'1JMd0:J:rk5u+omRA*.lLaHQLE8XX3uq>3\4+E/-,'e9LI77_g.3GjZ?;C
;+!i]A\;WdHf\)^3NCGbj^_4W:J3cp+DE]Aj,]AVHW1q4`[IGY<c'L9"9f^60J>^#UhaManQWS7
t;.$%*u=XUGqhjd\D9c_5jh&LjJYBTC0A+W2;^JC!ar/c,K:f(\;2_E)m<(na$U4hf0O%9V^
H!J6CPQFB?s%.aE-uR1,I-T`L52.REI\BMP^B7o,LE7U]Aikju;#E5@5L',AB"aHCsQRcFf]AQ
&[/iSWK[7*-4%'&))^`9JfH-SJpN_$@FIS9orrP]AlRTr__tXIER/UnsXCK:7q:-<g9(qKpQ3
.rVPJ!Hq:DEf]Au//I(pBMnaJf5<hJo3M**9.m3$&bcaQSKSG#M&!<cZ@M$&0A4GhBg_pYU#B
b,1KZY7I!9WFiR]A:k]Ak'p>lMEY9E1G7US+r,P7fG\4^O>E+LR<5R:R"%@Q1KVA*=Vpc0hG*;
BVY*0cJa/]AiV#*s`LIQGcVl=rK848+0&a1+*./D8/+DL26LjhasA(3KNg[Wehal(f!TGh*n@
/-G'gOrat;WKZs5mMCVCZY&'Hm&$D;neV'1T;%fgbM-f%m7<<XqIVb&eTWiB@E_6hF]Am2,73
:rV-WUFJZfY<negBL^=bGL9i`.u[+%q\p,S%GQ;^V\hoq)UsVPnHOcY[;V]A,p6S$p84P++"e
d$/BNu"#Rs;S!"[Zr0?9:\snlWRC'_M2)qi=`^jk39N&d2FkLquWNEqkYddML078]A8i*E[t1
UUX9qWGu%D6!i"k13=$Q4B4<+prLIBK<KEG_[A-Xj;b><E<@_YM'!sIIh3D2pj)6-CuQY'qR
E1pe@\gqI\&Z[ulHe5"+HlW/uEIV3Orbn39kbZK!FK1D;=I($s4`P47lX[D"6&6dq*JhQLb%
"pBK:e:Oo]Ak1Q%dDtDP,]AZ(fQq3f"BAk0Ch:FS(+O,oTI<8?3J,c7PcS,)ar-dV3tOE43fLY
NoqH1Gf"\)07AqWPqRF0JR\&^9/!.Y:DRfF#X#n^_MEf<am+J_,<JU)&?`$iH0oS[lWt,EfS
frdJ"L@qko&;fD@BH,_Hi_3/itQ\_pCkc(F8bK,`R:'A(-'N\1Km#!$OFH%caM`;=IFckRMO
KK7L:Ygqt[V:GR+A&hBT3!<kQ5eNSCcf4-7M_VE/9kQLpl.Sc43*kBfIMTX/&6`.jm?(b+/1
96E]A7<7+5kG(plSKO!?LpYBsoS2H6<&k5M*?nE.6BQ<(?WP-H3rLU8mO(GXAE\67EtKU[eUQ
du$5]A'fKW#n02&TF`mpVI"'--R.&Kei/INr*WCqd?/(tD#IXEs*NM03XY1hX1cobd,P'p^cH
sDYf8#mqLURMH'?,OtER`'%W&SAAr;5_b5Mo_^WE+4Rp"(68/e)?HQRABL.iOo4-%7\@s1Mo
Ag+DCcV.BK5ekq]A>X>)cIif[SJG[]A:?pA)oRId)5+rk5Qt+o>dfrSd9F)gZ%e-(ej*3_J#]AD
&S/?6'"bgD]AcP^qX"X.c=pd4^=NR8l2JE_g?(G-?Wao9meHM,O`s.Am6/['MpmT0.W%9B@)q
[@i!8N-mg$4*#`fiEo+PETE;ca.+8T!"MuBEV7pg*s<V9q=j-+lEmXtL]AO94S8j#=r7?U+1t
1+3AL]AK`Od#u,%"rU=,LoASk0CU4\MG:)@Nej9f@Qg`K)Z%+[B6g(TGIsQ'.1-F(p*_nk_[p
U&"\3.j?&0f!SY9q_Z/pQj_.4\HG<eL=6_<'&#^GYTI),'9D1NNqV0XDX>2E+%q4V?\9Bo6'
[&q0"DnG&a1HPu%uQ`=HkPK/jpT0<!&N>f:r3k:p\b]ALk^4*f`!L#Z-G<2(qG9$(a7!'Rmt,
Nsh+CD'R.Wrp3C=uJWiFb0X>X8%4Rj&XW`l+QA9"0:0\W%06rqL!F5lD(NZC_&t6pFY#g`_m
>qnf1k_?(o^U6OU4r#mK.>PiChWk2ME!onrC.c=Z@L6gD4@?ZmL]A\&^WfC2R:a?KV9sVJ4@N
NUcV(H>IT<dZrV"j%O)5_<pH`%AWeUo_p>1@m2B4T,[^.Qu(c305Z>[g]AR*9Eq"F?JR)6+=O
$r"/m`@j$BK);#0]AA`maI`i[^KX2T_bu^de$gO>66j,G#jA,DXVZYG-o9(m:^^]Am]Aflb^UA/
9p>U\hoV`k(hUjd_-XhL[Tg(97-BoS?dS9N+hII&>S_/1^+Vu`$&D<54T\BEJ*r%ar>aVId<
uRXnBiDdf0s?>m)cm@P_G2-EL4M*h;qKjA-5<2I0QS>\/8.]A@l14eR5Ybt<7T(gVdE]A//Pjk
9,<pR]APUHSR;o_ReCh$#/5a4Z0lpN2To>kcB_<h8WrG.$&:H1e.cmF!SFEVJP_h,!!q,\_n"
*%rfAI$%;beTsm7duNO;FZ67$oPusJd%\_^_"B8!lr+_M2%(,$n]AoJ8[IgPDSbg&uT\aD!a[
;<LF+?cbdO2N8=gSj6N29sf:=935q//-^$nZCrMLDn.n+PVZMKm_ab<%"4;s:m.f?3m`>p/e
<N^7c>g5CApoZ:upX\m+uFZFkX?pGU_octl-M8&ArmK/EWc1!A[9"8^E4?Fkufj!g>hYQ*ah
C6/afol=/BLZ]A\+!5NJ=ceN</&t^7p4:usQ`]A*iFq-oLT1PCBNAt>k2XHAKcijk7eUsNbO\O
&JA`')cGqDJ1jb)-`ns&h4QYbECQr=<Ekc\9i#-*8XnC39#^6^3$gn0?-%m+TR>48A:r@OM;
B1Jq5L8rS3A]A:PcmH]Aqq=J`tHlEXV^,0,-f;SAQ:8D_H9K7ISM%R"`j`L_56buh&886`@(AA
"JhZ_JD8YiR_bGL+".9l!NX(oB9pWCHmPeaIZlA*IT;k1Y1;Zn8c$Q`MC32qAr0`GMTcHnW:
e,[(b\rd]AcWK7i!5dHdjM/cE$6#;a8ihYLQ.h$se33pLSgOfj/3A=ZL*1/q#g+m(08Tq0M=S
"nmnk97)5F#n.9'4#J.FJ!.%=eSW!h#<rBS(-PAs*'&P24&Ti$a<_<ENU`1kEWSc'kWAon*t
3kfji5&2u*\tm"0fJW-?i)gcE)nPPT>1OiCZI-Bt!;+fcptrd@,dn0%aoChBs853J,.'CKDL
fPP84K8'5P^6S;EIJAPI#=q#nTkJk)kS_"jbjs.AcIfuV:b'?LX6gcoZal(le?93NO">p1cg
ju8qmtK5%?-ULe%9WTs,J(\c;,$B=/ej5gpj0Kke*j50]AMU+^Tajg/e:TI>W-$OHq$Y&pp0K
on<2YF_Ad)]AVfT^ZF[sthZjFs9:)D78_7:A1:B]A``oK2KR1g.WDde=i:=fXUs7XtBd84W4E"
LkYWSU\:;5sBikbmg4BOQQUtLcKnt7*fRF^VQJ1)&/K]AMWO"lM2eCV3BEi:\[Z);CF<@TIt^
*C(=poE;nSRb9lRPX?)_TuD3.-=/5.3j6a)`DA#6NnIUjgklaY!WiB*3KGmn2\I`6E_hO?0r
8fLCI6^2W5FgXaF]A+5ul0H@u#Is=m0#RM<[2QB'E3WB&TbGnZca7Es$1VH[Og.*ujl76B(kT
?PD@NWX?`L9TIVSLi9jGT:fW0_[f+K^?_]A3A[S+$)GH2-e"kYh/ONUeNtrRf@`YH,gs6i<j%
'iIeH9`#$SK@O$_SpQZ6u0V=eInZF*!*9aWrENf9r0&X[KIc#<*rE?'eTG:r:4e<OY]AQE937
p2G<s6KKlnXm"BfS=.RWN3^P/L5DC,.a^2i5K>V&1Qk`9XaU'Z^A!<$(I*^qBgL!(5LV,C3Y
fS?Y)+g3po5M4!eN>LGbZ+qU>nmChbdk[b!q%IX4e7T22P"CL;q-d@jb`dk:K/rm?Nho`*:/
F:u'!cQ<mF7b29K*2T._LL#[0epkP?h!6[3q(6dd7BOpCcg'4+eT]AmTO0eW]A]A!i_rOW6()-)
/Z$p%FT`Jq_4`UNh+=-o4S_LTU0N^(b[qrLA1OT5'OHSOB%@S5=Mr3MV%^LKD.r]Ap?;ZSu_d
$bH\2tf3LH!Kh_Q.Y@XP\:q]APu1CWPb\D$Ak9CDZ0LZ&tSJ&TC9EQk$2h?D]As0%$?'e&2&>&
#!=m#^Nh%nLRAiMc2\cV*5@1ID1LMF47GGl*l_75)&kAhY`&m5&%!J'AKN>\F2/W%0#U"g?U
gX(jcma^Zf-Y%77EC':meF@i^KEg>`IDqFf!ofC0P)"0*5s*&F*'g[dN!B)LKBs"]AjJ__BQI
p<k%7VKD+p$Cmu:f*htm!c=GM6gBn]A8a#HqYAD'Zs"1k/efN.oA\`6S<Q5o)r/P[fV>e0j0F
"5YrChg)9+\\'LC?:0[O`B8J=m',iH&q-nQ*nE(>lBX#5Y(VHf!#V&*B%h/^ER#D5JbU#SBV
-nEl-&<aB`o^!Fl;o)7BKc_kQB,8/;.hZe@3a8`U<lBcEID\QQh*c-*X@<8\J85SfF\!+jnJ
%tY!534ccHq9<=LWQ]AZq]AO,2.mL.N%:mlgqr[.jVI`]AIZDffD)HS8TMA]A/48#G3u[>mq5TjZ
/KN[JFFScQ\V`U,*>=>ilCTQuTa$OQt:lt*CH'l9q40*dDBG!TEl7`8%dFq7Dn$n7dMlZ2Js
/c3c.K5i&^MHD$(!O7dY.\XZ1%:uBD;AQ?^(ZMYQAcrI3p\a%5`Q.[.3VMPZUa.KKj14B"T@
/%mMq>a[''1R>3/lOi:s"8'Nq->9[JUs_?6)8p"an`+Qn0R.N%hkYA-rPK&:e4Cd<:m/,sRT
uc/RX95kCkH?tBD'/'!iVk0mc_/\\]AW>JPgk'cE"[Zh\!C5#tQ6&EA9TSiF\n),l.n,P]A4"0
X>n6J@#_t?rR=9=>]AO&mg###8hSEr.BC;+emd*A#_m:UE?U\d,F,Ju1-W71O:(*67l98[S!1
4!p(Tab1[Q!-m$:l[X:f>"lbai:B!MPUP_6l!:)-W!Slb/%*2#SD.FR"=[bQ)5,:)i)qZ&t.
>l8sXAp0V1*:j.cZN9AH@@i:JL]A/cY_iPrWG$l%pi%3*(LZ8Aq;[JaiJtj+(bSj\Nm2"J<:7
a@bB"Uf4.<A>R!CIIBM),bMQMk46".L&VQ.[SADk"RM+701FOa4e`@1&*q#:Ra>jKHcI#fB<
[C_ZOn)KEoTBBLtC64,^oL`SL>2FHQM?/S`CXakU5S/U`d<6Sj&Cn`1:WD&IT<]A<IT<n=TBU
iI5bC**;k:]A6t0PW6KQS3Z(APT5d2E29PY?9*/42a_UhU''QDE"$,FQC^!U<f7hB<m*asneK
]A!*LN:.Eo3O2aV8$>W=HuUak_hKX*"1a&1Rc.!]AqkkIW,$AV';64(UmB'JF:QB)+I1:)$^U$
qYL[pB_nCspTk)+!GQHu,AMs3L3-J+g5idN'$lU5$2nKVQ*=l5j%L"2E^>Kh0*425fJH.sgX
K'ik-2Ls,1%,GnRiIj;lLl:/s@%Z'CLs<3mgi=Cn7BC=8FgB=^s)qTjd4Ja:oD2Xg/*[Do!*
8UhUbjg?2rL(f;Df+cqGP[mQD^&k"_a5rZ\*jb%,<of)5,1DF)Z!fcQ$_:p=s=D\nC9UZ%N:
3eAbN!\W%[(L(eg5I:umD,s7Ed4`-4hMat4EjNbN1"b,@s1]A=8.$Eklo3u8p+QKWPl^;saM^
PNM]A%sJEZK`O*U,"?cPn?D'[F!t"-Z"G+4ceDi6a"LXGQfW^eJ=-`-GI7#b#SE)NY(fm,c_@
hrm%mT84@De-?!9?M"t5AZ*tFYriPYPPA\Wpk<(^m"]AcDrj9`rd/`*X<-Z7EHSFJ\fX*i-8p
W!Z@9hQnLgoFdQ$(+YEPY%'N\N#H"i\VH4dsC!R7VWQ5b?]AQB4r.HBdXFGh".`Nn9#[EP!cQ
ur!Y`NJY%sR_klBeDL<N1$3fRc(o]AhDA6T7;YaEN>2H7f\!(sMt;)nfK)<&VDoYe9J<2Q1C?
f&c5_WCrkenC@lT(5E.9NDV/-bMZWAg\ZX;iZm:J+!Ll261+AAu"Yq@+__W2;hTq#`6H;pL=
GYrZ)'FN'1YfH_.%U@C".0Gu\AfUjh9jBFU%`-k@12D/of0fdR>0D@SJ\f3ANP;7W(#11G&3
#V&p]A_oN$:PGS_$\qr())2Qp1<(J.))*^#$L/HN2A[V5('N.V&.5=PMUlB$iZeF,D4eF_CVZ
o:aZWaJTY!aI)q>b%RBCHUoM%%Uml<d!l6kP$*Bi'<8,DdkkA_+-%b&#umCu4adK:;nI=70[
iTdGeOq!D<1T^8\=-*[%3c7[a+!tu5(7M]A^?\t]A;R_'='\oA\r'BoJr6HVe]A)`W5>#A:[6Z+
Ag[PfE'_kAId_E@pX74M$lP)8$gSMBDM)rg5^6hCT6AY@'0@H-?`_m>ofKVM#hfmY@p"S5r@
^$[b0;Z(0(3HK+_CF;,A0CD1ROk<3_'rV?[1#\929WB9^E>Vhb\/=TNQ9.k`7K(C+O*2/D^5
%(VAM+1gBka'>;.R33VaXH0<M`tM`(FYjeVKEfM3&54"#O#sBJ_CYm:0`_FkXKWl^ojsg>'A
b\RgGn-nZZA7G:^&"9Y`+WCLfk3[0c$]A6+2Oh*MSL+]A[6[QmGKCQ!dk:fK(V.j&ELRVA5?U9
V))<6Fa@O^%-%f5*>)<Jq.QAOJRMX4a'VU:.1lRTt&mB32^a%_aFFj%r'klL7Cs[32-&1fDA
i#i,4P>tQh_/)Qhf@e&m"-^%GZkpal_eYL,Ps0:28V?7MCo<e""%9tI`%s.(8)O#6(SRMUj#
+C_-&I#U,?@iedsAd9[ZDD5EKDMPYdQYRc[7B\dVV]AJK5KkZMQ>/2Je:DO$HJbLL`=G*E[C"
5\im6-HAqS0hkhF_IKBd*+4ETi5K39J:/\&lg<5T\-C(ALeu;JO/URB?]AEC;0=h%tD!eb]AMH
cYP$nT2EKod3m1sC-AjhQ5N_hE\RI:gE@5fNi"Sn$7!:Ol>0hDM.04PUSC+B,ht"b+9'6TU^
nQO>oT7`bF4A\,#/pNoK'9nK_t<=&7nJr"o1fJrk>!*gV#c5hS`R3RS0SG&_iXAN7:Yer^H:
0,sMPt544dEY&,5l`![1Y<),89LAgD%\_Sr#V%NjMqoNdtUGZRuW^bC2Wd_WCX[5KTVPBLR%
TiNq-/s>B!co:6`48)1a*;nMma.Un=1,@#le'h_C>Ml!j?9AkC_7d6=0_aDb&g:KF?_/9;!S
$1mc,//:uFke:.uT9%-=!f':eU$2@`9"mTDZ5jLD!J4HSI-&R9ok^.g:"V]AJSu[,:!j8lNR+
&hA@DQ>_>/"/P0t$<B7PJ?M?uJDK(W97g]AQ%-gWN.qd?iq'Xfk2*5:[>SMf'2BY+iWn&nK,_
#]ABBa)qZS\sW(Apb)KOV")ho1LF<s\_IJ!`RKL!jrbntuTUr6@[C`41E(Pr$_#+/C24BW?D*
amYN^IsWQSVH1@(jXOT@GJ04ej2EG"Y3%O`A1:^+B^_G*Y@k'*.)Pd]AK7s]A[Okf".\1ek+O'
Rh9Ne/:RNM3pNc(_6XqO_u8U_RbbSpn:JMB5C:@hO-1qXZ34>aaI@&@nu2>BPgXDH*g85umd
G/qnkb#X@E/T('iRjs'->%5sd;4giKp'_,\)S3)J3eg:d90AcjGTf^26O9`[*4e9%U\e.T>D
[(nL81chRLu-olX,*gd#FLKq^;-[>u7OYP\;`9j#EhGBq2Lb'SD8\QfF"N`D=V(:/n3WR-g1
kj]A(U-X*j]AZ5G(u$#Q_Sm.(URZpO&"Dg6GJrjT0:,<LO4jpeWMiG#31TdT>!%<V5c!-GVl$6
=p'f<2M;OhG83COa3n21q%B2S?&#\aW&4)rc@C:E`(oD#Cs-]AgK!/A3W2m"di$-/MZ:P$U+,
a$Em-(?(%c19$CR#0i]A^7t'%',VQ*VIY6P"(M[!3d!0T?a<$X![In]A:8rjZF59hl9R?7pmSS
.\\IQL`?&Ejc_'N^b50a$:$9uV^mP$.TT+nlgfD8p$eMB."nOMM2IL?iR!3RTF`J&9S//*6>
Z]A7RG?BFZr!#%gEb"FOj@Elb#Sqt&a1K>0?c1:Wu9`p/rm-Y+j.bZ#A"Qe%bh.QB8O7U!KlO
cdftuMK*St)^_WQ=i]AluY$bl/F]A+k-Sn03K_-#nR2OL&#2((S$M0N_[0p1[No9qlc(3dnk%b
]A"05.W7`_%#>,do-C@m+L\t`bD]AP&emnaEa9UJiRt=Y,REbAuP<YbrCpt*OeRcZ>`E^tYS`,
0.-TOhB).\8QM#Ru+$p[AOqPhaXjCD+5Mu//^+=ZF4WnZGeHVbWc5:&4ZI,sdfXm3[o"\7Oj
KZO[/YBu?LpbcO\mpa`mb"r#14*O@G:E#Ub8R%o5/9)U'2.HUS@RnEShu,od*o3brnc'f?H1
!m@Qj/#!fUid<a1u6?+(8sETddTYn.^2maAZ3>JR9Y1L@T$9f2*Ltr#3_QJR:ci2"5;!ekdE
IenZ[p#(@$CdD2rZ4<!uPPXbhj7ViOqdD2rZ4<!uPPXbhjL@T$9f2*Ltjj@bTL@T$9f2*Ltr
#3_QJR:ci2"5;!ekdCsr#3_QJR:ci2"59/Ns:%Bjj?mGNRhknNs:%BjjClITfi?^k9/)&;D.
e46P/qfb9c"[>?hf8rc*o!qI]AY0:T^#&Pg<<Y%NffkTlg<1$3(5~
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
<MobileStyle class="com.fr.form.ui.mobile.DefaultMobileStyle" isCustom="true" borderType="1" borderRadius="6.0" borderColor="-13395610" iconColor="-13395610">
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
<![CDATA[=if($para_viewtype==0,门店分区.SELECT(VIEWNO,INARRAY(SHOPGROUPNO,['QY01','QY02']A)>0),"")]]></FormulaDict>
<EFormulaDict>
<![CDATA[=if($para_viewtype==0,门店分区.select(VIEWNAME,VIEWNO=$$$ && INARRAY(SHOPGROUPNO,['QY01','QY02']A)>0),"")]]></EFormulaDict>
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
<ExtraBackground initialBackgroundColor="-6891594" selectedBackgroundColor="-13395610"/>
<ExtraBorder borderType="0" borderColor="-14701083" borderRadius="6.0"/>
<InitialFont>
<FRFont name="Arial" style="0" size="112" foreground="-1"/>
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
<TemplateIdAttMark TemplateId="f441f4ab-446f-442a-9585-fc17b05fa267"/>
</TemplateIdAttMark>
<TemplateCloudInfoAttrMark class="com.fr.plugin.cloud.analytics.attr.TemplateInfoAttrMark" pluginID="com.fr.plugin.cloud.analytics.v10" plugin-version="2.3.0.20210831">
<TemplateCloudInfoAttrMark createTime="1633678816517"/>
</TemplateCloudInfoAttrMark>
</Form>
