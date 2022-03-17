select distinct a.shopgroupno,a.shop viewno,C.ORG_NAME viewname,b.shopgroupname,case when regexp_like(b.shopgroupname,'事业部$') then 0 when regexp_like(b.shopgroupname,'区$') then 1 when regexp_like(a.shopgroupno,'^[A-z]L+') and regexp_like(b.shopgroupname,'.类') then 2 else -1 end viewtype
FROM "POS"."TA_SHOPGROUP" a
inner join "POS"."TA_SHOPGROUP" z on a.shop = z.shop and a.shopgroupno != z.shopgroupno
left join ta_ShopGHead b on a.companyno=b.companyno and a.shopgroupno = b.shopgroupno
LEFT JOIN ta_Org_Lang C ON C.OrganizationNo = a.shop
where a.companyno = '${para_companyno}'
and b.shopgrouptype=2
ORDER BY VIEWNO