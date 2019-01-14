---------------------------------------------FEATURES FOR TOLL MANAGEMENT SYSTEM-----------------------------------------------------------------

--FEATURE 1
--Description: Create a user account and display a message if the user already exists.

Create or replace procedure check_acc(account_id in number, a_name in VARCHAR2, e_mail in VARCHAR2, addr in VARCHAR2, bal number, pswd in VARCHAR2)
IS
flag NUMBER;
Begin
    select count(*) into flag
    from  account where email = e_mail;
    if flag > 0 then
dbms_output.put_line('User already exists');        
else
    insert into account values (account_id, a_name, e_mail, addr, bal, pswd);
    dbms_output.put_line('User created');
    end if;
End;
/
set serveroutput on;
--Valid
exec check_acc(accid_seq.nextval,'Kaushik','kv1@umbc.edu','1010 ChapelSq',987,'abc123');
--Invalid Case
exec check_acc(accid_seq.nextval,'Kaushik','kv1@umbc.edu','1010 ChapelSq',987,'abc123');

------------------------------------------------------------------------------------------------------------------------------------------------

--FEATURE 2
--Description: Allow a user to login by providing email and password.

create or replace function user_login(e_mail in VARCHAR2,pswd in VARCHAR2)
return VARCHAR2
IS
flag number;
BEGIN
    select count(*) into flag
    from  account where email = e_mail and password = pswd;
    return flag;
    if flag > 0 then
        return 1;
    else
        return 0;
    end if;
END;
/
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
-------------------------------------------------------------------------------------------------------------------------------------------------
--FEATURE 3
--Description: Allows a user to read messages providing account id and starting date.

create or replace procedure read_msg(account_id in number, msg_time in timestamp)
IS
body1 message.body%type;
BEGIN
    select body into body1 from message where acc_id = account_id and message_time = msg_time;
    dbms_output.put_line('Message: '|| body1);
    EXCEPTION
    WHEN no_data_found THEN
        dbms_output.put_line('No messages for account id '||account_id||' and time '||msg_time);
END;
/
set serveroutput on;
--Valid case 1
exec read_msg(101 ,timestamp '2018-07-01 06:00:30.750000000');
--Valid case 2
exec read_msg(103 ,timestamp '2018-07-01 07:35:30.750000000');
--Invalid case
exec read_msg(103 ,timestamp '2018-07-01 10:35:30.750000000');

------------------------------------------------------------------------------------------------------------------------------------------------
--FEATURE 4

--Description: Add Vehicle of a user to the Vehicle Table
--Input: account_id,license,state,address,class

create or replace procedure add_vehicle(account_id in number,license in varchar2,state in varchar2,address in varchar2,class1 in number)
IS
temp int;
Begin
SELECT count(*) into temp FROM vehicle where license = vehicle.license_plate_no and state = vehicle.state;
if temp = 1 then
    dbms_output.put_line('A vehicle already exists with same license plate number');
    update vehicle set class = class1,address_owner = address
    where account_id = acc_id;
else
    insert into vehicle(vehicle_id,acc_id,license_plate_no,state,address_owner,class) values(vehicle_id_seq.nextval,account_id,license,state,address,class1);
    dbms_output.put_line('The vehicle is inserted into the table');
    insert into message(message_id,acc_id,message_time,body) values(message_id_seq.nextval,account_id,systimestamp,'The Vehicle has been added to the account ');
end if;

Exception
when no_data_found then
    dbms_output.put_line('No data');

End;
/


--Valid Case
exec add_vehicle(101,'2CD4512','AD','1018 Howland SQ Westland Gardens',2);
-- Invalid Case where licenseplate and State is same
exec add_vehicle(101,'1AB123','TN','7367 South Buttonwood Ave. Cookeville, TN 38501',1);

-- Delete a vehicle from the vehicle table
-- Input : account_id,licenseplate,vehiclestate
create or replace procedure delete_vehicle(account_id in number,licenseplate in varchar2,vehiclestate in varchar2)
IS
temp int;
temp1 int;
temp2 int;
Begin
select count(*) into temp2 from vehicle where licenseplate = license_plate_no and vehiclestate = state;
if temp2 = 0 then
    dbms_output.put_line('Vehicle Not Found');
else
    select count(*) into temp1 from vehicle where account_id = acc_id;
    if temp1 > 0 then
        SELECT count(*) into temp FROM vehicle where licenseplate = vehicle.license_plate_no and vehiclestate = vehicle.state;
        if temp = 1 then
        delete from vehicle where licenseplate = vehicle.license_plate_no and vehiclestate = vehicle.state;
        commit;
        dbms_output.put_line('The vehicle has been deleted');
        insert into message(message_id,acc_id,message_time,body) values(message_id_seq.nextval,account_id,systimestamp,'Vehicle has been deleted');
        end if;
        else
        dbms_output.put_line ('Account number is invalid');
    end if;
end if;
Exception
when no_data_found then
    dbms_output.put_line('No data');
End;
/

--Valid Case
exec delete_vehicle(101,'2CD4512','AD');
--Invalid Case
exec delete_vehicle(101,'2CD45121','AD');

