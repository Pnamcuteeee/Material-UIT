CREATE DATABASE QuanLyBanHang
--USE QuanLyBanHang
GO
CREATE TABLE KHACHHANG (
    MAKH CHAR(4) PRIMARY KEY,
    HOTEN VARCHAR(40) NOT NULL,
    DCHI VARCHAR(50) NOT NULL,
    SODT VARCHAR(20) NOT NULL,
    NGSINH SMALLDATETIME,
    NGDK SMALLDATETIME,
    DOANHSO MONEY NOT NULL
);

CREATE TABLE NHANVIEN (
    MANV CHAR(4) PRIMARY KEY,
    HOTEN VARCHAR(40) NOT NULL,
    SODT VARCHAR(20) NOT NULL,
    NGVL smalldatetime
);

CREATE TABLE SANPHAM (
    MASP char(4) PRIMARY KEY,
    TENSP VARCHAR(40) NOT NULL,
    DVT VARCHAR(20),
    NUOCSX VARCHAR(40),
    GIA MONEY
);

CREATE TABLE HOADON (
    SOHD INT PRIMARY KEY,
    NGHD SMALLDATETIME,
    MAKH CHAR(4) FOREIGN KEY REFERENCES KHACHHANG(MAKH),
    MANV CHAR(4) FOREIGN KEY REFERENCES NHANVIEN(MANV),
    TRIGIA INT
);

CREATE TABLE CTHD (
    SOHD INT FOREIGN KEY REFERENCES HOADON(SOHD),
    MASP CHAR(4) FOREIGN KEY REFERENCES SANPHAM(MASP),
    SL INT,
    PRIMARY KEY(SOHD,MASP)
);
--2.
ALTER TABLE SANPHAM ADD GHICHU VARCHAR(20)
GO
--3.
ALTER TABLE KHACHHANG ADD LOAIKH TINYINT
GO
--4.
ALTER TABLE SANPHAM ALTER COLUMN GHICHU VARCHAR(100)
GO
--5.
ALTER TABLE SANPHAM DROP COLUMN GHICHU
GO
--6.
ALTER TABLE KHACHHANG 
ALTER COLUMN LOAIKH VARCHAR(20)
GO
--7.
ALTER TABLE SANPHAM
ADD CONSTRAINT CK_DVT CHECK(DVT in ('cay', 'hop', 'cai', 'quyen', 'chuc'))
GO
--8.
ALTER TABLE SANPHAM
ADD CONSTRAINT CK_GIA CHECK(GIA >= 500)
GO
--9.
ALTER TABLE CTHD
ADD CONSTRAINT CK_SL CHECK(SL >= 1)
GO
--10.
ALTER TABLE KHACHHANG
ADD CONSTRAINT CK_NGAYDK CHECK(NGDK > NGSINH)
GO