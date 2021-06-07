--DROP TABLE
DROP TABLE DIRECTOR;
DROP TABLE COMPANY;
DROP TABLE PERSON;
DROP TABLE SHAREHOLDER;
DROP TABLE INCOME
DROP TABLE FACTORY;
DROP TABLE PRODUCT;
DROP TABLE MANUFACTURES;


--Creating Table
CREATE TABLE DIRECTOR(
	CodeD VARCHAR(15),
	LNameD VARCHAR(15),
	FnameD VARCHAR(15),
	CONSTRAINT pk_director PRIMARY KEY (CodeD)
);

CREATE TABLE COMPANY(
	VATNum VARCHAR(15),
	NameC VARCHAR(15),
	RoadC VARCHAR(15),
	PostCodeC VARCHAR(15),
	CityC VARCHAR(15),
	DomaineC VARCHAR(15),
	CreatDateC DATE,
	CodeD VARCHAR(15),
	CONSTRAINT pk_company PRIMARY KEY (VATNum),
	CONSTRAINT fk_company_director FOREIGN KEY (CodeD) REFERENCES DIRECTOR(CodeD)
);

CREATE TABLE PERSON(
	CodeP VARCHAR(15),
	LNameP VARCHAR(15),
	FNameP VARCHAR(15),
	RoadP VARCHAR(20),
	PostCodeP VARCHAR(15),
	CityP VARCHAR(15),
	CONSTRAINT pk_person PRIMARY KEY (CodeP)
);

CREATE TABLE SHAREHOLDER(
	VATNum VARCHAR(15),
	CodeP VARCHAR(15),
	NumSharespers NUMBER(3),
	DatePers DATE,
	CONSTRAINT pk_shareholder PRIMARY KEY (VATNum, CodeP),
	CONSTRAINT fk_shareholder_company FOREIGN KEY (VATNum) REFERENCES COMPANY(VATNum),
	CONSTRAINT fk_shareholder_person FOREIGN KEY (CodeP) REFERENCES PERSON(CodeP)
);

CREATE TABLE FACTORY(
	CodeF VARCHAR(15),
	NameF VARCHAR(15),
	RoadF VARCHAR(15),
	PostCodeF VARCHAR(15),
	CityF VARCHAR(15),
	VATNum VARCHAR(15),
	CodeD VARCHAR(15),
	CONSTRAINT pk_factory PRIMARY KEY (CodeF),
	CONSTRAINT fk_factory_company FOREIGN KEY (VATNum) REFERENCES COMPANY(VATNum),
	CONSTRAINT fk_factory_director FOREIGN KEY (CodeD) REFERENCES DIRECTOR(CodeD)
);

CREATE TABLE INCOME(
	VATNum VARCHAR(15),
	Year VARCHAR(15),
	RevenueAmount NUMBER(15),
	CONSTRAINT pk_income PRIMARY KEY (VATNum, Year),
	CONSTRAINT fk_income_company FOREIGN KEY (VATNum) REFERENCES COMPANY(VATNum)
);

CREATE TABLE PRODUCT(
	CodePR VARCHAR(15),
	NamePR VARCHAR(15),
	Line VARCHAR(15),
	CONSTRAINT pk_product PRIMARY KEY (CodePR)
);

CREATE TABLE MANUFACTURES(
	CodePR VARCHAR(15),
	CodeF VARCHAR(15),
	DateStart DATE,
	DateEnd DATE,
	CONSTRAINT pk_manufactures PRIMARY KEY (CodePR,CodeF,DateStart),
	CONSTRAINT fk_manufactures_product FOREIGN KEY (CodePR) REFERENCES PRODUCT(CodePR),
	CONSTRAINT fk_manufactures_factory FOREIGN KEY (CodeF) REFERENCES FACTORY(CodeF)
);
--End Creating Tables


