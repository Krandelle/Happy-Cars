-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 04, 2025 at 07:09 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `car_rental_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `books`
--

CREATE TABLE `books` (
  `id` int(30) NOT NULL,
  `car_id` int(30) NOT NULL,
  `pickup_datetime` datetime NOT NULL,
  `dropoff_datetime` datetime NOT NULL,
  `car_registration_no` varchar(200) NOT NULL,
  `car_plate_no` varchar(200) NOT NULL,
  `name` text NOT NULL,
  `email` varchar(200) NOT NULL,
  `contact` varchar(20) NOT NULL,
  `address` text NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '0= cancelled,1=Pending , 2= confirmed'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `books`
--

INSERT INTO `books` (`id`, `car_id`, `pickup_datetime`, `dropoff_datetime`, `car_registration_no`, `car_plate_no`, `name`, `email`, `contact`, `address`, `status`) VALUES
(1, 5, '2020-10-27 16:00:00', '2020-10-28 18:00:00', '123456789', 'GBN-623', 'John Smith', 'jsmith@sample.com', '+6948 8542 623', 'Sample', 2);

-- --------------------------------------------------------

--
-- Table structure for table `borrowed_cars`
--

CREATE TABLE `borrowed_cars` (
  `id` int(30) NOT NULL,
  `booked_id` int(30) NOT NULL,
  `car_id` int(30) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1=picked-up,2=drop-off'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `borrowed_cars`
--

INSERT INTO `borrowed_cars` (`id`, `booked_id`, `car_id`, `status`) VALUES
(1, 1, 0, 2);

-- --------------------------------------------------------

--
-- Table structure for table `cars`
--

CREATE TABLE `cars` (
  `id` int(30) NOT NULL,
  `model` varchar(200) NOT NULL,
  `brand` varchar(200) NOT NULL,
  `transmission_id` int(30) NOT NULL,
  `category_id` int(30) NOT NULL,
  `engine_id` int(30) NOT NULL,
  `description` text NOT NULL,
  `price` float NOT NULL,
  `qty` int(30) NOT NULL,
  `img_path` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `cars`
--

INSERT INTO `cars` (`id`, `model`, `brand`, `transmission_id`, `category_id`, `engine_id`, `description`, `price`, `qty`, `img_path`) VALUES
(3, '2020 Ford Escape', 'Ford', 3, 1, 2, '&lt;span style=&quot;color: rgb(10, 10, 10); font-family: Roboto, sans-serif; font-size: 16px; background-color: rgb(254, 254, 254);&quot;&gt;The redesigned 2020 Ford Escape finishes in the top third of our compact SUV rankings. It has a great predicted reliability rating, a spacious interior, and engaging performance, but its middling interior quality keeps it from being a class leader.&lt;/span&gt;', 2000, 5, '1603337160_image.imgs.full.high.jpg'),
(4, 'Hyundai Verna', 'Hyundai', 2, 2, 1, '&lt;b style=&quot;color: rgb(34, 34, 34); font-family: arial, sans-serif; font-size: 16px;&quot;&gt;Hyundai Verna&lt;/b&gt;&lt;span style=&quot;color: rgb(34, 34, 34); font-family: arial, sans-serif; font-size: 16px;&quot;&gt;&amp;nbsp;is a 5 seater Sedan available in a price range of Rs 9.03 - 15.19 Lakh. It is available in 12 variants, 1 engine option and 4 transmission options : Manual,&amp;nbsp;&lt;/span&gt;&lt;b style=&quot;color: rgb(34, 34, 34); font-family: arial, sans-serif; font-size: 16px;&quot;&gt;Automatic&lt;/b&gt;&lt;span style=&quot;color: rgb(34, 34, 34); font-family: arial, sans-serif; font-size: 16px;&quot;&gt;&amp;nbsp;(CVT),&amp;nbsp;&lt;/span&gt;&lt;b style=&quot;color: rgb(34, 34, 34); font-family: arial, sans-serif; font-size: 16px;&quot;&gt;Automatic&lt;/b&gt;&lt;span style=&quot;color: rgb(34, 34, 34); font-family: arial, sans-serif; font-size: 16px;&quot;&gt;&amp;nbsp;(Torque Converter) and&amp;nbsp;&lt;/span&gt;&lt;b style=&quot;color: rgb(34, 34, 34); font-family: arial, sans-serif; font-size: 16px;&quot;&gt;Automatic&lt;/b&gt;&lt;span style=&quot;color: rgb(34, 34, 34); font-family: arial, sans-serif; font-size: 16px;&quot;&gt;&amp;nbsp;(Dual Clutch).&lt;/span&gt;', 1500, 5, '1603338000_DSC_7294_800x450.jpg'),
(5, '2020 Honda Civic', 'Honda', 1, 3, 2, '&lt;p style=&quot;margin-bottom: 15px; padding: 0px; text-align: justify; color: rgb(0, 0, 0); font-family: &quot; open=&quot;&quot; sans&quot;,=&quot;&quot; arial,=&quot;&quot; sans-serif;&quot;=&quot;&quot;&gt;Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent aliquet justo accumsan varius efficitur. Sed sit amet massa quam. Aenean dictum urna nulla, nec iaculis ligula ullamcorper eleifend. Nulla imperdiet semper leo. Aliquam elit lectus, cursus sit amet felis sed, sollicitudin sollicitudin dui. Ut placerat consectetur tortor non eleifend. Integer dignissim ex ac dignissim pharetra. Curabitur gravida hendrerit tempus. Nunc fringilla tempor ex quis malesuada. Suspendisse laoreet sem egestas aliquam semper.&lt;/p&gt;&lt;p style=&quot;margin-bottom: 15px; padding: 0px; text-align: justify; color: rgb(0, 0, 0); font-family: &quot; open=&quot;&quot; sans&quot;,=&quot;&quot; arial,=&quot;&quot; sans-serif;&quot;=&quot;&quot;&gt;Curabitur elementum molestie dignissim. Ut vel urna metus. Suspendisse blandit lacus quis mauris ultricies dictum. Quisque accumsan ornare ligula sit amet dignissim. Maecenas a sollicitudin purus. In porta risus enim, congue porttitor sapien efficitur ut. Curabitur finibus enim a massa egestas luctus. Proin ornare ante tincidunt, rutrum mauris id, tristique massa. Quisque convallis neque dui, eu ultricies elit eleifend et. Curabitur nec finibus libero, a iaculis orci. Cras nec dapibus elit. Vivamus blandit dignissim ipsum, nec vestibulum nisl tincidunt tempor. Aliquam ex eros, cursus ac pretium eu, commodo ut eros. Cras id arcu nulla. Cras in ultricies augue.&lt;/p&gt;&lt;p style=&quot;margin-bottom: 15px; padding: 0px; text-align: justify; color: rgb(0, 0, 0); font-family: &quot; open=&quot;&quot; sans&quot;,=&quot;&quot; arial,=&quot;&quot; sans-serif;&quot;=&quot;&quot;&gt;&lt;br&gt;&lt;/p&gt;', 1200, 1, '1603338300_honda civic.jpg'),
(6, 'Wave 125', 'Honda', 1, 7, 2, '&lt;table class=&quot;table-specs m-lg-t&quot; style=&quot;margin: 20px 0px 0px; padding: 0px; -webkit-user-drag: none; text-size-adjust: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); width: 780px; color: rgb(36, 39, 44); font-family: poppins-regular, sans-serif;&quot;&gt;&lt;tbody style=&quot;margin: 0px; padding: 0px; -webkit-user-drag: none; text-size-adjust: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0);&quot;&gt;&lt;tr style=&quot;margin: 0px; padding: 0px; -webkit-user-drag: none; text-size-adjust: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); border-bottom: 1px solid rgb(221, 221, 221);&quot;&gt;&lt;td class=&quot;truncate&quot; style=&quot;margin: 0px; padding: 13px 20px; -webkit-user-drag: none; text-size-adjust: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); text-wrap: nowrap;&quot;&gt;&lt;p class=&quot;d-flex align-center&quot; style=&quot;margin-bottom: 0px; padding: 0px; -webkit-user-drag: none; text-size-adjust: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); align-items: center;&quot;&gt;&lt;img src=&quot;https://imgcdn.zigwheels.ph/feature/break-type.svg&quot; data-src=&quot;https://imgcdn.zigwheels.ph/feature/break-type.svg&quot; class=&quot;m-xs-r lazyLoaded&quot; width=&quot;16&quot; height=&quot;17&quot; style=&quot;margin-right: 0px; margin-bottom: 0px; padding: 0px; -webkit-user-drag: none; text-size-adjust: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-inline-end: 4px; max-width: 100%; height: auto; outline: none;&quot;&gt;Front Brake&lt;/p&gt;&lt;/td&gt;&lt;td class=&quot;t-right f-semibold&quot; style=&quot;margin: 0px; padding: 13px 20px; -webkit-user-drag: none; text-size-adjust: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); font-family: poppins-medium, sans-serif; text-align: end;&quot;&gt;&lt;p style=&quot;margin-bottom: 0px; padding: 0px; -webkit-user-drag: none; text-size-adjust: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0);&quot;&gt;Disc&lt;/p&gt;&lt;/td&gt;&lt;/tr&gt;&lt;tr style=&quot;margin: 0px; padding: 0px; -webkit-user-drag: none; text-size-adjust: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); border-bottom: 1px solid rgb(221, 221, 221);&quot;&gt;&lt;td class=&quot;truncate&quot; style=&quot;margin: 0px; padding: 13px 20px; -webkit-user-drag: none; text-size-adjust: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); text-wrap: nowrap;&quot;&gt;&lt;p class=&quot;d-flex align-center&quot; style=&quot;margin-bottom: 0px; padding: 0px; -webkit-user-drag: none; text-size-adjust: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); align-items: center;&quot;&gt;&lt;img src=&quot;https://imgcdn.zigwheels.ph/feature/engine-displacement.svg&quot; data-src=&quot;https://imgcdn.zigwheels.ph/feature/engine-displacement.svg&quot; class=&quot;m-xs-r lazyLoaded&quot; width=&quot;16&quot; height=&quot;17&quot; style=&quot;margin-right: 0px; margin-bottom: 0px; padding: 0px; -webkit-user-drag: none; text-size-adjust: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-inline-end: 4px; max-width: 100%; height: auto; outline: none;&quot;&gt;Engine&lt;/p&gt;&lt;/td&gt;&lt;td class=&quot;t-right f-semibold&quot; style=&quot;margin: 0px; padding: 13px 20px; -webkit-user-drag: none; text-size-adjust: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); font-family: poppins-medium, sans-serif; text-align: end;&quot;&gt;&lt;p style=&quot;margin-bottom: 0px; padding: 0px; -webkit-user-drag: none; text-size-adjust: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0);&quot;&gt;124.8 cc&lt;/p&gt;&lt;/td&gt;&lt;/tr&gt;&lt;tr style=&quot;margin: 0px; padding: 0px; -webkit-user-drag: none; text-size-adjust: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); border-bottom: 1px solid rgb(221, 221, 221);&quot;&gt;&lt;td class=&quot;truncate&quot; style=&quot;margin: 0px; padding: 13px 20px; -webkit-user-drag: none; text-size-adjust: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); text-wrap: nowrap;&quot;&gt;&lt;p class=&quot;d-flex align-center&quot; style=&quot;margin-bottom: 0px; padding: 0px; -webkit-user-drag: none; text-size-adjust: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); align-items: center;&quot;&gt;&lt;img src=&quot;https://imgcdn.zigwheels.ph/feature/transmission-type.svg&quot; data-src=&quot;https://imgcdn.zigwheels.ph/feature/transmission-type.svg&quot; class=&quot;m-xs-r lazyLoaded&quot; width=&quot;16&quot; height=&quot;17&quot; style=&quot;margin-right: 0px; margin-bottom: 0px; padding: 0px; -webkit-user-drag: none; text-size-adjust: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-inline-end: 4px; max-width: 100%; height: auto; outline: none;&quot;&gt;Transmission Type&lt;/p&gt;&lt;/td&gt;&lt;td class=&quot;t-right f-semibold&quot; style=&quot;margin: 0px; padding: 13px 20px; -webkit-user-drag: none; text-size-adjust: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); font-family: poppins-medium, sans-serif; text-align: end;&quot;&gt;&lt;p style=&quot;margin-bottom: 0px; padding: 0px; -webkit-user-drag: none; text-size-adjust: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0);&quot;&gt;Manual&lt;/p&gt;&lt;/td&gt;&lt;/tr&gt;&lt;tr style=&quot;margin: 0px; padding: 0px; -webkit-user-drag: none; text-size-adjust: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); border-bottom: 1px solid rgb(221, 221, 221);&quot;&gt;&lt;td class=&quot;truncate&quot; style=&quot;margin: 0px; padding: 13px 20px; -webkit-user-drag: none; text-size-adjust: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); text-wrap: nowrap;&quot;&gt;&lt;p class=&quot;d-flex align-center&quot; style=&quot;margin-bottom: 0px; padding: 0px; -webkit-user-drag: none; text-size-adjust: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); align-items: center;&quot;&gt;&lt;img src=&quot;https://imgcdn.zigwheels.ph/feature/clearance-ground.svg&quot; data-src=&quot;https://imgcdn.zigwheels.ph/feature/clearance-ground.svg&quot; class=&quot;m-xs-r lazyLoaded&quot; width=&quot;16&quot; height=&quot;17&quot; style=&quot;margin-right: 0px; margin-bottom: 0px; padding: 0px; -webkit-user-drag: none; text-size-adjust: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-inline-end: 4px; max-width: 100%; height: auto; outline: none;&quot;&gt;Ground Clearance&lt;/p&gt;&lt;/td&gt;&lt;td class=&quot;t-right f-semibold&quot; style=&quot;margin: 0px; padding: 13px 20px; -webkit-user-drag: none; text-size-adjust: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); font-family: poppins-medium, sans-serif; text-align: end;&quot;&gt;&lt;p style=&quot;margin-bottom: 0px; padding: 0px; -webkit-user-drag: none; text-size-adjust: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0);&quot;&gt;157 mm&lt;/p&gt;&lt;/td&gt;&lt;/tr&gt;&lt;tr style=&quot;margin: 0px; padding: 0px; -webkit-user-drag: none; text-size-adjust: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); border-bottom: 1px solid rgb(221, 221, 221);&quot;&gt;&lt;td class=&quot;truncate&quot; style=&quot;margin: 0px; padding: 13px 20px; -webkit-user-drag: none; text-size-adjust: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); text-wrap: nowrap;&quot;&gt;&lt;p class=&quot;d-flex align-center&quot; style=&quot;margin-bottom: 0px; padding: 0px; -webkit-user-drag: none; text-size-adjust: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); align-items: center;&quot;&gt;&lt;img src=&quot;https://imgcdn.zigwheels.ph/feature/start-options.svg&quot; data-src=&quot;https://imgcdn.zigwheels.ph/feature/start-options.svg&quot; class=&quot;m-xs-r lazyLoaded&quot; width=&quot;16&quot; height=&quot;17&quot; style=&quot;margin-right: 0px; margin-bottom: 0px; padding: 0px; -webkit-user-drag: none; text-size-adjust: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-inline-end: 4px; max-width: 100%; height: auto; outline: none;&quot;&gt;Start Option&lt;/p&gt;&lt;/td&gt;&lt;td class=&quot;t-right f-semibold&quot; style=&quot;margin: 0px; padding: 13px 20px; -webkit-user-drag: none; text-size-adjust: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); font-family: poppins-medium, sans-serif; text-align: end;&quot;&gt;&lt;p style=&quot;margin-bottom: 0px; padding: 0px; -webkit-user-drag: none; text-size-adjust: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0);&quot;&gt;Kick &amp;amp; Electric&lt;/p&gt;&lt;/td&gt;&lt;/tr&gt;&lt;tr style=&quot;margin: 0px; padding: 0px; -webkit-user-drag: none; text-size-adjust: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); border-bottom: 1px solid rgb(221, 221, 221);&quot;&gt;&lt;td class=&quot;truncate&quot; style=&quot;margin: 0px; padding: 13px 20px; -webkit-user-drag: none; text-size-adjust: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); text-wrap: nowrap;&quot;&gt;&lt;p class=&quot;d-flex align-center&quot; style=&quot;margin-bottom: 0px; padding: 0px; -webkit-user-drag: none; text-size-adjust: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); align-items: center;&quot;&gt;&lt;img src=&quot;https://imgcdn.zigwheels.ph/feature/power.svg&quot; data-src=&quot;https://imgcdn.zigwheels.ph/feature/power.svg&quot; class=&quot;m-xs-r lazyLoaded&quot; width=&quot;16&quot; height=&quot;17&quot; style=&quot;margin-right: 0px; margin-bottom: 0px; padding: 0px; -webkit-user-drag: none; text-size-adjust: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-inline-end: 4px; max-width: 100%; height: auto; outline: none;&quot;&gt;Power&lt;/p&gt;&lt;/td&gt;&lt;td class=&quot;t-right f-semibold&quot; style=&quot;margin: 0px; padding: 13px 20px; -webkit-user-drag: none; text-size-adjust: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); font-family: poppins-medium, sans-serif; text-align: end;&quot;&gt;&lt;p style=&quot;margin-bottom: 0px; padding: 0px; -webkit-user-drag: none; text-size-adjust: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0);&quot;&gt;8.71 HP&lt;/p&gt;&lt;/td&gt;&lt;/tr&gt;&lt;/tbody&gt;&lt;/table&gt;', 1500, 1, '1746378360_wave125.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `id` int(30) NOT NULL,
  `name` varchar(250) NOT NULL,
  `description` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `name`, `description`) VALUES
(1, 'SUV', 'Sport-Utility Vehicle'),
(2, 'SEDAN', 'SEDAN'),
(3, 'Coupe', 'Coupe									\r\n								'),
(4, 'STATION WAGON', 'STATION WAGON'),
(5, 'MINIVAN', 'MINIVAN'),
(6, 'Pickup Truck (4WD)', 'Pickup Truck - For-Wheel Drive (4x4)'),
(7, 'Motorcycle', 'Motorcycle');

-- --------------------------------------------------------

--
-- Table structure for table `engine_types`
--

CREATE TABLE `engine_types` (
  `id` int(30) NOT NULL,
  `name` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `engine_types`
--

INSERT INTO `engine_types` (`id`, `name`) VALUES
(1, 'Diesel'),
(2, 'Gasoline'),
(3, 'Electric Motor');

-- --------------------------------------------------------

--
-- Table structure for table `system_settings`
--

CREATE TABLE `system_settings` (
  `id` int(30) NOT NULL,
  `name` text NOT NULL,
  `email` varchar(200) NOT NULL,
  `contact` varchar(20) NOT NULL,
  `cover_img` text NOT NULL,
  `about_content` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `system_settings`
--

INSERT INTO `system_settings` (`id`, `name`, `email`, `contact`, `cover_img`, `about_content`) VALUES
(1, 'HappyCars', 'happycars@gmail.com', '+63 929 116 7300', '1746377400_blackbg.jpg', '&lt;p data-start=&quot;174&quot; data-end=&quot;404&quot; class=&quot;&quot; style=&quot;text-align: center;&quot;&gt;At HappyCars, we believe every journey should be smooth, safe, and enjoyable. Whether you&amp;#x2019;re planning a weekend getaway, a business trip, or just need a reliable ride around town, we&rsquo;ve got the perfect vehicle waiting for you.&lt;/p&gt;&lt;p data-start=&quot;406&quot; data-end=&quot;644&quot; class=&quot;&quot; style=&quot;text-align: center;&quot;&gt;Our easy-to-use online platform lets you browse, book, and drive&mdash;hassle-free. With a wide range of well-maintained cars, flexible rental options, and competitive pricing, HappyCars is here to make your travels easier and more comfortable.&lt;/p&gt;&lt;p style=&quot;text-align: center; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial; position: relative;&quot;&gt;&lt;/p&gt;&lt;p data-start=&quot;646&quot; data-end=&quot;756&quot; class=&quot;&quot; style=&quot;text-align: center;&quot;&gt;Wherever you&amp;#x2019;re headed, HappyCars is ready to take you there&mdash;because your journey starts with a smile.&lt;/p&gt;&lt;p style=&quot;text-align: center; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial; position: relative;&quot;&gt;&lt;br&gt;&lt;/p&gt;&lt;p style=&quot;text-align: center; background: transparent; position: relative;&quot;&gt;&lt;br&gt;&lt;/p&gt;&lt;p&gt;&lt;/p&gt;');

-- --------------------------------------------------------

--
-- Table structure for table `transmission_types`
--

CREATE TABLE `transmission_types` (
  `id` int(30) NOT NULL,
  `name` varchar(200) NOT NULL,
  `description` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `transmission_types`
--

INSERT INTO `transmission_types` (`id`, `name`, `description`) VALUES
(1, 'Manual transmission', 'Manual transmission'),
(2, 'Automatic transmission', 'Automatic transmission'),
(3, 'Continuously variable transmission', 'Continuously variable transmission (CVT)\r\n'),
(4, 'Semi-automatic and dual-clutch transmissions', 'Semi-automatic and dual-clutch transmissions');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(30) NOT NULL,
  `name` text NOT NULL,
  `username` varchar(200) NOT NULL,
  `password` text NOT NULL,
  `type` tinyint(1) NOT NULL DEFAULT 3 COMMENT '1=Admin,2=Staff, 3= subscriber'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `username`, `password`, `type`) VALUES
(1, 'Administrator', 'admin', '0192023a7bbd73250516f069df18b500', 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `books`
--
ALTER TABLE `books`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `borrowed_cars`
--
ALTER TABLE `borrowed_cars`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cars`
--
ALTER TABLE `cars`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `engine_types`
--
ALTER TABLE `engine_types`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `system_settings`
--
ALTER TABLE `system_settings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `transmission_types`
--
ALTER TABLE `transmission_types`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `books`
--
ALTER TABLE `books`
  MODIFY `id` int(30) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `borrowed_cars`
--
ALTER TABLE `borrowed_cars`
  MODIFY `id` int(30) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `cars`
--
ALTER TABLE `cars`
  MODIFY `id` int(30) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(30) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `engine_types`
--
ALTER TABLE `engine_types`
  MODIFY `id` int(30) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `system_settings`
--
ALTER TABLE `system_settings`
  MODIFY `id` int(30) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `transmission_types`
--
ALTER TABLE `transmission_types`
  MODIFY `id` int(30) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(30) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