-------------------------------------------------------------------------------------------------------------------------------------------------
--FEATURE 5

-- Description: 5.Add/delete a transponder to an account. 

---------------For Adding------------------
create or replace procedure add_transponder(trans_id in integer,account_id in integer) is
tmp int;
begin
select count(*) into tmp from transponder where transponder_id=trans_id;--To check the count of Transponders whether its already added
if tmp>=1 then
dbms_output.put_line('The Transponder already exists');
else 
insert into transponder(transponder_id,acc_id) values(transponder_id_seq.nextval,account_id);--Insert new transponder Value
dbms_output.put_line('The Transponder has been added');
insert into message(message_id,acc_id,message_time,body) values(message_id_seq.nextval,account_id,systimestamp,'Transponder added');--Insert in Message Table
end if;
Exception
when no_data_found then
    dbms_output.put_line('No data');
End;

--Valid Scenario
exec add_transponder(211,104);
--Exception
set serveroutput on;
exec add_transponder(201,104);

---------------For Delete------------------
create or replace procedure delete_transponder(trans_id in integer,account_id in integer) is
flg int;
flg1 int;
Begin
select count(*) into flg1 from transponder where trans_id=transponder_id and acc_id = account_id;
if flg1 > 0 then
    delete from transponder where transponder_id=trans_id;
        commit;
    dbms_output.put_line('The transponder has been deleted');
        insert into message(message_id,acc_id,message_time,body) values(message_id_seq.nextval,account_id,systimestamp,'Transponder deleted');
else
    dbms_output.put_line ('Please check the transponder id or account id entered');
end if;
Exception
when no_data_found then
    dbms_output.put_line('No data');
End;
/

--Invalid Condition
set serveroutput on;
exec delete_transponder(214,102);

--Valid Condition
set serveroutput on;
exec delete_transponder(220,104);
-------------------------------------------------------------------------------------------------------------------------------------------------
--FEATURE 6

-- Description: Match Account with transponderid and license number
-- Input: transponder_id_input int,license_number_input varchar,input_state varchar

create or replace PROCEDURE MATCHACCOUNT(transponder_id_input int,license_number_input varchar,input_state varchar,
ouput_account_id OUT account.acc_id%type,output_status OUT int, output_vehicle_id OUT vehicle.vehicle_id%type)AS
temp int;
temp_1 int;
temp_2 int;
temp_3 int;
temp_4 int;
temp_5 int;

BEGIN
    --Check if the transponder id exists
    Select count(*) into temp from transponder where transponder_id=transponder_id_input;
 --If transponder does exists check if the vehicle is associated with the account
    if temp!=0 then
        --check the account id associated with the given transponder id and set it to account id variable
        Select acc_id into ouput_account_id from transponder where transponder_id=transponder_id_input;
        --Check if vehicle is associated with the account else throws exception
        Select vehicle_id into output_vehicle_id from vehicle where license_plate_no=license_number_input and state=input_state and acc_id=ouput_account_id;
        --Set the status to 1
        output_status:=1;
 else

    begin
    Select count(*) into temp_3 from transponder where transponder_id=transponder_id_input;
    exception
    when no_data_found then 
    temp_3:=0;
    end;

    begin
    select count(*) into temp_4 from vehicle where vehicle.license_plate_no=license_number_input;
    exception
    when no_data_found then 
    temp_4:=0;
    end;

    begin
    select count(*) into temp_5 from vehicle where vehicle.state=input_state;
    exception
    when no_data_found then 
    temp_5:=0;
    end;

        --Check if vehicle exists with given license number and state
    begin
    select count(*) into temp_2 from account,vehicle where account.acc_id=vehicle.acc_id and vehicle.license_plate_no=license_number_input and vehicle.state=input_state ;
    exception
    when no_data_found then 
    temp_2:=0;
    end;
--For checking transponder id
    begin
    Select count(*) into temp_3 from transponder where transponder_id=transponder_id_input;
    exception
    when no_data_found then 
    temp_3:=0;
    end;
  --For checking License Plate number  
    begin
    select count(*) into temp_4 from vehicle where vehicle.license_plate_no=license_number_input;
    exception
    when no_data_found then 
    temp_4:=0;
    end;
  --For checking State   
    begin
    select count(*) into temp_5 from vehicle where vehicle.state=input_state;
    exception
    when no_data_found then 
    temp_5:=0;
    end;
  Select count(*) into temp from vehicle where license_number_input=license_plate_no and state=input_state;
        --If vehicle exists
        if temp!=0 then
            Select acc_id,vehicle_id into ouput_account_id,output_vehicle_id from vehicle where license_number_input=license_plate_no and state=input_state;
            --If account id is not null set status to 2
            if ouput_account_id is not null then
                output_status:=2;
                 else 
                output_status:=3;
            end if;
  if temp_3=0 and temp_4<>0 and temp_5<>0 and temp_2<>0  then
  insert into message(message_id,acc_id,message_time,body) values(message_id_seq.nextval,ouput_account_id,systimestamp,'Vehicle not associated with the account');
