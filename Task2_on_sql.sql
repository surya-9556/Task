--1
select * from stores
select * from authors
sp_help authors
sp_help titles
sp_help sales
select * from publishers
select * from titles
select * from sales

select city,count(*) from authors group by city

--2
select distinct city,au_fname from authors where city not in
(select city from publishers where pub_name = 'New Moon Books')


--3
create proc NameAndMoneies(@au_fname varchar(20),@au_lname varchar(40),@price money)
as 
	begin
		update titles set price = @price
		select au_fname,au_lname,price,title from authors,titles where au_fname = @au_fname
end

exec NameAndMoneies  Johnson,White,20.5

--4
create function taxb(@qty varchar(10))
returns @FinalTable table(title_id varchar(10),tax varchar(10))
as
begin
	declare
	@title_id varchar(10),
	@tax varchar(10),
	@qty1 int
	set @qty1 = (select distinct qty from sales where ord_num=@qty)
		if(@qty1 < 10)
			set @tax = '2%'
		else if(@qty1 >= 10 and @qty1 <= 20)
			set @tax = '5%'
		else if(@qty1 >= 20 and @qty1 <= 30)
			set @tax = '6%'
		else
			set @tax = '7.5%'
		set @title_id = (select title_id from sales where ord_num=@qty)
		insert into @FinalTable values(@title_id,@tax) 

	return
end

select title_id,tax from dbo.taxb('QA7442.3')