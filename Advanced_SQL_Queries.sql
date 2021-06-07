	
	
	--1 List of Company Name, HQ City whose HQ is in france but not in paris

	SELECT c.companyname,g.city as HQCityName,g.COUNTRY,c.HQADDRESSCITYCODE
	FROM company c,geography g 
	WHERE c.HQADDRESSCITYCODE = g.citycode
	and  g.COUNTRY = 'France' 
	and c.HQADDRESSCITYCODE != 'PARIS_FR'
	
	--2 List of Company whose HQ and Legal or  registration city are different based in France with TRBC Business sector
	
	SELECT c.companyname,g.CITY, g.COUNTRY,tr.TRBCBUSINESSSECTOR,c.HQADDRESSCITYCODE, c.REGISTRATIONCITYCODE,c.LEGALADDRESSCITYCODE
	FROM company c,geography g , trbcclassification tr
	WHERE c.HQADDRESSCITYCODE = g.CITYCODE and c.TRBCACTIVITYCODE = tr.TRBCACTIVITYCODE
	and   c.HQADDRESSCITYCODE != c.LEGALADDRESSCITYCODE 
	and   c.HQADDRESSCITYCODE != c.REGISTRATIONCITYCODE
	and g.COUNTRY = 'France'
	 
	
	--3 List top 10 cities and how many company have their HQ in the city in desc order

	select top 10 g.COUNTRY,g.CITY,count(c.IDCOMPANY) NoOfCompanyHQs
	from company c, geography g
	where c.HQADDRESSCITYCODE = g.CITYCODE
	group by g.CITY,g.COUNTRY
	order by NoOfCompanyHQs desc
	
	
	--4 List top 3 cities from europe region and how many company have their HQ in the city in desc order

	select top 3 g.REGION,g.COUNTRY,g.CITY,count(c.IDCOMPANY) NoOfCompanyHQs
	from company c, geography g
	where c.HQADDRESSCITYCODE = g.CITYCODE
	and g.REGION = 'Europe'
	group by g.CITY,g.COUNTRY,g.REGION
	order by NoOfCompanyHQs desc

	-- List top   cities from europe region and how many company have their HQ in the city in desc order 
	-- with no of HQs more than 3
	select   g.REGION,g.COUNTRY,g.CITY,count(c.IDCOMPANY) NoOfCompanyHQs
	from company c, geography g
	where c.HQADDRESSCITYCODE = g.CITYCODE
	group by g.CITY,g.COUNTRY,g.REGION
	having count(c.IDCOMPANY) >3
	order by NoOfCompanyHQs desc
	
	
	 
	--5 List of all markets an no of companies listed in each market in desc order
	-- in CompanyStock file we have only 17 company data that is why it is showing only 17
 
	select m.IDMARKET,m.FULLNAME  , count(distinct cs.IDCOMPANY) NoOfCompany
	from market m,  companystock cs
	where  cs.IDMARKET = m.IDMARKET
	group by m.FULLNAME,m.IDMARKET
	order by NoOfCompany desc
	
	--6. List all Food Processing (NEC) (as per TRBC Classification) companies  who have HQ in France or in Switzerland
	
	SELECT c.companyname ,g.country
	from company c, geography g,trbcclassification tr
	where c.TRBCACTIVITYCODE = tr.TRBCACTIVITYCODE
	and c.HQADDRESSCITYCODE = g.citycode
	and tr.TRBCACTIVITY = 'Food Processing (NEC)'
	and ( g.COUNTRY ='France'or g.COUNTRY ='Switzerland');
	
	
	
	--7. List all Retailers companies (TRBCBUSINESSSECTOR) or Retailers (GICSINDUSTRYGROUP) who have
	--	 either Legal address or registration city or HQ in France.

	SELECT c.companyname, g.city
	from company c,geography g,trbcclassification tr,gicsclassification gi
	where c.trbcactivitycode = tr.trbcactivitycode
	and c.gicssubindustrycode = gi.gicssubindustrycode
	and c.HQADDRESSCITYCODE = g.citycode
	and (tr.TRBCBUSINESSSECTOR='Retailers' or gi.GICSINDUSTRYGROUP='Retailing')
	and (c.RegistrationAddressCityCode = (select CityCode from geography where City = 'PARIS')
	or c.HQAddressCityCode = (select CityCode from geography where City = 'PARIS')
	or c.LegalAddressCityCode = (select CityCode from geography where City = 'PARIS'));
	
	
	--8 List of all differebt industry under all 3 classification and no of companys in serving under each industry 
	select TRBCECONOMICSECTOR Industry ,count (c.IDCOMPANY) NoOfCompany
	from trbcclassification tr,company c
	where c.TRBCACTIVITYCODE = tr.TRBCACTIVITYCODE
	group by tr.TRBCECONOMICSECTOR
	
	union 
	
	select   GICSSECTOR Industry,count (c.IDCOMPANY) NoOfCompany
	from gicsclassification gi,company c
	where c.GICSSUBINDUSTRYCODE = gi.GICSINDUSTRYCODE
	group by GICSSECTOR
	
	union 
	
	select   NAICSSECTOR Industry,count (c.IDCOMPANY) NoOfCompany
	from naicsclassification na,company c
	where c.NAICSNATIONALINDUSTRYCODE = na.NAICSNATIONALINDUSTRYCODE
	group by NAICSSECTOR
	order by NoOfCompany desc
		
	-- 9 List of IDINDEX their max volume and data on which it occured (Complex Query)

	select indexstock.IDINDEX, MaxVolume,PRICECLOSEDATE
	from indexstock  
	join (select idindex,max(Volume) MaxVolume  from indexstock group by IDINDEX ) tblMaxVolume 
	on tblMaxVolume.MaxVolume = indexstock.VOLUME
	order by MaxVolume desc
	
		
	--10 List of company with total Volume (sum of all volume) in desc order with IDMARKET
	   
	select   IDMARKET, cs.idcompany,c.COMPANYNAME,sum(VOLUME) TotalVolume 
	from companystock cs, company c
	where cs.IDCOMPANY = c.IDCOMPANY
	group by cs.idcompany ,IDMARKET,c.COMPANYNAME
	order by IDMARKET asc , sum(VOLUME) desc


	--11. List of companies that never depends on naicssector 'Manufacturing'
	 
	 SELECT c.companyname, n.naicssector
		FROM company c, naicsclassification n
		WHERE c.naicsnationalindustrycode = n.naicsnationalindustrycode
		AND c.naicsnationalindustrycode NOT IN (
							SELECT n1.naicsnationalindustrycode FROM naicsclassification n1
							WHERE n1.naicssector = 'Manufacturing'
							);
							
	--12. List of companies that only depends on Software & IT Services  Business Sector
	SELECT c.companyname, tr.trbcbusinesssector
		FROM COMPANY c, trbcclassification tr
		WHERE c.trbcactivitycode = tr.trbcactivitycode
		and c.trbcactivitycode IN(
									select tr1.trbcactivitycode 
									from trbcclassification tr1
									where tr1.trbcbusinesssector= 'Software & IT Services'
								);
	 
	 
	 --13 top 3 high value index based on average Price close

	select top 3 IDINDEX,avg(priceclose) 
	from indexstock 
	group by idindex
	order by avg(priceclose)  desc
	
			--top 3 high transaction value   (avg of price close * avg of volume )
			select top 3 IDINDEX,avg(priceclose)*avg(volume) Transactionvalue
			from indexstock 
			group by idindex
			order by Transactionvalue  desc
	
	--14 Write a query to show maximum movement in index stock .. display top 50 movements with date
	select top 50 IDINDEX,left(PRICECLOSEDATE,10), max(cast (PRICECLOSE-PRICEOPEN as int)) DailyMovement
	from indexstock
	group by IDINDEX,PRICECLOSEDATE
	order by DailyMovement desc
	
	--15 To decide Market index trend over two years write a query to show the price on first and last avaliable transaction in indexstock table
	select indexstock.IDINDEX, PRICEOPEN,left(PRICECLOSEDATE,11)
	from indexstock  
	join (select min(Priceclosedate) Firstdate ,idindex from indexstock group by IDINDEX  ) tblDates 
	on tblDates.Firstdate = indexstock.PRICECLOSEDATE and   tblDates.idindex = indexstock.IDINDEX
	union
	select indexstock.IDINDEX, PRICECLOSE,left(PRICECLOSEDATE,11)
	from indexstock  
	join (select max(Priceclosedate) Firstdate ,idindex from indexstock group by IDINDEX  ) tblDates 
	on tblDates.Firstdate = indexstock.PRICECLOSEDATE and   tblDates.idindex = indexstock.IDINDEX
	order by indexstock.IDINDEX 
	
	
	
	