end if;  

        --If account is is null set status to 3
        else
            dbms_output.put_line('No vehicle is associated with given license number and state');
        end if;
    end if;
    dbms_output.put_line('account_id :'||ouput_account_id|| ' status :'|| output_status||' vehicle_id :' || output_vehicle_id);
exception
    when no_data_found then
        dbms_output.put_line('Vehicle is not associated with the account has used the transponder');
   -- insert into message(message_id,acc_id,message_time,body) values(message_id_seq.nextval,ouput_account_id,systimestamp,'Vehicle not associated with the account has used the transponder');
END;
/
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
END;
/
-------------------------------------------------------------------------------------------------------------------------------------------------
--FEATURE 7

--Description: Compute toll with the given parameters and add a trip entry in the trip table
--Input: trans_id int, licence_p varchar, state_s varchar, road_id_inp varchar, enter_exit_id int, exit_exit_id int, enter_time date

create or replace procedure Compute_trip_toll(trans_id int, licence_p varchar, state_s varchar, road_id_inp varchar, enter_exit_id int, exit_exit_id int, enter_time date) is
a_acc_id account.acc_id%type;
v_vehicle_id vehicle.vehicle_id%type;
t_toll_status trip.status%type;
vehicle_discount float;
v_vehicle_class vehicle.class%type;
computed_toll float;
admin_fee_val float;
t_transponder_id transponder.transponder_id%type;
return_val int;
s_start_exitid int;
e_end_id int;
d_direction varchar(10);
in_deducted int;

Cursor c1 is select start_exitid, end_exitid, direction from toll_rate
                where road_id=road_id_inp
                and start_exitid>=enter_exit_id and end_exitid<=exit_exit_id and start_exitid<end_exitid;
Cursor c2 is select start_exitid, end_exitid, direction from toll_rate
               where road_id=road_id_inp
                and start_exitid<=enter_exit_id and end_exitid>=exit_exit_id and start_exitid>end_exitid;
op_account_id account.acc_id%type;
op_status int;
op_vehicle vehicle.vehicle_id%type;

