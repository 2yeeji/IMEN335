-- 장바구니에 담긴 총 가격 출력
select sum(I.price) as 'total price'
from ticket T 
	inner join ticket_info I
	on T.ticket_code=I.ticket_code
where cart_id=@cartid;

-- 최대 할인율 출력
select max(dc_rate) from (	
    (select D.dc_rate from cart C 
		inner join card_dc D 
		on C.card_id=D.card_id
		where C.cart_id=@cartid) 
	union
	(select E.dc_rate from cart C 
		inner join carrier_dc E
		on C.carrier_id=E.carrier_id
		where C.cart_id=@cartid))X;
     
-- 총 결제금액 확인
     
drop procedure if exists totalprice;

delimiter $$
create procedure totalprice(
	in my_cartid int)
begin 
	select dc as '최종 할인율',round((1-dc)*p) as '결제금액' from
	(select max(dc_rate) dc from (	
		(select D.dc_rate from cart C 
			inner join card_dc D 
			on C.card_id=D.card_id
			where C.cart_id=my_cartid) 
		union
		(select E.dc_rate from cart C 
			inner join carrier_dc E
			on C.carrier_id=E.carrier_id
			where C.cart_id=my_cartid))X)Y,
	(select sum(I.price) p 
		from ticket T 
			inner join ticket_info I
			on T.ticket_code=I.ticket_code
		where cart_id=my_cartid)Z;
end $$
delimiter ;

call totalprice(@cartid);