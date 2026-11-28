@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Olist Customer Interface View'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_OL_CUSTOMER as select from zol_cust
    association[0..1] to ZI_OL_GEO as _GEO on $projection.ZipPrefix = _GEO.ZipPrefix and $projection.StateCode = _GEO.StateCode
{
 
    key customer_id as CustomerId,
    person_id as PersonId,
    zip_prefix as ZipPrefix,
    city as City,
    state_code as StateCode,
    
    // Use the geographic coordinates from ZI_OL_GEO
    _GEO.Latitude as Latitude,
    _GEO.Longitude as Longitude,
    
    // Check whether geographic data is even availabne
    case
        when _GEO.ZipPrefix is null then 'MISSING'
        else 'AVAILABLE'
    end as GeoStatus,
    
    _GEO
}
