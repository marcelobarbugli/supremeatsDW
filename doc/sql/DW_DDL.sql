SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`DW_Category`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `mydb`.`DW_Category` (
  `SKCategoryID` INT NOT NULL ,
  `CategoryID` INT NOT NULL ,
  `DT_INI` DATE NULL ,
  `DT_FIM` DATE NULL ,
  `DT_LOAD` DATE NULL ,
  `CategoryName` CHAR(20) NULL ,
  `CategoryDescription` VARCHAR(80) NULL ,
  `CHECKSUM` CHAR(32) NULL ,
  PRIMARY KEY (`SKCategoryID`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`DW_Supplier`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `mydb`.`DW_Supplier` (
  `SKSupplierID` INT NOT NULL ,
  `SupplierID` INT NOT NULL ,
  `DT_INI` DATE NULL ,
  `DT_FIM` DATE NULL ,
  `DT_LOAD` DATE NULL ,
  `CompanyName` VARCHAR(50) NULL ,
  `ContactName` VARCHAR(50) NULL ,
  `ContactTitle` VARCHAR(30) NULL ,
  `Address` VARCHAR(50) NULL ,
  `City` VARCHAR(50) NULL ,
  `Region` VARCHAR(50) NULL ,
  `PostalCode` CHAR(10) NULL ,
  `Country` VARCHAR(50) NULL ,
  `CHECKSUM` CHAR(32) NULL ,
  PRIMARY KEY (`SKSupplierID`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`DW_Product`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `mydb`.`DW_Product` (
  `SKProductID` INT NOT NULL ,
  `ProductID` INT NOT NULL ,
  `DT_INI` DATE NULL ,
  `DT_FIM` DATE NULL ,
  `DT_LOAD` DATE NULL ,
  `ProductName` VARCHAR(50) NULL ,
  `SKCategoryID` INT NOT NULL ,
  `SKSupplierID` INT NOT NULL ,
  `QuantityPerUnit` VARCHAR(20) NULL ,
  `UnitPrice` DECIMAL(7,2) NULL ,
  `UnitsInStock` INT(11) NULL ,
  `UnitsOnOrder` INT(11) NULL ,
  `Discontinued` CHAR(1) NULL ,
  `CHECKSUM` CHAR(32) NULL ,
  PRIMARY KEY (`SKProductID`) ,
  INDEX `fk_Product_Category_idx` (`SKCategoryID` ASC) ,
  INDEX `fk_Product_Supplier1_idx` (`SKSupplierID` ASC) ,
  CONSTRAINT `fk_Product_Category`
    FOREIGN KEY (`SKCategoryID` )
    REFERENCES `mydb`.`DW_Category` (`SKCategoryID` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Product_Supplier`
    FOREIGN KEY (`SKSupplierID` )
    REFERENCES `mydb`.`DW_Supplier` (`SKSupplierID` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`DW_Customer`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `mydb`.`DW_Customer` (
  `SKCustomerID` INT NOT NULL ,
  `CustomerID` CHAR(5) NOT NULL ,
  `DT_INI` DATE NULL ,
  `DT_FIM` DATE NULL ,
  `DT_LOAD` DATE NULL ,
  `CompanyName` VARCHAR(50) NULL ,
  `ContactName` VARCHAR(50) NULL ,
  `ContactTitle` VARCHAR(50) NULL ,
  `Address` VARCHAR(50) NULL ,
  `City` VARCHAR(50) NULL ,
  `Region` VARCHAR(50) NULL ,
  `PostalCode` VARCHAR(50) NULL ,
  `Country` VARCHAR(50) NULL ,
  `CHECKSUM` CHAR(32) NULL ,
  PRIMARY KEY (`SKCustomerID`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`DW_Shipper`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `mydb`.`DW_Shipper` (
  `SKShipperID` INT NOT NULL ,
  `ShipperID` INT NOT NULL ,
  `DT_INI` DATE NULL ,
  `DT_FIM` DATE NULL ,
  `DT_LOAD` DATE NULL ,
  `CompanyName` VARCHAR(50) NULL ,
  `CHECKSUM` CHAR(32) NULL ,
  PRIMARY KEY (`SKShipperID`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`DW_Employee`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `mydb`.`DW_Employee` (
  `SKEmployeeID` INT NOT NULL ,
  `EmployeeID` INT NOT NULL ,
  `DT_INI` DATE NULL ,
  `DT_FIM` DATE NULL ,
  `DT_LOAD` DATE NULL ,
  `LastName` VARCHAR(20) NULL ,
  `FirstName` VARCHAR(20) NULL ,
  `Title` VARCHAR(50) NULL ,
  `BirthDate` DATE NULL ,
  `HireDate` DATE NULL ,
  `Salary` DECIMAL(7,2) NULL ,
  `CHECKSUM` CHAR(32) NULL ,
  PRIMARY KEY (`SKEmployeeID`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`DW_Store`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `mydb`.`DW_Store` (
  `SKStoreID` INT NOT NULL ,
  `StoreID` INT NOT NULL ,
  `DT_INI` DATE NULL ,
  `DT_FIM` DATE NULL ,
  `DT_LOAD` DATE NULL ,
  `ManagerID` INT NOT NULL ,
  `Address` VARCHAR(45) NULL ,
  `City` VARCHAR(45) NULL ,
  `Region` VARCHAR(45) NULL ,
  `PostalCode` VARCHAR(45) NULL ,
  `Country` VARCHAR(45) NULL ,
  `CHECKSUM` CHAR(32) NULL ,
  PRIMARY KEY (`SKStoreID`) ,
  INDEX `fk_Store_Employee1_idx` (`ManagerID` ASC) ,
  CONSTRAINT `fk_Store_Employee`
    FOREIGN KEY (`ManagerID` )
    REFERENCES `mydb`.`DW_Employee` (`SKEmployeeID` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`DW_Order_Logical`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `mydb`.`DW_Order_Logical` (
  `OrderID` INT NOT NULL ,
  PRIMARY KEY (`OrderID`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`DW_Order`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `mydb`.`DW_Order` (
  `DT_REFE` DATE NOT NULL ,
  `OrderID` INT NOT NULL ,
  `DT_LOAD` DATE NULL ,
  `SKCustomerID` INT NOT NULL ,
  `SKEmployeeID` INT NOT NULL ,
  `OrderDate` DATE NULL ,
  INDEX `fk_Customer_has_Product_Customer1_idx` (`SKCustomerID` ASC) ,
  INDEX `fk_Customer_has_Product_Employee1_idx` (`SKEmployeeID` ASC) ,
  PRIMARY KEY (`DT_REFE`, `OrderID`) ,
  INDEX `fk_DW_Order_DW_Order1_idx` (`OrderID` ASC) ,
  CONSTRAINT `fk_Customer_has_Product_Customer1`
    FOREIGN KEY (`SKCustomerID` )
    REFERENCES `mydb`.`DW_Customer` (`SKCustomerID` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Customer_has_Product_Employee1`
    FOREIGN KEY (`SKEmployeeID` )
    REFERENCES `mydb`.`DW_Employee` (`SKEmployeeID` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_DW_Order_DW_Order1`
    FOREIGN KEY (`OrderID` )
    REFERENCES `mydb`.`DW_Order_Logical` (`OrderID` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`DW_Order_Detail`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `mydb`.`DW_Order_Detail` (
  `DT_REFE` DATE NOT NULL ,
  `OrderID` INT NOT NULL ,
  `SKProductID` INT NOT NULL ,
  `DT_LOAD` DATE NULL ,
  `UnitPrice` DECIMAL(7,2) NULL ,
  `Quantity` INT(11) NULL ,
  `Discount` DECIMAL(7,2) NULL ,
  PRIMARY KEY (`OrderID`, `SKProductID`, `DT_REFE`) ,
  INDEX `fk_Product_has_Order_Order1_idx` (`OrderID` ASC, `DT_REFE` ASC) ,
  INDEX `fk_Product_has_Order_Product1_idx` (`SKProductID` ASC) ,
  CONSTRAINT `fk_Product_has_Order_Product1`
    FOREIGN KEY (`SKProductID` )
    REFERENCES `mydb`.`DW_Product` (`SKProductID` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Product_has_Order_Order1`
    FOREIGN KEY (`OrderID` , `DT_REFE` )
    REFERENCES `mydb`.`DW_Order` (`OrderID` , `DT_REFE` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`DW_Delivery`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `mydb`.`DW_Delivery` (
  `DT_REFE` DATE NOT NULL ,
  `OrderID` INT NOT NULL ,
  `SKShipperID` INT NOT NULL ,
  `DT_LOAD` DATE NULL ,
  `RequiredDate` DATE NULL ,
  `ShippedDate` DATE NULL ,
  `Freight` DECIMAL(7,2) NULL ,
  `Address` VARCHAR(100) NULL ,
  `City` VARCHAR(50) NULL ,
  `Region` VARCHAR(50) NULL ,
  `PostalCode` VARCHAR(10) NULL ,
  `Country` VARCHAR(50) NULL ,
  PRIMARY KEY (`DT_REFE`, `OrderID`, `SKShipperID`) ,
  INDEX `fk_incremental_DW_Order1_idx` (`OrderID` ASC) ,
  INDEX `fk_incremental_DW_Shipper1_idx` (`SKShipperID` ASC) ,
  CONSTRAINT `fk_incremental_DW_Order1`
    FOREIGN KEY (`OrderID` )
    REFERENCES `mydb`.`DW_Order_Logical` (`OrderID` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_incremental_DW_Shipper1`
    FOREIGN KEY (`SKShipperID` )
    REFERENCES `mydb`.`DW_Shipper` (`SKShipperID` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

USE `mydb` ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
