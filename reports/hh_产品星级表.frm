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
<C c="2" r="10" s="11">
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
<C c="11" r="10" s="12">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=K11 * 100]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="12" r="10" s="12">
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
<Style horizontal_alignment="2" imageLayout="1">
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
<![CDATA[m(?t5e*5FBlASr8;$7o.W5+3e,SUQugAn'=9#+7<#Y58X&0Ope&LiS=!<ND"6O9=kL(5\->*
'Mq.kO*OTngETR$kX1[X6?5c[2g9STDL-M]A_T:s'C-Pf"0Hgr47IQO[CK+mG#,=aL/'MN:uX
#!8+c!^XZ*b)1N<M3`ie/?VTmp.i1p-;eE'@Df^K1f;"*:G`^&3H$PGmk%4R=:e0%2@>:np]A
koGBr-UKNaB1BKjXA'=2]AmK+;LA`/@!b![HgJ*r1:9a<;5nBjCla_tfq_3:"5D[U^36h'g-1
FH\<-WGq^BsiC.F$hliO<;Tu/ue9r>32'YJ#$Er+bB90`CS#At`7(h8^o18rQX0PaL)IkYs:
a/*.0Hh<nfI!ii+^3J@?/2Xs6JR$!gr;mpFc?4&s9h(^.0jm;0p?>"(R68f<Gc^c8T_dYrG%
hGc!'P5dB?%J@g)q),A-CZY_RAHPahaJ/W]A:ZkEgJ/&Q=l]AqG`;4lCkoWJKQ3#@h64dj*Sml
>6nCE#cXgHYK,s*fZ-8K_S'8'h-&2#i$Qg]AMJ+P0G=-).manXqnMWV\QA7Z_?PF7hgj-'p&q
jd@?2#Z#n+V6$Brppd#`gWkuVjIF'P'K^6?Ibc,jQ.V0VI\2LaoZE@XXENs/L?9+pTXWEiS?
=Js%Bo-i4ErXa^65I?>a-EQo'%3T2uTrP"Fm![edlCYm4O$7i"1GF/X#^-.j:P\YJa"61%/S
%ur?CYSFV'8//g9a#J*(3YdH_GK>L[GuN_'a+\J]AoU`sc8a'$>V0>Z-Dbi'D$Wr7T%QFu\pe
*XHh^G4hJcfGJ$r*nON!!3iE%]AOfApd;Lrg2]A,`a;j9Y^S=<*Vo;/^k"XGo]AAG61OKX#0eKS
tpaKOu>mHmWG3CbJEC^\*?fNN.hOIe7SD%>deN47O(qa3sIN@!t@Hn.(h(Z9lU,k>\1.>Ef0
:Z6QcDol*5/\!j#b#bn3qK*#2b_:n]A"QNNh/Q-BhW3h<0^U^kre';5QXVsjVEh<>HIg&]A/+3
p7ObPMqjJgo+,-4G_3>h/rqVnLug.)3J!SPNCXN_h.OX)E6;)o'X;)IN!OA-5"W$CmfrPq&:
+(T0kJB<VmS4(VDJN)"163K1),Hp.)*I_Bg-P3;J7Wc^8M!V^!d;TpH>$71u+XsDq@Ppb=c-
"!>jrmLF??1U;8#1Nbp`]ALJVa'ZjT#4B_ZLnnAmn">B^$-gNONW"5E%#1MGc@<rXVZG+)I`N
X_Ll>",l]A&ff&XE!%sQ4pS\1]A73ZT1`E=R8Tdfl_LW8NU$eS0Vf/q)_6oVrZkiB[2Bq+0,mg
XR!N%K/l1n@rR415Ft$c@_&_r,qJ4bAaNJI]A:AoA1p:kkp/:.3=(4F^E?lb@68'p3cKE<^_p
qlr<omPp42;j-AG(9d$Kd*UiF`K!fL[/9U3f3`i_K%1k'Hdd*9P_M[m_*SAJ)DFA_@Rc/obQ
]A6]A[!g6rh*bS\MQO-tQd@Ppf<&%7?)JmpZVjF(AJ%6&`W$d:=1BZ7_`3Hs7De*XlfTQjGa]At
)hU094ss4;L3"/XuKdEL=RU[fCF.lR$>b1TF=TS9WGHrJCinY%Qi./)tKcJ+N'aTC>+H5H?^
`;tR&>d\>:CEd,N8&fFS5&?sluJbbp7W;2)h:=Y+0B=&Gql@MV&F(T5E"$p7cmIJ#q),<8k]A
m,^DQ&(qoUf/`%h`2_=07Xi%D;_[e'u0;0`<oi%$k[%;D:eFP$2?n?YeTq&+nI%6hQ*uf_To
.j-oZ+>LBgNdpV_E\(mh7*]AE)tK6#>]A>f$OH8\CP?QP`44\%rB!g1T:DEjA1?m_[=_;CLMkd
Na"$_>r53+/';o95us/K?8;:M[I$X]A4s<A02tQZ*0TMsuA.@$iBL,D`*cNUqgB%$"bUS`R`b
3K:W<U>meLB*ZKpC<@2f9CWB`5P/_uZ.b4;PMn7EmAH6=oR[>]AniY=Q5NemLaShs6MQNY%Rm
/Dn.<Ka1?T7FlIG%(u\S,`B?$K)mAaTMmNakLqEIM[(s=n?&MR,4AH=,>?[L7Z.@1!NhaNOr
*!?C?6=mFF1FK-2S-S&=pt(/Rmg1LM3!UAFmB\_+$66VnuGXIO`NV*HMl5@hbWuRjZK)&]AS]A
<Tjt)Mu\raL8:1?G-!'DBPh8CbHHgu":e5OoZX,b]A/p;6L^RP!^,NX,^ah9R9JDBd^h:DGZV
MJ'4$KTBcBj7hPMRe&lPWoum.B*S6NKU?f5]A.8Z#O^lp>dL2Q*1nTp'RWYH\!3us#SEaH\7n
=*CE[&9"A+Lr\gPhSU>m?LNB%_'I6,9f_o>ftIZ(*Bn&ka]A+[CP?&@T\?[g0/G#e%j'r.!nW
50HSFW0]AT1,59@F3b=4-1<t3/OBq3Q#EP:SC*^H:8G:84d4;+F5&sc0:GPLY4Y&psHjp6TWK
iG-l+:7%PTNK&'j/3Va?cQcJUH/Y2T2Jdkm$JRP>su*^Pu]AkW%Ar$`RKIo;#SiTV]Au[eu^`d
0[(H38.^AL)sdA=#P/m12m,P<6rBu:>@Xk(4Y6V5It262GLkb+3bH?r3Qc6b7]AUcpr[YcP^%
e`lL,VPm%=O.>*b.]AtT-)ML%b[E,8W'iKJs8pPi6GeSc-7&&?#/12!Unr;$Ho4=>2Cge0TQ(
^.>oY+HqdJVHt*:5?;Reg7uB$`Mdj,pY"png<.)]Ajch9j*m8eaQGD<D040Hn=M<DApYsV^@U
Kk3K%B&C&r!ZXXE!+t%0t,I65:2b?W!b#Tgt%4S@E6&YU\f4OmfqpbOEDSn_>W=&(E0'K[uD
)-+0g_65JT62EJeLYc%P->Ll6I!pja2LhmM.X/"]A`U)?rJ4?\d(NR.V$09;466T`<_fm\Y+"
+Bb/b27\_TCShd%0@9YSiiJ"*#W)':j$@cJYp:sNYJ77:YWRL?\e<i#2;A!Y4BGI$GIH-<h#
rj/esbRaM3THc(3G(eW&Bf9gF;2X2gIKDeST8f(2@?c2u(qi(^5p8+HjAl_=d"`r3JqVX>Ck
=&"*UpiSopNi9%b6MO=;2<d4E`>K$pf^p#F\`K:*%CsVRFg9NfF*phtd'H'^C]A`UB,O;QUY`
SS+RaDYFq^_RhG&[q;K/=*)r913ZbCX!aMjgIOO5IFJ\jahYD8E4Q=*UZa0-CKU#<49>r"EN
#`!2Z]A"[bP-VZjhTq"N/ZI#SH$K[,QbdAOUKaU[l7sA)EIZ^#.).:/8RoeNAo?6:.j)!8-eE
dRVGJ?#R.<@,Ct(T<Q0]APY0fd_6icQ@_bsCeUZPf?+$t0"]A%BfBnSO9i?<)KM8J!L4eSjX07
^a.?%LN4b\AnVf^7ci=f<H8H#F!_<Fec_<AoG)bTa<[;<3j:1TElOs,K9F-Q%&C9YK=FsW$=
$%I&T'K9W;o<cdO##7oUq^+[$dQn(F*C9[:3d1ESV]Ab01u.X2J4$f#(`Roe9[q8(q\K`ZGeC
nkjCSc^"T%-i_o+#"ohGdC*'JmqYI-UJ3aqE_3%9fRP-)jbKUZEXeA,4J[@:4Y60BkfuUO[@
5d^C(Iluo4B]A4ZLhHJA:57J4eZ_@<+ht9>pSCf-O0Ih'UdYTF#;Z/aQ.D=*-K_YF4;gmUU#9
PI6?=;Yo@8Xuo<Tb(oqShectr-,>GaC\dCGJpRNcAL_O!_\i,8+'6Qc7:`ge,`;uCa`5\DUd
Po4EaMr/fe<#%i(%J/+MYah0r>Bh:oH^5$3rfSS_F%kHZOS[a1ZcbPk5f0TXE_3t?-2&?[F_
>4>@b6br<C@A>i39XbM%gpGZ"q%TZGnT[AlA8R0nRMFmccHsb9"b/2me?h<-/$5Oq\otL'i0
,_GR=]A3-0'j;TatXBWP_#[*TfZZC?8Z#rBa[Z"\Hopp<bSNlo1oX$\sHbC"@HNN5[?K1Y6E?
#'>J]AbmV$Zum6,_QNmCHugdj!]AGsW9_DLtJ3jlM_DN6%#D?kH>!91&8DP^j<(#WfTDZbL["`
703H1@t,j76ZVY<2\gkHD3%)Qih+Sj/U`Pr2AQhNdH!R$=\%EG:\JsNMN_Nd!)I')siL0BU.
5ZOiA9KjE'JYDXp0+?CcJKH@=Mg)Xf$eNEQ0/'Z4PsF)qnB*SR0/]A=h>?C\BLpg+uO-3)^:R
6JNV7)WS1F@TuQ]A5Q8g7]APrbtSSG=@'S<:/'en8(74+#\#X&$R=]A!(HP.n,A)7\5qjepDlQ?
PBu!i\Lj:]A=m(d+<WM4]A&NM$7YaOd6eq>/-`9F6!^5:J^;Q>R8A)j'_*_Fmt?K6k]A.!*r&<_
(Q1T1N&Z(?\\;(3<_LH^9:(Bjci831+Rr1lgDLn5k)S?;a%%"8er=rm5dn5qD"(dqGK;ob?W
]AE9RXWk>e,j3JJlGK;>b/Dh,KsMc]AcakCEH-UG**Q-!l]A<!8Pb@dE%h*8J(9Uh9t+:UE(3sB
>n\0F&]AHnS5\VH.Him]A.R3r:1i<95kjEbdA'2<0rcIdNeGCr/_i&pb&d#dkocb<^k#.s6`4K
eShP*7_,H]ApR9-Z=0Ao(ceAZ2/DGbp+g.:R*ZfBCRrNh"+s.8HYpBDpsnEH43@l0kJM0MXno
6mt!A!,-4!V''Op?3Nt:I87s=731-[+IAL/bF1tAGK69eG2N&ro#L`lK^%ZU^,iS#=l0PUO+
uNJeG.4IJ4Z-4[1lmQ:_BMrS0OPJ_'hEV`Z+[YV\#[Oc]AX$EY\tEf@o#K@$<g30WR`Q2?DY#
mED<#K,"O!s*#d]A\/AhGVSXBVWt&krNHGir=2HPu1T@qpZd^b<OZ&0K*Y)7(bFnAf\G.RT<Q
405%,o`:o7g1c!0]A*?F,=W\+Fiunt\PTBp#jq_5KK;RRcGSVYVO$_.&)S_l[g3$`7`L@Mumi
'TK%B#[HN1O%):`N<kLin`#.q.IkW`?`,fBX"tG4gRXdrnc4/NTt6aPdo6Q#Ok[lgaRb:dCr
h"nfgB`j_b_VhU)3LP5i_I7==j8RQo"A/q!e88cM1<fe9"T`*e'-aQXPej1?2Z"U^F)<!4ZN
Hpl1iK3:cqka]Ad9fXb)ob-+XS1(cY2uV[=jD?bu.ns#KPI2.lQ.(3eg53n=p))ReOgC$Zd7f
4I_iMncb'?q_dUkBbUjj6ZS@2H--Ma%$>"F=Or2\O*En%V'el7<$2g^'tB#b>6k5BYhr4;C%
O+Hd]A5,afe+\.@XN>L:%+:t"&>c[F%H[4DJadmdOnc8Qb+XOi)rBV^D\I$f6im3V2Y=]A#(XW
Q^#c%)oW1#TU#E!o_-5fWp(UYgUoY=gt?,`#C8N'&5g.REK3;O^\s5=Y0;DL[0fpjZ+pS@0o
elH,]A)JH5JCI;)X'SMr/>#1d1\<O[tB1-Vpl3r\*to*j^ao8%>_7hb<X50Kl:.UK3T8mc^eA
9("1dp;'X1UcKGrd^dSmE>Nng'uMW]ApY1\N[g-DSc@TA`iB:KS;TQlP?06u&F7QKkThgSch7
5dqHMkP;u(dj7n1Gc[H3.@]AHnhQ5Kedt>4a%o-E(</=Yn`s4#CVXdlk,Fc<`o2dC6CO:T]A/K
!m!BO?$G@Ehcn\bVLVjXmJ\I7H?]A>eOap5q(]AK._$q5:K0f\smncAR*qp@VHMXMF9XSAE5:@
Me%5FpWJmMrOHM`3$B(]A%c6W[jF$IslRKb?-s9'c)W5\kqorAR7+8aShKsf#+8LhC!tAnkCs
Np]AP(OS<af4YG>?Kn#R6p''&eVgoI;<[PQC2H"':HnkA\<M*%aEilQ_EN!f68T@K81Y)DfC.
6KgbBUEZ+0@$YuSe_Jts3NH6XW@1R<=69\`A+PR/$J)fq37q8i7<OK/Y.Xd?E:#<HA)m"+Dt
khcm&u<:'mE<?=&J3,K?'[.$'UjY/0qH_"CPJ*!(hn(DgFM3t..'7b?:%J,61a#.^Y%N4aYO
?T,5@g5uCr"\.b(al^HsM5cup'R)>`W?*>seI=he[R*rTK1FK#V+.^)ep3jdbLfp8>mhC9W0
'WchcZ>2MoLcQH`dR$HGAT6DW<$Y377%o!,aTr."mD'*Y";SjH^-TiNgr1Wccqe@o"Iqp?#B
Np:QZ1&!hNI,-=XuT_D@*Ag>-s\8&R.]AqC0o-7'JcB2qUik\`/`VZ-bG"i>s!n_+_m?WQPrN
u>Co;U9$9[14F:0-l)MB8kH[ji):5DJ`'pcE(DPDUhW41q6^g/U!ROEIHAc"<RObM9!Rjf`j
WXnu11R:-AMkj>r#.W_C\KUOGJ<V=#V-:)DgulJg$(ibtelU!gT[Tdf_]An^`+AH-%-LI?';I
?M=7?G&m1!2]AfF":>87lo\mQRJ1]Aas<8(Po>fJd<6'"L9W840;[5'bJYmF\&AbkPVN$/[I[^
AXWTGIt=!oA,<,NnJ*Q$*jOiQLmBK#.&Yaj7j'Ed;6Hj]A>4nA\q-7b>[B=U1kLGD0:RalGBA
n<1@-<oo^U+D$^j+)d`T)&RTZ0;$Ysm,[TqeCYq,Y1je"s7%DsUZb:Xm44aeT\Jc;V]Au,k`4
^d&GoNiE_hGP)==-"r<:@1;)<+?2mb=>sq:[hJ)<3A:[\2/NSl0dKi+NK5PYh-!O=8Mq!Z]AF
%*>)k,%_CeNVdMu^UH2#PhU1a,\#@!02%a\S&bPIl'YCV=n(2TI/W@A=+<J?5>iggaY:_Apo
Kj]A=LVZ5R1H4fiOL]A_D>7VFb4&D1s^fN6=#r'"F"YF)ZKqo!Q3Fn?TP8h8bt]AV&Y]AU;f5"I/
^+(B^Crh8ef^P5<u*;YQMY'B[QQDN3#D4boGqQCQPm=@[j[bYUhsI7,+qbg1Wk^+V>L3UV7K
59(8maXMYQ6XA%2,XSCW.nC\.V:1W)uOM\@\iAkal"5L!QjB@oE4,Qj]AZl;QM&_C>9<]A8VQr
1#J%('%bgRZCb<kau9rk!"Z$r#92HMkD8W%KZ=UB"`m,;6'?M]Ak9n/W[+gn>oTbH<KHlG!f5
lI3P`.I!n81E+AlSC.(O2M=sJ0e#"UJ4%n6aKNQ>`hq$q7g;sc>F,Pqe]AT/2Cd"5a!Wfa['B
[8-NQ3!fm_6V?[_*.3KS3rtJkFHgR]AQH60q;25]AQ%eC_ED?=WK>8m)W+fMetn^e1d/3sB?$0
mu,&luc(M?7T$K$<>2j!=UeDIfN(3:nHGr@#LD1n9G&%YH2Q_!Vk3]A9=%Aa?/OW]A@3Fsl"G<
[_GFU?'Y>@g0C2#X*&JPc/j%V3pec&P1[)VU?G&s#&/*QDQWp.L,-p(UNp3Q(m#O@!ol;uT[
cd>a!/&`ZH$K#KiG6fKG+bsY9T(G%qIDqj9FbF#fK:-OhBr?@XBhE9*TnjdDe9`6Vs$O$!f7
$5r:3Zhqk-'#/O>%[F22$,@%!7+FTanY4[D'p.:,WIcFE;6VVjWn%#3Hb1$l^bn2=>gV1+rf
1!)!GA>bMYBPS1gM9R5Z%fBN(Kg94On$9p(j1T9ZN`PaYgQ*&OHBJ6Ok5s)Jqs9FU?$G>jDR
;iC4.um/Ap!4"TB?PkXQ8?Dohk:*@Pp,3+7WA)RC&L4-WPe"05nRaDOm^7fN_a-=;u*XCe]AE
M@6(\IN'/#d94&2N#ujjhn-1UD4)K3\Ffgp!_V@dgKa,H\>KPX7J#:&\IAY.)`K$4;Fql[$K
GiD13U'l3Tin6V(0E#'?NM/lFG-e!7S<2/`7ic(Q+,rN3mS$6.Q;]Atg01KrZ=aL;#DJA)OiE
DuM+cHIBuVjU(@9/W=!/AS-KQ5p%Z2rd/TA1$*MdVjdGC$@B_5?$@kE;iU1.7d*HhV6l;i2=
VRj?Kh+Nc%(j**OP>YQZE&m<'DMT%]AoDRo-eQBFo&H`_d;VGa`Cg3rPfj;?aZD^K<XG,3*3\
F2b%h;>6:rJ[$&\MU"f:_]A3^f/-%YduL+q6:"bj;6hu,?8AOg3/U1P]AfVBh(3\qEI]AQIG02c
GJnj#;]A9TMZF:o3pThr\)W?MTAH/p7R(dD,[gMFmYZf&(nh%@gZ4Z-R9C^renI3K(@H6'dN0
UX,5-ouZ$Wq_[``r`ZN0,tZfW7A:n4g8g<=S%Hke&<;m0Qj"#$?N&Nq8um_jC4@4UROcVkLo
i;Lj^jODp4+BEJ3.B83:S#^0e&-UtIA/>U#"?2ofEDR,nOC9q]A'&!X$cTm_'gWD/rQFDSJ%/
o0'5`H'i_OVk8]ADd6a0h^Q6n]AP5ui\,H:selaEuU1gYINU+Wlg^Cjl1)k9`2EW*'?Jh!N,j=
g))e[4@<pA,se2#Ss8mMrBkZ\,>Tc99#N4`0r7o[To2jpS5.mX)'j#;-,^6bJ!oX3Kc.p_]A_
?a-G/MFBlEfC8&gt-Gd;QOm&gcaT,:\BrB0K]Asia=af.+Woi5cM*$l+7O;aS-Sm!/VHlj&:%
8j_4k2,MHmpY[8qs.+=<9GY5_TlD]AL$ZD"?q5"PmGX@l;PV:H26IRZ.CYR/f<(rO;B;CZg4,
8>-OWgEd76&7TTpsMYGr?t4/)>mR*YD2m+lr8S)k6mL2\W9!J;+@?/E:3=&KIVlgjK4kn.fU
M_6+0$c%^B0YBil4,GAkZ8l3To.^0#\$p\4U23>)lN#$u"RX`>b;HZbL01dDSXSulFbf.k;b
(XN@#c;q93N#K8<r=rl*J_h\uk5+As?F(JWN'p\KjN]AD`h-+>P#B8VHoGf:f!V0/:g_j*@`N
?GAVT9o@Ogk?9%Dj-M&sC]A^`@[]A9`!O7US-$N<G$)*[anF5Y!U@<KdskT!)-Pi]A9J4:3nHZo
%P--F6nRQeJ)7Q/jb3f2jVI9k@UcJHj1W64(I+GdD0QAg;RK8aF3"T&4IrdULnV#2!Brf@_n
L6=K/Pq'tlYIeYfmo?gYfW?g<=&7L2%Dr".e>=m,Ohi!i;">YH`SD!8R2"?4Yq-_&'0\]A.Ki
F"#uQ05pu'f,03\ld!oHCD>CiRi?US&CD<9/Q#@]Ah+Lsjb5]A-=8LDlV2XmgT;S,^<V/gaDD.
dUs>?."lcRfV$a.&#W8lg>5<Vrug'^JAW:RI$\.TU@\-.bm0M"J[ZFY.7beDa=(+M:`35<WL
$l@"!GkehC?q1NOf4Q<=CA1hcqfa=:Ze8hZ(gu.5f1]A2Y[J#1n59jkl:[irA74aDc[Zq#j&5
-8]A?I#egOQ=YsY,*%p3bjnS[(Mfq0/+-A9^D0qQ&mA6p?]Af`8Ppc.BQ,,O?Bh>K8IG.ORAG(
Ct"P%F(e&n-l<ed]Aaa32[$//)qJ/%Af9)1ce1\Ad'%a=W(YYGkDd>q.U>L6'5'rSPP,>QEaM
]A+li?RZSuY6ouqh"f:<6??=I3H#"-Pj_K&)0gPcJ5h-0"/Mphbp[Q/'Ws=;9nAYh$DaEcCdb
^1%O/?TTPuSe'rCr4)]A%-G`BaNLQgD10.CBH3WVW^QN"NFReibiW(H*Q=B$`bM!8S;T2LQS.
0ct,(3+f<0pT&=,ts")@o*YHoR&sO&P]AG6er((YNk\GN=Ma?3i$O:,f`&^k&=/P]AQ,+6F*j?
:#9_!82h/4'RqMFNPSmHEVi&DXdV_NrJ50U(R77cfhmTW-.!X8J;1,6X*NslH9:uqZmK3S2g
BTru\N*^^h%VC%AZW.&3b#K-eJ%gr1-PBlF\1H"d';FG.Hi,5c*cXnn5I=OV(uFIBJ2bG^Ul
M3"MDHgo=%D>qf<U$:WQ3#bI-5'&%kp1/.i6WF,kB-(`9%rd+m@.*m:_m7)/$"3ap?K=)M]A`
hJpDT^G7.$_^QMajkc"SE@Zj)$34d^!cIoLY1LFWS-KP,u6W^htN,(PB%cC:Hp5'@qVjdpr'
Z=B\HM+]A1J@lkIXq.5bd3>gq&Ge!jU`2mEp+"`XmsUTb*!";+-fk<3;7gLB\M4ps`UWql+jp
MWN0moWRhpdI8Nbm&>2J'm4"=-p?\V`EJ@UXf+FY\i^_[\t6N*lW@f<rdg7Zo.$K,c4)3Bc?
P[6Q8?9?<j_.RdRedSjtRg*[h7ADu!lUTG8DW!Qp.i9\=X&Hd,%27,9]A4Eq^O!FFUG-3hnS"
c'#NJGsrsOkp:#YI>FECQJ;=#BZ2OE==L?'fFmX2c11)GX4DQD4"_pS<B^#K\;((bTiEY2Nj
\t\7h?uM5lrTs8nL:2qkYNcCP=f9)a$DS,+Uk5VN3B=S)mmG!GW6A:??fIQf4,eRMNc7`j6"
R1%qj^23ZJKbCh3k28="9Os!E)E^6UP^$+t`-Y(9*ZB!KL81.#>+R(!5qJlP/E3m=<.-gH%B
-(m>SI6@,0c6I]AY'k4#m,<lb!gj0#U/M^EjFOpM&iYTd%aL,dIba@,3p#%\3UcX6Pc2)W3YS
#7;J93^[rB?-U>6Y[1OSWZ8FG$6<R.kK%GKq*.FjV=Sh\cDg=g!uE_?8Lb>1ja#-Sf<c*IA"
=AEXOcn353_e;hO':ei/,i/DpWHcbKk>rE`/76\u*=4@+mf?Ju^Wep8m\,LW#kSl'CqEt#,*
KaKRf<Ne9l?q")JIK!d`T2&/Y<l-lsSrVX+fiHh)d80mJ2?dUs).D1jlc9WrOqO^#2KJD0:b
@A#<b`@;E5[$_X81MlF@)*l0>&6[)aqA4U/ldmZRF'1&H(OZ]AE1ZeLfknlbb#5.F[2d]A5I\I
(\^5p%RGsKjU`6E_6fEdL^No8Baa>FrSg68<L,KNK[-%dd'eR8;Y<d70L6+%?-o<)o&a!Q+S
l2ZY3Pa@X>t53:<f]AQ'^4[``8\=k's=MTA;i3T?YRs/uZ"-o/('D2-_5\WC0R\^`G=eT]Atrk
YI:-FcX8I/+Qr@W:4Q&bYUS2TVo?u)2CFdX:+QhH/KCP:CZn3g<WskM.[p"+RT[IR--#B!-W
p7?YG\%;O%W/8pV4@@QN/@>9^p=B>T[05U+l4;CM<^jE)!"3\Q-kFPI*'8,ZSu]A56nO7%89M
oI:R&F*h0]AKj?Hl6[lWRK=Q"cuHd_6Z^g5o#Wfr_$fpCCB<mF9hoHHpFWO5a%W4MZ?Jmf7q.
@!!QCnKL4@J=k.TMWl3f:p3`)lH%IX-H+81nV,q?H>ho0:$:o$.ObU3[F@<[6E%CU1E)06Q)
LVRY3_$+X+j\eL0N0O8Tlm7!_+PN+-jr`PuYJ0aF&9I.dl!cF%oo2lLqu(b05@6^C@cYpHho
L\U72(^5;br;5Yj'_LLoX#sJ&,pF!'_Pj"Yq"KN"CqaK'8j\[3:hYebrV@8C;/J0`#mh,lh.
i=Vd3pCAkIR;9(S*fAqP'K@_q@I9#35A`:I^.\*YQ?)+#7e2hHF87Y$t<nXM/pSlqlml6c8c
=A#CCi?(S]ACC27Q0auL7uZQM/-?[b7g0jfu]A>t.<?c@!)u9(Ag_g3?XI'"7oqL/]A:@UUtmME
E>K8d]A]AOjjrG3?L&V(p8tCWNpIC6ja&&8ZUD8]Aff9/7<+uXXt5)E"N$Y6?`MA=Z^T6.h-Jg!
^cVUs&+<$3S:mr$&pDkjUeS*S]Aho[R3%m6*fN-bEE&clnuepr/*fB8WMoFWd7!?G4IM[8/pQ
Ag6"ABuh7;HIIQ>Oh6rrV<_"Mi2aodj#9[N)aXu)F5L]AKXc=UDc4VFjUJCu"Sb$;"T'%mG6>
MmL`E>Woik@_e"\/b<+[.l)3$gL88D2bW<qtfDi.=2)3,#]A":"X:e"a-LqJqJ(TI8:=Ll[>V
K@\\F/C2rCiCRZg-]A`"jIb'IAFF6TRD9Yh`:/"S8jLVc1b1CuM1JPdX.dZ@Yn^HPH+-A%gs4
p^d^^g/XM;S/g(n[D,/eK#nG0*IQ_poW<u0/X%ePSi2[h9hLfT$U,/+7:Ml/7-V3^]Ac0`eT3
ERX&NqnF(1!@-FA-$+\tnoi-DR/n6UVAT6"Mdrq>N6$H_X(L(I[@.tg8N]AVRng<_aSIYomUI
h<FN1EU5ELK6^6mU`1UsB0+;mlr[$A39=-R^F)luS<_lFAcm7XQkjjUe>E[\fsW?=Cb;ZI,H
%%)BgH,+f(Ap\=tEDE6@EL-0dlCJ,CWSH3DkT5h>?AJm#]ASVnEIg<OVt@5J_nYj0F`$S#]A-<
:T3'l,0b,A4&gFRY##]AUl*T+g(YIHd_P8;3OlpQ[3T26ZrMmY&ND;8[;=0DW5o/P"`It]AnI(
FSuRrZ&)Z+@JigRq(IHYL=;>CV+SDG4Wqo&AOJ`S[ZsWNf&nU>LU,44I13ZQi-H,@K)qU/iI
aT6;>L4>3N=/0LLG]AlYkUFKFi,2='pE+`kkCp_BL&YVW..Bdtn%@n1?JX9u*fkGEg/MhXpo9
icp+eK.1)4@7!>t7K78Crjg@=#q6e3]A.)8&BJpZ5A0S><n*q7Pq1/h;XPlZC*+P"!'PaG!>A
G9%:>=u%Bh!,U(NGBJD4&.W%FCNL3=[(/F/hn+*2lBdYU/HC,@2_*rYsn:r-*>(<HQWr2N"N
tcUe3_,702>7'j)NmZJF0-.TEDbX'KpROK!\pM/ZG"1C?.V]A+?.:Qe)W\Z?MR##(^1;]A$pr<
JfEVK77C`6l=>>$b(9lh;P]Am7^XbrDRSFB%cd;1YJbh9f!8'I6f?%Hr9pL01q;5PG*YLgM+H
:Z^NoiT]ASu`3[PuTN.d?QBPq'.DI'i(^-<[04S`Z@KCJ_&fg^[J.<2ZH!BH&O82.J*7oB#dT
nU<<-@T67ej(@V'nXZ?/GAB/5*MCiOh"Yf>&CYD9qN[Hri<&RC%?/=E@Am<?FDbpY7tD,5S/
6JA5a16F(s7Jh=eWS=ed8,r9"J$WF9ZQDs5o$#Yi1I>lMSf<3&oY:am"[4K-SQhEQ$P2p#o6
.'tDfia!K>qf'Yi,=^_9j;9M8^UbA:,2Q)*!n'ecmbe:k+9D:J<mRPL%rDjZ5i3Z%bhtfIk7
Q3VrI\0[$hR<.-]A$brn8c&9*/Z[3uDDdn^`T>q#6M9/Rg=dP)+?TVs6Di<I5:,%hP,He32I'
o'[Caq6b4LOIB%b:<%RH2%`:"9hA)R=Y>D[VoLCZT3DX$7I%rdC/7o6bqp!+2M>L[X@ZO:'f
gUkOW)8gO_$PIbHV(7&&M;!16c3&j";tj\Jr!Ml8g@$?<h:j/;]AJ9ts'/6DcH'P,h[=MlEa5
j8jV^h;IHn(iuQ?;0+2q)PT5?qe2CdGCQ_hk;/:+\sV6icllb7ELN`d^c/G@.\(7i,IDenlQ
nJ^j"OL=6@%dtRdf2ItTf5O5Xs;b+8eV)p8Brm-9R,Q=IIChRmdUPJ$GHnG-sWER"MSVC7l]A
"KSiea]A@08U2?MjW(l+B]A+3/h"t3OR5g>1m&u!]Ajp<QiU[X\/Rn'$t/a%Su`t3-9RjcE+kd)
uPe(qDNDgZ#8f4P!EHeNfBks+N!\/hG%[nsc2E9G]A>g+0"JGfPhJ-'dKaZ\`UV%T'.QD4etI
a+Le;dr47(#9!QGYPNR$.S=qhp%39*_;E#alVYN)BQgOa4flh\K\c:TOC?Y&!"18$4tc[+%(
,nm?<402<_+eRm\0]A3YQPJM[TRLp2:m.cEiT.%BW087l'Y(dcT0?Ph<2>=*c;CY&Mq.=EfsL
_Q(o/pp=HH?jTGB#KOD!*^<+QBRVD_i,@5[)r4+&YYGTi*A_oGa2t4^R(AcNqT8eh@lG`"V;
8Bim1OpotK:nt4b4nJlAE7(1!39@^i_s!4q"X[A*_B/rb=&,M,#dT3"!ok7)75o&Md/jHiZ`
G"Hj4g\oC__IGNTi(QrQs,Y!DBOBbtsok;P[a_(s98b'.Q[8CY^LM7$W3&)(Fc?5mA5fnSnf
A;0%)*U.FK"O"F%L!^f#)_Hn#",g'diRR)sJ,_fLg?J1hFV_CQJLB1+Zr3JV#"B^)*Ie.CL5
n2]An%Qe?jVOK5BLV`Ks'7WMLH>;.kX(0q=?,j-&,T;T"1Ju(Et.(!jlBB!9)\7]AA(EqVZk$R
p*$uB`p>NtZ+qkKsp>\".&>Z^R<fY#$hA=_kH'V2%*/#<)J$SP\$=70):>H3e'nYH[>&<Keb
J9h7eajLi[q1`<SR/PRY[FKdFCF[(+o/i]ARp`T1hfuP``*LN_OtFiT?MmYsD/Xu.nE"N)%p0
*D^2dYHe!tAE[JOiGU3+H<X4(ecI"J#Ka1oZJ(oXP%E(-s#a#K3D>Xs@)4*./Ym@3bmlCZ8@
GF5_,I!PoZ'lU;A^+'OYp3s#(,O.8EQ&T[^A>[=^D1TJD&"4.$<Z%HJ[AjVZj,X`l[j(e:6V
'0>ngCd2_0&G[-3TMW!(AgZ?</?d6lN*2^FFX]A^\$O6hA1XeZ/6!UW:dSC"cH._4j;rW'`9t
U8(hs`D>GSS#WBt,]A+NbVG6Bo]A>`\ZG7:<()l>USo1PsWbdWD9G#(fae_Aker1?IYL8R)*EK
_+ukR1pEfJ=#*HHddrOrj/Mr,Ctdqh@Tsg%f$9GHk,`sKD4gE'bo9DW31QU,;SFBA;H,0^X9
1I[,$G.n@5dYOo><G9Bto=pXU%;I`L7\Rt2q:HktkF(>g-%:IQID+Wp(rr?%$Z44G]A0$_sI.
Jh)L@LF-,c5*I>.33$n>7Oq,3YJdLnA*9<[M*nkCmN)7d2>r=-]A_BEH69@-HqOaA,IQDfh\(
P3(+uEk`Qp_]AVa%4Q'lYT2Ia&dF6JSp)Cf\TT*ZsBG9LY@'sTC:V1%Z<4E>JeY29q;UCW"YP
b[BXQB=mL;(3T$GpWEO0?&G$;dD2U'L\6H3A)dkOr/Y(l,LF"#Q]A6T[NI3[9j[nKNr#/Uqtr
-Y,js3AG*-RLCX3]A2bQMR4b.Ct4k<^DDCH`b,tMI,deB08I!ScKR^hf4'FEPY,\+XM6t5>sa
W$3o4I$M5MlTeJ!>lDS%FbC`U9PL]Ag4sP:Ikj.ZR!!I;?-WNNQiOkaGrsX[\cIcAh6E[a?49
N(5OG$/)*sf&KE()E'[PK6j&2en]AKoT1G/W*JN(p'sFC;PJG"J)*QSBZ]AMSbbe&9"oDY?C(r
GY2cKgnj*=03%(t-TW44<S9&G]A=6[0QTDOI5iZH%(`kSq6(m'Cnc1G&*\r9Bkn*HUkmS^K4'
eg/V)#O?T330CO*S+[rLN`MoN88[-n4LU5#<^W@/.eC'@`qIs+]AQOVh0%<U#6JZJTPlW%r>G
F\!1BH6_`ETU#mN_6LqO"NBr+nA]A(+'qS.Z'pIB"KsnXq^:%tGT]AI*Y:*6\=SPt`7%b5b\=q
BB^KLb4b@;UbrQA\(RE$rZj]A^%[[Q^l?lRuu4l/'`G`:s;BIAm1`=2r)fhYYp9i_dpUp8h,T
6'?Ke#*VgFao&ubEeB$\.Y<,/dm7gt]ArRKL3h9id2imUc!5S=sT[M]AF9LVUoVEEVt"J1t''4
?2,Na&f2qgH9>HQn<.#"XXm]ACaQfqsj6Nhn,_?^;CE3n)k2Y`V0k9ON3IlQB^8cHC"TY9)ai
G>A,2DF^#NqLIWRmrqf7q1:L512SF^7n^WoW-fhmh9Yc$WGmp#!cCXA^p.)me]A6;;X]A')$Ie
2+9-7@4`QT72#J``6%9O(k6Tg&]A6jT@2'Zq`]AH(HOKAU-8*0Fmi$*.e?/`p2aJ"-]AbpWdV0D
r.$(@h%EtN/)oR-F@j;"B20IWKZ-fgp!h]AO>@'Dqc?k*PZ:"CC?`WArl/`pNa9h?ElXf4FuS
'@F2YgN3WNL_Hj%@=SV2&S<D-mi^O)\n?\#B[+d,)j2@<873Wms.pn0;Yp'hJ*u,Nj9>#?Zq
t)eIhrDM7qdXJTphJ5:[&UX4h"+MXb>lOA//fOjnk1$*+be,Zgf,D>[-keH7sa^/Ij:?(;\#
*3^dj#aA47>M/r/UcAZ,YmCdXH(;cjkAhk6<(jHYL+DZ5Xg4/O5A*`SU\FLE9a1WS7j<D4Xe
M+MBnJ(fqFd)J#H=gU#.'N$::TKZ1<NNB.C\1)8p,7WE",HRC?k%F`9ug!TkPt^5M:CKLGo4
\VpVu#ULE)tsj0tE`5H"2[2%MGlUi'3]AF%.n&1_Y:>!a:0OObq)C2;<7/s#3.Sg9*72^[d5*
#;Ukok_!4u&qKG.G\Zif!R90WQa7[!R>P@<Hb@4TlEP?ApDgUP43uA9qlMCC6i/qPY`<"L<&
a`%mg)g&d9=#93oMQ6]ADsa@E6+??K:h!Z3M6\fH/fWc=GpU:8"P/u-X9jBNBGh%<9hCh:_%;
EVutu=.o6O$$=:7Z0@');9"D`3UOr=LU3t,Gg>)MTmC)G-Ql?:(+kcXbi@rT'X-`A;bdSYXf
o%5F`koj*\#?lLIl4<fT4,]A?3VrgWC6CJ38KYDkAfJQ$%S?/JkAogWMgL@t=mJ8P0!>pH%VW
RX1uhq5OM>@(V8T#Wn;$E6/dV+`Vg-Dr(&u(f`.l%O=+_Q>.IIpD=.[S9/8PSa7H+JVT6/:G
h!!T">7k`3>cY$nc8,>un^,9i;NTM??*]Af+9h#UL7N*RSgic%<#.?@"Z=d#sfZDCmG:[[)X#
e>/2pG1]A91kd:DqF0=g5Ni<Me427r%8[]ABnkLbI#ho]AJ1b]A,+XUP1c"ZdJ'::TiZ#RYk?0%<
lrLEiAmKUE4qlP//Sj)&BgtVG&he)Xn:\1jY[BpD1gKVBg"O4G'_%:$LUdKThTDW6C7B=7<a
T,Bf>EbHuhM?-(o>t?f;Q!D\k"iV$De@Xj`Yp&Ke..Jl<POCbcd?_AGPZ;U,(bb#=06T/[b+
/%JHX[#<dW)`[^_@8alfBA.+o!UCbr>BpMoS3AUuuB=t2?b84SEf2Y&`:._qi*9mH1CR%\k7
:3N,>1a'I'hLc4Fqlc!Pgf-N$&%a6$\2+M7<Bl^F*e#1$*e`WR;ETe.`)Qd4l'7[n<g9[a%/
!O)4)(M:nEj7GUnmVIOh/>Njo@4-?0G]A3XGC>S=4]A<dcmD\W;g0jMJD7J!(norq*&BdM'AM9
p)30Cj__4L[MJf1O`g`\=?5R9h.:%D@lD,5^ko@hbdJ"bEb+rs[6oFl7A/5k_\l:sYlXJS(d
cuMRd(VJ_:H?]ALF=7f!88u</\0dU*F@`&HhJ2qhcVhWgECu8B@W.b=iDi-p.q'=e*@@st>YR
ukCJaj8_s8*J4a-Of-/fgfb3Ph=_6sChDBnub_\6m#'a<LQG.Be*G=8K#8qKd!dd(16dP:,f
LAj*A#,DJV-@oAO:@pt=[(rKI$iq"D)K'RMIb;,JmscGSD0a@@IKp1eX]AVNqH'b)3Y#f90Es
/4)A%.>!ZX2I=+KLGrX0)tYne"o(\j7fSI,9_T+M-I#aslQ)S@W3YL<YuRcoq'%:lhN;"dgZ
cBFtLk\>@u.lGHi-\B?)W29KV"f5f:/N%*Rml>T'nc;Luo/aG^I;PD7+q#3H8L(oqLff4,@X
[\D0D\I,+Bj:tNN\LW[<T\&"<^G'Bqb$p*Pdo^&3p=uV>IQ&:RKhS`X"Oi7=1S.P:5*Ga2b4
+cK$(*sp)(QH1:%;R<EcEc0OBi'k/4=03>"n(p)+kla>lIL1Jc-!PuqI4%r:dQj/=P[id+1>
cSZ[/rk8U(L8BHNr)qo-odK9%JUNe.P??"Kgo>XoP0Yi;N3XoJ]A\,n,'_3.4cp#>Y_k#Gj]AS
YT;#0sZV!CZ&[Df6kS(oqU\Qd2IXU.SN3Rc\@P.GCJSM)kWCD$02W2d0l)H)qc\d_E0Nnel)
t*i:8&5Z&kL4ge)+!<>$B@^e"'1Z[2`cW_t7kM5m3KQ?2J(;WK'c8DYi#=e%@2O;"3dD0lNN
U>'YkZEqXd[/edeaWF#cX?lm]AJ5F[\7r!^A.eF$e$N.[I(.op.(3qKD0nUF&8%$(>/"$IJB!
>@T8\94q<Tlk[&c`$J*d804ZWW\/LVABZ>+FErmj>"%V&ScYpM?uqdZs>6Dch(,(eV4#$s)E
c;Q.1[3I([(Xn!(mPm+A?EmN^QI7DkbmR$$CI8C:-]A%*+[[F&9IKTY#14fG7\%pcn3.m8m*f
Gdfc`C[Z"<a+1k+gdZa=;EB<P?cU)RX-mR(*9jnC=kODHr6o-"OkY(c.=)9%e3e'(&n2e7nY
Tpjctojt=Qd4V"cgqD-!F/qrU%1qR8u$'J=\S!H*.QAs8m'5*."NbNm+Q;P>VfELD=jp(_*f
15aE(79i\'fIC.)PtdWKMrp5d0[8T'#+[n2t]A>NKE`$DR(Gscj=B)f]Ak4)FEMGU2V(14h?d^
Qc#G#'2im3cAkSY$aag1\!l,..2N2f6g);:d+fGdZ(E.o@`#5SG/X9KG"kW=`Bm__N!4b^2+
5c,`<K>pLZ11'Zi!"L)dF_IC@ZYD;1l>aQN<uPs1RMaC?i%$\ChiAXMBter=/hXlM`3Qa3BL
&Q:I]AOd&&j+T(AOV."lU)g>*`pB\)Pu5iTE'1cQq2gjW$jcfk$GIF8<S8#l&&:bCIhS388`@
LbR[d@2R5<=nL:tN;ES5U=Mq;Ur(-Se,&V4<d]A1am8`1iW"q!AfoYU;);-R'%i<bMHTpo:rr
u<4,\Ku>s4bV3!'\nF,<X;u&<:qq,^oasXcNQYUKQl0aX0NR[GKk7uNgn$kTq2-[mB$nO480
`RkdZMO(7`&`=a6^;8Yl-:`0Gck`MAW>[LW$KiY8_H]AEHVOW,dD0lRnWW_sOQQNjkn#kR!dB
M(Ui$B"A]AopLULQkJ5Cb4K"V9WPk.4lBL$-?&G]A-9B1'U4?pKg=:!AJ>I$#jd6?KoFK/iaMQ
DQ,KJj^/7@<McQ/8F/q)Z!Np]AFaf9HuMtR/?eEYlG"W):!WV-,8-ZhR7:CU%_HPHu03#L/lL
!hD,g`eWMqcm^t7tIB8o<$q6ee?In]AX6n-lZ`r!qf=ijgNM<<1<TU*WpHj!\J^>febHNY:Y^
E6&k'm`&D>PlK2XTp552-KPU-C*'t$tC5%QH#Z0@p)$EOTB"$`AUnOWVI68=OPg2`Q0mFEOT
jpYuttfr=`#GXK@1IGs$?+5]A*o!k@8FZ%YMLIHBLkGE\#jJZ@7&GG0eTF=Et+G_q`0$;b+3-
Pk8DNFC^!9J,o(TXW&>FQIPXpQ\KXZH]A_Sa+k%g0`o8AN!'gXOX*,dnlG,^grcf`Z6Lm3L0M
l8P1s)/$<c%_8@&mq-@4JH>6INJ3)V(nCG<JPm:+^"Ug92u&5%TcM_B+)!F;HZ:Dhr?`0]A$u
O=`43\ij=E*$FjQ'O_K]Amc;HJ[Lq`Q9\osFS^oi&l?f>j"U<"tUV,"I=6Z'PDUDO9TiFK2##
bI!fKZc+8/3mSs\RPA5qpLch-`XWU:=b]A"<sQ.7m;tpX7\)gWM-f]A"E'`.<`je"+88-H[_'[
sGX>@mc_u>?9S&jNU<&K/Db3I^9TZX9/4gg5=b'I)A=h_*M?f"'0DNFnOpjN_?$*532>I`_&
2VSaI10K1SfEO8)3\'i+qnn*CD8m^![Pbeh\VXP&EDIbR$%LrV<o;`ZGgRPg)=(mJh!U0:bD
=1-KC&M'[["#o30NQ).t1RO[9NYi>;?Z)a%u_M3$SfeA38:e*Z@<oD-WGG=uE\8kbT_]AK1H^
g@GMNA(@'<&E=2oC!2tHOZ[.k-ieSAj",j6;'2%Z+oX69\"`&#L?=/3Pjhnru:sdBoa0`XHD
?H0@\nqRm8kEFf'?f7j_s5<\#lh"7ej5dh/Mn>9+M%W;9@#Q,U!8Y&V`8l:'NJQ!!.(\FmEe
m!QOK]Aub*]AguE;&VIa'<<%k@;,eWeV:"W!'TVIB[&'C,KL7[OZHL!/;KJoFKQXi$8F<lIn?R
e%?;*A;tshA6b"c>b?%qQmh#'H.D%o`A3gco^Se-iJ\#DZn)M#JBTWd<i.9`p;!`iotM!CL4
R.A\m*BBq,s7s#O"^0B*OVFX5\8Nh!<G'[(DftjlR3'OE:C%c.77daj_m'!a-<&`uYKsn$k>
jn>^>GHn96id^0?FWS$/1[Mo_0.r&roFQC`.^HVCa+RgHlXI,aA4\KjhG(MH<H,)$G:D%@Zk
MJW+SZ==oZJEdBGU"!4741Y-FEX"\8["G\bMOsHiY\(H04O#,mFXXH4J-)G5q@^A\OmqPP([
*c'lkDo_9]Al);FYg&N%L"a>4>3"N^@KX2T3L[Z]A@(VZ^psBD5j\>.js8`?c9O,_0F5<km+Cl
pZes/Y9H''pq!PSC@CO4j%B@dg'.?^9In<q&l[$SoUAP4bKVlUn=QO+^CH:3kJ,*-5Fa-IUQ
sR/WU,8bJ'_X-d36-Q+Q`oBm&LpWHOIC<q,;E,A:;:R^K7L>[HmHhp_B<.V4@QNqJB`m0n8J
/numP0Prr1LSEI?g^0\"#l^TAXp1)BVdW0l>U1=S.omZ&`GfK3u+D87>>3r(M4Sl10A+BJX5
/C<P2AG9&Z/o!YICUO%qN]A`)42o7UI[J9+S2t)1NBKLs[Z<T%VUMD`-oAj3fRDf-+\LU/;3q
<515YS*jjTt*Y#5-#?dG-FIXskT$-\0fDaha;k.;@qI\<Hcm)mJ%,;\=ad<W^O"_dCZ)-9AK
7J_/Ae=FnYI\9ibenG\rnDqXCQ*HppCEd]A);qW6\5Pa0oY[1\a0@F;FMb-_Yn&LIS)K*j!S$
mcElUA3^+Vj6)Wl%eq"WAi+Sb0cnoIT:0OY=;a@UPj9qmg`'l&:fjKQaFS6,I)J#o(&&bn;0
QShjD1P;4`"@8Abf$9PtJkB0ADNRht4o,#/++Ne)k50ro(9>"^5ku?rnC8:ufCGX;^A3Z`sC
:Og:]A>,g5X1%S?;n'!FeK*q^.Sf%>D/(DoYIKmS?AnVm1K@j&llJ^&#j09(X>m'95#PB@:.Q
0($!8<N3P^hCF!\?m5EfE3&FZ7r8G1:8c(1h1SVI$%i1R4B!Ah`0'qg^odb..U7+_ZhiK'NI
8NG$CQ_il4HfZZZnFq,>F'Qr+O!>rugOWf`p#F.QD=>a#b[E9V%InVcp\8@Jju[lY6T\R0Jm
S'1jILV([A\5Q<TREEggFjd*Ll`>KaO<mX\udC0(6Dr0glKl;b2^@It:SbGl_Y!W3Qe%HkQZ
4G53!:H+Rt!\LI9*,BMTjCh&qp(jmO8G&P5G3h88C:hShE/<hi1_O>H,o/i3nK50NtLBXYG^
@]AsiK[Q'EWHQgnlMATj:5nY$S+MPMi\%:;\CK;M,0d2J.0[[J(%DH/E27)ARa[7[nu`ok(&H
t`RbWKqX+hXN-6%D:ND\&?G/p.0k3)MN0Q?rH6IF3Z(;\P4;Um;so3OJkLa;-^CgN6=^K9K%
Y3d"rgb5k&O^#'*Z=`Ds+ZFVeY"+`2a^A'_@LUVHHX!WFI/V9BnTF!Zg9j<t,+#33jW't<#M
144*0?/XYiLi^Enp'$J4I:n7C3At?S2_&I>ArcF.DeLfMXF8q>OFXhCGS,==WISM-"O$*3l"
@?Xh3>%*8d\7g7$3KfXtZ9b&_HN@i4bKbb\iOO73C-.\oDS3^PkgKs%DOd7Dk#`iESgkfY,1
<]AtXUl6^Ua:`IpcsG\_$k,=-X+`]A82>oER3drDM7<H/3^,EK?^dhO-f%o0+I@X^IR"=+c<!s
WBN4D0i^]A#(,)gM,`-S[CGO0l%cDjG)2?=ph?Hs;-1g!j%djCUefKBp?c<q+19'Q[DbGU`;*
aZu>kTMc4!*4D9YnP<G^_DtPk417d[m!6.X0@.2u5s2",n@ri3DJk8B_ml8+2"e/f#;f"_.S
7R,-]A'5aBp%,S3nmGQ-P?GF3[2%RB&5PGJD,TpX;jr%+MD'\$IXj0LoG-rqsVX1qC.:pbs-7
TX3T7SLihu#r4_h0SLV/tal*>J/AS.`)t5=>Y]ASm[7ZYX"Mp=b8%':/L)Ig<c9NMY6<RT]A%@
D8jZWQ[L>jurdj&F[t00PeK'p]AQA-RA"SHoXkB*;=6#:]A_-#TV*Oee2oar>S2+Mr@/R*sHui
GTbd6ELoXTH(&/uPNUGlA\2?W6,'-J'5-^aNDdP8\"T:YPQD/"lP5pp/qFG%:Y\G,$VUG.gD
9tcZrC<(gDJ)V[XDiE[ef3Fs/%2aF%i:/U]ADjdM.=^ZMrWP_$]Aglt^<#\[a`G2&,TEg'*:L&
+h-*`?>Ss46Y,1D&5o9,"TY[Z9jXDN*!U*bNDqm2)+t.O[`Nc%0UGX13eg53Z+u:*mI#+<AV
1WnBkL;S@1q?)&H8k!(pJkOY`bAPpt?GkmD4Di8`VSb-@sZ1bM,0T`p_#GZao0iD/+#1d2K=
uk-^f<q+%dcTjqI2&5eJ"O@<oH,+?'jQ9Y/SO2-kB[itLGXF5-gQs8LJJ1T(11ZPRc*k<W%I
3QDgX;gBbC(9[Nrj9Q?rYlLjn/r'm/^60RMg,i[57%J_s5On'/1"RA_SuGnemR@1#TT"Ua"j
-<:kBa*U(F\C5Hk3q_%A!UJ#_Z?2GT;Cb6SFt#>n_\s&ULI3'*^dAN3.VkVe,R`NI!$;??p8
(.^^V2..(38*pn=sI/Tl+$>Tr^V&2c9JG5R!ZUZu2EmooSkCJo`5KD"VG'PXVUPF:772C@B?
@R_$*(mH[tjSZ!bW6E1eu;%ZY:JY\S=.RI*FOs*hYa;>d^+=(,*7"Nhg:bY:+k"3QHKiC@T*
0Eeu8V@(P9F)dEaDcV8g=Gu*?b^N]Ahm_227p,S>Q$'G,\U0t?m'G#dSp`8CUBJ=g*+N$)"(M
Lu6_sJuWY*O4;\hsJKi]A%k<^/@7bR$D'/3.D-ErX=t>>>*d<u$R+,I\?HqR*_L(3WPBnKk+*
c"a-%c&E`a0K&L9RS:i5Y<J+4O:^[.k'FD;q*>DVPk7`@S_``mH6f1b52-im[dlBMF`,ni0E
6`&e$is7Io5nY;N2+%9Gmoo4+X""1T7[s9a+QBjUn@Sn,tOmYHj)N.fK,%f-,<mHW@o>7:f\
V$-0Zg&@YeuS.p0,q5NDJUuDr^Q(+X9S7rBV<(0iOX4\N-$]AiiiF]A&&69s*e<AF/t+&3uto]A
/HT`+itq>n1Xt80XQ[_AcqHkXm+#b2_U>U5u$>YlHmArX/DcNCpc3G)Z"Wj,\L'6Em7>T.^a
U*8eBg(cHM5O"=r!ifAA,,a&YQSXlAfhmsi)j]ArSJaHN-2/4nUgq*Q="4ALmHE^,!M$_hQfk
D]AN_HgGZp^n+-$!&%g)U4'?04kM5bq7))rLLnT#a(f6Cqgb>i(KGK"@U"NH<+q7/Cm_i29KO
O<^>@+5XGnn'&-N%!X^W>D'Y?Ea[gkbB'V#h'c=p]Ah5)-sS[>h'K(8T^-R("&t$,P8(g=_"U
iOH.9-ZYAR*X0hK@0&g$ZUYg[V5elEk_IYH5\)$/O77:K#cbaV5.5?+@a&XfO*3'2bXR_ZM[
kTk+ff<)CS9DAY/JOItYNpi_nQp<D)7=H662+VmFP5dFF8S+[nX#PY]A^WF5E^1@'\Qq5[5gQ
Z1P(T^trgdmi\a!SP\93HlcZ`d?pjX#!)"3n<ObT+_q,IIU>#+%'d)hTOmC:;&mTm#?R!p5_
MX=",i,.'E$q>Oc*U-=_B3kaoX6&VIXZb_#kthF8:)8#06B:T-N1G#`ma]A!*S\lbolfo50`_
hcRO"!&F.6X*ai".:CDQ^(.+7*u%U;ZLeT<`W*+7P8@m%#It137S6)T+pLh=qmlR4iB)8#[J
GIM>%$dm^95pMW;$7rQfrYi.(&fZr29/;n'/Hr2@f&J^.;Tb"<f?[42KYf>1a<pCoMP0;F9"
T:g9^jjV0(?n2\M'AsRhsDBcp9!_e+\kd0h'qJGEYq%#(B!+XCnM./*k+7u$$GNY+Y/gL#NV
+PH1s8Z#bt&^ACN;i'57),38@2;"C0smgTC!.`j<c*n"/6<EPh.@VDCCg=C@c6.=2VtSTrh2
,<^K9(fb<0oBnjXcGO]A`Ls%l9+DSKk@`=/W1G\XYRmV@"8E@YbE@W&?cr2+!C\K0,@$X:T-j
!UZ<_g:"<sW1$A(ijn90fPVNj;X69crb2Lf/2H_[k!<D@fYU[5p]AN`uLJF$Ek/dl%78QUJ!H
VX$e3Xoo2E9.>u@&p9sfLSG;NlBVj!eZ@.DXPomVJoF)-!*hV`:]AWH-oE_rU%j2KkuEUG`ME
fmtGab:0dS!Vj!nDnjf[VMW3TW;RD+iU.5[nC8#/2V7036,jR9k51(<='"Q9et<"Ff2[^[n[
5bpJSfJh95K[FDbD$_0Y_&'R4QTFDNd@-a,?\*O4BI`NIF,fGWSA=%J\hj-#'$qC(h#]ASWUn
5l=es:U<Yl5t:IhHP9&07eDU2mF"iDn#c6h<>=X8;tFFo`8H1T:M8udNm2IF[CoUr!hoLe5@
u2INs$aL_pn**!gf3$`VhZ*,Zlp<,*o5[EuS1<)sB;10c=-RVI]AN=CNB6q'8R6Q^^f&1M=X@
SXT=K\$@)qgK,J?-gQC%PgbZU&O/q)2O3$fC3]Ah]A#o9mCgntHk(J&cU!cr?7QWl2]AGb?_G2h
(:GgQ^LRe"d4'K"6ap:Tb0L4SmirQ&ie]Ac-l;&&Gr52tY`_WQR2g_KTJDCA'<5<Qja+Y_ZH9
6jbt#2_;[J3sMs3Cr`e8+06"Qqi?<oQCS/H[('V^_%KP+ka+.%S!K!,#gaTn@kNP!X95fkL\
CH?f&(N!L5TYFepl'M35]AELKbnmgsNVEV%<r#]A`<7([6Ko1?0nS1L*WI?^<"1>N9'p(6Cf/?
"@fWYVq/FtleBf_@q(.14>oMU=nHH[@41If3>m^KJ.u[q;D+Bdhn'!_N-YdnF`Ocebk#CcqB
kH>BQkXb7V[<-YB.=\5b(@+Z`VD?\V[$QI8_#HKR5DkGN>Ei0GP)GX5]ANIo,n12?Lqqts/UH
K6M4TYY:&HJ7>?-eC*?flm1A>RLYlN"@V.n,]AsXp,jG"+BeEO1a5>[?%7&[Q<d5QJE]An5#)W
Xlha+3nQ/%*gZWiTS6mM-%&bq@>I*mh2HfbZ;'"q7+>en-kHULo8[AFu5Fb@b_@;4;0diXf@
Jhj'+e]ATappIB/QFK9iA)YXB"Io#spnm;('dUe*bq<.%sDGD8Cko)Io98hZ85.%h:^ekTU0f
qH*)Pkg(r)a8RUG>Y_%Wd@dQ&iO<L7R2o=7k9J&^t@2L7]ABm3(mE1PKX#dY&'Zpq[#QWg<4N
;]Aq;Q3M\OauJU_6#e@j<*?l*]A6XBKGig58%r&qg^p*SF?#.%Unl2QjR9/*V3h72PKfOfQGGk
)`E[IhBFgG.mEZ6F@F<I&O)%Q!s99[>hBp03L*hBib:%oPe'P,9G>N^,:p44@ShDs(*^(ZOD
Tj)!#)2";!#,Z<-G$([nDS6\LC-CTVCIlrLctI0tEsm2Q&j%[d&@8[n.5/a9o@eOF=_36]A^g
T?A>X(?08h:K.MZPiO/7Woq&TJc<rACkf]A?*B\f/kbXZT,;"noL]A)Wq.srhd.`+W\)[;P8nX
=r:T!n.XWf5B`3*[Z2s6u(t<e6$N%A%B8WT+G[1I["Bf,(#-42gp-hdP*>goJ:5/na[sC'\R
0r!$oD80GE]A=/D0Vh;c,0Ap'h/22'GIfOIpuGl5R[2W3\j/QB`E!fgNZ^[RG(f735[':u\5(
\71?LD(9!iH:.tQPSH#.m[h%Y/P8S7]AUI"7eO4aXT%R:.eY3?nm63=$$?TW]A7a4=ib+5j_+M
^U$)f\A^=$DSV+?,I8&-G#(DIcH,W;a#-0h2$#CU-Z9)``as!jr-$'J,!kGo\a?/Ih16&oj&
\Hpmt%PhJWq*;.?fiNPA_(7=338s_`LW&KNasWI$a6QJaHX!mAdsA1<K6E[2\*K(9q*%0$6(
]AD\C.H^$[CSHR2#M&k[*4.LdQ*UOh#g!P>a4[J9+T91W6oAXelRUg*le*fe%2(3`\S%T(X#_
AW0q3_=ACK2Z-`<Dn3[7<Y=+r9L^\5PP@;pbA"N@/?0/%`*K?C:!d:!s(.@S4[HYG??cjZ#L
X:mHTD5ZShEf\"B<,?eX56qN7?`GKBNC@1qb@P'eU'cRGM"nnWnIZgoW`1QR@K[(`BFFSn0;
@1]A;eikd@M\1Km/B7F:>,alAR/hEfa)>8rPD_f$j]AgpPlF=ZhHl+%;/.;qloP0-\%=.]AJae`
Yp$g#FgfQMl&/&8d'di3L@ZbOGm<SAN/?>?qMn6bd+:Hf2s_1&gLiC8k[V6D1_p=U+4+VZiO
`.JHU.4;I;Ba>BAJ0)?gsi+!hYeP\`;XX8!R'-Aoo^'^:RBTW?`iRhT`KKn/t`_54T+tdM7Z
'*ApmB]AoMFn9CpAHC'MC\`rqf#>Wd`mEC?iUmalmr'dU2GMn90F]A!UtU-97;ls,<_JH`IP#V
QFnG7(%G_e\g2p.SDSnfhu[YfFlK\iP't0>KX]AW'-UfVTUL[%q:>_WB%/.%9ltW-".^,Q`#`
N4I_S>pLd*d-3@?_44%WsTj5*bbeC:=7:a]AE?"A>raE+-Z8Li@6-&Y&Ukc1Z(U-A-pR)H<V5
5&.)0c"K1%nbggH/*ClL2+/t(*1kT(l6BD(L#h*6F#Ih_dW)5=iG0(hmWR1B;R@2J78$"fc2
@EG+n2e(WpWHQD":E0I$bX?EQ<#O/".E8\]AH(0/i2`LI2/`]A41..50?!7OJI*Q<"o-Eg>0^R
+6AjCZ(k%;]AcY6S)E&6dl[p3LC@JA04g?nUrq)QjR1BGU5:o>roQ[N!@4cE'`WZ&T&UJ)l?B
!;=,'pC++p%>I)ND8^eS%-VG7uAI=ZuY5u9-I4B)>\9D5$.Jo\"6L-lhnN-%ef7Yh7Vf=^&<
p<T<?jb<]A*oPGZ;Oc=l_eFl9bZ[W@HQQoiY)sQUK-dYCJVmf\kYYHE_8AVI;t&]A#h?ta=!qr
FQ2:^a4";&g7@l=p[)?T1&+qt);(crDr9fIJ8(#/6'(#QHa]Ah6m*ZHPdDC@>f^O7G7qL66T3
=UXd[0>OZF[Xdfm?_b'66ESosVPg>Y?0E'!'$\o:X]A&,@/ARNr/#Zj7bU[dM$#UGo;9?>_9(
\AWRRZ2LChZlrn/V>^8MS%B>P_EqJ5W'aPV=*p=E7c6^,W2W%TEP?$,fNC&hGGuk,&:dD?>Y
+kl1`Xu7:@uJte\_)D1Z,EL^7pE$$5f,_*dETs00#dH%qeV7-M>)]AC.1=[Qp9bjO4#'>:K.#
Nll(e2QLEaurC;+#S6#jVF;nL]ANG'b!K?]A]A,.M9WX*.1WspTF"IQQ$YkAG-VQBFr%HKGI$:A
)MJt%Q`aA^gm5sMf!+4N;;U9dIh2A64'8</g$b0Sb7e#(Ye>8b&T3)fXh<G8qSq%%LLV$gJ/
MsC=egI5N1:2V%1uBM]Ab2=2JrN=0%`&#+UKVn)p@-YK.&;ABFeDG6k1Jdb%:r`24X-;.`su;
[r=9pZp.&JDS?8JC3=o<M8HX<ZHNgsjo#UHCff%5sH+m$1lU+m1gYF2Vn<#B/+b<@nD8s%pB
>9Bfd*fFNf"1RA"q`;hJkJ@l?M1rO3h^<"Dc1+t;e6Jc-OhI?DU`Yl<u1=OCKWk%&!K&cT(s
5I"_8Ine!7M>LZFo/A2V*3n\A7>g+2OWNC5T)J\#;e>8O&(*jgOkO1@$cc]A4XhCR1&/mm&5p
^_Y7s07!CH;jl!.)j?\n-p$:u,X1_Ed4WYV;_='6)oDHD)*;MD`.q$)dMYmTY9eNc`023B7c
->'R;=]A(\^l)qc#f/^ZS==h!S\um0^J&\)1>[=nB9:c?]A;-jeC<%:FhVN7Ira+W<%6)>eD$)
r:,(%JH;KXrq5GJq&@+="m+5=p-r:T:`dV;\T#^CQ4a"tUqI?Sth`t5E#X<1=,&jdc/i`o$2
K)n,m+gF9QTE@'5OBHQ'%CV_]AVRFi$QVrQ"pD,U61KEuU;+h49!bFQ/G2s7a.lSeooY)[<Z7
k419LJ+p8#d8s'g&(Y>"g]AD>fd#5.R;mAN2MJbhV/h8_`:k5rffIqQPTW+(i_T=dH2YH*=g#
7$c>X[NM@`;<tU)L)41P8>gZe,rhgkG&=@rn&J*!<`Z'rWKkk*LL$Vqj/!o[Y!'Mhl56PjjQ
X@j\YWLK['f_$:bKo^qP!Yq%_g,`^0+*Nn49."fV!NF8JbCr9'eC^q=NO>SpfWp78;0(DY9I
W=>,DX5fo_1j&<Q$bdrNn3^E\DXdlQ+)^F.gG-a4Eea4't69LW$nT?R#ofAS4<HajHqf;FR9
67dpS\Jk8a#VuU'(e&+F,-`#:Hdh")1CPC8@h`$gF_PoeTcE'MP@TQMk&$rS+aqX44KgO*PG
_JIeue0l[S17q5<?<k3eNd@"IbSZ^TH'T9RN*Umfp'g$jL6N6G&IoL3:'>K5OM-M_NLT=W3<
3GKb@(^]A%q@J,3.>'^O_;U1tPZ^WF8K"<j!k-uFA_f,Kmk'Sa6C8UShUj>/GJs8@:,a5-eN9
pB8"R<C,.lg80jK#CAIVJ=JoX'T3>2L)pFQ?X2)D3\:(t5B)0U?&E=EAb&T7=R4:M#A11^JN
H^ufi=0k'k+f*fPZG[*IoXuLQNCdlp"VlfLONhps-f)7``GZXd*Q+FT2LE+N7g'6C'pPdt8B
jY\fG]A"DfnnI2-P>D,nI-":"pXa#Y*,'\nEQe.)[sq12I^JI>>A$oNANp"rFl;I*/E,C#p6s
:9CPft>>+0s*k/+:mMkaPlXF?JQ4Nm&i#T@@)8&*FCjY&nF2>3!ZSOY<tPSSu5T4LikVm&Z`
]AXetB?$+@.O2UI-XuOYE![<8$RAV^%r\tHJs7ARH6GW.r%'V=./)(hD]Arp3,i88ZXT-I`fmf
R4Wjt<GIRIl.eBmMjpL\]A2@gn8bca=dB&f=L1eD9IZ^POs8Q]A'q>BYucPIDOATBfiZo;G1O@
U46Rmehu@X+=_nkTF-Fkl8_aWmlAn*%,)%:f9,Z$"b!6cGMtN"mC/c4F_tBO^PujfEnM*t=\
W7>l^&Iu(R'6NOVL#ZO6/L)*C"]AN21Mi9.G:Xa2EBpRm/sRDo[*[S'ja]AU&CL/YEEHE*^/Dm
c-:G+hAi"W'k/iaJg?c;M_iGBLA,A2TtjML+%3a9-@jI??CWT,.*YWZjdi[MpBhX%R"GQIYX
?I"iI%JOu967Y"$_p]A1i5>J/4dTaR^nf3M#!6[tp2DHPt*/A6dEcN"V(KN0@4#sK[5'\K++^
#A4W,E%?SK)s7s1sVb<-E\[[U#JGfp."KB:L9>^T^J"',3Fgp%n@dAoP>I=Vkbdr;=!H'%3s
J-#o@n-d=!r^Dk?ioL[3I?&/Db.JYu5I/Y\NrJ2&;#5545[3gBS?Ptu:&7MB[odkdbe/6Gf'
NWjllI@C3H&Qt/<\hN=@<"FE4cOQi=V?iFrYE]AP1_Fo)rPm%<Q$Sbm'UDr$_kIFubM16^5k<
2d[?KG;UV4\Zi2q]AnKQ6[CV:(fOdeA*Ue`!7a6@n8L-`:_O4S"cF/u6XQ$`g#G;(L6s';O`m
$16K'cO$ZgcskP(Fm@pbYp^<;?p%\jVN5m[e/doFO+GfP^BLSi0<:XcT('!CFBmqc[J(bln_
XpDFQIApZM[hI[bg3<Vsun4AKRQ:s/p&r:AXIYra/lJN5]A.JaCO@*%!_NJZ*Ap?XmHPFh@.r
sl08HVPW%8U6TT=_`t<gb*HI_&hi9iHn9^W#S,2&OgtGb(mM'BX<Jblg]A]A->lW6EKEm*(#9m
lufr8_%X\=2kb0/OK=-O)f5p7MrpS878!8r(OWLj^$D2*siCU5;(dl3b*p+TrF/pf#uB2rtC
BFQegnI8N(;::A]A7EJ)GeUn,:JHX\.H$0Z>5ET3MuPP/`/cA="+KWL3/Q0j1oOErirHlT<qa
%uB:%!]Aer1Z'=Q)&)Yac7;&6@naPPK"l?@eAuU_b4]A+$I&f.q9,2o6MLPD\R%1`t9C`^U@me
UF8[-C8/DL%oJ3Q]AD4Ob!sR(ESLj4D6+ga#ZU_5P3,;J!RBW0dba$N]A`5%-[unRD((Dj%Z`6
ugO3te+*(E&HI07[:PSfcAP.5a89nY&oq.lLjrF/eIe$9Xe9'=#>4%L_@K)AE)]A$-Z)t1_)L
,=uFc0<P,c()[(J9#UBq.;J.LR9$mLIlR*r%]A]A"nUbV]Aeo0'+dW"9A'Ee27E8JjV)^.5g)WF
I3LVgmKVaK^hHrV=nXr-Kts+><]AW[cEQRFSV?G954MmX^EeaT"J+gE`=-d%;t\<sHu6$#%[Z
3*[-%Wi9N)QCSEKok89#f@UZG>1dM'_II@3_q1[U8tqn^-JhI_Q?3gYF*CM(-L@_U@b'T,JY
EfaIN[Bm<h>QAI.WAeD<rV*=7XtlW)Xc537tu,/n/=em&j1<r:]A"K9n"&d95k3^e:Y5JJQ$%
.jhtMPDf#"GkE_;A_)@Mp#D_A)f)!8"Wuj8#?^M=6SolA(OL?Ys-H)X;1TaB3`$5D&F'Fn/Q
:$,Ipk(N>DJeQqLEF2%1;[-nkKi""DNlsFrD:1]A05`m%ocH4$ImAAA>]AB5cGW6pQ*Ac=)MFT
FJ6:hu.QGFs*'qB+J4J_AqA#!r"mY2XY>ksL]A2V,SfXnAA?CF^3uC3_?.,TbY%f36X<ea=dh
]AXSeWJ2ppR)qg+FF:Himb&ls_h#=Zp`O5&l7nYV?NI4\%X*3U6hCg_C4o%+4ULJ_cDY-t$q$
VT/9tShjgTS9ErH#[?eB*<&'uTo01*V10,TrJuDW^jB]A8&Hq5oI!t-nmTPVTa>015&S"I&Y!
YXZFH9@C:'U*uJb`U1@b&RWV:YH%(d:%h=^YOjS7_GbH^YT^ecVL=&hJQ9KV4WW4p&:iR8J1
eG[/)"_-G96hI0:_1b%(>R%Y:BIjT6E/[=Z<6g9_(:^"l%7-NOk!:D69]A[g,97cB*uADIY@B
?Ui[-80c^+f6Ktb&VWcPbIY9d)7^tsj)WrXli`@3l03LaQ!-&cYVJ4'OaR:7NLQk!N0#$=u]A
-sPmHkeN:%0,J">)[Zsq*4=4(>C"Ohot0cPKbu82!+a:1:Blr-"6&g;_"<I5XfEiJV!m@b^4
>Hn0d"$DABo,C]AI7,`0^U.eL2Q:Lqcb2[Bgt9bK[9j[WFYNj1:P<6c@jjSMkT`6U7SnZ!HjC
^O\)u7(d2Mj7-/6Qr?<MbMA1d[#mE@lMHt2O66RCblmK;'%]A^Xm&Rm$g7UsLa>EK_;,*bGc3
or[ib`EiilAuiXiC^!l+_%7%&-iWBOQWEY&K>s%>'Pqtk5nUn'hb)[Esoj1,X$4=3^X"+b@X
Xu;F0#Ih?%4NG$'f%4ti!R[1%T@=-WN"lEDmR^/XAXOj'Y#le$,!n5GOiKZa+iIX^0NJc@g.
pBB"^m[+(\g9?uXfmq;?0FVgGQdV]At(0n[t!_afF5\SV:#Q(5rJ\Ysfl59e26r:paV.7NTc6
`Wu.o]Ahg0*+TY!W]AfE]AC[+k_0i:T3s%L_nj6VWS0D:Wjsl-/6>G$@0K^($Dn$`A>C`K,q3sZ
dTh,lnX>8isg8U5U-7n/A2\A=O6+p7/Cc\7Le+SM09;h,R@8,p]A*MH_!PQY1Z5qM*:g;-DW;
W]A`Kml6%PJW]A,)([tJupif[823_MWDKmVW_^ih>T>Xc%LUcO[U8/\kkK9%mBTWH5aRHlF.8:
/Be!L-h`"pQgl!]A3ujZ;FNTMEct_/qXqN7hp`S8ZZL@V1Pb\=q`DH'emFAtf:C/4)d,hD&rm
0,D@.Zgdm'oQ5^_cXala!D!9@PKYo+L:F`;n5TSt!7bS`Q`0hk,XB-Kc/6dcU*\jq<?)$54O
DakPWkF>@R'lCcP9EiOOQu?>BEO#7:Zg&?!r?c`MfHE-5+p^/.m&8-/Cg>&`#hh-R;[;U]APp
h;IX+ULeN=;$PD:)Wu<\5_p2VE8nMXUF9QhYXh%jK%(%_-/V&As`<[p7;K`oG%STRAa3G3OJ
;$Os"GPg=0cU>cX0VM%M!2MbA8]AbV0c^d9!9)`/<j&qIR$pY3(LdCgE2U<_p^j,s.R<]AaKHY
l%$/BZfMS2:/"NGLT@i.+\018`m:<qL7G&i1@5%_)>1F[BE*Mq/61hs!@FhIHW%<JLd"#Z3?
emO&YX4#L6,]AN^A!/K'4o$Oemb2FRTE#7BuD!"t[[rS1S)d#@[Qa77O]Ae!_^.>PNsQ]A216$s
Y&fSI&3J(C?$NYOL$&ldTGqm2\5C%-S)AYMe>t`E/0e2p`.i*=9k!UVdBGP<o_,fj.,1=3of
2U*T++=pS"N/0MaY;c3[$+En[<'^1W]AUUV7>;)`Z%9!/pr6KZd?6=-gn%V[+pLKoU($SZ7GL
"NonBfh&*/A$Ud"A3/5phF`Q-`;4da48AH_Bk:s6sK50$UT`haVMU0>R/_ciA+-Y=C;0uU!c
4TB$Q'fU-_CK!G$?X_M!e^U#PCk3[Xin*Wg\QN34I*&bFhgd*(W0#U$)^NFJq:NMo;3&gpu5
T<2=PjT.fF,/Pc%'"`PP9:`W,=OGnkrD2!X2MjG(adcf%<R4JhUaAFTPcr*9ABoEW#B0^@A%
Es`#1^@'o"l?=7Hb@JMPuXibn'3cQL_LX_keU?i9@l7+J9Yh#Z0^QV+[[AaYBM`XJ>sn^==.
3DQ&1+&P?[,VqBW^*)Hm0]A*XsRe,F@GNtENjoV?#Ok(&icZOj`Igcs_/qM"L(de#r&akmkLA
Zt<s/H0UTftmjuDB&kfK`N\Cje</kN.Cuk-kPXd0KMJ"B$PRMYZr>sTeg$_Kc9Pt<P\28:oV
68,!sVOJ0^oC3YLOon`qmacO_N5,#nh=LIb)I>o>a2ZC,tK@u=C1$a(TQ1E&DG"_)$kR\1f5
W"P9'&p%W@+*@e^6YIB:qOWiWarXdZ3q-7\jM-Lr!gb0C#)ZJ5-9J,ZJh2n$MQf3sm*bh=I%
fCGSYfQ!i.D8!A=t+ZP&VM,JB>p-/F^NCM1]An]Ad)#%O@J:31LMttc\5c._I1glGS:Dnh3B)E
W&nW4Y2O^?Uf:`SFmsUjaOM,j&K#K8CouAI[Vn-6eMk0-D3>8"VT-KsRnMOiK_puc&$cgeET
7?%lI!N(S#Y`dh`C5M7.5C)Ro.]A@W7``<lB=9N[,gJ."S1A$4Qk20pHAf*AfL)[<=3:?`K)b
g>q<F0,;CHj!*L=);4/"$ip&E5)X@2/AEgt>mg<--9Smbd`mBM/b>psrHO@bTF3GJhVOoH)q
*/U9b+I=5-N<qZL&O2dq]Au<$&:]A**QKD>/P:>G`l_\WCD+]Aq%*?1i:?p5]ATB^NE!MWQ=!i88
]A:<"TQRWZnOD<@)fSjLW'D@bD%aq4s3Yo1h0aLfe5BucNU,FJ&EUN*J/d$bZkV44UC\P/u:G
%Dt/ur2tb7C:AIR/VftuNA_3X3D2#XK9H\FeJS[q.'-;:N.nou81/1<6S<Q`#q55Fg#aJ=GF
(]AUaYHpb3!JTe<1gQ-aH*B8JmQIIJgnuu4O<7Zf%9k>,TJ3JJ*JJ22kU9+T5XuCe"m@?YTE#
u9kU9+T5Y#6d!BLS:$IDX<5QNp'#Ui@s5Y#6d!BLS:$IDWQ?NE3F#Uhr.&HRT""m@@..mQU5
=og[Ai%%&_&HN(!-pU:2=ogYkdgFH!Qr\`t+p&+u;+*YM3XX52Qr\`t_R'Ad'W)V<oA:Ss1O
'U1qCmuF)g0QTf)5#U9YG6,a4\-qK%7S[UOA4%d5O^/Ij^7ZrL!>s:I"kD~
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
<![CDATA[1]]></O>
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
<TemplateIdAttMark TemplateId="84e6957e-1be1-4488-89e1-2fbc9e0f68bd"/>
</TemplateIdAttMark>
<TemplateCloudInfoAttrMark class="com.fr.plugin.cloud.analytics.attr.TemplateInfoAttrMark" pluginID="com.fr.plugin.cloud.analytics.v10" plugin-version="2.3.0.20210831">
<TemplateCloudInfoAttrMark createTime="1633678816517"/>
</TemplateCloudInfoAttrMark>
</Form>
