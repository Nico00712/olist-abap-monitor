@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Olist Category Interface View'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_OL_CATEGORY as select from zol_cat
{
    key category_code as CategoryCode,
    category_name_en as CategoryNameEn
}
