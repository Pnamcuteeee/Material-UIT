CREATE DATABASE OT04

GO

USE OT04
GO
SET DATEFORMAT dmy
GO
CREATE TABLE KHACHHANG
(
	MAKH VARCHAR(4) PRIMARY KEY,
    TENKH VARCHAR(50),
    DIACHI VARCHAR(50),
    LOAIKH VARCHAR(20)
)
GO

CREATE TABLE LOAICAY
(
    MALC VARCHAR(4) PRIMARY KEY,
    TENLC VARCHAR(50),
    XUATXU VARCHAR(50),
    GIA MONEY
)
GO
CREATE TABLE HOADON
(
    SOHD VARCHAR(5) PRIMARY KEY,
    NGHD SMALLDATETIME,
    MAKH VARCHAR(4) REFERENCES KHACHHANG,
    KHUYENMAI INT
)
GO
CREATE TABLE CTHD
(
    MALC VARCHAR(4) REFERENCES LOAICAY,
    SOHD VARCHAR(5) REFERENCES HOADON,
    SOLUONG INT,
    PRIMARY KEY (MALC,SOHD)
)
GO


INSERT INTO KHACHHANG(MAKH,TENKH,DIACHI,LOAIKH) VALUES 
('KH01','Liz Kim Cuong','Ha Noi','Vang lai'),
('KH02','Ivone Dieu Linh','Da Nag','Thuong xuyen'),
('KH03','Emma Nhat Khanh','TP.HCM','Vang lai')
GO
INSERT INTO LOAICAY(MALC,TENLC,XUATXU,GIA) VALUES 
('LC01','Xuong rong tai tho','Mexico',180000),
('LC02','Sen thach ngoc','Anh',300000),
('LC03','Ba mau rau','Nam Phi',270000)
GO
INSERT INTO HOADON(SOHD,NGHD,MAKH,KHUYENMAI) VALUES 
('00001','22/11/2017','KH01',5),
('00002','04/12/2017','KH03',5),
('00003','10/12/2017','KH02',10)
GO
INSERT INTO CTHD(MALC,SOHD,SOLUONG) VALUES 
('LC01','00001',1),
('LC02','00001',2),
('LC03','00003',5)

GO
--CAU 3
ALTER TABLE LOAICAY ADD CONSTRAINT CK_LOCATE CHECK (XUATXU <> 'Anh' OR GIA > 250000)
GO
--CAU 4
/*
    them     xoa   sua

hd    -       -     +

cthd  +       +     +
*/

CREATE TRIGGER TR_UP_HOADON ON HOADON
FOR UPDATE
AS 
BEGIN
    IF EXISTS(
        SELECT * FROM INSERTED I 
        JOIN CTHD CT ON I.SOHD = CT.SOHD
        WHERE KHUYENMAI <> 10
        GROUP BY I.SOHD
        HAVING SUM(SOLUONG) < 5
    )
    BEGIN 
        RAISERROR('NHAP LAI! ',16,1)
        ROLLBACK TRANSACTION
    END
    ELSE
        PRINT 'THANH CONG'
END
GO
CREATE TRIGGER TR_CT_IN_UP ON CTHD
FOR INSERT, UPDATE
AS
BEGIN 
    IF EXISTS ( 
        SELECT I.SOHD
        FROM INSERTED I
        JOIN HOADON HD ON I.SOHD = HD.SOHD
        JOIN CTHD CT ON HD.SOHD = CT.SOHD
        WHERE HD.KHUYENMAI <> 10 
        GROUP BY I.SOHD
        HAVING SUM(CT.SOLUONG)  >= 5
    )
    BEGIN 
		PRINT 'DU LIEU NHAP SAI'
        UPDATE HD
        SET KHUYENMAI = 10 
        FROM HOADON HD
        WHERE HD.KHUYENMAI <> 10 
          AND HD.SOHD IN (
              SELECT CT.SOHD
              FROM INSERTED I
              JOIN CTHD CT ON I.SOHD = CT.SOHD
              GROUP BY CT.SOHD
              HAVING SUM(CT.SOLUONG)  >= 5)
		PRINT 'DA CAP NHAT LAI'
    END
    ELSE
        PRINT 'NHAP DU LIEU HOAN TAT'
END
GO
CREATE TRIGGER TR_CT_DEL ON CTHD
FOR DELETE
AS
BEGIN 
    IF EXISTS ( 
        SELECT D.SOHD
        FROM DELETED D
        JOIN HOADON HD ON D.SOHD = HD.SOHD
        JOIN CTHD CT ON HD.SOHD = CT.SOHD
        WHERE HD.KHUYENMAI = 10 
        GROUP BY D.SOHD
        HAVING SUM(CT.SOLUONG)  >= 5
    )
    BEGIN 
		PRINT 'DU LIEU XOA DA THAY DOI'
        UPDATE HD
        SET KHUYENMAI = 10
        FROM HOADON HD
        WHERE HD.KHUYENMAI <> 10 
          AND HD.SOHD IN (
              SELECT D.SOHD
              FROM DELETED D
              JOIN CTHD CT ON D.SOHD = CT.SOHD
              GROUP BY D.SOHD
              HAVING SUM(CT.SOLUONG)  >= 5)
		PRINT 'DA CAP NHAT DU LIEU'
    END
    ELSE
        PRINT 'NHAP DU LIEU HOAN TAT'
END
--CAU 5
SELECT * FROM HOADON
WHERE MONTH(NGHD) >= 10 AND YEAR(NGHD) = 2017 
ORDER BY KHUYENMAI ASC
--CAU 6
SELECT * FROM LOAICAY
WHERE MALC IN (
    SELECT MALC FROM CTHD 
    GROUP BY MALC
    HAVING SUM(SOLUONG) <= ALL (
        SELECT  COUNT(SOLUONG) FROM CTHD JOIN HOADON ON CTHD.SOHD = HOADON.SOHD
        GROUP BY MALC
    )
)
--CAU 7


SELECT LC.MALC , TENLC FROM LOAICAY LC
                            JOIN CTHD CT ON LC.MALC = CT.MALC
                            JOIN HOADON HD ON CT.SOHD = HD.SOHD
                            JOIN KHACHHANG KH ON HD.MAKH = KH.MAKH
    WHERE LOAIKH = 'Thuong xuyen'
EXCEPT
SELECT LC.MALC , TENLC FROM LOAICAY LC
                            JOIN CTHD CT ON LC.MALC = CT.MALC
                            JOIN HOADON HD ON CT.SOHD = HD.SOHD
                            JOIN KHACHHANG KH ON HD.MAKH = KH.MAKH
    WHERE LOAIKH = 'Vang lai'

-- cau 8
SELECT * FROM KHACHHANG KH
WHERE NOT EXISTS (
    SELECT MALC FROM LOAICAY LC
    WHERE NOT EXISTS (
        SELECT * FROM HOADON HD JOIN CTHD CT ON HD.SOHD = CT.SOHD
        WHERE HD.MAKH = KH.MAKH AND CT.MALC = LC.MALC
    )
)