select t+u total, A2.isinsp+A1.isInsp inspection from
(
select sum(time)+sum(waiting_time) t
,sum(if(idy=dayofweek(curdate()),-1,0)) isInsp
from
(select U.ticket_id, T.attraction_from, T.attraction_to, minute(time) time,
	if(mid(T.attraction_to,3,1)=0,
		round((1+V.waiting/V.max_available)/V.opnumph*60),
		0) as 'waiting_time',
        V.inspectiond_day idy
from traveltime T
	inner join 
		(select P.ticket_id, P.attraction_id f, Q.attraction_id t
		from plan P 
			inner join plan Q
			on P.ticket_id=Q.ticket_id
			and P.plan_num+1=Q.plan_num
			and Q.status=0
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
where ticket_id=@ticketid)B
) A1,
(
select
	if(mid(plan.attraction_id,3,1)=0,
		if(
		dayofweek(curdate())<>V.inspectiond_day,
		concat(round(
			 (1+V.waiting/V.max_available)/V.opnumph*60),'min'),
		'점검일'),
	0) as u, if(V.inspectiond_day=dayofweek(curdate()),-1,0) isinsp
from plan, (select A.attraction_id, A.max_available, A.opnumph,
 			A.inspectiond_day, W.waiting 
        	from attraction A 
			inner join attraction_waiting W 
			on A.attraction_id=W.attraction_id) V
where ticket_id=@ticketid
and V.attraction_id = plan.attraction_id
and plan_num=(select max(plan_num) from plan where ticket_id=@ticketid and plan.status=0)) A2
;