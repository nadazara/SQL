/*

cleaning data

*/
-- standaralize data format 
select *
from dbo.Housing

SELECT SaleDate
from dbo.Housing

update dbo.Housing
set SaleDate = convert(date,SaleDate)

alter table dbo.Housing
add saledateconverted date ;

update dbo.Housing
set saledateconverted = convert(Date,SaleDate)

SELECT saledateconverted
from dbo.Housing
--notice format date change to standerd



--populate property address

select PropertyAddress
from dbo.Housing

select PropertyAddress
from dbo.Housing
where PropertyAddress is null;

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress) as samepropertyaddress
from dbo.Housing a
join dbo.Housing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null;

update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from dbo.Housing a
join dbo.Housing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null;

--breaking out Address into (address ,city, status)

select PropertyAddress
from dbo.Housing 


select
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress) -1) as address
,SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) +1 , LEN(PropertyAddress)) as city

from  dbo.Housing



alter table dbo.Housing
add PropertySplitAsddress nvarchar(150);


update dbo.Housing
set PropertySplitAsddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress) -1) 



alter table dbo.Housing
add PropertySplitcity nvarchar(50);

update dbo.Housing
set PropertySplitcity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) +1 , LEN(PropertyAddress)) 

--Check
select PropertySplitAsddress
from dbo.Housing

select PropertySplitcity
from dbo.Housing 


--Breaking out owner address
 select OwnerAddress
 from dbo.Housing

 select 
  PARSENAME(REPLACE(OwnerAddress  ,',','.') , 3)
 , PARSENAME(REPLACE(OwnerAddress,',','.') , 2)
 , PARSENAME(REPLACE(OwnerAddress ,',','.') , 1)
 from dbo.Housing

 alter table dbo.Housing
 add ownersplitAddress nvarchar(150);

 update dbo.Housing
 set  ownersplitAddress =   PARSENAME(REPLACE(OwnerAddress  ,',','.') , 3)


 alter table dbo.Housing
 add ownersplitcity nvarchar(150);

 update dbo.Housing
 set  ownersplitcity =   PARSENAME(REPLACE(OwnerAddress  ,',','.') , 2)


 alter table dbo.Housing
 add ownersplitstatus nvarchar(150);

 update dbo.Housing
 set  ownersplitstatus =   PARSENAME(REPLACE(OwnerAddress  ,',','.') , 1)

  -- change Y and N to YSE and NO in SoldAsVacant

  select Distinct(SoldAsVacant),count(SoldAsVacant)
  from dbo.Housing
  group by SoldAsVacant

  select 
  case when SoldAsVacant =  'Y' then 'Yes'
       when SoldAsVacant =  'N' then 'NO' 
	   else SoldAsVacant
       end
  from dbo.Housing



  update  dbo.Housing
  set SoldAsVacant = case when SoldAsVacant =  'Y' then 'Yes'
       when SoldAsVacant =  'N' then 'NO' 
	   else SoldAsVacant
       end



  -- Remove Duplicates values  

  select *
  from dbo.Housing



  WITH CTE as (
  select  * ,
  ROW_NUMBER() over (
  partition by ParcelID ,
               SalePrice , saledateconverted,
			   propertySplitAsddress
			   order by 
			   UniqueID) row_num

  from dbo.Housing
  )

   select* 
   from CTE
   where row_num >1
   order by ParcelID 


   delete 
   from CTE
   where row_num >1
  

  -- Delete unused columns
    
	select * 
	from dbo.Housing

	alter table dbo.Housing
	drop column PropertyAddress ,SaleDate,OwnerAddress


