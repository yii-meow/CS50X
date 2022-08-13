-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 11, 2022 at 07:27 AM
-- Server version: 10.4.22-MariaDB
-- PHP Version: 8.1.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `yimmerce`
--

-- --------------------------------------------------------

--
-- Table structure for table `chats`
--

CREATE TABLE `chats` (
  `id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `chats`
--

INSERT INTO `chats` (`id`) VALUES
(1),
(2),
(3),
(4),
(5),
(6);

-- --------------------------------------------------------

--
-- Table structure for table `chat_lines`
--

CREATE TABLE `chat_lines` (
  `id` int(11) NOT NULL,
  `chat_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `line_text` text NOT NULL,
  `sender` enum('buyer','seller') NOT NULL,
  `created_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `chat_lines`
--

INSERT INTO `chat_lines` (`id`, `chat_id`, `user_id`, `line_text`, `sender`, `created_at`) VALUES
(1, 1, 4, 'test', 'buyer', '2022-08-08 13:44:40'),
(2, 1, 4, 'test2', 'buyer', '2022-08-08 13:45:09'),
(3, 1, 4, 'test3', 'buyer', '2022-08-08 13:49:17'),
(4, 1, 4, 'test4', 'buyer', '2022-08-08 13:49:20'),
(5, 1, 4, 'test4', 'buyer', '2022-08-08 13:49:27'),
(6, 1, 4, 'test5', 'buyer', '2022-08-08 13:49:29'),
(7, 1, 4, 'Hi, Morning Miss/Sir. I would like to make an enquiry on your product, \"Jk Skirt\" . May I know what is the size?', 'buyer', '2022-08-08 13:50:13'),
(8, 1, 4, 'Hi, Can you answer my question?', 'buyer', '2022-08-08 13:52:28'),
(9, 1, 4, 'May I know how the tax rate is calculated?', 'buyer', '2022-08-08 13:53:20'),
(10, 1, 4, 'nice', 'buyer', '2022-08-08 13:54:06'),
(11, 1, 4, 'very very nice', 'buyer', '2022-08-08 13:54:11'),
(12, 1, 4, 'very very nice', 'buyer', '2022-08-08 13:54:59'),
(13, 2, 3, 'Hi, yiyi.', 'buyer', '2022-08-08 14:03:28'),
(16, 2, 3, 'Hey', 'buyer', '2022-08-08 14:03:28'),
(18, 1, 4, 'test6', 'buyer', '2022-08-08 14:06:40'),
(19, 3, 2, 'Heyy', 'buyer', '2022-08-08 14:08:04'),
(23, 3, 2, 'Belo', 'buyer', '2022-08-08 14:09:50'),
(24, 2, 3, 'heyhey', 'buyer', '2022-08-08 15:50:03'),
(25, 2, 3, 'can you respond me?', 'buyer', '2022-08-08 15:50:08'),
(26, 4, 17, 'Whatsupp!', 'buyer', '2022-08-08 16:01:49'),
(27, 4, 17, 'May I have more picture for the \"green jk skirt\"?', 'buyer', '2022-08-08 16:02:16'),
(28, 4, 17, 'It looks really good for me', 'buyer', '2022-08-08 16:02:28'),
(29, 4, 17, 'Wish to hear from you soon!', 'buyer', '2022-08-08 16:02:39'),
(30, 4, 17, 'since I would like to wear this on my dating with my bf', 'buyer', '2022-08-08 16:03:25'),
(31, 2, 3, 'Hey~ Greeting from yiyi', 'seller', '2022-08-08 17:18:25'),
(32, 2, 3, 'hihi', 'buyer', '2022-08-08 17:20:35'),
(33, 2, 3, 'yo', 'seller', '2022-08-08 23:06:58'),
(34, 1, 4, 'Tax rate is 6 %', 'seller', '2022-08-08 23:07:09'),
(35, 1, 4, 'jk size is 42 MM, and there are sizes XS, S,M,L, XL ', 'seller', '2022-08-08 23:07:38'),
(36, 4, 17, 'sorry here cannot send picture', 'seller', '2022-08-08 23:07:59'),
(37, 4, 17, 'it is definitely looking beautiful on you during your meeting while wearing jk~!', 'seller', '2022-08-08 23:08:19'),
(38, 2, 3, 'your clothes are very beautiful!', 'buyer', '2022-08-08 23:08:53'),
(39, 2, 3, 'Thank you!', 'seller', '2022-08-08 23:09:11'),
(40, 1, 4, 'Morning. Are you still interested in our product ?', 'seller', '2022-08-09 11:53:10'),
(41, 1, 4, 'hihi', 'seller', '2022-08-09 11:59:43'),
(42, 2, 3, ' Morning~!', 'seller', '2022-08-09 12:34:14'),
(43, 4, 17, 'Morning~ ^.^', 'seller', '2022-08-09 12:34:25'),
(44, 4, 17, 'Morning~ ^.^', 'seller', '2022-08-09 12:34:30'),
(45, 4, 17, 'Morning~ ^.^', 'seller', '2022-08-09 12:34:31'),
(46, 5, 1, 'Hi~~', 'buyer', '2022-08-09 16:09:17'),
(47, 5, 1, 'Whatddup', 'seller', '2022-08-09 17:06:26'),
(48, 5, 1, 'your clothes are really beautiful and cute!', 'buyer', '2022-08-09 21:37:35'),
(49, 2, 3, 'morning~ ^.^', 'buyer', '2022-08-10 11:00:21'),
(50, 6, 18, 'hi', 'buyer', '2022-08-10 20:15:58'),
(51, 6, 18, 'hi', 'buyer', '2022-08-10 20:15:58'),
(52, 6, 18, 'hi', 'buyer', '2022-08-10 20:16:00'),
(53, 6, 18, 'seller are you here', 'buyer', '2022-08-10 20:16:03'),
(54, 6, 18, 'I want to buy', 'buyer', '2022-08-10 20:16:10'),
(55, 6, 18, 'yes sure sure', 'seller', '2022-08-10 20:16:39'),
(56, 5, 1, 'aww thank you pretty !', 'seller', '2022-08-10 21:36:44');

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `message` varchar(255) NOT NULL,
  `notify_time` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`id`, `user_id`, `title`, `message`, `notify_time`) VALUES
(1, 2, 'Parcel Delivered', 'Parcel SPXMY123321312312 for your order 220726FFS89891 has been delivered.', '2022-08-04 13:01:49'),
(4, 2, 'Redeem Voucher', 'Successfully Redeemed Voucher ID: 1.', '2022-08-05 00:03:38'),
(5, 2, 'Redeem Voucher', 'Successfully Redeemed Voucher ID: 3.', '2022-08-05 00:03:39'),
(6, 2, 'Payment is Successful', 'Payment for Order ID 14 is successful. We have notified the seller to ship.', '2022-08-05 14:16:15'),
(7, 2, 'Payment is Successful', 'Payment for Order ID 15 is successful. We have notified the seller to ship.', '2022-08-05 14:19:12'),
(8, 2, 'Payment is Successful', 'Payment for Order ID 16 is successful. We have notified the seller to ship.', '2022-08-05 14:22:11'),
(9, 2, 'Payment is Successful', 'Payment for Order ID 17 is successful. We have notified the seller to ship.', '2022-08-05 21:00:45'),
(10, 2, 'Change password', 'You have changed your password. Doesn\'t recognize this? Contact Us.', '2022-08-05 21:30:50'),
(11, 2, 'Payment is Successful', 'Payment for Order ID 18 is successful. We have notified the seller to ship.', '2022-08-06 12:07:52'),
(12, 3, 'Payment is Successful', 'Payment for Order ID 19 is successful. We have notified the seller to ship.', '2022-08-06 12:13:37'),
(13, 3, 'Payment is Successful', 'Payment for Order ID 20 is successful. We have notified the seller to ship.', '2022-08-06 12:14:56'),
(14, 3, 'Payment is Successful', 'Payment for Order ID 21 is successful. We have notified the seller to ship.', '2022-08-06 12:15:24'),
(15, 1, 'Payment is Successful', 'Payment for Order ID 22 is successful. We have notified the seller to ship.', '2022-08-06 12:18:00'),
(16, 4, 'Redeem Voucher', 'Successfully Redeemed Voucher ID: 1.', '2022-08-06 13:53:14'),
(17, 4, 'Redeem Voucher', 'Successfully Redeemed Voucher ID: 2.', '2022-08-06 13:53:15'),
(18, 4, 'Payment is Successful', 'Payment for Order ID 23 is successful. We have notified the seller to ship.', '2022-08-06 14:19:14'),
(19, 4, 'Payment is Successful', 'Payment for Order ID 24 is successful. We have notified the seller to ship.', '2022-08-06 15:05:49'),
(20, 4, 'Payment is Successful', 'Payment for Order ID 25 is successful. We have notified the seller to ship.', '2022-08-06 15:54:24'),
(21, 4, 'Payment is Successful', 'Payment for Order ID 29 is successful. We have notified the seller to ship.', '2022-08-06 16:03:38'),
(22, 4, 'Payment is Successful', 'Payment for Order ID 30 is successful. We have notified the seller to ship.', '2022-08-06 16:04:37'),
(23, 4, 'Payment is Successful', 'Payment for Order ID 32 is successful. We have notified the seller to ship.', '2022-08-06 16:11:07'),
(24, 4, 'Payment is Successful', 'Payment for Order ID 33 is successful. We have notified the seller to ship.', '2022-08-06 16:13:09'),
(25, 4, 'Payment is Successful', 'Payment for Order ID 34 is successful. We have notified the seller to ship.', '2022-08-06 16:13:35'),
(26, 4, 'Payment is Successful', 'Payment for Order ID 35 is successful. We have notified the seller to ship.', '2022-08-08 00:18:18'),
(27, 4, 'Payment is Successful', 'Payment for Order ID 36 is successful. We have notified the seller to ship.', '2022-08-08 00:24:11'),
(28, 5, 'Payment is Successful', 'Payment for Order ID 37 is successful. We have notified the seller to ship.', '2022-08-08 14:11:01'),
(29, 3, 'Payment is Successful', 'Payment for Order ID 38 is successful. We have notified the seller to ship.', '2022-08-08 15:50:17'),
(30, 5, 'Redeem Voucher', 'Successfully Redeemed Voucher ID: 1.', '2022-08-08 15:54:37'),
(31, 3, 'Payment is Successful', 'Payment for Order ID 39 is successful. We have notified the seller to ship.', '2022-08-08 16:55:49'),
(32, 3, 'Payment is Successful', 'Payment for Order ID 40 is successful. We have notified the seller to ship.', '2022-08-08 16:57:29'),
(33, 1, 'Payment is Successful', 'Payment for Order ID 41 is successful. We have notified the seller to ship.', '2022-08-09 15:50:40'),
(34, 1, 'Payment is Successful', 'Payment for Order ID 49 is successful. We have notified the seller to ship.', '2022-08-09 16:05:14'),
(35, 1, 'Payment is Successful', 'Payment for Order ID 50 is successful. We have notified the seller to ship.', '2022-08-09 16:08:37'),
(36, 3, 'Payment is Successful', 'Payment for Order ID 51 is successful. We have notified the seller to ship.', '2022-08-09 16:22:11'),
(37, 18, 'Payment is Successful', 'Payment for Order ID 52 is successful. We have notified the seller to ship.', '2022-08-10 11:27:46'),
(38, 18, 'Payment is Successful', 'Payment for Order ID 53 is successful. We have notified the seller to ship.', '2022-08-10 13:51:30'),
(39, 18, 'Payment is Successful', 'Payment for Order ID 54 is successful. We have notified the seller to ship.', '2022-08-10 13:53:52'),
(40, 18, 'Payment is Successful', 'Payment for Order ID 55 is successful. We have notified the seller to ship.', '2022-08-10 14:34:03'),
(41, 18, 'Payment is Successful', 'Payment for Order ID 56 is successful. We have notified the seller to ship.', '2022-08-10 14:35:17'),
(42, 18, 'Payment is Successful', 'Payment for Order ID 57 is successful. We have notified the seller to ship.', '2022-08-10 14:36:55'),
(43, 18, 'Payment is Successful', 'Payment for Order ID 58 is successful. We have notified the seller to ship.', '2022-08-10 14:39:17'),
(44, 4, 'Payment is Successful', 'Payment for Order ID 59 is successful. We have notified the seller to ship.', '2022-08-10 14:44:44'),
(45, 4, 'Payment is Successful', 'Payment for Order ID 60 is successful. We have notified the seller to ship.', '2022-08-10 14:53:12'),
(46, 4, 'Payment is Successful', 'Payment for Order ID 61 is successful. We have notified the seller to ship.', '2022-08-10 14:57:34'),
(47, 1, 'Redeem Voucher', 'Successfully Redeemed Voucher ID: 1.', '2022-08-10 15:38:04'),
(48, 3, 'Payment is Successful', 'Payment for Order ID 62 is successful. We have notified the seller to ship.', '2022-08-10 17:04:00'),
(49, 3, 'Payment is Successful', 'Payment for Order ID 63 is successful. We have notified the seller to ship.', '2022-08-10 17:18:51'),
(50, 3, 'Payment is Successful', 'Payment for Order ID 64 is successful. We have notified the seller to ship.', '2022-08-10 17:20:40'),
(51, 3, 'Payment is Successful', 'Payment for Order ID 65 is successful. We have notified the seller to ship.', '2022-08-10 17:21:57'),
(52, 3, 'Payment is Successful', 'Payment for Order ID 66 is successful. We have notified the seller to ship.', '2022-08-10 17:23:49'),
(53, 3, 'Payment is Successful', 'Payment for Order ID 67 is successful. We have notified the seller to ship.', '2022-08-10 17:25:33'),
(54, 3, 'Payment is Successful', 'Payment for Order ID 68 is successful. We have notified the seller to ship.', '2022-08-10 17:30:40'),
(55, 3, 'Payment is Successful', 'Payment for Order ID 69 is successful. We have notified the seller to ship.', '2022-08-10 17:31:44'),
(58, 3, 'Payment is Successful', 'Payment for Order ID 72 is successful. We have notified the seller to ship.', '2022-08-10 17:49:34'),
(59, 1, 'Used Voucher', 'Voucher Id: 1has been used.', '2022-08-10 17:54:21'),
(62, 2, 'Used Voucher', 'Voucher Id: 3 has been used.', '2022-08-10 17:56:50'),
(63, 2, 'Payment is Successful', 'Payment for Order ID 74 is successful. We have notified the seller to ship.', '2022-08-10 17:56:50'),
(64, 2, 'Used Voucher', 'Voucher ( RM5 OFF FREE SHIPPING )has been used.', '2022-08-10 17:58:48'),
(65, 2, 'Payment is Successful', 'Payment for Order ID 75 is successful. We have notified the seller to ship.', '2022-08-10 17:58:48'),
(66, 1, 'Redeem Voucher', 'Successfully Redeemed Voucher ID: 11.', '2022-08-10 20:05:23'),
(67, 18, 'Redeem Voucher', 'Successfully Redeemed Voucher ID: 1.', '2022-08-10 20:11:29'),
(68, 18, 'Redeem Voucher', 'Successfully Redeemed Voucher ID: 6.', '2022-08-10 20:11:30'),
(69, 18, 'Redeem Voucher', 'Successfully Redeemed Voucher ID: 7.', '2022-08-10 20:11:31'),
(70, 18, 'Redeem Voucher', 'Successfully Redeemed Voucher ID: 8.', '2022-08-10 20:11:32'),
(71, 18, 'Redeem Voucher', 'Successfully Redeemed Voucher ID: 9.', '2022-08-10 20:11:33'),
(72, 18, 'Redeem Voucher', 'Successfully Redeemed Voucher ID: 10.', '2022-08-10 20:11:33'),
(73, 18, 'Redeem Voucher', 'Successfully Redeemed Voucher ID: 11.', '2022-08-10 20:11:34'),
(74, 18, 'Used Voucher', 'Voucher ( RM5 FREE SHIPPING ) has been used.', '2022-08-10 20:11:52'),
(75, 18, 'Payment is Successful', 'Payment for Order ID 76 is successful. We have notified the seller to ship.', '2022-08-10 20:11:52'),
(76, 18, 'Used Voucher', 'Voucher ( RM20 OFF ) has been used.', '2022-08-11 10:25:07'),
(77, 18, 'Payment is Successful', 'Payment for Order ID 77 is successful. We have notified the seller to ship.', '2022-08-11 10:25:07'),
(78, 18, 'Used Voucher', 'Voucher ( RM20 OFF ) has been used.', '2022-08-11 10:27:53'),
(79, 18, 'Payment is Successful', 'Payment for Order ID 78 is successful. We have notified the seller to ship.', '2022-08-11 10:27:53'),
(80, 18, 'Payment is Successful', 'Payment for Order ID 79 is successful. We have notified the seller to ship.', '2022-08-11 11:02:57'),
(81, 18, 'Used Voucher', 'Voucher ( RM20 OFF ) has been used.', '2022-08-11 11:03:42'),
(82, 18, 'Payment is Successful', 'Payment for Order ID 80 is successful. We have notified the seller to ship.', '2022-08-11 11:03:42'),
(83, 1, 'Used Voucher', 'Voucher ( RM20 OFF ) has been used.', '2022-08-11 11:16:56'),
(84, 1, 'Payment is Successful', 'Payment for Order ID 81 is successful. We have notified the seller to ship.', '2022-08-11 11:16:56'),
(85, 1, 'Payment is Successful', 'Payment for Order ID 82 is successful. We have notified the seller to ship.', '2022-08-11 11:17:11'),
(86, 1, 'Payment is Successful', 'Payment for Order ID 83 is successful. We have notified the seller to ship.', '2022-08-11 12:10:55'),
(87, 1, 'Payment is Successful', 'Payment for Order ID 84 is successful. We have notified the seller to ship.', '2022-08-11 12:16:24'),
(88, 1, 'Redeem Voucher', 'Successfully Redeemed Voucher ID: 6.', '2022-08-11 12:20:32'),
(89, 1, 'Used Voucher', 'Voucher ( RM20 OFF ) has been used.', '2022-08-11 12:41:15'),
(90, 1, 'Payment is Successful', 'Payment for Order ID 85 is successful. We have notified the seller to ship.', '2022-08-11 12:41:15'),
(91, 1, 'Payment is Successful', 'Payment for Order ID 86 is successful. We have notified the seller to ship.', '2022-08-11 13:05:12');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `grand_total` double NOT NULL DEFAULT 0,
  `order_time` datetime NOT NULL,
  `shipment_status` varchar(255) NOT NULL DEFAULT 'pending',
  `shipment_time` datetime DEFAULT NULL,
  `delivered_time` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `user_id`, `grand_total`, `order_time`, `shipment_status`, `shipment_time`, `delivered_time`) VALUES
(14, 2, 1290, '2022-08-05 14:16:15', 'pending', NULL, NULL),
(15, 2, 1290, '2022-08-05 14:19:12', 'pending', NULL, NULL),
(16, 2, 200, '2022-08-05 14:22:11', 'pending', NULL, NULL),
(17, 2, 210, '2022-08-05 21:00:45', 'pending', NULL, NULL),
(18, 2, 90, '2022-08-06 12:07:52', 'pending', NULL, NULL),
(19, 3, 250, '2022-08-06 12:13:37', 'pending', NULL, NULL),
(20, 3, 90, '2022-08-06 12:14:56', 'pending', NULL, NULL),
(21, 3, 430, '2022-08-06 12:15:24', 'pending', NULL, NULL),
(22, 1, 150, '2022-08-06 12:18:00', 'pending', NULL, NULL),
(23, 4, 770, '2022-08-06 14:19:14', 'pending', NULL, NULL),
(24, 4, 90, '2022-08-06 15:05:49', 'pending', NULL, NULL),
(32, 4, 111.3, '2022-08-06 16:11:07', 'pending', NULL, NULL),
(33, 4, 111.3, '2022-08-06 16:13:09', 'pending', NULL, NULL),
(34, 4, 217.3, '2022-08-06 16:13:35', 'pending', NULL, NULL),
(35, 4, 164.3, '2022-08-08 00:18:18', 'pending', NULL, NULL),
(36, 4, 312.7, '2022-08-08 00:24:11', 'pending', NULL, NULL),
(37, 5, 90.1, '2022-08-08 14:11:01', 'pending', NULL, NULL),
(38, 3, 47.7, '2022-08-08 15:50:17', 'pending', NULL, NULL),
(39, 3, 249.1, '2022-08-08 16:55:49', 'pending', NULL, NULL),
(40, 3, 58.3, '2022-08-08 16:57:29', 'pending', NULL, NULL),
(50, 1, 270.3, '2022-08-09 16:08:37', 'pending', NULL, NULL),
(51, 3, 296.8, '2022-08-09 16:22:11', 'pending', NULL, NULL),
(52, 18, 413.4, '2022-08-10 11:27:46', 'pending', NULL, NULL),
(53, 18, 42.4, '2022-08-10 13:51:30', 'pending', NULL, NULL),
(54, 18, 58.3, '2022-08-10 13:53:52', 'pending', NULL, NULL),
(55, 18, 90.1, '2022-08-10 14:34:03', 'pending', NULL, NULL),
(56, 18, 47.7, '2022-08-10 14:35:17', 'pending', NULL, NULL),
(57, 18, 100.7, '2022-08-10 14:36:55', 'pending', NULL, NULL),
(58, 18, 58.3, '2022-08-10 14:39:17', 'pending', NULL, NULL),
(59, 4, 1701.3, '2022-08-10 14:44:44', 'Preparing', NULL, NULL),
(60, 4, 58.3, '2022-08-10 14:53:12', 'Preparing', NULL, NULL),
(61, 4, 853.3, '2022-08-10 14:57:34', 'Delivered', '2022-08-10 15:35:35', '2022-08-10 15:36:57'),
(62, 3, 90.1, '2022-08-10 17:04:00', 'pending', NULL, NULL),
(63, 3, 84.8, '2022-08-10 17:18:51', 'pending', NULL, NULL),
(64, 3, 44.52, '2022-08-10 17:20:40', 'pending', NULL, NULL),
(65, 3, 45.3, '2022-08-10 17:21:57', 'pending', NULL, NULL),
(66, 3, 47.46, '2022-08-10 17:23:49', 'pending', NULL, NULL),
(67, 3, 43.46, '2022-08-10 17:25:33', 'pending', NULL, NULL),
(68, 3, 84.8, '2022-08-10 17:30:40', 'pending', NULL, NULL),
(69, 3, 55.12, '2022-08-10 17:31:44', 'pending', NULL, NULL),
(70, 3, 119.78, '2022-08-10 17:47:56', 'pending', NULL, NULL),
(71, 3, 79.5, '2022-08-10 17:48:30', 'pending', NULL, NULL),
(72, 3, 79.5, '2022-08-10 17:49:34', 'pending', NULL, NULL),
(73, 1, 84.8, '2022-08-10 17:54:21', 'pending', NULL, NULL),
(74, 2, 100.7, '2022-08-10 17:56:50', 'Preparing', NULL, NULL),
(75, 2, 42.4, '2022-08-10 17:58:48', 'pending', NULL, NULL),
(76, 18, 42.4, '2022-08-10 20:11:52', 'Shipping', '2022-08-10 21:36:11', NULL),
(77, 18, 84.8, '2022-08-11 10:25:07', 'pending', NULL, NULL),
(78, 18, 58.3, '2022-08-11 10:27:53', 'pending', NULL, NULL),
(79, 18, 291.5, '2022-08-11 11:02:57', 'pending', NULL, NULL),
(80, 18, 1166, '2022-08-11 11:03:42', 'pending', NULL, NULL),
(81, 1, 302.1, '2022-08-11 11:16:56', 'pending', NULL, NULL),
(82, 1, 1277.3, '2022-08-11 11:17:11', 'pending', NULL, NULL),
(83, 1, 153.7, '2022-08-11 12:10:55', 'pending', NULL, NULL),
(84, 1, 121.9, '2022-08-11 12:16:24', 'pending', NULL, NULL),
(85, 1, 185.5, '2022-08-11 12:41:15', 'pending', NULL, NULL),
(86, 1, 90.1, '2022-08-11 13:05:12', 'pending', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `order_lists`
--

CREATE TABLE `order_lists` (
  `order_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `subtotal` double NOT NULL,
  `rated` tinyint(4) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `order_lists`
--

INSERT INTO `order_lists` (`order_id`, `product_id`, `quantity`, `subtotal`, `rated`) VALUES
(14, 1, 3, 150, 0),
(14, 2, 1, 40, 0),
(14, 3, 10, 900, 0),
(14, 4, 1, 100, 0),
(14, 6, 2, 100, 0),
(15, 1, 3, 150, 0),
(15, 2, 1, 40, 0),
(15, 3, 10, 900, 0),
(15, 4, 1, 100, 0),
(15, 6, 2, 100, 0),
(16, 4, 2, 200, 0),
(17, 2, 3, 120, 0),
(17, 3, 1, 90, 0),
(18, 1, 1, 50, 0),
(18, 2, 1, 40, 0),
(19, 5, 5, 250, 0),
(20, 3, 1, 90, 0),
(21, 2, 2, 80, 1),
(21, 4, 1, 100, 1),
(21, 6, 5, 250, 1),
(22, 1, 3, 150, 0),
(23, 1, 3, 150, 0),
(23, 2, 2, 80, 0),
(23, 3, 1, 90, 0),
(23, 4, 2, 200, 0),
(23, 6, 5, 250, 0),
(24, 3, 1, 90, 0),
(32, 4, 1, 100, 0),
(33, 5, 2, 100, 0),
(34, 4, 2, 200, 0),
(35, 6, 3, 150, 0),
(36, 1, 1, 50, 0),
(36, 2, 1, 40, 0),
(36, 4, 2, 200, 0),
(37, 2, 2, 80, 0),
(38, 2, 1, 40, 1),
(39, 2, 2, 80, 1),
(39, 6, 3, 150, 1),
(40, 1, 1, 50, 1),
(50, 14, 2, 100, 1),
(50, 15, 2, 70, 1),
(52, 2, 3, 120, 1),
(52, 3, 2, 180, 1),
(52, 6, 1, 50, 1),
(52, 15, 1, 35, 1),
(53, 15, 1, 35, 1),
(54, 14, 1, 50, 1),
(55, 1, 1, 80, 0),
(56, 2, 1, 40, 0),
(57, 3, 1, 90, 0),
(58, 6, 1, 50, 1),
(59, 1, 20, 1600, 1),
(60, 6, 1, 50, 0),
(61, 2, 20, 800, 0),
(62, 1, 1, 80, 0),
(63, 1, 1, 80, 0),
(64, 2, 1, 40, 0),
(65, 2, 1, 40, 0),
(66, 2, 1, 40, 0),
(67, 2, 1, 40, 0),
(68, 1, 1, 80, 0),
(69, 6, 1, 50, 1),
(70, 1, 1, 80, 0),
(70, 2, 1, 40, 0),
(71, 15, 2, 70, 0),
(72, 15, 2, 70, 0),
(73, 1, 1, 80, 0),
(74, 6, 2, 100, 0),
(75, 2, 1, 40, 0),
(76, 2, 1, 40, 0),
(77, 1, 1, 75, 0),
(78, 5, 1, 50, 0),
(79, 3, 3, 270, 0),
(80, 1, 1, 75, 0),
(80, 2, 1, 40, 0),
(80, 4, 10, 1000, 0),
(81, 1, 4, 300, 0),
(82, 2, 30, 1200, 0),
(83, 20, 1, 80, 1),
(83, 22, 1, 60, 1),
(84, 21, 1, 110, 1),
(85, 1, 2, 150, 0),
(85, 2, 1, 40, 0),
(86, 20, 1, 80, 0);

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `price` double NOT NULL,
  `description` varchar(255) NOT NULL,
  `image` varchar(255) NOT NULL,
  `quantity` int(11) NOT NULL,
  `release_date` datetime NOT NULL,
  `amount_of_sold` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `name`, `price`, `description`, `image`, `quantity`, `release_date`, `amount_of_sold`) VALUES
