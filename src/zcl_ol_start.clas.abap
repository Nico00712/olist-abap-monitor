CLASS zcl_ol_start DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_ol_start IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    DATA max_score TYPE i VALUE 5.
    DATA project_name TYPE string VALUE 'Olist Fulfillment Monitor'.

    out->write( | { project_name }, review scale 1 to { max_score } | ).

  ENDMETHOD.
ENDCLASS.
