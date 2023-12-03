select T.ticket_id, T.name, T.age, T.height, I.price
from ticket T
	inner join ticket_info I
	on T.ticket_code=I.ticket_code
	and T.cart_id=@cartid;