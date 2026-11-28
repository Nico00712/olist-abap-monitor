@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Olist Order Item Interface View'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_OL_ITEM as select from zol_item
    association[1..1] to ZI_OL_PRODUCT as _PRODUCT on $projection.ProductId = _PRODUCT.ProductId
    association[1..1] to ZI_OL_SELLER as _SELLER on $projection.SellerId = _SELLER.SellerId
{
    key order_id as OrderId,
    key item_no as ItemNo,
    product_id as ProductId,
    seller_id as SellerId,
    shipping_limit as ShippingLimit,
    currency as Currency,
    @Semantics.amount.currencyCode: 'Currency'
    price as Price,
    @Semantics.amount.currencyCode: 'Currency'
    freight as Freight,
    
    // Calculate the total amount including freight
    @Semantics.amount.currencyCode: 'Currency'
    curr_to_decfloat_amount( price ) + curr_to_decfloat_amount( freight )  as TotalAmount,
    
    _PRODUCT,
    _SELLER
}
