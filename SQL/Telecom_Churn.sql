USE master
go

IF Db_id('Telecom_Churn') IS NOT NULL
	DROP DATABASE Telecom_Churn;

CREATE DATABASE Telecom_Churn
go 
use Telecom_Churn
go
Create Table Populations 
	(
		ZipCode_ID int NOT NULL ,
		Population_Num int check (Population_Num>0 )
		CONSTRAINT Populations_pk PRIMARY KEY (Zipcode_ID)
	);


Create table Locations
	(
		Location_ID int NOT NULL  ,
		City Varchar(50) ,
		Latitude FLOAT,
		Longitude FLOAT ,
		ZipCode_ID int NOT NULL
		CONSTRAINT Locations_PK PRIMARY KEY (Location_ID),
		CONSTRAINT Population_Locations_FK foreign key(ZipCode_ID) REFERENCES Populations(ZipCode_ID)
	);



CREATE TABLE Churn_Categories 
	(
		Churn_Category_ID INT NOT NULL ,
		Churn_Category VARCHAR(50) CHECK (Churn_Category IN 
		('Competitor','Dissatisfaction','Price', 'Attitude', 'Other')),
		CONSTRAINT Churn_Categories_PK PRIMARY KEY (Churn_Category_ID)
	);



CREATE TABLE Churn_Reasons
	(
		Churn_Reason_ID INT NOT NULL ,
		Churn_Category_ID INT ,
		Churn_Reason VARCHAR(150) ,
		CONSTRAINT Churn_Reasons_Pk PRIMARY KEY (Churn_Reason_ID) ,
		CONSTRAINT Churn_Category_Churn_Reasons_FK FOREIGN KEY(Churn_Category_ID) REFERENCES Churn_Categories(Churn_Category_ID)
	);



CREATE TABLE Contracts
	(
		Contract_ID INT  , 
		Contract_Type VARCHAR(50) CHECK 
		(Contract_Type IN ('Month-to-Month', 'One Year', 'Two Year'))
		CONSTRAINT Contracts_PK PRIMARY KEY (Contract_ID)
	);




CREATE TABLE Status
	(
		Status_ID INT  ,
		Customer_Status VARCHAR(50) CHECK 
		(Customer_Status IN ('Churned', 'Stayed', 'Joined'))
		CONSTRAINT Status_Pk PRIMARY KEY (Status_ID)
	);



Create Table Customers
	(
		Customer_ID int , 
		Location_ID int , 
		Status_ID int ,
		Churn_reason_ID int , 
		Contract_ID int , 
		Number_Of_Referrals int Default 0, 
		Referred_A_Friend bit Default 0 CHECK(Referred_A_Friend in (0,1)),
		Gender varchar(10) Default 'Male' CHECK(Gender in ('Female','Male')), 
		Age int ,
		Married bit Default 0 CHECK(Married in (0,1)), 
		Dependents bit Default 0 CHECK(Dependents in (0,1)), 
		Number_Of_Dependents int Default 0,
		Quarter varchar(10), 
		Tenure_In_Months int, 
		Offer varchar(10) CHECK(Offer in ('Offer A','Offer B','Offer C','Offer D','Offer E','None')), 
		Paperless_Billing bit Default 0 CHECK(Paperless_Billing in (0,1)) , 
		Payment_Method varchar(50) Default 'Bank_Transfe' CHECK
		(Payment_Method in ('Bank Withdrawal', 'Credit Card', 'Mailed Check')),
		Monthly_Charge Float,
		Total_Charges Float, 
		Total_Refunds Float, 
		Total_Revenue Float, 
		CLTV Float, 
		Churn_Score int CHECK(Churn_Score between 0 and 100), 
		Satisfaction_Score int CHECK(Satisfaction_Score between 1 and 5),
		CONSTRAINT Customers_Pk PRIMARY KEY (Customer_ID) ,
		CONSTRAINT Location_Customers_Fk FOREIGN KEY (Location_ID) REFERENCES Locations (Location_ID),
		CONSTRAINT Status_Customers_Fk FOREIGN KEY (Status_ID) REFERENCES Status(Status_ID),
		CONSTRAINT Churn_Reason_Customers_FK FOREIGN KEY (Churn_Reason_ID)REFERENCES Churn_Reasons(Churn_Reason_ID),
		CONSTRAINT Contract_Cutomers_Fk FOREIGN KEY (Contract_ID) REFERENCES Contracts(Contract_ID)
	);




