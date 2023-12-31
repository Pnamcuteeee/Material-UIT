/*
CREATE DATABASE QLDOc
GO
USE QLDOc
GO
SET DATEFORMAT dmy 
CREATE TABLE NGUOIBAN
(
    MANB CHAR(9) PRIMARY KEY,
    HOTEN NVARCHAR(50),
    DIACHI NVARCHAR(70),
    SODT CHAR(10)
)
GO
CREATE TABLE LOAI_DIAOC
(
    MALDO INT PRIMARY KEY,
    TENLDO NVARCHAR(50),
    
)
GO

CREATE TABLE DIAOC
(
    MADO CHAR(9) PRIMARY KEY,
    SO VARCHAR(10),
    DUONG NVARCHAR(30),
    PHUONG VARCHAR(3),
    QUAN VARCHAR(3),
    DTDAT REAL,
    DTXD REAL,
    HUONG NVARCHAR(10),
    VITRI NVARCHAR(20),
    MOTA NVARCHAR(100),
    MALDO INT REFERENCES LOAI_DIAOC
)
GO

CREATE TABLE DICHVU
(
    MADV INT PRIMARY KEY,
    TENDV NVARCHAR(50),
    TIENDV MONEY
)
GO
CREATE TABLE PHIEU_DANG_KY
(
    MAPDK CHAR(10) PRIMARY KEY,
    NGDK DATETIME,
    TongSoDV INT,
    TongTien MONEY,
    MANB CHAR(9) REFERENCES NGUOIBAN
)
GO
CREATE TABLE CT_PDK
(
    MAPDK CHAR(10) REFERENCES PHIEU_DANG_KY,
    MADO CHAR(9) REFERENCES DIAOC,
    MADV INT REFERENCES DICHVU,
    TUNGAY DATETIME,
    DENNGAY DATETIME,SOTIEN MONEY,
    PRIMARY KEY (MAPDK,MADO,MADV)
)
GO
CREATE TABLE PHIEUTHU
(
    MAPT CHAR(10) PRIMARY KEY,
    MAPDK CHAR(10) REFERENCES PHIEU_DANG_KY,
    NGAYTHU DATETIME,
    LANTHU INT,
    SOTIEN MONEY,MAPTGOC CHAR(10)
)
GO
CREATE TABLE PHIEUGIAHAN
(
    MAPGH CHAR(10) PRIMARY KEY,
    MAPDK CHAR(10) REFERENCES PHIEU_DANG_KY,
    MADO CHAR(9) REFERENCES DIAOC,
    MADV INT REFERENCES DICHVU,
    NGAYGIAHAN DATETIME,
    TUNGAY DATETIME,
    DENNGAY DATETIME
)
GO

INSERT INTO NGUOIBAN (MANB, HOTEN, DIACHI, SODT)
VALUES 
('111222333', 'Nguyễn Tường Vân', '330/2 Lê Hồng Phong Quận 5', '8111222'),
('222333444', 'Trần Thanh Tùng', '111 Trương Định Quận 3', '8222333'),
('333444555', 'Nguyễn Ngọc Nga', '315 An Dương Vương Quận 5', '8333444')
GO
INSERT INTO LOAI_DIAOC (MALDO, TENLDO)
VALUES 
('1', 'Nhà và đất'),
('2', 'Đất')
GO


INSERT INTO DIAOC (MADO, SO, DUONG, PHUONG, QUAN, DTDAT, DTXD, HUONG, VITRI, MOTA, MALDO)
VALUES 
('DO111', '731', 'Trần Hưng Đạo', '7', '1', 1000, 800, 'Đông', 'Mặt tiền', '1', 1),
('DO222', '638', 'Nguyễn Văn Cừ', '5', '5', 500, 450, 'Tây', 'Mặt tiền', '2', 2),
('DO333', '332/1', 'Nguyễn Thái Học', '9', '1', 100, 100, 'Nam', 'Hẻm', '1', 1),
('DO444', '980', 'Lê Hồng Phong', '4', '5', 450, 450, 'Bắc', 'Mặt tiền', '2', 2),
('DO555', '111/45', 'Trương Định', '10', '3', 85, 85, 'Đông Nam', 'Hẻm', '1', 1);


INSERT INTO DICHVU (MADV, TENDV, TIENDV)
VALUES 
('1', 'Tờ bướm quảng cáo 200 tờ', '200.000'),
('2', 'Tờ bướm quảng cáo 100 tờ', '100.000'),
('3', 'Quảng cáo trên báo', '300.000')
GO


INSERT INTO PHIEU_DANG_KY (MAPDK, NGDK, TONGSODV, TONGTIEN, MANB)
VALUES 
('PDK111', '01/05/2006', '1', '1040000', '111222333'),
('PDK222', '19/10/2006', '2', '600000', '222333444'),
('PDK333', '07/09/2006', '3', '1000000', '333444555')
GO

INSERT INTO CT_PDK (MAPDK, MADO, MADV, TuNgay, DenNgay, SOTIEN)
VALUES 
('PDK111', 'DO111', '1', '05/05/2006', '05/07/2006', '400000'),
('PDK222', 'DO222', '1', '01/11/2006', '31/12/2006', '400000'),
('PDK222', 'DO333', '2', '01/11/2006', '31/12/2006', '200000'),
('PDK333', 'DO444', '1', '15/09/2006', '15/10/2006', '200000'),
('PDK333', 'DO444', '2', '15/09/2006', '15/10/2006', '100000'),
('PDK333', 'DO555', '3', '15/09/2006', '15/10/2006', '300000')
GO --here

INSERT INTO PHIEUGIAHAN (MAPGH, MAPDK, MADO, MADV, NGAYGIAHAN, TUNGAY, DENNGAY)
VALUES ('PGH111', 'PDK111', 'DO111', '1', '5/7/2006', '5/7/2006', '5/9/2006'),
('PGH222', 'PDK111', 'DO111', '1', '1/11/2006', '1/11/2006', '31/12/2006'),
('PGH444', 'PDK333', 'DO444', '1', '15/11/2006', '15/11/2006', '15/12/2006'),
('PGH555', 'PDK333', 'DO555', '3', '15/11/2006', '15/11/2006', '15/12/2006')
GO --here

INSERT INTO PHIEUTHU (MAPT, MAPDK, NGAYTHU, LANTHU, SOTIEN, MAPTGOC)
VALUES 
('PT111', 'PDK111', '01/05/2006', '1', '400000', NULL),
('PT222', 'PDK222', '19/10/2006', '1', '400000', NULL),
('PT333', NULL, '15/12/2006', '2', '200000', 'PT222'),
('PT444', NULL, '05/07/2006', '2', '320000', 'PT111'),
('PT555', NULL, '01/11/2006', '3', '320000', 'PT111'),
('PT666', 'PDK333', '07/09/2006', '1', '600000', NULL),
('PT777', NULL, '15/11/2006', '2', '400000', 'PT666')
GO
*/

