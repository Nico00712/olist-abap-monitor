@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Olist Parameterized Order View'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_OL_ORDER_PERIOD 
    with parameters
        p_date_from : abap.dats,
        p_date_to : abap.dats

as select from ZC_OL_ORDER

{
    key OrderId,
    CustomerId,
    CustomerCity,
    CustomerState,
    OrderStatus,
    PurchaseDate,
    DeliveredDate,
    EstimatedDate,
    DeliveryStatus,
    DeliveryDelayDays,
    Currency,
    ItemCount,
    
    @Semantics.amount.currencyCode: 'Currency'
    TotalPrice,
    @Semantics.amount.currencyCode: 'Currency'
    TotalFreight,
    @Semantics.amount.currencyCode: 'Currency'
    TotalOrderAmount,
    PaymentCount,
    @Semantics.amount.currencyCode: 'Currency'
    TotalPaidAmount,
    ReviewCount,
    AverageScore,
    ValidReviewCount,
    PositiveReviewCount,
    NeutralReviewCount,
    NegativeReviewCount,
    /* Associations */
    _CUSTOMER,
    _ITEMS,
    _PAYMENTS,
    _REVIEWS
    
}
where PurchaseDate between $parameters.p_date_from and $parameters.p_date_to
