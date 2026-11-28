@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Olist Payment Aggregation View'
@Metadata.ignorePropagatedAnnotations: true

define view entity ZI_OL_PAY_TOTAL
  as select from zol_pay
{
  key order_id as OrderId,
  key currency as Currency,

      count( * ) as PaymentCount,

      @Semantics.amount.currencyCode: 'Currency'
      sum( paid_value ) as TotalPaidAmount,

      @Semantics.amount.currencyCode: 'Currency'
      max( paid_value ) as MaxPaymentAmount,

      @Semantics.amount.currencyCode: 'Currency'
      min( paid_value ) as MinPaymentAmount
}

group by
  order_id,
  currency