begin
--return_val := matchaccount(trans_id, licence_p, state_s);
MATCHACCOUNT(trans_id,licence_p,state_s,op_account_id,op_status,op_vehicle);
select class into v_vehicle_class from vehicle where license_plate_no=licence_p and state=state_s;
select vehicle_id into v_vehicle_id from vehicle where license_plate_no=licence_p and state=state_s;
    if(op_status=1 or op_status=2) then
        in_deducted:=1;
        select disc_rate into vehicle_discount from disc_rate;
        if op_status=1 then
            if(v_vehicle_class=1) then
               select acc_id into a_acc_id from transponder where transponder_id=trans_id;            
                if(enter_exit_id<exit_exit_id) then

                     open c1;
                     loop
                        fetch c1 into s_start_exitid, e_end_id, d_direction;
                        exit when c1%notfound;
                        computed_toll:=0;
                        select sum(car_toll_rate) into computed_toll from toll_rate
                        where road_id=road_id_inp
                        and start_exitid>=s_start_exitid and end_exitid<=e_end_id and start_exitid<end_exitid group by road_id;

                        computed_toll:=computed_toll*vehicle_discount;

                        insert into trip values(trip_id_seq.nextval, op_account_id, trans_id,v_vehicle_id,road_id_inp,s_start_exitid,e_end_id,enter_time,computed_toll,op_status,in_deducted);

                     end loop;
                     close c1;

                else
                    open c2;
                    loop
                        fetch c2 into s_start_exitid, e_end_id, d_direction;
                         exit when c2%notfound;
                         computed_toll:=0;
                        select sum(car_toll_rate) into computed_toll from toll_rate
                        where road_id=road_id_inp
                        and start_exitid<=s_start_exitid and end_exitid>=e_end_id and start_exitid>end_exitid group by road_id;

                        computed_toll:=computed_toll*vehicle_discount;

                        insert into trip values(trip_id_seq.nextval, op_account_id, trans_id,v_vehicle_id,road_id_inp,s_start_exitid,e_end_id,enter_time,computed_toll,op_status,in_deducted);
                    end loop;
                    close c2;

                end if;
            else
                if(enter_exit_id<exit_exit_id) then
                    open c1;
                    loop
                        fetch c1 into s_start_exitid, e_end_id, d_direction;
                        exit when c1%notfound;
                        computed_toll:=0;
                        select sum(truck_toll_rate) into computed_toll from toll_rate
                        where road_id=road_id_inp
                        and start_exitid>=s_start_exitid and end_exitid<=e_end_id and start_exitid<end_exitid group by road_id;

                        computed_toll:=computed_toll*vehicle_discount;

                        insert into trip values(trip_id_seq.nextval, op_account_id, trans_id,v_vehicle_id,road_id_inp,s_start_exitid,e_end_id,enter_time,computed_toll,op_status,in_deducted);

                    end loop;
                    close c1;
                else
                    open c2;
                    loop
                        fetch c2 into s_start_exitid, e_end_id, d_direction;
                        exit when c2%notfound;
                        computed_toll:=0;
                        select sum(truck_toll_rate) into computed_toll from toll_rate
                        where road_id=road_id_inp
                        and start_exitid<=s_start_exitid and end_exitid>=e_end_id and start_exitid>end_exitid group by road_id;

                        computed_toll:=computed_toll*vehicle_discount;
                        insert into trip values(trip_id_seq.nextval, op_account_id, trans_id,v_vehicle_id,road_id_inp,s_start_exitid,e_end_id,enter_time,computed_toll,op_status,in_deducted);

                    end loop;
                    close c2;

                end if;
            end if;

        else
            if(v_vehicle_class=1) then
                select vehicle_id into v_vehicle_id from vehicle where license_plate_no=licence_p and state=state_s;
                select acc_id into a_acc_id from vehicle where vehicle_id=v_vehicle_id;
                select disc_rate into vehicle_discount from disc_rate;
                if(enter_exit_id<exit_exit_id) then

                     open c1;
                     loop
                        fetch c1 into s_start_exitid, e_end_id, d_direction;
                        exit when c1%notfound;
                        computed_toll:=0;
                        select sum(car_toll_rate) into computed_toll from toll_rate
                        where road_id=road_id_inp
                        and start_exitid>=s_start_exitid and end_exitid<=e_end_id and start_exitid<end_exitid group by road_id;
                        computed_toll:=computed_toll*vehicle_discount;
                        insert into trip values(trip_id_seq.nextval, op_account_id, trans_id,v_vehicle_id,road_id_inp,s_start_exitid,e_end_id,enter_time,computed_toll,op_status,in_deducted);
                     end loop;

                     close c1;

                else
                    open c2;
                    loop
                        fetch c2 into s_start_exitid, e_end_id, d_direction;
                        exit when c2%notfound;
                        computed_toll:=0;
                        select sum(car_toll_rate) into computed_toll from toll_rate
                        where road_id=road_id_inp
                        and start_exitid<=s_start_exitid and end_exitid>=e_end_id and start_exitid>end_exitid group by road_id;
                        computed_toll:=computed_toll*vehicle_discount;
                        insert into trip values(trip_id_seq.nextval, op_account_id, trans_id,v_vehicle_id,road_id_inp,s_start_exitid,e_end_id,enter_time,computed_toll,op_status,in_deducted);

                end loop;

                    close c2;

                end if;
            else
                if(enter_exit_id<exit_exit_id) then
                    open c1;
                    loop
                        fetch c1 into s_start_exitid, e_end_id, d_direction;
                        exit when c1%notfound;
                        computed_toll:=0;
                        select sum(truck_toll_rate) into computed_toll from toll_rate
                        where road_id=road_id_inp
                        and start_exitid>=s_start_exitid and end_exitid<=e_end_id and start_exitid<end_exitid group by road_id;

                        computed_toll:=computed_toll*vehicle_discount;

                        insert into trip values(trip_id_seq.nextval, op_account_id, trans_id,v_vehicle_id,road_id_inp,s_start_exitid,e_end_id,enter_time,computed_toll,op_status,in_deducted);

                    end loop;
                    close c1;
                else
                    open c2;
                    loop
                        fetch c2 into s_start_exitid, e_end_id, d_direction;
                        exit when c2%notfound;
                        computed_toll:=0;
                        in_deducted:=1;
                        select sum(truck_toll_rate) into computed_toll from toll_rate
                        where road_id=road_id_inp
                        and start_exitid<=s_start_exitid and end_exitid>=e_end_id and start_exitid>end_exitid group by road_id;

                        computed_toll:=computed_toll*vehicle_discount;
                        insert into trip values(trip_id_seq.nextval, op_account_id, trans_id,v_vehicle_id,road_id_inp,s_start_exitid,e_end_id,enter_time,computed_toll,op_status,in_deducted);

                    end loop;
                    close c2;

                end if;

            end if;  
        end if;

    else
         select rate_video_toll,admin_fee into vehicle_discount,admin_fee_val from disc_rate;
        if(enter_exit_id<exit_exit_id) then
        open c1;
        loop
        fetch c1 into s_start_exitid, e_end_id, d_direction;
        exit when c1%notfound;
        computed_toll:=0;
        in_deducted:=1;
             select car_toll_rate into computed_toll from toll_rate
                where road_id=road_id_inp
                and start_exitid>=s_start_exitid and end_exitid<=e_end_id and start_exitid<end_exitid;

            computed_toll:=computed_toll*vehicle_discount+admin_fee_val;

            insert into trip values(trip_id_seq.nextval, op_account_id, trans_id,v_vehicle_id,road_id_inp,s_start_exitid,e_end_id,enter_time,computed_toll,op_status,in_deducted);

        end loop;
        close c1;

        else
            open c2;
             loop
            fetch c2 into s_start_exitid, e_end_id, d_direction;
            in_deducted:=1;
             exit when c2%notfound;
             computed_toll:=0;
            select car_toll_rate into computed_toll from toll_rate
            where road_id=road_id_inp
            and start_exitid<=s_start_exitid and end_exitid>=e_end_id and start_exitid>end_exitid;

            computed_toll:=computed_toll*vehicle_discount+admin_fee_val;

        insert into trip values(trip_id_seq.nextval, op_account_id, trans_id,v_vehicle_id,road_id_inp,s_start_exitid,e_end_id,enter_time,computed_toll,op_status,in_deducted);

            end loop;
        close c2;
        end if;
    end if;
