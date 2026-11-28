CLASS zcl_ol_import DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE .

  PUBLIC SECTION.

  CONSTANTS max_rows TYPE i VALUE 500.
  CONSTANTS max_characters TYPE i VALUE 1000000. " Arbitrary number, just chose a big one

  CLASS-METHODS upsert
    IMPORTING
        kind TYPE string
        payload TYPE string
    RETURNING VALUE(written) TYPE i
    RAISING zcx_ol_import.

   PROTECTED SECTION.

   PRIVATE SECTION.

   CLASS-METHODS split_row
    IMPORTING
        line TYPE string
        expected_fields TYPE i
    RETURNING
        VALUE(columns) TYPE string_table
    RAISING
        zcx_ol_import.

    CLASS-METHODS assert_written
        IMPORTING
            expected TYPE i
            actual TYPE i
        RAISING
            zcx_ol_import.

    CLASS-METHODS write_category
        IMPORTING
            lines TYPE string_table
        RETURNING
            VALUE(written) TYPE i
        RAISING
            zcx_ol_import.

    CLASS-METHODS write_customer
        IMPORTING
            lines TYPE string_table
        RETURNING
            VALUE(written) TYPE i
        RAISING
            zcx_ol_import.

     CLASS-METHODS write_seller
        IMPORTING
            lines TYPE string_table
        RETURNING
            VALUE(written) TYPE i
        RAISING
            zcx_ol_import.

     CLASS-METHODS write_product
        IMPORTING
            lines TYPE string_table
        RETURNING
            VALUE(written) TYPE i
        RAISING
            zcx_ol_import.

     CLASS-METHODS write_geo
        IMPORTING
            lines TYPE string_table
        RETURNING
            VALUE(written) TYPE i
        RAISING
            zcx_ol_import.

     CLASS-METHODS write_orders
        IMPORTING
            lines TYPE string_table
        RETURNING
            VALUE(written) TYPE i
        RAISING
            zcx_ol_import.

      CLASS-METHODS write_items
        IMPORTING
            lines TYPE string_table
        RETURNING
            VALUE(written) TYPE i
        RAISING
            zcx_ol_import.

      CLASS-METHODS write_payments
        IMPORTING
            lines TYPE string_table
        RETURNING
            VALUE(written) TYPE i
        RAISING
            zcx_ol_import.

      CLASS-METHODS write_reviews
        IMPORTING
            lines TYPE string_table
        RETURNING
            VALUE(written) TYPE i
        RAISING
            zcx_ol_import.

ENDCLASS.


