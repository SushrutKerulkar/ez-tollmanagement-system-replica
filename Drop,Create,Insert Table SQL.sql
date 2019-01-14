/* Drop and Create Sequences */

--Transponder
Drop sequence transponder_id_seq; 
CREATE SEQUENCE transponder_id_seq
START WITH 220
INCREMENT BY 1;

--Video_bill_info
Drop sequence bill_id_seq;
CREATE SEQUENCE bill_id_seq
START WITH 720
INCREMENT BY 1;

--account id sequence
Drop sequence accid_seq ;
create sequence accid_seq 
start with 120 
increment by 1;


-- Sequence created for vehicle id
Drop sequence vehicle_id_seq;
CREATE SEQUENCE vehicle_id_seq
START WITH 520
INCREMENT BY 1;

-- Sequence created for trip id
Drop sequence trip_id_seq;
CREATE SEQUENCE trip_id_seq
START WITH 620
INCREMENT BY 1;

--------Payment Sequence-------
Drop sequence payment_id_seq;
CREATE SEQUENCE payment_id_seq
START WITH 315
INCREMENT BY 1;

---Payment
Drop sequence message_id_seq;
CREATE SEQUENCE message_id_seq
START WITH 820
INCREMENT BY 1;



/* Drop all tables*/
drop table disc_rate cascade constraints;
drop table message cascade constraints;
drop table video_bill_info cascade constraints;
drop table trip cascade constraints;
drop table road_exit cascade constraints;
drop table toll_rate cascade constraints;
drop table toll cascade constraints;
drop table payment cascade constraints;
drop table transponder cascade constraints;
drop table vehicle cascade constraints;
drop table account cascade constraints;

/* Create table Account*/
create table account
(
acc_id int,
name VARCHAR(50),
email VARCHAR(50),
address VARCHAR(50),
balance number,
password VARCHAR(50),
primary key(acc_id)
);


/* Insert values into account*/
insert into account values(101,'Ashish','ashishv1@umbc.edu','4735 Gateway',300.20,'Ashish@91');
insert into account values(102,'Abhishek','abhishek1@umbc.edu','1018 Howland',0,'Abhishek@91');
insert into account values(103,'Sushrut','sushrut1@umbc.edu','1010 Howland',0.60,'Sushrut9');
insert into account values(104,'Andrew','andy11@umbc.edu','1000 belwood',700,'Andrew');
insert into account values(105,'Andrew','andy11@umbc.edu','1000 belwood',700,'Andrew');

/* Create table Vehicle*/
create table vehicle
(
vehicle_id int,
license_plate_no varchar(50),
state VARCHAR(50),
class number,
address_owner VARCHAR(50),
acc_id int,
primary key(vehicle_id),
foreign key(acc_id) references account(acc_id)
);


/* Insert values into vehicle*/
insert into vehicle values(501,'1AB123','TN',1,'7367 South Buttonwood Ave. Cookeville, TN 38501',101);
insert into vehicle values(502,'2CD456','CT',1,'145 Monroe Street Bristol, CT 06010',102);
insert into vehicle values(503,'3EF789','IA',2,'898 West Shipley Drive Riverdale, GA 30274',103);
insert into vehicle values(504,'4GH987','NY',1,'491 San Juan St. Jamaica, NY 11432',104);
insert into vehicle values(505,'5IJ654','NC',1,'7927 Beach Street Jacksonville, NC 28540',105);

/* create transponder table*/
create table transponder
(
transponder_id int,
acc_id int,
primary key(transponder_id),
foreign key(acc_id) references account(acc_id)
);

/* Insert values into transponder*/
insert into transponder values(201, 101);
insert into transponder values(202, 102);
insert into transponder values(203, 103);
insert into transponder values(204, 104);
insert into transponder values(205, 105);

/* Create table payment */
create table payment
(
payment_id int,
acc_id int,
payment_date date,
amount number,
primary key(payment_id),
foreign key(acc_id) references account(acc_id)
);

/* Insert table payment values*/
insert into payment values(301,101,date '2018-07-10',5);
insert into payment values(302,102,date '2018-07-10',10);
insert into payment values(303,103,date '2018-07-10',5);
insert into payment values(304,103,date '2018-07-10',5);
insert into payment values(305,105,date '2018-07-10',5);

