CREATE TABLE `harmonized_tariffs` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(255) NOT NULL DEFAULT '',
  `description` text,
  `unit` varchar(255) DEFAULT NULL,
  `rate_1` varchar(255) DEFAULT NULL,
  `special_rate` varchar(255) DEFAULT '',
  `rate_2` varchar(255) DEFAULT NULL,
  `notes` text,
  PRIMARY KEY (`id`),
  KEY `tariff` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
