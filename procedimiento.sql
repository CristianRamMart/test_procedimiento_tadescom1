CREATE OR REPLACE procedure public.ds_reports_companies_credit_debit()
LANGUAGE plpgsql
AS $$
	BEGIN
	TRUNCATE TABLE bi.temp_companies_debit;
	INSERT INTO bi.temp_companies_debit
	SELECT ci.company_id from conekta.companies_information_dimension ci;
	UPDATE bi.temp_companies_debit
	SET tarjeta = 'debit';
	TRUNCATE TABLE bi.temp_companies_credit;
	INSERT INTO bi.temp_companies_credit
	SELECT ci.company_id from conekta.companies_information_dimension ci;
	UPDATE bi.temp_companies_credit
	SET tarjeta = 'credit';
	CREATE TABLE IF NOT EXISTS bi.temp_companies_cardtype
	(
		company_id VARCHAR(40)   ENCODE lzo
		,Tarjeta VARCHAR(20)   ENCODE lzo
	)
	DISTSTYLE AUTO;
	TRUNCATE TABLE bi.temp_companies_cardtype;
	insert into bi.temp_companies_cardtype (company_id, Tarjeta)
	(select * from bi.temp_companies_debit d
	union 
	select * from bi.temp_companies_credit c 
	order by company_id);
	END;

$$
;