/* Create table toll*/
create table toll
(
road_id int,
road_name VARCHAR(50),
no_of_exits int,
primary key(road_id)
);

/* Insert values into toll*/
insert into toll values (401,'I-95',2);
insert into toll values (402,'I-81',2);
insert into toll values (403,'I-70',2);
insert into toll values (404,'I-170',2);
insert into toll values (405,'I-495',2);


/* Create table toll_rate*/
create table toll_rate
(
toll_rate_id int,
road_id int,
start_exitid number,
end_exitid number,
direction VARCHAR(50),
toll_start_time timestamp,
toll_end_time timestamp,
car_toll_rate number,
truck_toll_rate number,
primary key (toll_rate_id),
foreign key(road_id) references toll(road_id)
);

/* Insert into toll_rate*/
Insert into TOLL_RATE (TOLL_RATE_ID,ROAD_ID,START_EXITID,END_EXITID,DIRECTION,TOLL_START_TIME,TOLL_END_TIME,CAR_TOLL_RATE,TRUCK_TOLL_RATE) values (100,401,20,60,'South',to_timestamp('01-JUL-18 06.00.30.750000000 AM','DD-MON-RR HH.MI.SSXFF AM'),to_timestamp('01-JUL-18 09.00.30.750000000 AM','DD-MON-RR HH.MI.SSXFF AM'),5,10);
Insert into TOLL_RATE (TOLL_RATE_ID,ROAD_ID,START_EXITID,END_EXITID,DIRECTION,TOLL_START_TIME,TOLL_END_TIME,CAR_TOLL_RATE,TRUCK_TOLL_RATE) values (101,402,80,90,'South',to_timestamp('01-JUL-18 06.00.30.750000000 AM','DD-MON-RR HH.MI.SSXFF AM'),to_timestamp('01-JUL-18 09.00.30.750000000 PM','DD-MON-RR HH.MI.SSXFF AM'),5,10);
Insert into TOLL_RATE (TOLL_RATE_ID,ROAD_ID,START_EXITID,END_EXITID,DIRECTION,TOLL_START_TIME,TOLL_END_TIME,CAR_TOLL_RATE,TRUCK_TOLL_RATE) values (102,403,95,110,'North',to_timestamp('01-JUL-18 06.00.30.750000000 AM','DD-MON-RR HH.MI.SSXFF AM'),to_timestamp('01-JUL-18 09.00.30.750000000 AM','DD-MON-RR HH.MI.SSXFF AM'),5,10);
Insert into TOLL_RATE (TOLL_RATE_ID,ROAD_ID,START_EXITID,END_EXITID,DIRECTION,TOLL_START_TIME,TOLL_END_TIME,CAR_TOLL_RATE,TRUCK_TOLL_RATE) values (103,404,120,200,'South',to_timestamp('01-JUL-18 06.00.30.750000000 AM','DD-MON-RR HH.MI.SSXFF AM'),to_timestamp('01-JUL-18 09.00.30.750000000 PM','DD-MON-RR HH.MI.SSXFF AM'),5,10);
Insert into TOLL_RATE (TOLL_RATE_ID,ROAD_ID,START_EXITID,END_EXITID,DIRECTION,TOLL_START_TIME,TOLL_END_TIME,CAR_TOLL_RATE,TRUCK_TOLL_RATE) values (104,405,210,248,'North',to_timestamp('01-JUL-18 06.00.30.750000000 AM','DD-MON-RR HH.MI.SSXFF AM'),to_timestamp('01-JUL-18 09.00.30.750000000 AM','DD-MON-RR HH.MI.SSXFF AM'),5,10);

/* Create table road_exit*/
create table road_exit
(
road_exit_id int,
road_id int,
exit_no number,
description VARCHAR(50),
primary key(road_exit_id),
foreign key(road_id) references toll(road_id)
);