end;
/
-- Case for Car
exec Compute_trip_toll(202,'2CD456','CT',403,95,110,timestamp  '2018-7-10 07:00:30.75 -5:00');
-- Case for Truck
exec Compute_trip_toll(203,'3EF789','IA',402,80,90,timestamp  '2018-7-12 05:00:30.75 -5:00');
-------------------------------------------------------------------------------------------------------------------------------------------------
--FEATURE 8

-- Description: Match Account and Deduct Toll
-- Input: input trip ID

create or replace PROCEDURE DEDUCTTOLL(input_trip_id integer) AS 
temp int;
temp_1 int;
actualtoll number;
actual_account_balance number;
account_id_actual int;
new_toll number;
actual_video_toll_rate number;
actual_admin_fee number;
BEGIN
    Select rate_video_toll into actual_video_toll_rate from disc_rate;
    Select admin_fee into actual_admin_fee from disc_rate;
    Select balance,trip.acc_id into actual_account_balance,account_id_actual from trip,account where trip_id=input_trip_id and trip.acc_id=account.acc_id;
    Select toll into actualtoll from trip where trip_id=input_trip_id;
    Select deducted into temp from trip where trip_id=input_trip_id;--check whether toll has been deducted=1
    if(temp=1) then
        dbms_output.put_line('Toll has been deducted');
    else
    
        Select status into temp_1 from trip where trip_id=input_trip_id;--if status=1 or status=2 and accountbalance is more than 0 deduct amount
        if(temp_1=1 or temp_1=2) then
            if((actual_account_balance-actualtoll)>=0) then
                Update account set balance=actual_account_balance-actualtoll where acc_id=account_id_actual;
            else  --  if amount not sufficientbalance recompute toll
                new_toll:=actualtoll*actual_video_toll_rate+actual_admin_fee;
                Update trip set toll=new_toll where trip_id=input_trip_id;
                Insert into video_bill_info values (bill_id_seq.nextval,sysdate,input_trip_id,1);
                Insert into message values (message_id_seq.nextval,account_id_actual,systimestamp,'Please replenish the account');
                        dbms_output.put_line('Insufficient balance so Toll has been recomputed');
            end if;
        else
            Insert into video_bill_info values (bill_id_seq.nextval,sysdate,input_trip_id,1);--for status=3
        dbms_output.put_line('Values inserted in video bill table');
        end if;
        Update trip set deducted=1 where trip_id=input_trip_id;--To prevent multiple transactions
    end if;
END;


set serveroutput on;
exec DEDUCTTOLL(601);

--For insufficient Balance
set serveroutput on;
exec DEDUCTTOLL(602);

--For Sufficient Balance
set serveroutput on;
exec DEDUCTTOLL(604);


--For Status =3
set serveroutput on;
exec DEDUCTTOLL(608);
-------------------------------------------------------------------------------------------------------------------------------------------------
--FEATURE 9

-- Description: Allow user to make payment to an account.
-- Input: pay_id ,account_id in integer,pay_date,User_amount
create or replace procedure add_payment(pay_id in integer,account_id in integer,pay_date in date,User_amount in number) is
tmp int;
begin
select count(*) into tmp from payment where account_id=acc_id;---Handle Exception from Payment Table
if tmp=0 then
dbms_output.put_line('Account doesnot exist');
else 
    insert into payment(payment_id,acc_id,payment_date,amount) values(payment_id_seq.nextval,account_id,sysdate,user_amount);--Matches Exception and Inserts in the Payment Table
    dbms_output.put_line('The payment has been added to the account');
        insert into message(message_id,acc_id,message_time,body) values(message_id_seq.nextval,account_id,systimestamp,'payment received');
end if;
Exception
when no_data_found then
    dbms_output.put_line('No data');
End;

--Valid Condition

set SERVEROUTPUT ON;
exec add_payment(123,103,date'2018-11-12',200);

--Invalid Condition
set SERVEROUTPUT ON;
exec add_payment(123,163,date'2018-11-12',200);

-------------------------------------------------------------------------------------------------------------------------------------------------
--FEATURE 10

--Description: Update the video_bill's status whenever the bill is sent or paid. 

create or replace PROCEDURE change_status(id_bill in integer,new_status in number) is
temp integer;
temp1 integer;
BEGIN
select count(*) into temp from video_bill_info where bill_id=id_bill;
select status into temp1 from video_bill_info where bill_id = id_bill;

if temp = 0  then
    dbms_output.put_line('Please Enter a Valid Bill ID');
else
    if temp1 = new_status then
        dbms_output.put_line('Please enter updated status/ new status');
    else
    update video_bill_info set status = new_status where bill_id=id_bill and status=1;
    dbms_output.put_line('Video bill Table Updated');
    end if;
end if;
EXCEPTION
    WHEN no_data_found then
        dbms_output.put_line('Bill id doesnt exist');
