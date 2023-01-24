--CREATE PROCEDURE spCounter
--AS

--DECLARE @Counter INT = 1;

--WHILE @Counter <=10 
--BEGIN 
--PRINT @Counter;
--SET @Counter = @Counter + 1;
--END;

--Orders tablosundan 1997 yýlýna ait 1 numaralý çalýþanýmýn sorumlu olduðu ve sadece UK ülkesindedki sadece London'a gönderilen ürünlerin sipariþ numarasý, hangi müþteriye gittiði ve hangi taþýmacý þirketi ile yapýldýðýný listeleyen bir sp yazýnýz.(Cursor yapýsýný kullanýnýz)

--ALTER PROCEDURE csOrderReport --YENÝ ÝSÝM VERDÝK
--AS
--BEGIN

--DECLARE @vs_OrderID int --deðiþken tanýmladýk
--DECLARE @vs_CustomerID nchar(5)
--DECLARE @vs_ShipCompany nvarchar(50)

--DECLARE CurOrders Cursor --Cursor tanýmladýk
--FOR 
--	SELECT OrderID,CustomerID,CompanyName FROM Orders
--	INNER JOIN Shippers on Orders.ShipVia=Shippers.ShipperID
--	WHERE YEAR(OrderDate)=1997 and EmployeeID=1 and ShipCountry='UK'and ShipCity='London'

--OPEN CurOrders --cursor açýldý
--FETCH NEXT FROM CurOrders INTO @vs_OrderID, @vs_CustomerID, @vs_ShipCompany --ilk kaydý oku

--WHILE @@FETCH_STATUS =0 --Kayýt okumasý baþarýlý ve bir kayýt geldi.
--BEGIN 

--	PRINT 'Sipariþ Numarasý: ' + Convert(nvarchar(20),@vs_OrderID )+ 'Müþteri Kodu: ' + @vs_CustomerID + 'Taþýmacý Þirket: ' + @vs_ShipCompany
--	FETCH NEXT FROM CurOrders INTO @vs_OrderID, @vs_CustomerID, @vs_ShipCompany --Bir sonraki kaydý oku

--END --Kayýtlar bitti
--CLOSE CurOrders -- Cursoru'ý kapat
--DEALLOCATE CurOrders
--END

alter procedure BackupAll
as
begin --Bu prosedür sql server üzerinde o an tanýmlý olan tüm verileri bir anda yedekler

DECLARE @name VARCHAR(50) -- database name 
DECLARE @path VARCHAR(256) -- path for backup files 
DECLARE @fileName VARCHAR(256) -- filename for backup 
DECLARE @fileDate VARCHAR(20) -- used for file name 

SET @path = 'C:\PY100KY\' 

SELECT @fileDate = CONVERT(VARCHAR(20),GETDATE(),112) 

DECLARE db_cursor CURSOR FOR 
SELECT name 
FROM MASTER.dbo.sysdatabases 
WHERE name NOT IN ('master','model','msdb','tempdb') 

OPEN db_cursor  
FETCH NEXT FROM db_cursor INTO @name  

WHILE @@FETCH_STATUS = 0  
BEGIN  
      SET @fileName = @path + @name + '-' + @fileDate + '.BAK' 
      BACKUP DATABASE @name TO DISK = @fileName 

      FETCH NEXT FROM db_cursor INTO @name 
END 

CLOSE db_cursor  
DEALLOCATE db_cursor 

end