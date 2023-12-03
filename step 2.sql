drop procedure if exists addticket;

delimiter $$
create procedure addticket(
	in my_cart_id int,
    in my_name varchar(5),
    in my_age int,
    in my_height int,
    in my_timerange varchar(1))
begin
	declare my_ticketcode varchar(3);
    declare my_agecode varchar(1);
    case
		when my_age <= 13 then set my_agecode='3';
        when my_age between 14 and 19 then set my_agecode='2';
        else set my_agecode='1';
	end case;
    set my_ticketcode = concat(my_timerange,my_agecode);
	insert into ticket(cart_id, name, age, height, ticket_code)
		values (my_cart_id, my_name, my_age, my_height, my_ticketcode);
	select * from ticket where cart_id=my_cart_id;
end $$
delimiter ;

select * from ticket;
call addticket(@cartid,'김철수',20,180,'A');
call addticket(@cartid,'김민수',20,175,'A');
