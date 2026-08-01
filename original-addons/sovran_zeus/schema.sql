CREATE TABLE IF NOT EXISTS `sovran_zeus_object` (
  `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `class`       VARCHAR(64)  NOT NULL,
  `position_x`  DOUBLE NOT NULL,
  `position_y`  DOUBLE NOT NULL,
  `position_z`  DOUBLE NOT NULL,
  `dir_x`       DOUBLE NOT NULL DEFAULT 0,
  `dir_y`       DOUBLE NOT NULL DEFAULT 1,
  `dir_z`       DOUBLE NOT NULL DEFAULT 0,
  `up_x`        DOUBLE NOT NULL DEFAULT 0,
  `up_y`        DOUBLE NOT NULL DEFAULT 0,
  `up_z`        DOUBLE NOT NULL DEFAULT 1,
  `created_by`  VARCHAR(32) NOT NULL DEFAULT '',
  `created_at`  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_class` (`class`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
