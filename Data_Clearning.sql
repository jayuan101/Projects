--Standardize Data Formate
Select *
From PortfoiloProject.dbo.NashvilleHousing


Select SaleDateConverted, CONVERT(Date,SaleDate)
From PortfoiloProject.dbo.NashvilleHousing

Update NashvilleHousing
SET SaleDate= CONVERT (Date,SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted= CONVERT (Date,SaleDate)

Select *
From PortfoiloProject.dbo.NashvilleHousing
--Where PropertyAddress is NULL
Order by ParcelID



--Populate Address data

Select a.ParcelID, a.PropertyAddress,b.ParcelID, b.PropertyAddress ,ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfoiloProject.dbo.NashvilleHousing a
JOIN PortfoiloProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is NULL
	
Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfoiloProject.dbo.NashvilleHousing a
JOIN PortfoiloProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
	--Breakout Property Address
Select PropertyAddress
From PortfoiloProject.dbo.NashvilleHousing
--Where PropertyAddress is NULL
--Order by ParcelID

SELECT 
SUBSTRING (PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as Address
, SUBSTRING (PropertyAddress, CHARINDEX(',',PropertyAddress)+1),LEN(PropertyAddress) as Address
From PortfoiloProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertySpiltAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySpiltAddress = SUBSTRING (PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity =  SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))

SELECT*
From PortfoiloProject.dbo.NashvilleHousing

SELECT OwnerAddress
From PortfoiloProject.dbo.NashvilleHousing
 


 SELECT
 PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
 From PortfoiloProject.dbo.NashvilleHousing




 ALTER TABLE NashvilleHousing
Add OwnerSpiltAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSpiltAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)
--
ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity =  PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)
--
ALTER TABLE NashvilleHousing
Add OnwerSpiltState Nvarchar(255);

Update NashvilleHousing
SET OnwerSpiltState =  PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)




SELECT*
From PortfoiloProject.dbo.NashvilleHousing



--Y and N to Yes and No SoldAsVacant 

SELECT Distinct(SoldAsVacant), COUNT (SoldAsVacant)
From PortfoiloProject.dbo.NashvilleHousing
Group by (SoldAsVacant)
Order by (2)


SELECT SoldAsVacant
,Case When SoldAsVacant = 'Y'  then 'yes'
When SoldAsVacant = 'N' Then 'No'
Else SoldAsVacant
END
From PortfoiloProject.dbo.NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant = Case When SoldAsVacant = 'Y'  then 'yes'
When SoldAsVacant = 'N' Then 'No'
Else SoldAsVacant
END













-- Show Duplicates



--Delete Duplicates

WITH ROWNUMCTE AS (
SELECT*,
ROW_NUMBER()over(
Partition by ParcelID,
PropertyAddress,
SaleDate,
SalePrice,
LegalReference
Order by
UniqueID
)row_num



From PortfoiloProject.dbo.NashvilleHousing
--order by ParcelID
)
-- Delete Unused Columns
Delete
From ROWNUMCTE

Where row_num > 1
--Order by PropertyAddress


Select*
From PortfoiloProject.dbo.NashvilleHousing


ALTER TABLE PortfoiloProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfoiloProject.dbo.NashvilleHousing
DROP COLUMN Saledate