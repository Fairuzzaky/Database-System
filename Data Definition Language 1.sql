
create database GamingStore
use GamingStore

create table MsStaff (
	StaffID char (5) primary key not null,
	check(staffID like 'ST[0-9][0-9][0-9]'),
	StaffName varchar(100) not null,
	StaffEmail varchar(100) not null,
	check(StaffEmail like '%gmail.com' or StaffEmail like '%yahoo.com'),
	StaffTelpNo varchar (15) not null,
	StaffBirthdate date not null,
	StaffGender varchar(100) not null,
	check(StaffGender = 'Male' or StaffGender = 'Female'),
	StaffAdress varchar(1000) not null,
	check(StaffAdress like '% %' ),
	StaffSalary int not null
)

create Table MsComponent (
	ComponentID char (5) primary key not null,
	check(ComponentID like 'CO[0-9][0-9][0-9]'),
	ComponentName varchar(100) not null,
	ComponentDescription varchar(1000) not null,
	ComponentPrice int not null,
	check (ComponentPrice > 5000)
)

create table MsVendor (
	VendorID char (5) primary key not null,
	check(VendorID like 'VE[0-9][0-9][0-9]'),
	VendorName varchar(100) not null,
	check(len (VendorName) > 3),
	VendorEmail varchar(100) not null,
	check(VendorEmail like '%gmail.com' or VendorEmail like '%yahoo.com'),
	VendorTelpNo varchar (15) not null,
	VendorBirthdate date not null,
	VendorGender varchar(100) not null,
	check(VendorGender = 'Male'  or VendorGender = 'Female'),
	VendorAdress varchar(1000) not null,
)

create table ComponentTransaction ( 
		CTransactionID char(5) primary key not null,
		check(CTransactionID like 'CT[0-9][0-9][0-9]'),
		StaffID char (5) foreign key references MsStaff(StaffID) not null,
		VendorID char(5) foreign key references MsVendor(VendorID) not null,
		CTransactionDate date not null,
		ComponentID char (5) not null,
		QuantityC int not null,
		check (QuantityC > 0)
)

create table ComponentTransactionDetail(
		CTransactionID char (5)  foreign key references ComponentTransaction(CTransactionID) not null,
		ComponentID char (5) foreign key references MsComponent(ComponentID) not null,
		QuantityC  int not null
		check (QuantityC > 0),
)


create Table MsProduct (
	ProductID char (5) primary key not null,
	check(ProductID like 'PR[0-9][0-9][0-9]'),
	CategoryID char (5) foreign key references MsProductCategory(CategoryID) not null,
	ProductName varchar (100) not null,
	ProductDescription Varchar (1000) not null,
	productWeight int not null,
	check(ProductWeight between 1 and 40),
	ProductPrice int not null,
	check(ProductPrice > 5000)
)

create table MsProductCategory(
		CategoryID char (5) primary key not null,
		check(CategoryID like 'PC[0-9][0-9][0-9]'),
		CategoryName varchar(100) not null
)

create table MsCustomer  (
	CustomerID char (5)Primary key not null,
	check(CustomerID like 'CU[0-9][0-9][0-9]'),
	CustomerName varchar (100) not null,
	check(len (CustomerName) > 3),
	CustomerEmail varchar (100) not null,
	check(CustomerEmail like '%gmail.com'  or CustomerEmail like '%yahoo.com'),
	CustomerTelpNo varchar (15) not  null,
	check(CustomerTelpNo like '+62%'),
	CustomerBirtDate date not null,
	CustomerGender varchar (100) not null,
	check(CustomerGender = 'Male'  or CustomerGender = 'Female'),
	CustomerAddress varchar (1000) not null,
	check(CustomerAddress like '% %' )
)

create table ProductTransaction (
	PTransactionID char (5) primary key not null,
	check(PTransactionID like 'PT[0-9][0-9][0-9]'),
	StaffID char (5) foreign key references MsStaff(StaffID) not null,
	CustomerID char(5)foreign key references MsCustomer(CustomerID) not null,
	PTransactionDate date  not null,
	ProductID char(5) foreign key references MsProduct(ProductID) not null,
	QuantityP int not null
	check (QuantityP > 0)
)

create table ProductTransactionDetail(
		PTransactionID char (5)  foreign key references ProductTransaction(PTransactionID) not null,
		ProductID char (5) foreign key references MsProduct(ProductID) not null,
		QuantityP  int not null
		check (QuantityP > 0),
)