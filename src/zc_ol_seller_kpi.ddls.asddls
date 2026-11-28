@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Olist Seller KPI View'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZC_OL_SELLER_KPI as select from ZC_OL_ITEM
{
    key SellerId,
    key Currency,
    SellerCity,
    SellerState,
    
    // Count the number of sold items, distinct orders and products
    count( * ) as ItemCount,
    count( distinct OrderId ) as OrderCount,
    count( distinct ProductId ) as ProductCount,
    
    // Calculate total product revenue, freight amount and total amount including freight
    @Semantics.amount.currencyCode: 'Currency'
    sum( Price ) as TotalRevenue,
    
    @Semantics.amount.currencyCode: 'Currency'
    sum( Freight ) as TotalFreight,
    
    @Semantics.amount.currencyCode: 'Currency'
    sum( TotalAmount ) as TotalAmount

}
    group by SellerId, Currency, SellerCity, SellerState