END;
/

--Valid Condition
set serveroutput on;
exec change_status(702, 2);

--Invalid Condition
set serveroutput on;
exec change_status(787, 2);
-------------------------------------------------------------------------------------------------------------------------------------------------
--FEATURE 11

-- Description: Match Account and retrieve trip details
-- Input: account_id , date1 ,date2 

create or replace procedure trip_payment_detail(account_id in number, date1 in timestamp,date2 in timestamp) 
IS    
CURSOR c1 is select tp.transponder_id, v.license_plate_no, t.road_name, tp.entering_exit_id,tp.exiting_exit_id, tp.entrance_time, tp.toll,tr.toll_start_time,tr.toll_end_time
from toll_rate tr, vehicle v, toll t, trip tp, payment p
where v.vehicle_id = tp.vehicle_id and t.road_id = tp.road_id and t.road_id = tr.road_id and tp.acc_id = p.acc_id 
and tp.acc_id=account_id and tp.entrance_time >= date1 and tp.entrance_time<=date2;
   trans_id transponder.transponder_id%type;
   lpno vehicle.license_plate_no%type;
   road_nm toll.road_name%type;
  ent_exit_id trip.entering_exit_id%type;
  ex_exit_id trip.exiting_exit_id%type;
  ent_time trip.entrance_time%type;
  tll trip.toll%type;
starttime trip.entrance_time%type;
endtime trip.entrance_time%type;
flag account.acc_id%type;

BEGIN
    select count(*) into flag
    from  account where acc_id = account_id;
    if flag = 0 then
        dbms_output.put_line('User does not exists');
    else
    open c1;
    loop 
        fetch c1 into trans_id, lpno, road_nm, ent_exit_id, ex_exit_id, ent_time, tll,starttime,endtime;
        exit when c1%NOTFOUND;
        dbms_output.put_line('Account ID: '||account_id ||' '||'with transponder: '||trans_id||' having vehicle with license plate number: ' ||lpno|| ' travelling in road: '|| road_nm||' entering with exit number: '|| ent_exit_id ||' and exiting with exit number: '|| ex_exit_id ||' at '|| ent_time ||'has total toll of '|| tll);
    end loop;
    close c1;
    end if;
END;
/
set serveroutput on;
exec trip_payment_detail(105 ,to_timestamp('01-JUL-18 07.00.30.750000000 AM'),to_timestamp('01-JUL-18 07.10.30.750000000 AM'));
exec trip_payment_detail(101 ,to_timestamp('01-JUL-18 06.00.30.750000000 AM'),to_timestamp('01-JUL-18 07.10.30.750000000 AM'));
exec trip_payment_detail(100 ,to_timestamp('01-JUL-18 06.00.30.750000000 AM'),to_timestamp('01-JUL-18 07.10.30.750000000 AM'));
-------------------------------------------------------------------------------------------------------------------------------------------------
--FEATURE 12
-- Description: Match Account and retrieve monthly details
-- Input: account_id , date1 ,date2 

create or replace procedure monthly_statement(account_id in number, date1 in timestamp, date2 in timestamp) 
IS    
    CURSOR c1 is select sum(car_toll_rate) as Total_Car_Toll, sum(truck_toll_rate) as Total_Truck_Toll, sum(amount) as Total_Payment, tp.transponder_id, v.license_plate_no, t.road_name, tp.entering_exit_id,tp.exiting_exit_id, tp.entrance_time, tp.toll,tr.toll_start_time,tr.toll_end_time
    from toll_rate tr, vehicle v, toll t, trip tp, payment p
    where v.vehicle_id = tp.vehicle_id and t.road_id = tp.road_id and t.road_id = tr.road_id and tp.acc_id = p.acc_id 
    and tp.acc_id=account_id and tp.entrance_time >= date1 and tp.entrance_time<=date2
    group by tp.transponder_id, v.license_plate_no, t.road_name, tp.entering_exit_id,tp.exiting_exit_id, tp.entrance_time, tp.toll,tr.toll_start_time,tr.toll_end_time;
   trans_id transponder.transponder_id%type;
   lpno vehicle.license_plate_no%type;
   road_nm toll.road_name%type;
  ent_exit_id trip.entering_exit_id%type;
  ex_exit_id trip.exiting_exit_id%type;
  ent_time trip.entrance_time%type;
  tll trip.toll%type;
  starttime trip.entrance_time%type;
  endtime trip.entrance_time%type;
car_toll toll_rate.car_toll_rate%type;
truck_toll toll_rate.truck_toll_rate%type;
total_payment payment.amount%type;
flag account.acc_id%type;
BEGIN
    select count(*) into flag
    from  account where acc_id = account_id;
    if flag = 0 then
        dbms_output.put_line('User does not exists');
    else
    open c1;
        loop 
            fetch c1 into car_toll, truck_toll, total_payment, trans_id, lpno, road_nm, ent_exit_id, ex_exit_id, ent_time, tll,starttime,endtime;
            exit when c1%NOTFOUND;
            dbms_output.put_line('Account ID: '||account_id ||' '||'with transponder: '||trans_id||' having vehicle with license plate number: ' ||lpno|| ' travelling in road: '|| road_nm||' entering with exit number: '|| ent_exit_id ||' and exiting with exit number: '|| ex_exit_id ||' at '|| ent_time ||'has total toll of, '|| tll ||
            ' car toll of, '||car_toll||' truck toll of, '||truck_toll||' and a Total Payment of '||total_payment);
        end loop;
    close c1;
    end if;