/* Insert into road_exit*/
Insert into road_exit (ROAD_EXIT_ID,ROAD_ID,EXIT_NO,DESCRIPTION) values (700,401,20,'North');
Insert into road_exit (ROAD_EXIT_ID,ROAD_ID,EXIT_NO,DESCRIPTION) values (701,401,60,'South');
Insert into road_exit (ROAD_EXIT_ID,ROAD_ID,EXIT_NO,DESCRIPTION) values (702,402,80,'South');
Insert into road_exit (ROAD_EXIT_ID,ROAD_ID,EXIT_NO,DESCRIPTION) values (703,402,90,'North');
Insert into road_exit (ROAD_EXIT_ID,ROAD_ID,EXIT_NO,DESCRIPTION) values (704,403,95,'South');
Insert into road_exit (ROAD_EXIT_ID,ROAD_ID,EXIT_NO,DESCRIPTION) values (705,403,110,'North');
Insert into road_exit (ROAD_EXIT_ID,ROAD_ID,EXIT_NO,DESCRIPTION) values (706,404,120,'South');
Insert into road_exit (ROAD_EXIT_ID,ROAD_ID,EXIT_NO,DESCRIPTION) values (707,404,200,'North');
Insert into road_exit (ROAD_EXIT_ID,ROAD_ID,EXIT_NO,DESCRIPTION) values (708,405,210,'South');
Insert into road_exit (ROAD_EXIT_ID,ROAD_ID,EXIT_NO,DESCRIPTION) values (709,405,248,'North');


/* Create table trip, need to recheck this table when used*/
create table trip
(
trip_id int,
acc_id int, 
transponder_id int,
vehicle_id int,
road_id int,
entering_exit_id int, -- 801 start
exiting_exit_id int, -- 901 start
entrance_time timestamp,
toll int,
status VARCHAR2(20),
deducted VARCHAR(10),
primary key(trip_id),
foreign key(road_id) references toll(road_id),
foreign key(vehicle_id) references vehicle(vehicle_id),
foreign key(transponder_id) references transponder(transponder_id),
foreign key(acc_id) references account(acc_id)
);

/* Create table trip*/
Insert into TRIP (TRIP_ID,ACC_ID,TRANSPONDER_ID,VEHICLE_ID,ROAD_ID,ENTERING_EXIT_ID,EXITING_EXIT_ID,ENTRANCE_TIME,TOLL,STATUS,DEDUCTED) values (601,101,201,501,401,20,60,to_timestamp('01-JUL-18 06.00.30.750000000 AM','DD-MON-RR HH.MI.SSXFF AM'),5,'1','1');
Insert into TRIP (TRIP_ID,ACC_ID,TRANSPONDER_ID,VEHICLE_ID,ROAD_ID,ENTERING_EXIT_ID,EXITING_EXIT_ID,ENTRANCE_TIME,TOLL,STATUS,DEDUCTED) values (602,102,202,502,402,80,90,to_timestamp('01-JUL-18 06.10.30.750000000 AM','DD-MON-RR HH.MI.SSXFF AM'),5,'2','2');
Insert into TRIP (TRIP_ID,ACC_ID,TRANSPONDER_ID,VEHICLE_ID,ROAD_ID,ENTERING_EXIT_ID,EXITING_EXIT_ID,ENTRANCE_TIME,TOLL,STATUS,DEDUCTED) values (603,103,203,503,403,95,110,to_timestamp('01-JUL-18 06.20.30.750000000 AM','DD-MON-RR HH.MI.SSXFF AM'),10,'3','1');
Insert into TRIP (TRIP_ID,ACC_ID,TRANSPONDER_ID,VEHICLE_ID,ROAD_ID,ENTERING_EXIT_ID,EXITING_EXIT_ID,ENTRANCE_TIME,TOLL,STATUS,DEDUCTED) values (604,104,204,504,404,120,200,to_timestamp('01-JUL-18 07.00.30.750000000 AM','DD-MON-RR HH.MI.SSXFF AM'),5,'1','2');
Insert into TRIP (TRIP_ID,ACC_ID,TRANSPONDER_ID,VEHICLE_ID,ROAD_ID,ENTERING_EXIT_ID,EXITING_EXIT_ID,ENTRANCE_TIME,TOLL,STATUS,DEDUCTED) values (605,105,205,505,405,210,248,to_timestamp('01-JUL-18 07.10.30.750000000 AM','DD-MON-RR HH.MI.SSXFF AM'),5,'1','1');
Insert into TRIP (TRIP_ID,ACC_ID,TRANSPONDER_ID,VEHICLE_ID,ROAD_ID,ENTERING_EXIT_ID,EXITING_EXIT_ID,ENTRANCE_TIME,TOLL,STATUS,DEDUCTED) values (606,101,201,502,401,60,20,to_timestamp('01-JUL-18 07.20.10.750000000 AM','DD-MON-RR HH.MI.SSXFF AM'),5,'2','2');
Insert into TRIP (TRIP_ID,ACC_ID,TRANSPONDER_ID,VEHICLE_ID,ROAD_ID,ENTERING_EXIT_ID,EXITING_EXIT_ID,ENTRANCE_TIME,TOLL,STATUS,DEDUCTED) values (607,102,202,501,401,60,20,to_timestamp('01-JUL-18 07.30.00.000000000 AM','DD-MON-RR HH.MI.SSXFF AM'),5,'2','1');
Insert into TRIP (TRIP_ID,ACC_ID,TRANSPONDER_ID,VEHICLE_ID,ROAD_ID,ENTERING_EXIT_ID,EXITING_EXIT_ID,ENTRANCE_TIME,TOLL,STATUS,DEDUCTED) values (608,103,203,503,402,90,80,to_timestamp('01-JUL-18 07.35.35.000000000 AM','DD-MON-RR HH.MI.SSXFF AM'),10,'3','2');

