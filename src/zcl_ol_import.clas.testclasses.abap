*"* use this source file for your ABAP unit test classes
CLASS ltc_import DEFINITION FINAL
    FOR TESTING
    DURATION SHORT
    RISK LEVEL HARMLESS.

    PRIVATE SECTION.
        METHODS unknown_dataset FOR TESTING.
        METHODS wrong_field_count FOR TESTING.
        METHODS duplicate_category FOR TESTING.
        METHODS empty_payload FOR TESTING.

ENDCLASS.

CLASS ltc_import IMPLEMENTATION.

    METHOD unknown_dataset.
        TRY.
            zcl_ol_import=>upsert(
                kind = 'unknown'
                payload = 'test'
            ).

            cl_abap_unit_assert=>fail(
                msg = 'Expected unknown dataset exception'
            ).

        CATCH zcx_ol_import INTO DATA(lx_error).

            cl_abap_unit_assert=>assert_equals(
                exp = 'Unknown dataset: unknown'
                act = lx_error->reason
            ).
        ENDTRY.
    ENDMETHOD.

    METHOD wrong_field_count.
        TRY.
            zcl_ol_import=>upsert(
                kind = 'category'
                payload = 'only_one_column'
            ).

            cl_abap_unit_assert=>fail(
                msg = 'Expected field count exception'
            ).

        CATCH zcx_ol_import INTO DATA(lx_error).
            cl_abap_unit_assert=>assert_equals(
                exp = 'Wrong number of columns'
                act = lx_error->reason
            ).
        ENDTRY.
    ENDMETHOD.

    METHOD duplicate_category.
        DATA(tab) = cl_abap_char_utilities=>horizontal_tab.
        DATA(nl) = cl_abap_char_utilities=>newline.

        DATA(payload) = |electronics { tab } Electronics { nl }| && |electronics { tab } Electronics|.

        TRY.
            zcl_ol_import=>upsert(
                kind = 'category'
                payload = payload
            ).
            cl_abap_unit_assert=>fail(
                msg = 'Expected duplicate key exception'
            ).
        CATCH zcx_ol_import INTO DATA(lx_error).

            cl_abap_unit_assert=>assert_equals(
                exp = 'Duplicate category key in batch'
                act = lx_error->reason
            ).
       ENDTRY.
    ENDMETHOD.

    METHOD empty_payload.
        TRY.
            zcl_ol_import=>upsert(
                kind = 'category'
                payload = ''
            ).

            cl_abap_unit_assert=>fail(
                msg = 'Expected invalid size exception'
            ).

        CATCH zcx_ol_import INTO DATA(lx_error).

            cl_abap_unit_assert=>assert_equals(
                exp = 'Invalid size'
                act = lx_error->reason
            ).
        ENDTRY.

    ENDMETHOD.

ENDCLASS.


