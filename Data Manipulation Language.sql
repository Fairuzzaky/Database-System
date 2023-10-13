/*
2502024836 - MUHAMMAD FAIRUZZAKY
2502023991 - NATASYA AUTARIA
2502041640 - ANAS SYAHREFI SATYAKUSUMA
2502024331 - MUHAMMAD ALIF ZAFUTRA
*/

--1.
select ms.CustomerID, UPPER(CustomerName) CustomerName, QuantityP as TotalItemsBought
from MsCustomer ms join ProductTransaction pt on pt.CustomerID = ms.CustomerID 
where year (PTransactionDate) = 2021
and year (CustomerBirtDate)  = 2001

--2.
Select distinct Count (pt.PTransactionID) as PTransactionID , mp.ProductID, ProductName, CategoryName as ProductCategoryName from 
MsProductCategory mpc join MsProduct mp on
mpc.CategoryID = mp.CategoryID join ProductTransactionDetail ptd 
on mp.ProductID = ptd.ProductID join ProductTransaction pt 
on ptd.PTransactionID = pt.PTransactionID 
where year (pt.PTransactionDate) = 2020 
group by mp.ProductID, ProductName, CategoryName 
Having count (pt.PTransactionID) > '1'



--3. 
select distinct mp.ProductID, UPPER (ProductName) AS ProductName, SUM (ProductPrice * ptd.QuantityP) as Income,
COUNT (ptd.PTransactionID) as TotalTransaction from MsProductCategory mpc JOIN MsProduct mp
ON mpc.CategoryID = mp.CategoryID JOIN ProductTransactionDetail ptd
ON mp.ProductID = ptd.ProductID JOIN ProductTransaction pt
on ptd.PTransactionID = pt.PTransactionID
WHERE CategoryName = 'Mouse' or CategoryName = 'Keyboard'
AND ProductName LIKE '%gaming%'
group by mp.ProductID, ProductName
order by Income DESC



--4.
SELECT ms.StaffID, StaffName, LEFT (StaffEmail,CHARINDEX ('@', StaffEmail )) as 'Username', COUNT (ptd.PTransactionID) as 'Total Transaction',
SUM (mp.ProductPrice * ptd.QuantityP) as MoneySpend
FROM MsStaff ms JOIN ProductTransaction pt 
ON ms.StaffID = pt.StaffID join ProductTransactionDetail ptd 
ON pt.PTransactionID = ptd.PTransactionID JOIN MsProduct mp
ON ptd.ProductID = mp.ProductID
WHERE StaffGender = 'Male'
AND YEAR (PTransactionDate) = 2019
Group by ms.StaffID, StaffName, StaffEmail

--5.

select CAST (VendorName as varchar) + RIGHT (mv.VendorID,3) as VendorNameID, 
VendorTelpNo as VendorPhone, YEAR (VendorBirthdate) as YearOfBirth 
from MsVendor mv join ComponentTransaction ct on
mv.VendorID = ct.VendorID join ComponentTransactionDetail ctd on
ct.CTransactionID = ctd.CTransactionID join MsComponent mc on
ctd.ComponentID = mc.ComponentID ,
(
  select TransactionCount = Count(CTransactionID)
	from ComponentTransaction
 )as tc
where VendorGender = 'Female'  and ct.QuantityC > 60
group by VendorName, mv.VendorID, VendorTelpNo, VendorBirthdate, TransactionCount
ORDER BY TransactionCount DESC



--6.
select distinct mc.ComponentID,
Left (ComponentDescription,1) as ComponentKeyword 
from MsComponent mc join ComponentTransactionDetail ctd on mc.ComponentID = ctd.ComponentID
join ComponentTransaction ct on ctd.CTransactionID = ct.CTransactionID,
(
		SELECT Average = AVG(ComponentPrice)
		FROM MsComponent
) as alias
where mc.ComponentPrice * ctd.QuantityC > alias.Average
and year (CTransactionDate) = 2020


--7.
select right(mp.ProductID,3) + left(ProductName,3) as ProductIdentifier,
Cast (ProductWeight as varchar) + ' Kg' as ProductWeight, ProductPrice,
COUNT (pt.QuantityP) as TotalQTY
from MsProduct mp  join ProductTransactionDetail ptd on
ptd.ProductID = mp.ProductID join ProductTransaction pt on
ptd.PTransactionID = pt.PTransactionID,
(
	SELECT [AverageCount] = AVG(counting.TransactionCount)
	FROM (
		SELECT 
		[ProductIdentifier] = SUBSTRING(mp.ProductID, 3, 3) + LEFT(ProductName, 3), 
		productWeight, 
		ProductPrice, 
		[TransactionCount] = COUNT (PTransactionID)
		FROM MsProduct mp JOIN ProductTransactionDetail ptd
		ON mp.ProductID = ptd.ProductID
		GROUP BY  SUBSTRING(mp.ProductID, 3, 3) + LEFT(ProductName, 3), productWeight, ProductPrice
		) counting
	) average 
where year (PTransactionDate) > 2019 
group by mp.ProductID, ProductName, ProductWeight, ProductPrice,
average.AverageCount
having COUNT (pt.PTransactionID) > average.AverageCount

--8
Select distinct CustomerName, [EmailProvider] = 
Right (CustomerEmail, 9 ) from MsCustomer mc join ProductTransaction pt
on mc.CustomerID = pt.CustomerID join ProductTransactionDetail ptd 
on pt.PTransactionID = ptd.PTransactionID join MsProduct mp on
mp.ProductID = ptd.ProductID,
(
select AVERAGE =  AVG (QuantityP) 
from ProductTransaction
) as alias
where pt.QuantityP > alias.AVERAGE
and CustomerGender = 'Male' 

--9.
Create view StaffCompactView as 
select distinct ms.StaffID, StaffName, replace (StaffTelpNo, '0', '+62') as StaffPhone, year (StaffBirthdate) as YearOfBirth,
SUM (ProductPrice * ptd.QuantityP) as Earning, COUNT (ptd.PTransactionID) as TotalTransaction  from MsStaff ms join ProductTransaction pt
on ms.StaffID = pt.StaffID join ProductTransactionDetail ptd on
pt.PTransactionID = ptd.PTransactionID join MsProduct mp on
ptd.ProductID = mp.ProductID
where StaffGender = 'Female'and ProductWeight > 0 
group by ms.StaffID, StaffName, StaffTelpNo, StaffBirthdate

select * from StaffCompactView

--10.
Create view CustomerFLView as
SELECT mc.CustomerID, LOWER(CustomerName) AS CustomerName ,
MIN (PTransactionDate) as FirstTransaction, MAX (PTransactionDate) as
LastTransaction
FROM MsCustomer mc JOIN ProductTransaction pt
ON mc.CustomerID = pt.CustomerID join MsStaff ms 
on pt.StaffID = ms.StaffID
WHERE (CustomerName like '% %') 
AND StaffSalary > 7000000
group by mc.CustomerID, CustomerName
ORDER BY CustomerName ASC

select * From CustomerFLView
