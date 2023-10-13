/*
2502024836 - MUHAMMAD FAIRUZZAKY
2502023991 - NATASYA AUTARIA
2502041640 - ANAS SYAHREFI SATYAKUSUMA
2502024331 - MUHAMMAD ALIF ZAFUTRA
*/



-- SIMULATE COMPONENT TRANSAKSI PROCESS

--1.
/*
Staff mencari dan melihat list komponen barang yang dibutuhkan melalui vendor
*/

SELECT ComponentID, ComponentName, ComponentDescription , ComponentPrice
from MsComponent
ORDER BY ComponentPrice ASC

--2.
/*
Jika daftar list komponen telah tersedia, maka Staff akan melakukan pemesanan 
dan mengisi data pribadi vendor yang akan dihubungi 
*/
INSERT INTO MsVendor  VALUES
('VE011', 'Eduardo', 'Edward@gmail.com', '081209876504', '1998-11-03' ,'Male', 'Jalan Tegal Parang No 4K')

--3. 
/*
Jika vendor telah dihubungi, maka vendor akan memberikan bill / struk kepada staff yang berisi
Daftar komponen beserta harga komponen yang dibeli lalu staff akan memasukkan 
data-data ke dalam table transaksi komponen
*/
INSERT INTO ComponentTransaction VALUES
('CT016','ST006', 'VE011', '2022-09-26', 'CO007', '40')

SELECT distinct CTransactionID, CTransactionDate,
		VendorID,
		VendorName = MsVendor.VendorName,
		VendorPhone = MsVendor.VendorPhone,
		VendorAddress = MsVendor.VendorAdress, 
		StaffID,
		StaffName = MsStaff.StaffName,
		StaffPhone = MsStaff.StaffPhone,
		ComponentID, 
		ComponentName,
		ComponentPrice , 
		TotalPay = ComponentPrice * QuantityC
FROM ComponentTransaction,
(
	SELECT [StaffName] = StaffName,
			[StaffPhone] = StaffTelpNo
	FROM MsStaff
	WHERE StaffID = 'ST006'
) MsStaff,
(
	SELECT [VendorName] = VendorName, 
	[VendorPhone] = VendorTelpNo,
	[VendorAdress] = VendorAdress 
	FROM MsVendor
	WHERE VendorID = 'VE011'
) MsVendor,
(
	SELECT [ComponentName] = ComponentName,
			[ComponentPrice] = ComponentPrice
	FROM MsComponent
	WHERE ComponentID = 'CO007'
) MsProduct
where CTransactionID = 'CT016'

--4. 
/*
Kemudian, Staff akan memasukkan hasil data pembelian ke dalam table 
detail transaksi Untuk memasukkan rincian pembelian komponen 
*/

INSERT INTO ComponentTransactionDetail Values
('CT016', 'CO007', '40')




-- SIMULATE PRODUCT TRANSACTION PROCESS 
--1
/*
Customer datang ke toko lalu melihat list category serta produk yang tersedia, dimulai
dari harga terendah
*/

SELECT CategoryName,ProductName, ProductDescription, Cast (ProductWeight as varchar) + 'Kg' as ProductWeight, ProductPrice
FROM MsProduct mp join MsProductCategory mpc on mp.CategoryID = mpc.CategoryID 
ORDER BY ProductPrice DESC

--2
/*
Jika Customer berminat membeli produk tersebut maka customer akan mengisi 
data pribadi 
*/
INSERT INTO MsCustomer
VALUES ('CU011', 'Jack', 'Jack@gmail.com','+628575398333', '2001-02-01', 'Male', 'Mampang No.18A')
select * from  MsCustomer
--3
/*
Setelah itu Staff akan akan mengisi data yang akan dimasukkan ke dalam transaksi penjualan
*/
INSERT INTO ProductTransaction Values
('PT016','ST006','CU011','2022-09-10','PR008', '1')

--4.
/*
Kemudian Staff akan memberikan rincian pembelian yang akan ditransaksi oleh Customer sesuai dengan harga & kuantitas
produk
*/
SELECT distinct PTransactionID, PTransactionDate,
		StaffID,
		StaffName = MsStaff.StaffName,
		StaffPhone = MsStaff.StaffTelpNo,
		StaffAddress = MsStaff.StaffAdress,CustomerID,
		CustomerName = MsCustomer.CustomerName,
		CustomerPhone = MsCustomer.CustomerPhone,
		ProductID, 
		ProductName = MsProduct.ProductName,
		ProductCategory = MsProductCategory.CategoryName,
		QuantityProduct = QuantityP,
		ProductPrice = MsProduct.ProductPrice,
		TotalPay = MsProduct.ProductPrice * QuantityP
FROM ProductTransaction,
(
	SELECT [CustomerName] = CustomerName,
			[CustomerPhone] = CustomerTelpNo
	FROM MsCustomer
	WHERE CustomerID = 'CU011'
) MsCustomer,
(
	SELECT [StaffName] = StaffName, [StaffTelpNo] = StaffTelpNo,
	[StaffAdress] = StaffAdress 
	FROM MsStaff
	WHERE StaffID = 'ST006'
) MsStaff,
(
	SELECT [ProductName] = ProductName,
			[ProductPrice] = ProductPrice
	FROM MsProduct
	WHERE ProductID = 'PR008'
) MsProduct,
(
	SELECT [CategoryName] = CategoryName
	FROM MsProductCategory
	WHERE CategoryID = 'PC008'
) MsProductCategory
where PTransactionID = 'PT016'

--5.
/*
Kemudian, Staff akan memasukkan hasil data penjualan ke dalam table 
detail transaksi Untuk memasukkan rincian penjualan product 
*/
INSERT INTO ProductTransactionDetail VALUES 
('PT016','PR008', '1')
