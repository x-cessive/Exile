
CREATE TABLE IF NOT EXISTS `barter` (
  `uid` varchar(32) NOT NULL,
  `barterdata` text,
  KEY `barter_ibfk_1` (`uid`),
  CONSTRAINT `barter_ibfk_1` FOREIGN KEY (`uid`) REFERENCES `account` (`uid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