Create TABLE Internet_Services
	(
		Internet_Service_ID INT NOT NULL,
		Internet_Type VARCHAR(50) CHECK 
		(Internet_Type IN ('Cable', 'DSL', 'Fiber optic','No Internet')),
		CONSTRAINT Internet_Service_PK PRIMARY KEY (Internet_Service_ID)
	);


Create Table Phone_Services 
	(
		Phone_Service_ID int NOT NULL ,
		Customer_Id int ,
		Multiple_Lines bit Default 0 check (Multiple_Lines in(0,1)) ,
		Avg_Monthly_Long_Distance_Charges decimal(10,3) CHECK 
		(Avg_Monthly_Long_Distance_Charges >= 0),
		Total_Long_Distance_Charges decimal(10,3) CHECK 
		(Total_Long_Distance_Charges >= 0)
		CONSTRAINT Phone_Services_PK PRIMARY KEY (Phone_Service_ID) ,
		CONSTRAINT Customer_Phone_Services_FK FOREIGN KEY (Customer_Id) REFERENCES Customers(Customer_Id)
	);

CREATE TABLE Customer_Internet
	(
		Customer_ID int , 
		Internet_Service_ID int ,
		Online_Security bit Default 0 CHECK(Online_Security in (0,1)),
		Online_Backup bit Default 0 CHECK(Online_Backup in (0,1)),
		Device_Pro_Plan bit Default 0 CHECK(Device_Pro_Plan in (0,1)),
		Premium_TSupport bit Default 0 CHECK(Premium_TSupport in (0,1)),
		Streaming_TV bit Default 0 CHECK(Streaming_TV in (0,1)),
		Streaming_Movies bit Default 0 CHECK(Streaming_Movies in (0,1)),
		Streaming_Music bit Default 0 CHECK(Streaming_Music in (0,1)),
		Unlimited_Data bit Default 0 CHECK(Unlimited_Data in (0,1)),
		Avg_Monthly_GB int Default 0,
		Total_Extra_Data_Charges int Default 0,
		CONSTRAINT Customer_Internet_PK PRIMARY KEY (Customer_ID, Internet_Service_ID),
		CONSTRAINT Customer_Customer_Internet_FK FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID),
		CONSTRAINT Internet_Service_Customer_Internet_FK FOREIGN KEY (Internet_Service_ID) REFERENCES Internet_Services (Internet_Service_ID)
		
	);



CREATE TABLE Calls
	(
		Call_ID int  ,
		Customer_Id INT ,
		Agent VARCHAR(50),
		Date_Of_Call DATE ,
		Time_Of_Call TIME,
		Resolved bit Default 0 CHECK(Resolved in (0,1)),
		Answered bit Default 0 CHECK(Answered in (0,1)),
		Topic varchar(50)  CHECK(Topic in 
		('Contract related','Technical Support', 'Payment related', 'Admin Support', 'Streaming')),
			Speed_Of_Answer_In_Seconds int CHECK (Speed_Of_Answer_In_Seconds >= 0),
		Duration Time ,
		Satisfaction_Rating int CHECK (Satisfaction_Rating BETWEEN 1 AND 5),
		CONSTRAINT Calls_PK PRIMARY KEY (Call_ID),
		CONSTRAINT  Customer_Calls_FK FOREIGN KEY(Customer_ID) REFERENCES Customers(Customer_ID)
	)	
