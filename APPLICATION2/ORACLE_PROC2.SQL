create or replace PROCEDURE ORACLE_PROC2(end_date IN VARCHAR,
                                                      period   IN NUMBER)
AS
BEGIN
    IF frequency = 'WEEKLY' THEN
      merge /*+ parallel(MONTHLY_TABLE,10) append */
      INTO WEEKLY_TABLE tgt
      USING (SELECT vendor_id,
                    TO_DATE(End_date, 'yyyy-mm-dd') AS max_date
             FROM   VENDOR_INFO_REF
             GROUP  BY vendor_id) src
      ON ( Src.vendor_id = tgt.vendor_id )
      WHEN matched THEN
        UPDATE SET tgt.Enddate = (CASE WHEN tgt.enddate > src.max_date THEN tgt.enddate ELSE src.max_date END)
      WHEN NOT matched THEN
        INSERT ( tgt.vendor_id,
                 tgt.Enddate )
        VALUES ( Src.vendor_id,
                 Src.max_date );
    END IF;

    COMMIT;
END ORACLE_PROC2;  
