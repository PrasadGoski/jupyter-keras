Modified



set timing on;
set serveroutput on;
spool alt_name_not_in_profile.lst;
DECLARE
--
cursor cur_c1(c_COID VARCHAR2) is 
    select a.regcode, a.ccode, a.ssn, a.filen, a.active_name, a.user_id, b.last_access 
    from voi_admin.T_IPAY_USER a, VOI_ADMIN.T_IPAY_ACCESS b 
    where a.idnkey = b.idnkey and a.COID = c_COID;
--
cursor cur_c2(c_regcode NUMBER, c_ccode VARCHAR2, c_ssn VARCHAR2, c_name VARCHAR2, c_user_id VARCHAR2)  is 
        select distinct upper(EFFECTIVE_NAME) as alt_name_not_in_profile from colddba.X_TBINDPVOIECV120100 
        where REGCODE = c_regcode and CCODE = c_ccode and ssn = c_ssn and upper(effective_name) != upper(c_name)
        MINUS
        select upper(ALIAS_NAME) as alt_name_not_in_profile from voi_admin.IPAY_ALIAS_NAMES where USER_ID = c_user_id and ssn = c_ssn;
BEGIN
    DBMS_OUTPUT.PUT_LINE('regcode,ccode,ssn,active_name,user_id,last_access');
    FOR c1 IN cur_c1('03FYXZYA2AX0097V')    
    LOOP
        DBMS_OUTPUT.PUT_LINE(c1.regcode || ',' || c1.ccode || ',' || c1.ssn || ',' || c1.active_name || ',' || 
        c1.user_id || ',' || c1.filen || ',' || c1.last_access);
        FOR c2 IN cur_c2(c1.regcode, c1.ccode, c1.ssn, c1.active_name, c1.user_id)    
        LOOP
              DBMS_OUTPUT.PUT_LINE('Alternate Name not in Profile:' || c2.alt_name_not_in_profile);
        END LOOP;
    END LOOP;
END;
/
spool off;


