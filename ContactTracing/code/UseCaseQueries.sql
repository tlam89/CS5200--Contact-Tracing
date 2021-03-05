USE `contact_tracing`;

-- Use Case 1
SELECT FirstName, LastName,
CASE
    WHEN PreferredContact='Email' THEN Email
    WHEN PreferredContact='Phone' THEN PhoneNumber
END AS ContactInformation
FROM Contact;

-- Use Case 2
SELECT FirstName, LastName, 
CASE
    WHEN PreferredContact='Email' THEN Email
    WHEN PreferredContact='Phone' THEN PhoneNumber
END AS ContactInformation,
CASE
	WHEN StatusId = (SELECT StatusId FROM Status WHERE Description LIKE 'Triaged')
    AND ExposureId = (SELECT ExposureId FROM Exposure WHERE Level LIKE 'Very High') THEN 'Triaged and Very High Exposure'
END AS Status
FROM Contact
WHERE StatusId = (SELECT StatusId FROM Status WHERE Description LIKE 'Triaged')
AND ExposureId = (SELECT ExposureId FROM Exposure WHERE Level LIKE 'Very High');

-- After a Case is created the system sends Patient a confidential electronic survey 
-- before the interview about any contact they’ve had to speed up interview:
SELECT `Email` AS ContactEmail
FROM `Contact`;

-- Use Case 3
-- CURDATE() was for 10/11/2020
SELECT DISTINCT `Contact`.`FirstName`, `Contact`.`LastName`, COUNT(`Contact`.`ContactId`) AS NumberOfSymptoms
FROM `Contact`
JOIN (SELECT * FROM ContactSymptom WHERE Date LIKE '2020-10-06%') AS Symptoms ON `Contact`.`ContactId` = Symptoms.`ContactId`
GROUP BY `Contact`.`ContactId`
HAVING COUNT(`Contact`.`ContactId`) > 0;

-- Use Case 4
SELECT FirstName, LastName, `Name` AS `TestName`
FROM `Contact`
JOIN `Test` ON `Contact`.`ContactId` = `Test`.`ContactId`
JOIN `TestType` ON `Test`.`TestTypeId` = `TestType`.`TestTypeId`
WHERE `Name`='Molecular Test' OR `Name` = 'Antigen Test';

-- Use Case 5
-- CURDATE() was for 10/11/2020
DROP VIEW IF EXISTS DailyMonitorView;
CREATE VIEW DailyMonitorView AS
SELECT FirstName, LastName, Email, PhoneNumber #, PreferredContact
FROM `Contact`
JOIN `ContactStatus` ON `Contact`.`ContactId` = `ContactStatus`.`ContactId`
WHERE `SelfQuarantined` = 1 AND CURDATE() < DATE_ADD(ExposureStartDate, INTERVAL 14 DAY);
