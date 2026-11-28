@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Olist Order Consumption View'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZC_OL_ORDER as select from ZI_OL_ORDER as O
    left outer join ZI_OL_ITEM_TOTAL as I on O.OrderId = I.OrderId and I.Currency = 'BRL'
    left outer join ZI_OL_PAY_TOTAL as P on O.OrderId = P.OrderId and P.Currency = 'BRL'
    left outer join ZI_OL_REV_TOTAL as R on O.OrderId = R.OrderId
    
{
    key O.OrderId,
    
    // Customer Information
    O.CustomerId,
    O._CUSTOMER.City as CustomerCity,
    O._CUSTOMER.StateCode as CustomerState,
    
    // Order and delivery information
    O.OrderStatus,
    O.PurchaseDate,
    O.DeliveredDate,
    O.EstimatedDate,
    O.DeliveryStatus,
    O.DeliveryDelayDays,
    
    // Currency
    cast( 'BRL' as abap.cuky ) as Currency,
    
    // Order item information
    coalesce( I.ItemCount, 0 ) as ItemCount,

    @Semantics.amount.currencyCode: 'Currency'
    I.TotalPrice as TotalPrice,

    @Semantics.amount.currencyCode: 'Currency'
    I.TotalFreight as TotalFreight,

    @Semantics.amount.currencyCode: 'Currency'
    I.TotalOrderAmount as TotalOrderAmount,

    // Payment Information
    coalesce( P.PaymentCount, 0 ) as PaymentCount,
    
    @Semantics.amount.currencyCode: 'Currency'
    curr_to_decfloat_amount( P.TotalPaidAmount ) as TotalPaidAmount,
    
    // Review Information
    coalesce( R.ReviewCount, 0 ) as ReviewCount,
    coalesce( R.AverageScore, 0 ) as AverageScore,
    coalesce( R.ValidReviewCount, 0 ) as ValidReviewCount,
    coalesce( R.PositiveReviewCount, 0 ) as PositiveReviewCount,
    coalesce( R.NeutralReviewCount, 0 ) as NeutralReviewCount,
    coalesce( R.NegativeReviewCount, 0 ) as NegativeReviewCount,    

    // Existing Associations
    O._CUSTOMER,
    O._ITEMS,
    O._PAYMENTS,
    O._REVIEWS
}