/*
select * from dba_tab_columns where column_name = 'REGCODE';

select distinct ORIGIN_NAME, EFFECTIVE_NAME from colddba.X_TBINDPVOIECV120100@pvc where SSN = '417421976';
select * from voi_admin.IPAY_ALIAS_NAMES@pvc where SSN = '417421976';
select * from voi_admin.T_IPAY_USER@pvc where SSN = '417421976';


WITH NON_USED_NAMES as (
select distinct SSN, EFFECTIVE_NAME as NAME from colddba.X_TBINDPVOIECV120100 where SSN = '100000001'
MINUS
select SSN, ALIAS_NAME as NAME from voi_admin.IPAY_ALIAS_NAMES where SSN = '100000001'
MINUS
select SSN, ACTIVE_NAME as NAME from voi_admin.T_IPAY_USER where SSN = '100000001'
)
select B.REGCODE, B.CCODE, B.SSN, B.FILEN, B.AOID, B.COID, B.USER_ID, B.ACTIVE_NAME as PROFILE_NAME, A.NAME as NOTUSED_ALT_NAMES from NON_USED_NAMES a, voi_admin.T_IPAY_USER b where a.ssn = b.ssn and b.SSN = '100000001'


WITH NON_USED_NAMES as (
select distinct SSN, EFFECTIVE_NAME as NAME from colddba.X_TBINDPVOIECV120100 where SSN = '100000001'
MINUS
select SSN, ALIAS_NAME as NAME from voi_admin.IPAY_ALIAS_NAMES where SSN = '100000001'
MINUS
select SSN, ACTIVE_NAME as NAME from voi_admin.T_IPAY_USER where SSN = '100000001'
)
select B.REGCODE, B.CCODE, B.SSN, B.FILEN, B.AOID, B.COID, B.USER_ID, B.ACTIVE_NAME as PROFILE_NAME, A.NAME as NOTUSED_ALT_NAMES 
from NON_USED_NAMES a, voi_admin.T_IPAY_USER b where a.ssn = b.ssn and b.COID = '100000001'


WITH NON_USED_NAMES as (
select distinct SSN, EFFECTIVE_NAME as NAME from colddba.X_TBINDPVOIECV120100 where SSN = '100000001'
MINUS
select SSN, ALIAS_NAME as NAME from voi_admin.IPAY_ALIAS_NAMES where SSN = '100000001'
MINUS
select SSN, ACTIVE_NAME as NAME from voi_admin.T_IPAY_USER where SSN = '100000001'
)
select B.REGCODE, B.CCODE, B.SSN, B.FILEN, B.AOID, B.COID, B.USER_ID, B.ACTIVE_NAME as PROFILE_NAME, A.NAME as NOTUSED_ALT_NAMES 
from NON_USED_NAMES a, voi_admin.T_IPAY_USER b where a.ssn = b.ssn and b.COID = '100000001'



select * from voi_admin.T_IPAY_USER where COID = '03FYXZYA2AX0097V';
    select a.regcode, a.ccode, a.ssn, a.filen, a.active_name, a.user_id, b.last_access 
    from voi_admin.T_IPAY_USER a, VOI_ADMIN.T_IPAY_ACCESS b 
    where a.idnkey = b.idnkey and a.COID = '03FYXZYA2AX0097V';






edit 
edit colddba.X_TBINDPVOIECV120100 where ssn = 000000000

select * from dba_data

select a.User_id,b.ssn,b.effective_name,b.FILEN,b.ccode,b.REGCODE from X_TBINDPVOIECV120100 b, t_ipay_user a  
where a.ssn=b.ssn and a.active_name!=b.effective_name and a.ccode in ('PCSDEJ', 'W7E') and a.REGCODE=191 and b.ccode in ('PCSDEJ', 'W7E') and b.REGCODE=191
and effective_name not in (select alias_name from VOI_ADMIN.IPAY_ALIAS_NAMES where ssn=a.ssn);

select a.User_id,b.ssn,b.effective_name,b.FILEN,b.ccode,b.REGCODE from X_TBINDVOIW2200100 b, t_ipay_user a  
where a.ssn=b.ssn and a.active_name!=b.effective_name and a.ccode in ('PCSDEJ', 'W7E') and a.REGCODE=191 and b.ccode in ('PCSDEJ', 'W7E') and b.REGCODE=191
and effective_name not in (select alias_name from VOI_ADMIN.IPAY_ALIAS_NAMES where ssn=a.ssn);

select a.User_id,b.ssn,b.effective_name,b.FILEN,b.ccode,b.REGCODE from X_TBINDVOI1099200100 b, t_ipay_user a  
where a.ssn=b.ssn and a.active_name!=b.effective_name and a.ccode in ('PCSDEJ', 'W7E') and a.REGCODE=191 and b.ccode in ('PCSDEJ', 'W7E') and b.REGCODE=191
and effective_name not in (select alias_name from VOI_ADMIN.IPAY_ALIAS_NAMES where ssn=a.ssn);



--

select a.User_id,b.ssn,b.effective_name,b.FILEN,b.ccode,b.REGCODE from X_TBINDVOIW2200100 b, t_ipay_user a  
where a.ssn=b.ssn and a.active_name!=b.effective_name and a.ccode='W7E'and a.REGCODE=191 and b.ccode='W7E' and b.REGCODE=191
and effective_name not in (select alias_name from VOI_ADMIN.IPAY_ALIAS_NAMES where ssn=a.ssn);




select a.User_id,b.ssn,b.effective_name,b.FILEN,b.ccode,b.REGCODE from X_TBINDPVOIECV120100 b, t_ipay_user a  
where a.ssn=b.ssn and a.active_name!=b.effective_name and a.ccode='PCSDEJ'and a.REGCODE=191 and b.ccode='PCSDEJ' and b.REGCODE=191
and effective_name not in (select alias_name from VOI_ADMIN.IPAY_ALIAS_NAMES where ssn=a.ssn);

select a.User_id,b.ssn,b.effective_name,b.FILEN,b.ccode,b.REGCODE from X_TBINDPVOIECV120100 b, t_ipay_user a  
where a.ssn=b.ssn and a.active_name!=b.effective_name and a.ccode='W7E'and a.REGCODE=191 and b.ccode='PCSDEJ' and b.REGCODE=191
and effective_name not in (select alias_name from VOI_ADMIN.IPAY_ALIAS_NAMES where ssn=a.ssn);


select a.User_id,b.ssn,b.effective_name,b.FILEN,b.ccode,b.REGCODE from X_TBINDVOI1099200100 b, t_ipay_user a  
where a.ssn=b.ssn and a.active_name!=b.effective_name and a.ccode='W7E'and a.REGCODE=191 and b.ccode='W7E' and b.REGCODE=191
and effective_name not in (select alias_name from VOI_ADMIN.IPAY_ALIAS_NAMES where ssn=a.ssn);

select a.User_id,b.ssn,b.effective_name,b.FILEN,b.ccode,b.REGCODE from X_TBINDVOIW2200100 b, t_ipay_user a  
where a.ssn=b.ssn and a.active_name!=b.effective_name and a.ccode='W7E'and a.REGCODE=191 and b.ccode='W7E' and b.REGCODE=191
and effective_name not in (select alias_name from VOI_ADMIN.IPAY_ALIAS_NAMES where ssn=a.ssn);




select * from X_TBINDVOI1099200100@pdc where ccode = 'W7E';

select a.User_id,b.ssn,b.effective_name,b.FILEN,b.ccode,b.REGCODE from X_TBINDPVOIECV120100 b, t_ipay_user a  
where a.ssn=b.ssn and a.active_name!=b.effective_name and a.ccode='PCSDEJ'and a.REGCODE=191 and b.ccode='PCSDEJ' and b.REGCODE=191
and effective_name not in (select alias_name from VOI_ADMIN.IPAY_ALIAS_NAMES where ssn=a.ssn);

select a.User_id,b.ssn,b.effective_name,b.FILEN,b.ccode,b.REGCODE from X_TBINDVOI1099200100 b, t_ipay_user a  
where a.ssn=b.ssn and a.active_name!=b.effective_name and a.ccode='PCSDEJ'and a.REGCODE=191 and b.ccode='PCSDEJ' and b.REGCODE=191
and effective_name not in (select alias_name from VOI_ADMIN.IPAY_ALIAS_NAMES where ssn=a.ssn);

select a.User_id,b.ssn,b.effective_name,b.FILEN,b.ccode,b.REGCODE from X_TBINDVOIW2200100 b, t_ipay_user a  
where a.ssn=b.ssn and a.active_name!=b.effective_name and a.ccode='PCSDEJ'and a.REGCODE=191 and b.ccode='PCSDEJ' and b.REGCODE=191
and effective_name not in (select alias_name from VOI_ADMIN.IPAY_ALIAS_NAMES where ssn=a.ssn);





select a.User_id,b.ssn,b.ORIGIN_NAME,b.FILEN,b.ccode,b.REGCODE from X_TBINDVOI1099200100 b, t_ipay_user a  where a.ssn=b.ssn 
and a.active_name!=b.ORIGIN_NAME and CLIENT_OID='03FYXZYA2AX0097V' and a.ccode='PCSDEJ' and a.REGCODE=191 and ORIGIN_NAME not in (select alias_name from VOI_ADMIN.IPAY_ALIAS_NAMES);

 select a.User_id,b.ssn,b.ORIGIN_NAME,b.FILEN,b.ccode,b.REGCODE from X_TBINDVOIW2200100 b, t_ipay_user a  where a.ssn=b.ssn 
and a.active_name!=b.ORIGIN_NAME and CLIENT_OID='03FYXZYA2AX0097V' and a.ccode='PCSDEJ' and a.REGCODE=191 and ORIGIN_NAME not in (select alias_name from VOI_ADMIN.IPAY_ALIAS_NAMES);







select count(*) from
(
select a.User_id,b.ssn,b.effective_name,b.FILEN,b.ccode,b.REGCODE from X_TBINDVOI1099200100 b, t_ipay_user a  
where a.ssn=b.ssn and a.active_name!=b.effective_name and a.ccode='PCSDEJ'and a.REGCODE=191 and b.ccode='PCSDEJ' and b.REGCODE=191
and effective_name not in (select alias_name from VOI_ADMIN.IPAY_ALIAS_NAMES where ssn=a.ssn)
)
;



select count(*) from
(
select a.User_id,b.ssn,b.effective_name,b.FILEN,b.ccode,b.REGCODE from X_TBINDVOIW2200100 b, t_ipay_user a  
where a.ssn=b.ssn and a.active_name!=b.effective_name and a.ccode='PCSDEJ'and a.REGCODE=191 and b.ccode='PCSDEJ' and b.REGCODE=191
and effective_name not in (select alias_name from VOI_ADMIN.IPAY_ALIAS_NAMES where ssn=a.ssn)
)
;


select count(*) from
(
select a.User_id,b.ssn,b.effective_name,b.FILEN,b.ccode,b.REGCODE from X_TBINDPVOIECV120100 b, t_ipay_user a  
where a.ssn=b.ssn and a.active_name!=b.effective_name and a.ccode='PCSDEJ'and a.REGCODE=191 and b.ccode='PCSDEJ' and b.REGCODE=191
and effective_name not in (select alias_name from VOI_ADMIN.IPAY_ALIAS_NAMES where ssn=a.ssn)
)
;
*/
