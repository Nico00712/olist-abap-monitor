CLASS zcx_ol_import DEFINITION
  PUBLIC
  FINAL
  INHERITING FROM cx_static_check

  CREATE PUBLIC .

  PUBLIC SECTION.

    DATA reason TYPE string READ-ONLY. " Readable description of what went wrong

    METHODS constructor
        IMPORTING
            previous LIKE previous OPTIONAL " Allows exception chaining, which could come in handy when wanting to preserve the original cause of an error.
            reason TYPE string OPTIONAL.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcx_ol_import IMPLEMENTATION.

  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    super->constructor(
        previous = previous
    ).

    me->reason = reason.

  ENDMETHOD.
ENDCLASS.
