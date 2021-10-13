select distinct a.shopgroupno,a.shop viewno,C.ORG_NAME viewname,b.shopgroupname 		FROM "POS"."TA_SHOPGROUP" a
inner join "POS"."TA_SHOPGROUP" z on a.shop = z.shop and a.shopgroupno != z.shopgroupno
left join ta_ShopGHead b on a.companyno=b.companyno and a.shopgroupno = b.shopgroupno
LEFT JOIN ta_Org_Lang C ON C.OrganizationNo = a.shop
where a.companyno = '${para_companyno}'
and a.shopgroupno not in ('001')
ORDER BY VIEWNO