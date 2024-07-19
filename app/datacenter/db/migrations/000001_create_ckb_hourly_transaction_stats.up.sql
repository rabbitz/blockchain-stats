CREATE TABLE IF NOT EXISTS `ckb_hourly_transaction_stats`(
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT 'id primary key',
    `timestamp` BIGINT COMMENT 'stats timestamp',
    `transaction_count` INTEGER NOT NULL DEFAULT 0 COMMENT 'hourly total transaction count',
    `transaction_capacity` DECIMAL(38, 0) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'hourly total transaction capacity',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'created time',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'updated time',
    PRIMARY KEY(`id`),
    UNIQUE KEY `uc_timestamp_on_ckb_transaction_stats`(`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;