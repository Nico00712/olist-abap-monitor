@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Olist Order Item Aggregation View'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_OL_ITEM_TOTAL as select from ZI_OL_ITEM
{
    key OrderId,
    key Currency,
    
    count( * ) as ItemCount,
    
    // Calulate the total Price, Freight and Order amount
    @Semantics.amount.currencyCode: 'Currency'
    sum( curr_to_decfloat_amount( Price ) ) as TotalPrice,
    @Semantics.amount.currencyCode: 'Currency'
    sum( curr_to_decfloat_amount( Freight ) ) as TotalFreight,
    @Semantics.amount.currencyCode: 'Currency'
    sum( TotalAmount ) as TotalOrderAmount
    
}
    group by OrderId, Currency