END;
/
set serveroutput on;
exec monthly_statement(105 ,to_timestamp('01-JUL-18 07.00.30.750000000 AM'),to_timestamp('01-JUL-18 07.10.30.750000000 AM'));
--exec trip_payment_detail(101 ,to_timestamp('01-JUL-18 06.00.30.750000000 AM'),to_timestamp('01-JUL-18 07.10.30.750000000 AM'));
--exec trip_payment_detail(100 ,to_timestamp('01-JUL-18 06.00.30.750000000 AM'),to_timestamp('01-JUL-18 07.10.30.750000000 AM'));
-------------------------------------------------------------------------------------------------------------------------------------------------
--FEATURE 13
-- Description: Total Toll and number of trips on that road
-- Input: start_date and end_date
create or replace procedure road_details(start_date in date, end_date in date)
IS
cursor c1 is 
select count(trip_id),road_name,sum(toll) as total_toll from trip,toll 
where trunc(entrance_time) > start_date 
and trunc(entrance_time) < end_date
and trip.road_id=toll.road_id 
group by road_name
order by total_toll
desc;

temp1 trip.trip_id%type;
temp2 toll.road_name%type;
temp3 trip.toll%type;

Begin
open c1;

loop
    fetch c1 into temp1,temp2,temp3;
    exit when c1%notfound;
    dbms_output.put_line('Number of trips :' || temp1 ||' Road name :'||temp2|| ' Total toll collected :'|| temp3);
end loop;
if temp1 is null and temp2 is null and temp3 is null then
    dbms_output.put_line('No trips found for this date range');
end if;
close c1;
Exception
when no_data_found then
    dbms_output.put_line('No data');
End;
/

-- Valid Case
exec road_details(date '2018-06-01',date '2018-07-20');
-- Invalid Case
exec road_details(date '2028-06-01',date '2028-07-20');
-------------------------------------------------------------------------------------------------------------------------------------------------
--FEATURE 14

-- Description: Number of trips made through each exit in descending order. 
--Input : start_date,end_date,road_id
-- Output includes exit ID and total number of trips
create or replace procedure number_of_trips(start_date in date,end_date in date,road_id_input in number) is
--This is in the ascending order
cursor c1 is  select exiting_exit_id,count(*) from trip
    where exiting_exit_id > entering_exit_id
    and trunc(entrance_time) > start_date
    and trunc(entrance_time) < end_date
    and road_id = road_id_input
    group by exiting_exit_id, entering_exit_id
    order by count(*) desc;
-- This is in descending order
cursor c2 is  select exiting_exit_id,count(*) from trip
    where exiting_exit_id < entering_exit_id
    and trunc(entrance_time) > start_date
    and trunc(entrance_time) < end_date
    and road_id = road_id_input
    group by exiting_exit_id, entering_exit_id
    order by count(*) desc;
temp1 number;
temp2 number;
temp3 number;
no_of_trips_asc1 number;
no_of_trips_dsc1 number;
count1 number;
count2 number;
begin
open c1;
open c2;
select count(*) into temp3 from trip where road_id = road_id_input;
if temp3 = 0 then
    dbms_output.put_line('Road ID invalid');
else
    loop
        
        fetch c1 into temp1, no_of_trips_asc1;
        exit when c1%notfound;
        dbms_output.put_line('Exit Id: ' ||temp1||' '||'No. of trips: ' ||no_of_trips_asc1);
        dbms_output.put_line('=============================');
    end loop;
        if no_of_trips_asc1 is null then
            no_of_trips_asc1 := 0;
        end if;
    loop
        fetch c2 into temp2,no_of_trips_dsc1;
        exit when c2%notfound;
        dbms_output.put_line('Exit Id: '||temp2||' '||'No. of trips: '||no_of_trips_dsc1);
        dbms_output.put_line('==============================');
    end loop;
        if no_of_trips_dsc1 is null then
            no_of_trips_dsc1 := 0;
        end if;
        dbms_output.put_line('Number of trips in ascending order '||no_of_trips_asc1);
        dbms_output.put_line('Number of trips in descending order '||no_of_trips_dsc1);
    if (no_of_trips_dsc1 < no_of_trips_asc1) then
        dbms_output.put_line('Number of trips in ascending are greater');
    elsif (no_of_trips_asc1 < no_of_trips_dsc1) then
        dbms_output.put_line('number of trips in descending are greater');
    elsif (no_of_trips_asc1 = no_of_trips_dsc1) then
        dbms_output.put_line('Number of trips are equal in both direction');
    else
        dbms_output.put_line('No trips found');
    end if;
    end if;
end;
/