(1, 'Kanao Cosplay 2', 75, 'Demon Slayer Kanao Cosplay', '\\static\\pic\\kanao2.jpg', 287, '2022-08-03 13:02:37', 34),
(2, 'jk shirt', 40, 'White Jk Shirt', '\\static\\pic\\purplejk.jpg', 11, '2022-08-04 12:02:37', 60),
(3, 'Kanao Cosplay', 90, 'Kanao Cosplay Set (Wig+ Costume+ Coat)', '\\static\\pic\\kanao.jpg', 16, '2022-08-04 20:31:50', 4),
(4, 'Nezuko', 100, 'Nezuko Cosplay Costume Set', '\\static\\pic\\nezuko.jpg', 20, '2022-08-04 20:37:50', 10),
(5, 'Blue Jk', 50, 'Blue Jk Skirt', '\\static\\pic\\bluejk.jpg', 99, '2022-08-04 20:40:50', 1),
(6, 'Green Jk', 50, 'Green Jk Skirt', '\\static\\pic\\greenjk.jpg', 195, '2022-08-04 20:42:50', 5),
(14, 'Red JK', 50, 'Red JK CNY Red Line', '\\static\\pic\\redjk.jpg', 50, '2022-08-09 14:41:03', 0),
(15, 'Egirl JK', 35, 'E-Girl JK', '\\static\\pic\\egirlJk.jpg', 66, '2022-08-09 14:45:53', 4),
(18, 'Rem Cosplay', 80, 'Rem Cosplay Full Set', '\\static\\pic\\rem.jpg', 50, '2022-08-09 16:29:49', 0),
(19, '星星抱月球 千鸟格群', 65, '星星抱月球 千鸟格群 M size 42 MM', '\\static\\pic\\yellowjk.jpg', 100, '2022-08-11 11:22:00', 0),
(20, 'DokiBoom 冈犁田', 80, 'DokiBoom 冈犁田 42MM TR', '\\static\\pic\\dokiboomjk.jpg', 98, '2022-08-11 11:23:48', 2),
(21, 'SwallowJk 燕子家 JK ', 110, 'SwallowJk 燕子家 JK 水手服 M size', '\\static\\pic\\swallowjk.jpg', 149, '2022-08-11 11:25:48', 1),
(22, 'Jk Vest', 60, 'Jk Vest S Size', '\\static\\pic\\jkvest.jpg', 74, '2022-08-11 11:31:34', 1),
(23, 'Jk Coat', 130, 'Jk Coat M Size', '\\static\\pic\\jkcoat.jpg', 200, '2022-08-11 11:33:03', 0);

