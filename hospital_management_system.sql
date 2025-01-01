-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 23, 2024 at 01:42 PM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `hospital_management_system`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `email` varchar(20) NOT NULL,
  `password` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`email`, `password`) VALUES
('pmhiroshan@gmail.com', '1234');

-- --------------------------------------------------------

--
-- Table structure for table `booking`
--

CREATE TABLE `booking` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `purpose` varchar(255) DEFAULT NULL,
  `mobile_number` varchar(15) DEFAULT NULL,
  `department` varchar(100) DEFAULT NULL,
  `appointment_date` date DEFAULT NULL,
  `appointment_time` varchar(50) DEFAULT NULL,
  `status` varchar(50) DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `booking`
--

INSERT INTO `booking` (`id`, `name`, `email`, `purpose`, `mobile_number`, `department`, `appointment_date`, `appointment_time`, `status`, `created_at`) VALUES
(2, 'Supun Delanka', 'supun@gmail.com', 'gaddac', 'o9977373', 'General Surgery', '2024-11-22', '6 PM - 8 PM', 'pending', '2024-11-24 06:32:10'),
(3, 'Janka', 'jaban@gmail.com', 'treatament', 'o9977373', 'Health Checkup Packages', '2024-11-30', '8 PM - 10 PM', 'pending', '2024-11-24 06:33:30'),
(4, 'janaka', 'kavaish@gmail.com', 'treatament', '1893819', 'Health Checkup Packages', '2024-11-02', '4 PM - 6 PM', 'pending', '2024-11-24 06:36:55'),
(5, 'aruna', 'aru@gmail.com', 'ji', '1893819', 'Health Checkup Packages', '2024-11-30', '10 AM - 12 PM', 'pending', '2024-11-24 06:40:31'),
(6, 'pmhiroshan@gmail.com', 'pmhiroshan@gmail.com', 'pain kill', '1893819', 'Dermatology and Cosmetology', '2024-11-15', '12 PM - 2 PM', 'pending', '2024-11-24 06:41:51'),
(7, 'ffffffff', 'pm@gmail.com', 'fffffffffffffff', '909090909090', 'Health Checkup Packages', '2024-11-29', '8 AM - 10 AM', 'pending', '2024-11-24 06:44:38'),
(8, 'Hioroshanmadusanka', 'hiroshan@gmail.com', 'headch', '00770462380', 'General Surgery', '2024-11-23', '8 AM - 10 AM', 'pending', '2024-11-24 07:28:17'),
(9, 'pasindu myantha', 'maya@gmail.com', 'gaddac', '00770462380', 'Dermatology and Cosmetology', '2024-11-16', '2 PM - 4 PM', 'pending', '2024-11-24 07:59:30'),
(10, 'pmhiroshan@gmail.com', 'pmhiroshan@gmail.com', 'WWW', '1999', 'Dermatology and Cosmetology', '2024-11-15', '8 AM - 10 AM', 'pending', '2024-11-24 15:36:37');

-- --------------------------------------------------------

--
-- Table structure for table `cashier_invoices`
--

