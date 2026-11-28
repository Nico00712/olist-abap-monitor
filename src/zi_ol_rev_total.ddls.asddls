@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Olist Review Agregation View'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_OL_REV_TOTAL as select from ZI_OL_REVIEW
{
    key OrderId,
    
    // Count all reviews
    count( * ) as ReviewCount,
    
    // Calculate the average review score
    avg( Score as abap.dec( 12,2 ) ) as AverageScore,

    // Identify highest and lowest scores
    max( Score ) as MaxScore,
    min( Score ) as MinScore,
    
    // Count valid reviews
    sum( IsValidScore ) as ValidReviewCount,
    
    // Count positive reviews
    sum( case 
            when ReviewCategory = 'POSITIVE' then 1
            else 0
         end ) as PositiveReviewCount,
         
    // Count neutral reviews
    sum( case
            when ReviewCategory = 'NEUTRAL' then 1
            else 0
         end ) as NeutralReviewCount,

      // Count negative reviews
     sum( case
            when ReviewCategory = 'NEGATIVE' then 1
            else 0
        end ) as NegativeReviewCount         


}
    group by OrderId
