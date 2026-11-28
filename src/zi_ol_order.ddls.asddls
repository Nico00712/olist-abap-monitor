@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Olist Order Interface View'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_OL_ORDER as select from zol_ord
    association[1..1] to ZI_OL_CUSTOMER as _CUSTOMER on $projection.CustomerId = _CUSTOMER.CustomerId
    association[0..*] to ZI_OL_ITEM as _ITEMS on $projection.OrderId = _ITEMS.OrderId
    association[0..*] to ZI_OL_PAYMENT as _PAYMENTS on $projection.OrderId = _PAYMENTS.OrderId
    association[0..*] to ZI_OL_REVIEW as _REVIEWS on $projection.OrderId = _REVIEWS.OrderId
{
    key order_id as OrderId,
    customer_id as CustomerId,
    order_status as OrderStatus,
    purchase_at as PurchaseAt,
    approved_at as ApprovedAt,
    carrier_at as CarrierAt,
    delivered_at as DeliveredAt,
    est_at as EstAt,
    purchase_date as PurchaseDate,
    delivered_date as DeliveredDate,
    estimated_date as EstimatedDate,
    
    // Classify delivery performance
    case
        when dats_is_valid( delivered_date ) = 0 or dats_is_valid( estimated_date ) = 0 then 'UNKNOWN'
        when delivered_date > estimated_date then 'LATE'
        else 'ON_TIME'
    end as DeliveryStatus,
    
    // Calculate the differences between estimated and actual delivery dates
    case    
        when dats_is_valid( delivered_date ) = 1 and dats_is_valid( estimated_date ) = 1 then dats_days_between( estimated_date, delivered_date )
        else 0
    end as DeliveryDelayDays,
  
    _CUSTOMER,
    _ITEMS,
    _PAYMENTS,
    _REVIEWS
}
