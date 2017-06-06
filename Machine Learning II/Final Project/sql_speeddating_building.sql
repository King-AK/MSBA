CREATE TABLE female AS SELECT * FROM speeddating_scaled_pure where gender=0;
CREATE TABLE male AS SELECT * FROM speeddating_scaled_pure where gender=1;
SELECT * FROM speeddating.female;
ALTER TABLE female DROP COLUMN p_age
,DROP COLUMN p_call
,DROP COLUMN p_dec
,DROP COLUMN p_met_before
,DROP COLUMN p_pref_amb
,DROP COLUMN p_pref_attr
,DROP COLUMN p_pref_fun
,DROP COLUMN p_pref_intel
,DROP COLUMN p_pref_shar
,DROP COLUMN p_pref_sinc
,DROP COLUMN p_race
,DROP COLUMN p_rate_i_amb
,DROP COLUMN p_rate_i_attr
,DROP COLUMN p_rate_i_fun
,DROP COLUMN p_rate_i_intel
,DROP COLUMN p_rate_i_like
,DROP COLUMN p_rate_i_shar
,DROP COLUMN p_rate_i_sinc
,DROP COLUMN p_rate_prob;
select * from female join male on (female.pid = male.iid and male.pid = female.iid);