--Inserting values into tables
INSERT INTO DIRECTOR (CodeD, LNameD, FnameD) VALUES('D001', 'Ravat', 'Franck');
INSERT INTO COMPANY (VATNum, NameC, RoadC, PostCodeC, CityC, DomaineC, CreatDateC, CodeD) VALUES ('FR83404833048', 'MagicCompany', 'Rue de Minimes', '31000', 'Toulouse', 'Sales of Computer','2013-10-21', 'D001');
INSERT INTO PERSON (CodeP, LNameP, FNameP, RoadP, PostCodeP, CityP) VALUES ('P001', 'Neymar', 'Jean', 'Boulevard Lascrosses', '31000', 'Toulouse');
INSERT INTO SHAREHOLDER (VATNum, CodeP, NumSharespers, DatePers) VALUES ('FR83404833048', 'P001', 3, '2018-07-15');
INSERT INTO FACTORY (CodeF, NameF, RoadF, PostCodeF, CityF, VATNum, CodeD) VALUES ('F001', 'MagicFactory1', 'Rue Jean-Jaurès', '69', 'Toulouse', 'FR83404833048', 'D001');
INSERT INTO INCOME (VATNum, Year, RevenueAmount) VALUES ('FR83404833048', '2013', 15000);
INSERT INTO INCOME (VATNum, Year, RevenueAmount) VALUES ('FR83404833048', '2014', 189000);
INSERT INTO PRODUCT (CodePR, NamePR, Line) VALUES ('XZF1', 'ComputerV1', '500');
INSERT INTO PRODUCT (CodePR, NamePR, Line) VALUES ('XZF2', 'ComputerV2', '1000');
INSERT INTO MANUFACTURES (CodePR, CodeF, DateStart, DateEnd) VALUES ('XZF1', 'F001', '2013-10-22', '2014-08-15');
INSERT INTO MANUFACTURES (CodePR, CodeF, DateStart, DateEnd) VALUES ('XZF2', 'F001', '2014-02-12', NULL);
	--End Inserting Values into tables
	
	
	--Full Name of Column NameC
	
	SELECT  COMPANY.NameC FROM COMPANY;
	
	--Name of a column using an alias for the table
	
	SELECT c.NameC FROM COMPANY C;
	
	--Product names (NamePR) and their lines (Line)
	SELECT pr.NamePR, pr.Line FROM PRODUCT pr;
	
	--All the characteristics of the factories of the Lot French department (Frenchdepartment number 46, i.e. the first two numbers of the postal code)
	
	SELECT f.* FROM FACTORY f 
	WHERE f.PostCodeF LIKE '46__';
	
	
	
	--All the information of Manufactures that have “DateEnd”
	SELECT m.* FROM MANUFACTURES m 
	WHERE m.DateEnd is NOT NULL;
	
	--Person names from Toulouse or Bordeaux
	
	SELECT p.FNameP, p.LNameP FROM PERSON p 
	WHERE P.CityP = 'Toulouse' OR p.CityP = 'Bordeaux';
	
	--Company VAT number where a shareholder person exists
	SELECT DISTINCT s.VATNum from SHAREHOLDER s; 
	
	--Company names from Toulouse, in alphabetical order
	
	SELECT c.NameC FROM COMPANY c 
	WHERE c.CityC = 'Toulouse' ORDER BY c.NameC ASC;

	--The product codes with a line greater than 1000 with custom headers
	
	SELECT pr.CodePR  AS "product code", 
	pr.Line AS "product line" FROM PRODUCT pr WHERE pr.Line>1000;
	
	
	-- For all the 90’s (all years between 1990 and 2000),give the incomes orderedaccording to the company VAT numbers and to years 
	
	SELECT i.RevenueAmount FROM INCOME i  
	WHERE Year BETWEEN 1990 AND 2000 ORDER BY VATNum AND Year;
	
	--The code of the major shareholders (i.e. shareholders that have over a 100 shares) that acquired their shares in 2003 for the company
	--with the VAT number FR1234567891234 (with personalised column headers and ordered in ascending order)
	SELECT s.CodeP FROM SHAREHOLDER s  
	WHERE s.DatePers ="2003" AND VATNum = " FR1234567891234";
	
	--The company names and their factory directors
	SELECT c.Namec, d.FNameD, d.LNameD
	FROM COMPANY c, FACTORY f, DIRECTOR d 
	WHERE f.VATNum = c.VATNum
	 AND f.CodeD = d.CodeD;
	
	
	--The names of the companies along with their shareholders
	SELECT  C.NameC, p.FNameP, p.LNameP 
	FROM COMPANY c, SHAREHOLDER s, PERSON p
	WHERE c.VATNum = s.VATNum
	AND s.codeP = p.CodeP;
	
	
	--The names of the companies from the electronic domain as well as the income they made in 2003
	SELECT c.NameC, c.DomaineC, i.RevenueAmount,i.Year
	FROM COMPANY c, INCOME i
	WHERE c.DomaineC ="electronic" 
	AND i.Year="2003"
	AND c.VATNum = i.VATNum;
	
	
	--Cities of the companies that are identical to the cities of persons
	
	SELECT c.CityC, p.CityP FROM COMPANY c, PERSON p,SHAREHOLDER S
	WHERE s.VATNum = c.VATNum
	AND s.CodeP = p.CodeP;
	
	
	--The names of the factories that do not produce the product that has the code'P0001'.
	
					   
	SELECT f.NameF
	FROM FACTORY f, PRODUCT pr, MANUFACTURES m
	WHERE f.CodeF=m.codeF AND m.CodePR = pr.CodePR
	AND f.codeF NOT IN (
						SELECT m.codeF FROM MANUFACTURES m
						WHERE m.CodePR = 'P0001'
						);
						
	--The name of companies that have factories in the departments 69 and 92.
	
	SELECT c.NameC
	FROM COMPANY c, FACTORY f
	WHERE c.VATNum = f.VATNum
	AND f.PostCodeF LIKE '69__'
	AND c.VATNum IN(
					SELECT f1.VATNum 
					FROM FACTORY f1 
					WHERE c.VATNum = f.VATNum
					AND f1.PostCodeF LIKE '92__'
					
	);
	
	--The last names and first names of people that only have shares in companies that produce products from the product line “electronic chips”.
	
	SELECT p.FNameP, p.LNameP, c.NameC, pr.NamePR, pr.Line
	FROM COMPANY c, PERSON p, PRODUCT pr, MANUFACTURES m, FACTORY f, SHAREHOLDER s
	WHERE c.VATNum = f.VATNum
	AND   f.CodeF = m.CodeF
	AND	  m.CodePR = pr.CodePR
	AND   c.VATNum = s.VATNum
	AND   s.CodeP = p.CodeP
	AND   s.codeP IN(
					 SELECT p.CodeP
					 FROM PERSON p1
					 WHERE pr.Line = 'electronic chips'
						
	);
	
	
	--The product name that is manufactured only in the French department “Haute Garonne” (department number 31)
	SELECT pr.CodePR, pr.NamePR, f.NameF
	FROM PRODUCT pr, MANUFACTURES m, FACTORY f
	WHERE 
	AND   f.CodeF = m.CodeF
	AND   m.codePR = pr.CodePR
	AND f.PostalCodeF like "31___"
	AND pr.CodePR NOT IN (
		SELECT pr1.CodePR from Product pr1, MANUFACTURES m1, FACTORY f1
		AND   f1.CodeF = m1.CodeF
	  AND   m1.codePR = pr1.CodePR
	 AND f1.POstalCodeF NoT like "31___"
	);
	
	
	
	
	
	--The number of factories in the whole database.
	SELECT COUNT(*) AS Factory_Count 
	FROM FACTORY f;
	
	--The total number of shares for the person “Jean Neymar”
	SELECT p.FNameP,p.LNameP,SUM(s.NumSharespers) AS share_count
		FROM SHAREHOLDER s, PERSON p
		WHERE p.FNameP LIKE 'Jean'
		AND p.LNameP LIKE 'Neymar'
		AND p.CodeP = s.CodeP
		GROUP BY p.FNameP, p.LNameP;
		
		
		
		--The total number of shares for each company.
		
		SELECT c.NameC,SUM(s.NumSharesPers) AS share_count
		FROM shareholder s, company c
		WHERE s.VATNum = c.VATNum
		GROUP BY c.NameC, c.VATNum;
		
		--For each company, the last name and the first name of the director and the maximum income.
		
		SELECT d.FNameD, d.LNameD,
		MAX(i.RevenueAmount) AS max_count
		FROM DIRECTOR d, COMPANY c, INCOME i
		where d.CodeD = c.CodeD
		AND   c.VATNum = i.VATNum
		GROUP BY c.NameC, c.VATNum, d.LNameD, d.FnameD, d.CodeD;
		
		
		--For each company that have more than 10 shareholders, give the total number of shares.
		SELECT c.NameC, c.VATNum, SUM(s.NumSharesPers) AS Total_shares
		FROM COMPANY c,SHAREHOLDER s
		WHERE c.VATNum = s.VATNum
		GROUP BY c.NameC, c.VATNum
		HAVING COUNT(s.CodeP) >10;
		
		--The name and complete address of companies that manufacture more than 2 products.
		
		SELECT c.NameC,c.RoadC, c.PostCodeC,c.CityC
		FROM COMPANY c, MANUFACTURES m, FACTORY f
		WHERE c.VATNum = f.VATNum
		AND  f.CodeF = m.CodeF
		GROUP BY c.NameC,c.RoadC, c.PostCodeC,c.CityC, c.VATNum
		HAVING COUNT(m.CodePR) >2;
		
		--The name of companies that have more than 5 factories
		
		SELECT c.NameC
		FROM COMPANY c, FACTORY f
		WHERE c.CodeD = f.CodeD
		GROUP BY c.Namec, c.CodeD
		HAVING COUNT(f.codeF)> 5;
		
		
		--The name of the greatest shareholder for each company (the person who has the maximum shares).
		SELECT c.NameC, p.FNameP, p.LNameP
		FROM COMPANY c, SHAREHOLDER s, PERSON p
		WHERE c.VATNum = s.VATNum
		AND   s.CodeP = p.CodeP
		AND s.NumSharesPers = ( SELECT MAX(s2.NumSharesPers)
								FROM SHAREHOLDER s2
								WHERE s2.VATNum = c.VATNum
							);
							
		--The number of product in each product line
		SELECT pr.Line, COUNT(NamePR) AS product_count
		FROM PRODUCT pr;
		
		
		--The name of companies that have the same number of factories as the company “Electronic Plus”
		SELECT c.NameC, COUNT(f.NameF) AS factory_count
		FROM COMPANY c, FACTORY f
		WHERE c.VATNum = f.VATNum
		AND C.NameC LIKE 'Electronic Plus'= c.Namec;
		
		
		
		--The last name and the first name of people that have shares in at least 2 companies of the domain “electronic”
		
		SELECT p.FNameP, p.LNameP, c.NameC, c.DomaineC
		FROM PERSON p, SHAREHOLDER s, COMPANY c
		WHERE c.VATNum = s.VATNum
		AND   s.CodeP = p.CodeP
		GROUP BY p.FNameP, p.LNameP, c.NameC, c.DomaineC
		HAVING (c.DomaineC LIKE 'electronic')>=2;
		
		
		--For each company that has more factories than the company “Electronic Plus”
		--the name (first name and last name) and address (of the office of the company)of its director
		
		SELECT c.Namec, d.FNameD, d.LNameD
		FROM  FACTORY f,COMPANY c, DIRECTOR d
		WHERE d.CodeD = c.CodeD
		AND   c.VATNum = f.VATNum
		AND 	f.NameF = (SELECT MAX(f2.NameF)
								FROM FACTORY f2
								WHERE c.VATNum = f.VATNum
								AND c.NameC LIKE 'Electronic Plus'
								);
								
								
								
		--All queries are Testing in Mysql 
		
		
		

		
	
	
	