CREATE TABLE `cashier_invoices` (
  `id` int(11) NOT NULL,
  `invoice_number` varchar(20) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `date` date DEFAULT curdate(),
  `time` time DEFAULT curtime(),
  `payment_method` enum('cash','credit_card','debit_card','other') NOT NULL,
  `status` enum('paid','pending','canceled') DEFAULT 'pending',
  `user_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `cashier_invoices`
--

INSERT INTO `cashier_invoices` (`id`, `invoice_number`, `amount`, `date`, `time`, `payment_method`, `status`, `user_id`) VALUES
(2, 'INV-2024-001', 150.00, '2024-12-14', '16:22:58', 'credit_card', 'paid', 10),
(4, 'INV-2024-002', 150.00, '2024-12-14', '16:29:28', 'credit_card', 'paid', 12),
(6, 'INV-2024-00003', 230.00, '2024-12-14', '00:27:00', 'cash', 'pending', 12);

--
-- Triggers `cashier_invoices`
--
DELIMITER $$
CREATE TRIGGER `before_insert_cashier_invoices` BEFORE INSERT ON `cashier_invoices` FOR EACH ROW BEGIN
    DECLARE new_invoice_number VARCHAR(20);
    DECLARE last_invoice_number VARCHAR(20);
    
    -- Get the last invoice number for the current year
    SELECT invoice_number INTO last_invoice_number 
    FROM cashier_invoices 
    WHERE invoice_number LIKE CONCAT('INV-', YEAR(CURRENT_DATE), '-%') 
    ORDER BY invoice_number DESC 
    LIMIT 1;

    -- Generate the new invoice number
    IF last_invoice_number IS NULL THEN
        SET new_invoice_number = CONCAT('INV-', YEAR(CURRENT_DATE), '-00001');
    ELSE
        SET new_invoice_number = CONCAT('INV-', YEAR(CURRENT_DATE), '-', LPAD(SUBSTRING_INDEX(last_invoice_number, '-', -1) + 1, 5, '0'));
    END IF;

    -- Set the new invoice number to the NEW row
    SET NEW.invoice_number = new_invoice_number;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `invoice`
--

CREATE TABLE `invoice` (
  `id` int(11) NOT NULL,
  `customer_name` varchar(100) NOT NULL,
  `date` timestamp NOT NULL DEFAULT current_timestamp(),
  `items` text NOT NULL,
  `total_amount` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `items`
--

CREATE TABLE `items` (
  `uuid` char(36) NOT NULL DEFAULT uuid(),
  `item_name` varchar(255) NOT NULL,
  `company` varchar(255) NOT NULL,
  `dose` varchar(100) DEFAULT NULL,
  `genetic_name` varchar(255) DEFAULT NULL,
  `brand_name` varchar(255) DEFAULT NULL,
  `specific1` varchar(255) DEFAULT NULL,
  `specific2` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `items`
--

INSERT INTO `items` (`uuid`, `item_name`, `company`, `dose`, `genetic_name`, `brand_name`, `specific1`, `specific2`) VALUES
('9de37ed8-b718-11ef-bfce-e8113234d532', 'Hiro', 'PharmaCorp', '100 mg', 'Acetaminophen', 'soc', 'bioOne', NULL),
('9de38044-b718-11ef-bfce-e8113234d532', 'Aspirin', 'PharmaCorp', '500 mg', 'neurron', 'PainAway', 'bioOne', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `registration`
--

CREATE TABLE `registration` (
  `id` int(11) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `registration`
--

INSERT INTO `registration` (`id`, `first_name`, `last_name`, `email`, `password`) VALUES
(2, 'Poddiwala', 'Kumara', 'pmhiroshan@gmail.com', '12'),
(3, 'kavishaka', 'skks', 'kavi@gmail.com', '123'),
(4, 'Dhananjaya', 'Gamamge', 'dhanajayay@gmail.com', '123'),
(5, 'Gayan', 'Kumara', 'pmhiroshan11@gmail.com', '1111'),
(6, 'Kumudu', 'Madusnaka', 'kumudu@gmail.com', '127777'),
(7, 'dineljka', 'jhon', 'jon@do.com', '123'),
(9, 'Kumudu', 'Madusnaka', 'kumudu1@gmail.com', '123');

-- --------------------------------------------------------

--
-- Table structure for table `stock`
--

CREATE TABLE `stock` (
  `item_uuid` char(36) NOT NULL DEFAULT uuid(),
  `item_code` varchar(255) NOT NULL,
  `invoice_number` varchar(255) NOT NULL,
  `item` varchar(255) NOT NULL,
  `time` time NOT NULL,
  `date` date NOT NULL,
  `cost` decimal(10,2) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 0,
  `expire_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `stock`
--

INSERT INTO `stock` (`item_uuid`, `item_code`, `invoice_number`, `item`, `time`, `date`, `cost`, `price`, `quantity`, `expire_date`) VALUES
('1f0ef6d3-b7d4-11ef-a6cb-e8113234d532', 'code-11', 'inv-112', 'gzta', '00:00:12', '0000-00-00', 30.00, 35.00, 20, NULL),
('2190a5cd-b9de-11ef-a669-e8113234d532', 'code-17', 'inv-17', 'seirup', '12:46:00', '2024-07-13', 100.00, 102.00, 1000, NULL),
('259ebf2d-b9e3-11ef-a669-e8113234d532', 'code-18', 'inv-18', 'virus', '17:53:00', '2024-12-14', 200.00, 250.00, 199, NULL),
('4e171ce3-b9dd-11ef-a669-e8113234d532', 'code-15', 'inv-112', 'Gen_texZ', '00:00:01', '2024-10-24', 50.00, 75.00, 15, NULL),
('708b9a5a-b9e3-11ef-a669-e8113234d532', 'code-20', 'inv-20', 'Sixpack', '13:51:00', '2024-12-27', 200.00, 220.00, 550, NULL),
('71a357e7-b9dd-11ef-a669-e8113234d532', 'code-16', 'inv-16', 'Six', '00:00:01', '2024-10-24', 30.00, 40.00, 100, NULL),
('e8e16567-b9e2-11ef-a669-e8113234d532', 'code-18', 'inv-116', 'Gen_texZ', '15:49:00', '2024-12-14', 200.00, 205.00, 100, NULL),
('ea96a07d-b9e5-11ef-a669-e8113234d532', 'code-201', 'inv-1151', 'gtz', '06:35:00', '2024-12-26', 200.00, 75.00, 100, '2026-10-15');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('SuperAdmin','Admin','User','Cashier') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `role`) VALUES
(1, 'superadmin', '123', 'SuperAdmin'),
(2, 'admin', '1234', 'Admin'),
(3, 'user', '12345', 'User'),
(4, 'cahier', '123456', 'Cashier');

