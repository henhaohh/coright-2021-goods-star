<?xml version="1.0" encoding="UTF-8"?>
<Form xmlVersion="20170720" releaseVersion="10.0.0">
<TableDataMap>
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
<Attributes name="para_companyno"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="para_shop"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="para_iscake"/>
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
where 1 = 1
${if(para_iscake==0,"and a.cat_name != '裱花组'","")}
${if(para_iscake==1,"and a.cat_name = '裱花组'","")}
${if(len(para_pluno)==0,""," and a.pluno in ('"+ REPLACE(para_pluno,",","','") +"')")}
${if(len(para_shop)==0,""," and a.viewno in ('"+ REPLACE(para_shop,",","','") +"')")}
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
ORDER BY item_per_dif asc]]></Query>
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
<WidgetID widgetID="ad6c4e00-2ff9-4357-b372-4e9613331d79"/>
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
<HR F="0" T="1"/>
<FR/>
<HC/>
<FC/>
<UPFCR COLUMN="false" ROW="true"/>
</ReportPageAttr>
<ColumnPrivilegeControl/>
<RowPrivilegeControl/>
<RowHeight defaultValue="723900">
<![CDATA[1296000,1296000,1296000,1296000,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[1728000,4608000,1728000,2592000,2304000,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" cs="5" s="0">
<O t="DSColumn">
<Attributes dsName="汇" columnName="VIEWNAME"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="1"/>
</C>
<C c="0" r="1" s="1">
<O>
<![CDATA[排名]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="1" s="2">
<O>
<![CDATA[品名]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="1" s="2">
<O>
<![CDATA[万购率]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="1" s="2">
<O>
<![CDATA[得分参照值]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="1" s="3">
<O>
<![CDATA[得分系数]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="2" s="4">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=seq()]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[row() % 2 == 0]]></Formula>
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
<![CDATA[$$$ <= 5]]></Formula>
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
<Expand leftParentDefault="false" left="B3" upParentDefault="false"/>
</C>
<C c="1" r="2" s="5">
<O t="DSColumn">
<Attributes dsName="汇" columnName="PLUNAME"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="2" r="2" s="5">
<O t="DSColumn">
<Attributes dsName="汇" columnName="ITEM_SHOP_PER"/>
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
<C c="3" r="2" s="6">
<O t="DSColumn">
<Attributes dsName="汇" columnName="ITEM_TOTAL_PER"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="4" r="2" s="7">
<O t="DSColumn">
<Attributes dsName="汇" columnName="ITEM_PER_DIF"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[= 1 - $$$]]></Content>
</Present>
<Expand dir="0"/>
</C>
<C c="0" r="3" s="8">
<O>
<![CDATA[汇总]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="3" s="9">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="3" s="9">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="3" s="9">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="3" s="10">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=sum(E3)]]></Attributes>
</O>
<PrivilegeControl/>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[= (1 - $$$) * 100]]></Content>
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
<FRFont name="SimSun" style="1" size="96"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="1" size="72" foreground="-1"/>
<Background name="ColorBackground" color="-13395610"/>
<Border>
<Bottom style="1" color="-1"/>
<Right style="1" color="-1"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="1" size="72" foreground="-1"/>
<Background name="ColorBackground" color="-13395610"/>
<Border>
<Bottom style="1" color="-1"/>
<Left style="1" color="-1"/>
<Right style="1" color="-1"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="1" size="72" foreground="-1"/>
<Background name="ColorBackground" color="-13395610"/>
<Border>
<Bottom style="1" color="-1"/>
<Left style="1" color="-1"/>
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
<FRFont name="微软雅黑" style="0" size="72"/>
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
<FRFont name="微软雅黑" style="0" size="72"/>
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
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Top style="1" color="-1"/>
<Bottom style="1" color="-1"/>
<Left style="1" color="-1"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-13312"/>
<Border>
<Top style="1" color="-1"/>
<Right style="1" color="-1"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
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
<![CDATA[m<j7[P@q=J4&05<''Y@_(:h\K7C6)l&J,"8*BGAm6:F=3L_V`rKQ%BeghQ(=]Aoe1O":Q`RVT
L2/O8pFq.7-EJ!<WH;Oq>/,$uZ1MP)tdd$Yj<L>F@KaXg>`+c:Si[eq/*1ca3)TBCGe>5&=R
Kkaf-M]A^`u\TV1,5m=4/U[p7d7@n"lhXN\F>&S@C)`Z'106(dO,OE"c&oPV!Dre>G_`'T5I]A
E:e'S'Ql(qmU]Aj>l(-Vl(aKLQaVWb?Q\9)]AKSDjmHVH8<da&aTVh=1aPPbEefQiR^%<B0$N6
O1`"M7.crDE?]Ahtt#_Sd]A(.F*de(8HG,^<Th1_5!]AkEE`BGqVl<=3<,bHV6B8NTT@#Wm-SfM
`Xr&F@csunCM2OqfgAQTBW%]A/Xr`\$T3(EM+aZWHps^gM/SB6C%'$0%jGnpNc:D/\D+RNh*m
>'VKmBhnbK8)e3I:NG@n4nZ"93o90ZbR%-_)>K5<mi%8\0!/UTVpEj!IbHQd(#rBOfe`T"o.
]A$(%mVJqK[V*0_4*84,TpqW\ddfL+TdrV:T6(9ijLZ/W-t[M`l@ic6Aa<aY?:Tmpqdcd[HS[
,RHbj"GRjc/m6N[h]A\5np.;F?Xg8"dQ`dZ)?XG,C^`obOH=tSr9";GL$Z&B.a_8-+m;GRrK6
q=Y[U,15,mVdqMBmqf5GZqYEpnL:-2Vh$g%7_j;mf+\q8AkCr4\0^P^OUjdsjdGLCWsibn&u
(r,AiVdF`JVTEb'qOP>d/fVXK9$rNZC6h^5&Y7_9@X;e9[=f'iV=k3);D-cCf#u!+mXaW$4%
0i^"270f>HQMdE*#Y.F*\tN<G/s;0$QGRd;Q=B_(qhd+KpI&B%lW\8M+k_C&T:g$GV_Q4pe/
gmFre$<q&c1KGgOBH#%i25lhg/dZOf"EYDO\P7E^RNLik(F)3U;G1$o*UD[<m*ck8pOEJsDg
`9J-/.:6`N]A$\HYDqMD%\WlPotZA+&?>'TVa4b\%"A@NT5+R%]Ac*oEO!<WHW9"ZiO"6`t-/g
fF)gT=N"AP\PbiYcqYSsZ8#14tML2gN4N%-S!2a/XaI`NdGgHr8+V'DB0?E*dY&OGu(W#!Ld
Z$s1P#%dkmd8P-Dn;1*(M7*e"E/![l#</kR(Og)UQtnNF=mX@YHO+72Cj'G2KqUu%l?^S"!X
#;D6!mp@nRX.g)"C*Qr!?:2aY-YiMaZ(hfa@0qCT5,*c3P815&PcN@5S&,K,V/)cr<@AgBii
qam80k9q3LGob]AGJdl3a##YHT'U^Bd3lD:q6m<kt3-g/Z!(F<;UlRBB%o^6n@2iS_1)Wp:n_
f7*OA0`R2l#VoCacZ.m]ALGbM]AS^=VaWAYjWHu7s]A:E0@p/B7=fE2[U&"c.42^iQLh<-;(<cP
p2RmL<3d%-=&h,T0Qh?G;UFVD#NkW)7GqSg_/L>2PM>";n(m!Cg?k4(P:,pA@>5*-8.S=ZZq
pXbO$B4rjcbemEn?]A9'!@p8>*"spW3MI2ePBc/YL0_Gd$c&sA:2#`lp2N=ghDB%00pQ_X]AW6
]AN_*WP9tj`;6(F-GL8bgc`R%`)-8(Gt\0_D)gp()W47ch/7U$OgE/SkWljIC=V>%tflu2%4%
4Oj7K$Mopr./fSX7+Aqnb;OX9B)k$o-T+Q';9r8?%S7OPf"\AbQamid(-;*mr-q\S511=UeL
E3j5d.kW)7K[?Y;[^_+)M^(Z7+RC,YiM9Hk>VOiL3e%aCJu&1od2HjV`74B^-/cIL7@?bqag
<h:2M)&^W!lcdk#"%^JYs_,'h'aSL"S:P@H?\hIo^Y^"/=0Y@3h-XJFfrf$W5u&1CBoT1_e*
]AFc3Mep!4-O<@VHA?YWrGc&idm?iP>,]Ahp[Ke/SAE^DRVe'KBFVLKA?54tRi9p;mf5`qG>GB
9#1rW[K?AZmG8IQduZ[Ke9lRd0M0G1*uLaX#nkRkal-BBSTu>N=>S'^qnDGf)XmYk7aQ.>u6
oo"ML94L=YclJOW=kk\b:'1IQe!mpRj066H61./0*Bh.()?E\r"'-W35oji[&/8]A#fp*3Q6\
2;gj-jF>t@u3a5nA%$TUX;>gLeEX:kZ+k/OGTO:3l*'-I*N85:0A81!-Du5@RS*DN&)c\YCb
fu2l?Jh(-PLho),I$<(To.9__i87!#iCn[K$f,C*[e+Xf25.9d<M6:Kd4M,7D3*.WsO`FfoH
\ZS'5CN,M3]AYZ$Wpm7R$AMUj.ATAa;pjguJ;\\KRJ]AUcKfo0%i=jCfW;L;MFY4-ZFBT%sB$$
9&\Pm=Z6hahHu_&gdg]AM5Qh\&E!(UJRl8^:K@l-)L-3XaleI5]A8I,Q5/kNk)Rl)s2';Hes5/
B!t]ALcM1k6'F++8a.Ho,#0GD3VVSnp<S09JQ/?&P/gMa`,bn9LdKrN/C>*DfZ_uJr':e->9#
?Y9j6A.W'GE`U%jFPDj)2<,.2+-6l/DMuPMGj+jKp3U5]ATgi^#JU;-94?-Yifl%I3q?#6>U0
$F.EXhjT6cjue]AP7_5lE#QrC/i4V*&1\5:mp\/m4%Bb!ntC&mO3Z:=q8alJ;4V(8Y"AUKenU
q^AbA?fi`>X>OJ%;Bi]AIZYT&TmWHMA;pu(^<L4hu%'HhOg;_Nfk'P"V;`JBHI^)INNLlcXep
5nPZW4oo:i4JmI8g`A4rY19jjPMr$Hr483VZ%HWQ"b^WRB2gPt_4LUXf\j8O"Jqf4G*]A`g/h
<Z#'&$(deUha-1EKj*RO[eIY*TQf*<;!C5@BppBIY^rlNQUFZDS-n1L58&#L`F@4Y+<h.3-7
E>i9G*EQ#*c=S*19hP5gO&0YIt)d/KL:`;D)Ts1W-Dsc7VQTOGq&8UGJ-D3Tk2Y\c@%8(KJ_
h->Wb]At9fPV_Q\^RjQ^kHu9lu->g.K']AW8hkmLWZ"b<>`D$PndIP4c6E:*]A^"a2CtH3BKubR
RiftSVW[#=n-6Ga_;M:*;86OZA,)/F*9,:sSE(jb=]Ap.Wh'7rg)u3J%^G'u!Rh3r>O9l41jY
p;$8/&m^m/2eT2/)[5.P(u(ocgXE43-02_<;]A+1_"8Q)0/-4d#g5`Tb_EVbi^=D"JOM;ET7E
%+[oLmf'u:#BhOmHAp=IeWbl?am93LNrH0O]Ac1,\SK.!iDV6<_!pD";4S(4T_,/tg;lkcm%4
+0M5Nei%"RA1bJP:JktH'*!a99>5gQ>d=s+-g`ZBL]Aj?o\ZG\/ISU3E:/j^ER342]Ab=Fjrf:
JjrqJ5dI0jcM8@-&2P8N[78EYMrT]A5NRGfehapqMP>-UB@"C$(ZIVHY!4./^&(F8$=6^30G=
[q2?#,T2XkS,*VfE$Kj`DcZaQB;$+`nVfO/Mi><blHDTO8jdH"FC9(>aQLX`'#Orfa*.d)DE
-:Can>#OaD[_a^\\JS[^0u,e)r&%aP>"_ERB\)E#,a6^K'J(I3-8E#u4=Jh(E92ab?7diR`H
M`6Y)Hn<<_>lh8W=&3-(lQJ>j/5YYDJA<p.hrl=<>/"m9a\.Td,b:LNFpBtI43hFXofsi#l,
5h+8YeB`NZRdb/db$SU\)j#"#2^A=rqim;%BD3A/ut$U#p>QtI+=O7"#\F5^V2RQXSjjJis0
$@qqu8?Z7e,k4b8*4@J!n^?@)2#o[\TrYmc,cJkr,NX^V+]AN#QAYFhajlNnJCG;&23A_i^hE
gp1-#%%iSer?^3R>0N:SAR7M2p)qoC2BZ\@^AO+o2rq^l>if$?"d@FV2VWlVX]A2PlnXR2#;D
Tp2QR!T8F[DSdWc$JGGj7)t(]Au*&3"]AQ25od/?.7h0LfNa_+`6HYF>-GZc/rRDgYq4Jq3c6I
mpsU=^bE.^IN/;%l1(=*bG^uPGkp7`_(7P\$)A[B=oL2WNBTt'?K"[pW_+YA=hF]Ao7emrP_A
WHc3/f4X$h'_roqi"u5V/+_Y=_PR1YQkA@n`1MeCT'r&M9S$^kZBl4":?nkjdsIHE;/.Eg1.
nPW8gEH'=9nZEg5iS5_hlmk=m40$j(F7S!L?oI?Y'_CHar%SXODNVaClCHQ#Xm@'MDS[u%7H
%#Z*UV)sOh%']A$C439NoNhT"<[:BUhV`La<)'?-3+W@)gYP[=S&k-i_$H`3u4su>c)TVe[Sd
Do!HLsXBd_ZQNL7`>E\0gEgWZ0jVIqhWm%:imH.(Cm8'Z8VOXMT&WmqF%7.?Nd@nH`X+G"im
nGaY&H`9T>qaj%VD%LG%acb\Y+E=D(\H<jYn=M,-4H</T9b+bd>h=:I-k)R*_YQr2"RGnJA)
]A!nlFqeKX$R(+rkK."8YgS4Ic^kBP#`!m0r?Fhi9/BU^(t,_;A%q:)_NCL]AHpkH4l&NO#G@W
9FPc\@KA&e<*N[^0U$u*5CQIVHTl)ar6#fDZ/?0f9^,=l;7(9aeqKWWMZk%KSuc4>chX,A`k
QCrC>;8Wf$<@4u5]A*UV%cWX17[uj(VpV"P-$h25pC,B2KUfJPgDFHi#82-lS(;\?B#kMi_1f
o"lNXr)_C::TS':E,a>#LoJQPj2N=JZ@nWS^<A0r894dCm)aEmQ`1o`0BsU,J3$+j_#a'4nZ
[8JZ<>nR<9K5&Fl=^,Feuof0sMW\J,-),^j)@PrcoaH%5Xe5,&$VImhPdFhe;d6>'4`-Vm`O
U2@b?56+[6rqAa*n6trI<!eoYaeG^K[$MBqCHmNR2,J4GdQfl`B'ZejYdAi.#Q4q2,:Q#;>Z
<I@-)k04/_:#SGU8g0BF5j4,;,Ti*-A,1ns\Ee(>]AZ3gBU?osL5M9d05H?6q3$oYkf6_aDYt
Pp=cOkoL2Z`7_aYJ)PT<;$jPP2$BjN,A8Db\a>3f*9AD`ZCQb=0@j3tq6V-)gQ:/iOGe6>a4
+LE/2!srn6'rWA>NN6OC4H)VMb`Q)c9(\,OG0QC4@lVX,@Y?Ap#$I_W)bM9&c6=2G2W-jAT^
E:o68RD*ePhA0Z82aN>OQFMgOkE4NsjYkcDoYXml?_MtZ$KGo"?WV0upNh"\H4Wp![_!&?X6
's8DAiLp^DW4>M(gFk*8IOfM2#Jb%82I@^N`jgV^/\Zf__<SBlkIg?HX6D.;I1+H%L:jUctg
j+N`:W0+ASFsKD@L[-K'-e8f-IYe7DN)9]Ak^(>H^'6JPptm7tALXLdc`g\3YgR$.ZUCh@-Xg
;dJ'PQ`L_bM;R7?GLGi(EA'XK[X%6IKfom#Hn;YHa`hWc4r:Od]AF#DhU%fcQo`Nnfk:?2R8A
]AEZ7;s26.A$2(`nsfGgp*./GJp24#)4I'+0ECU7HR;UrO#]ATY`q"c<)NRJ6+$auRBPa<@Hqj
X!j&pf*=oBWW[44n[hO7Cd&P@]A&_X3Z'/Jc^'lqSJ3.?>`U^?J@7;:C0k4bl)%C+OCSVE8l9
,ag1p!.f.XX)Bo3Uog\K*PhBB]A**O!9u%`/D<L%2/(j=n:58r3$C+0.m45fr_"m`,fOZJ%61
o83,rY<(5[\HXL#2oG63!#JSc]AEUOR'X,9[.9e<3)o%5]AiaHj9<os*pE_;#9SO?--J1J5h"(
>j>;W!+oGh8G^<Om>Iqg$&-fKdsk\!8_s;rGbSf$0UKSaZHA0T$H,@>^tu(9[[#GcKdBZ4NC
ieR"JJ'6)@:Dn.L0S0_?MK(*H(XoWB?)>FF(iteUHW>Zdk"<Ol-ZQLb$+I.Mm%EAm4[(ej(J
u:QHCYV)"6q5*J:h5WcG7+l?&^4@%RZ=SfY'd^-s:OXsr$oVRG+-AC',EUYrX&e6Lao)bLej
T$X>Btb4LVJJ5WFiK*e2`CtdFiUs$T[[>AZ#*glE</b5H4R<LRU1#La+qM.:dnYuail/aJY\
bt&)1%kEX:1M-O'mY$F=M4'2Gl!pS""f2/&@ub%(eqY;5\3+O2n"E]AjaZ9s6hq,Yt>rB^L#;
l=_f(37s_\Qea[<UC"hDF7Ie>1QR::'UW`ta7*d/5CL3DpGr'&/c=kfr`I\BqbO&8d&iXAL'
F6/M_In5^BZ<k.KZ0cDF`C5gg7`RQs(FQr,X1J]A&:nl$RTK&(lRjJEL,TD&7,4IIh`EG'?XB
SaZ:ns$]AT.0e!#Cg5'\RL%.u*+V^O>^h/NLB#l&-DW&tmYS^c"A=GW@.MlqInll't5>gDIrN
gIeo2RXH9[8t-_)tDP?2^u6`9m&*u3fB2&361hnHmg1I`KV9dng54lWn(GY53Ymbq@NhdIKf
92h))QMYLSUKk(]ASaS5nDWMp(;gnQC)B[@YN)MnIBri#F3c)2Ct=.oNhj`35QD2iZCFj3jkI
Tu'^Ypf3aE'.`iI>PNptVUrYf\EsG02nF=;*!,sh>4'1QZqekec^9)RMDN5U(gD4;>D8k*-m
P-fe[`CYR75*p>s.696+>Eq%_SL%*l2Y/:PU5t^Tb]AE!?E[Mp`q-mYlTe<%"Ih)>ATZAo?@R
hQ\>d/bt"-&Ol$[;HREO:AOQ3O\3Xn/VXZSLd(Jhse_S%%FEo%p=sD[IgtaemP+Lo!^(^Qp1
3b`jKFY^o-HN<Zo!Z@!*3a:"QTN^L(@(3;SgAgjUZ%aEcY^PR`4!K[VP+cal`n2>Q,_:mR)V
-oZrsijr4D):HsC?-"dfFCV[t+XW/.M:/tn"eqXj2%<J<!(h2_lX*jqXM63us3.H]AE_3pnW5
:M5(GUC`$LI&oR"?JD#l"dkaE1XQ6G1K1=os%OP]A!.$%Im3#-oBXV#7>h4e9;5[0`=.E?q9e
NXLihp>-@-Y<$.<1'iZ<2H`*Il.ZkZ"tM.fit1,iQrKbQ).Wp)Bs$_bo<\PG#NrfUdXA"&1B
ACP_rldG4VX6a:_PEUV"'FPq3S9"G-VQ$7q<+4J6B=^.]A[/[WgUJ.C'LdIBU21EiD[.ZbaJm
Qm`^>tajaS++tH575q8J:+pV'Cf^&Ro7Zg.p#sN"/*`p[c+-\!c\\O#f-f+:-ll2k$WIR+=D
(Bj3HihGVGE]ATjodSXXIN[4C*kla#J(n5jQ\j%_rBC5)@(8aOW:?J\u74OWPXNJkP]A1/Rrkd
H;BkmdTJfj*2#J<Lql\a1!"U>#;&I:<b@!9DNBAg=W;b`GocMAN!j3l$F0s]A'1*LYb%Mu_4g
t$`/LG=SY8GGO9-;>M(J7c&q=PeY(#"!i-J";:V0W&D,=L\7dMUKIJ/>(nntak,]A("cDIY!-
2K$ZJ9[o&Q6*tR`*;AY:dm$c8eWUL-2U',Ys[V@'-#6atJk_1Xl-Kcj4fmU9n2WI=VRdj3(L
^Trk3I3a`0-ci')]AR[U"3sR@>o/CmTW=Zk'T%Ag:JgF5i**-H_bWN.e+ZQJ>m<<1$*?NO\/O
EQHqu['LX7li4p>PjDfWf7%P8Lq8'DaR=D)A'dajWmTo7I+Tb=9cUtlb0gq?IhfrTjtROuf\
)7t>+8K`L"b`qQ6JHo$/%+dFh2Q$?Rh;[IN`;UU%1R@#BU'ZLYWm\"EU+a!T[u[SNScd>qJR
7q:,iCClJSiS<WgYTX,j5W97%e=fi()ju:0fe2p#O,1=;[\_"t1M8KV-hJq?0%6&\A8&J4i,
,H_5T:/3YC+4HJK+p#$L+P5/eEIK.RgM"Ef1:)piaWWc%R3=X#*4k:"GFm1mmn4bag52iu.3
%2,\qmq4I67>s=>/DBG-)d?oHLF&C6gWlK\>JndL_CbH`\HH0=m)cImOWo2O%:Ei+:M<Z__o
;,;mt1%8<@dTWd"%Pc(NUp/rGJ,fPWUtkbD^^9g[]A4_@f@8FD(1:^@>79i-s-jmUY+\Af+$@
_&&_-R<j?U+!!pgaX&/\B1$(cYG0W=B!BCW=4[nTg0sVgd-VhI<i`CXTQS+jS8^0]A:o#,me/
Cge16hGuO;i/J)0+<@-\gmu/dtBd=q]AR4"=ZPUHJ>FPmFgu-Z1^)A"e)C@/,39#9WA./"m/Y
j[(a3K/s>0lji0TmZ&.daK:IU<[h-FZiiR=^>6@o.+='gg,q2^TQ%<?7E\N;$63k=B$3N&hF
Q3t&4JZ6VN$.1'pmdiD:lc->WFTs]A>2pl.8X[9K(7#@h-:flo_NpDZ2chKlLV85@97desqN6
#$=8cK$lC/W;s%_a'/]AR*&d=i)>kW!f<<H8S:*%PZo=?\_rk$HgJ(i1"bjBPIH"s<Dn$C<=J
^"ZoL()^F+m+3.$.1uOb3b)e.30M;6'oO+^BorYfMa2c^%^)0oMdY%\IpFg`9(=QRkiGLY;^
r!G29F=!b?+SBij8Y?F^k4\*s"3Z&D%8Df2s`ca@[6dcg5j!i"`XB2s[smEZ5h*kqtD>pgk)
%EP9)-*QY'2Q/Q(2IQ?BOfg9b]An#S!MRrQiINQ\ibs5u_as/??^#>/;k6QKD-.#_Zf+ql<h@
#HZV`<Rh5P(4$^p*B\rEjeSU=P)s[+ke*L^c<8,7!%s!GOY8BHJt4^Vk)<HH6pq>7Oi!WDe+
$7ZW_+7#8`sg]AdYU+m)nH/kRO'!oTVOLKi71CAOXeFg9*Oh\NtS'<O[gUqoc9KD(jIflg'BC
l;,OiEHY9TVV]A`h^(#h\O3IR8cNCS\)FuVT,]A(HXJp.*^E@%UagdF"+^GI5Gj\K@2'#(I9g@
P0,1]A1k<ki7trM,,5cq&$La,ZB/#F)8#2e7iP=s%W;f#K=mm'[mSM1ep.JIk$MF0Lh\$_e,L
C8V9?4qPlf]A9&rd>Tl\@nQnHq\R5n9S8_rAO*m&PB1jk4:/kCHCmtj0*^!6M@nQZF?P'Y8?U
T=`4.ln0n)]A`O^X^Pqe&Hb0-Vt?Z.]A^pQ\/u]AL`r?-fnHfE;Mp?pMR7e.B,=DX3![QAY1-pY
/K\,3o'5J"krlU>m^p..k]A*a#,,TBF*cKlfbI>XmoR@n4569/E017lpLS&*q^QZ(QQ\%T_bC
B5#^@E?Hf"p5rUAU/eAuUa2\64iJ>A?!IP#7AU)3i"P@ELtB-*m@8d/]AeXCDG>eYmgSUmj=N
;5uV=ZW/IfO+Q4_Z'=1DYJMr[^j0/hs.=hNX<b+o2aTL0>]A1&"jB'ciZ,R.F#rA<IX?$ZZUZ
V[KFT'iYc7USZ9o;jG+lW31uj]Am-9X")R<ZI-\Ip\V\.L?WSMFbLq4WM*0<&j6_UMg?Dt-p>
P>XTT[Rk@)cb@6n6:Bbdci"&+_GuqFZ-l/>\o,%Yg`tBPf1S%NOe'c<ikN"jWbgDYZQU.qRN
Z*[Gm=94J-U`if%uXdMh./Ph:<=Q%YPG>_PJPQ>oLkq7[-cWTj4\_Ua`mL4#=:C-<m7hL)=b
Mm4sB&iq0r7Co4H1As.AM.unro*<VEie^U@$HW^(Pp-+ia\T`!dWi)T0A?B1cC2r4YHb.<s6
/is%B$eKS<Ttk))dD(Ka>j3Ja(_]A)/6Tor6#g*)_1M:8_Ff,m"Q`t]A#(Mh-:X?ka@-/VBE[>
0a=r(2+<Vm8d1Jr'[crp9hu2KBgR-gs/5Iu6T6p4\'S<fXEM80fGs)"5)Do9;'_<SqK,oAf1
-5>aC#Or#9,]AQs.>]AIhj;s@&V<=6Y$3.]AX%8p&0J/PXeGr[QM`qL)`P>3iD3Vb/E\1u5lDgR
ckKR2$D$n'LqP`07U8/Wd4,C_OgZ&ql_pe-iQlekK<kaG:rkq9E?gBr#KmThIc!Gq_3J(u91
eN0;(kPmC\RD1>s0PqXFERJMbLG.5n';65_6GkUk4>M$D@6*X1%#-^b;l3[,B-7'G2h=&X&#
hs[\;<Go(F85-TdEZJ6K8nK+2F,^0A4XNf:%!^IaZdc`pF)eL?e@!$\)!&K&EhMTLPcmBZGs
=6DU7R>EKrj&*QhoXVMKS2ERG?&d\\sDB^))KoiR$X(D5a:9*W"]A:uF*2(PAYe!^F)i$fS=C
%;c+N'o\H7EIDG]Ab8q+r7;'nN-]ANB4^G,i&M&DsknNk%+aJcLcj"sH#`6.mX!&D*[AM=6@C&
2$$MBmfW_tMJ?:([]A1f7*7K=3/e.s^,E-Q]A?r=9oLfH&M2>>:6>93ht+lo.#m8'[foij&B>L
dr')m3l9/,\#/a/o]A1.m]AGHXKV.T@gZ90XhE&`hshU[g?0^8L@IDl,f=[P@8qVTnOQ)s^Y]AG
SskYT3nQE.IsPg+,cOPX#HdT&YPZ7?s:&aKG)H0D*[E+`I>0=HW<@1t':Id1:n$QGK'Y9T,N
u8kt=kV(fpp+lCfVmf<#j\q$s![!&T;O@!BSFhJm%[pdk^1F/tu9f!FsE<j0ZFH"3/PqVDDX
Wq4?m<_c7\0"YCpa9;!c/khf(A:?;9.brUh-hSE9]Aui`nX\f]AP@WBLdAgVsm#DIQ6.VXdBJM
d@="SR'i%GT\F4^-X$9W$(gMbQlGk-SY'Fk#:`SbBT?9uDM%Ej_dY&e+)NQO_Pb]AdSdgC[X+
A:l^O<@DBd[+85-c3YUb`X_HXMWsKuQ7V_70kpUVeOhrF*ih\%8i1"aZD*1D!Om'2XI#+r%=
:cE38[<gd5\M5bF@!u.`1Vj.;"*%"l]AtuOl4LbD/d*;]A(sC!a&G"_9L_/R,5>s)-\="N5Ih`
e0)[O5[_hLup\GT:kV@I5^5aO.b)#<%'BnfS7^.OqVsZ5d7Ys)PQ@PGTVo\&&nHLZ/`6F4[Z
k<La@38Z3#165Gc:b#4Dd#4J*moq*j<U*2N+oBsT8<C:qD@l;:\b^CLCPeQ)!q?mSc?)Jm"P
e,l_E[RY&R_bf9s'(PTr;^oROl+I]Ajra0#?eWF]A^BtkYsfT!^.40#;Nfp2K#*jH46/TL-(bd
1L&B(=i-U4(ZNHDjt;j'l.A(0XEpK0.'_K:ocCj)Usk]AcD2lH@fug7h[ac(ro]AoKsq'B^&HF
D1:Lb>g3<U)TDJmFYB:e$@(21\NeS1igYJgoI70B/f%46D0^.1p:?mug<[`#>LB@Q#_mRcWj
o)OBW=fCc+'fUCkuR<Mp0Y_'P`%s.0FbBc\-N?CpRNMAs,>$8o##:lB:E^a=e#Z;n[\e^gk5
@)N`'!nlQH4T7Ad*[lLK;>8$A58BN7Lqa;.RNB"]A^!#X"t;dW*jY2td=9N9V$C[KN71u\TMp
uo$,%<H4Qge^eX7H+*L`uc$&iiDc=qXQ*(e2<9I37!pZAU/nL;hN3:KNe/HK_eb\1(SEEEdM
k[@#=.>o4#)B=*JeI^=>4E\F31>qD*%abrknsM_.'0HNaX$^7i_40Rtjcjf\p#)M,+rNu,3D
-$/J+*:ZM"8fZC[N0;Ra*a4*Mtm]A`-5CkX4>t&3SKX>)^]AA"pW0G<&bh"))8kVEk?aM_16Es
07!j)qbWC+H)qp-q,^[Lg#naai\oT*Vs'dU7X;qEH:3GDE]A<sQIW\:LQL0:ZCoU.K+l!\]AK+
kTP"rI*`QnYrq(kEf`8kN!]A]AmpqupYfkd#%_ZtcK!?s5SX$9R8LCEhe+Q!`&&74t&V66BEjX
dNDZn25QDT:q)5Q'mitnR>.D*+,',n2g2c1JO]A2>Aij,HmoN8"+XMf6$mKkFc;hY@]A"Dkpt2
21a$Y%!CX7PYAM!qO#WkU"um!Rs((b2tR<UoGLq3:8h#FosdU8rZ06.6fi"`Y?DEY`7M>Ra7
jcT[ob>Rb95tV*;oPGmY$"0hC'Vpp\>?g$G*;:5n+mT?:>6G8G:<>4=rkDi>HCd8H.@[d%>s
,aQYOF.V>#GqS)"ibWs``c*6GD"qn[*r\=RQCSAU):T?0U(Re5_EVPQBn@i&]A-+PF\mE#!N1
#eC,T:f0fqE=_NWQu%rnu/-RQ`,hWb?"I4h[\2VC.=^o%4,uD]ADd8%LatC);8e<[4'<^I9<M
*Fg)KH5mcL;=-0*CCirnIqNmBIu#3rZG;b23C9g@OQZQgHBNYt1LN,M3n<0_%T_Z?5j1=S#B
XGEaQ5#IWtl_fg!pK6qA0pj9R"Sp0#E-92Y9aLNH2'2A@-Y#L*1Kn5.R^N`?FbNmEL?;:7?B
;4ik==jO?Og[BhC^@-WlEk)&1;)6g$p3p`C_5DjrVn+AmKm\5&/jbSkS<8_,_h^0/gm9*@V^
IBVH%MTnK9f+['I$;LXCmDR"rh)B&\L(p2s:f<ZU_)"$8mYdJ97G:[`-AK1-A-'rrNdIpf0q
$U+Pk2]AZ>HM:2#.)/4.)lrgUc2j9Hnf<;=;KS6D+gV85K9/(['i9$Ho6^10VWgaW@ARh@E0+
]A/*0k9E)7AU%6a@\1SnqD%6ookQZH2PLHO%nSO5^f??M0-cS34),mlDU^j$a62q.^HA<S%d!
=]AU2>*#%trFKf26-Q1&]A!]A@-g`M55r+e0T]A%8O4oG#g/X/Y7pkBRJ#G.r9i21S4l^&p\+]AU!
k&!RH$g"Sf!YT;>Yf=\a^u4iLo&)6AZPSl>iF_eoDjHSFKN8m*Z^'39qVI*^6"C%SK!W.+7Y
`eXtpbLHFl(mnl7)7.JHjdk,-YXa9B*g?AX8aXW*a%V3q/X_/@C:)(jPF8.qs\.=NuRs"QJS
+N2M)kNn>(lqru(W@"ni:T2.R>#J".NE1$C[RMcF7X\M'63uq1k?<af[Ik[$*V\HCVs-imBV
!K/DW.\?PAT5i^GGe>rqu('V<C=Kt9/Z<WX5\4JI'*,GO<(lLo0^`G>o)l\k*ZB;1+M[9`$p
18-/'LHXd]A8>e:FXdN/qD#R`D&KIcGYUt:;Q+TK.G"hi(bsDt_T,(Ytn69^Rrkm[ZSZDROoL
:a"E@9>5>,N`6)bop50Moe?gm-f;`&:@.-H8-QM0I<FDb'7fC=9FL%@<jcd&SVWD^Vc85(dM
99D0m8kBd;t=GkRRh%-%Dn-4@$L;nl0OaHB$[ljpKdO/f599)l`'N,P2P;Yh.Dn&!IhNeak3
(kcIQD*sCgZ#*ZVm\_bmDUP&58[8dn!%P]AOkqY=FFSWu><O$$2odUTdo+UrU&F"4>1#M+d<"
^^PYcG0MHHd-lAE>+Gqp0/^iUU02c4KV-[G`n5X1q`1<p7b/9+Qr'PcU)m8/kc[FRl>b%uh`
8]A40X'hu(NBC/\@?A]A<c)?c:cDlo0:.;IEm(r%bLNtkHc_B"kDXfYCu%AZ36*3o+QU8R1@Ee
Af;S7Lj5`CV%J@MM-`7AG,sP>5f#gjHOdIShMXT?)r1RfSTa>&]A3igmY?09I<O2F<&-N'$FH
*$oFsQ_VeC_B_qRIbpb*"A(3%!$^\QGg'`N7RQ(0R1>cRQ\?eP-Pq2Yt`IsEKf#?OXc\K=Yf
Cu7#Eo=d`6Y:7Ui`"s/*@$nqY)Q_"k=JWB$@G_Ce/%XpS^S"+B:(`gdY7*2qf4lEL.(dN0DY
Obr$($[@Bph]ALYMZaIVX:E/RXmYZ[@f*PCKWg"*qVJi8Fa02KWmF*1-^596#V4_@VJ35D8Ls
)65S(hMU*X8>#8#j;Mcsd',A3Ct%q3`]A<44T\EGPHi3JeYqa'^YSHBUk;=*'Psk:A1r5h4RR
kAZZIh.iMZHjX%Qon[QKse.Kr.F>dXh)g=7A_"M<X#RM`a)HM9DoQir%N3jrg1'&kguX1hU+
IMrFnT(IFn_\oX)P/!la&[UrI(\]A,3'DXFW@?n^WZ/g5rZ;!E2s8JNgkJ&dc.%fc7I"a8Pt]A
*F*\b^crFLR@op8<sU:UhH7sNQ$i$#f?)b^ca@dLAJ$98pg?hb[X]Abc"SN>H4A`?EV]A$9Rt(
)=<+N`1@K,ue2^K.6I"*EoD<[7%9((J.9,4ts?G(c-O'e\6McK1uGc5oblT77>aR6VUF'qEo
W\mo!g1Zbeq@fFgro_ZZNRFrs&p9dXaCcn$2q&:LC&_U6dbgiCSTMQGiEX&Xn9FOlkPE66Gq
Ho\-boXs+nlV34sBC7-ti/oQktc\ou03/4o?i-27%GNXJpdic9^Gb<f65hOV#Lk4ej,lF`W,
h$RTp!4K*[VrH"IA,UT2EELObRi7RW9*S6TkR[NQVG/iF?T^ir40.besk+g"fr-?cW$aWX_2
$77tP)1u+UWI\kWQS7rbmH&6XK3k/*G[,5^eOhCiDt1U[W@k9*j^.s[8-G3LT7,LO6AN/AEL
Suj?Gl?I(f5n4GEiVfu/)=^?U'nMoj8ds"836o!RLZZE(aM9Ec>`3B,jL%p,1Ij\or01cTjV
2sMk'_XK@>1]A$,,qlO;KB>"9C-JZ#;/l58l%4>E@AAZ:*=/HP?eg%T.CB&D"Q9bf"0G6a3Ed
D-Dg4e6aE(ob!ScY7;%@QLL(a@WuRc+U=pNruTBMAZbf="h&(s]Ab;p;P?@Wo:&<34#!,GWJ-
jhnDc[h^;@#Si2!g;P7h0$+$P8TT"e?UJDP0af[1f,LXhC5,=-t+ZdMgNG3^$MFS60[ieALg
_u3mbt5W/cANk*Z,X\e1<llU:p=cpg?!WG[P#G54;&pBch'B"K=a&_*"[4;l30sn#qK;GMfX
YbJV>(r+?EGJ=QXG<o^Tg.MT1dZ'bF;6+PX@N^@&NOjU<iF@.qc^!DOLt/.9uB)tDamn-sU/
?Kn-Pm@8P>IJtB\1@FUW3R'#+<5Z7IP*a`A"n.p6B<B?c-'24:,dsnR;3p1Rj!<c3#.KMmAG
Ll)M*gn/.7,h.<_rWZ$/=%'.>Hr\XTTa79*6:</;WQ`HMKUW8e.C1=mBHQU5lU,\BkFX.odj
*Ud6r-POEC`c]AF3LdM<A2CF+.E#OJg`0-bB!chn@o+ejQP(4MaKKtF'H3r4'R?\7f@RgagaF
VE6=$=0q4&/MNE_rtC`JfD?UErV%5j)u+fN^,gn0=L5*+f\pS+U9!I5t,2m(n$0OM\-PfnV1
5!q-.LqV6iUTLXUo)ogsJ]A1tVM=<B;<]A"CN,a-uAn2X#fV3U)V8YL"c6N%XSMl5BF)W^!ljS
DOG1D_m4WrU!(25M09BuqBgY[LVM<hrlf#PkVRp";nM]AK5Xg8^lGA^lO?:$#s36JQcD?HKf#
u9!U[@d*\gAUFPL-^"a)QP3R*M.XS@<_c(SSLLhLh&F7!JHc+Kp&IFOdDYnI0/*;$_(dfZ'a
!oh$*]A--0&N6tq_^=>MLPUcFl3]AUWc%$r4(0901pGGo(]A4*Q+D5j&onY#uDuih.&QI=j'fE0
_pTH&Uue.ht2uG]AGXg#FN1,!7S)0udbHN#XUNia+DFT@^cs)iin@2&f8_1tc+Z!B$GL"bbJ2
j/,UbSnf[p;E[sNO_&\_OJNFW2Bkjqu;5Y:Ng$tdf@T/!l?Rb"Q!)oYeifXS?iW*a1p=4V?=
h4s-N-tbr8O&iJYf^-r:Y^jdQ.oh#^"MD7/\`7'J<:a$HgD::b0]Ar;<9!+"Q@`I!Qr)YTnBe
::s(?>4<bRHR-HY#Z-?<'O!^t+VZR]AVM&':0:td8fY4,6bj/I(F&jW#E$aGEVi38Y2d_FY*U
8Te&!6oNu'KiGdHu-?^9Gs8RuIs%6gR[cP,dYEC)K@enU3c_4b4ndWH;3LIO.S+1tOq2rU(Z
Qg(,X95i'fb$uP46pu!^MH1m6AYJ#Ndtpc$RBV11JQc&XLfKU=N2C4KF,r._HiJ#copo#2D/
dlgR?tH1QLJAa-+%3*'?bNIe+cI;E+4og<(oQh=mC"aAP7qR8_$Y%pS`@=4^dq#+%BVLQVq4
Wf(n-`ilOkh:2<p>hQ\geT(RI0;sWm^[`"-9!9n,55Z]A>]AW5<&.t=WkC@bCN5/ANE"p?P9?r
q+^SeYo+3!JjJ%8'i>iEiamrBFe]A;0M9eHd!R_Q<pLL&\>%4=^=ECd\:.Xg]A*[YZ?JUN9Co^
%oA+6ea/1mEp>8]A=>lZDo[]Ao_&fq-C/s7sDXSDKZtJ'm.+l2iVb1WuM$$et]ALD)5)Ds2o_j2
EqOAY&Q&NP9d(DUKKEi@J`9qc*IojIVCuA^OOEZfM*BU\oAh'ISjt0Y_DKEb]A[#PcqE.6['o
DK!?H$RQe^<?:p*A@)RcmKT@j]ACDV4a,I'Ptmh9\-#[HI5nTPmkEdBJ>ls310^aMm8;q4-]AX
'R_NeD(5<`1i+W;=>XhCqH,Rj.Jd.'Cgl'roW]A7AV<DF:YbgPndBKJ2A'qN7mJdP_T1'E.C;
B+Q)fiY2SqkPqmB2p"ZsFK>5k%TA>KM%6XE/':94[Y<ZR:3#:WP1,3qMp\`A<.8R=YMOg?dW
U:Kfaqhj7Q]A'VC*O^J.=`Du;VNV$E=KLZ3MLZp:61Tm;EK/Qan+nC9"lW74p6Qg`pHg+RcNm
X(&h]AisOJL2[G\I"00A8.4\^2,[T.5As]A!/*'PKWQ,s5SnD1'a$TVUd`0_-l[Yu!UDk$3i,b
52d9*6aIk7Dq,-<3l$sH&ZRDBGe*Hm)O+e`-<a$ONl,Sj8c,dEG7+Gkg%!_Fr=(._mX[6P?4
W<JGe>gEIC/<Ie:C4RWG;@=bTOBNc`L"$/q/>O%P@Ni-E&rZ'Y+Gn)1/<IdO8M$[PKd7;fMV
TpQM=/_TK1b"qcTl(42#al">%`*-M3$OJItI[6n$D;o*WPF)!<~
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
<WidgetName name="report0"/>
<WidgetID widgetID="ad6c4e00-2ff9-4357-b372-4e9613331d79"/>
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
<HR F="0" T="1"/>
<FR/>
<HC/>
<FC/>
<UPFCR COLUMN="false" ROW="true"/>
</ReportPageAttr>
<ColumnPrivilegeControl/>
<RowPrivilegeControl/>
<RowHeight defaultValue="723900">
<![CDATA[1296000,1296000,1296000,1296000,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[1728000,4608000,1728000,2592000,2304000,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" cs="5" s="0">
<O t="DSColumn">
<Attributes dsName="汇" columnName="VIEWNAME"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="1"/>
</C>
<C c="0" r="1" s="1">
<O>
<![CDATA[排名]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="1" s="2">
<O>
<![CDATA[品名]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="1" s="2">
<O>
<![CDATA[万购率]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="1" s="2">
<O>
<![CDATA[得分参照值]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="1" s="3">
<O>
<![CDATA[得分系数]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="2" s="4">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=seq()]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[row() % 2 == 0]]></Formula>
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
<![CDATA[$$$ <= 5]]></Formula>
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
<Expand leftParentDefault="false" left="B3" upParentDefault="false"/>
</C>
<C c="1" r="2" s="5">
<O t="DSColumn">
<Attributes dsName="汇" columnName="PLUNAME"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="2" r="2" s="5">
<O t="DSColumn">
<Attributes dsName="汇" columnName="ITEM_SHOP_PER"/>
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
<C c="3" r="2" s="6">
<O t="DSColumn">
<Attributes dsName="汇" columnName="ITEM_TOTAL_PER"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="4" r="2" s="7">
<O t="DSColumn">
<Attributes dsName="汇" columnName="ITEM_PER_DIF"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[= 1 - $$$]]></Content>
</Present>
<Expand dir="0"/>
</C>
<C c="0" r="3" s="8">
<O>
<![CDATA[汇总]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="3" s="9">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="3" s="9">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="3" s="9">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="3" s="10">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=sum(E3)]]></Attributes>
</O>
<PrivilegeControl/>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[= (1 - $$$) * 100]]></Content>
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
<FRFont name="SimSun" style="1" size="96"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="1" size="72" foreground="-1"/>
<Background name="ColorBackground" color="-13395610"/>
<Border>
<Bottom style="1" color="-1"/>
<Right style="1" color="-1"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="1" size="72" foreground="-1"/>
<Background name="ColorBackground" color="-13395610"/>
<Border>
<Bottom style="1" color="-1"/>
<Left style="1" color="-1"/>
<Right style="1" color="-1"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="1" size="72" foreground="-1"/>
<Background name="ColorBackground" color="-13395610"/>
<Border>
<Bottom style="1" color="-1"/>
<Left style="1" color="-1"/>
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
<FRFont name="微软雅黑" style="0" size="72"/>
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
<FRFont name="微软雅黑" style="0" size="72"/>
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
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Top style="1" color="-1"/>
<Bottom style="1" color="-1"/>
<Left style="1" color="-1"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-13312"/>
<Border>
<Top style="1" color="-1"/>
<Right style="1" color="-1"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
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
<![CDATA[m<j7[P@q=J4&05<''Y@_(:h\K7C6)l&J,"8*BGAm6:F=3L_V`rKQ%BeghQ(=]Aoe1O":Q`RVT
L2/O8pFq.7-EJ!<WH;Oq>/,$uZ1MP)tdd$Yj<L>F@KaXg>`+c:Si[eq/*1ca3)TBCGe>5&=R
Kkaf-M]A^`u\TV1,5m=4/U[p7d7@n"lhXN\F>&S@C)`Z'106(dO,OE"c&oPV!Dre>G_`'T5I]A
E:e'S'Ql(qmU]Aj>l(-Vl(aKLQaVWb?Q\9)]AKSDjmHVH8<da&aTVh=1aPPbEefQiR^%<B0$N6
O1`"M7.crDE?]Ahtt#_Sd]A(.F*de(8HG,^<Th1_5!]AkEE`BGqVl<=3<,bHV6B8NTT@#Wm-SfM
`Xr&F@csunCM2OqfgAQTBW%]A/Xr`\$T3(EM+aZWHps^gM/SB6C%'$0%jGnpNc:D/\D+RNh*m
>'VKmBhnbK8)e3I:NG@n4nZ"93o90ZbR%-_)>K5<mi%8\0!/UTVpEj!IbHQd(#rBOfe`T"o.
]A$(%mVJqK[V*0_4*84,TpqW\ddfL+TdrV:T6(9ijLZ/W-t[M`l@ic6Aa<aY?:Tmpqdcd[HS[
,RHbj"GRjc/m6N[h]A\5np.;F?Xg8"dQ`dZ)?XG,C^`obOH=tSr9";GL$Z&B.a_8-+m;GRrK6
q=Y[U,15,mVdqMBmqf5GZqYEpnL:-2Vh$g%7_j;mf+\q8AkCr4\0^P^OUjdsjdGLCWsibn&u
(r,AiVdF`JVTEb'qOP>d/fVXK9$rNZC6h^5&Y7_9@X;e9[=f'iV=k3);D-cCf#u!+mXaW$4%
0i^"270f>HQMdE*#Y.F*\tN<G/s;0$QGRd;Q=B_(qhd+KpI&B%lW\8M+k_C&T:g$GV_Q4pe/
gmFre$<q&c1KGgOBH#%i25lhg/dZOf"EYDO\P7E^RNLik(F)3U;G1$o*UD[<m*ck8pOEJsDg
`9J-/.:6`N]A$\HYDqMD%\WlPotZA+&?>'TVa4b\%"A@NT5+R%]Ac*oEO!<WHW9"ZiO"6`t-/g
fF)gT=N"AP\PbiYcqYSsZ8#14tML2gN4N%-S!2a/XaI`NdGgHr8+V'DB0?E*dY&OGu(W#!Ld
Z$s1P#%dkmd8P-Dn;1*(M7*e"E/![l#</kR(Og)UQtnNF=mX@YHO+72Cj'G2KqUu%l?^S"!X
#;D6!mp@nRX.g)"C*Qr!?:2aY-YiMaZ(hfa@0qCT5,*c3P815&PcN@5S&,K,V/)cr<@AgBii
qam80k9q3LGob]AGJdl3a##YHT'U^Bd3lD:q6m<kt3-g/Z!(F<;UlRBB%o^6n@2iS_1)Wp:n_
f7*OA0`R2l#VoCacZ.m]ALGbM]AS^=VaWAYjWHu7s]A:E0@p/B7=fE2[U&"c.42^iQLh<-;(<cP
p2RmL<3d%-=&h,T0Qh?G;UFVD#NkW)7GqSg_/L>2PM>";n(m!Cg?k4(P:,pA@>5*-8.S=ZZq
pXbO$B4rjcbemEn?]A9'!@p8>*"spW3MI2ePBc/YL0_Gd$c&sA:2#`lp2N=ghDB%00pQ_X]AW6
]AN_*WP9tj`;6(F-GL8bgc`R%`)-8(Gt\0_D)gp()W47ch/7U$OgE/SkWljIC=V>%tflu2%4%
4Oj7K$Mopr./fSX7+Aqnb;OX9B)k$o-T+Q';9r8?%S7OPf"\AbQamid(-;*mr-q\S511=UeL
E3j5d.kW)7K[?Y;[^_+)M^(Z7+RC,YiM9Hk>VOiL3e%aCJu&1od2HjV`74B^-/cIL7@?bqag
<h:2M)&^W!lcdk#"%^JYs_,'h'aSL"S:P@H?\hIo^Y^"/=0Y@3h-XJFfrf$W5u&1CBoT1_e*
]AFc3Mep!4-O<@VHA?YWrGc&idm?iP>,]Ahp[Ke/SAE^DRVe'KBFVLKA?54tRi9p;mf5`qG>GB
9#1rW[K?AZmG8IQduZ[Ke9lRd0M0G1*uLaX#nkRkal-BBSTu>N=>S'^qnDGf)XmYk7aQ.>u6
oo"ML94L=YclJOW=kk\b:'1IQe!mpRj066H61./0*Bh.()?E\r"'-W35oji[&/8]A#fp*3Q6\
2;gj-jF>t@u3a5nA%$TUX;>gLeEX:kZ+k/OGTO:3l*'-I*N85:0A81!-Du5@RS*DN&)c\YCb
fu2l?Jh(-PLho),I$<(To.9__i87!#iCn[K$f,C*[e+Xf25.9d<M6:Kd4M,7D3*.WsO`FfoH
\ZS'5CN,M3]AYZ$Wpm7R$AMUj.ATAa;pjguJ;\\KRJ]AUcKfo0%i=jCfW;L;MFY4-ZFBT%sB$$
9&\Pm=Z6hahHu_&gdg]AM5Qh\&E!(UJRl8^:K@l-)L-3XaleI5]A8I,Q5/kNk)Rl)s2';Hes5/
B!t]ALcM1k6'F++8a.Ho,#0GD3VVSnp<S09JQ/?&P/gMa`,bn9LdKrN/C>*DfZ_uJr':e->9#
?Y9j6A.W'GE`U%jFPDj)2<,.2+-6l/DMuPMGj+jKp3U5]ATgi^#JU;-94?-Yifl%I3q?#6>U0
$F.EXhjT6cjue]AP7_5lE#QrC/i4V*&1\5:mp\/m4%Bb!ntC&mO3Z:=q8alJ;4V(8Y"AUKenU
q^AbA?fi`>X>OJ%;Bi]AIZYT&TmWHMA;pu(^<L4hu%'HhOg;_Nfk'P"V;`JBHI^)INNLlcXep
5nPZW4oo:i4JmI8g`A4rY19jjPMr$Hr483VZ%HWQ"b^WRB2gPt_4LUXf\j8O"Jqf4G*]A`g/h
<Z#'&$(deUha-1EKj*RO[eIY*TQf*<;!C5@BppBIY^rlNQUFZDS-n1L58&#L`F@4Y+<h.3-7
E>i9G*EQ#*c=S*19hP5gO&0YIt)d/KL:`;D)Ts1W-Dsc7VQTOGq&8UGJ-D3Tk2Y\c@%8(KJ_
h->Wb]At9fPV_Q\^RjQ^kHu9lu->g.K']AW8hkmLWZ"b<>`D$PndIP4c6E:*]A^"a2CtH3BKubR
RiftSVW[#=n-6Ga_;M:*;86OZA,)/F*9,:sSE(jb=]Ap.Wh'7rg)u3J%^G'u!Rh3r>O9l41jY
p;$8/&m^m/2eT2/)[5.P(u(ocgXE43-02_<;]A+1_"8Q)0/-4d#g5`Tb_EVbi^=D"JOM;ET7E
%+[oLmf'u:#BhOmHAp=IeWbl?am93LNrH0O]Ac1,\SK.!iDV6<_!pD";4S(4T_,/tg;lkcm%4
+0M5Nei%"RA1bJP:JktH'*!a99>5gQ>d=s+-g`ZBL]Aj?o\ZG\/ISU3E:/j^ER342]Ab=Fjrf:
JjrqJ5dI0jcM8@-&2P8N[78EYMrT]A5NRGfehapqMP>-UB@"C$(ZIVHY!4./^&(F8$=6^30G=
[q2?#,T2XkS,*VfE$Kj`DcZaQB;$+`nVfO/Mi><blHDTO8jdH"FC9(>aQLX`'#Orfa*.d)DE
-:Can>#OaD[_a^\\JS[^0u,e)r&%aP>"_ERB\)E#,a6^K'J(I3-8E#u4=Jh(E92ab?7diR`H
M`6Y)Hn<<_>lh8W=&3-(lQJ>j/5YYDJA<p.hrl=<>/"m9a\.Td,b:LNFpBtI43hFXofsi#l,
5h+8YeB`NZRdb/db$SU\)j#"#2^A=rqim;%BD3A/ut$U#p>QtI+=O7"#\F5^V2RQXSjjJis0
$@qqu8?Z7e,k4b8*4@J!n^?@)2#o[\TrYmc,cJkr,NX^V+]AN#QAYFhajlNnJCG;&23A_i^hE
gp1-#%%iSer?^3R>0N:SAR7M2p)qoC2BZ\@^AO+o2rq^l>if$?"d@FV2VWlVX]A2PlnXR2#;D
Tp2QR!T8F[DSdWc$JGGj7)t(]Au*&3"]AQ25od/?.7h0LfNa_+`6HYF>-GZc/rRDgYq4Jq3c6I
mpsU=^bE.^IN/;%l1(=*bG^uPGkp7`_(7P\$)A[B=oL2WNBTt'?K"[pW_+YA=hF]Ao7emrP_A
WHc3/f4X$h'_roqi"u5V/+_Y=_PR1YQkA@n`1MeCT'r&M9S$^kZBl4":?nkjdsIHE;/.Eg1.
nPW8gEH'=9nZEg5iS5_hlmk=m40$j(F7S!L?oI?Y'_CHar%SXODNVaClCHQ#Xm@'MDS[u%7H
%#Z*UV)sOh%']A$C439NoNhT"<[:BUhV`La<)'?-3+W@)gYP[=S&k-i_$H`3u4su>c)TVe[Sd
Do!HLsXBd_ZQNL7`>E\0gEgWZ0jVIqhWm%:imH.(Cm8'Z8VOXMT&WmqF%7.?Nd@nH`X+G"im
nGaY&H`9T>qaj%VD%LG%acb\Y+E=D(\H<jYn=M,-4H</T9b+bd>h=:I-k)R*_YQr2"RGnJA)
]A!nlFqeKX$R(+rkK."8YgS4Ic^kBP#`!m0r?Fhi9/BU^(t,_;A%q:)_NCL]AHpkH4l&NO#G@W
9FPc\@KA&e<*N[^0U$u*5CQIVHTl)ar6#fDZ/?0f9^,=l;7(9aeqKWWMZk%KSuc4>chX,A`k
QCrC>;8Wf$<@4u5]A*UV%cWX17[uj(VpV"P-$h25pC,B2KUfJPgDFHi#82-lS(;\?B#kMi_1f
o"lNXr)_C::TS':E,a>#LoJQPj2N=JZ@nWS^<A0r894dCm)aEmQ`1o`0BsU,J3$+j_#a'4nZ
[8JZ<>nR<9K5&Fl=^,Feuof0sMW\J,-),^j)@PrcoaH%5Xe5,&$VImhPdFhe;d6>'4`-Vm`O
U2@b?56+[6rqAa*n6trI<!eoYaeG^K[$MBqCHmNR2,J4GdQfl`B'ZejYdAi.#Q4q2,:Q#;>Z
<I@-)k04/_:#SGU8g0BF5j4,;,Ti*-A,1ns\Ee(>]AZ3gBU?osL5M9d05H?6q3$oYkf6_aDYt
Pp=cOkoL2Z`7_aYJ)PT<;$jPP2$BjN,A8Db\a>3f*9AD`ZCQb=0@j3tq6V-)gQ:/iOGe6>a4
+LE/2!srn6'rWA>NN6OC4H)VMb`Q)c9(\,OG0QC4@lVX,@Y?Ap#$I_W)bM9&c6=2G2W-jAT^
E:o68RD*ePhA0Z82aN>OQFMgOkE4NsjYkcDoYXml?_MtZ$KGo"?WV0upNh"\H4Wp![_!&?X6
's8DAiLp^DW4>M(gFk*8IOfM2#Jb%82I@^N`jgV^/\Zf__<SBlkIg?HX6D.;I1+H%L:jUctg
j+N`:W0+ASFsKD@L[-K'-e8f-IYe7DN)9]Ak^(>H^'6JPptm7tALXLdc`g\3YgR$.ZUCh@-Xg
;dJ'PQ`L_bM;R7?GLGi(EA'XK[X%6IKfom#Hn;YHa`hWc4r:Od]AF#DhU%fcQo`Nnfk:?2R8A
]AEZ7;s26.A$2(`nsfGgp*./GJp24#)4I'+0ECU7HR;UrO#]ATY`q"c<)NRJ6+$auRBPa<@Hqj
X!j&pf*=oBWW[44n[hO7Cd&P@]A&_X3Z'/Jc^'lqSJ3.?>`U^?J@7;:C0k4bl)%C+OCSVE8l9
,ag1p!.f.XX)Bo3Uog\K*PhBB]A**O!9u%`/D<L%2/(j=n:58r3$C+0.m45fr_"m`,fOZJ%61
o83,rY<(5[\HXL#2oG63!#JSc]AEUOR'X,9[.9e<3)o%5]AiaHj9<os*pE_;#9SO?--J1J5h"(
>j>;W!+oGh8G^<Om>Iqg$&-fKdsk\!8_s;rGbSf$0UKSaZHA0T$H,@>^tu(9[[#GcKdBZ4NC
ieR"JJ'6)@:Dn.L0S0_?MK(*H(XoWB?)>FF(iteUHW>Zdk"<Ol-ZQLb$+I.Mm%EAm4[(ej(J
u:QHCYV)"6q5*J:h5WcG7+l?&^4@%RZ=SfY'd^-s:OXsr$oVRG+-AC',EUYrX&e6Lao)bLej
T$X>Btb4LVJJ5WFiK*e2`CtdFiUs$T[[>AZ#*glE</b5H4R<LRU1#La+qM.:dnYuail/aJY\
bt&)1%kEX:1M-O'mY$F=M4'2Gl!pS""f2/&@ub%(eqY;5\3+O2n"E]AjaZ9s6hq,Yt>rB^L#;
l=_f(37s_\Qea[<UC"hDF7Ie>1QR::'UW`ta7*d/5CL3DpGr'&/c=kfr`I\BqbO&8d&iXAL'
F6/M_In5^BZ<k.KZ0cDF`C5gg7`RQs(FQr,X1J]A&:nl$RTK&(lRjJEL,TD&7,4IIh`EG'?XB
SaZ:ns$]AT.0e!#Cg5'\RL%.u*+V^O>^h/NLB#l&-DW&tmYS^c"A=GW@.MlqInll't5>gDIrN
gIeo2RXH9[8t-_)tDP?2^u6`9m&*u3fB2&361hnHmg1I`KV9dng54lWn(GY53Ymbq@NhdIKf
92h))QMYLSUKk(]ASaS5nDWMp(;gnQC)B[@YN)MnIBri#F3c)2Ct=.oNhj`35QD2iZCFj3jkI
Tu'^Ypf3aE'.`iI>PNptVUrYf\EsG02nF=;*!,sh>4'1QZqekec^9)RMDN5U(gD4;>D8k*-m
P-fe[`CYR75*p>s.696+>Eq%_SL%*l2Y/:PU5t^Tb]AE!?E[Mp`q-mYlTe<%"Ih)>ATZAo?@R
hQ\>d/bt"-&Ol$[;HREO:AOQ3O\3Xn/VXZSLd(Jhse_S%%FEo%p=sD[IgtaemP+Lo!^(^Qp1
3b`jKFY^o-HN<Zo!Z@!*3a:"QTN^L(@(3;SgAgjUZ%aEcY^PR`4!K[VP+cal`n2>Q,_:mR)V
-oZrsijr4D):HsC?-"dfFCV[t+XW/.M:/tn"eqXj2%<J<!(h2_lX*jqXM63us3.H]AE_3pnW5
:M5(GUC`$LI&oR"?JD#l"dkaE1XQ6G1K1=os%OP]A!.$%Im3#-oBXV#7>h4e9;5[0`=.E?q9e
NXLihp>-@-Y<$.<1'iZ<2H`*Il.ZkZ"tM.fit1,iQrKbQ).Wp)Bs$_bo<\PG#NrfUdXA"&1B
ACP_rldG4VX6a:_PEUV"'FPq3S9"G-VQ$7q<+4J6B=^.]A[/[WgUJ.C'LdIBU21EiD[.ZbaJm
Qm`^>tajaS++tH575q8J:+pV'Cf^&Ro7Zg.p#sN"/*`p[c+-\!c\\O#f-f+:-ll2k$WIR+=D
(Bj3HihGVGE]ATjodSXXIN[4C*kla#J(n5jQ\j%_rBC5)@(8aOW:?J\u74OWPXNJkP]A1/Rrkd
H;BkmdTJfj*2#J<Lql\a1!"U>#;&I:<b@!9DNBAg=W;b`GocMAN!j3l$F0s]A'1*LYb%Mu_4g
t$`/LG=SY8GGO9-;>M(J7c&q=PeY(#"!i-J";:V0W&D,=L\7dMUKIJ/>(nntak,]A("cDIY!-
2K$ZJ9[o&Q6*tR`*;AY:dm$c8eWUL-2U',Ys[V@'-#6atJk_1Xl-Kcj4fmU9n2WI=VRdj3(L
^Trk3I3a`0-ci')]AR[U"3sR@>o/CmTW=Zk'T%Ag:JgF5i**-H_bWN.e+ZQJ>m<<1$*?NO\/O
EQHqu['LX7li4p>PjDfWf7%P8Lq8'DaR=D)A'dajWmTo7I+Tb=9cUtlb0gq?IhfrTjtROuf\
)7t>+8K`L"b`qQ6JHo$/%+dFh2Q$?Rh;[IN`;UU%1R@#BU'ZLYWm\"EU+a!T[u[SNScd>qJR
7q:,iCClJSiS<WgYTX,j5W97%e=fi()ju:0fe2p#O,1=;[\_"t1M8KV-hJq?0%6&\A8&J4i,
,H_5T:/3YC+4HJK+p#$L+P5/eEIK.RgM"Ef1:)piaWWc%R3=X#*4k:"GFm1mmn4bag52iu.3
%2,\qmq4I67>s=>/DBG-)d?oHLF&C6gWlK\>JndL_CbH`\HH0=m)cImOWo2O%:Ei+:M<Z__o
;,;mt1%8<@dTWd"%Pc(NUp/rGJ,fPWUtkbD^^9g[]A4_@f@8FD(1:^@>79i-s-jmUY+\Af+$@
_&&_-R<j?U+!!pgaX&/\B1$(cYG0W=B!BCW=4[nTg0sVgd-VhI<i`CXTQS+jS8^0]A:o#,me/
Cge16hGuO;i/J)0+<@-\gmu/dtBd=q]AR4"=ZPUHJ>FPmFgu-Z1^)A"e)C@/,39#9WA./"m/Y
j[(a3K/s>0lji0TmZ&.daK:IU<[h-FZiiR=^>6@o.+='gg,q2^TQ%<?7E\N;$63k=B$3N&hF
Q3t&4JZ6VN$.1'pmdiD:lc->WFTs]A>2pl.8X[9K(7#@h-:flo_NpDZ2chKlLV85@97desqN6
#$=8cK$lC/W;s%_a'/]AR*&d=i)>kW!f<<H8S:*%PZo=?\_rk$HgJ(i1"bjBPIH"s<Dn$C<=J
^"ZoL()^F+m+3.$.1uOb3b)e.30M;6'oO+^BorYfMa2c^%^)0oMdY%\IpFg`9(=QRkiGLY;^
r!G29F=!b?+SBij8Y?F^k4\*s"3Z&D%8Df2s`ca@[6dcg5j!i"`XB2s[smEZ5h*kqtD>pgk)
%EP9)-*QY'2Q/Q(2IQ?BOfg9b]An#S!MRrQiINQ\ibs5u_as/??^#>/;k6QKD-.#_Zf+ql<h@
#HZV`<Rh5P(4$^p*B\rEjeSU=P)s[+ke*L^c<8,7!%s!GOY8BHJt4^Vk)<HH6pq>7Oi!WDe+
$7ZW_+7#8`sg]AdYU+m)nH/kRO'!oTVOLKi71CAOXeFg9*Oh\NtS'<O[gUqoc9KD(jIflg'BC
l;,OiEHY9TVV]A`h^(#h\O3IR8cNCS\)FuVT,]A(HXJp.*^E@%UagdF"+^GI5Gj\K@2'#(I9g@
P0,1]A1k<ki7trM,,5cq&$La,ZB/#F)8#2e7iP=s%W;f#K=mm'[mSM1ep.JIk$MF0Lh\$_e,L
C8V9?4qPlf]A9&rd>Tl\@nQnHq\R5n9S8_rAO*m&PB1jk4:/kCHCmtj0*^!6M@nQZF?P'Y8?U
T=`4.ln0n)]A`O^X^Pqe&Hb0-Vt?Z.]A^pQ\/u]AL`r?-fnHfE;Mp?pMR7e.B,=DX3![QAY1-pY
/K\,3o'5J"krlU>m^p..k]A*a#,,TBF*cKlfbI>XmoR@n4569/E017lpLS&*q^QZ(QQ\%T_bC
B5#^@E?Hf"p5rUAU/eAuUa2\64iJ>A?!IP#7AU)3i"P@ELtB-*m@8d/]AeXCDG>eYmgSUmj=N
;5uV=ZW/IfO+Q4_Z'=1DYJMr[^j0/hs.=hNX<b+o2aTL0>]A1&"jB'ciZ,R.F#rA<IX?$ZZUZ
V[KFT'iYc7USZ9o;jG+lW31uj]Am-9X")R<ZI-\Ip\V\.L?WSMFbLq4WM*0<&j6_UMg?Dt-p>
P>XTT[Rk@)cb@6n6:Bbdci"&+_GuqFZ-l/>\o,%Yg`tBPf1S%NOe'c<ikN"jWbgDYZQU.qRN
Z*[Gm=94J-U`if%uXdMh./Ph:<=Q%YPG>_PJPQ>oLkq7[-cWTj4\_Ua`mL4#=:C-<m7hL)=b
Mm4sB&iq0r7Co4H1As.AM.unro*<VEie^U@$HW^(Pp-+ia\T`!dWi)T0A?B1cC2r4YHb.<s6
/is%B$eKS<Ttk))dD(Ka>j3Ja(_]A)/6Tor6#g*)_1M:8_Ff,m"Q`t]A#(Mh-:X?ka@-/VBE[>
0a=r(2+<Vm8d1Jr'[crp9hu2KBgR-gs/5Iu6T6p4\'S<fXEM80fGs)"5)Do9;'_<SqK,oAf1
-5>aC#Or#9,]AQs.>]AIhj;s@&V<=6Y$3.]AX%8p&0J/PXeGr[QM`qL)`P>3iD3Vb/E\1u5lDgR
ckKR2$D$n'LqP`07U8/Wd4,C_OgZ&ql_pe-iQlekK<kaG:rkq9E?gBr#KmThIc!Gq_3J(u91
eN0;(kPmC\RD1>s0PqXFERJMbLG.5n';65_6GkUk4>M$D@6*X1%#-^b;l3[,B-7'G2h=&X&#
hs[\;<Go(F85-TdEZJ6K8nK+2F,^0A4XNf:%!^IaZdc`pF)eL?e@!$\)!&K&EhMTLPcmBZGs
=6DU7R>EKrj&*QhoXVMKS2ERG?&d\\sDB^))KoiR$X(D5a:9*W"]A:uF*2(PAYe!^F)i$fS=C
%;c+N'o\H7EIDG]Ab8q+r7;'nN-]ANB4^G,i&M&DsknNk%+aJcLcj"sH#`6.mX!&D*[AM=6@C&
2$$MBmfW_tMJ?:([]A1f7*7K=3/e.s^,E-Q]A?r=9oLfH&M2>>:6>93ht+lo.#m8'[foij&B>L
dr')m3l9/,\#/a/o]A1.m]AGHXKV.T@gZ90XhE&`hshU[g?0^8L@IDl,f=[P@8qVTnOQ)s^Y]AG
SskYT3nQE.IsPg+,cOPX#HdT&YPZ7?s:&aKG)H0D*[E+`I>0=HW<@1t':Id1:n$QGK'Y9T,N
u8kt=kV(fpp+lCfVmf<#j\q$s![!&T;O@!BSFhJm%[pdk^1F/tu9f!FsE<j0ZFH"3/PqVDDX
Wq4?m<_c7\0"YCpa9;!c/khf(A:?;9.brUh-hSE9]Aui`nX\f]AP@WBLdAgVsm#DIQ6.VXdBJM
d@="SR'i%GT\F4^-X$9W$(gMbQlGk-SY'Fk#:`SbBT?9uDM%Ej_dY&e+)NQO_Pb]AdSdgC[X+
A:l^O<@DBd[+85-c3YUb`X_HXMWsKuQ7V_70kpUVeOhrF*ih\%8i1"aZD*1D!Om'2XI#+r%=
:cE38[<gd5\M5bF@!u.`1Vj.;"*%"l]AtuOl4LbD/d*;]A(sC!a&G"_9L_/R,5>s)-\="N5Ih`
e0)[O5[_hLup\GT:kV@I5^5aO.b)#<%'BnfS7^.OqVsZ5d7Ys)PQ@PGTVo\&&nHLZ/`6F4[Z
k<La@38Z3#165Gc:b#4Dd#4J*moq*j<U*2N+oBsT8<C:qD@l;:\b^CLCPeQ)!q?mSc?)Jm"P
e,l_E[RY&R_bf9s'(PTr;^oROl+I]Ajra0#?eWF]A^BtkYsfT!^.40#;Nfp2K#*jH46/TL-(bd
1L&B(=i-U4(ZNHDjt;j'l.A(0XEpK0.'_K:ocCj)Usk]AcD2lH@fug7h[ac(ro]AoKsq'B^&HF
D1:Lb>g3<U)TDJmFYB:e$@(21\NeS1igYJgoI70B/f%46D0^.1p:?mug<[`#>LB@Q#_mRcWj
o)OBW=fCc+'fUCkuR<Mp0Y_'P`%s.0FbBc\-N?CpRNMAs,>$8o##:lB:E^a=e#Z;n[\e^gk5
@)N`'!nlQH4T7Ad*[lLK;>8$A58BN7Lqa;.RNB"]A^!#X"t;dW*jY2td=9N9V$C[KN71u\TMp
uo$,%<H4Qge^eX7H+*L`uc$&iiDc=qXQ*(e2<9I37!pZAU/nL;hN3:KNe/HK_eb\1(SEEEdM
k[@#=.>o4#)B=*JeI^=>4E\F31>qD*%abrknsM_.'0HNaX$^7i_40Rtjcjf\p#)M,+rNu,3D
-$/J+*:ZM"8fZC[N0;Ra*a4*Mtm]A`-5CkX4>t&3SKX>)^]AA"pW0G<&bh"))8kVEk?aM_16Es
07!j)qbWC+H)qp-q,^[Lg#naai\oT*Vs'dU7X;qEH:3GDE]A<sQIW\:LQL0:ZCoU.K+l!\]AK+
kTP"rI*`QnYrq(kEf`8kN!]A]AmpqupYfkd#%_ZtcK!?s5SX$9R8LCEhe+Q!`&&74t&V66BEjX
dNDZn25QDT:q)5Q'mitnR>.D*+,',n2g2c1JO]A2>Aij,HmoN8"+XMf6$mKkFc;hY@]A"Dkpt2
21a$Y%!CX7PYAM!qO#WkU"um!Rs((b2tR<UoGLq3:8h#FosdU8rZ06.6fi"`Y?DEY`7M>Ra7
jcT[ob>Rb95tV*;oPGmY$"0hC'Vpp\>?g$G*;:5n+mT?:>6G8G:<>4=rkDi>HCd8H.@[d%>s
,aQYOF.V>#GqS)"ibWs``c*6GD"qn[*r\=RQCSAU):T?0U(Re5_EVPQBn@i&]A-+PF\mE#!N1
#eC,T:f0fqE=_NWQu%rnu/-RQ`,hWb?"I4h[\2VC.=^o%4,uD]ADd8%LatC);8e<[4'<^I9<M
*Fg)KH5mcL;=-0*CCirnIqNmBIu#3rZG;b23C9g@OQZQgHBNYt1LN,M3n<0_%T_Z?5j1=S#B
XGEaQ5#IWtl_fg!pK6qA0pj9R"Sp0#E-92Y9aLNH2'2A@-Y#L*1Kn5.R^N`?FbNmEL?;:7?B
;4ik==jO?Og[BhC^@-WlEk)&1;)6g$p3p`C_5DjrVn+AmKm\5&/jbSkS<8_,_h^0/gm9*@V^
IBVH%MTnK9f+['I$;LXCmDR"rh)B&\L(p2s:f<ZU_)"$8mYdJ97G:[`-AK1-A-'rrNdIpf0q
$U+Pk2]AZ>HM:2#.)/4.)lrgUc2j9Hnf<;=;KS6D+gV85K9/(['i9$Ho6^10VWgaW@ARh@E0+
]A/*0k9E)7AU%6a@\1SnqD%6ookQZH2PLHO%nSO5^f??M0-cS34),mlDU^j$a62q.^HA<S%d!
=]AU2>*#%trFKf26-Q1&]A!]A@-g`M55r+e0T]A%8O4oG#g/X/Y7pkBRJ#G.r9i21S4l^&p\+]AU!
k&!RH$g"Sf!YT;>Yf=\a^u4iLo&)6AZPSl>iF_eoDjHSFKN8m*Z^'39qVI*^6"C%SK!W.+7Y
`eXtpbLHFl(mnl7)7.JHjdk,-YXa9B*g?AX8aXW*a%V3q/X_/@C:)(jPF8.qs\.=NuRs"QJS
+N2M)kNn>(lqru(W@"ni:T2.R>#J".NE1$C[RMcF7X\M'63uq1k?<af[Ik[$*V\HCVs-imBV
!K/DW.\?PAT5i^GGe>rqu('V<C=Kt9/Z<WX5\4JI'*,GO<(lLo0^`G>o)l\k*ZB;1+M[9`$p
18-/'LHXd]A8>e:FXdN/qD#R`D&KIcGYUt:;Q+TK.G"hi(bsDt_T,(Ytn69^Rrkm[ZSZDROoL
:a"E@9>5>,N`6)bop50Moe?gm-f;`&:@.-H8-QM0I<FDb'7fC=9FL%@<jcd&SVWD^Vc85(dM
99D0m8kBd;t=GkRRh%-%Dn-4@$L;nl0OaHB$[ljpKdO/f599)l`'N,P2P;Yh.Dn&!IhNeak3
(kcIQD*sCgZ#*ZVm\_bmDUP&58[8dn!%P]AOkqY=FFSWu><O$$2odUTdo+UrU&F"4>1#M+d<"
^^PYcG0MHHd-lAE>+Gqp0/^iUU02c4KV-[G`n5X1q`1<p7b/9+Qr'PcU)m8/kc[FRl>b%uh`
8]A40X'hu(NBC/\@?A]A<c)?c:cDlo0:.;IEm(r%bLNtkHc_B"kDXfYCu%AZ36*3o+QU8R1@Ee
Af;S7Lj5`CV%J@MM-`7AG,sP>5f#gjHOdIShMXT?)r1RfSTa>&]A3igmY?09I<O2F<&-N'$FH
*$oFsQ_VeC_B_qRIbpb*"A(3%!$^\QGg'`N7RQ(0R1>cRQ\?eP-Pq2Yt`IsEKf#?OXc\K=Yf
Cu7#Eo=d`6Y:7Ui`"s/*@$nqY)Q_"k=JWB$@G_Ce/%XpS^S"+B:(`gdY7*2qf4lEL.(dN0DY
Obr$($[@Bph]ALYMZaIVX:E/RXmYZ[@f*PCKWg"*qVJi8Fa02KWmF*1-^596#V4_@VJ35D8Ls
)65S(hMU*X8>#8#j;Mcsd',A3Ct%q3`]A<44T\EGPHi3JeYqa'^YSHBUk;=*'Psk:A1r5h4RR
kAZZIh.iMZHjX%Qon[QKse.Kr.F>dXh)g=7A_"M<X#RM`a)HM9DoQir%N3jrg1'&kguX1hU+
IMrFnT(IFn_\oX)P/!la&[UrI(\]A,3'DXFW@?n^WZ/g5rZ;!E2s8JNgkJ&dc.%fc7I"a8Pt]A
*F*\b^crFLR@op8<sU:UhH7sNQ$i$#f?)b^ca@dLAJ$98pg?hb[X]Abc"SN>H4A`?EV]A$9Rt(
)=<+N`1@K,ue2^K.6I"*EoD<[7%9((J.9,4ts?G(c-O'e\6McK1uGc5oblT77>aR6VUF'qEo
W\mo!g1Zbeq@fFgro_ZZNRFrs&p9dXaCcn$2q&:LC&_U6dbgiCSTMQGiEX&Xn9FOlkPE66Gq
Ho\-boXs+nlV34sBC7-ti/oQktc\ou03/4o?i-27%GNXJpdic9^Gb<f65hOV#Lk4ej,lF`W,
h$RTp!4K*[VrH"IA,UT2EELObRi7RW9*S6TkR[NQVG/iF?T^ir40.besk+g"fr-?cW$aWX_2
$77tP)1u+UWI\kWQS7rbmH&6XK3k/*G[,5^eOhCiDt1U[W@k9*j^.s[8-G3LT7,LO6AN/AEL
Suj?Gl?I(f5n4GEiVfu/)=^?U'nMoj8ds"836o!RLZZE(aM9Ec>`3B,jL%p,1Ij\or01cTjV
2sMk'_XK@>1]A$,,qlO;KB>"9C-JZ#;/l58l%4>E@AAZ:*=/HP?eg%T.CB&D"Q9bf"0G6a3Ed
D-Dg4e6aE(ob!ScY7;%@QLL(a@WuRc+U=pNruTBMAZbf="h&(s]Ab;p;P?@Wo:&<34#!,GWJ-
jhnDc[h^;@#Si2!g;P7h0$+$P8TT"e?UJDP0af[1f,LXhC5,=-t+ZdMgNG3^$MFS60[ieALg
_u3mbt5W/cANk*Z,X\e1<llU:p=cpg?!WG[P#G54;&pBch'B"K=a&_*"[4;l30sn#qK;GMfX
YbJV>(r+?EGJ=QXG<o^Tg.MT1dZ'bF;6+PX@N^@&NOjU<iF@.qc^!DOLt/.9uB)tDamn-sU/
?Kn-Pm@8P>IJtB\1@FUW3R'#+<5Z7IP*a`A"n.p6B<B?c-'24:,dsnR;3p1Rj!<c3#.KMmAG
Ll)M*gn/.7,h.<_rWZ$/=%'.>Hr\XTTa79*6:</;WQ`HMKUW8e.C1=mBHQU5lU,\BkFX.odj
*Ud6r-POEC`c]AF3LdM<A2CF+.E#OJg`0-bB!chn@o+ejQP(4MaKKtF'H3r4'R?\7f@RgagaF
VE6=$=0q4&/MNE_rtC`JfD?UErV%5j)u+fN^,gn0=L5*+f\pS+U9!I5t,2m(n$0OM\-PfnV1
5!q-.LqV6iUTLXUo)ogsJ]A1tVM=<B;<]A"CN,a-uAn2X#fV3U)V8YL"c6N%XSMl5BF)W^!ljS
DOG1D_m4WrU!(25M09BuqBgY[LVM<hrlf#PkVRp";nM]AK5Xg8^lGA^lO?:$#s36JQcD?HKf#
u9!U[@d*\gAUFPL-^"a)QP3R*M.XS@<_c(SSLLhLh&F7!JHc+Kp&IFOdDYnI0/*;$_(dfZ'a
!oh$*]A--0&N6tq_^=>MLPUcFl3]AUWc%$r4(0901pGGo(]A4*Q+D5j&onY#uDuih.&QI=j'fE0
_pTH&Uue.ht2uG]AGXg#FN1,!7S)0udbHN#XUNia+DFT@^cs)iin@2&f8_1tc+Z!B$GL"bbJ2
j/,UbSnf[p;E[sNO_&\_OJNFW2Bkjqu;5Y:Ng$tdf@T/!l?Rb"Q!)oYeifXS?iW*a1p=4V?=
h4s-N-tbr8O&iJYf^-r:Y^jdQ.oh#^"MD7/\`7'J<:a$HgD::b0]Ar;<9!+"Q@`I!Qr)YTnBe
::s(?>4<bRHR-HY#Z-?<'O!^t+VZR]AVM&':0:td8fY4,6bj/I(F&jW#E$aGEVi38Y2d_FY*U
8Te&!6oNu'KiGdHu-?^9Gs8RuIs%6gR[cP,dYEC)K@enU3c_4b4ndWH;3LIO.S+1tOq2rU(Z
Qg(,X95i'fb$uP46pu!^MH1m6AYJ#Ndtpc$RBV11JQc&XLfKU=N2C4KF,r._HiJ#copo#2D/
dlgR?tH1QLJAa-+%3*'?bNIe+cI;E+4og<(oQh=mC"aAP7qR8_$Y%pS`@=4^dq#+%BVLQVq4
Wf(n-`ilOkh:2<p>hQ\geT(RI0;sWm^[`"-9!9n,55Z]A>]AW5<&.t=WkC@bCN5/ANE"p?P9?r
q+^SeYo+3!JjJ%8'i>iEiamrBFe]A;0M9eHd!R_Q<pLL&\>%4=^=ECd\:.Xg]A*[YZ?JUN9Co^
%oA+6ea/1mEp>8]A=>lZDo[]Ao_&fq-C/s7sDXSDKZtJ'm.+l2iVb1WuM$$et]ALD)5)Ds2o_j2
EqOAY&Q&NP9d(DUKKEi@J`9qc*IojIVCuA^OOEZfM*BU\oAh'ISjt0Y_DKEb]A[#PcqE.6['o
DK!?H$RQe^<?:p*A@)RcmKT@j]ACDV4a,I'Ptmh9\-#[HI5nTPmkEdBJ>ls310^aMm8;q4-]AX
'R_NeD(5<`1i+W;=>XhCqH,Rj.Jd.'Cgl'roW]A7AV<DF:YbgPndBKJ2A'qN7mJdP_T1'E.C;
B+Q)fiY2SqkPqmB2p"ZsFK>5k%TA>KM%6XE/':94[Y<ZR:3#:WP1,3qMp\`A<.8R=YMOg?dW
U:Kfaqhj7Q]A'VC*O^J.=`Du;VNV$E=KLZ3MLZp:61Tm;EK/Qan+nC9"lW74p6Qg`pHg+RcNm
X(&h]AisOJL2[G\I"00A8.4\^2,[T.5As]A!/*'PKWQ,s5SnD1'a$TVUd`0_-l[Yu!UDk$3i,b
52d9*6aIk7Dq,-<3l$sH&ZRDBGe*Hm)O+e`-<a$ONl,Sj8c,dEG7+Gkg%!_Fr=(._mX[6P?4
W<JGe>gEIC/<Ie:C4RWG;@=bTOBNc`L"$/q/>O%P@Ni-E&rZ'Y+Gn)1/<IdO8M$[PKd7;fMV
TpQM=/_TK1b"qcTl(42#al">%`*-M3$OJItI[6n$D;o*WPF)!<~
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
<Widget widgetName="report0"/>
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
<TemplateIdAttMark TemplateId="1caa29fa-1834-4bde-82ef-ab2c794c0dca"/>
</TemplateIdAttMark>
</Form>
