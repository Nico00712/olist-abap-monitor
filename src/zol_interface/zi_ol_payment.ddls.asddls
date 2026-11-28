@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Olist Payment Interface View'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_OL_PAYMENT as select from zol_pay
{
    key order_id as OrderId,
    key payment_no as PaymentNo,
    method as Method,
    installments as Installments,
    currency as Currency,
    @Semantics.amount.currencyCode: 'Currency'
    paid_value as PaidValue,
    
    // Calculate the average amount per installment
    @Semantics.amount.currencyCode: 'Currency'
    case
        when installments > 0 then curr_to_decfloat_amount( paid_value ) / cast( installments as abap.decfloat34 )
        else  curr_to_decfloat_amount( paid_value ) * 0 // This is used because only casting 0 leads to a wrong data type error.
    end as AmountPerInstallment
}
