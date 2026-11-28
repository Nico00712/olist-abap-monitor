@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Olist Geolocation Interface View'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_OL_GEO as select from zol_geo
{
    key zip_prefix as ZipPrefix,
    key state_code as StateCode,
    latitude as Latitude,
    longitude as Longitude,
    point_count as PointCount
}
