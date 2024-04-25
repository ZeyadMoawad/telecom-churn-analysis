Create Database TelecomChurmDWH
GO

use TelecomChurmDWH

go

Create Table Dim_Customers 
	(
		Customer_Key INT NOT NULL Identity (1,1) ,
		Customer_ID INT ,
		Referred_A_Friend bit Default 0 CHECK(Referred_A_Friend in (0,1)),
		Gender varchar(10) Default 'Male' CHECK(Gender in ('Female','Male')), 
		Age INT ,
		Married Bit Default 0 CHECK(Married in (0,1)), 
		Dependents bit Default 0 CHECK(Dependents in (0,1)), 
		Offer varchar(10) CHECK(Offer in ('Offer A','Offer B','Offer C','Offer D','Offer E','None')), 
		Paperless_Billing bit Default 0 CHECK(Paperless_Billing in (0,1)) , 
		Payment_Method varchar(50) Default 'Bank_Transfe' CHECK
		(Payment_Method in ('Bank Withdrawal', 'Credit Card', 'Mailed Check')),
		source_system_code tinyint NOT NULL,
		Start_Date datetime NOT NULL Default (GetDate()),
		End_Date datetime NULL,
		Is_Current tinyint NOT NULL Default(1),
		Constraint Dim_Customer_PK Primary key (Customer_Key)

	);

Create Table Dim_Calls 
	(
		Call_Key INT NOT NULL Identity (1,1) ,
		Call_ID INT ,
		Agent VARCHAR(50),
		Date_Of_Call DATE ,
		Time_Of_Call TIME,
		Resolved bit Default 0 CHECK(Resolved in (0,1)),
		Answered bit Default 0 CHECK(Answered in (0,1)),
		Topic varchar(50)  CHECK(Topic in 
		('Contract related','Technical Support', 'Payment related', 'Admin Support', 'Streaming')),
		Constraint Dim_Call_Pk Primary Key (Call_Key) 
	
	);

Create Table Dim_Locations 
	(
		Location_key INT NOT NULL identity (1,1),
		Location_ID INT ,
		City Varchar(50) ,
		Latitude FLOAT,
		Longitude FLOAT ,
		Population_Num INT check (Population_Num>0 ),
		Constraint Dim_Location_PK primary key (Location_key)
	
	);

Create Table Dim_Churn_Reasons
	(
		Churn_Reason_Key INT  NOT NULL identity (1,1),
		Churn_Reason_ID INT NOT NULL ,
		Churn_Reason VARCHAR(150) ,
		Churn_Category VARCHAR(50) CHECK (Churn_Category IN 
		('Competitor','Dissatisfaction','Price', 'Attitude', 'Other')),
		Constraint Dim_Churn_Reason_PK primary key (Churn_Reason_Key)
	);


Create Table Dim_Contracts
	(
		Contract_Key INT NOT NULL Identity(1,1),
		Contract_ID INT ,
		Contract_Type VARCHAR(50) CHECK 
		(Contract_Type IN ('Month-to-Month', 'One Year', 'Two Year')) ,
		Constraint Dim_Contract_PK Primary Key (Contract_Key)
	);


Create Table Dim_Status
	(
		Status_Key INT NOT NULL Identity(1,1),
		Status_ID INT  ,
		Customer_Status VARCHAR(50) CHECK 
		(Customer_Status IN ('Churned', 'Stayed', 'Joined')),
		CONSTRAINT Dim_Statu_pk PRIMARY KEY (Status_Key)

	);


Create Table Dim_Phone_Services
	(
		Phone_Service_Key INT NOT NULL Identity(1,1),
		Phone_Service_ID INT,
		Multiple_Lines Bit Default 0 Check (Multiple_Lines in(0,1)) ,
		Constraint Phone_Service_PK Primary Key (Phone_Service_Key)
	);


Create Table Dim_Internet_Service_Details
	(
		Internet_Service_Key INT NOT NULL Identity(1,1),
		Internet_Service_ID INT ,
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
		Internet_Type VARCHAR(50) CHECK 
		(Internet_Type IN ('Cable', 'DSL', 'Fiber optic','No Internet')),
		Constraint Internet_Service_PK Primary key(Internet_Service_Key)
	);


CREATE TABLE Dim_Date 
	(
		Date_Key INT NOT NULL PRIMARY KEY,
		Date DATE NOT NULL,
		Day TINYINT NOT NULL,
		WeekDayName VARCHAR(10) NOT NULL,
		Month TINYINT NOT NULL,
		MonthName VARCHAR(10) NOT NULL,
		MonthName_Short CHAR(3) NOT NULL,
		Quarter TINYINT NOT NULL,
		QuarterName VARCHAR(6) NOT NULL,
		Year INT NOT NULL,
		MMYYYY CHAR(6) NOT NULL,
		MonthYear CHAR(7) NOT NULL
	  
	);


Create Table Fact_TelecomChurm
	(
		Fact_Id INT NOT NULL Identity (1,1),
		Customer_Key INT ,
		Contract_key INT ,
		Status_Key INT ,
		Internet_Service_Key INT , 
		Location_Key INT ,
		Phone_Service_Key INT ,
		Churn_Reason_key INT ,
		Call_key INT ,
		Date_Key INT ,
		Number_Of_Referrals INT Default 0, 
		Number_Of_Dependents INT Default 0,
		Churn_Score INT CHECK(Churn_Score between 0 and 100), 
		Satisfaction_Score INT CHECK(Satisfaction_Score between 1 and 5),
		CLTV Float, 
		Tenure_In_Months INT,
		Monthly_Charge Float,
		Speed_Of_Answer_In_Seconds int CHECK (Speed_Of_Answer_In_Seconds >= 0),
		Duration Time ,
		Satisfaction_Rating int CHECK (Satisfaction_Rating BETWEEN 1 AND 5),
		Avg_Monthly_Long_Distance_Charges decimal(10,3) CHECK 
		(Avg_Monthly_Long_Distance_Charges >= 0),
		Total_Long_Distance_Charges decimal(10,3) CHECK 
		(Total_Long_Distance_Charges >= 0),
		Total_Charges Float, 
		Total_Refunds Float, 
		Total_Revenue Float, 
		Created_At Datetime Default(GetDate()),
		Constraint Fact_PK Primary Key (Fact_Id),
		Constraint Customer_Fact_FK Foreign key (Customer_Key) references Dim_Customers(Customer_Key) ,
		Constraint Call_Fact_FK Foreign key (Call_Key) references Dim_Calls(Call_Key) ,
		Constraint Location_Fact_FK Foreign key (Location_key) references Dim_Locations (Location_key) ,
		Constraint Churn_Reason_Fact_FK Foreign key (Churn_Reason_Key) references Dim_Churn_Reasons(Churn_Reason_Key) ,
		Constraint Contract_Fact_FK Foreign key (Contract_key) references Dim_Contracts(Contract_key) ,
		Constraint Status_Fact_FK Foreign key (Status_Key) references Dim_Status(Status_Key) ,
		Constraint Phone_Service_Fact_FK Foreign key (Phone_Service_Key) references Dim_Phone_Services (Phone_Service_Key) ,
		Constraint Internet_Service_Fact_FK Foreign key (Internet_Service_Key) references Dim_Internet_Service_Details(Internet_Service_Key) ,
		Constraint Date_Fact_FK Foreign key (Date_Key) references Dim_Date(Date_Key) 

	);