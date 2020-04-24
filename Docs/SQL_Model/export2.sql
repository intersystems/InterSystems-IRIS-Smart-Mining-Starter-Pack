-- -----------------------------------------------------
-- Table CanonicalModelImportedEquipmentGroup
-- -----------------------------------------------------
CREATE TABLE CanonicalModelImportedEquipmentGroup (
  Id INT NOT NULL,
  Name VARCHAR(45) NULL,
  Description MEDIUMTEXT NULL,
  PRIMARY KEY (Id))



-- -----------------------------------------------------
-- Table CanonicalModelImportedEquipmentModel
-- -----------------------------------------------------
CREATE TABLE CanonicalModelImportedEquipmentModel (
  Id INT NOT NULL,
  Name VARCHAR(45) NULL,
  Brand VARCHAR(45) NULL,
  NominalCapacityTons FLOAT NULL,
  PRIMARY KEY (Id))



-- -----------------------------------------------------
-- Table CanonicalModelImportedEquipment
-- -----------------------------------------------------
CREATE TABLE CanonicalModelImportedEquipment (
  Id INT NOT NULL,
  Name VARCHAR(45) NULL,
  EquipmentGroup_Id INT NOT NULL,
  EquipmentModel_Id INT NOT NULL,
  PRIMARY KEY (Id),
  INDEX fk_Equipment_EquipmentGroup_idx (EquipmentGroup_Id ASC) VISIBLE,
  INDEX fk_Equipment_EquipmentModel1_idx (EquipmentModel_Id ASC) VISIBLE,
  CONSTRAINT fk_Equipment_EquipmentGroup
    FOREIGN KEY (EquipmentGroup_Id)
    REFERENCES CanonicalModelImportedEquipmentGroup (Id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_Equipment_EquipmentModel1
    FOREIGN KEY (EquipmentModel_Id)
    REFERENCES CanonicalModelImportedEquipmentModel (Id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)



-- -----------------------------------------------------
-- Table CanonicalModelImportedStatusReason
-- -----------------------------------------------------
CREATE TABLE CanonicalModelImportedStatusReason (
  Id INT NOT NULL,
  Reason VARCHAR(45) NULL,
  PRIMARY KEY (Id))



-- -----------------------------------------------------
-- Table CanonicalModelImportedStatusType
-- -----------------------------------------------------
CREATE TABLE CanonicalModelImportedStatusType (
  Id INT NOT NULL,
  Type VARCHAR(45) NULL,
  PRIMARY KEY (Id))



-- -----------------------------------------------------
-- Table CanonicalModelImportedShifType
-- -----------------------------------------------------
CREATE TABLE CanonicalModelImportedShifType (
  Id INT NOT NULL,
  Type VARCHAR(45) NULL,
  Other TINYTEXT NULL,
  PRIMARY KEY (Id))



-- -----------------------------------------------------
-- Table CanonicalModelImportedShift
-- -----------------------------------------------------
CREATE TABLE CanonicalModelImportedShift (
  Id INT NOT NULL,
  ShifType_Id INT NOT NULL,
  Date DATETIME NULL,
  INDEX fk_Shift_ShifType1_idx (ShifType_Id ASC) VISIBLE,
  PRIMARY KEY (Id),
  CONSTRAINT fk_Shift_ShifType1
    FOREIGN KEY (ShifType_Id)
    REFERENCES CanonicalModelImportedShifType (Id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)



-- -----------------------------------------------------
-- Table CanonicalModelImportedStatusEvent
-- -----------------------------------------------------
CREATE TABLE CanonicalModelImportedStatusEvent (
  Id INT NOT NULL,
  StatusType_Id INT NOT NULL,
  Shift_Id INT NOT NULL,
  Equipment_Id INT NOT NULL,
  StatusReason_Id INT NOT NULL,
  StartTime DATETIME NULL,
  EndTime DATETIME NULL,
  Duration INT NULL,
  PRIMARY KEY (Id, StatusType_Id),
  INDEX fk_StatusEvent_Equipment1_idx (Equipment_Id ASC) VISIBLE,
  INDEX fk_StatusEvent_StatusReason1_idx (StatusReason_Id ASC) VISIBLE,
  INDEX fk_StatusEvent_StatusType1_idx (StatusType_Id ASC) VISIBLE,
  INDEX fk_StatusEvent_Shift1_idx (Shift_Id ASC) VISIBLE,
  CONSTRAINT fk_StatusEvent_Equipment1
    FOREIGN KEY (Equipment_Id)
    REFERENCES CanonicalModelImportedEquipment (Id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_StatusEvent_StatusReason1
    FOREIGN KEY (StatusReason_Id)
    REFERENCES CanonicalModelImportedStatusReason (Id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_StatusEvent_StatusType1
    FOREIGN KEY (StatusType_Id)
    REFERENCES CanonicalModelImportedStatusType (Id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_StatusEvent_Shift1
    FOREIGN KEY (Shift_Id)
    REFERENCES CanonicalModelImportedShift (Id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)



-- -----------------------------------------------------
-- Table CanonicalModelImportedOEMInterface
-- -----------------------------------------------------
CREATE TABLE CanonicalModelImportedOEMInterface (
  Id INT NOT NULL,
  Name VARCHAR(45) NULL,
  Brand VARCHAR(45) NULL,
  PRIMARY KEY (Id))



-- -----------------------------------------------------
-- Table CanonicalModelImportedOEMInterfaceMap
-- -----------------------------------------------------
CREATE TABLE CanonicalModelImportedOEMInterfaceMap (
  OEMInterface_Id INT NOT NULL,
  Equipment_Id INT NOT NULL,
  OEMInterfaceMapcol VARCHAR(45) NULL,
  INDEX fk_OEMInterfaceMap_Equipment1_idx (Equipment_Id ASC) VISIBLE,
  PRIMARY KEY (OEMInterface_Id),
  CONSTRAINT fk_OEMInterfaceMap_Equipment1
    FOREIGN KEY (Equipment_Id)
    REFERENCES CanonicalModelImportedEquipment (Id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_OEMInterfaceMap_OEMInterface1
    FOREIGN KEY (OEMInterface_Id)
    REFERENCES CanonicalModelImportedOEMInterface (Id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)



-- -----------------------------------------------------
-- Table CanonicalModelImportedOEMEventType
-- -----------------------------------------------------
CREATE TABLE CanonicalModelImportedOEMEventType (
  Id INT NOT NULL,
  Description VARCHAR(45) NULL,
  Other VARCHAR(45) NULL,
  PRIMARY KEY (Id))



-- -----------------------------------------------------
-- Table CanonicalModelImportedSite
-- -----------------------------------------------------
CREATE TABLE CanonicalModelImportedSite (
  Id INT NOT NULL,
  Name VARCHAR(45) NULL,
  PRIMARY KEY (Id))



-- -----------------------------------------------------
-- Table CanonicalModelImportedLocation
-- -----------------------------------------------------
CREATE TABLE CanonicalModelImportedLocation (
  Id INT NOT NULL,
  Grade FLOAT NULL,
  Site_Id INT NOT NULL,
  PRIMARY KEY (Id),
  INDEX fk_Location_Site1_idx (Site_Id ASC) VISIBLE,
  CONSTRAINT fk_Location_Site1
    FOREIGN KEY (Site_Id)
    REFERENCES CanonicalModelImportedSite (Id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)



-- -----------------------------------------------------
-- Table CanonicalModelImportedOEMEvent
-- -----------------------------------------------------
CREATE TABLE CanonicalModelImportedOEMEvent (
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
  PRIMARY KEY (Id),
  INDEX fk_OEMEvent_OEMEventType1_idx (OEMEventType_Id ASC) VISIBLE,
  INDEX fk_OEMEvent_OEMInterface1_idx (OEMInterface_Id ASC) VISIBLE,
  INDEX fk_OEMEvent_Location1_idx (Location_Id ASC) VISIBLE,
  INDEX fk_OEMEvent_Shift1_idx (Shift_Id ASC) VISIBLE,
  CONSTRAINT fk_OEMEvent_OEMEventType1
    FOREIGN KEY (OEMEventType_Id)
    REFERENCES CanonicalModelImportedOEMEventType (Id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_OEMEvent_OEMInterface1
    FOREIGN KEY (OEMInterface_Id)
    REFERENCES CanonicalModelImportedOEMInterface (Id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_OEMEvent_Location1
    FOREIGN KEY (Location_Id)
    REFERENCES CanonicalModelImportedLocation (Id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_OEMEvent_Shift1
    FOREIGN KEY (Shift_Id)
    REFERENCES CanonicalModelImportedShift (Id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)



-- -----------------------------------------------------
-- Table CanonicalModelImportedCrewType
-- -----------------------------------------------------
CREATE TABLE CanonicalModelImportedCrewType (
  Id INT NOT NULL,
  Name VARCHAR(45) NULL,
  PRIMARY KEY (Id))



-- -----------------------------------------------------
-- Table CanonicalModelImportedOperator
-- -----------------------------------------------------
CREATE TABLE CanonicalModelImportedOperator (
  Id INT NOT NULL,
  FirstName VARCHAR(45) NULL,
  LastName VARCHAR(45) NULL,
  CrewType_Id INT NOT NULL,
  PRIMARY KEY (Id),
  INDEX fk_Operator_Crew1_idx (CrewType_Id ASC) VISIBLE,
  CONSTRAINT fk_Operator_Crew1
    FOREIGN KEY (CrewType_Id)
    REFERENCES CanonicalModelImportedCrewType (Id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)



-- -----------------------------------------------------
-- Table CanonicalModelImportedLoadEvent
-- -----------------------------------------------------
CREATE TABLE CanonicalModelImportedLoadEvent (
  Id INT NOT NULL,
  DumpEvent_Id INT NOT NULL,
  Shift_Id INT NOT NULL,
  Location_Id INT NOT NULL,
  EquipmentTruck_Id INT NOT NULL,
  EquipmentExcav_Id INT NOT NULL,
  OperatorTruck_Id INT NOT NULL,
  OperatorExcav_Id INT NOT NULL,
  Latitude FLOAT NULL,
  Longitude FLOAT NULL,
  MeasuredTons FLOAT NULL,
  PRIMARY KEY (Id, DumpEvent_Id),
  INDEX fk_ExchangeEvent_Shift1_idx (Shift_Id ASC) VISIBLE,
  INDEX fk_ExchangeEvent_Location1_idx (Location_Id ASC) VISIBLE,
  INDEX fk_ExchangeEvent_Equipment1_idx (EquipmentTruck_Id ASC) VISIBLE,
  INDEX fk_ExchangeEvent_Equipment2_idx (EquipmentExcav_Id ASC) VISIBLE,
  INDEX fk_ExchangeEvent_Operator1_idx (OperatorTruck_Id ASC) VISIBLE,
  INDEX fk_ExchangeEvent_Operator2_idx (OperatorExcav_Id ASC) VISIBLE,
  INDEX fk_LoadEvent_DumpEvent1_idx (DumpEvent_Id ASC) VISIBLE,
  CONSTRAINT fk_ExchangeEvent_Shift10
    FOREIGN KEY (Shift_Id)
    REFERENCES CanonicalModelImportedShift (Id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_ExchangeEvent_Location10
    FOREIGN KEY (Location_Id)
    REFERENCES CanonicalModelImportedLocation (Id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_ExchangeEvent_Equipment10
    FOREIGN KEY (EquipmentTruck_Id)
    REFERENCES CanonicalModelImportedEquipment (Id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_ExchangeEvent_Equipment20
    FOREIGN KEY (EquipmentExcav_Id)
    REFERENCES CanonicalModelImportedEquipment (Id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_ExchangeEvent_Operator10
    FOREIGN KEY (OperatorTruck_Id)
    REFERENCES CanonicalModelImportedOperator (Id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_ExchangeEvent_Operator20
    FOREIGN KEY (OperatorExcav_Id)
    REFERENCES CanonicalModelImportedOperator (Id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_LoadEvent_DumpEvent1
    FOREIGN KEY (DumpEvent_Id)
    REFERENCES CanonicalModelImportedDumpEvent (Id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)



-- -----------------------------------------------------
-- Table CanonicalModelImportedDumpEvent
-- -----------------------------------------------------
CREATE TABLE CanonicalModelImportedDumpEvent (
  Id INT NOT NULL,
  LoadEvent_Id INT NOT NULL,
  Shift_Id INT NOT NULL,
  Location_Id INT NOT NULL,
  EquipmentTruck_Id INT NOT NULL,
  EquipmentExcav_Id INT NOT NULL,
  OperatorTruck_Id INT NOT NULL,
  OperatorExcav_Id INT NOT NULL,
  Latitude FLOAT NULL,
  Longitude FLOAT NULL,
  MeasuredTons FLOAT NULL,
  PRIMARY KEY (Id, LoadEvent_Id),
  INDEX fk_ExchangeEvent_Shift1_idx (Shift_Id ASC) VISIBLE,
  INDEX fk_ExchangeEvent_Location1_idx (Location_Id ASC) VISIBLE,
  INDEX fk_ExchangeEvent_Equipment1_idx (EquipmentTruck_Id ASC) VISIBLE,
  INDEX fk_ExchangeEvent_Equipment2_idx (EquipmentExcav_Id ASC) VISIBLE,
  INDEX fk_ExchangeEvent_Operator1_idx (OperatorTruck_Id ASC) VISIBLE,
  INDEX fk_ExchangeEvent_Operator2_idx (OperatorExcav_Id ASC) VISIBLE,
  INDEX fk_DumpEvent_LoadEvent1_idx (LoadEvent_Id ASC) VISIBLE,
  CONSTRAINT fk_ExchangeEvent_Shift1
    FOREIGN KEY (Shift_Id)
    REFERENCES CanonicalModelImportedShift (Id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_ExchangeEvent_Location1
    FOREIGN KEY (Location_Id)
    REFERENCES CanonicalModelImportedLocation (Id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_ExchangeEvent_Equipment1
    FOREIGN KEY (EquipmentTruck_Id)
    REFERENCES CanonicalModelImportedEquipment (Id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_ExchangeEvent_Equipment2
    FOREIGN KEY (EquipmentExcav_Id)
    REFERENCES CanonicalModelImportedEquipment (Id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_ExchangeEvent_Operator1
    FOREIGN KEY (OperatorTruck_Id)
    REFERENCES CanonicalModelImportedOperator (Id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_ExchangeEvent_Operator2
    FOREIGN KEY (OperatorExcav_Id)
    REFERENCES CanonicalModelImportedOperator (Id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_DumpEvent_LoadEvent1
    FOREIGN KEY (LoadEvent_Id)
    REFERENCES CanonicalModelImportedLoadEvent (Id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)



-- -----------------------------------------------------
-- Table CanonicalModelImportedCrewRegistry
-- -----------------------------------------------------
CREATE TABLE CanonicalModelImportedCrewRegistry (
  Id INT NOT NULL,
  CrewType_Id INT NOT NULL,
  __OperatorList VARCHAR(45) NULL,
  PRIMARY KEY (Id),
  INDEX fk_CrewRegistry_Crew1_idx (CrewType_Id ASC) VISIBLE,
  CONSTRAINT fk_CrewRegistry_Crew1
    FOREIGN KEY (CrewType_Id)
    REFERENCES CanonicalModelImportedCrewType (Id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
