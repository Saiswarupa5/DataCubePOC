create or replace PROCEDURE SAMPLE3(end_date IN VARCHAR,
                                                      period   IN NUMBER)
AS
BEGIN
    IF frequency = 'DAILY' THEN
      merge /*+ parallel(DAILY_TABLE,10) append */
      INTO DAILY_TABLE tgt
      USING (SELECT vendor_id,
                    TO_DATE(End_date, 'yyyy-mm-dd') AS max_date
             FROM   VENDOR_ID_REF
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
END SAMPLE3;  
