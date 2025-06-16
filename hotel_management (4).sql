-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3307
-- Generation Time: Jun 16, 2025 at 04:33 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `hotel_management`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `admin_id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `fullname` varchar(100) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `position` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`admin_id`, `username`, `fullname`, `password`, `position`, `email`) VALUES
(2, 'Adib02', 'Wan Muhammad Adib Arsyad', 'Adib2', 'Assistant Manager 2', 'adib@example.com'),
(4, 'Atikah03', 'Noratikah Binti Noor Azmien', 'Atikah3', 'Assistant Manager 1', 'bla@bla'),
(6, 'Haikal01', 'Haikal Danial Bin Mohd Rohaiza', 'Haikal1', 'Super Manager', 'haikal@yahoo.com'),
(9, 'Ali04', 'Ali Bin Hasan', 'Ali4', 'Receptionist', 'ali@example.com');

-- --------------------------------------------------------

--
-- Table structure for table `assignedtask`
--

CREATE TABLE `assignedtask` (
  `assignedTaskID` int(11) NOT NULL,
  `assignmentID` int(11) NOT NULL,
  `taskID` varchar(10) NOT NULL,
  `taskStatus` varchar(20) DEFAULT NULL CHECK (`taskStatus` in ('DONE','NOT DONE'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `assignedtask`
--

INSERT INTO `assignedtask` (`assignedTaskID`, `assignmentID`, `taskID`, `taskStatus`) VALUES
(7, 18, 'T001', 'DONE'),
(8, 19, 'T002', 'NOT DONE'),
(9, 20, 'T001', 'NOT DONE'),
(10, 20, 'T002', 'NOT DONE'),
(11, 20, 'T003', 'NOT DONE'),
(12, 21, 'T001', 'NOT DONE'),
(13, 21, 'T002', 'NOT DONE');

-- --------------------------------------------------------

--
-- Table structure for table `guest`
--

CREATE TABLE `guest` (
  `guestID` varchar(10) NOT NULL,
  `guestName` varchar(255) DEFAULT NULL,
  `guestAddr` varchar(255) DEFAULT NULL,
  `guestPhone` varchar(15) DEFAULT NULL,
  `guestEmail` varchar(150) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `guest`
--

INSERT INTO `guest` (`guestID`, `guestName`, `guestAddr`, `guestPhone`, `guestEmail`) VALUES
('G001', 'John Doe', '123 Street', '1234567890', 'john@example.com'),
('G002', 'Alice Johnson', '456 Avenue', '9876543210', 'alice@example.com'),
('G003', 'Bob Smith', '789 Boulevard', '8765432109', 'bob@example.com'),
('G004', 'Clara Lee', '321 Lane', '7654321098', 'clara@example.com'),
('G005', 'David Kim', '654 Drive', '6543210987', 'david@example.com'),
('G909', 'Aninah', 'Lot 123', '0178623343', 'Aminah@yahoo.com'),
('G910', 'Ali', 'wywyye', '0189283833', 'Ali@hahoo.com'),
('G911', 'Ali', 'wywyye', '0189283833', 'Ali@hahoo.com'),
('G912', 'Badrul', 'Lot 123, Jalan ABC', '0188627356', 'Badrul@Ghee.com'),
('G913', 'Jalil', 'Lot ABC, 123', '0199928343', 'Jalil@Jalal.com'),
('G914', 'Adabi', 'Lot Mutiara, Jalan Ampong', '01892667382', 'AdabiAbadi@boby.com'),
('G915', 'Haikal', 'Lot 123, Jalan ABC', '0188627356', 'Badrul@Ghee.com'),
('G916', 'Dragon G Gonnard', 'Road White Myomi, London, America', '019238433', 'gDragon@yahoo.com'),
('G917', 'Naim Najmi', 'Lot Mutiara, Jalan Ampong', '0189283833', 'Naim@yahoo.com'),
('G918', 'Haris Farhan', 'Lot 123, Jalan ABC', '01787665426', 'Haris@yahoo.com'),
('G919', 'Fik', 'Lot 123, Jalan ABC', '012738943', 'fik@yahoo.com'),
('G920', 'Tikah', 'Blok An Najjah', '999', 'Tikah@yahoo.com');

-- --------------------------------------------------------

--
-- Table structure for table `housekeepingassignment`
--

CREATE TABLE `housekeepingassignment` (
  `assignmentID` int(11) NOT NULL,
  `housekeepingStaffID` int(11) NOT NULL,
  `roomAssigned` int(11) NOT NULL,
  `housekeepingStatus` varchar(20) DEFAULT 'NOT DONE' CHECK (`housekeepingStatus` in ('DONE','NOT DONE'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `housekeepingassignment`
--

INSERT INTO `housekeepingassignment` (`assignmentID`, `housekeepingStaffID`, `roomAssigned`, `housekeepingStatus`) VALUES
(9, 10002, 103, 'NOT DONE'),
(10, 10001, 101, 'NOT DONE'),
(11, 10001, 101, 'NOT DONE'),
(12, 10001, 101, 'NOT DONE'),
(13, 10001, 101, 'NOT DONE'),
(14, 10003, 103, 'NOT DONE'),
(15, 10001, 101, 'NOT DONE'),
(16, 10001, 101, 'NOT DONE'),
(17, 10001, 101, 'NOT DONE'),
(18, 10001, 101, 'DONE'),
(19, 10002, 102, 'NOT DONE'),
(20, 10001, 101, 'NOT DONE'),
(21, 10002, 104, 'NOT DONE');

-- --------------------------------------------------------

--
-- Table structure for table `housekeepingtask`
--

CREATE TABLE `housekeepingtask` (
  `taskID` varchar(10) NOT NULL,
  `taskName` varchar(150) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `housekeepingtask`
--

INSERT INTO `housekeepingtask` (`taskID`, `taskName`) VALUES
('T001', 'Clean Bathroom'),
('T002', 'Make Bed'),
('T003', 'Vacuum Floor'),
('T004', 'Change Towels');

-- --------------------------------------------------------

--
-- Table structure for table `payment`
--

CREATE TABLE `payment` (
  `billID` int(11) NOT NULL,
  `reservationID` varchar(10) DEFAULT NULL,
  `items` varchar(200) DEFAULT NULL,
  `totalAmount` double(9,2) DEFAULT NULL,
  `paymentDate` date DEFAULT NULL,
  `paymentMethod` varchar(50) DEFAULT NULL,
  `status` varchar(50) DEFAULT 'Not Paid Yet',
  `paymentReference` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `payment`
--

INSERT INTO `payment` (`billID`, `reservationID`, `items`, `totalAmount`, `paymentDate`, `paymentMethod`, `status`, `paymentReference`) VALUES
(1, 'R001', 'Room Charge', 300.00, '2025-06-18', 'Cash', 'Paid', NULL),
(2, 'R001', 'Room Charge', 300.00, '2025-06-18', 'Card', 'Paid', 'P1003-18062025'),
(3, 'R555', NULL, 250.00, '2025-06-16', 'Card', 'Paid', 'P1001-16062025'),
(4, 'R556', NULL, 600.00, '2025-06-16', 'Card', 'Paid', 'P1002-16062025'),
(5, 'R557', NULL, 2400.00, '2025-06-16', 'Card', 'Paid', 'P1004-18062025'),
(6, 'R558', NULL, 3600.00, '2025-06-16', 'Card', 'Paid', 'P1005-16062025'),
(7, 'R002', NULL, 5600.00, NULL, NULL, 'Not Paid Yet', NULL),
(8, 'R003', NULL, 400.00, NULL, NULL, 'Not Paid Yet', NULL),
(9, 'R004', NULL, 300.00, NULL, NULL, 'Not Paid Yet', NULL),
(10, 'R005', NULL, 5200.00, NULL, NULL, 'Not Paid Yet', NULL),
(11, 'R548', NULL, 300.00, NULL, NULL, 'Not Paid Yet', NULL),
(12, 'R549', NULL, NULL, NULL, NULL, 'Not Paid Yet', NULL),
(13, 'R550', NULL, NULL, NULL, NULL, 'Not Paid Yet', NULL),
(14, 'R551', NULL, NULL, NULL, NULL, 'Not Paid Yet', NULL),
(15, 'R552', NULL, NULL, NULL, NULL, 'Not Paid Yet', NULL),
(16, 'R553', NULL, NULL, NULL, NULL, 'Not Paid Yet', NULL),
(17, 'R554', NULL, NULL, NULL, NULL, 'Not Paid Yet', NULL),
(18, 'R559', NULL, 430.00, '2025-06-16', 'Card', 'Paid', 'P1006-16062025');

-- --------------------------------------------------------

--
-- Table structure for table `paymentitem`
--

CREATE TABLE `paymentitem` (
  `itemID` int(11) NOT NULL,
  `billID` int(11) DEFAULT NULL,
  `itemDescription` varchar(200) DEFAULT NULL,
  `itemAmount` double(9,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `paymentitem`
--

INSERT INTO `paymentitem` (`itemID`, `billID`, `itemDescription`, `itemAmount`) VALUES
(1, 3, 'Dinner', 50.00),
(4, 18, 'Set Dinner', 30.00);

-- --------------------------------------------------------

--
-- Table structure for table `reservation`
--

CREATE TABLE `reservation` (
  `reservationID` varchar(10) NOT NULL,
  `guestID` varchar(10) DEFAULT NULL,
  `checkInDate` datetime DEFAULT NULL,
  `checkOutDate` datetime DEFAULT NULL,
  `roomType` varchar(50) DEFAULT NULL,
  `roomNo` int(11) DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `reservation`
--

INSERT INTO `reservation` (`reservationID`, `guestID`, `checkInDate`, `checkOutDate`, `roomType`, `roomNo`, `status`) VALUES
('R001', 'G001', '2025-05-18 01:21:54', '2025-05-18 01:22:15', 'Deluxe', 101, 'checked-out'),
('R002', 'G002', '2025-05-18 10:02:53', '2025-06-15 09:19:42', 'Standard', 102, 'checked-out'),
('R003', 'G003', '2025-05-18 10:03:08', '2025-05-19 04:26:52', 'Suite', 103, 'checked-out'),
('R004', 'G004', '2025-05-19 04:25:33', '2025-05-19 22:10:55', 'Deluxe', 104, 'checked-out'),
('R005', 'G005', '2025-05-19 22:08:27', '2025-06-15 12:39:13', 'Standard', 105, 'checked-out'),
('R548', 'G909', '2025-05-25 13:27:34', '2025-05-25 13:27:49', 'Deluxe', 101, 'checked-out'),
('R549', 'G910', '2025-05-27 07:24:04', '2025-05-27 07:24:32', 'Deluxe', 101, 'checked-out'),
('R550', 'G911', '2025-06-15 12:38:40', '2025-06-15 12:39:17', 'Deluxe', 101, 'checked-out'),
('R551', 'G912', '2025-06-15 12:38:45', '2025-06-15 12:39:22', 'Deluxe', 101, 'checked-out'),
('R552', 'G913', '2025-06-15 12:38:48', '2025-06-15 12:39:27', 'Deluxe', 104, 'checked-out'),
('R553', 'G914', '2025-06-15 12:38:52', '2025-06-15 12:39:31', 'Standard', 201, 'checked-out'),
('R554', 'G915', '2025-06-15 12:38:56', '2025-06-16 01:35:36', 'Deluxe', 101, 'checked-out'),
('R555', 'G916', '2025-06-15 12:39:00', '2025-06-16 01:35:40', 'Standard', 102, 'checked-out'),
('R556', 'G917', '2025-06-16 01:35:48', '2025-06-20 17:46:00', 'Standard', 205, 'checked-in'),
('R557', 'G918', '2025-06-16 01:35:51', '2025-06-21 17:51:00', 'Suite', 103, 'checked-in'),
('R558', 'G919', '2025-06-16 01:35:56', '2025-06-27 20:40:00', 'Suite', 203, 'checked-in'),
('R559', 'G920', '2025-06-19 14:03:00', '2025-06-21 14:03:00', 'Standard', 105, 'pending');

--
-- Triggers `reservation`
--
DELIMITER $$
CREATE TRIGGER `after_reservation_insert` AFTER INSERT ON `reservation` FOR EACH ROW BEGIN
    INSERT INTO payment (reservationID, status)
    VALUES (NEW.reservationID, 'Not Paid Yet');
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `room`
--

CREATE TABLE `room` (
  `roomNo` int(11) NOT NULL,
  `roomType` varchar(50) DEFAULT NULL,
  `roomPrice` decimal(9,2) DEFAULT NULL,
  `roomStatus` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `room`
--

INSERT INTO `room` (`roomNo`, `roomType`, `roomPrice`, `roomStatus`) VALUES
(101, 'Deluxe', 300.00, 'available'),
(102, 'Standard', 200.00, 'available'),
(103, 'Suite', 400.00, 'occupied'),
(104, 'Deluxe', 300.00, 'available'),
(105, 'Standard', 200.00, 'pending'),
(201, 'Standard', 120.00, 'available'),
(202, 'Deluxe', 180.00, 'Occupied'),
(203, 'Suite', 300.00, 'occupied'),
(204, 'Deluxe', 180.00, 'Maintenance'),
(205, 'Standard', 120.00, 'occupied');

-- --------------------------------------------------------

--
-- Table structure for table `staff`
--

CREATE TABLE `staff` (
  `staffID` int(10) NOT NULL,
  `staffName` varchar(255) NOT NULL,
  `staffContactNo` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `staff`
--

INSERT INTO `staff` (`staffID`, `staffName`, `staffContactNo`) VALUES
(10001, 'Alice Tan', '0123456789'),
(10002, 'Mohd Azlan', '0138765432'),
(10003, 'Nur Aisyah', '0142233445');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`admin_id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `assignedtask`
--
ALTER TABLE `assignedtask`
  ADD PRIMARY KEY (`assignedTaskID`),
  ADD KEY `assignmentID` (`assignmentID`),
  ADD KEY `taskID` (`taskID`);

