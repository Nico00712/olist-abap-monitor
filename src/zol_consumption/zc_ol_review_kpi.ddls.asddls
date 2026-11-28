@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Olist Review KPI View'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZC_OL_REVIEW_KPI as select from ZI_OL_REVIEW
{
    key cast( 'GLOBAL' as abap.char( 6 ) ) as KpiId,
    
    // Count all reviews
    count( * ) as ReviewCount,
    
    // Calculate average review score
    avg( Score as abap.dec( 12, 2 ) ) as AverageScore,
    
    // Count valid and invalid reviews
    sum( IsValidScore ) as ValidReviewCount,
    
    sum( case 
                when ReviewCategory = 'INVALID' then 1
                else 0
         end ) as InvalidReviewCount,
         
    // Count positive, neutral and negative reviews
     sum( case
                when ReviewCategory = 'POSITIVE' then 1
                else 0
          end ) as PositiveReviewCount,

     sum( case
                when ReviewCategory = 'NEUTRAL' then 1
                else 0
         end ) as NeutralReviewCount,

     sum( case
                when ReviewCategory = 'NEGATIVE' then 1
                else 0
        end ) as NegativeReviewCount,
    
    // Calculate positive, neutral and negative review percentage
    case 
        when sum( IsValidScore ) > 0
        then division( sum( case
                                when ReviewCategory = 'POSITIVE' then 1
                                else 0
                            end) * 100 , sum( IsValidScore ), 2 )
        else 0
        end as PositiveReviewRate, 
                
    case 
        when sum( IsValidScore ) > 0
        then division( sum( case
                                when ReviewCategory = 'NEUTRAL' then 1
                                else 0
                            end) * 100 , sum( IsValidScore ), 2 )
        else 0
        end as NeutralReviewRate,
        
    case 
        when sum( IsValidScore ) > 0
        then division( sum( case
                                when ReviewCategory = 'NEGATIVE' then 1
                                else 0
                            end) * 100 , sum( IsValidScore ), 2 )
        else 0
        end as NegativeReviewRate       
}
