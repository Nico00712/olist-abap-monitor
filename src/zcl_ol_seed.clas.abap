CLASS zcl_ol_seed DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.


CLASS zcl_ol_seed IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DATA total TYPE i.

    TRY.

        " Fill up every single Database Table
        " CATEGORY

        DATA category TYPE STANDARD TABLE OF zol_cat
          WITH EMPTY KEY.

        category = VALUE #(
          ( category_code    = 'casa'
            category_name_en = 'home' )

          ( category_code    = 'livros'
            category_name_en = 'books' )
        ).

        MODIFY zol_cat FROM TABLE @category.
        total += sy-dbcnt.


        " CUSTOMERS

        DATA customer TYPE STANDARD TABLE OF zol_cust
          WITH EMPTY KEY.

        customer = VALUE #(
          ( customer_id = 'C001'
            person_id   = 'U001'
            zip_prefix  = '01234'
            city        = 'São Clara'
            state_code  = 'SP' )

          ( customer_id = 'C002'
            person_id   = 'U002'
            zip_prefix  = '20000'
            city        = 'Rio Claro'
            state_code  = 'RJ' )

          ( customer_id = 'C003'
            person_id   = 'U003'
            zip_prefix  = '01234'
            city        = 'São Clara'
            state_code  = 'SP' )

          ( customer_id = 'C004'
            person_id   = 'U004'
            zip_prefix  = '77777'
            city        = 'Sem Mapa'
            state_code  = 'MG' )

          ( customer_id = 'C005'
            person_id   = 'U002'
            zip_prefix  = '01234'
            city        = 'Outra Cidade'
            state_code  = 'SP' )
        ).

        MODIFY zol_cust FROM TABLE @customer.
        total += sy-dbcnt.


        " SELLERS

        DATA seller TYPE STANDARD TABLE OF zol_seller
          WITH EMPTY KEY.

        seller = VALUE #(
          ( seller_id  = 'S001'
            zip_prefix = '01234'
            city       = 'São Clara'
            state_code = 'SP' )

          ( seller_id  = 'S002'
            zip_prefix = '20000'
            city       = 'Rio Claro'
            state_code = 'RJ' )
        ).

        MODIFY zol_seller FROM TABLE @seller.
        total += sy-dbcnt.


        " PRODUCTS

        DATA product TYPE STANDARD TABLE OF zol_product
          WITH EMPTY KEY.

        product = VALUE #(
          ( product_id   = 'P001'
            category     = 'casa'
            name_length  = 25
            descr_length = 42
            photos       = 1
            weight_g     = 102
            length_cm    = 10
            height_cm    = 5
            width_cm     = 12 )

          ( product_id   = 'P002'
            category     = 'livros'
            name_length  = 30
            descr_length = 60
            photos       = 2
            weight_g     = 500
            length_cm    = 20
            height_cm    = 18
            width_cm     = 10 )

          ( product_id   = 'P003'
            category     = 'sem_traducao'
            name_length  = 12
            descr_length = 42
            photos       = 1
            weight_g     = 105
            length_cm    = 11
            height_cm    = 5
            width_cm     = 13 )
        ).

        MODIFY zol_product FROM TABLE @product.
        total += sy-dbcnt.



        " GEOLOCATION

        DATA geo TYPE STANDARD TABLE OF zol_geo
          WITH EMPTY KEY.

        geo = VALUE #(
          ( zip_prefix  = '01234'
            state_code  = 'MG'
            latitude    = '-19.100000'
            longitude   = '-43.200000'
            point_count = 1 )

          ( zip_prefix  = '01234'
            state_code  = 'SP'
            latitude    = '-23.550000'
            longitude   = '-46.650000'
            point_count = 2 )

          ( zip_prefix  = '20000'
            state_code  = 'RJ'
            latitude    = '-22.900000'
            longitude   = '-43.200000'
            point_count = 1 )
        ).

        MODIFY zol_geo FROM TABLE @geo.
        total += sy-dbcnt.



        " ORDERS


        DATA orders TYPE STANDARD TABLE OF zol_ord
          WITH EMPTY KEY.

        orders = VALUE #(
          ( order_id       = 'O001'
            customer_id    = 'C001'
            order_status   = 'delivered'
            purchase_at    = '20180301120000'
            approved_at    = '20180301120000'
            carrier_at     = '20180302120000'
            delivered_at   = '20180308120000'
            est_at         = '20180305120000'
            purchase_date  = '20180301'
            delivered_date = '20180308'
            estimated_date = '20180305' )

          ( order_id       = 'O002'
            customer_id    = 'C002'
            order_status   = 'delivered'
            purchase_at    = '20180302120000'
            approved_at    = '20180302120000'
            carrier_at     = '20180303120000'
            delivered_at   = '20180304120000'
            est_at         = '20180305120000'
            purchase_date  = '20180302'
            delivered_date = '20180304'
            estimated_date = '20180305' )

          ( order_id       = 'O003'
            customer_id    = 'C003'
            order_status   = 'shipped'
            purchase_at    = '20180303120000'
            approved_at    = '20180303120000'
            carrier_at     = '20180304120000'
            est_at         = '20180309120000'
            purchase_date  = '20180303'
            delivered_date = '00000000'
            estimated_date = '20180309' )

          ( order_id       = 'O004'
            customer_id    = 'C004'
            order_status   = 'canceled'
            purchase_at    = '20180304120000'
            est_at         = '20180311120000'
            purchase_date  = '20180304'
            delivered_date = '00000000'
            estimated_date = '20180311' )

          ( order_id       = 'O005'
            customer_id    = 'C001'
            order_status   = 'delivered'
            purchase_at    = '20180305120000'
            approved_at    = '20180305120000'
            est_at         = '20180310120000'
            purchase_date  = '20180305'
            delivered_date = '00000000'
            estimated_date = '20180310' )

          ( order_id       = 'O006'
            customer_id    = 'C005'
            order_status   = 'delivered'
            purchase_at    = '20180306120000'
            approved_at    = '20180306120000'
            carrier_at     = '20180307120000'
            delivered_at   = '20180310120000'
            est_at         = '20180310120000'
            purchase_date  = '20180306'
            delivered_date = '20180310'
            estimated_date = '20180310' )
        ).

        MODIFY zol_ord FROM TABLE @orders.
        total += sy-dbcnt.


        " ORDER ITEMS

        DATA items TYPE STANDARD TABLE OF zol_item
          WITH EMPTY KEY.

        items = VALUE #(
          ( order_id       = 'O001'
            item_no        = 1
            product_id     = 'P001'
            seller_id      = 'S001'
            shipping_limit = '20180307120000'
            currency       = 'BRL'
            price          = '20.00'
            freight        = '5.00' )

          ( order_id       = 'O001'
            item_no        = 2
            product_id     = 'P002'
            seller_id      = 'S001'
            shipping_limit = '20180307120000'
            currency       = 'BRL'
            price          = '40.00'
            freight        = '10.00' )

          ( order_id       = 'O001'
            item_no        = 3
            product_id     = 'P003'
            seller_id      = 'S002'
            shipping_limit = '20180307120000'
            currency       = 'BRL'
            price          = '60.00'
            freight        = '15.00' )

          ( order_id       = 'O002'
            item_no        = 1
            product_id     = 'P003'
            seller_id      = 'S002'
            shipping_limit = '20180307120000'
            currency       = 'BRL'
            price          = '60.00'
            freight        = '10.00' )

          ( order_id       = 'O003'
            item_no        = 1
            product_id     = 'P001'
            seller_id      = 'S001'
            shipping_limit = '20180307120000'
            currency       = 'BRL'
            price          = '10.00'
            freight        = '2.00' )

          ( order_id       = 'O005'
            item_no        = 1
            product_id     = 'P001'
            seller_id      = 'S002'
            shipping_limit = '20180307120000'
            currency       = 'BRL'
            price          = '40.00'
            freight        = '8.00' )

          ( order_id       = 'O006'
            item_no        = 1
            product_id     = 'P002'
            seller_id      = 'S001'
            shipping_limit = '20180307120000'
            currency       = 'BRL'
            price          = '25.00'
            freight        = '5.00' )
        ).

        MODIFY zol_item FROM TABLE @items.
        total += sy-dbcnt.


        " 8. PAYMENTS

        DATA payments TYPE STANDARD TABLE OF zol_pay WITH EMPTY KEY.

        payments = VALUE #(
          ( order_id     = 'O001'
            payment_no   = 1
            method       = 'credit_card'
            installments = 2
            currency     = 'BRL'
            paid_value   = '100.00' )

          ( order_id     = 'O001'
            payment_no   = 2
            method       = 'voucher'
            installments = 1
            currency     = 'BRL'
            paid_value   = '50.00' )

          ( order_id     = 'O002'
            payment_no   = 1
            method       = 'boleto'
            installments = 1
            currency     = 'BRL'
            paid_value   = '70.00' )

          ( order_id     = 'O003'
            payment_no   = 1
            method       = 'credit_card'
            installments = 1
            currency     = 'BRL'
            paid_value   = '12.00' )

          ( order_id     = 'O005'
            payment_no   = 1
            method       = 'credit_card'
            installments = 1
            currency     = 'BRL'
            paid_value   = '48.00' )

          ( order_id     = 'O006'
            payment_no   = 1
            method       = 'credit_card'
            installments = 1
            currency     = 'BRL'
            paid_value   = '30.00' )
        ).

        MODIFY zol_pay FROM TABLE @payments.
        total += sy-dbcnt.


        " 9. REVIEWS

        DATA reviews TYPE STANDARD TABLE OF zol_rev
          WITH EMPTY KEY.

        reviews = VALUE #(
          ( order_id    = 'O001'
            review_id   = 'R001'
            score       = 1
            created_at  = '20180311120000'
            answered_at = '20180312120000' )

          ( order_id    = 'O001'
            review_id   = 'R002'
            score       = 3
            created_at  = '20180311120000'
            answered_at = '20180312120000' )

          ( order_id    = 'O002'
            review_id   = 'R003'
            score       = 5
            created_at  = '20180311120000'
            answered_at = '20180312120000' )

          ( order_id    = 'O006'
            review_id   = 'R003'
            score       = 4
            created_at  = '20180311120000'
            answered_at = '20180312120000' )
        ).

        MODIFY zol_rev FROM TABLE @reviews.
        total += sy-dbcnt.



        " COMMIT DATABASE CHANGES
        COMMIT WORK.

        out->write( |Committed { total } synthetic rows| ).


      CATCH cx_sy_open_sql_db INTO DATA(lx_db).

        ROLLBACK WORK.

        out->write( lx_db->get_text( ) ).

    ENDTRY.

  ENDMETHOD.

ENDCLASS.
