select * from (
select U.ticket_id, T.attraction_from, T.attraction_to, time travel_time,
	if(mid(T.attraction_to,3,1)=0,
        	if(
			dayofweek(curdate())<>V.inspectiond_day,
			concat(round(
			     (1+V.waiting/V.max_available)/V.opnumph*60),'min'),
			'점검일'),
		0) as 'waiting_time'
from traveltime T
	inner join 
		(select P.ticket_id, P.attraction_id f, Q.attraction_id t
		from plan P 
			inner join plan Q
			on P.ticket_id=Q.ticket_id
			and P.plan_num+1=Q.plan_num
            -- and Q.status=0
			order by P.ticket_id
            ) U
	on T.attraction_from=U.f
	and T.attraction_to=U.t
	left outer join 
		(select A.attraction_id, A.max_available, A.opnumph,
 			A.inspectiond_day, W.waiting 
        	from attraction A 
			inner join attraction_waiting W 
			on A.attraction_id=W.attraction_id) V
	on T.attraction_to=V.attraction_id
	and U.t=V.attraction_id
where ticket_id=@ticketid) A1
union
(
select @ticketid ticket_id, plan.attraction_id attraction_from, null attraction_to, time(0) travel_time, 
	if(mid(plan.attraction_id,3,1)=0,
		if(
		dayofweek(curdate())<>V.inspectiond_day,
		concat(round(
			 (1+V.waiting/V.max_available)/V.opnumph*60),'min'),
		'점검일'),
	0) as 'waiting_time'
from plan, (select A.attraction_id, A.max_available, A.opnumph,
 			A.inspectiond_day, W.waiting 
        	from attraction A 
			inner join attraction_waiting W 
			on A.attraction_id=W.attraction_id) V
where ticket_id=@ticketid
and V.attraction_id = plan.attraction_id
and plan_num=(select max(plan_num) from plan where ticket_id=@ticketid and plan.status=0));