--
-- Indexes for table `guest`
--
ALTER TABLE `guest`
  ADD PRIMARY KEY (`guestID`);

--
-- Indexes for table `housekeepingassignment`
--
ALTER TABLE `housekeepingassignment`
  ADD PRIMARY KEY (`assignmentID`),
  ADD KEY `housekeepingStaffID` (`housekeepingStaffID`),
  ADD KEY `roomAssigned` (`roomAssigned`);

--
-- Indexes for table `housekeepingtask`
--
ALTER TABLE `housekeepingtask`
  ADD PRIMARY KEY (`taskID`);

--
-- Indexes for table `payment`
--
ALTER TABLE `payment`
  ADD PRIMARY KEY (`billID`),
  ADD KEY `reservationID` (`reservationID`);

--
-- Indexes for table `paymentitem`
--
ALTER TABLE `paymentitem`
  ADD PRIMARY KEY (`itemID`),
  ADD KEY `billID` (`billID`);

--
-- Indexes for table `reservation`
--
ALTER TABLE `reservation`
  ADD PRIMARY KEY (`reservationID`),
  ADD KEY `guestID` (`guestID`),
  ADD KEY `roomNo` (`roomNo`);

--
-- Indexes for table `room`
--
ALTER TABLE `room`
  ADD PRIMARY KEY (`roomNo`);

