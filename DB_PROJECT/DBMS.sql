CREATE TABLE train(
    train_num INTEGER NOT NULL,
    dtofj DATE NOT NULL,
    AC_coach INTEGER,
    SL_coach INTEGER,
    AC_seat_booked INTEGER,
    SL_seat_booked INTEGER,

    PRIMARY KEY(train_num,dtofj)
);


CREATE TABLE ticket(
    pnr INTEGER NOT NULL,
    train_num INTEGER NOT NULL,
    dtofj DATE NOT NULL,
    pname varchar(100),
    berth_type varchar(2),
    berth_num INTEGER NOT NULL,
    coach_num INTEGER NOT NULL,
    coach_type varchar(2),
    PRIMARY KEY(pnr,train_num,dtofj,berth_num,coach_num),
    FOREIGN KEY(train_num,dtofj) REFERENCES train(train_num,dtofj)
);






--

CREATE OR REPLACE FUNCTION public.reservation(
	IN no_of_pass integer,
	IN names_p character varying[],
	IN train_numb integer,
	IN doj date,
	IN coach character varying
	)
	
RETURNS INT 
LANGUAGE 'plpgsql'
AS $BODY$
declare


pnr_in int;
chk_pnr int;
chk int;
curr_sl_book_seat int;
curr_sl_coach int;
curr_sl_rem_seat int;
sl_tot_seat int;
curr_sl_seat int;
curr_ac_book_seat int;
curr_ac_coach int;
curr_ac_rem_seat int;
ac_tot_seat int;
curr_ac_seat int;
berth_t varchar(2);


begin

 
 chk=0;

  curr_sl_book_seat=(select SL_seat_booked from train where train_numb=train.train_num and doj=train.dtofj);
  curr_ac_book_seat=(select AC_seat_booked from train where train_numb=train.train_num and doj=train.dtofj);
  ac_tot_seat=(select AC_coach from train where train_numb=train.train_num and doj=train.dtofj);
  sl_tot_seat=(select SL_coach from train where train_numb=train.train_num and doj=train.dtofj);
  
  ac_tot_seat=ac_tot_seat*18;
  sl_tot_seat=sl_tot_seat*24;
  
  curr_ac_rem_seat=ac_tot_seat-curr_ac_book_seat;
  curr_sl_rem_seat=sl_tot_seat-curr_sl_book_seat;
 
  
  curr_ac_seat=((ac_tot_seat-curr_ac_rem_seat)%18)+1;
  curr_ac_coach=((ac_tot_seat-curr_ac_rem_seat)/18)+1;
  curr_sl_seat=((sl_tot_seat-curr_sl_rem_seat)%24)+1;
  curr_sl_coach=((sl_tot_seat-curr_sl_rem_seat)/24)+1; 
 
 
 
 
 if(not exists(select train_num from train where train_numb=train.train_num and doj=train.dtofj) or not exists(select dtofj from train where train_numb=train.train_num and doj=train.dtofj))
 then
 return 0;
 end if;
 


--insert in tickets

 --for train_row IN select * from train where train_numb=train.train_num and doj=train.dtofj
 --LOOP
 if(exists(select train_num from train where train_numb=train.train_num and doj=train.dtofj))then
 
 if((coach = 'SL' and curr_sl_rem_seat>=no_of_pass) or (coach= 'AC' and curr_ac_rem_seat>=no_of_pass)) then
 
 
 --pnr generation
 pnr_in:=(select floor(random()*(99999999-9999999+1)+9999999))::int;
 
 for chk_pnr IN select pnr from ticket where train_numb=ticket.train_num and doj=ticket.dtofj
 loop
 if(chk_pnr=pnr_in)then
 pnr_in:=(select floor(random()*(99999999-9999999+1)+9999999))::int;
 end if;
 end loop;
 
 

 --update train seats
 --AC coach
  if(coach='AC')then
  update train
  set AC_seat_booked=AC_seat_booked+no_of_pass
  where train_numb=train.train_num and doj=train.dtofj;
  
  
  for i in 1..no_of_pass
 loop
 
 if(curr_ac_seat%6=0)then 
 berth_t='SU';end if;
 if(curr_ac_seat%6=1 or curr_ac_seat%6=2 )THEN
 berth_t='LB';end if;
 if(curr_ac_seat%6=3 or curr_ac_seat%6=4 )THEN
 berth_t='UB';end if;
 if(curr_ac_seat%6=5)then
 berth_t='SL';end if;
 

 insert into ticket(pnr,train_num,dtofj,pname,berth_type,berth_num,coach_num,coach_type) values(pnr_in,train_numb,doj,names_p[i],berth_t,curr_ac_seat,curr_ac_coach,coach);
 curr_ac_seat=curr_ac_seat+1;
 if(curr_ac_seat=19)THEN
 curr_ac_seat=1;
 curr_ac_coach=curr_ac_coach+1;
 end if;

 end loop;
 end if;
  
  
  --SL coach
  
 if(coach='SL')then
   update train
  set SL_seat_booked=SL_seat_booked+no_of_pass
  where train_numb=train.train_num and doj=train.dtofj;
  
  
  for i in 1..no_of_pass
 loop
 
  if(curr_sl_seat%8=0)then
  berth_t='SU';end if;
  if(curr_sl_seat%8=1 or curr_sl_seat%8=4)then
  berth_t='LB';end if;
  if(curr_sl_seat%8=2 or curr_sl_seat%8=5)then
  berth_t='MB';end if;
  if(curr_sl_seat%8=3 or curr_sl_seat%8=6)then
  berth_t='UB';end if;
  if(curr_sl_seat%8=7)then
  berth_t='SL';
  end if;
 

 insert into ticket(pnr,train_num,dtofj,pname,berth_type,berth_num,coach_num,coach_type) values(pnr_in,train_numb,doj,names_p[i],berth_t,curr_sl_seat,curr_sl_coach,coach);
  curr_sl_seat=curr_sl_seat+1;
 if(curr_sl_seat=25)THEN
 curr_sl_seat=1;
 curr_sl_coach=curr_sl_coach+1;
 end if; 

 end loop;
 end if;

 chk=1;
 end if;
 end if;
 
 
 
if(chk=0)then
return 1; 
end if;

if(chk=1)then 
return 2;
end if;


 end;
$BODY$;
ALTER FUNCTION public.reservation(integer, character varying[], integer, date, character varying)
    OWNER TO postgres;