-- --------------------------------------------------------

--
-- Table structure for table `ratings`
--

CREATE TABLE `ratings` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `stars` int(11) NOT NULL,
  `content` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `ratings`
--

INSERT INTO `ratings` (`id`, `product_id`, `user_id`, `stars`, `content`, `created_at`) VALUES
(1, 15, 1, 4, 'Very Nice egirl jk', '2022-08-10 11:00:21'),
(2, 14, 1, 5, 'Nice CNY skirt', '2022-08-10 11:00:21'),
(3, 14, 1, 3, 'Nice', '2022-08-10 11:00:21'),
(4, 15, 1, 5, 'nice skirt', '2022-08-10 11:00:21'),
(5, 1, 3, 5, 'nice set', '2022-08-10 11:00:21'),
(6, 6, 3, 5, 'Very Nice Green Color JK! Love it~ <3', '2022-08-10 11:00:21'),
(7, 2, 3, 5, 'Green Shirt', '2022-08-10 11:00:21'),
(8, 2, 3, 5, 'Nice Shirt', '2022-08-10 11:00:21'),
(9, 4, 3, 5, 'Very Nice Nezuko Cosplay!!!', '2022-08-10 11:00:21'),
(10, 6, 3, 5, 'Nice Green Color Jk, Kawaiii', '2022-08-10 11:00:21'),
(11, 2, 3, 5, 'nice purple shirt', '2022-08-10 11:00:21'),
(12, 2, 18, 5, 'Good Looking Shirt', '2022-08-10 11:00:21'),
(13, 3, 18, 5, 'Very Cute Kanao Cosplay Set, it comes with full set!', '2022-08-10 11:00:21'),
(14, 6, 18, 5, 'I love this skirt so well! the colors is very sharp and nice', '2022-08-10 11:00:21'),
(15, 15, 18, 5, 'this egirl jk is so sexy and cute at the same time!!', '2022-08-10 11:00:21'),
(16, 15, 18, 5, 'Sexy!!', '0000-00-00 00:00:00'),
(17, 14, 18, 5, 'its so cute and kawaii', '2022-08-10 13:54:36'),
(18, 6, 18, 1, 'I\'m Karen', '2022-08-10 14:43:22'),
(19, 1, 4, 5, 'Noice Noice Noice', '2022-08-10 14:45:01'),
(20, 6, 3, 5, 'nice jk, btw this is my first jk, lovely seller !', '2022-08-10 17:40:52'),
(21, 22, 1, 5, 'pretty, and cute!', '2022-08-11 12:15:55'),
(22, 20, 1, 5, 'nice and awesome jk skirt! love it ', '2022-08-11 12:16:09'),
(23, 21, 1, 5, 'very pretty and nice-looking', '2022-08-11 12:17:12');

