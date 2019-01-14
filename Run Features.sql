Feature 1:
set serveroutput on;
--Valid case
exec check_acc(accid_seq.nextval,'Kaushik','kv1@umbc.edu','1010 ChapelSq',987,'abc123');
--Invalid case
exec check_acc(accid_seq.nextval,'Kaushik','kv1@umbc.edu','1010 ChapelSq',987,'abc123');

Feature 2:
--Valid case
SET SERVEROUT ON;
DECLARE
flag1 number;
BEGIN
    flag1 := user_login('sushrut1@umbc.edu', 'Sushrut9');
    --dbms_output.put_line(flag1);
    if flag1 = 1 then
        dbms_output.put_line('Login Successful');
    else
        dbms_output.put_line('User cannot login');
    end if;
END;

--Invalid case
SET SERVEROUT ON;
DECLARE
flag1 number;
BEGIN
    flag1 := user_login('sushrut1@gmail.com', 'Sushrut');
    --dbms_output.put_line(flag1);
    if flag1 = 1 then
        dbms_output.put_line('Login Successful');
    else
        dbms_output.put_line('User cannot login');
    end if;
END;


Feature 3:

set serveroutput on;
--Valid case 1
exec read_msg(101 ,timestamp '2018-07-01 06:00:30.750000000');
--Valid case 2
exec read_msg(103 ,timestamp '2018-07-01 07:35:30.750000000');
--Invalid case
exec read_msg(103 ,timestamp '2018-07-01 10:35:30.750000000');

Feature 4:

--Valid Case
exec add_vehicle(101,'2CD4512','AD','1018 Howland SQ Westland Gardens',2);
-- Invalid Case where licenseplate and State is same
exec add_vehicle(101,'1AB123','TN','7367 South Buttonwood Ave. Cookeville, TN 38501',1);

--Valid Case
exec delete_vehicle(101,'2CD4512','AD');
--Invalid Case
exec delete_vehicle(101,'2CD45121','AD');

Feature 5:

--Valid Scenario
exec add_transponder(211,104);
--Exception
set serveroutput on;
exec add_transponder(201,104);

--Invalid Condition
set serveroutput on;
exec delete_transponder(214,102);

--Valid Condition
set serveroutput on;
exec delete_transponder(220,104);

Feature 6:

--1st scenario:

set serveroutput on;
declare
op_account_id account.acc_id%type;
op_status int;
op_vehicle vehicle.vehicle_id%type;
begin
MATCHACCOUNT(201,'1AB123','TN',op_account_id,op_status,op_vehicle);
end;
/

--2nd scenario:

set serveroutput on;
declare
op_account_id account.acc_id%type;
op_status int;
op_vehicle vehicle.vehicle_id%type;
begin
MATCHACCOUNT(null,'1AB123','TN',op_account_id,op_status,op_vehicle);
end;
/
--3rd Scenario
set serveroutput on;
declare
op_account_id account.acc_id%type;
op_status int;
op_vehicle vehicle.vehicle_id%type;
begin
MATCHACCOUNT(null,'1AD123','TN',op_account_id,op_status,op_vehicle);
end;
/

Feature 7:

-- Case for Car
exec Compute_trip_toll(202,'2CD456','CT',403,95,110,timestamp  '2018-7-10 07:00:30.75 -5:00');
-- Case for Truck
exec Compute_trip_toll(203,'3EF789','IA',402,80,90,timestamp  '2018-7-12 05:00:30.75 -5:00');

Feature 8:


set serveroutput on;
exec DEDUCTTOLL(601);

For insufficient Balance
set serveroutput on;
exec DEDUCTTOLL(602);

For Sufficient Balance
set serveroutput on;
exec DEDUCTTOLL(604);


--For Status =3
set serveroutput on;
exec DEDUCTTOLL(608);

Feature 9:

--Valid Condition

set SERVEROUTPUT ON;
exec add_payment(123,103,date'2018-11-12',200);

--Invalid Condition
set SERVEROUTPUT ON;
exec add_payment(123,163,date'2018-11-12',200);

Feature 10:

--Valid Condition
set serveroutput on;
exec change_status(702, 2);

--Invalid Condition
set serveroutput on;
exec change_status(787, 2);

Feature 11:

set serveroutput on;
exec trip_payment_detail(105 ,to_timestamp('01-JUL-18 07.00.30.750000000 AM'),to_timestamp('01-JUL-18 07.10.30.750000000 AM'));
--exec trip_payment_detail(101 ,to_timestamp('01-JUL-18 06.00.30.750000000 AM'),to_timestamp('01-JUL-18 07.10.30.750000000 AM'));
--exec trip_payment_detail(100 ,to_timestamp('01-JUL-18 06.00.30.750000000 AM'),to_timestamp('01-JUL-18 07.10.30.750000000 AM'));

Feature 12:

set serveroutput on;
exec monthly_statement(105 ,to_timestamp('01-JUL-18 07.00.30.750000000 AM'),to_timestamp('01-JUL-18 07.10.30.750000000 AM'));
--exec trip_payment_detail(101 ,to_timestamp('01-JUL-18 06.00.30.750000000 AM'),to_timestamp('01-JUL-18 07.10.30.750000000 AM'));
--exec trip_payment_detail(100 ,to_timestamp('01-JUL-18 06.00.30.750000000 AM'),to_timestamp('01-JUL-18 07.10.30.750000000 AM'));

Feature 13:

-- Valid Case
exec road_details(date '2018-06-01',date '2018-07-20');
-- Invalid Case
exec road_details(date '2028-06-01',date '2028-07-20');

Feature 14:

set serveroutput on;
-- Valid case 
exec number_of_trips(date '2018-06-21',date '2018-07-10',401);
-- Invalid RoadID case
exec number_of_trips(date '2018-04-01',date '2020-10-01',41);

Feature 15:

-- Valid case
set serveroutput on;
exec stat_mosttoll(date '2018-06-30',date '2018-07-30',2);

Feature 16:

--Valid
set serveroutput on;
exec travel_vehicle(timestamp  '2018-7-01 05:00:30.75 -5:00',timestamp  '2018-7-20 05:30:30.75 -5:00');
/
--InValid Condition
set serveroutput on;
exec travel_vehicle(timestamp  '2018-7-20 05:00:30.75 -5:00',timestamp  '2018-7-20 05:30:30.75 -5:00');
