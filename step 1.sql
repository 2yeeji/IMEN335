drop procedure if exists addcart;
drop procedure if exists addcarrier;
drop procedure if exists addcard;
drop procedure if exists addid;

delimiter $$
create procedure addcart(
	in cart_date date,
	out my_cartid int)
begin
	insert into cart(date) values(cart_date);
	select max(cart_id) into my_cartid from cart;
    select * from cart;
end $$

create procedure addcarrier(
	in my_cartid int,
    in my_carrier varchar(5))
begin
	declare my_carrierid varchar(5);
    case
		when left(my_carrier,1) = 'K' then set my_carrierid = 'DC201';
        when left(my_carrier,1) = 'S' then set my_carrierid = 'DC202';
        when left(my_carrier,1) = 'L' then set my_carrierid = 'DC203';
		else select '통신사 할인이 적용되지 않는 통신사입니다.';
	end case;
	UPDATE cart SET carrier_id = my_carrierid WHERE (cart_id = my_cartid);
	select * from cart where cart_id = my_cartid;
end $$    

create procedure addcard(
	in my_cartid int,
    in my_card varchar(5))
begin
	declare my_cardid varchar(5);
    case
		when left(my_card,2) = '삼성' then set my_cardid = 'DC101';
        when left(my_card,2) = '롯데' then set my_cardid = 'DC102';
		else select '제휴카드 할인이 적용되지 않는 카드입니다.';
	end case;
	UPDATE cart SET card_id = my_cardid WHERE (cart_id = my_cartid);
	select * from cart where cart_id = my_cartid;
end $$
    
create procedure addid(
	in my_cartid int,
    in my_memberid varchar(5))
begin
	UPDATE cart SET member_id = my_memberid WHERE (cart_id = my_cartid);
	select * from cart where cart_id = my_cartid;    
end $$
    
delimiter ;

SELECT * FROM cart;
call addcart(curdate(),@cartid);
-- SELECT @cartid;
call addcarrier(@cartid,'SKT');
call addcard(@cartid,'삼성카드');
call addid(@cartid,'mskim');