@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Olist Review Interface View'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_OL_REVIEW as select from zol_rev
{
    key order_id as OrderId,
    key review_id as ReviewId,
    score as Score,
    created_at as CreatedAt,
    answered_at as AnsweredAt,
    
    // Classify customer satisfaction
    case
        when score between 1 and 2 then 'NEGATIVE'
        when score = 3 then 'NEUTRAL'
        when score between 4 and 5 then 'POSITIVE'
        else 'INVALID'
    end as ReviewCategory,
    
    // Identify valid review scores
    case
        when score between 1 and 5 then 1
        else 0
    end as IsValidScore
    
}
