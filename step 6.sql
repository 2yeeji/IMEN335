set @ticketid=11;

drop procedure if exists addattraction;

delimiter $$
create procedure addattraction(
	in my_ticketid int,
    in my_attraction varchar(5)
    )
begin
	insert into plan(ticket_id,plan_num,attraction_id,status) 
		select my_ticketid,if(count(a.plan_num)=0,1,count(a.plan_num)+1),my_attraction,0 
		from plan a
			inner join attraction b 
			on a.attraction_id=b.attraction_id
			and b.inspectiond_day<>dayofweek(curdate())
		where a.ticket_id = my_ticketid;
	select * from plan where ticket_id=@ticketid;
end $$    
delimiter ;

select * from plan where ticket_id=@ticketid;
call addattraction(@ticketid,'A3003');