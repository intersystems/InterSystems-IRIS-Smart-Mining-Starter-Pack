
-- -----------------------------------------------------
-- Table mydb.EquipmentGroup
-- -----------------------------------------------------
CREATE TABLE EquipmentGroup (
  Id INT NOT NULL,
  Name VARCHAR(45) NULL,
  Description VARCHAR(1000) NULL,
  PRIMARY KEY (Id));


-- -----------------------------------------------------
-- Table mydb.EquipmentModel
-- -----------------------------------------------------
CREATE TABLE EquipmentModel (
  Id INT NOT NULL,
  Name VARCHAR(45) NULL,
  Brand VARCHAR(45) NULL,
  NominalCapacityTons FLOAT NULL,
  PRIMARY KEY (Id));


-- -----------------------------------------------------
-- Table mydb.Equipment
-- -----------------------------------------------------
CREATE TABLE Equipment (
  Id INT NOT NULL,
  Name VARCHAR(45) NULL,
  EquipmentGroup_Id INT NOT NULL,
  EquipmentModel_Id INT NOT NULL,
  PRIMARY KEY (Id));


-- -----------------------------------------------------
-- Table mydb.StatusReason
-- -----------------------------------------------------
CREATE TABLE StatusReason (
  Id INT NOT NULL,
  Reason VARCHAR(45) NULL,
  PRIMARY KEY (Id));


-- -----------------------------------------------------
-- Table mydb.StatusType
-- -----------------------------------------------------
CREATE TABLE StatusType (
  Id INT NOT NULL,
  Type VARCHAR(45) NULL,
  PRIMARY KEY (Id));


-- -----------------------------------------------------
-- Table mydb.StatusEvent
-- -----------------------------------------------------
CREATE TABLE StatusEvent (
  Id INT NOT NULL,
  Equipment_Id INT NOT NULL,
  StatusReason_Id INT NOT NULL,
  StatusType_Id INT NOT NULL,
  PRIMARY KEY (Id, StatusType_Id));


-- -----------------------------------------------------
-- Table mydb.OEMInterface
-- -----------------------------------------------------
CREATE TABLE OEMInterface (
  Id INT NOT NULL,
  Name VARCHAR(45) NULL,
  Brand VARCHAR(45) NULL,
  PRIMARY KEY (Id));


-- -----------------------------------------------------
-- Table mydb.OEMInterfaceMap
-- -----------------------------------------------------
CREATE TABLE OEMInterfaceMap (
  OEMInterface_Id INT NOT NULL,
  Equipment_Id INT NOT NULL,
  OEMInterfaceMapcol VARCHAR(45) NULL,
  PRIMARY KEY (OEMInterface_Id));


-- -----------------------------------------------------
-- Table mydb.OEMEventType
-- -----------------------------------------------------
CREATE TABLE OEMEventType (
  Id INT NOT NULL,
  Description VARCHAR(45) NULL,
  Other VARCHAR(45) NULL,
  PRIMARY KEY (Id));


-- -----------------------------------------------------
-- Table mydb.Site
-- -----------------------------------------------------
CREATE TABLE Site (
  Id INT NOT NULL,
  Name VARCHAR(45) NULL,
  PRIMARY KEY (Id));


-- -----------------------------------------------------
-- Table mydb.Location
-- -----------------------------------------------------
CREATE TABLE Location (
  Id INT NOT NULL,
  Grade FLOAT NULL,
  Site_Id INT NOT NULL,
  PRIMARY KEY (Id));


-- -----------------------------------------------------
-- Table mydb.ShifType
-- -----------------------------------------------------
CREATE TABLE ShifType (
  Id INT NOT NULL,
  Type VARCHAR(45) NULL,
  Other VARCHAR(100) NULL,
  PRIMARY KEY (Id));


-- -----------------------------------------------------
-- Table mydb.Shift
-- -----------------------------------------------------
CREATE TABLE Shift (
  Id INT NOT NULL,
  ShifType_Id INT NOT NULL,
  DateShift DATETIME NULL,
  PRIMARY KEY (Id));


-- -----------------------------------------------------
-- Table mydb.OEMEvent
-- -----------------------------------------------------
CREATE TABLE OEMEvent (
  Id INT NOT NULL,
  OEMEventType_Id INT NOT NULL,
  OEMInterface_Id INT NOT NULL,
  Shift_Id INT NOT NULL,
  Location_Id INT NULL,
  ReadTime DATETIME NULL,
  Value FLOAT NULL,
  Latitude FLOAT NULL,
  Longitude FLOAT NULL,
  EquipmentId VARCHAR(45) NULL,
  PRIMARY KEY (Id));


-- -----------------------------------------------------
-- Table mydb.ExchangeType
-- -----------------------------------------------------
CREATE TABLE ExchangeType (
  Id INT NOT NULL,
  Type VARCHAR(45) NULL,
  PRIMARY KEY (Id));


-- -----------------------------------------------------
-- Table mydb.CrewType
-- -----------------------------------------------------
CREATE TABLE CrewType (
  Id INT NOT NULL,
  Name VARCHAR(45) NULL,
  PRIMARY KEY (Id));


-- -----------------------------------------------------
-- Table mydb.Operator
-- -----------------------------------------------------
CREATE TABLE Operator (
  Id INT NOT NULL,
  FirstName VARCHAR(45) NULL,
  LastName VARCHAR(45) NULL,
  CrewType_Id INT NOT NULL,
  PRIMARY KEY (Id));


-- -----------------------------------------------------
-- Table mydb.ExchangeEvent
-- -----------------------------------------------------
CREATE TABLE ExchangeEvent (
  Id INT NOT NULL,
  ExchangeType_Id INT NOT NULL,
  Shift_Id INT NOT NULL,
  Location_Id INT NOT NULL,
  EquipmentTruck_Id INT NOT NULL,
  EquipmentExcav_Id INT NOT NULL,
  OperatorTruck_Id INT NOT NULL,
  OperatorExcav_Id INT NOT NULL,
  Latitude FLOAT NULL,
  Longitude FLOAT NULL,
  MeasuredTons FLOAT NULL,
  PRIMARY KEY (Id));


-- -----------------------------------------------------
-- Table mydb.CrewRegistry
-- -----------------------------------------------------
CREATE TABLE CrewRegistry (
  Id INT NOT NULL,
  CrewType_Id INT NOT NULL,
  OperatorList VARCHAR(45) NULL,
  PRIMARY KEY (Id));