-- --------------------------------------------------------

--
-- Table structure for table `seller`
--

CREATE TABLE `seller` (
  `id` int(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `password_hash` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `seller`
--

INSERT INTO `seller` (`id`, `username`, `password_hash`) VALUES
(1, 'yiyi', 'pbkdf2:sha256:260000$3cwSnkiWJTOQYTn4$28eabb6858e3a8def442c274d1228621d4e3be7097565edbd76d0d3572b09031');

-- --------------------------------------------------------

--
-- Table structure for table `seller_notifications`
--

CREATE TABLE `seller_notifications` (
  `id` int(11) NOT NULL,
  `seller_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `message` varchar(255) NOT NULL,
  `notify_time` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `seller_notifications`
--

INSERT INTO `seller_notifications` (`id`, `seller_id`, `title`, `message`, `notify_time`) VALUES
(1, 1, 'New Order', 'Order Id: 72 has been placed.', '2022-08-10 17:49:34'),
(2, 1, 'New Order', 'Order Id: 74 has been placed.', '2022-08-10 17:56:50'),
(3, 1, 'New Order', 'Order Id: 75 has been placed.', '2022-08-10 17:58:48'),
(4, 1, 'New Order', 'Order Id: 76 has been placed.', '2022-08-10 20:11:52'),
(5, 1, 'New Order', 'Order Id: 77 has been placed.', '2022-08-11 10:25:07'),
(6, 1, 'New Order', 'Order Id: 78 has been placed.', '2022-08-11 10:27:53'),
(7, 1, 'New Order', 'Order Id: 79 has been placed.', '2022-08-11 11:02:57'),
(8, 1, 'New Order', 'Order Id: 80 has been placed.', '2022-08-11 11:03:42'),
(9, 1, 'New Order', 'Order Id: 81 has been placed.', '2022-08-11 11:16:56'),
(10, 1, 'New Order', 'Order Id: 82 has been placed.', '2022-08-11 11:17:11'),
(11, 1, 'New Order', 'Order Id: 83 has been placed.', '2022-08-11 12:10:55'),
(12, 1, 'New Order', 'Order Id: 84 has been placed.', '2022-08-11 12:16:24'),
(13, 1, 'New Order', 'Order Id: 85 has been placed.', '2022-08-11 12:41:15'),
(14, 1, 'New Order', 'Order Id: 86 has been placed.', '2022-08-11 13:05:12');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `gender` enum('M','F','others') NOT NULL,
  `DOB` datetime NOT NULL,
  `registered_date` datetime NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `phone_number` varchar(255) DEFAULT NULL,
  `profile_picture` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password_hash`, `email`, `gender`, `DOB`, `registered_date`, `name`, `address`, `phone_number`, `profile_picture`) VALUES
(1, 'yiyi', 'pbkdf2:sha256:260000$MzTPvnnpIMFaZdxE$9c5a252b0f63c75de6eb5d7f76d3b22e8c25c960ea0fcbf2beb2c787ab97936a', 'yiyi@gmail.com', 'F', '2022-01-01 00:00:00', '2022-08-03 00:08:37', 'yiyi', 'Street 11, Selangor, Malaysia', '012-9646220', ''),
(2, 'yiyi11', 'pbkdf2:sha256:260000$1cQhmNct32K6b6IL$07bcfd1ec6604d65671425afe332ff93516fa5d31bf37514152b4add013449ac', 'yiyi11@gmail.com', 'F', '2002-01-22 00:00:00', '2022-08-03 11:46:13', NULL, NULL, NULL, ''),
(3, 'yiyimeow', 'pbkdf2:sha256:260000$4OcndkXxKm0d2vaO$211bf10b3949ceaba16d2b58dfafe4f0b4cd84d2fa5eff3eb17a5adaf9990c13', 'yiyimeow@gmail.com', 'others', '2011-11-22 00:00:00', '2022-08-03 13:01:49', NULL, NULL, NULL, ''),
(4, 'miaomiao', 'pbkdf2:sha256:260000$WFTqk6szWd6bo2wq$ac617b07037f33fef379fd60b89a6ba842df702ee9efa0e4f30dc5e4fe35dd5e', 'miao@gmail.com', 'F', '2022-01-01 00:00:00', '2022-08-06 13:45:59', NULL, NULL, NULL, ''),
(5, 'meowmeow', 'pbkdf2:sha256:260000$6YYw21ol6z7Y0tZD$0e7478ea91033399a2cf2c4cc28d24ed72df64690360b00d147ff2dfdba5a949', 'meowmeow@gmail.com', 'M', '2022-08-02 00:00:00', '2022-08-08 14:10:42', NULL, NULL, NULL, ''),
(14, 'catie', 'pbkdf2:sha256:260000$PqhEnWUTOKRI1kq8$b5ec3bc285384734f8265df626e9a8827d90ef9db25e9bd236127d0caf4b54b3', 'catie@gmail.com', 'M', '2022-08-01 00:00:00', '2022-08-08 14:22:06', NULL, NULL, NULL, ''),
(15, 'test', 'pbkdf2:sha256:260000$grwSw89eubh8sCzH$13b5c37baaf0e66e4e0f9e1b3ddc22c7c1147f4b85f217883993e36dccc4ef07', 'test', 'M', '2022-08-01 00:00:00', '2022-08-08 15:57:38', NULL, NULL, NULL, ''),
(16, 'test2', 'pbkdf2:sha256:260000$RdpAlsBSm9CtkccB$78f0109b342e8c42991b0ab57a75b95a107974fe308dafad0a1da2fcb395f903', 'test2', 'M', '2022-08-01 00:00:00', '2022-08-08 15:58:51', NULL, NULL, NULL, ''),
(17, 'test3', 'pbkdf2:sha256:260000$7d6L5CA4xiaZeji7$3851bd4a53c08518adea6ea1c3a9230f7381bfdbd7ac4cf9acf395e6ae8f02ce', 'test3', 'M', '2022-08-01 00:00:00', '2022-08-08 16:00:14', NULL, NULL, NULL, ''),
(18, 'yiyimiaomiao', 'pbkdf2:sha256:260000$Iv5ukV470izpo1fb$808160a2cd7cd8263e1f511358c695119c69ee9ddad2268d235ebf52b45eeae4', 'yiyimiaomiao@gmail.com', 'F', '2022-08-01 00:00:00', '2022-08-10 11:26:58', 'yiyimiao', 'miao miao, taman catty, 11111, Malaysia', '6011-1321311', '');

-- --------------------------------------------------------

--
-- Table structure for table `user_vouchers`
--

CREATE TABLE `user_vouchers` (
  `user_id` int(11) NOT NULL,
  `voucher_id` int(11) NOT NULL,
  `used` tinyint(4) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `user_vouchers`
--

INSERT INTO `user_vouchers` (`user_id`, `voucher_id`, `used`) VALUES
(1, 1, 1),
(1, 6, 1),
(1, 11, 1),
(2, 1, 1),
(2, 2, 0),
(2, 3, 1),
(3, 1, 1),
(3, 2, 1),
(3, 3, 1),
(4, 1, 0),
(4, 2, 0),
(5, 1, 0),
(18, 1, 1),
(18, 6, 1),
(18, 7, 1),
(18, 8, 1),
(18, 9, 0),
(18, 10, 0),
(18, 11, 0);

-- --------------------------------------------------------

--
-- Table structure for table `vouchers`
--

CREATE TABLE `vouchers` (
  `id` int(11) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `is_shipment` tinyint(4) NOT NULL,
  `by_percentage` tinyint(4) NOT NULL,
  `minimum_spend` double NOT NULL,
  `deduct_amount` double NOT NULL,
  `start_date` datetime NOT NULL,
  `end_date` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `vouchers`
--

INSERT INTO `vouchers` (`id`, `name`, `is_shipment`, `by_percentage`, `minimum_spend`, `deduct_amount`, `start_date`, `end_date`) VALUES
(1, 'RM5 FREE SHIPPING', 1, 0, 40, 5, '2022-08-01 00:00:00', '2022-09-01 00:00:00'),
(2, 'RM3 OFF', 0, 0, 20, 3, '2022-08-04 22:28:00', '2022-08-07 00:00:00'),
(3, '10% OFF', 0, 1, 10, 10, '2022-08-04 22:50:00', '2022-08-05 22:50:00'),
(6, 'RM20 OFF', 0, 0, 100, 20, '2022-08-09 00:00:00', '2022-08-31 00:00:00'),
(7, 'RM20 OFF', 0, 0, 100, 20, '2022-08-09 00:00:00', '2022-08-31 00:00:00'),
(8, 'RM20 OFF', 0, 0, 100, 20, '2022-08-09 00:00:00', '2022-08-31 00:00:00'),
(9, 'RM20 OFF', 0, 0, 100, 20, '2022-08-09 00:00:00', '2022-08-31 00:00:00'),
(10, 'RM20 OFF', 0, 0, 100, 20, '2022-08-09 00:00:00', '2022-08-31 00:00:00'),
(11, 'RM20 OFF', 0, 0, 100, 20, '2022-08-09 00:00:00', '2022-08-31 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `wallets`
--

CREATE TABLE `wallets` (
  `user_id` int(11) NOT NULL,
  `amount` double NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `wallets`
--

INSERT INTO `wallets` (`user_id`, `amount`) VALUES
(1, 97495.29999999999),
(2, 106.9),
(3, 429.6600000000001),
(4, 2507.0999999999995),
(5, 0),
(17, 50),
(18, 262.10000000000014);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `chats`
--
ALTER TABLE `chats`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `chat_lines`
--
ALTER TABLE `chat_lines`
  ADD PRIMARY KEY (`id`),
  ADD KEY `chat_id` (`chat_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `order_lists`
--
ALTER TABLE `order_lists`
  ADD PRIMARY KEY (`order_id`,`product_id`),
  ADD KEY `order_lists_ibfk_2` (`product_id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ratings`
--
ALTER TABLE `ratings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_id` (`product_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `seller`
--
ALTER TABLE `seller`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `seller_notifications`
--
ALTER TABLE `seller_notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `seller_id` (`seller_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `password_hash` (`password_hash`);

--
-- Indexes for table `user_vouchers`
--
ALTER TABLE `user_vouchers`
  ADD PRIMARY KEY (`user_id`,`voucher_id`),
  ADD KEY `user_vouchers_ibfk_2` (`voucher_id`);

--
-- Indexes for table `vouchers`
--
ALTER TABLE `vouchers`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `wallets`
--
ALTER TABLE `wallets`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `chats`
--
ALTER TABLE `chats`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `chat_lines`
--
ALTER TABLE `chat_lines`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=57;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=92;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=87;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `ratings`
--
ALTER TABLE `ratings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `seller`
--
ALTER TABLE `seller`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `seller_notifications`
--
ALTER TABLE `seller_notifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `vouchers`
--
ALTER TABLE `vouchers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `chat_lines`
--
ALTER TABLE `chat_lines`
  ADD CONSTRAINT `chat_lines_ibfk_1` FOREIGN KEY (`chat_id`) REFERENCES `chats` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `chat_lines_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `order_lists`
--
ALTER TABLE `order_lists`
  ADD CONSTRAINT `order_lists_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `order_lists_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON UPDATE NO ACTION;

--
-- Constraints for table `ratings`
--
ALTER TABLE `ratings`
  ADD CONSTRAINT `ratings_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `ratings_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `seller_notifications`
--
ALTER TABLE `seller_notifications`
  ADD CONSTRAINT `seller_notifications_ibfk_1` FOREIGN KEY (`seller_id`) REFERENCES `seller` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `user_vouchers`
--
ALTER TABLE `user_vouchers`
  ADD CONSTRAINT `user_vouchers_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `user_vouchers_ibfk_2` FOREIGN KEY (`voucher_id`) REFERENCES `vouchers` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `wallets`
--
ALTER TABLE `wallets`
  ADD CONSTRAINT `wallets_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
