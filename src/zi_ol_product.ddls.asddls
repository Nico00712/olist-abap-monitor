@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Olist Product Interface View'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_OL_PRODUCT as select from zol_product
    association[0..1] to ZI_OL_CATEGORY as _CATEGORY on $projection.Category = _CATEGORY.CategoryCode
{
    key product_id as ProductId,
    category as Category,
    name_length as NameLength,
    descr_length as DescrLength,
    photos as Photos,
    weight_g as WeightG,
    length_cm as LengthCm,
    height_cm as HeightCm,
    width_cm as WidthCm,
    
    // Retrieve the English category name
    coalesce( _CATEGORY.CategoryNameEn , 'Unknown') as CategoryNameEn,
    
    // Calculate the product volume in cm^3
    cast( length_cm as abap.int8 ) * height_cm * width_cm as VolumeCm3,
    
    _CATEGORY
} 
