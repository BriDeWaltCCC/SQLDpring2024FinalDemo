-- Procedures

USE AdventureWorks2022
GO

ALTER PROCEDURE UpdateInventory @Product_ID int, @Location_ID smallint, 
    @ChangeAmount SMALLINT, @NewQuant SMALLINT OUTPUT
AS
BEGIN
BEGIN TRANSACTION
UPDATE Production.ProductInventory SET Quantity = Quantity + @ChangeAmount
WHERE ProductID = @Product_ID AND LocationID = @Location_ID
COMMIT

SET @NewQuant = (SELECT Quantity FROM Production.ProductInventory WHERE ProductID = @Product_ID AND LocationID = @Location_ID)

END
GO

DECLARE @Output SMALLINT

EXEC UpdateInventory @Product_ID = 1, @Location_ID = 1, @ChangeAmount = -10, @NewQuant = @Output OUTPUT

PRINT (@Output)

-- Functions

USE AdventureWorks2022
GO

CREATE FUNCTION TotalInventory (@Product_ID INT)
RETURNS INT
AS
BEGIN
RETURN (SELECT SUM(Quantity) FROM Production.ProductInventory GROUP BY ProductID HAVING ProductID = @Product_ID)
END
GO

PRINT (dbo.TotalInventory(1))

-- Joins and Aggregations
USE AdventureWorks2022
GO

SELECT Per.FirstName, Per.LastName, SUM(SOH.TotalDue) AS [Sum Total Due], MIN(SOH.TotalDue) AS [Min Total Due], 
    MAX(SOH.TotalDue) AS [Max Total Due], AVG(SOH.TotalDue) AS [Avg Total Due]
FROM Sales.SalesOrderHeader AS SOH
JOIN Person.Person AS Per ON Per.BusinessEntityID = SOH.SalesPersonID
GROUP BY Per.FirstName, Per.LastName, SOH.SalesPersonID

-- Try Catch

USE The_ACC_Store
GO

BEGIN TRY
SELECT * FROM Store
WHERE Store_ID = 12/4
END TRY
BEGIN CATCH
PRINT ('An Error Happened')
END CATCH