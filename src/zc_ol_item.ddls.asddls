@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Olist Order Item Consumption View'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZC_OL_ITEM as select from ZI_OL_ITEM 
{
    key OrderId,
    key ItemNo,
    
    // Product information
    ProductId,
    _PRODUCT.Category,
    _PRODUCT.CategoryNameEn,
    _PRODUCT.WeightG,
    _PRODUCT.VolumeCm3,

    // Seller information
    SellerId,
    _SELLER.City as SellerCity,
    _SELLER.StateCode as SellerState,
    _SELLER.Latitude as SellerLatitude,
    _SELLER.Longitude as SellerLongitude,
    _SELLER.GeoStatus as SellerGeoStatus,
    
    // Shipping information
    ShippingLimit,
    
    // Financial Information
    Currency,
    @Semantics.amount.currencyCode: 'Currency'
    Price,
    @Semantics.amount.currencyCode: 'Currency'
    Freight,
    @Semantics.amount.currencyCode: 'Currency'
    TotalAmount,
    
    // Existing associations
    _PRODUCT,
    _SELLER
}