CLASS zcl_ol_import IMPLEMENTATION.


    METHOD split_row.
        SPLIT line AT cl_abap_char_utilities=>horizontal_tab INTO TABLE columns.
        IF lines( columns ) <> expected_fields.
            RAISE EXCEPTION NEW zcx_ol_import( reason = 'Wrong number of columns' ).
        ENDIF.
    ENDMETHOD.

    METHOD assert_written.
        IF actual <> expected.
            RAISE EXCEPTION NEW zcx_ol_import( reason = |Expected { expected } rows, but wrote { actual }| ).
        ENDIF.
    ENDMETHOD.


    METHOD upsert.
        " Validate the payload size
        IF payload IS INITIAL OR strlen( payload ) > max_characters.

        RAISE EXCEPTION NEW zcx_ol_import(
            reason = 'Invalid size'
        ).
        ENDIF.
    " Split the payload into individual and even rows
    SPLIT payload AT cl_abap_char_utilities=>newline INTO TABLE DATA(lt_lines).

    " Validate maximum number of rows
    IF lines( lt_lines ) > max_rows.
        RAISE EXCEPTION NEW zcx_ol_import(
            reason = |Maximum of { max_rows } rows exceeded|
        ).
    ENDIF.

    TRY.
        " Lastly, validate the dataset name
        CASE kind.
            WHEN 'category'.
                written = write_category( lt_lines ).

            WHEN 'customer'.
                written = write_customer( lt_lines ).


            WHEN 'seller'.
                written = write_seller( lt_lines ).

            WHEN 'product'.
                written = write_product( lt_lines ).

            WHEN 'geo'.
                written = write_geo( lt_lines ).

            WHEN 'orders'.
                written = write_orders( lt_lines ).


            WHEN 'items'.
                written = write_items( lt_lines ).

            WHEN 'payments'.
                written = write_payments( lt_lines ).

            WHEN 'reviews'.
                written = write_reviews( lt_lines ).

            WHEN OTHERS.
                RAISE EXCEPTION NEW zcx_ol_import(
                    reason = |Unknown dataset: { kind }|
                ).
         ENDCASE.
    " Convert system conversion errors into custom exceptions
    CATCH cx_sy_conversion_error INTO DATA(lx_conversion).

        RAISE EXCEPTION NEW zcx_ol_import(
            previous = lx_conversion
            reason = |Conversion error in { kind }: { lx_conversion->get_text( ) }|
        ).

    " Convert database errors into custom exceptions
    CATCH cx_sy_open_sql_db INTO DATA(lx_database).

        RAISE EXCEPTION NEW zcx_ol_import(
            previous = lx_database
            reason = |Database error in { kind }: { lx_database->get_text(  ) }|
        ).

    ENDTRY.

    ENDMETHOD.









    METHOD write_category.
        DATA rows TYPE SORTED TABLE OF zol_cat WITH UNIQUE KEY category_code.

        LOOP AT lines INTO DATA(line).

            DATA(columns) = split_row(
                                        line = line
                                        expected_fields = 2
                                    ).
            DATA(row) = VALUE zol_cat(
                                        category_code = EXACT #( columns[ 1 ] )
                                        category_name_en = EXACT #( columns[ 2 ] )
                                     ).

            IF row-category_code IS INITIAL.
                RAISE EXCEPTION NEW zcx_ol_import(
                    reason = 'Invalid category row'
                ).
            ENDIF.

            INSERT row INTO TABLE rows.

            IF sy-subrc <> 0.
                RAISE EXCEPTION NEW zcx_ol_import(
                    reason = 'Duplicate category key in batch'
                ).
            ENDIF.
        ENDLOOP.

    MODIFY zol_cat FROM TABLE @rows.

    written = sy-dbcnt. " Stores the number of database rows affected by MODIFY (doesn't matter whether it' inserted or updated).

    assert_written(
        expected = lines( rows )
        actual = written
    ).
    ENDMETHOD.


    METHOD write_customer.
        DATA rows TYPE SORTED TABLE OF zol_cust WITH UNIQUE KEY customer_id.

        LOOP AT lines INTO DATA(line).

            DATA(columns) = split_row(
                                        line = line
                                        expected_fields = 5
                                    ).
            DATA(row) = VALUE zol_cust(
                                        customer_id = EXACT #( columns[ 1 ] )
                                        person_id = EXACT #( columns[ 2 ] )
                                        zip_prefix = EXACT #( columns[ 3 ] )
                                        city = EXACT #( columns[ 4 ] )
                                        state_code = EXACT #( columns[ 5 ] )

                                     ).

            IF row-customer_id IS INITIAL.
                RAISE EXCEPTION NEW zcx_ol_import(
                    reason = 'Invalid customer row'
                ).
            ENDIF.

            INSERT row INTO TABLE rows.

            IF sy-subrc <> 0.
                RAISE EXCEPTION NEW zcx_ol_import(
                    reason = 'Duplicate customer key in batch'
                ).
            ENDIF.
        ENDLOOP.

    MODIFY zol_cust FROM TABLE @rows.

    written = sy-dbcnt. " Stores the number of database rows affected by MODIFY (doesn't matter whether it' inserted or updated).

    assert_written(
        expected = lines( rows )
        actual = written
    ).
    ENDMETHOD.


    METHOD write_seller.
        DATA rows TYPE SORTED TABLE OF zol_seller WITH UNIQUE KEY seller_id.

        LOOP AT lines INTO DATA(line).

            DATA(columns) = split_row(
                                        line = line
                                        expected_fields = 4
                                    ).
            DATA(row) = VALUE zol_seller(
                                        seller_id = EXACT #( columns[ 1 ] )
                                        zip_prefix = EXACT #( columns[ 2 ] )
                                        city = EXACT #( columns[ 3 ] )
                                        state_code = EXACT #( columns[ 4 ] )

                                     ).

            IF row-seller_id IS INITIAL.
                RAISE EXCEPTION NEW zcx_ol_import(
                    reason = 'Invalid seller row'
                ).
            ENDIF.

            INSERT row INTO TABLE rows.

            IF sy-subrc <> 0.
                RAISE EXCEPTION NEW zcx_ol_import(
                    reason = 'Duplicate seller key in batch'
                ).
            ENDIF.
        ENDLOOP.

    MODIFY zol_seller FROM TABLE @rows.

    written = sy-dbcnt. " Stores the number of database rows affected by MODIFY (doesn't matter whether it' inserted or updated).

    assert_written(
        expected = lines( rows )
        actual = written
    ).
    ENDMETHOD.

    METHOD write_product.
        DATA rows TYPE SORTED TABLE OF zol_product WITH UNIQUE KEY product_id.

        LOOP AT lines INTO DATA(line).

            DATA(columns) = split_row(
                                        line = line
                                        expected_fields = 9
                                    ).
            DATA(row) = VALUE zol_product(
                                         product_id = EXACT #( columns[ 1 ] )
                                         category = EXACT #( columns[ 2 ] )
                                         name_length = EXACT #( columns[ 3 ] )
                                         descr_length = EXACT #( columns[ 4 ] )
                                         photos = EXACT #( columns[ 5 ] )
                                         weight_g = EXACT #( columns[ 6 ] )
                                         length_cm = EXACT #( columns[ 7 ] )
                                         height_cm = EXACT #( columns[ 8 ] )
                                         width_cm = EXACT #( columns[ 9 ] )

                                     ).

            IF row-product_id IS INITIAL.
                RAISE EXCEPTION NEW zcx_ol_import(
                    reason = 'Invalid product row'
                ).
            ENDIF.

            INSERT row INTO TABLE rows.

            IF sy-subrc <> 0.
                RAISE EXCEPTION NEW zcx_ol_import(
                    reason = 'Duplicate product key in batch'
                ).
            ENDIF.
        ENDLOOP.

    MODIFY zol_product FROM TABLE @rows.

    written = sy-dbcnt. " Stores the number of database rows affected by MODIFY (doesn't matter whether it' inserted or updated).

    assert_written(
        expected = lines( rows )
        actual = written
    ).
    ENDMETHOD.


    METHOD write_geo.
        DATA rows TYPE SORTED TABLE OF zol_geo WITH UNIQUE KEY zip_prefix state_code.

        LOOP AT lines INTO DATA(line).

            DATA(columns) = split_row(
                                        line = line
                                        expected_fields = 5
                                    ).
            DATA(row) = VALUE zol_geo(
                                         zip_prefix = EXACT #( columns[ 1 ] )
                                         state_code = EXACT #( columns[ 2 ] )
                                         latitude = EXACT #( columns[ 3 ] )
                                         longitude = EXACT #( columns[ 4 ] )
                                         point_count = EXACT #( columns[ 5 ] )


                                     ).

            IF row-zip_prefix IS INITIAL OR row-state_code IS INITIAL OR abs( row-latitude ) > 90 OR abs( row-longitude ) > 180 OR row-point_count < 1.
                RAISE EXCEPTION NEW zcx_ol_import(
                    reason = 'Invalid geo row'
                ).
            ENDIF.

            INSERT row INTO TABLE rows.

            IF sy-subrc <> 0.
                RAISE EXCEPTION NEW zcx_ol_import(
                    reason = 'Duplicate geo key in batch'
                ).
            ENDIF.
        ENDLOOP.

    MODIFY zol_geo FROM TABLE @rows.

    written = sy-dbcnt. " Stores the number of database rows affected by MODIFY (doesn't matter whether it' inserted or updated).

    assert_written(
        expected = lines( rows )
        actual = written
    ).
    ENDMETHOD.


    METHOD write_orders.
        DATA rows TYPE SORTED TABLE OF zol_ord WITH UNIQUE KEY order_id.

        LOOP AT lines INTO DATA(line).

            DATA(columns) = split_row(
                                        line = line
                                        expected_fields = 11
                                    ).
            DATA(row) = VALUE zol_ord(
                                         order_id = EXACT #( columns[ 1 ] )
                                         customer_id = EXACT #( columns[ 2 ] )
                                         order_status = EXACT #( columns[ 3 ] )
                                         purchase_at = EXACT #( columns[ 4 ] )
                                         approved_at = EXACT #( columns[ 5 ] )
                                         carrier_at = EXACT #( columns[ 6 ] )
                                         delivered_at = EXACT #( columns[ 7 ] )
                                         est_at = EXACT #( columns[ 8 ] )
                                         purchase_date = CONV #( columns[ 9 ] )
                                         delivered_date = CONV #( columns[ 10 ] )
                                         estimated_date = CONV #( columns[ 11 ] )
                                     ).

            IF row-order_id IS INITIAL OR row-customer_id IS INITIAL OR row-purchase_date IS INITIAL OR row-estimated_date IS INITIAL.
                RAISE EXCEPTION NEW zcx_ol_import(
                    reason = 'Invalid order row'
                ).
            ENDIF.

            INSERT row INTO TABLE rows.

            IF sy-subrc <> 0.
                RAISE EXCEPTION NEW zcx_ol_import(
                    reason = 'Duplicate order key in batch'
                ).
            ENDIF.
        ENDLOOP.

    MODIFY zol_ord FROM TABLE @rows.

    written = sy-dbcnt. " Stores the number of database rows affected by MODIFY (doesn't matter whether it' inserted or updated).

    assert_written(
        expected = lines( rows )
        actual = written
    ).
    ENDMETHOD.


    METHOD write_items.
        DATA rows TYPE SORTED TABLE OF zol_item WITH UNIQUE KEY order_id item_no.

        LOOP AT lines INTO DATA(line).

            DATA(columns) = split_row(
                                        line = line
                                        expected_fields = 8
                                    ).
            DATA(row) = VALUE zol_item(
                                         order_id = EXACT #( columns[ 1 ] )
                                         item_no = EXACT #( columns[ 2 ] )
                                         product_id = EXACT #( columns[ 3 ] )
                                         seller_id = EXACT #( columns[ 4 ] )
                                         shipping_limit = EXACT #( columns[ 5 ] )
                                         currency = EXACT #( columns[ 6 ] )
                                         price = EXACT #( columns[ 7 ] )
                                         freight = EXACT #( columns[ 8 ] )
                                     ).

            IF row-order_id IS INITIAL OR row-item_no < 1 OR row-product_id IS INITIAL OR row-seller_id IS INITIAL OR row-currency <> 'BRL' OR row-price < 0 OR row-freight < 0.
                RAISE EXCEPTION NEW zcx_ol_import(
                    reason = 'Invalid item row'
                ).
            ENDIF.

            INSERT row INTO TABLE rows.

            IF sy-subrc <> 0.
                RAISE EXCEPTION NEW zcx_ol_import(
                    reason = 'Duplicate item key in batch'
                ).
            ENDIF.
        ENDLOOP.

    MODIFY zol_item FROM TABLE @rows.

    written = sy-dbcnt. " Stores the number of database rows affected by MODIFY (doesn't matter whether it' inserted or updated).

    assert_written(
        expected = lines( rows )
        actual = written
    ).
    ENDMETHOD.

    METHOD write_payments.
        DATA rows TYPE SORTED TABLE OF zol_pay WITH UNIQUE KEY order_id payment_no.

        LOOP AT lines INTO DATA(line).

            DATA(columns) = split_row(
                                        line = line
                                        expected_fields = 6
                                    ).
            DATA(row) = VALUE zol_pay(
                                         order_id = EXACT #( columns[ 1 ] )
                                         payment_no = EXACT #( columns[ 2 ] )
                                         method = EXACT #( columns[ 3 ] )
                                         installments = EXACT #( columns[ 4 ] )
                                         currency = EXACT #( columns[ 5 ] )
                                         paid_value = EXACT #( columns[ 6 ] )
                                     ).

            IF row-order_id IS INITIAL OR row-payment_no < 1 OR row-method IS INITIAL OR row-installments < 0 OR row-currency <> 'BRL' OR row-paid_value < 0.
                RAISE EXCEPTION NEW zcx_ol_import(
                    reason = 'Invalid payment row'
                ).
            ENDIF.

            INSERT row INTO TABLE rows.

            IF sy-subrc <> 0.
                RAISE EXCEPTION NEW zcx_ol_import(
                    reason = 'Duplicate payment key in batch'
                ).
            ENDIF.
        ENDLOOP.

    MODIFY zol_pay FROM TABLE @rows.

    written = sy-dbcnt. " Stores the number of database rows affected by MODIFY (doesn't matter whether it' inserted or updated).

    assert_written(
        expected = lines( rows )
        actual = written
    ).
    ENDMETHOD.


    METHOD write_reviews.
        DATA rows TYPE SORTED TABLE OF zol_rev WITH UNIQUE KEY order_id review_id.

        LOOP AT lines INTO DATA(line).

            DATA(columns) = split_row(
                                        line = line
                                        expected_fields = 5
                                    ).
            DATA(row) = VALUE zol_rev(
                                         order_id = EXACT #( columns[ 1 ] )
                                         review_id = EXACT #( columns[ 2 ] )
                                         score = EXACT #( columns[ 3 ] )
                                         created_at = EXACT #( columns[ 4 ] )
                                         answered_at = EXACT #( columns[ 5 ] )
                                     ).

            IF row-order_id IS INITIAL OR row-review_id IS INITIAL OR row-score < 1 OR row-score > 5.
                RAISE EXCEPTION NEW zcx_ol_import(
                    reason = 'Invalid review row'
                ).
            ENDIF.

            INSERT row INTO TABLE rows.

            IF sy-subrc <> 0.
                RAISE EXCEPTION NEW zcx_ol_import(
                    reason = 'Duplicate review key in batch'
                ).
            ENDIF.
        ENDLOOP.

    MODIFY zol_rev FROM TABLE @rows.

    written = sy-dbcnt. " Stores the number of database rows affected by MODIFY (doesn't matter whether it' inserted or updated).

    assert_written(
        expected = lines( rows )
        actual = written
    ).
    ENDMETHOD.




ENDCLASS.