--
-- Indexes for table `staff`
--
ALTER TABLE `staff`
  ADD PRIMARY KEY (`staffID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin`
--
ALTER TABLE `admin`
  MODIFY `admin_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `assignedtask`
--
ALTER TABLE `assignedtask`
  MODIFY `assignedTaskID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `housekeepingassignment`
--
ALTER TABLE `housekeepingassignment`
  MODIFY `assignmentID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `payment`
--
ALTER TABLE `payment`
  MODIFY `billID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `paymentitem`
--
ALTER TABLE `paymentitem`
  MODIFY `itemID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `room`
--
ALTER TABLE `room`
  MODIFY `roomNo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=206;

--
-- AUTO_INCREMENT for table `staff`
--
ALTER TABLE `staff`
  MODIFY `staffID` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10004;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `assignedtask`
--
ALTER TABLE `assignedtask`
  ADD CONSTRAINT `assignedtask_ibfk_1` FOREIGN KEY (`assignmentID`) REFERENCES `housekeepingassignment` (`assignmentID`),
  ADD CONSTRAINT `assignedtask_ibfk_2` FOREIGN KEY (`taskID`) REFERENCES `housekeepingtask` (`taskID`);

--
-- Constraints for table `housekeepingassignment`
--
ALTER TABLE `housekeepingassignment`
  ADD CONSTRAINT `housekeepingassignment_ibfk_1` FOREIGN KEY (`housekeepingStaffID`) REFERENCES `staff` (`staffID`),
  ADD CONSTRAINT `housekeepingassignment_ibfk_2` FOREIGN KEY (`roomAssigned`) REFERENCES `room` (`roomNo`);

--
-- Constraints for table `payment`
--
ALTER TABLE `payment`
  ADD CONSTRAINT `payment_ibfk_1` FOREIGN KEY (`reservationID`) REFERENCES `reservation` (`reservationID`);

--
-- Constraints for table `paymentitem`
--
ALTER TABLE `paymentitem`
  ADD CONSTRAINT `paymentitem_ibfk_1` FOREIGN KEY (`billID`) REFERENCES `payment` (`billID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `reservation`
--
ALTER TABLE `reservation`
  ADD CONSTRAINT `reservation_ibfk_1` FOREIGN KEY (`guestID`) REFERENCES `guest` (`guestID`),
  ADD CONSTRAINT `reservation_ibfk_2` FOREIGN KEY (`roomNo`) REFERENCES `room` (`roomNo`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
