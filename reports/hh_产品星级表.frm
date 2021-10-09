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
<Attributes name="para_bdate"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="para_viewtype"/>
<O>
<![CDATA[0]]></O>
</Parameter>
<Parameter>
<Attributes name="para_shop"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="para_companyno"/>
<O>
<![CDATA[66]]></O>
</Parameter>
<Parameter>
<Attributes name="para_iscake"/>
<O>
<![CDATA[0]]></O>
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
*/
select 
${if(len(para_viewtype)==0,"1","")}
${if(para_viewtype==0,"distinct pluno,pluname,item_total_cnt,total_cnt,item_total_per,cat_name","")}
${if(para_viewtype==1,"viewno,1-sum(item_per_dif) dif_score","")}
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
${if(para_viewtype==0,"ORDER BY item_total_per DESC","")}
${if(para_viewtype==1,"group by viewno ORDER BY dif_score DESC","")}]]></Query>
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
<InnerWidget class="com.fr.form.parameter.FormSubmitButton">
<WidgetName name="formSubmit0"/>
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
<BoundsAttr x="357" y="6" width="72" height="21"/>
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
<Widget widgetName="formSubmit0"/>
</MobileWidgetList>
<FrozenWidgets/>
<MobileBookMarkStyle class="com.fr.form.ui.mobile.impl.DefaultMobileBookMarkStyle"/>
<Display display="true"/>
<DelayDisplayContent delay="false"/>
<UseParamsTemplate use="true"/>
<Position position="0"/>
<Design_Width design_width="960"/>
<NameTagModified>
<TagModified tag="para_bdate" modified="true"/>
</NameTagModified>
<WidgetNameTagMap>
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
<WidgetID widgetID="3c18e407-229f-43f2-ac34-189fa150c6ee"/>
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
<![CDATA[1008000,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="0" s="0">
<O>
<![CDATA[❓]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="移动端弹窗1">
<JavaScript class="com.fr.plugin.mobile.popup.js.MobilePopupHyperlink" pluginID="com.fr.plugin.mobile.popup" plugin-version="10.4.976">
<Parameters/>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<PopupTarget>
<![CDATA[template]]></PopupTarget>
<ReportletName>
<![CDATA[/ERP/定制报表/2021/hh_产品星级表_child_info.frm]]></ReportletName>
<Style borderType="0" borderColor="-16777216" borderRadius="4.0" bgColor="-1" bgOpacity="1.0" mobileRegularType="auto_height" mobileWidth="95.0" mobileHeight="95.0" padRegularType="custom" padWidth="95.0" padHeight="95.0"/>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="网络报表2">
<JavaScript class="com.fr.js.ReportletHyperlink">
<JavaScript class="com.fr.js.ReportletHyperlink">
<Parameters/>
<TargetFrame>
<![CDATA[_dialog]]></TargetFrame>
<Features width="600" height="400"/>
<ReportletName showPI="true">
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
</NameJavaScriptGroup>
<CellGUIAttr showAsDefault="true"/>
<CellPageAttr/>
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
<Style horizontal_alignment="4" imageLayout="1">
<FRFont name="宋体" style="0" size="96" foreground="-65536"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<IM>
<![CDATA[m?rGpPBe.gT/\;r$Tk;#r>JX2.8cgFW0LSTWEZ(@Np@LPAZ']A9W#5K#kHbVVbG&S;ZjKFY+4
Gs4NoNk9ViFqRk.!mIkFG&mEbgN^k%8Mr[C*7g1&(qXpW'i$@t/<A53)IQT@`9'I(ulPm.Q%
DRITn/.>jQCaNl<0W2VUBIC:eH>4@`=m@9pc[F6\Jg%:Q*p=5?XoCDH$Vlb$+A7nu_/_G5d[
Jo#'rN'Q>Feq<>Rf,UjNNVSgF[M-Woa--2ce<!W.iiFT86ZrZVTnLD1cEH3gO\[\N6[*^2_2
DdTa.K]A$/!V2/o+/G8?ERF2u?U'L?_/ZmrtDIC8`ai_de9O*\%e&HZDhfE's*.]A,*NR>TF4o
:K3T6^90;$9iQ86nB4"Jk-@O*2l\o@W8V]A@bmJW.<-@9/NMXdOdFI4)(9UQic9tZ&:A[20c3
mX!fLi?Tbps13]A(a?Y')Nt8DhE/]AB[Ad<et.(jcU\pf+;Kl='lFi&;W@#Qea$=VQOqTm0RSA
`S/DfA/:Zj:XlU"*/:"*s:]A1egqBakM(23784X0XrFFU2uTS$2l)Y<V:o=6^X+'1MP/gFYP`
JmV6j19Y,Q,l#Z!F9h?Z/^ON/b,P\8OrYV/u6)9rY68ng!c:K0Er0H%DkGsD",cWO87*b-,a
Sqlt&:.`TLD'1NF(qX@59/io&!+YFG34`bj0#>'CR22TWF!4fVG9IB=I12&>&9d;VJ=n&tM%
RO,fFJ*bKMlMC%]A[P(A-gSVJCWTVq>eWJ>K0ILEq7jMHn\m.N<Zs]AHm>@hRrB2o2``+5\($8
r<]A4a+]A,<8gR+;Zej2)/3J"9nt*=s!q.2IT-*t6D01W8DU73@<b]AMd6jsO:X"SLJL2]Agh)qW
8L@=!l^M_:Rl)m,["&3T$l:=O-Crsi'.+j_4C-0e\Au$>B;.N=CIl3")IZnOORb3Q%TnZAG%
>5X5+OiXYT`uD@2:+Ued;9G0F;olOh$0R-:d_0)e3F,0"r[b)cp4O\#!rbU&8H;+KGrYNTgl
LWW$0Y%C'Z]AD5cB5<64Ga_C7p,S!tBo%h$0R5AMb2$UL+MVrk*oQ<ojeWjNbjA\h*g#WHIC`
NKIY-ahut$*-NoRfPg(&-@:YQfIeCeeMP2YR:J"n6ned40`Q,Z3uQ6i'hPEnfW$gZZ<@uGZi
P#a7s^Ud0%ubZ)V[M;nZE@8P<2\:abcW]Aq`C!37`g!t5b$PkYY8Pp"uIm[J;.VRd/Il-\TW:
J(r5@[g@9m(l,EE^O2m^NG@"IDYB-#4V1K5oQ@bX(m/9rQ!<~
]]></IM>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false" appearRefresh="false" allowFullScreen="false" allowDoubleClickOrZoom="true" functionalWhenUnactivated="false"/>
<MobileFormCollapsedStyle class="com.fr.form.ui.mobile.MobileFormCollapsedStyle">
<collapseButton showButton="true" color="-6710887" foldedHint="" unfoldedHint="" defaultState="0"/>
<collapsedWork value="false"/>
<lineAttr number="1"/>
</MobileFormCollapsedStyle>
</InnerWidget>
<BoundsAttr x="0" y="0" width="360" height="36"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
<body class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="report1"/>
<WidgetID widgetID="3c18e407-229f-43f2-ac34-189fa150c6ee"/>
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
<![CDATA[1008000,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="0" s="0">
<O>
<![CDATA[❓]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="移动端弹窗1">
<JavaScript class="com.fr.plugin.mobile.popup.js.MobilePopupHyperlink" pluginID="com.fr.plugin.mobile.popup" plugin-version="10.4.976">
<Parameters/>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<PopupTarget>
<![CDATA[template]]></PopupTarget>
<ReportletName>
<![CDATA[/ERP/定制报表/2021/hh_产品星级表_child_info.frm]]></ReportletName>
<Style borderType="0" borderColor="-16777216" borderRadius="4.0" bgColor="-1" bgOpacity="1.0" mobileRegularType="auto_height" mobileWidth="95.0" mobileHeight="95.0" padRegularType="custom" padWidth="95.0" padHeight="95.0"/>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="网络报表2">
<JavaScript class="com.fr.js.ReportletHyperlink">
<JavaScript class="com.fr.js.ReportletHyperlink">
<Parameters/>
<TargetFrame>
<![CDATA[_dialog]]></TargetFrame>
<Features width="600" height="400"/>
<ReportletName showPI="true">
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
</NameJavaScriptGroup>
<CellGUIAttr showAsDefault="true"/>
<CellPageAttr/>
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
<Style horizontal_alignment="4" imageLayout="1">
<FRFont name="宋体" style="0" size="96" foreground="-65536"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<IM>
<![CDATA[m?rGpPBe.gT/\;r$Tk;#r>JX2.8cgFW0LSTWEZ(@Np@LPAZ']A9W#5K#kHbVVbG&S;ZjKFY+4
Gs4NoNk9ViFqRk.!mIkFG&mEbgN^k%8Mr[C*7g1&(qXpW'i$@t/<A53)IQT@`9'I(ulPm.Q%
DRITn/.>jQCaNl<0W2VUBIC:eH>4@`=m@9pc[F6\Jg%:Q*p=5?XoCDH$Vlb$+A7nu_/_G5d[
Jo#'rN'Q>Feq<>Rf,UjNNVSgF[M-Woa--2ce<!W.iiFT86ZrZVTnLD1cEH3gO\[\N6[*^2_2
DdTa.K]A$/!V2/o+/G8?ERF2u?U'L?_/ZmrtDIC8`ai_de9O*\%e&HZDhfE's*.]A,*NR>TF4o
:K3T6^90;$9iQ86nB4"Jk-@O*2l\o@W8V]A@bmJW.<-@9/NMXdOdFI4)(9UQic9tZ&:A[20c3
mX!fLi?Tbps13]A(a?Y')Nt8DhE/]AB[Ad<et.(jcU\pf+;Kl='lFi&;W@#Qea$=VQOqTm0RSA
`S/DfA/:Zj:XlU"*/:"*s:]A1egqBakM(23784X0XrFFU2uTS$2l)Y<V:o=6^X+'1MP/gFYP`
JmV6j19Y,Q,l#Z!F9h?Z/^ON/b,P\8OrYV/u6)9rY68ng!c:K0Er0H%DkGsD",cWO87*b-,a
Sqlt&:.`TLD'1NF(qX@59/io&!+YFG34`bj0#>'CR22TWF!4fVG9IB=I12&>&9d;VJ=n&tM%
RO,fFJ*bKMlMC%]A[P(A-gSVJCWTVq>eWJ>K0ILEq7jMHn\m.N<Zs]AHm>@hRrB2o2``+5\($8
r<]A4a+]A,<8gR+;Zej2)/3J"9nt*=s!q.2IT-*t6D01W8DU73@<b]AMd6jsO:X"SLJL2]Agh)qW
8L@=!l^M_:Rl)m,["&3T$l:=O-Crsi'.+j_4C-0e\Au$>B;.N=CIl3")IZnOORb3Q%TnZAG%
>5X5+OiXYT`uD@2:+Ued;9G0F;olOh$0R-:d_0)e3F,0"r[b)cp4O\#!rbU&8H;+KGrYNTgl
LWW$0Y%C'Z]AD5cB5<64Ga_C7p,S!tBo%h$0R5AMb2$UL+MVrk*oQ<ojeWjNbjA\h*g#WHIC`
NKIY-ahut$*-NoRfPg(&-@:YQfIeCeeMP2YR:J"n6ned40`Q,Z3uQ6i'hPEnfW$gZZ<@uGZi
P#a7s^Ud0%ubZ)V[M;nZE@8P<2\:abcW]Aq`C!37`g!t5b$PkYY8Pp"uIm[J;.VRd/Il-\TW:
J(r5@[g@9m(l,EE^O2m^NG@"IDYB-#4V1K5oQ@bX(m/9rQ!<~
]]></IM>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false" appearRefresh="false" allowFullScreen="false" allowDoubleClickOrZoom="true" functionalWhenUnactivated="false"/>
<MobileFormCollapsedStyle class="com.fr.form.ui.mobile.MobileFormCollapsedStyle">
<collapseButton showButton="true" color="-6710887" foldedHint="" unfoldedHint="" defaultState="0"/>
<collapsedWork value="false"/>
<lineAttr number="1"/>
</MobileFormCollapsedStyle>
</body>
</InnerWidget>
<BoundsAttr x="0" y="44" width="360" height="36"/>
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
<BoundsAttr x="0" y="23" width="360" height="21"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
</InnerWidget>
<BoundsAttr x="0" y="23" width="360" height="21"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="report0"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="report0" frozen="false"/>
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
<WidgetName name="report0"/>
<WidgetID widgetID="d2984f73-7760-4903-b705-abc1613c691a"/>
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
<![CDATA[723900,1296000,1296000,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[723900,2016000,4032000,2304000,2304000,3456000,2743200,2743200,2743200,2743200,2743200,2016000,4032000,2304000,2304000,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=$para_viewtype]]></Attributes>
</O>
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
<C c="1" r="0" cs="5" s="0">
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
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="6" r="0" cs="5">
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
<C c="11" r="0" cs="4" s="0">
<O>
<![CDATA[门店得分]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$para_viewtype == 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand leftParentDefault="false" upParentDefault="false"/>
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
<Expand/>
</C>
<C c="3" r="1" s="1">
<O>
<![CDATA[分类]]></O>
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
<C c="4" r="1" s="1">
<O>
<![CDATA[万购率]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="1" s="1">
<O>
<![CDATA[星级]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="11" r="1" s="1">
<O>
<![CDATA[排名]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="12" r="1" s="1">
<O>
<![CDATA[门店]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="13" r="1" s="1">
<O>
<![CDATA[得分]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="14" r="1" s="1">
<O>
<![CDATA[差距]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="2" s="2">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=SEQ()]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=LET(A,&C3, IF(A<=5,'<span style="border-radius: 50%;width: 2.25em;height: 2.25em;display: inline-block;text-align: center;font-size: 1em;line-height: 2.25em;background-color: #900;color: #fff;">'+A+'</span>','<span style="border-radius: 50%;width: 2.25em;height: 2.25em;display: inline-block;text-align: center;font-size: 1em;line-height: 2.25em;background-color:#aaa;color:#fff">'+A+'</span>'))]]></Content>
</Present>
<Expand leftParentDefault="false" left="C3"/>
</C>
<C c="2" r="2" s="2">
<O t="DSColumn">
<Attributes dsName="汇" columnName="PLUNAME"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="3" r="2" s="1">
<O t="DSColumn">
<Attributes dsName="汇" columnName="CAT_NAME"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="4" r="2" s="1">
<O t="DSColumn">
<Attributes dsName="汇" columnName="ITEM_TOTAL_PER"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=round($$$ * 10000, 0)]]></Content>
</Present>
<Expand dir="0"/>
</C>
<C c="5" r="2" s="3">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=1 - (B3 / B4)]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=let(a,$$$,full,'<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" style="display:inline-block;margin:auto;" viewBox="0 0 16 16"><path d="M3.612 15.443c-.386.198-.824-.149-.746-.592l.83-4.73L.173 6.765c-.329-.314-.158-.888.283-.95l4.898-.696L7.538.792c.197-.39.73-.39.927 0l2.184 4.327 4.898.696c.441.062.612.636.282.95l-3.522 3.356.83 4.73c.078.443-.36.79-.746.592L8 13.187l-4.389 2.256z"/></svg>',half,'<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" style="display:inline-block;margin:auto;" viewBox="0 0 16 16"><path d="M5.354 5.119 7.538.792A.516.516 0 0 1 8 .5c.183 0 .366.097.465.292l2.184 4.327 4.898.696A.537.537 0 0 1 16 6.32a.548.548 0 0 1-.17.445l-3.523 3.356.83 4.73c.078.443-.36.79-.746.592L8 13.187l-4.389 2.256a.52.52 0 0 1-.146.05c-.342.06-.668-.254-.6-.642l.83-4.73L.173 6.765a.55.55 0 0 1-.172-.403.58.58 0 0 1 .085-.302.513.513 0 0 1 .37-.245l4.898-.696zM8 12.027a.5.5 0 0 1 .232.056l3.686 1.894-.694-3.957a.565.565 0 0 1 .162-.505l2.907-2.77-4.052-.576a.525.525 0 0 1-.393-.288L8.001 2.223 8 2.226v9.8z"/></svg>',if(a>0 && a<0.1,REPEAT(half,1),if(a>=0.1 && a<0.2,REPEAT(full,1),if(a>=0.2 && a<0.3,REPEAT(full,1)+REPEAT(half,1),if(a>=0.3 && a<0.4,REPEAT(full,2)+REPEAT(half,0),if(a>=0.4 && a<0.5,REPEAT(full,2)+REPEAT(half,1),if(a>=0.5 && a<0.6,REPEAT(full,3)+REPEAT(half,0),if(a>=0.6 && a<0.7,REPEAT(full,3)+REPEAT(half,1),if(a>=0.7 && a<0.8,REPEAT(full,4)+REPEAT(half,0),if(a>=0.8 && a<0.9,REPEAT(full,4)+REPEAT(half,1),if(a>=0.9,REPEAT(full,5)+REPEAT(half,0),"")))))))))))]]></Content>
</Present>
<Expand/>
</C>
<C c="11" r="2" s="2">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=seq()]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=LET(A,&M3, IF(A<=5,'<span style="border-radius: 50%;width: 2.25em;height: 2.25em;display: inline-block;text-align: center;font-size: 1em;line-height: 2.25em;background-color: #900;color: #fff;">'+A+'</span>','<span style="border-radius: 50%;width: 2.25em;height: 2.25em;display: inline-block;text-align: center;font-size: 1em;line-height: 2.25em;background-color:#aaa;color:#fff">'+A+'</span>'))]]></Content>
</Present>
<Expand leftParentDefault="false" left="M3"/>
</C>
<C c="12" r="2" s="4">
<O t="DSColumn">
<Attributes dsName="汇" columnName="VIEWNO"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
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
<Style borderType="0" borderColor="-16777216" borderRadius="4.0" bgColor="-1" bgOpacity="1.0" mobileRegularType="custom" mobileWidth="95.0" mobileHeight="95.0" padRegularType="custom" padWidth="95.0" padHeight="95.0"/>
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
<Expand dir="0"/>
</C>
<C c="13" r="2" s="5">
<O t="DSColumn">
<Attributes dsName="汇" columnName="DIF_SCORE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=ROUND($$$*100,2)]]></Content>
</Present>
<Expand dir="0"/>
</C>
<C c="14" r="2" s="1">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=IF(&M3 > 1,ROUND(ABS(N3-N3[M3:-1]A)*100,2),"🏆")]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="3">
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
<C c="1" r="3" s="0">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=COUNT(C3) + 1]]></Attributes>
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
<FRFont name="微软雅黑" style="0" size="72" foreground="-16776961" underline="1"/>
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
<![CDATA[m<j+[PM+M?dr^fd7o<,eNWft[:m#)DW$=o7:l:K.OXO5Jck;L]A'Gs5o;Pf'1cpUL%[tH.]AL)
0"r,sm,Q%3[tL#g%MTW+XDdh`'_Fc@,-TI*]ALJ5C#fNS$i"EC]ADuS\).&rFj\'NgK*R@@U`g
$/t>.A,pr>VJsb1L:>]Ask5&n9Gn!9>CC<)%75@"aoT>PJoEp-+Q1&7Yjld!;dkrY[n`jt!aH
ndYIr6?D%o=qF,`AHQ4X6]AI@c7X#EG.I8*IDL-XLUR-Wm;?t:ThAqPH\]A=EDZ*rk0Ie/!LRH
VhVcbNdph\#"e>!3d3l=ER?W_ta?SS&W,-F"aI<dujGh#1X_R\u#pRZRZdu-r"pqH.8HJaX;
EO,,5O;Ar8amk^5nsS&gOOu3V]AWkhWdbD9/nA>RXCJ,=TD2$]A=Ha[2k'Dl`rRma4CqsVJKs"
FQjHRWC+^jAjT>=j`g;#^)Mm#UUrM>c]A91MLi!Ok1onD37gWMf5-c>3lr,=a'W7.rhh0hc<R
lY0!N/E*f<14O`<DM'6//<=0L+4MR+`Is85HE(GUskG)t7IZ]A]ACs"O8,Ph<#Y57['kio3*t/
Rfj=Ri)mA>4TZi)]AeB^I6pRuAl!Ne+WVm.[^,S1Qk'l"Zjefe.C"linL34lDk+eb*+"Bm.=s
kWmd^hr\jMj]A'$^fG*`B$2`t(@M&biDP7_Nt`gOaIuE6dAgN9f<%(pg./6L_[pRd2C<8gprk
hlf\0M5@loMt!8eSi;7GLK:LCSlF@WI7RL#f1`k"nVrE?hBrU(T-1,9GB_?1P6VjMEi#EUJS
U^XSi6)Q'76S>NIA6^5/Z/>S_]AW%Q(WIFQm1(n`7/]Aqc?67d`*GSt_H@d2)oW?V3>HLN`f(m
pm8!GBnIkM[fZPj6:`hhekRAQ`q`n+YcCnMrqV`RR5^'ep!gIooVON_:E#%o+lG]Ajm-qbjPV
[qO@Hk'G2(%f[F&KB_=^R,NKH"hAgP63m=k1mkG.!a>JD?Y*=9o$s7M)JG5+*WjMcls%opUB
p#WF!dQD0n-P[TJ5F'R]ArP`SL>Mm[:2BqC.XlW1oF*qU]A-D>[cjags2>?c_>pn?N(3*YJ/\]A
I^]A#NPQ_0>9r95b*tWG*CLq9P7E>.,<n51-Zs;/i@`gPBdKjRgDGC9LA"1;cdkaW\&&.YJ_h
,N?mr)8i2r\($1']A.qiEo1%6,^^SlW<K&OBN"f)^B2ScbBB'fQ,[QVMGJ[GGPf[-Hn@#a#<V
&G'u;q:%5RC29?3J]A/r@dEt_Y&#(\70ECCY!s)HH-8Hn3=DiT$-9l0)1-;"or;)H;,7Xk_^6
oT)4qWrr>0(dQuj1b$Y?-#GnWRNm^T=6b]A9=j(/JP5=.,Nq)rL"@f(*ghRgs#f[3W5;`*au<
#./pfWiRMQF\L?"h&2q0m[HqX:piZ6W1PYccY2q^tgFP^W<]A7V[.q81LpKJr#N_M,2ZpQMV]A
([>[!p)du^f\>(r]A'^b,.$j/A\T"5q@I?5-O0=1hAP_Z:@U]Ae/_FkproaI8eo$a;o9]Aa)a.5
r(%CYuK#(WB;>6>pT5gH?,:4gaaJnC&qB's6mkF7dHH\/dM&plk!AIDP\MVFgXkchSdeD;U)
eW@LBc3oiScmRk_KWAVRf<fE5rp$Q&"!$iP/@6,&;rpul(hWMQgFE)MQE\7bs`fq04.Lb$J5
H,NKl:f<`s/sPT5<mn@hj,>KoL=3qrgUQn<#_0eqnP=ZG4[8ceC>Z!m/*Jh-7ce0eYh["9TA
WrfUU+]ArTth0%h"!C6oYg-[n#=<s-PsR!>jdGRu%N,\Er/PYfRPje_tX&mH2^E!7$9MjqkE$
^56jKoUO!p%%hS;gPSGo&[N`*pN_OCYK7]Aj[JL_en*X1L!_[jT,PD%j/CNgjF^3/5WD#CMni
"gUBAC2`$/K/sirM^+%$#Y:QH.jqk;DAT;]ADQ)r2,>c72Kng2W8M)]A:7d6_gN>]AQ<n^J@J!o
f_?60*CI++_lMm]A[\<\Q/HM0J)JOk@ADf`oB,=d?a:8)QGE^qX8Do6HfiK>#./j.K::Hb]ADL
u_=&Of/',cI[QR=n]Ampi:/5AUZ3UJ2G=M(1PMo5/[YU=J_K6>(QH0"gtg730De0_N^4BK(K2
`<S9_+eCo6CWCf,$P*K*6jo1]A27"'+)DUdhE8*;2"%f,CG4dben$JBi$i?'<D0q2$SO*h3UN
@FK=Ia_:^/J]A.j)6"28'h3Ra09#q"&5q&R#3<tW40=u'\>R_kE,O753PAD4d'#Wc:Kgbp/As
ikQlcu$DEPI?s%2,f@^82S6e.]A<;H2-/@<nQqbO#3K)`r^\g!6Idt^@S/_bP%-(eoc7@NTSg
$>8!/*/T-@4[X%:=gpBRV;UOi5A[/mgWikNj,Aq$<*n`>4*'e5)N_RHcJFMFa[=oIW3TJMU<
2h"Q0duB`\c$(d@D62!igth[@=sR$m[Os/`HlNj[O9,W@WFK5jl3bI`OF[1Yu-a(np'=7d(W
`3,2KE-dj)JMcOEV163GSN`Dij=`/np)dIjn8>N\-:TH,p[HW2@<_qE0bNhLOdn*0FQj8&l3
IG\$q*]As8WQ$]A$_jT14Nr`Ud&FKV!1IjDd:Vf26=df.X^l@QJQ`KB9Wj'Ie)h+/Rfr,LF_o;
.'^6JIhHMQ4sAk8.M2k2$BNeW=X"A2U.42@[fW>hH^@QoKats!WYC&8eZ#LeG18aN)iECMOF
)Ra+g^[9?ZWTC8CIYdW2I?W_;*(eCNOFHb_=S2B,I9>pXYY_oKk'-n#MH3uL(ikttETqk\*X
DWG0T3IZAOfBt-_.:Xk%QmtUQM3Ja1rm[.eZgfeb=$N?WVSLYIjqqAB4,MQ%tX'aDR-C)g[5
jY,TBi$eoSt4)r>*\Ua%*&3mgXi[r[J<eU,89J^SE3cZqq<^M<:'XhBb\=ml^1$0>O5V=[H.
fsr/mfgTiL_@ZjMQ<I8#n;[5u9=p_&d0C.f*t<(/M^e,,We+UG1A*pT9T?Z09t6[bGa\15mF
<1;hdl"eWAgA*a3kj+>,[i@Ta3V'YX`T+?n%LgP#/faM/fUQr"tjYl%N;17j,SA[8"'15/l7
(0N%QF"jENn+.UtZ!V/I3X(EVa*60(R1YOpB]AeqSeJ<VT@d_kk-&DdG++:AG=RE"G#B6@`j[
tXg(C&f7fj<9m99]Ar5%:Zl3K[AXA^@OZIfocXTWPj[GAO6ksK'1b^Qn`XABNMD!P0m\.2KS(
@4;ucdu$3o'o5KK!h+&c)a#Gpnb40nSN:GdJ0P4(lZRXAl*8lWV'1qu(Wi&>h?"^oq&9l2WU
E4]A-gAU.=O2jVpk,V:Zu7?(K(-nskSFkF6/=KLLh@N-jmg9_Q-LW6fu3+pM[9.kps>4JVF="
eldn:3388H6r,k3M'iPNZ7-X*!i'mMQ>eX@\#]Apgac=TKK^pJu?,)=,#%4W8Gen<k22Cs&Jt
#4,1Au:R'0[:UBS:B2=g."N[B-26D?iWBOV+S%g0)$H\E/Z="1J=KZ]A-8h'<kQIq-M+`24;D
g;s2DluNppj+Cl^2SuGU[8(fKnW^Q-5)e7"_XHC.n;tQ2/a?u$.pXS"MF[+b[:Eo@h+rg>KM
Y:]AMR=*94_2QKYBnI(C9HGL&DqhH.uaeo+Q(Wc$,jiOB4X]AFSd4aC#0JYG0U$0KTe:(m^XV=
4fkV2PTSAU;od3sfoUR+4d10B\chq$Qo#O/FiNirdj3E7\:Tme=siVW3jfp-6_uLK*r8?<GN
2Pm!k<M]Ae>;-(au)D!FT@"7(KjPVlSP_>[cu$P%.5]A85RcR@([PgJ[7=Bb7]AW(nj@QPHO]Ar:
L`i<^WXU?[aY%:pa)g-Rn>nZ,50+RCh6*T'[2$1h54Y19tB$r5-CYa%_;mkmXl_1Sp;pRtaQ
$.c,0k>S7>ch",k(`of.i]AHG>,55Jg%._MT%a-hm:c,P<'IX!51m%]A3/N;UD9TH)%(o@19"N
EWOd64&R^(C+.A8u<!+`"oq_.V^@fU&;q\dW.0IITKf:/.SN(3:K$KllIJ7aIZ";8<tSBBc2
/k>m88S=F364Jf<5kiXN->XC.6T%p0:YW,LhR&!o27YOgk2k-E48E\`[BGl$Tr$LAg?3=AcN
iKV-h+Jt7NSi0qW4c]A`Hr"ChAh>p:Neh1Q83DQ3_q)eI=u`<`[?>1n*3\fe'J4Z+%b%o;AT]A
MkEA_)A$'JO'E]Al=Emqi#KX6Ld;9AWf>ZfGY'V=OJIBM8QcLmZjFfaocm`cR)Od30-3R)hHd
*?^Z-6aTI'jkdQ;HRP]ApM(NkfI5Q2ZIGlalHj2%$S7Z*1]AE2BNPj?>RGHg/gt;#s?Y]A5=)sZ
.QcEjkegR5:8[<K1p*X^V1TjQQqkL49LJe)t=Bdn%YF"=uR$%?$!<(35p\gN0]A#_sr2C[?]A!
CtY/?8?#).$9i);9BLMu9L5Tc+aB'-P2E"7Mjr\N47<emQ%M!#5d6[f^IOWXQE\_13EOZWD!
KN?6Y33o4Hf%oVUsmLNV*>aoVpb6-beTPa2*1!ph;^L2VaqRpL;!?#7(/)a3+IqKPi#?:U4&
,\%IEUoU%c2SE!6eDTr!C7U3u8,Oi=NDkB*SGrn4b**%m;q,p)6U0Ulp1!1rD!Xt3aF#1h^@
$`#C7iTZ^'"aQ;)*ko@pud$MVdu^s3F<,m*`P]AsSt>t,@hLa;@F,mU*#NHn0GP8j2H[BY3VP
!ef=gbpW(G:jO6i`5ftNp9KY2L4@7qI/?F9DT0Rhs7OW_9tj89uE?Pe)D#/<FG0k,=K`%oSD
LJgtp\KH+["_#CZU6\fB"!#Cfe83sP9.cEO.u!jL9s$(a)q1,O#(+c>1=(p[qdnb!I&+$TS!
Ko;>U(\:0\T+1+l"0m]Ad[qppioJfV>bkqS=GNW/a2kO;EkFh?pVH!'Eo'NQD1mYA$V<u&m!S
2kj\,a7OBNj=j@%\br6kg6LY0/^i'T(pl,[sTp0Q_7n3MY"2u4G"bEXmKT89`nqh6WYi3OaT
gH0<k6Ckm[2-=Am*I,@6RRlSRUXjOH5.cM5$&d^%GGbc1qS[O0]AYaZW8Al\I5-9B/@aCQO#-
H8\0<"8+3maLhCO$><8XI&@B\_:os,9%rRCqXdag5\K%ZBR!Xb??>VKFe!1#2bR^"7ePC)'o
:L5n^T<iDg@unKDAXo1,;?q`+4R.D%rS'\"rJEI7VLQq)IHE[fjaal5`dAG@YLbDl#k,6TZ#
BCmEjJ(#mr%hiL69pT83Wp[m[_]AcAki<ph-Y&dZDAR@1V_lus$:tuI"aq5a>rQ!f]Ak#JBN4j
q!@c>CF^FJ[$gA2n:]AsUEbNIJJ6f9:(7@0T0kJf;a59H(k*uFdOi;F_!Fu;smBKW"s#_TCf/
r?JC[lAp>U,cT3D;g'kXL=''-m5(\m9p9sR7stbbnOF)4>gQc@,m)J/9tYb)5U@]AZgoYF5'9
5mCl(2m3JE2K-JTV<ah'-BbcWr9[D.#;<Mc@3Tk;[@&<4\gb8"+!^Dui[dSL"fqrlfGFe$tW
=E@EcMUS!_A*'EV((U")0KDfbJ$[q$Mm*h.dMtNGdRMN\^abj-rY$jdYAUe*Q)kikAWJ0>Ql
ZBu*\G.>(Q:c7ghSVie%kc/cmJe&1[@Le0KRn42<nbbekhFD-kN(YI/E-3+skd?-tNOg!MDW
q!qACdWj@<oU_C&Y>Jn)p.03I5hOdX<CScUR1__a;Ej'^KIVjbngRRl-b8\(1mdkI<]ACmE?g
Ad(/lMp=P4?RO&pUS!--Tq9Tc^m9k5@(\fqiipJ!24l;__*ImH+m6Oll,%5nG8gdfQg\]ArH9
9.;?=MuqRHiO8Doj)o@e2N^$`br527[doNk\OkbiEl3+,Lqj:[m^b)t$k2IOf[>N[QH83X\B
))j\<MQrmVAms@W8"n^u#Ona^_#.K`]AN,bf^L%c"AhP)lghodCH7uDUj2ZWAc&cc>QRH$#&O
>iZ<Ud<+/#MG`fTu/Hi2PlL\V:1b`?j?Lk:-4-3-!MpR?'6!>`H&Wo53Pf""Jf.;Q1ODc-l\
mm[7nq1-Kp=DJ6p5o)n"u+Tud2?@qhH66H?%Ula<kL$sjUr0mT6g;tUq#`)ljTA3dj)fkP_V
j3g<?\$gr*"_!sSjFJ)W!J1:(Mp3`dmC,'_X8ki;L.q1^1a>hdi"O2r69/5X%Y^\V6ILV^O8
3b^n,;sL%K?ti'%_Fc0Qe0bVBVQcq-=RLut:%O)0!`Paa7V@cOU1ANm,s#;kQ!MUBf(3S(%N
F5^=K'i/G$1.%>K8dtd+a<Uf%E6P*Ea\1JgCZNb.S6c=e-oU?M:$OVbj%1RFjIik'on`IQ$g
(YfB7+/AI$%XZp(%X;?LJ/992Me(A`+35+4^M!$oU`SYc@ML[HbS3it\2X!'#9pm*RskG<5J
^FuT*GcBYc^(kFpd6#6P?:g93hguVF54gfF@YgU&h#h9UK5V\s#GL&m@]A/TSbJ/n#jP#Rc3p
o<I(N8A)K*#E*PPR2RCB+VH%0s!8BbB&?f(*!=ZhI0(Rm5?]Aon^s,)V9$j6!W)>K2N>U("YW
Y!d;!9O`4(AE\$WlTo-s-V6'\75`(3''Wq\N3i0h75(QB[U`3rEF?oQ4"OAqC'9AKb"S3J=D
kqaX9=MJtWL95@50iJpucX*:/mY_t'nfHP4UaW0B%(NmQ7tS1E%@5;KZRb]Al4<4a=;Ai:LC/
,7MXc4-hG/*q1Si<o&?fK(?7#1)C#T]A[G!6@nPQ4!-UL4NgCI#),MGA?L;B$_(RKOl[Z64d!
@ah_&&lET+piO7I,Vd4@0^*#FHr;$sr*^5piP^]A[)oL"2Zalh6mdhp"9H&P;rq8##)Hf-CpY
h`^WP[3c\G_7f"I^a7?FNuIgo\;CW)K^JhjX4#rZ)`r28E:Z]A]Am+?T>\q=ta>DKk;0VZaVTl
6hQ!+[mf$6c&n:q)o=2=+`"f:I;]AKS<(A;.+6nrT`SC0ma>iYO`q*oS.?2F[s3P93/5'5#UJ
6S4G#;;PpdkN-2'&?^lGD6cL-gV_Ckc3<^kCjUU?-ES'qf^!ZFA.En'Ca2`"k=5H`a$+:TX6
jH,R>YI*9p)VbX;CUto".TGgH1pZC,R/N.,_?e3rkO]AnMr/HPk3m+._XN+(8]ANJC8[^:c+/]A
T?VN#9HKj3O2*GFZS?4r%lc^idb<jTqhS&,CV%X>&j]A?7'BrD"jlgd>bA*^u$`i$Lrlkdfso
8P]A0n7t/PYn7H)*e(LO<5LVtdT=K9!D=.!7m]AEsj.[.+67Na@0=?N>+d!S)1'bMXr#+VLrBl
HeeDf^I/9S/O./;BL`J&`%/N?*CMUJuJZAseqm"^c3#$*2QQrUf/:aae#Z*0eNoV=q0EKgSo
_)a:`[9e^4?T5n;=m+h5'+[DWLq+`jmS(7k9:;H4_d4X(V/7RaZ\Osf"1R?A;Vs[me9oF^rc
[`FgHmMOfZKSl1r"1FiUXsKrA30tWQ4T>rt)-]A8g$sH.6mFak!J6]A#e9r/,o`QNhh=t-d5gX
k\GkAH1Q<U[Q'O3pO&!FHfQq)@K@nAWd??8nS.UN*5Zn:I\VkmL<(^mjU*>9Es%EJ!^2;'(7
b)?XO&VBf%\"r>Trk-1KoG;D%PGK]AhQDhT5qV;(QTsWH*d,X2ZhZhB8+b!Vifn'NQ)2D-_UO
[L4S<&Na/<r'a_B:f!=p2Bn;[of.,,]Anr2+8JN3[OQSb=N]A4r;jF/#=)Z9qmj-V')_)T"I?M
5d?h\=.5p-ZGPa.OPKUV&@gZ_<KM`@r6HgV-?hhRk%7h]Al'Ck"nkLh_Au"F[_KYuO1.7n*kF
%oVA%q%n(lnhPGh[-/r9">G6)G'YBX,d]A(KW9Mai1'q-2&,pZ]A`P?#hbkM7Kf\.*:dk$/Han
?)X5)5EF:)s&CtU'V`_,tc/@Ld=ph5seP@k_YkX[5Ei1a.(s*=)i5R05ZWGu2m3p`c=n]Ao]Ab
nHpUrNLD\*'7N`&7hSXm54">N*C_E-+I`UZMQkC<`s0bes[3Y&]A;/j;FbIV<1%NpN@&Koh@[
Wfd\0be!:thq=9tg2WnnuFB9.c7AAWd8#cHbanGH25pCQG0o7"`1p05H6,gGH4j_i8_HeXO[
VOS=:'isZX55%e@k@@`:j";_V#!OX:OE4Z!h=.maW-2i9:l_p6\Lm0fIL>aVF`0u^S1[$LS(
>C(r&No<2D]A!U]AhcW#C'Pu\gCpo=IVD!R(!BA$a)=B/H)/IUR1WF>cmT$E-">G^60F$O/>;;
Y_=)[(+R?^=)>i"9(TQm[;o2WA)k>SLr`%XdjE,4_F^qZC587(*`@V!0\`qsEQ`!:-%$mec7
0N7ZkHbW\q3f/ur/4Df!KX/g0)1RgnM$i6V>ke%[na8D[>aNlIUDOf`[5%?@F=H9W^ocp7U/
45n]Ae-o'%d+jE]Amr:i_7r5dL`1!3%)sP>!d`,AL[d@GF577hpbgk]A4"q_]AHp*323+)E<5oI;
5;YncA.R![mU0qt.=Nkn,/L#JWE2m6V=mCc$M!-e<3@"ASmmq,BialJL7r/L/NBNui0E?^k%
'%:ItP3R5Ellal`]A^*X'6O/S2;gO1-VoKCW#[;)ic-sn8tX!a!,uH4r.;n12D!saaN_TjPi>
hfnnd]A=]AZb8m*-S/BWMG[Bk\f()$\V!CqFFMm3m<?HFM9oT&k+LhjW=U#7M$<Zf4V]A]A>.(#d
J(W1Wr=mb^rG<Ha5$Z-#d18PAC+&#Tuq5*\rX,1O1P()h838>87'\+[F(Z.Rnmi8ScEV!:mM
IO1uFejGDH8DPWK.=BVcf&FinZdQ5kihl#Z>EjRY5W"r]AiFp8%M2!Q+,aBbe9:iF29pTT!aX
JO2[M'>8c.jYTMcZU"41?@P5F<D3-^f"Z4F+R5mm+m\BKFiij%jO'.u1msBIPX&7?[sIbDrX
;Qr6]A]Ap@P5=J]Ao]AT+)V:UQ@#aJeJn;@f]A)tZ.C6Fl9f;pgj$H9601@u(jPqWE[VglmR.SDPd
"(Y[Us0J3+:L`\)'5P0;*$E.1-m?K1B5H5Jf:'r_"Cn[.<+lcLEkm7?F-+%=mMU*1L;adaR@
]Aq<XWg:=]AD=:NL$"Z0<!N;01Kb;g.M\!8do_.r0D:d3H>^!Q^6>QSJ-S<\CTVlN"]AVFh5]A_.
_lMI3Gd:TcK'WMtYEn#OGh\,aI?[\W7EgacEL.QAgm'=\790(,:Ho5-_K:HlR)a\Qs5Dn6+a
>aM3q;>bn-cM)EA&g/iM6;D*f460\YO]A`I(Aj'FYR4/O_D5d$'nLN0,C'?8V#Bkh=_kKYiBt
Cifn0^5$==Y;6OZ0j>_tlK)Q`_J0MMmL@?FJ-BVr*NaSiYfu\q?-NPNnmWE/gSZHT9%[hY_>
Goj0Y2KH`<UO"1VPDKLS,BjeCQNJ9]A"6[7nQ)Drt))?o<S9&:O)XJNc*o;5*=GuAfE9^6")W
:h\^\'.A"R1tTtj#HT6aGbo$kRLA\]Au]AaJL*Nm@+"i*D<J0p&5/-7&CS,hT=(.q;q:EF7*Ga
-7G7Zi>85dca2eT>#pTWq'OS`>-T+CtlG2j?ILDiGD(/IZ2/:0]Am@+muJ_jB^7>A-^]A!@Dl%
<qT((9Qget%YD@O&MthsFWF0(O$VGU_F;.8nP=(l,ku@XWUbGEQ)X`)Hnm+-SVQo3OMjVpZN
-lV@nmN(-5D$TH8G9"Q6%,AGSnoZ[:qrlRj*"M3:kZZg[Y'-HAtq2JDIt;Nj9_$&JH[W+=%2
`9sI\MG)SI1Pks)\+E.O4@uDeOmn0q6XE,sqb7E2\cF"<#gB\0EZi"IR4c]A>t49_K`B!Vngn
/=THkiNm#Xp./bbte.`.^anpNM17X%.]AuOQWo:,J&k%0"\0Z:W%)0:-Lb[K05(M^fj24*gIg
/=`TT,IXHd8piH%b.^!CaN@KOlu9*aN,m[V#qj@mL>`DD?CW"%e:aLk3]AE1-?H,/*)-f6YP&
Kl2.qM-1P=.@=Ck.1PR#:!Orj(-?>CfKp-aGlIU90anh^5Yu>'k7f4&nI<rU.)p1=O4i'k1Y
qnT@)jE]A2g>16a0jd8akjWo$EMcbD3GO3?4Ud*D]A]A1L:DRtXPssa]A[SNXJl8ft*8!o`qLmK,
,Qfr(Z(+/n`ZPW<,47p0F:R@JUeYGHe8QmBPq!R:#<k$<55Nq[1PFXn>T?aApQUV6p:!q.*K
&p]Ab+1$"tI^o<:b68V+)Khjk]Adm^'C>UFQdSTJ7SZdj17MC=^@]A]A\pQDD,t<4fA(C$D7cCmX
b<(e>Ip#il7e.Hj!]AZo$c;#]A/bU`A)eKMu$?PmG^DOF?S;hjK=YIY0fa@a$1Ua=lt00";@,o
*-W?%$$4<YGX,?1]A9Z:YFe!I6,aRaU7b;sJ>YEdm,9Q&j.5OsWqd&@l*9s@3n0%"t5#m-1p!
*CMf\^Z%HAUPaf$,`U@_g4bMrb+'rYlTIbaKu%U`r6V[$pSuEJA&8h2=P[Ca<cfNH&><L7@f
>.uq:A;?C4@Sn'buLG%l:b9'u,VfWhI!We)9QlMQ6'>;koq`_8ZV$Kn&\4$I4K0sCHAYVomo
KOS('l^ah&Z+LNq:]AHF0a\pGea^MlL5uT^p.C8IT:Y0bg_C2TiYcq&KQf/AT*O;NEbmcH@kQ
<G]AfH,0oS'G1C$,\GW1EeOl]A9("lEh:ZI4+mX@mL=7"5[[4OYUR,DV^fI*KO7aT:Vo3_(sH=
hOYK1=E-^[k:;D.bPkNMg^B=AR[/3-q)mtJ^1Ab;q^gU;G1hAnK50epW+Xc=HMmB+OM&M*M:
B&"j:l83(K+L#n:@0HM<-Z1<fX=WEO]A-fifTngag[Fi5mY+JJ`jO0Dh2(a!!Vins.&504R3k
Fk6H$61U'M(?GA"GHuRV,NC3H6K%N!.n@G8'j(%KQC,ac:a#B%*oR0O9kMI(C%\s&S!ah"[)
iYdc@b3pY+jKm>qD1mj*Ig_b\?b3h_M>;Fbfd"6%"sr@g;*aNXK3;Nr.3[]A2ZJcUjA8kW)+3
Roo_jl]A05/)4T5U4%+lioXW.b4fXW^e#pO;Qe/CFY$3s;:!d&YR$i_1jSqI4h065R(>es,=/
2)i?BhMtghShjf`4ssKT`1V^h4?XIZ;XgH/Tg@V+rF8_ZkPRES*@<&Y(akORAN$)nTFno%q>
lj_kk$#KYZG8]A!7rmj8"M`rO`,qp"!:Q,82-Ans08"C;A)re]A2#`5ZL2Zf*p*,1gq!aJSj]AP
LbO"_5IgeN>mVF38iOHog"Sk*GdGd8G?)DG1EBY^6\[XG[Srk?JlaG/Q\#A3n#e^Yd94_DpR
g8bVJL<ZUY+OR'6tYXF'*hZFNr?]AGZmpS5^W'h"[Qsa_>)qY_>\:4JWblZb9)&$-Y=PTN`G2
R**1iDd[D#q3N&ER4JB#l#V(pMD+ml^?PijBN@1(t9]A1`e9!,oTeWC/g*$Eq(heOO-q!mGre
aM-'epTG>]A"HRDm3ITZ?%81P?\pfdH,@gW9^AaCGaoB^u5!W@Z#tjpW]A\Ip*+-;f0X)"6IV1
.c25JkPN."C;Q[s>,-MT5j<f2.sUC^:\*Yd?I\L65lH(2K$J#ABr[k0NW%&CauP1Slt^fs]Aq
./?s3XI]AZuA7?nK?$d'o;9ZtG-e2@bMCg&"pqKSo_A1B0?40##k87:Cn(,<]AP78acK^[f!jQ
SNk#7_&0Y_I+M+M?7/"H[Bjn0,GQ+nP2Tbo"HN\Jo6Ub:Rk6`3#J:SRaH0,eJ6POT7bd;I2,
f]AQ&[&XpLG+P$]AiKuc>a@48T$I\RVX-Np_-bYGHC+ri<qP3+sLr:/t<'h&+CgO"CqT#Qo3A;
8BJY!%f\AB93+Clk+oZtQukK]A`d2-Z,k_8N9f:-C!(#fmIIhuVJ'#g+#H/tp6,@/g&G4<7Es
/N"$o\MENV.oH*P!P0/7H_@C>I>:3BEcAa"HQYi<@hYK0^33M.Q9-V'-e3cTNQ7oIOJdTS#[
JO>'6qck@d>=aCT[41Pf@@2C6M#7YDA`;V-<K9#dUZ)H1bb?T,Zm=sU1AlBu#g=L=:"(t\jc
pMCVbM[=2'#8rDK@"FZ_(bY-oJ)eoUDkY*)euuSC:!p<<0[O2&cf`4I3p1&+CM1p@;'fl'q>
5;6TCAu%b'Sgr6B6VG[H!V>'\,Ck1p_fIh!5HF)lLf>FK=GUV`LS#Z>kE%M^+VOG2HiC?_^E
6&iT.QEf,]A[9hYP>AlNi*K6).e.DD#s4]AL5WZ3>`VEDZ9d-O/id&^gYOa<Ht&Rk>Qb'U,;Zr
q@6UeN,([s>nW9=/eUrPS;I/3i8J8+Gs,V@WFAfk%YhStFJbR1L:l%_*LsdC!aV"HS!aJHa@
9YLd#*EBH&_'aEX\q%)i'[5Ks/&kmhSpA4*-g'c>E7BDW,G:b9O9tmRDY0qb@<q(R?"2nJo$
7A3,-6UPY!"f$&b,\p6WK$nP_Z9elBjQp#/..Q@$kTHc@D1=0.,IT+WT=9S@H2(H]A1u1G0fJ
CL31Wp0%G&i@e_\P4f/ZPg>p?\WT]A_5mX/9'"cJWKNDJ/Yb/TjRf;E7\0gaQ<PJg'Dk:jB4b
PU1?_#67("6&5B@jsI>%aCjb&Xi*$^O8RW]A6eT3!)d^7BAr6SUVJXu/RedlDoC^-#>9l^=_g
(C9+I.J`glc@C'kA=/B/H?O>3WmU*h+(l5-a"O<4U^FWj!5=%T9kpg$I"Z\>IGqVkYs+U"\g
Qk-B#&a>9e84f23fX<3&JJ=D/C?Hek34_f8;/ni/QWZ7%J`UN7qLXTM/L\7ujZ7&@6!Q)SL&
[ci<N;TY]Aa@gE5$#q/4[NAT8W61Y:e%Sa%bDbsCR2S#Yl)bPD4f4;A6-B:&9LUDc?Coi<&T_
$SU+l$(!o6d-l%o&LdeI*"8d?<CgX;>ikMd]AI!XGkU6]Ag*/A$ibFC)Xd6lJ46KY8$Q<#5!3.
![s6@0W,*"GXHrpo['0Ccu!pAQ>`"il[Ng;B=p/J^PSLLb=otfq9>6bJ-'>*-=?l2%X:tUG7
r]Am%<M0KGW:KY'r^Wjn1W#ZCM)a:Ij.C_rcdkLY!pl>Thp7R7B9C5_SXd#n6=uSC#uK$CH:D
e#IP$F;8_%Jn>2A2l`gtnF'%YV:rqa&/D6,Aa2nWW$P)kU)_-ZtQFjZkR*%`A'kuDR(iP.E-
;isi^RUc6H(d@qWq-OD'[@P_9QF6k.X!',$,^g=m/-&#]AsGt&)k.7$^pGa7%W`n=Yf!h;DrG
'LH<VQ+gI$hnp.f<gcl#u2IY>dEm^C'94#2`-MQ.EM]AHda>]AQLnuVa1+kW[*BeF=+@LRHd=T
1oro'53ctPCtAp'9VL47.4Tl.B;QOoCZV6//,e4Zgiboqckm:g6M#<LO.*?d`gL+8+W9I\&G
3J+C$.N;`Wj4.7dFZ$2:SQorqBn!fGGBnJlJe_a1c[XW5d3Hmuk;C^C^=6V*SrQ6K-q";4P-
YTNdVL'sHZ8/jAg?))MZUA+]AbeDi45qR:@bsBu0cTXoeUlXZ"g6Ic#"*<$B3IhDTmi*<6jZp
a2fY6VQpQ$-iPSDGa1U$.Y[F!(U<K<+o:>XfItJX!T8B;%Sa&S[26lcmsMf7<e6!-7&B=8Ct
"U$t4:ZD<*nPrY]Am2#0a)jVQ0e`n^prmMuMMT1P]AIr`rnM*UgMcUK-l9ZLjbWC_FfZ$>0TEG
l^T!uWi(LiR?C&2nh05jkH_NY%DsqJFFMiXRHWYmV&D8a0E:UB(_*K=EQONfgD4&i'15?a1d
A941.&*;7m$dfAT;@.hSp^i6U$cAB=RM)>kh]A&AudD*`F?P$HSYVa3MpEL;S1e%JIA-7>89(
#NPPB4D>B%!?9-p^rNbml=1IaqckKF2>>J(C4W(DTUdW<!4u"uu_JSpI>PA%%67mC"2uF`!-
7ob#.kX`RM((3.bgY>&Y@.Ph1k0O^ru?SQ3nQD*X2"-nd60Pu=Tp4FGG-`LT,*s>T4GF8TtK
.9Y_'G]Ao;I+`+rJX2=)"W#%fBWe*0;tseb7J`HUFc"I;g3rcaRR,h4)#e#8AmMNX(?BI1?Tj
DjL"2s'u_5%,&c'iGW`"cDBqgNV)1KKbZ31TtceLocWpUSrCaAj5E#d[A<9/=J\C!qh'Q*p0
@0iD2TrO%e<F:3Wn`nCeVnRn&+_*?@=^)/5gqt:g=7J?4'iF]A35,[EHV2]A!ME?ARqn'1Zp3+
_FH<&&c*ohtkjNB,*Y-iC*XRE\0aP>7R8<t>ZOkid*D'1X)m32>aK6QS'sF_^;`kFQd60d3,
A$IT9$np.Jfl/$q/_MX9[A+QObFi[eq#l'Wb6e>*bPV^.@%V8K`gE.rc,F0q_Glcqc*Y;W_$
q)gn.)3eVgIEKIdC)mlC/D?ge["=ah/BIWk"5>O6IqJ^3MKZ6a:>.R,<u5hNbCS=_^_-#>iI
0`<pW9B5O]AY5jusZC16[Df"IX*hSnRD1_jfF5CFHnG;I^!"V!!^douo/9l>m&QDfl2nI#_#I
R!p\m>S3,u"ds7/sgbWL)(rBK.Yl0UQG-,!.=`8LV8nojcF^a6HEJD[G:1ZSG1oU?^=>JARK
ck%#ro!i@Tkf'!7URQ#<G15=H:63":jcAB$$LX`f%/fj]AAnW=*%>$E";gV,ADe:5kT@Al'LO
V'?KOOAV'P"<oL7fZLpBcSA`]A2qel+;m!m3+ITC@?`=A%T^53BW[LJ[!#,Ll#XYbI`.p^XF^
/oZAZRE'TiUj!XDm$lSn's=1NC-r4juC-9T4^_oh^>ogeuZ)dih%3;ZUm.B4[o%?G&8[R&P*
ijq9cI61PG<$.6(Yb1f=@^#l.]ArK/CDo4EUU?]Am8.g=4ir1VOE9_JG:%dZ6:WRK*e"mpeJWm
?PqZusq7p=3PQ#OgY!l-[#Y>sKr9"<f,nndOM27_T!rI(2u68DkH<apfHodqr1A(2<i8I\20
(XIgq6RZ[FWHGMn6\X64kY(Ko8.W!]Ap0Y:31o"H_>?,I)GVn'P84>Z\"ogI=CJ]A["m6g3o;B
3,*?-m>R#+hJHB^/3+#IrB\+cU,2Ait$@(hQ9oKcaYSihBrnE?t@1MTe-u1f`HR6'b;80mN2
klDgB6.d&c&]A@M"<7ipuo.oaka=EWGhUFFqin,#,XiPZJV)^W0SOmBW67Z^>Yeor[7L'l`n&
^=u`"SP,;eJ*^PK8O"GRhB?=3paT92Xk#0A&4^NVeK;)$+!tLJCZe=0]AHHNA"2cdEl.I;/\K
e<XI-4m.mKui`?@BaPTO"l<rjji/NfO'_H3Ql<+>IM]A9;d?0kPJl"ED$BfBmCXZQgd"E)KQ&
^VlK\`'bp)XejR)jn6#H?5V)hbA[TT(NU'Z7"X!GgctmaP_Rg?Z\ua0*gT4c/i1tr-9gq>Gn
"/snQ10D[1#<lI^srV+&AiqDmTe8oHT=*JY/i.:T%S"+1//C>=<dL&BS?=6!CNPlqN44P9#:
[H/jSe?DcJAHCKI0ga;aTB?eIsT)6qmP`pt8lSjT<g&Uo4t-1CO&=Ml6*nG1]AQ<Gi<b:Sa4u
0lqXSjjm,U#mhQjAYUXWQ/ikt&>cs@-_B1.UL)b4ZUp5GH!s_Ghks4O#S[?YST1Kh?5nZ+a!
p3M):P*Ip$H1N8`O,g1l[bind1h:Rl%TqQ7_'7!l$WE8aaoQ"3g\"V?2E!W;N^,:+:->p<`;
t?msatf73mg851-iOT(PM*K[F`",*ic^gmf(&W]A(G4.8L=J>^9]ASV!@96Kjek"4=,gRL6XW?
1OU/2p_rK><)_lWcoj%)pk:ZR=%%YA1GQp/*k%irk[mMG@%`C\fF0H!u6<9jL<2@q30lOq*c
?V0k#FDUf=o@F8epo)J6)i^ju[l<a34^%8sE*Kf6C!k\5Kg[fFp\7)T3PE`.%gD=qt%HhMHR
fal:4C'W!h/eH`tDu"K#j,J@kJ!9AILlXVWGVB\Y89^;3aCg'pP8lq*en/n9?d"Yb>8$)D7d
<6/K5!(9PY,=tK=]AA!14l]A:RcO=b*dkbLJS_*@)sR\>1bVVB>Fn*Ph"jfn3$pK_89WIIl7Xa
H3i,\ua_e=J'/mQJ6Z_k6D8ce/XHbOsaCd+`ChJ,`qE$M[Me9*M>7GXpXo>]Ain//9Occ9K#d
C@J(MT+#IIfFY3!-s-g-9PUTdHOq/Ehi'VfA`fkg/55*%uD5ho83@&Q)g@M]AnBt;h0'IO^Nl
FuV,APD86_1Lj`>R0O@ZS*(%+gI$M0,E]A3kOsb[RCo`9A."BA@D,=A6$/!H56Zm*N5Ce#_T]A
Y5O,YdM%]Asei!&]Afb!H&%f6,!<hR<e"O=G1boRfbP@o(&m(`?HftA$@cH_adX]AXA]AddM7sB>
E"'*THgPs0IEMdBt7JYN5A3LLb9!fShiCS)F:dF$NTPmT9>_j`-tYmOXU`\>s!6oXn#/mCK<
bfNt=+VeEgDiP7723Vf'*Hu?kW<j'Ar`MP"3_W*U/+&:U7417[;LgG8*5P>9u$YSAe-\Bd50
7RZGm<5)rku!;=Xp!:O1Ckh_dC-Z!Z]Aa[9WZTt@*6#]Ap!61a14Yp`A?Yr:K>f8'%?9**(<4$
73j8R]A-o=t<FYitNF?U29u,RIo3GaUH^94&n[h83I"94fCqrjHJ5A&l!8KFT/<55=1-dW`rF
5h,r#$\uVf?cBYi#JBD01+0\I*n"-WCI<aMS1#9^/XR9]A?!XLRpO]AWVQOOS8hQ)9*!VKj%c?
NDlIjp5-#,"uO3(A5g3/JWY,WL@>#MU)p+4Um+lc.N?"+N1<UVJ!]Ad7]AWbgsOh.dLq2lF.lb
ITM<pO:]AG2!-J#X2[ZMl1bIsoCWm4*$QI'pWMb4?q'XC,-&eMZGgm2ddpKGt/9>3m#7utQu/
DVQ'A>6M_A%!DV/Jk_?ZkdaF^KJQP2Am.<`8E\BY.-$#g[sa?fA:G!hW@!_#(+2sVuqUTg"U
<=\uEFJS+d%(Dm#Ab*/_+,J<s$E:\?3sk&ul1\"^cF!DNYU\Jer\B&Hf48&C5W"MmsI[o."T
OX!HCU!lh:OOQY!p=4XQ^E#Kb=pLQ4S^qn7R*=ipe61!aU[I-]AJSKMNqY\P>Xd^Y/8PUUE7n
tO%,5a3H9o?Dce&`J443#tG9p8o?FdlG%LL1?d3tTJk72i+0n$*S2U+1q?X`#kBk[YrOJ8BL
9!(?(*__bO)`"nM3VR*3d!MV?TPcH1k9T>iOTI*kBHDH=h->Jg`[k/8PMGiEiP8o(h8ma/ff
fsi*%0Q\GL#A\(kOu:HdN5TM)1h6odK@)o%%*$;lA*93bPhn0]AkPn7<&s56gaH&0X#h%"U`;
daC5#n`S()o04jQ!3*,1&L61dmI.TE2`F/_s),cUS78lEXlDtUQPiN\hP#2TIQABk-]AYO?aE
NudtC=*>5sh;6Ya:$#Asog^B\5QNto8V$R\Z-`bKEBn!^OWM%$U`:3$!BIC:RS=*7Li*Q7M_
uk6ksNuEhBk\dV3^KodPr[tepjOJ(2L6WAX<.q#LJr:<q!.5&X6\9o<2Wo>[&@u.JW(8$dY'
oV6A^nKFf7R6j&HhTuFro^e\i2W=]A'd@*t;Z(R_KDF4Fe_9+5u/j,X=gZ3`(P>L0-naUeHCM
GNsIZN>aO@g*UX4u)rbkJsQoRR'j3#bf5YJm2Vp&kV2g,4ec:3C.1!ZM=/GhPA0irCR"ECL%
6f^!S?JiTj@+#0rPBiidZmj'V0gDDScH_B$\sS@r:!?[*p'&6\r.('+>^qtL+6nMWDJ*TpZ-
;Alp]A:GVs5DV[#".^BUgr#]A%*j;e#ZH)JOF:+F%\>W;#hOQ/k2>"5$f[Q5tF&6\r.(6:9e^(
<H4,Knc_KDAEOUoeH)^C^<MM:1ijj%bL`6l,g:7<jCSQ7nYMnX6sKfpQ4Q[]A.+J\'fI"Q)]A/
"YcC3'+gUn;/_nT(I*'$.[YETp=e081/$@cCFHFOkHM$^\&&JZZr/Ip_$_I)^iIMEG]A:5",;
.LiUq"HB6H^T9[-1rm?0XWO<<UW<D?;MR=+42GK=o?$M@;ijN9BJB#/SaO,/4;'QObKa1-Yb
l&/4;'QObKa1-YcJ7/4;'QObKa1-aF:dLg#*K$W0PmA0J5i[Icj&s(JYc(b37Dg%a16rUqd-
@#[4efp&8AKb.R!DL*a]AH.-f30in<A-JE.H-ZE<QCq9Do9_UKm`,Q/ZHE'%*X0C\\]A#<<X9S
u\-L3"7I<qQC\^*W[C.dQfn.<3+$+Q.iu7Va)</U`lKhATm(FA*ki2TcDo",aV]A12i.<@1,l
Y7Vd(r6W*-a05\[?IVuM86>e1?H:cDp7FSuc\fs%M5PE5%rSDY"]A#F^3_2;LtO)eN%5Q"Zg6
8E'd:b0L_?s]AA#-r(u<s4[.?mUtPZ.Tsl\$jiD=g.la.(WAu,qHpj(`-s%0Mj*3p9=>s&ZU*
E=-&Ro-[>=C0>`1"kaL-ipLmCS"Gsk:NE\4"J,1e$]A,B>B14JF,7;'+*tM("E5:*S:6as1pY
U-'XO,0D-6+q`oK/Wkk[La\>*[>=C0>`1"kaL-ipLmCS"GslZKY7uHj9(;Z(d61j@4Ce;1E8
N1@:@3FrG18>,Jagtn5?jX03dpDIrri~
]]></IM>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false" appearRefresh="false" allowFullScreen="false" allowDoubleClickOrZoom="true" functionalWhenUnactivated="false"/>
<MobileFormCollapsedStyle class="com.fr.form.ui.mobile.MobileFormCollapsedStyle">
<collapseButton showButton="true" color="-6710887" foldedHint="" unfoldedHint="" defaultState="0"/>
<collapsedWork value="false"/>
<lineAttr number="1"/>
</MobileFormCollapsedStyle>
</InnerWidget>
<BoundsAttr x="0" y="0" width="360" height="559"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
<body class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="report0"/>
<WidgetID widgetID="d2984f73-7760-4903-b705-abc1613c691a"/>
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
<![CDATA[723900,1296000,1296000,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[723900,2016000,4032000,2304000,2304000,4896000,2743200,2743200,2743200,2743200,2743200,2743200,4032000,2304000,2304000,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=$para_viewtype]]></Attributes>
</O>
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
<C c="1" r="0" cs="5" s="0">
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
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="6" r="0" cs="5">
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
<C c="11" r="0" cs="4" s="0">
<O>
<![CDATA[门店得分]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$para_viewtype == 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand leftParentDefault="false" upParentDefault="false"/>
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
<Expand/>
</C>
<C c="3" r="1" s="1">
<O>
<![CDATA[分类]]></O>
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
<C c="4" r="1" s="1">
<O>
<![CDATA[万购率]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="1" s="1">
<O>
<![CDATA[星级]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="11" r="1" s="1">
<O>
<![CDATA[排名]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="12" r="1" s="1">
<O>
<![CDATA[门店]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="13" r="1" s="1">
<O>
<![CDATA[得分]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="14" r="1" s="1">
<O>
<![CDATA[差距]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="2" s="2">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=SEQ()]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=LET(A,&C3, IF(A<=5,'<span style="border-radius: 50%;width: 2.25em;height: 2.25em;display: inline-block;text-align: center;font-size: 1em;line-height: 2.25em;background-color: #900;color: #fff;">'+A+'</span>','<span style="border-radius: 50%;width: 2.25em;height: 2.25em;display: inline-block;text-align: center;font-size: 1em;line-height: 2.25em;background-color:#aaa;color:#fff">'+A+'</span>'))]]></Content>
</Present>
<Expand leftParentDefault="false" left="C3"/>
</C>
<C c="2" r="2" s="2">
<O t="DSColumn">
<Attributes dsName="汇" columnName="PLUNAME"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="3" r="2" s="1">
<O t="DSColumn">
<Attributes dsName="汇" columnName="CAT_NAME"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="4" r="2" s="1">
<O t="DSColumn">
<Attributes dsName="汇" columnName="ITEM_TOTAL_PER"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=round($$$ * 10000, 2)]]></Content>
</Present>
<Expand dir="0"/>
</C>
<C c="5" r="2" s="3">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=1 - (B3 / B4)]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=let(a,$$$,full,'<svg style="width: 1em;height: 1em;vertical-align: middle;fill: currentColor;overflow: hidden;display:inline-block;margin:auto;" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg"><path d="M832.68 400.67H616.21L549.32 194.8c-5.87-18.08-21.6-27.11-37.32-27.11s-31.45 9.04-37.32 27.11l-66.89 205.88H191.32c-38.01 0-53.82 48.64-23.06 70.99L343.38 598.9l-66.89 205.88c-8.95 27.54 12.93 51.54 37.46 51.54 7.67 0 15.6-2.35 22.93-7.67L512 721.41l175.13 127.24c7.33 5.32 15.26 7.67 22.93 7.67 24.53 0 46.4-24.01 37.46-51.54l-66.9-205.88 175.13-127.24c30.75-22.34 14.95-70.99-23.07-70.99z"></path></svg>',half,'<svg style="width: 1em;height: 1em;vertical-align: middle;fill: currentColor;overflow: hidden;display:inline-block;margin:auto;" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg"><path d="M832.68 400.67H616.21L549.32 194.8c-5.87-18.08-21.6-27.11-37.32-27.11s-31.45 9.04-37.32 27.11l-66.89 205.88H191.32c-38.01 0-53.82 48.64-23.06 70.99L343.38 598.9l-66.89 205.88c-8.95 27.54 12.93 51.54 37.46 51.54 7.67 0 15.6-2.35 22.93-7.67L512 721.41l175.13 127.24c7.33 5.32 15.26 7.67 22.93 7.67 24.53 0 46.4-24.01 37.46-51.54l-66.9-205.88 175.13-127.24c30.75-22.34 14.95-70.99-23.07-70.99zM643 547.12c-22.43 16.3-31.82 45.18-23.25 71.55l43.35 133.4-113.48-82.45A63.921 63.921 0 0 0 512 657.4V287.05l43.35 133.4c8.57 26.37 33.14 44.22 60.87 44.22h140.27L643 547.12z"></path></svg>', if(a>0 && a<0.1,REPEAT(half,1) 	,if(a>=0.1 && a<0.2,REPEAT(full,1), 		if(a>=0.2 && a<0.3,REPEAT(full,1)+REPEAT(half,1), 			if(a>=0.3 && a<0.4,REPEAT(full,2)+REPEAT(half,0), 				if(a>=0.4 && a<0.5,REPEAT(full,2)+REPEAT(half,1), 					if(a>=0.5 && a<0.6,REPEAT(full,3)+REPEAT(half,0), 						if(a>=0.6 && a<0.7,REPEAT(full,3)+REPEAT(half,1), 							if(a>=0.7 && a<0.8,REPEAT(full,4)+REPEAT(half,0), 								if(a>=0.8 && a<0.9,REPEAT(full,4)+REPEAT(half,1), 									if(a>=0.9,REPEAT(full,5)+REPEAT(half,0),"") 								) 							) 						) 					) 				) 			) 		) 	) ) )]]></Content>
</Present>
<Expand/>
</C>
<C c="11" r="2" s="2">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=seq()]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=LET(A,&M3, IF(A<=5,'<span style="border-radius: 50%;width: 2.25em;height: 2.25em;display: inline-block;text-align: center;font-size: 1em;line-height: 2.25em;background-color: #900;color: #fff;">'+A+'</span>','<span style="border-radius: 50%;width: 2.25em;height: 2.25em;display: inline-block;text-align: center;font-size: 1em;line-height: 2.25em;background-color:#aaa;color:#fff">'+A+'</span>'))]]></Content>
</Present>
<Expand leftParentDefault="false" left="M3"/>
</C>
<C c="12" r="2" s="2">
<O t="DSColumn">
<Attributes dsName="汇" columnName="VIEWNAME"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="13" r="2" s="1">
<O t="DSColumn">
<Attributes dsName="汇" columnName="DIF_SCORE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=ROUND($$$*100,2)]]></Content>
</Present>
<Expand dir="0"/>
</C>
<C c="14" r="2" s="1">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=IF(&M3 > 1,ROUND(ABS(N3-N3[M3:-1]A)*100,2),"🏆")]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="3">
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
<C c="1" r="3" s="0">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=COUNT(C3) + 1]]></Attributes>
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
<FRFont name="微软雅黑" style="0" size="144" foreground="-236032"/>
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
<![CDATA[m<s1XPM<N!DVZcdE0RK'Zn2W@+=OoLEJo]Ar'r;R3&<L4o"qo`!Cd^N;;F=Cd<([:X)MitX6]A
6&J-5$SIO?c-!b55Z$B:j8&4m.ha`d?aZqss]A@RGXHKbr+*kroTa:)oeMZ0G<5^@#'8_J?\R
Sdh`/jI[1WYf^,tn/+>2ncgMAU&BM.555j64nD"2C@&E"mg8a;"^MQ1`=<Y.m<BrNP@@t\6i
@TNuqW7@fOT`cb!XF5/,TC^oO'eLr^"N=,oC'jXpRC7XA/"A`r2/#pgdqG;Vk:]AiqIkRJUb>
`u("-`eP8EJko6!^_mZHq"F1('-0,c)$?UPD#_l5Y#"F`Io:0l3:5I1;4kCJOZ?W".]A2oTcA
B'r_$J^52JcIArP7YYXB)GNgB`YK,qjKc$hTO74\GrO^R2TUa@,A@Nc[Mjo[#s?(=kfc`V'G
pOEbm1Z@NLiW9nnjfk?@NWN_XG86l@/^1NPJnMhs"WK[3"qNhgYPjiVOu-"U,#onmNWp2Q7&
=gbfAoHo&_4keoAMk]A:)E/ae:$Wk<VQceqG4r4tA7TPMeR]AC'SL\1+!FIGDU9AR&94im=$/$
>,^L6*lbh+4GCVi+%&mG7&@L06/$CkqRqJZ!tU8T=g7T="Oc(,:%4sW/C)dNKfK?GF`BaMc$
h!>&(@SIt):nDYUMQL5XmB%^"8$hl<B)Jn0;SiC?qkk9$T/?IDWPNbigXp<4.<+3D$3IhK78
<^lf9@8JgR-KX;?E`C8B5;\)^J?5*H]AbK.O4ruK2><=.TD#HdNc')\h&ukqGd'9V76#U4)d8
U8PZiK]A`HI@4F=d\J/<p4NBYnN5uR)NEW;lCn9.B=CU78r[_cDShhZILURR.P=X(*3sH@g`U
u1`ljIpWW=KhTjhU]AhtsVG>NB`OnBTiK$76E-&\6`:bUn%A]AJ&h-&]A-ddYg(`4fU+^!UBE:(
1?S1Y.:@g]AXHV"DHfQpRS-tDi4%<d[H.T4K0,#cAHi8`."RR6%E@KWdq''F]AUe^Ud+NYhqhD
V25gIR:r^%QFr7MMY0Juf7(L!FCEuQiI_:uS)U)?/<<2Gn:C-'Oa]A1p9FR)<h&(q216V_m8M
D6TW#R3Q8Hgeo!-$4%'s=fg-<mnE>H@G2A^>kDN:=G$drD:OMjT658j^LEjWbjX(>7+DesiQ
X&p`"njH"FQYOFucig.7fKfFNaJahe\RBP9L82Xo)_h@ilB<(M+R:pr)Mpr\"kQ"C;EFHhc1
fRY4SA7O^UBI2XkPk.bbpWOBA-h4K=CY%=H*U\/Df$bGQ;[#G!Sf'Ve=9@PhD;,?;9X@(lP&
i)D[WAX9>EG-+5VpBm9//dEQ;EjRF@8ZV$k'64^H!9.spYF2XgLU>(Z(Mn8$#!#/K<s1Im!"
LT<@hVI6iC"SAuC@soBQ4?YCb:-f&OKH#c]A3&UN"b;p[!AR\)?e0X90HB*E9u6]Aas(FR7:@=
$RO_4;mbUnRtQ#^gNh>(:EGu.hL+J!10Z"odh7!Q@slnWKJnIlrVFH%`cJf`cJ6Z,^8epH<Y
QUeF"_GcqlB_]Ak"Te,aGKjEKgZgH3j'(X+H>ehDUs,"60)faNa\fm]A*A2*WT0Z2PZ(kj^X=Z
ZNg`*6c5l6CPIbsJ2RZg4ls'2)2!TWXpZstX8bgh7<[ikKc;p4b2%EQk>gYkMO(V5c%9@S!O
1Zo;Zg7jnX(3O<hbfo-V&$0F_EQj)n5p:[;MT^=\)fj^UV2$t#'569h]AE:jYBH_aYlOQEn4]A
[K^1Zn=9>i&jKdk6sW[rE38/s,NA"&nQk^]A.I9WT0mGTl.@l7\g4=32AW9l>QEos^6B?^NH6
a.-<#Oa5MjXGagS>A-,iQr&mrO;kL%CCZn\Hn^I$$$5qcF=-h7TY>^AEP!Pppp+$"ghrLcb:
_B22Qr4#S_dFgY4&4kYK%$>)f,+:-XK78WYJ=K9`N_HO`.;i]A%nmr1#p$_Ua,iXa"$JMT&BY
FEpeZeCb'cZT)HE<.9A#6FTG%9F!f!?Jr("sj>Ri(P?1u\FR4E_pW[ii40+D00tsPuSu!c89
5.D[B$a*9e5oIjDa0R)7DX<kCVl5)?n0PT+m8MsX6fm\\-]Ac<;3NXtF0iPdOT+5L=sj1=/YW
u;H"e*-9Nr@N6Xbo;R,oZgBWK7')B7]AW>V7i=08I$`?VH)>):3]At4StXUI,j:gm=-&Hb`_7=
ZkG1`PkG<-E22/3'-&#1oOcR\Vl4,D#[F%P;)EC:7`3TUkTtT&,u1J0E4ah/Hh:<Skd4,p&k
I:O=>KC%Y$%oU'aH)qo;NikDY17T5;]AP93u#5FP9H.qaZCTtr7u&hHdW=gC*pQT`2CVS?FG<
j;^h]A_Ae!LPmcfh_A4"[o7<XCKEEUe_=P'NtE\nYgO.7lJ^oV^KC-oj+0f[9_Ze'Ae<nIf^!
j'$1d4j)q0;@RV[((2,M>\g)Si3$:N09&rY&%1oS=Q5mDq(/N'tHBcp>oS-LkMt>Qd78LeF$
AKiMb>cQ.n^\YeMJ"^=HrW%G1%@BKK7C0<ZdVpi&^[,2r"9i/QARWUi*)D6jd:HbSt#-u";`
_hBt53f@MS-bP')a]AkHb/95(4J'HBpP<RW85B^Ctcm5EUgW?*8%nIN`7]Ai]Ahh=%5I;hcd\V^
`3oGWDp>7]A3:(ck\);o$31pRhPpo<k140S.'"U;HAqm"q4mrIdXA3hAb9bP"3F8W:bo//\^L
A#oR^1NW@l!7<4@b7r&@e5"ZpaZ(==^9igk7Uhe/elUlo=aZS3Red-lNeq@^t7o9Y!jeEaWb
Nc2QfVQ1T'Hl,ONALI4?U/"XW=/rCeedk:hSC4NI2h[90dabsS2I[*3&KD:BXQ$^89iel)Bm
.Ul5\646Eo&G/B_e+ZY(I+NW7[q(.:e@'lHukml%-@AqWpSf<UBui&J:"-Pe=GR'*b.E]A24j
+c.';Y:i#V'Yfod]Ak_g_%O`cuLm=''`Nk)M-iYT:PPejc26F2*=r/Pa#-BFujk'cL3b;D'F-
Sf3jj7WT=!/GL">g&jR(5P<^M%r,m/@fIUVR)[CaVV\n7[QW7g*nAaNA1*_\0>"8MB'j`Q(n
D"c_$mD'a(ZJ;8<K904C7Z#J<A$4B\ceKTfpeZ`EZ.WqIGY)"21*fm1Zp7Q.$F*65*pbst*M
='R2Z`;F"@3Q2u#uh:<(aPDHG2@qaHG>%H&j=%[/@S$lrc<FWDKHJAO\A2ZRcp<RUtjK0C"8
'c@pNNRHX/,haKRiYm-^)'kGYfd3,O-2.cu1fXb+B]A*W0[6C?Jn;VZ89JYb9Vm),r@;9MCI+
<L"Q;i$t6:F#:el#&GkS^NM.laE6Br5IosQ\EmP$+(qXqkmop5f_^4-eU\agY_0,<b7k<@Ii
2?o<F05<i!fU4ht?7-XCL>=h't<,*i1TVS>PM`L<YY5c5ZHlN9M;cEMj`lef%=DZfc.&Fb?S
Fjb-g<`S(#(Wh2PL*\GHmVK3\[?&.-?28>V$K9=D%1:fbhC10a[X41uA;9+*e@i)5(/BgP4g
?[Zq:+XWZ1Ee<nYNG'hjX.&p:I!</'_44&.l`Do%j24L+fsef=ZVp5CMAEi(WW\NYrqO/qSP
O$Wo.%PmkL#Mr+OC;oE++M,15G$k,6:6k;Vmn*]A/8HpkD>hip-X2#*$2<[j%@7?E1U[f71Z=
laX^uWqt(F\,;N?<YbL\plbdM`l5M(6$)*RZ#Y0M`Cfeu!/?YS9Su2]Aq;02q.7ak5j0_WY,j
<fmXgN&E#<P;78*Os]Aj/O/=Ihju\GtsKjL:gf2#NY1tndlJrU58L)lhO1*')lJY3YQ^<_2*1
PP@JL#cEP;fXdta!0pPBBD6LrlQ]A&tX*7A^=PX2D5b7pV>6\hhh%O<H(S6LX3hHGs/1]AmhVG
CB>J8Kk?O$@1U9+as-;MsPTQT^^_%Thu_%BAj9V31+JTV#d+6k$2$>CmXFMZgRm;_P8RGKhM
=?c<d=idoEBA1RZAcT3RFA*MRcnEFnDs?<s`>TOVWSSiDMu)cXq7qsN_mUM3*%C_Qc/Y,1^!
f9d]AdOdM-[SIdEsgu%`?\AF'93X"_^dW4YhpaT4t02eb+E%AkjH,j[@YbuTE3,$g>4Yj_7g]A
?;n3PI:h9hl4J\PNtf*I5TKlZn&JFO"lm;j"Y(o>_#go,lRI%R[;mQbVE>>CU=45[VF/Ej?f
9hJ-dh^j64.*l\tkDBrtXkofH8Wlm79]AE=I!nEI&Lk%`\+7'+")boJg(PKisLZ"MlKT->NCT
"B>@jok&D%=#r70;_,1cW*_QHP[$uh\HC]A+?u/M1?\-kM`]Aea<ueaR\jm%YH>UL'6+6X^GbG
!U4HQDp7\./U+\UR%SKq5pKQo_I;.Zb8NaKL=W[%5#@LL&e^koU\8T^hp\=pf6MgQ"c2X3d5
M!E3H)qbLs*Y%ds8RCi_[5=n)CA<3509VkC88IsH2!=aVc?H\<c5)7^Rh1dnG5gNEX.X)M]AH
C6F9JPomXT3aBcp!Y,h:Us3.5?"orRT;AB:)RcEI,I[V!3D+-^st2>64[t27"u?GlZkujut&
,WHNI#jia]ARHg_#Eggt7_\S+!o&]A;barKkC%=.HhFJa:Qq,E?0P]A,,T#4V"JLf#]A9EUGd/!%
cH.&UdEB>db;P9SQojjX&s6'*I5m3'+;LsF#Ri?.>/I';]AGdXI-g=gkeb=T+e7KS!qn+s[!l
k:_4rI<Kp[IG%g1C?',qCq:)[sB)EYZ-(q2R]A)pNo$9S3CqTQFU;8igeLR^OdmXA>R=/#9p+
o%D6o)?+W+c/CIlMN/5#!&o5B%&qW4n^NCqs*:3\6ACJ2jiKpk9VMMMA"uAj9$tVF#)DB>q+
".OCi0qg.HV0V+Eg^g:UO;]A&9Q0`]A:5-R`)J9V;[W\>/]A(jb*GN%aiM_L"('?0V\0HPm"h*c
ie^o[q+a9EU,$B!j2iQE$0^ZR1&0UGTT\OM]AT02$<9lTP3%g\`,7\U#A`8\_;?1k4j7136I'
@[#o?smf!&FJS-D%$M+gV8cA2%aFBT5bW(jC$&[2d/A"(J)_Y@_q2OJ9eZ>BeZu>H?]AH5=(F
HCD]Ai0>a\C[&6.B5(n>gO`aY.c5MS8tG\YIm+bZ2-p%^"_oqY;%"XcWWE%JnK5)#UB&N7n0p
mSAQ,XUTWHjk;*9?V`"9^^V,M5mHt!2P\Gd`]APWJI\FW#XaF7SnMp#g>&930O8AO;D3GAfq0
HK\'KHNX=PRNHTsNE`,"B3R53aR7!pfR`9L\jW//RGX&:5NH9H0hmD9_^anSJ,2S7Du6?coQ
K\n]A^4cIS%pmNM2@s,$JTI)gN]AqBJgj?Cs93aVoML+hsL3#LM@dHEY\4IR/<+^bG>bl+4]Ae#
DcWHl72'>d;6J%#R-8/?5'G1lpsU"NCD(NQ;;@f:J;k`%Jrnsj(f$Z'l>E1d0aHdfTKYgntK
,Q.Ntr05i$4s:a#\IES5HWnIiA\Vcp]AoE.p=(,i-=OO!:p3PVE:6TPLhnGrC9a%G.1e(53Sn
ms.@l$7]Ab^f[J+rh9;I>7'WlAd)Rj5Gf5Y0`6X#F2c!2E'IB\9ek?4eW%.jQEFj9*j)XQsP.
@Q(eZ!rKn^io!en)$(2+6rI5!r2o.m5t&=5'G(+suBkHh8=Xs#Dq7_7l36,;^uqJ&%I#Q)<B
$daouID(:T+nU@Xk/hiXeZ&u9gAS$Wpao-op4VjL.@6k8RRf8T+ebG$2>:#lhN?Bb?`-T@4N
[jh;;WgZ?5rT=DV7o>T>FMs8b*@E>Q>CWO`(DEP\46*jXFBQ7_+SW3*Oq:@aMQ,MJpi"KqW2
l[F)u?BJJYJ``=WF&rXYnds,F=ls'(hA^TSenpT5e$q,bRaj[\Rp)^(uk;B->G;7i4_!t,D@
C_[Zt&i,.\/$I52@%Y%:cljXWQ6tI`en_j36WLkqm`o=l><o[/gIpI-mJ6@0ns%/9"]An/Z69
i,R(3GiK)[U>RCb`S%'L90X^1`UW9TdbJA-/Ik-6cC%0eANO_--M9?'CYnloE61pJ:H'Mc*t
=Ik,_ko0s+3peSd@Vn![V)'eDkDj^"TlN7Q#1?MJr%V5E$>X%+ICa=*5bUM$)dnS\BW:cV>i
P+LOM2Z.cXR:q!ga:fQV2(#eQ-i);88/3Bji6^oi3@fEiNBDSB,5=&!Fg>&)X6%Uc?M!)+M'
bD=?R.+9W9607jDI,)6m!!CB7B4AL\ejq^f]A\$MI`IBH;s-PRpk+b57i04qJCt<;>cK)%NJp
OCI%io3@JF["g;eGK9d[hYM*J&rGK.4ZrS]Ae*en$."*3t0sh(<K\9uo8fXaQBTM#SWgHK.01
:XhBIWE%p2`'\A![tm73:!MH#u,ZO1"@@?Ck?:S1@VGSo0&'aAOB&W&$n6?lQOB3j+m8kdej
ENjsP`/&gJIJ$@UurZibJT8)[m*B+LShHjBB'?a%7X,B_^@2akS?s(P.FQasc4g#+C17U\g"
J4R+b(/DQ2_LQc_/3VB:oG!8V%l5DQ(Mfo20?>D8C+W$63T8h=mt.;AZ)cQm[)j1Of-YHF3!
1frJ&h6QBO(W[-gPfI08Os)4Z^#Xt<FrlUt?P]A[>jD$M?PGI371a[\=nm[Li+Hoa&l"+$eGi
T5*<8#+SNpPRiO]A[p0d[)(=U6kpU87*Kc(.P]A&l^c5*+rG"WM,:5kkMf5t8XH*6>F=<sY1Q[
@_LT@Dp>cC:GZPj^,(Ns+FX)[iVLbaEiQaS=QTS"ZY$UR`EHRWA!?o2OM*>6PQ)O+K@!JFO0
6#n?E$hQ9p_]A4?QMTfm:$(HrF0m-J)o=G6t[4q5E([,J'jlp\D8IFbRL6^tf]ATuW;k3AYRuZ
P4D8"'I-688,K;6M.lKOh]A`'Ma<@d0?VHr!&3/oI+"_3gi_lK2ArieA/WkuQHR)H3c[_784\
-sF/s-^o[%%(N$V8\c<S!FP08V[Z*)Km'jS2Z#i\ZPR.cW?_=AO(&i*.,H(@QX33t=XjVG[4
'F42$-t(nmpNmEP^DiZfr0+UG+%YX("32^7Y'Vf!aYRp+o*@`O(1"[S7l5@#?EEpB=/cb?Dl
l6R<1Gu+;-\n#l16gthl(+OTDI)4=;YBa9Tg3U2g_tV8aXlJ%U+=nXXMjOC?<,U(;ZB\..TX
(e9q8/%gN8SFF]AUK;Kmfj60-0IK^6TQVU'C3(>7M_og:[b9P?]AdcUJM4NbeoUJ3VLn(?"\MN
V9"6:Q(>%H^[_$.-SlP=Lb6:`oS2K=cJ!6fhVFm@!$S7W($.*2K)Rt,R-`E8\pRFZ^MsL9-j
jU"!f^IKqNmiGp!0Y=`p;kel=7kAe@7B(fc`n-6),B#h;riN_A,8"S^A#O_sm?A.1;5MFZc^
5Ot1S1H/f<#3Hk0#<Xr^GaWQ7nW3/V)W.4)"7>\TEug"XQk*FYQ\i^l=`)etG*^+_o?1VE6"
`FtO<-V:2+5RDGfA82>';fIf@!_R/hPh(eg*iO=%tJG\a&5of66H(pTi^<cOV09TeUOBE#mc
\2`GqVSsXu2f_hikq`GUke5t"^<'A^i=OSl11CaT9LAeApPDS!/&5iC%Oc]A*d68s>0^`O67E
=)j<L//&BUadd[EVU(W;2jmgp8q//a3@iV(;`-u\:1&jM_u>5SE'5qS=*7P[Va'j0p(<:ibK
&B1`2*NbaN:f[k['I[N?,OdE*=J2SO(uJ2^2Nj"ToAJlE!]ANj.k_X-2D0d@Jg$E;AKQ*XDq\
nipg3O;tB_(C#?sH*/`&^+@G2+>XO#F!Q*#Ni)WjKp!1W+P,:i_6ido!o0c#1_q.c1)WacAP
A"o\<0Sng;;2f8_c&Y2s)$o<3shiFip'Cm^1M&]A2!H$nd78AL\,M6Ml[^0P&4NmC?pAV^<r,
nPd1)qdQ='87DUMHR-nXnd#*]Aem4oT!C`;teddJ%CV;53n[(a?&_`X(V!4H.0IS!A<@S%hWV
kfMKNaEDLZA;m5r(P.G_qdQ5CX]A0:[?#BA/\XmE$&P<%R<hH"93cTLWD*i\HBeB=X6[^Y[rG
3aKfl*:,0/n=N#<$QC+Xim=roheE;fFF$pecTg=e68DIB$0]AY,,;hrZK[!(1PJpZ4a?iYspR
#_!;n]A\r9cG(!E`Kk[fpE=$ReKC=n.d+,7b'^bgl.)8`;+,!TJa4[P9)lPKB_clP[jS1R5p#
E4l+gjKiRetmp<3]A;_Jums`g=`S@550+#RKS=1+DSMLhBbq>3`rd)TZAE^GQ+KePJ5LH.01W
pi+,Y(pln8^e\f.5">CWuP1/E^j4f'O(-p.OYZc(>hkTai42'bPlV;UO,ICs<cm*Eh`gQKs2
of]A06Q_QO`Z&]Aec"gm4(nu$$LtW_\i.d:=YWjEF6s-ZI.%!\Hj?3DN]An&M'cnM>fQK*u#j)+
gQhd"c4LgQA-*ig>Rd3?i?c0A;1#BFYW2W1U8j..qtG:N>+:;3NWI#pCN1i[O"X@Q9M5Rb7"
g<]Au9)5KWRUgf7<Z3eZJ"r3WBF/':=GX7n?Vj4rjRDW@MV(%1_FIl0iPk81HP6*'Z99Eo6C"
8':1KJ68Q.O`M<Vtuu!3seZ_*E2)VOiOE+m5]AZ_+>aN>#PkWqHAg#l<[0Kd>,&+W%&re:rLB
0acq?=fFqk/9HfOfLP_sn7Pmm=?8k+6.HLuui$egsL\-ug1l-M##&=l1C<9SsW#PMAC]A8AWH
oj<DnB.9e4b\=NrCRt,"$G(M;?3o=YO3eLnG+@lXsc6M,gq\j#@;gPI$1.3Z;aV;>eTl?JJs
1'FUqQs7mi&)Qc=6tffT.VrfTeOE%'D@cn+K9Aq?e@C*o/0%h&4QlpEW%4]A=o\bs%mcm8l(U
]A1Q5ic9)nD;EYr`YXV+Pau^ARj7e9ko+SS7#7:I$)TaX.;_>ZS2se4N0*eQ(hUg;^1J3s&]A'
gJ+40%\jj<]AL5Xqc^C<PqN,lOcp%$JiRgZf["*$3]A`2k1>M*\AuuaOhL3E3Rb/'O>U.]A5W"d
h8f*bCO=A?sE:&.2<,NS+o2d$P_KA2+TA`p#IRP$G"5`IN-!#A3#hYR5iYP*J[SIDj#OroqJ
,l;cG46qFUZUF)\[qc/*Q9^j7,`E.[Foe]A2W[Q;:U]AX%kF)ggE+MV%^5\Y>ou"?)#I8FC(LL
<fkbjUc%_?h29?2t8nT*+G=k$"CMO;ML\7A"DlIps+4_6bu5-W%ucLqr44+6tPnG7cR!iCEV
WLd>!3`m2]Aa)+a?78_@c>)l.N6t'Dm^sl=/II5&rkk[shLG<G"YRPY,MSZJ\Se>M!^'\HjcB
aO:Q\P/l"1^+`!W[5kPL[JiG"*V]AUFh]A,M`,'%f%KgISAGu7MR?b96"Jkd^uh<''+X[-54>e
U"@C#0B$*gjX!W7e32m'C%qI`2E@c/0CEN@!G5p35.L<jEea+5'AoCNR&Drc*#+-FKp\a(_:
[Gn*MTJ(/-OhUj/c6jM9(h;d[&Ee&DIs`<\fX?NQYH`(2:J%6(*%N=LDs`6.BR5+#ZA-]A4"O
1KA#Ir(=1+]AV\,Wa.h*R`Ucd&>]ARZaKCS\dk*RA(6=S\\pRA4jri-&+8/g@Y"Oa\IsNWK`Fi
hH2_)6Bt$)79[o.3qn6+5(G3=-5/e1O1d5aLcBTSS?[>@]AJblhe3n3VbuQ"uKj%J9h:8dE,-
;g`eVWC/;BD1ZI_$Cs]AZR`4-SHM4iLl1<:&(*s[2V]A\%@;XP+kj^44?oiZQ#T(7=t-Zl5^gr
2fh!E2!lT",h$.2o)RsgN5n.XDms2ni\FX%`165F2H0<bkg[sJ$l9bfk#b0RaAZWfe;rqCP^
/M8bT$7b1<aB6e[l55:C?tYtD;Z[lgC&aaX%.RG#g$rA7Y"XIU7W5aN%ANtCdJ7,9Y]A__7ag
c^n&hj2Q1Vo><Mf`f'.F:pH^2Y'Zr3t%oZr;0ZtSmP:*FfkBfa45_ZRRlk4^Ip@PGo[<",j,
H</obcEt3/C9WrOl)b:Z@5o@*nG3]A%NG,A/C^3qOJH\,!cP\5F/XiRlRtLAoUEdCGES#D_Dt
cG7\r(C;Eh0r50aSoE*1R"(K2H6C9I_5>5=odrU)U#alOXjM9VkQ%Z=%sQ9e1t)P;[0tM\"U
+K_9F+4`C,^RN\guBm*4<]ABCp(<;u=W^,af;V]AX]ASqqdOlhoS`QG1</pT'G(jpTd<-_g2a*Y
uih7K:n9[H.YAlP_7RX_oCBjFEAHo#!?SWZ7W[OkEd+lj[U))>(G4NXglYIo!&eQL1#]A#9"?
I4;k'@#8k;lEAdUqX+B<KY?ARJiFi#,YR+c]AH/B3EI")%68c-]A8>\.,LpV@!hG*]AYHUhd%^T
MO%>Lb8bb^6a8kTC^+%2hL7e?pEGMQDDCqWcmL2<+`fb/M7\d^)2fQ_G/?\R(5_1kOgt4'D+
9hW=p1fd5@jg5mXBVVh;XL@WtnS%1RL2m&RTZ`nF+pZD>m*:gj>O/1T:G'#<:5a(!(uA+nSA
EcAW?gH$XZ)pU1"@DtQ_(nn$H0,9sAG9!K?_2u)ddiji)%,qR'bOl4j-;-h@tZ6/TeBB!lWq
rIT"P?m4P;F2gg_C`DWlKN=4EJIH6ngT)b<Xu\'N&iZ1Di=bk]Akn!e9K=Un4#V3/j]A*ebe^2
m,@fR/<*KA?=@;sXCY"hpjQX'tdQ/)3Z4Y9gWcjS&9lUhj4*Ob%4%!$'nPMr/rpII"h1(1p,
E-I#A'&eYCOkT?q5b+(R+NcH4D5nNS#*0]A3^`,(;IH*rP3o/,H7<sVUhm5Y-o!%TsTdAe&B,
&b`KuAhV%W<#b20X/l!P*tG2USD[58I\ZKAEqGZ[_?<`pN(Y*StDVY<4694]ASB?@mc0:=BN<
t#rrSPHMt;EAu(JTqNW-gYeYlFgpqGT?E./2Bu8pk^hL(!E$*-EjLFH*((#KAabtVlo_fpu*
lp7^<*-1?]A^"rmfqB,b:e)tV6`[>TO)Z@BD9n,''ZZrH*C]A4#l&1M3N^@4)2X0_WR^G,D0Q%
9e;H!m5YWYW"n`b+3[^<AqIan[hNrr-^9%r6%7OAiP<KEda2\AWJb6Q2!gTtEcn_23<-R&oR
i\c!ThP6?ba0FJa7UedJ.I4sGCe1/lK8'79'5:^\Z"k$;A6#TTVkH!NUkNiif^fJdC0L>lG5
=RYaa<<D=<L$[poMm9I7u\=55g%/16YD*6otN[+nB5$.0p<*GIae5AMjb[*.o`kl>5\f>C8#
$7M!Z[;0m@.d;/.d=IclOmJtH[N?V8sW&rXdgFORPF,m5lf]AcLI5QW\a:bi>g1B)P[Yo]AL]AR
`Yg,BP.]A^FQo$="M)i*F[2g$.>%31&4i(j="&!:b>0/:"pEt$Rj7C'EB_.Ji.MH]AqM/g7L$<
)8I8iOAFpfr8V<7qWnIWl(9j;l6nW#ep[j"`(l[?X+%fQoQ*U^b%:Dp7V,5>H7cm-hu::g9&
5.103g\_UY%;f+$jV3s1-;QdTElc$_*ktoD*&\b!K+g1>4r+8=VL1ath68Vh/ZfW]A%#EI&?_
QShir8=e[S@RWOR3bq_i7K@YFI46I]A#]A71gqfAY0KrsU/"L&*)]A.jd10@rM'Z!`d+K#R*U1s
sX@Si-ZAFK]Ab*7R`_O`om)2@n>6&k&i0R`7Vm3ht=)]AB-fgW@k_%,7<"Nh"2)JD%8"dXL#f0
COdeU]A!n`"IVCEC>`6T^ZLHXYuZu6OrSt,N4J=k,!r'+S=Ec-+$dX;orfnr=WVQHbDoBX/.L
@,dPt`A3%7jb,XTQ>`,7-Z3R?[Yc+"4tf^^EUO5VXql/Q$s<97X(BNL8ZrT7@uNNFR_PiA0e
;XkTLq^L@7?<RFHf`VRsY36DJ\D?"UW^m`OJE%$9^JoB'7ruS&&j:M.,qCOE1rcoI3Aj-J_C
:c7TjupBG9a,'F\nBAE%G-lc_0QkapCu>RE)kgWEaSVDc'GUgql_$_u!2ug'aa>.n*>cL_%i
Qk7;%-`B+Ts6oi*,jO>?<QYqSlp/\JX9ujQ:<6#5lUa1+87I2)uq4A'p,G[AagQOramb!J6*
L[(-Y>taXQ<&[H5'c:OCGSHS1b3]AC9_W-Bl+^#]Aol!9k[!4koi9kIsnNV0<mq,H:f1a71dHc
rqd@e4)r,+)Y,Wn;HmU:*Q@)=[EI(W6.<kI!d'bA#6!SGkj!$:GNs3.1%-?bG?:G1HIl]A$,d
P;PY10s,!V;hlbf'1(XYB4`Y5=G(#sKe'S?$qjnU_5"9h[^%fu4,Pg>"Gr8lhpQ8r-lNm09n
A-SL8p97"FDmNX3tuE+?k([g%^t^=$a#eE8np$O3JPEp3\55m1I\Q7nAP+Y*n5"Fou&VXt@O
-m;UT'?56c!W@*#FVIlYA.O1YS2j.+$bdIFjkaHk0AI%tb'YOtSe2NEhbK5j.nAtb]AM*96af
W1W.=O(C"\_nJ!*:MP$1iKqY[Ql,Ke.7OcI[S<RR--D,n$M?%qq'(.daQ#Jr[Sg"_27m64#<
DJD4qF9,J5Zf[KF-8NPgWF.lgh7J+e@4Y$(Q@,B0QMc9_d6DZh^5TIqZ_E"ed7?,Q8T?Iad[
I[7qBH_$uP?(M1#`UngQWj^U&/.M"<F<*RAQaF-WV'&<7%:oAr9'oT&F8Le;mG#3Zr]A!kX6Y
TOE*N#jPTZU,A5%R7o+D#KNU$f%5MR,/IDW-></8A9PU"biI$Ec`Jfj#7Lo?t%6Ull("oSi:
M5`,OApI;[="fJDle@VW#r?\rp.:;rcAm05PP%#okq`p:EqYF_rYjL0V^cttl?g!cuERNQbC
tb>\#sUUUbN$XKMV'';l'^YFp/CPs&oOT_iI[1kLu%FYDs8E/CXe3$W$#qQW%2q3egAZhYaK
p=eXr_1h\B;]AAYKp4nYLe#V@S14B+7d\]AR%DT(;!G?r,F?`=UC?gp'%bfY_QUNHP-YOe/0:]A
5g$BfqqR3"'\bY0oE)jIFQqIU+MUu*P\`1\>R-oU?flZKop@m*ibNZNTjWruh&)R14Ghc/+j
H:?.Yu&J$l!fG[I%r]A5@FAi*TRR;4TQQ=(UNkXA!qaY]AuVICE2e,cZA)Vj7-C,&FfOpLcDW]A
JMH#]Ak!H"')@Lpc2`u:k2W@HrdLruNB3`8Mu!hkL^9tq;T<X5r0H^]A&6)lhAgOt1A'\GKEj%
)0NP,<I0fF"j/hQ$$h&XG)a]A@e.K>C),8`"g;K^e`4)j<if?F%B%'H&bBH?&pb\F-`I!O4_$
$3a^$sJ(-E\kB2*>k*#-rR=agQ_45j%B'BNjnY'WD_1\o/`5VD#DnGiW_@]AGS+2(:9ZN5=K'
Fr,\IdeLA=,#0W3Z%MJknTaZPRL#VbrEb8s_5,B)%CS^R+U[m2-M>h$:E!\(okRRSf%5RupB
6h6i^Q0NdV:118Cb>a8nI<cC1QH"ngQmp$+4)SC'[:H5b#41?aYs&'hUQuj3,;ectBp_c>&*
XKc7Z(r4>cVrk.*E)B^!RB""63_#end*3X4Z(-LEEN>&e7EpK]AZTEWo$9_N129[CF7ZnZ"r@
G_Wf=M[SHPjLemY,1,g&=E:gdm`jW$M>0n[@Q?PGqFjc)3P#=2U/t*ldR;O.C^,2_h0i_X/j
ht9;CipFR2+a)VLD:1brM<IGqhUFFMMQ7-'\=`5HXD&u4nM5U:8iAAG_r3NDtBlcCoANYIqZ
6BV:2WsE:fP.l/tLp8ZG>D1gG62G&>Z\Yl;>)YapU*t,lpc4SZn_.C""lGQZQQR$2rohS_1%
fS=+S2ncjB[mTi`tM+H]A*;t)mfFW?/BE_C&%N-Z)iDr,l,g7ES0j:D5f%L3/%es((it%cn5Y
P5.<#I`f>78lM[hrRS&+'K",X.6;O;c.@@H)4:m4kRG;Zu4TC`W$MQL,\r,Y+T&]A7lNhTn%C
M99*KRn=-T)gXDG;8@G6>uJEX0VsI(;/.X#is2_(f6Y+))uGMn,CsnkLFZI)OYZ8j#R*uN"k
+h$T=1"5FmO?35ZsjfX0T]AiK%UX83&K8,S4gs9OTlcbZ"nc^blic"8b[(M%^&pIU#U>#gLOg
-Wj4=hMNa-cAR]ApPr3KYBDC%(#nQiQ<djJgfT!AT,o"dk9>F`FV^_QIlu6$3A&PV51t%48Wd
),hl0uVU6i$0ZB-CeD;pSt?Fn!)*Q>g;rP^V/YWkJOF"C<uP3Q6O&Y24qW%\JQF,6;?!VLgu
9)dl+^2AS@r;hIX`h0(!B]ABGLuqFMb7`E,.7'4e.>bM:tO[?pV]A95Y7t]AV+[^IK#.Y?GfB"%
YJ;['9O-C%eu'*`Cc%V&W.Ae1c$E;:siY0'tS6)c1D@EGitBU0Lf`)aH$'']AR8!6d"@`*:7k
QbY@V!dB["(uZme#\-D@t8H-sDu$&'WGq[(>XhS:TGOC;.Qa:'Xjg]A<l8ESmge[<?*G!4fg`
K$%M86S(2j[VlL9a\gI[*;m=M)eD^tg6`OAPK(piK,nq&Fq)-d!Ra`Vi;ZWL/9(Q@aiH,t3V
^HjT:5>^hd.a)e(]A25bfe7arJc<s$kmX'dcZ`s4;gntG6=!l9/)\u&7('DZDEK[.Xe2M$,F\
P@f895l"4qO?.nLedb[2LT&9AFJ.'n3M.U#+e)E7h]Af/=`0o2h(-OD9Um<Kh&2A6(\Z<C]AHV
/g$TJh!RZ)&C!V]AgNk8L8nB@nAS3<FK)ip@-R<ISri7?Q8&CNVh,3tmE[<+[LMNBk<XWtb2k
5O"Z)f?oGE5D.rOWULe(_$l9[",<'#Z>;BW]A=*VBp`4k]A[U;"94b7?D.3Ms[Bj[8RTC1%m3t
]AY@'\Lod"mW1"$JM]Aa0UFboc$]AfKpEBKEF1o[0_dI7kIT<?TR1I@!m[;,^)nHS1oS1^20D\b
hFO1=?1!>Qop/(&BE]AZSZ"IG"bGUjIP-s"7MZ_>L,#pZ;F"O#O;2tDl\G#k&Fr`Mh6FnSD%h
Th+U6A1^S'^=OWojp&IU0jh5mgO=,a1o8to2K-P%eb`a$"_2*\0NAjG\SoIO^:sJQV&m;6kr
DR=XA@9[/B9XGa]A!&\lD544VA!P.1cWV<\O?%M73?f$cndUMU\`ZE418=EnP'5aYXsM3$T\S
WfRmdkZ6?P`_dGeJ&[B[]Addr=M^,&;JF"(g<p&BF)"S_Zn(s0IthoNRWF,$[n1o!<NYH42@.
D-#oC)Do.Gn]A?FI]A]AHH'M>7.Vq;k_doGmI;(aHBlGHGJbDO:[Ph=7F&,5M]A1K<nr?!JQ`s=I
j#E>7.&SM(g?Td"^LEWXCV!Z!m+hik5Y[rR'",9\@45lW07XD=GqPdXPGEp40#j>Yh^g<!Lg
;j`QM-"&CkNr51pa8H$%(.M8;AH<Wf+fb0kPmA/Xa'SdmbCNsRG_?7-gis1!,JdS-%r`X@)*
VsM$#T6#&;MifS=K"nnZmsiKIO6I-;<nBB-oX1?_"p^4G?G]AKG>kl0mEbm)^s'J?m]AJZKO$%
W]A:'Jb@?*"r>iUoc@bJlQLC;gM%]A\GkYfih8pbT:Sr%sBhVA]A@]A9l%=@d0sEGcd#?$9s06Ue
C]A<qPbdbY_h_@Q?Bj;S!'$ZNEBaebmep^f)TZ=Z+/LK#4)pri1\ce$6e\0@l.c3Y(UQf_>S3
6bpVkqA!hF=k%(*0gdXo1RLQiE>VH()qh=%kqm6]ALr6kuInMZGorF=a*7?ddp'NK5qQL!Siu
PgW\I0%>Tt?T>`k)Gg5%?4PgE8f*,*rH&YeM7SrQ[$i%CF5$c>`@gnMJc9ic7XnKLhN(oJJ)
Oh$>40c-2R9N0s^&RU=7pn\^G9&aAe7L3dUu+pggttK;ae&\+kfd?*;#7nl]A-*WEo_$IYFiX
'Wn-3%>g]A8/iE8gtpb]ADO:A#B:bP/1L)Q]Ahhq(\I7qHk.bhlheAI+.\Z#.4BMSFsWNhg66[I
O8ma-MPVrV?t:i*OMiYX,n8hkH"\I$S=.U5lf>YS0*T#lhG')))2#bN:O&^n^Y^g196:"(h9
'"`Al=]AVGP/_k`5E@_*Y/1Z&Cb"LVL%?ngg#ETL9c?F4p,BS@D@+Ik5Nip+lckjGdkMqQD.G
?QL-KOprk;GI?'XUVh2"QIdT!_puR1PN!F:^Sbq0PG.+j'CUK&ifFAA,YGJ;f[!$3Vh'plbR
pY<M5.!DKH@.5=G&S*+F-@3LF/P^M7,]AHTd>C;X%4`tC1bnICN$8a=-qUgjIuS`[&,:.tFW3
"5E%Vi_70%7kT5%=F$8JWD8I,?k$Pt]A_BnRX93)a_RQ.8D#a]A3jMXqX[N\l#F1nRpEcglA'p
ihHT);L?);$@1T;LcjrA!FRnRq2"+WAC[>s]A8R_*";*k;Odb/*;[$j0=Ic55`1;Q@@>Tb`Oo
[&>@CL+c<>#JC&*4E=+;'pT?TYN%E(H4WbBPkW6*"/l<O:I+7.@5Ymqh'Tr)Zfg#Gr]A]ARgM3
4)A'5:e\++%n1nK"hZC19bI(d0S??u@[q2Y2C$i^TR,1b21nL22;@)\G-o16!Y(G3>98rEHr
g8rd_4cr8>bl:]AWT\1UjSZbH=49h+N_YB>c0W-L<KRI5J]AUK!-PUa:("O<$/6\/%SL1Zt=IA
+bktJ-@&.SYCQ=NI=doLXi#!qOf6:\/O&Q9qgR1'[l[_9mcB>gQ`Q^DZ]A\-W-_:5%eaXF+de
b"mQM(]AaQBA0'd&Qo2=BQ*,KZChamIL3!+\eV%G>d#^%D)KM]AlH#eVWm$,b6XgUH;*?%k6QL
+1!hA=/Fp$FrncRf1uABF$;93>Om[RYcX!fXYP8Zne*eG:rVFBg/`b6F%>P9(<YM(q42XN?:
8o87ke8.@Qua2%GF<(^1`@Xm1f!L`D#VloCINE*]A\2_=]A+?T\O[\F%,`XH__mW_]AStan'Du%
SBSCDQ2bkWmQilX?e'7?M/g9/uQ"`k%)B\WVmmKJT(d6I&\K[nY@+*qX89M.]Aq&L4Db"4@u)
#qI('NRGIcUn!HV;\DX*$nV8jN_./Hl-o%HUVHYNU0a-7aoLu=fbXZCG(f2&tf;9m9(.^d2/
)(gVnC[r_4ptbaQ]A2Kdl7m_uZrDfU3Hl+BGGckq02G''_"Z#)oCOfX$_`bMZl!Q7D-H_[=L*
"[p_FY,`<-.uhY<eLlf5:IPE"3V:]A"kC%a^9*l?JG2P9%gr'4OjgHB*%N0O]A;S9D#Hk2g8h)
LE_/4<N-;tfH[a5N:$CF\Si&i[L7+9OXnP(#Ye8C?D7K^?pqJqh)KIS4#:0/P;q+Nc-6FaoM
n#b\+R@blRK4VJSEKnD%pp"I$!ot68-C_\ju<87afa;_F$(.I[nFj5nC[aUbMc+lpQ`7+[JM
U!Mt9)m0>[BF^'*?bpf?BIn3)gc_=p(+*Vg=qcf7[f4c_84Qf*33?\7`lHjRLiht-UUI*^hG
n3)j$H$fq4kOBknT#\;Q?\7`lHjROMna4Dai-QMPK("!bSL$h^C=d=KPICD_2a\4ULi[-1fZ
\_eUl]AN?_^F"I59&SM'99dsH?Es`LMpeMj:e=i]A8TS6?MZ0,@&Du=$YmUPPJEpZi"#:^RpbA
Pn@%Q2/e?GZMl=\<@%2\RSW&_i,L<8.WA3+fP/5A)hdiH_LPi+MS:Qgr8BMg%Mgl%[TfWfC+
Zts\$kE/J,SNn!^A(GC)!V''ea&B=h_2irDG/5%U;=2iER#<JHopjus*N:(,NJ6;[8%kd@2(
(JXA<AknEn.qrU3b,&2*kdGDug<-Cd(t<VX.q2r@AXec/tK6u^lSs)RY,Wb#'8Q8t<T"35'G
mDN)NV`]A@WI*0?.c)3]A%/`K\MrYG$(o-k2W24sI/<V%XMIuF)dLVH9*b/:\%?T"JHn5]A'/%p
q2do'j,E:O2_>`2>_Fb/7<*V`]A@WI*0?.c)3]A(?YpC19pYSbi#eG;@/1bB5E0G4-$nE]Ai3Kc
bEF%Fn`b-htQ^t_Yqu6W~
]]></IM>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false" appearRefresh="false" allowFullScreen="false" allowDoubleClickOrZoom="true" functionalWhenUnactivated="false"/>
<MobileFormCollapsedStyle class="com.fr.form.ui.mobile.MobileFormCollapsedStyle">
<collapseButton showButton="true" color="-6710887" foldedHint="" unfoldedHint="" defaultState="0"/>
<collapsedWork value="false"/>
<lineAttr number="1"/>
</MobileFormCollapsedStyle>
</body>
</InnerWidget>
<BoundsAttr x="0" y="80" width="360" height="559"/>
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
<BoundsAttr x="0" y="0" width="360" height="23"/>
</Widget>
<ShowBookmarks showBookmarks="true"/>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="para_viewtype"/>
<Widget widgetName="para_shop"/>
<Widget widgetName="report1"/>
<Widget widgetName="report0"/>
</MobileWidgetList>
<FrozenWidgets/>
<MobileBookMarkStyle class="com.fr.form.ui.mobile.impl.DefaultMobileBookMarkStyle"/>
<WidgetZoomAttr compState="0"/>
<AppRelayout appRelayout="true"/>
<Size width="360" height="639"/>
<ResolutionScalingAttr percent="1.2"/>
<BodyLayoutType type="0"/>
</Center>
</Layout>
<DesignerVersion DesignerVersion="KAA"/>
<PreviewType PreviewType="0"/>
<TemplateIdAttMark class="com.fr.base.iofile.attr.TemplateIdAttrMark">
<TemplateIdAttMark TemplateId="cefe16a6-4508-4f9b-ab3f-62624d4b7bfc"/>
</TemplateIdAttMark>
<TemplateCloudInfoAttrMark class="com.fr.plugin.cloud.analytics.attr.TemplateInfoAttrMark" pluginID="com.fr.plugin.cloud.analytics.v10" plugin-version="2.3.0.20210831">
<TemplateCloudInfoAttrMark createTime="1633678816517"/>
</TemplateCloudInfoAttrMark>
</Form>
