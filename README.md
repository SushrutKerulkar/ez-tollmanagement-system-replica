# ez-tollmanagement-system-replica
This database project which is a replica of the EZ-PASS toll management system.

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

NOTES:
1) This project is a replica of the toll management system popular in United States. 
2) For reference you can refer to: Maryland https://www.ezpassmd.com and Virginia https://www.ezpassva.com/
3) Each feature is implemented as one or more Oracle PL/SQL procedures/functions.

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
ASSUMPTIONS:

1.	Ez pass is a RFID device (called transponder) that can be mounted on a vehicle’s windshield and when the vehicle passes a toll 
    antenna the antenna can read the radio signal sent by the transponder and retrieves the transponder ID.
2.	The system needs to store data about accounts. Each account has account id, name of account holder, email, address, 
    balance (pre-paid amount), and password. 
3.	Each account will have a list of transponders. Each transponder has a transponder id Users of the account can use any of the 
    associated transponders. 
4.	The system stores information about vehicles. You can assume that the database has information for all vehicles in US. Each vehicle 
    has a vehicle ID, license plate number, state, class (1 is car, 2 is truck), address of owner, and an optional account id. 
    Only some vehicles will be associated with an account. Others are not because either their owner does not have an ez pass account or 
    the owner has not registered the vehicle with the account. 
5.	When a vehicle passes a toll lane, there are two ways that the system can recognize who should pay for it. The first way is when a 
    transponder is mounted and its signal is received by the antenna. The account associated with that transponder will be charged.
    If this does not happen (e.g., there is no transponder or the transponder malfunctioned), a camera will take a picture of the license 
    plate and the system will use license plate number and state to locate the vehicle. If the vehicle is registered with an account that
    account will be charged. Otherwise the system sends a video toll bill to the owner of the vehicle. The fee for video toll is higher. 
6.	The system stores a discount_rate table which only has one row and three columns: the discount rate for EZ pass, the rate for video 
    toll, and the administrative fee. If the toll rate is $10, and the discount rate for EZ pass is 0.9, the rate for video toll is 1.0 
    and administrative fee is $3. Then the real toll for using ez pass is 10*0.9. The real toll for video toll is $10*1+3=$13. 
7.	The system stores information about toll roads. Each road is a road ID and road name. E.g., I95 or I495. 
8.	Each road has a number of exits. Each exit has a road ID and integer exit number. E.g., exit 143 of road 1. There is also a 
    description of the exit (e.g., junction with 395). The exit numbers may not be continuous, e.g., the exit numbers could be 143, 156,
    161. You can assume that on the same road, every exit number is unique, and these numbers are ordered in a certain direction. 
    E.g., for I95 in Virginia, exit numbers are in increasing order northbound. We use the same exit number for exits on both sides of 
    the road. You can distinguish the direction of the road by the increasing or decreasing order of exit numbers. E.g., if a car enters
    a toll road at exit 143 and leaves at exit 161. The car must be traveling in the increasing order direction. 
9.	The system uses a dynamic toll rate scheme to better manage the traffic. There is a toll_rate table that stores toll rate information
    for every pair of consecutive exits on a toll road for a given direction and at a certain time period. The columns include road id, 
    start exit id (the start exit number), end exit id, direction, toll_start_time, toll_end_time, car toll rate, truck toll rate. For 
    example, suppose a road has three exists: 143, 156, and 161. Suppose a toll is charged from July 30 2018 from 6 am to 8 am on both 
    directions. There should be 4 rows inserted in the toll_rate table for this time period: between exit 143 (as starting exit id) and 
    156 (as ending exit id), between 156 and 161, between 156 and 143 (opposite direction where 156 is start exit id and 143 is end exit
    id), and between 161 and 156 (opposite direction). 
10.	The toll rate for different time/direction can be different. E.g., the toll from exit 143 to 156 (north bound) for road 1 is $2.00 
    from 6 to 10 on that date but is $0.5 for exit 156 to 143 (south bound). 
11.	The system stores trip information, which represents information about a vehicle travels on a toll road at a specific time. The 
    information includes a trip id, account id, transponder id, vehicle ID, road id, entering exit id, exiting exit id, entrance time, 
    toll, status (how the account is looked up), and deducted (whether this toll has been deducted). 
12.	Toll will be computed by adding up tolls for each pair of exits in the range of the entering exit id and exiting exit id at the 
    correct time range and correct direction. 
  a.	The direction is not explicitly stored in trip table, but you can infer it by checking whether entering exit id is greater than 
      exiting exit id. E.g., if a car enters a toll road at exit 143 and leaves at exit 161. The car must be traveling in the increasing
      order direction of the road.
  b.	The entrance time should fall between a toll rate’s start and end time. For example, if a car travels at 7 am on 2018-7-30 from 
      exit 143 to exit 161, and the toll rate table contains two rows where the toll is $2.00 from exit 143 to exit 156 and $1.00 from 
      exit 156 to exit 161 from 6 to 10 am on that date, then the total toll should be $2.00+1.00 =$3.00. 
  c.	The status column in trip table indicates how the vehicle is identified. If status = 1, a valid transponder is used to locate the 
      account, when status = 2, transponder may be missing but the license plate (license and state) can be linked to an account. When 
      status = 3, the license plate can be used to link to a vehicle but not an account (the vehicle owner does not have a ezpass 
      account). When status = 1 or 2, if there is enough balance in the account ez-pass rate will apply. If status = 3 or there is not 
      enough balance video rate will apply (a video toll bill will be sent). 
  d.	The deducted column in trip table indicates whether the toll of this trip has been deducted from account or a video toll bill has 
      been generated. This column can be used to prevent deducting the same trip twice.  
13.	The system needs to store payment to an account, including a payment id, account id, payment date, and amount. 
14.	The system stores video_bill information, including a bill id, bill date, associated trip id, and status. Status = 1 means the bill 
    has been generated but not sent, 2 means it is sent. 3 means it is paid. 
15.	The system stores a message table which has a message id, an account id, a message time and body of the message. 

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
