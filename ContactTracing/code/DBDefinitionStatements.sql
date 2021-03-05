-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema contact_tracing
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `contact_tracing` ;

-- -----------------------------------------------------
-- Schema contact_tracing
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `contact_tracing` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `contact_tracing` ;

-- -----------------------------------------------------
-- Table `contact_tracing`.`Status`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `contact_tracing`.`Status` ;

CREATE TABLE IF NOT EXISTS `contact_tracing`.`Status` (
  `StatusId` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Description` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`StatusId`),
  UNIQUE INDEX `Description_UNIQUE` (`Description` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `contact_tracing`.`Address`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `contact_tracing`.`Address` ;

CREATE TABLE IF NOT EXISTS `contact_tracing`.`Address` (
  `AddressId` INT NOT NULL AUTO_INCREMENT,
  `Street` VARCHAR(45) NOT NULL,
  `City` VARCHAR(45) NOT NULL,
  `State` VARCHAR(45) NULL,
  `Zipcode` VARCHAR(45) NULL,
  `Country` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`AddressId`),
  UNIQUE INDEX `AddressId_UNIQUE` (`AddressId` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `contact_tracing`.`Exposure`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `contact_tracing`.`Exposure` ;

CREATE TABLE IF NOT EXISTS `contact_tracing`.`Exposure` (
  `ExposureId` INT NOT NULL AUTO_INCREMENT,
  `Level` VARCHAR(45) NOT NULL,
  `Description` VARCHAR(100) NULL,
  PRIMARY KEY (`ExposureId`),
  UNIQUE INDEX `ExposureLevel` (`ExposureId` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `contact_tracing`.`Office`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `contact_tracing`.`Office` ;

CREATE TABLE IF NOT EXISTS `contact_tracing`.`Office` (
  `OfficeId` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(45) NOT NULL,
  `AddressId` INT NOT NULL,
  `PhoneNumber` VARCHAR(20) NULL,
  PRIMARY KEY (`OfficeId`),
  UNIQUE INDEX `OfficeId_UNIQUE` (`OfficeId` ASC) VISIBLE,
  INDEX `fk_Office_Address_idx` (`AddressId` ASC) VISIBLE,
  CONSTRAINT `fk_Office_Address`
    FOREIGN KEY (`AddressId`)
    REFERENCES `contact_tracing`.`Address` (`AddressId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `contact_tracing`.`Employee`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `contact_tracing`.`Employee` ;

CREATE TABLE IF NOT EXISTS `contact_tracing`.`Employee` (
  `EmployeeId` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `FirstName` VARCHAR(45) NOT NULL,
  `LastName` VARCHAR(45) NOT NULL,
  `PhoneNumber` VARCHAR(20) NULL,
  `Email` VARCHAR(100) NULL,
  `Title` VARCHAR(45) NULL,
  `OfficeId` INT NOT NULL,
  PRIMARY KEY (`EmployeeId`),
  INDEX `fk_Employee_Office1_idx` (`OfficeId` ASC) VISIBLE,
  CONSTRAINT `fk_Employee_Office`
    FOREIGN KEY (`OfficeId`)
    REFERENCES `contact_tracing`.`Office` (`OfficeId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `contact_tracing`.`Contact`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `contact_tracing`.`Contact` ;

CREATE TABLE IF NOT EXISTS `contact_tracing`.`Contact` (
  `ContactId` INT NOT NULL AUTO_INCREMENT,
  `FirstName` VARCHAR(45) NULL,
  `LastName` VARCHAR(45) NULL,
  `DOB` DATE NULL,
  `Sex` ENUM('Decline', 'Female', 'Male') NULL,
  `Ethnicity` ENUM('White', 'African American', 'Native American or Alaskan Native', 'Pacific Islander', 'Asian', 'Native Hawaiian') NULL,
  `AddressId` INT NULL,
  `PhoneNumber` VARCHAR(20) NULL,
  `Email` VARCHAR(100) NULL,
  `PreferredContact` ENUM('Phone', 'Email') NULL,
  `EmployeeId` INT UNSIGNED NULL,
  `ReferringContactId` INT NULL,
  `ExposureStartDate` DATETIME NULL,
  `ExposureEndDate` DATETIME NULL,
  `ExposureDetails` VARCHAR(100) NULL,
  `ExposureId` INT NULL,
  `Consent` TINYINT NOT NULL,
  `Confidential` TINYINT NOT NULL,
  `StatusId` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`ContactId`),
  UNIQUE INDEX `PatientId_UNIQUE` (`ContactId` ASC) VISIBLE,
  INDEX `fk_Contact_Address_idx` (`AddressId` ASC) VISIBLE,
  INDEX `fk_Contact_Exposure_idx` (`ExposureId` ASC) VISIBLE,
  INDEX `fk_Contact_Employee_idx` (`EmployeeId` ASC) VISIBLE,
  INDEX `fk_Contact_Contact_idx` (`ReferringContactId` ASC) VISIBLE,
  INDEX `fk_Contact_Status_idx` (`StatusId` ASC) VISIBLE,
  CONSTRAINT `fk_Contact_Address`
    FOREIGN KEY (`AddressId`)
    REFERENCES `contact_tracing`.`Address` (`AddressId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Contact_Exposure`
    FOREIGN KEY (`ExposureId`)
    REFERENCES `contact_tracing`.`Exposure` (`ExposureId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Contact_Employee`
    FOREIGN KEY (`EmployeeId`)
    REFERENCES `contact_tracing`.`Employee` (`EmployeeId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Contact_Contact`
    FOREIGN KEY (`ReferringContactId`)
    REFERENCES `contact_tracing`.`Contact` (`ContactId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Contact_Status`
    FOREIGN KEY (`StatusId`)
    REFERENCES `contact_tracing`.`Status` (`StatusId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `contact_tracing`.`ContactStatus`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `contact_tracing`.`ContactStatus` ;

CREATE TABLE IF NOT EXISTS `contact_tracing`.`ContactStatus` (
  `ContactStatusId` INT NOT NULL AUTO_INCREMENT,
  `ContactId` INT NOT NULL,
  `StatusId` INT UNSIGNED NOT NULL,
  `SelfQuarantined` TINYINT NULL,
  `Date` DATE NOT NULL,
  `SelfReportedStatus` TINYINT NULL,
  `EmployeeId` INT UNSIGNED NULL,
  PRIMARY KEY (`ContactStatusId`, `ContactId`),
  INDEX `fk_CaseStatus_Status_idx` (`StatusId` ASC) VISIBLE,
  INDEX `fk_CaseStatus_Contact_idx` (`ContactId` ASC) VISIBLE,
  INDEX `fk_ContactStatus_Employee_idx` (`EmployeeId` ASC) VISIBLE,
  CONSTRAINT `fk_CaseStatus_Status`
    FOREIGN KEY (`StatusId`)
    REFERENCES `contact_tracing`.`Status` (`StatusId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_CaseStatus_Contact`
    FOREIGN KEY (`ContactId`)
    REFERENCES `contact_tracing`.`Contact` (`ContactId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ContactStatus_Employee`
    FOREIGN KEY (`EmployeeId`)
    REFERENCES `contact_tracing`.`Employee` (`EmployeeId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `contact_tracing`.`TestingCenter`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `contact_tracing`.`TestingCenter` ;

CREATE TABLE IF NOT EXISTS `contact_tracing`.`TestingCenter` (
  `TestCenterId` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(45) NOT NULL,
  `AddressId` INT NOT NULL,
  `PhoneNumber` VARCHAR(20) NULL,
  `LicenseNumber` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`TestCenterId`),
  INDEX `fk_TestingCenter_Address_idx` (`AddressId` ASC) VISIBLE,
  CONSTRAINT `fk_TestingCenter_Address`
    FOREIGN KEY (`AddressId`)
    REFERENCES `contact_tracing`.`Address` (`AddressId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `contact_tracing`.`TestType`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `contact_tracing`.`TestType` ;

CREATE TABLE IF NOT EXISTS `contact_tracing`.`TestType` (
  `TestTypeId` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`TestTypeId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `contact_tracing`.`Tester`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `contact_tracing`.`Tester` ;

CREATE TABLE IF NOT EXISTS `contact_tracing`.`Tester` (
  `TesterId` INT NOT NULL AUTO_INCREMENT,
  `FirstName` VARCHAR(45) NOT NULL,
  `LastName` VARCHAR(45) NOT NULL,
  `PhoneNumber` VARCHAR(45) NULL,
  `Email` VARCHAR(45) NULL,
  `TestCenterId` INT NOT NULL,
  PRIMARY KEY (`TesterId`),
  INDEX `fk_Tester_TestingCenter_idx` (`TestCenterId` ASC) VISIBLE,
  CONSTRAINT `fk_Tester_TestingCenter`
    FOREIGN KEY (`TestCenterId`)
    REFERENCES `contact_tracing`.`TestingCenter` (`TestCenterId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `contact_tracing`.`Test`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `contact_tracing`.`Test` ;

CREATE TABLE IF NOT EXISTS `contact_tracing`.`Test` (
  `TestId` INT NOT NULL AUTO_INCREMENT,
  `TestCenterId` INT NOT NULL,
  `ContactId` INT NOT NULL,
  `DateTime` DATETIME NULL,
  `Result` ENUM('NotAvailable', 'Positive', 'Negative', 'Inconclusive') NULL,
  `TestTypeId` INT NOT NULL,
  `TesterId` INT NULL,
  PRIMARY KEY (`TestId`, `ContactId`),
  UNIQUE INDEX `TestId_UNIQUE` (`TestId` ASC) VISIBLE,
  INDEX `fk_Test_TestingCenter_idx` (`TestCenterId` ASC) VISIBLE,
  INDEX `fk_Test_Contact_idx` (`ContactId` ASC) VISIBLE,
  INDEX `fk_Test_TestType_idx` (`TestTypeId` ASC) VISIBLE,
  INDEX `fk_Test_Tester_idx` (`TesterId` ASC) VISIBLE,
  CONSTRAINT `fk_Test_TestingCenter`
    FOREIGN KEY (`TestCenterId`)
    REFERENCES `contact_tracing`.`TestingCenter` (`TestCenterId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Test_Contact`
    FOREIGN KEY (`ContactId`)
    REFERENCES `contact_tracing`.`Contact` (`ContactId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Test_TestType`
    FOREIGN KEY (`TestTypeId`)
    REFERENCES `contact_tracing`.`TestType` (`TestTypeId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Test_Tester`
    FOREIGN KEY (`TesterId`)
    REFERENCES `contact_tracing`.`Tester` (`TesterId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `contact_tracing`.`Interview`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `contact_tracing`.`Interview` ;

CREATE TABLE IF NOT EXISTS `contact_tracing`.`Interview` (
  `InterviewId` INT NOT NULL AUTO_INCREMENT,
  `EmployeeId` INT UNSIGNED NOT NULL,
  `ContactId` INT NOT NULL,
  `OfficeId` INT NULL,
  `InterviewType` ENUM('Phone', 'InPerson', 'Video') NULL,
  `Datetime` DATETIME NOT NULL,
  `PatientPresent` TINYINT NULL,
  `InterviewNotes` VARCHAR(200) NULL,
  PRIMARY KEY (`InterviewId`),
  UNIQUE INDEX `InterviewId_UNIQUE` (`InterviewId` ASC) VISIBLE,
  INDEX `fk_Interview_Employee_idx` (`EmployeeId` ASC) VISIBLE,
  INDEX `fk_Interview_Contact_idx` (`ContactId` ASC) VISIBLE,
  INDEX `fk_Interview_Office_idx` (`OfficeId` ASC) VISIBLE,
  CONSTRAINT `fk_Interview_Employee`
    FOREIGN KEY (`EmployeeId`)
    REFERENCES `contact_tracing`.`Employee` (`EmployeeId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Interview_Contact`
    FOREIGN KEY (`ContactId`)
    REFERENCES `contact_tracing`.`Contact` (`ContactId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Interview_Office`
    FOREIGN KEY (`OfficeId`)
    REFERENCES `contact_tracing`.`Office` (`OfficeId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `contact_tracing`.`Symptom`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `contact_tracing`.`Symptom` ;

CREATE TABLE IF NOT EXISTS `contact_tracing`.`Symptom` (
  `SymptomId` INT NOT NULL AUTO_INCREMENT,
  `Description` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`SymptomId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `contact_tracing`.`ContactSymptom`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `contact_tracing`.`ContactSymptom` ;

CREATE TABLE IF NOT EXISTS `contact_tracing`.`ContactSymptom` (
  `ContactSymptomId` INT NOT NULL AUTO_INCREMENT,
  `Date` DATETIME NOT NULL,
  `ContactId` INT NOT NULL,
  `SymptomId` INT NULL,
  PRIMARY KEY (`ContactSymptomId`),
  UNIQUE INDEX `Date_UNIQUE` (`Date` ASC) VISIBLE,
  INDEX `fk_ContactSymptom_Contact_idx` (`ContactId` ASC) VISIBLE,
  INDEX `fk_ContactSymptom_Symptom_idx` (`SymptomId` ASC) VISIBLE,
  CONSTRAINT `fk_ContactSymptom_Contact`
    FOREIGN KEY (`ContactId`)
    REFERENCES `contact_tracing`.`Contact` (`ContactId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ContactSymptom_Symptom`
    FOREIGN KEY (`SymptomId`)
    REFERENCES `contact_tracing`.`Symptom` (`SymptomId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `contact_tracing`.`ContactTravel`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `contact_tracing`.`ContactTravel` ;

CREATE TABLE IF NOT EXISTS `contact_tracing`.`ContactTravel` (
  `TravelId` INT NOT NULL AUTO_INCREMENT,
  `ContactId` INT NOT NULL,
  `AddressId` INT NOT NULL,
  `Name` VARCHAR(45) NOT NULL,
  `StartDateTime` DATETIME NOT NULL,
  `EndDateTime` DATETIME NULL,
  `Notified` TINYINT NULL,
  `Type` ENUM('Transportation', 'Location') NULL,
  PRIMARY KEY (`TravelId`),
  INDEX `fk_ContactTravel_Contact_idx` (`ContactId` ASC) VISIBLE,
  INDEX `fk_ContactTravel_Address_idx` (`AddressId` ASC) VISIBLE,
  CONSTRAINT `fk_ContactTravel_Contact`
    FOREIGN KEY (`ContactId`)
    REFERENCES `contact_tracing`.`Contact` (`ContactId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ContactTravel_Address`
    FOREIGN KEY (`AddressId`)
    REFERENCES `contact_tracing`.`Address` (`AddressId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `contact_tracing`.`Service`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `contact_tracing`.`Service` ;

CREATE TABLE IF NOT EXISTS `contact_tracing`.`Service` (
  `ServiceId` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(45) NULL,
  `Type` ENUM('Meals', 'Urgent Care', 'Doctor', 'Clinic', 'Hospital', 'Testing Center', 'Grocery Store', 'Pharmacy', 'Safe Housing') NOT NULL,
  `URL` VARCHAR(100) NULL,
  `PhoneNumber` VARCHAR(20) NULL,
  `AddressId` INT NULL,
  PRIMARY KEY (`ServiceId`),
  INDEX `fk_Services_Address_idx` (`AddressId` ASC) VISIBLE,
  CONSTRAINT `fk_Services_Address`
    FOREIGN KEY (`AddressId`)
    REFERENCES `contact_tracing`.`Address` (`AddressId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `contact_tracing`.`Resources`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `contact_tracing`.`Resources` ;

CREATE TABLE IF NOT EXISTS `contact_tracing`.`Resources` (
  `ResourceId` INT NOT NULL AUTO_INCREMENT,
  `URL` VARCHAR(150) NULL,
  `Type` ENUM('Health Information', 'Statistics', 'Data', 'Social Media') NOT NULL,
  PRIMARY KEY (`ResourceId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `contact_tracing`.`Essentials`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `contact_tracing`.`Essentials` ;

CREATE TABLE IF NOT EXISTS `contact_tracing`.`Essentials` (
  `EssentialsId` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(45) NOT NULL,
  `Quantity` INT NULL,
  `ServiceId` INT NULL,
  INDEX `fk_Essentials_Services_idx` (`ServiceId` ASC) VISIBLE,
  PRIMARY KEY (`EssentialsId`),
  CONSTRAINT `fk_Essentials_Services`
    FOREIGN KEY (`ServiceId`)
    REFERENCES `contact_tracing`.`Service` (`ServiceId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