/* Create table video_bill_info*/
create table video_bill_info
(
bill_id int,
bill_date date,
trip_id int,
status int, -- 1 when bill generated but not sent,2 is sent,3 is paid
primary key(bill_id),
foreign key(trip_id) references trip(trip_id)
);

/* insert into table video_bill_info*/
insert into video_bill_info values(701, date '2018-07-01', 603, 2);
insert into video_bill_info values(702, date '2018-07-01', 608, 3);


/* Create table message*/
create table message
(
message_id int,
acc_id int,
message_time timestamp,
body VARCHAR(50),
primary key(message_id),
foreign key(acc_id) references account(acc_id)
);

/*Insert values in Message*/
insert into message values(801,101,to_timestamp('01-JUL-18 06.00.30.750000000 AM','DD-MON-RR HH.MI.SSXFF AM'),'Toll has been generated');
insert into message values(802,102,to_timestamp('01-JUL-18 06.10.30.750000000 AM','DD-MON-RR HH.MI.SSXFF AM'),'Toll has been generated');
insert into message values(803,103,to_timestamp('01-JUL-18 06.20.30.750000000 AM','DD-MON-RR HH.MI.SSXFF AM'),'Video Toll has been generated');
insert into message values(804,103,to_timestamp('01-JUL-18 06.20.00.750000000 AM','DD-MON-RR HH.MI.SSXFF AM'),'Toll amount has been sent');
insert into message values(805,104,to_timestamp('01-JUL-18 07.00.30.750000000 AM','DD-MON-RR HH.MI.SSXFF AM'),'Toll has been generated');
insert into message values(806,105,to_timestamp('01-JUL-18 07.10.30.750000000 AM','DD-MON-RR HH.MI.SSXFF AM'),'Toll has been generated');
insert into message values(807,101,to_timestamp('01-JUL-18 07.20.30.750000000 AM','DD-MON-RR HH.MI.SSXFF AM'),'Toll has been generated');
insert into message values(808,102,to_timestamp('01-JUL-18 07.30.30.750000000 AM','DD-MON-RR HH.MI.SSXFF AM'),'Toll has been generated');
insert into message values(809,103,to_timestamp('01-JUL-18 07.35.30.750000000 AM','DD-MON-RR HH.MI.SSXFF AM'),'Video Toll has been generated');
insert into message values(810,103,to_timestamp('01-JUL-18 10.00.30.750000000 AM','DD-MON-RR HH.MI.SSXFF AM'),'Toll has been paid');


create table disc_rate
(
disc_rate number,
rate_video_toll number,
admin_fee number
);

/*Insert values in disc_rate*/
insert into disc_rate values(0.9, 1, 3);

commit;
