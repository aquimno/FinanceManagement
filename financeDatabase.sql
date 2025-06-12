create schema financeProject;
use financeProject;

create table users(
	id 			integer 		primary key auto_increment,
    username 	varchar(20) 	not null unique,
    userpass 	varchar(255) 	not null
);

create table category(
	id 		int 			primary key auto_increment,
    def		varchar(20)		not null
);

create table transactions(
	id 			integer 		primary key auto_increment,
    userID		integer			not null,
    tDate 		date 			not null,
    amount 		numeric(9, 2)	not null,
    categoryID	int				not null,
    description	varchar(250),
    type varchar(10) check(type in ('income', 'expense')) not null,
    foreign key (userID) references users(id),
    foreign key (categoryID) references category(id)
);

DELIMITER $$
create procedure RegisterUser(
	IN inUsername	varchar(20),
    IN inPassword	varchar(255)
)
Begin
	insert into users (username, userpass) values (inUsername, inPassword);
End$$
Delimiter ;

DELIMITER $$
create procedure LoginUser(
	IN inUsername	varchar(20),
    IN inPassword	varchar(255),
    OUT outID		int
)
Begin
	Select id into outID from users where username = inUsername and userpass = inPassword;
End$$
Delimiter ;

DELIMITER $$
create procedure AddTransaction(
	IN inTransID	int,
	IN inUserID		int,
    IN inTDate		date,
    IN inAmount		numeric(9, 2),
    IN inCategoryID	int,
    IN inType			varchar(10),
    IN inDescription	varchar(250)
)
Begin
	insert into transactions (id, userID, tDate, amount, CategoryID, type, description) 
    values (inTransID, inUserID, inTDate, inAmount, inCategoryID, inType, inDescription);
End$$
Delimiter ;

Delimiter $$
create procedure DeleteTransaction(
	IN inTransID	int,
    IN inUserID		int
)
Begin
	delete from transactions where userID = inUserID and id = inTransID;
End$$
Delimiter ;

Delimiter $$
create procedure UpdateTransaction(
	IN inTransID	int,
	IN inUserID		int,
    IN inTDate		date,
    IN inAmount		numeric(9, 2),
    IN inCategoryID	int,
    IN inType			varchar(10),
    IN inDescription	varchar(250)
)
Begin
	update transactions
    set tDate = inTDate,
		amount = inAmount,
		categoryID = inCategoryID,
        type = inType,
        description = inDescription
	where userID = inUserID and id = inTransID;
End$$
Delimiter ;

Delimiter $$
create procedure GetTransactionByUser(
	IN inUserID		int
)
Begin
	select t.id, t.tDate, t.amount, c.def as category, t.type, t.description
    from transactions t join category c on c.id = t.categoryID
    where userID = inUserID
    order by t.tDate desc;
End$$
Delimiter ;

Delimiter $$
create procedure GetTransactionByMonth(
	IN inUserID		int,
    IN inYear		int,
    IN inMonth		int
)
Begin
	select t.id, t.tDate, t.amount, c.def as category, t.type, t.description
    from transactions t join category c on c.id = t.categoryID
    where userID = inUserID and year(t.tDate) = inYear and month(t.tDate) = inMonth
    order by t.tDate desc;
End$$
Delimiter ;

DELIMITER $$
create procedure MonthlyExpenses(
	IN inUserID int,
	IN inYear 	int,
    IN inMonth int
)
Begin
	Select transactions.categoryID, sum(amount) as total
    from transactions left join category on category.id = transactions.categoryID
    where type = "expense" and userID = inUserID
    and year(tDate) = inYear and month(tDate) = inMonth
    group by transactions.categoryID;
End$$
Delimiter ;

DELIMITER $$
create procedure MonthlyIncome(
	IN inYear 	int,
    IN inMonth int,
    In inUserID int
)
Begin
	Select sum(amount) as totalIncome from transactions 
    where type = "income" and userID = inUserID 
    and month(tDate) = inMonth and year(tDate) = inYear and category; 
End$$
Delimiter ;

Delimiter $$
create procedure MonthlyNetBalance(
	IN inUserID		int
)
Begin
	select
		coalesce(sum(case when type = "income" then amount else 0 end), 0) - 
		coalesce(sum(case when type = "expense" then amount else 0 end), 0)
		as net_balance from transactions
    where userID = inUserID
    and year(tDate) = inYear and month(tDate) = inMonth;
End$$
Delimiter ;

Delimiter $$
create procedure CategoryBreakdown(
	IN inUserID		int
)
Begin
	select c.def as category, sum(t.amount) as total 
    from transactions t
    join category c on c.id = t.categoryID
    where t.userID = inUserID
    group by c.def order by total desc;
End$$
Delimiter ;

Delimiter $$
create procedure yearlySummary(
	IN inUserID		int,
    IN inYear		int
)
Begin
	select
		month(tDate) as month,
        coalesce(sum(case when type = "income" then amount else 0 end), 0) as totalIncome,
        coalesce(sum(case when type = "expense" then amount else 0 end), 0) as totalExpense,
        coalesce(sum(case when type = "income" then amount else 0 end), 0) -
        coalesce(sum(case when type = "expense" then amount else 0 end), 0) as netBalance
	from transactions
    where userID = inUserID
    and year(tDate) = inYear
    group by month(tDate) order by month(tDate);
End$$
Delimiter ;