-- --------------------------------------------------------

--
-- Table structure for table `users_data`
--

CREATE TABLE `users_data` (
  `user_id` int(11) NOT NULL,
  `user_name` varchar(60) NOT NULL,
  `address` varchar(100) NOT NULL,
  `phone_no` varchar(15) DEFAULT NULL,
  `comment` varchar(500) DEFAULT NULL,
  `blank` varchar(100) DEFAULT NULL,
  `blank1` varchar(100) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `nic` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users_data`
--

INSERT INTO `users_data` (`user_id`, `user_name`, `address`, `phone_no`, `comment`, `blank`, `blank1`, `email`, `nic`) VALUES
(10, 'Oshan Sanaka', 'colombo', '7779008', 'Treatment', NULL, NULL, NULL, ''),
(12, 'Daminda', 'kottawa', '74326172', 'treatement', NULL, NULL, NULL, ''),
(21, 'lakmal', 'Colombo', '0770462380', 'no', NULL, NULL, 'lakamal12@gmail.com', '992761044v');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table `booking`
--
ALTER TABLE `booking`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cashier_invoices`
--
ALTER TABLE `cashier_invoices`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `invoice_number` (`invoice_number`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `invoice`
--
ALTER TABLE `invoice`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `items`
--
ALTER TABLE `items`
  ADD PRIMARY KEY (`uuid`);

--
-- Indexes for table `registration`
--
ALTER TABLE `registration`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `stock`
--
ALTER TABLE `stock`
  ADD PRIMARY KEY (`item_uuid`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users_data`
--
ALTER TABLE `users_data`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `booking`
--
ALTER TABLE `booking`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `cashier_invoices`
--
ALTER TABLE `cashier_invoices`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `invoice`
--
ALTER TABLE `invoice`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `registration`
--
ALTER TABLE `registration`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `users_data`
--
ALTER TABLE `users_data`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `cashier_invoices`
--
ALTER TABLE `cashier_invoices`
  ADD CONSTRAINT `cashier_invoices_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users_data` (`user_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