SELECT MANB,HOTEN,DIACHI FROM NGUOIBAN
WHERE MANB IN (
    SELECT MANB FROM PHIEU_DANG_KY PDK JOIN CT_PDK ON PDK.MAPDK = CT_PDK.MAPDK
    WHERE MONTH(TUNGAY) >= 9 AND MONTH(DENNGAY) <= 10 AND YEAR(TUNGAY) = 2006 AND YEAR(DENNGAY) = 2006
    GROUP BY MANB
)

SELECT PDK.MANB,NGDK,DAY(MAX(DENNGAY - TUNGAY)) AS MAXIMU
FROM PHIEUGIAHAN PGH JOIN PHIEU_DANG_KY PDK ON PGH.MAPDK = PDK.MAPDK
                     JOIN NGUOIBAN ON NGUOIBAN.MANB = PDK.MANB
GROUP BY PDK.MANB,NGDK
GO
/*
GIAHN  +      -      +
CTDK   -      -      +

*/

CREATE TRIGGER TRG_UP_IN_GH ON PHIEUGIAHAN
FOR UPDATE,INSERT
AS BEGIN
    IF EXISTS(
        SELECT * FROM inserted I JOIN CT_PDK CT ON I.MAPDK = CT.MAPDK
        WHERE I.MADO = CT.MADO AND I.MADV = CT.MADV AND I.TUNGAY < CT.DENNGAY 
    )
    BEGIN
     PRINT'LOI: INPUT KO HOP LE'
     ROLLBACK TRANSACTION
    END
    ELSE
    BEGIN
     PRINT 'THANH CONG'
    END
END
GO


CREATE TRIGGER TRG_UP_IN_CT ON CT_PDK
FOR UPDATE
AS BEGIN
    IF EXISTS(
        SELECT * FROM inserted I JOIN PHIEUGIAHAN CT ON I.MAPDK = CT.MAPDK
        WHERE I.MADO = CT.MADO AND I.MADV = CT.MADV AND I.DENNGAY > CT.TUNGAY 
    )
    BEGIN
     PRINT'LOI: INPUT KO HOP LE'
     ROLLBACK TRANSACTION
    END
    ELSE
    BEGIN
     PRINT 'THANH CONG'
    END
END
GO