set serveroutput on;
-- Valid case 
exec number_of_trips(date '2018-06-21',date '2018-07-10',401);
-- Invalid RoadID case
exec number_of_trips(date '2018-04-01',date '2020-10-01',41);
--------------------------------------------------------------------------------------------------------------------------------

--FEATURE 15
-- Description: Number of trips with highest toll and video bill
-- Input : start_date,end_date, parameter k - number of trips to display
create or replace procedure stat_mosttoll(start_date in date,end_date in date,k in VARCHAR) AS
Cursor c1 is select * from
(select account.acc_id,sum(toll),count(trip_id),trip.vehicle_id from account,trip 
where trip.acc_id = account.acc_id
and trunc(entrance_time) > start_date
and trunc(entrance_time) < end_date
group by account.acc_id, trip.vehicle_id order by sum(toll) desc)
where rownum <= k;

Cursor c2 is select * from
(select account.acc_id,sum(toll),count(trip_id),trip.vehicle_id from account,trip 
where trip.acc_id = account.acc_id
and trunc(entrance_time) > start_date 
and trunc(entrance_time) < end_date
and trip.status = 3
group by account.acc_id, trip.vehicle_id 
order by count(trip_id) desc)
where rownum <= k;

account_id account.acc_id%type;
total_toll number;
count_trips number;
account_id1 account.acc_id%type;
total_toll1 number;
count_trips1 number;
vehicle1 number;
vehicle2 number;

BEGIN
open c1;
dbms_output.put_line('Statistics for Toll Bill');
    Loop
        fetch c1 into account_id,total_toll,count_trips,vehicle1;
        exit when c1%NOTFOUND;

        dbms_output.put_line('Account ID: '||account_id||' '||'Toll: '||total_toll||' Number of Trips: '||count_trips || ' Vehicle ID: '||vehicle1);
    end loop;
close c1;
open c2;
dbms_output.put_line('*******************************');
dbms_output.put_line('Statistics for Video Toll Bill');
    Loop
        fetch c2 into account_id,total_toll,count_trips,vehicle2;
        exit when c2%NOTFOUND;
        dbms_output.put_line('Account ID: '||account_id||' '||'Total Toll: '||total_toll||' Number of Trips: '||count_trips||' Vehicle ID: ' || vehicle2);
    end loop;
close c2;
Exception
    when no_data_found then
        dbms_output.put_line( 'No data found');
END;
/

-- Valid case
set serveroutput on;
exec stat_mosttoll(date '2018-06-30',date '2018-07-30',2);
------------------------------------------------------------------------------------------------------------------------------------------------

--FEATURE 16

-- Description: Given a date range, find pairs of vehicles that travel at approximately similar time and similar route

create or replace procedure travel_vehicle(start_date in date,end_date in date)
AS
cursor c1 is select t1.vehicle_id,t2.vehicle_id,t1.road_id,t1.entering_exit_id,t1.exiting_exit_id,t1.entrance_time from trip t1,trip t2 
where t1.entering_exit_id = t2.entering_exit_id and t1.exiting_exit_id =
t2.exiting_exit_id and t1.road_id=t2.road_id and t1.entrance_time < = t2.entrance_time + interval '30' minute and t1.entrance_time>=start_date and t1.entrance_time<=end_date and
t1.vehicle_id > t2.vehicle_id;---To find pairs Vehicle within a interval of 30mins
vehicle1id trip.vehicle_id%type;
vehicle2id trip.vehicle_id%type;
roadid trip.road_id%type;
enter_exit_id trip.entering_exit_id%type;
exit_exit_id trip.exiting_exit_id%type;
enter_time trip.entrance_time%type;
temp int;

begin
    --Check if there are vehicles which travel at same time in same route
    Select count(*) into temp from trip t1, trip t2 where t1.entering_exit_id = t2.entering_exit_id and t1.exiting_exit_id = t2.exiting_exit_id and t1.entrance_time >= t2.entrance_time - interval '30' minute and t1.entrance_time < = t2.entrance_time + interval '30' minute and t1.vehicle_id > t2.vehicle_id and t1.entrance_time>=start_date and t1.entrance_time<=end_date;
    --If there are no such vehicle print message no such vehicles
    if temp=0 then
        dbms_output.put_line('There are no vehicles that travel at similar time and similar route');
    --else print the vehicle details
    else
    open c1;
    loop 
        fetch c1 into vehicle1id,vehicle2id,roadid,enter_exit_id,exit_exit_id,enter_time;
        exit when c1%NOTFOUND;
        dbms_output.put_line('Vehicle IDs are: '||vehicle1id||' '||vehicle2id||' travelling on road number:'||roadid||' entering exit number:'||enter_exit_id||' and exiting from'||exit_exit_id||' at'||enter_time);
    end loop;
    close c1;
end if;
END;

/
--Valid
set serveroutput on;
exec travel_vehicle(timestamp  '2018-7-01 05:00:30.75 -5:00',timestamp  '2018-7-20 05:30:30.75 -5:00');
/
--InValid Condition
set serveroutput on;
exec travel_vehicle(timestamp  '2018-7-20 05:00:30.75 -5:00',timestamp  '2018-7-20 05:30:30.75 -5:00');