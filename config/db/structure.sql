CREATE TABLE `schema_migrations`(`filename` varchar(255) NOT NULL PRIMARY KEY);
CREATE TABLE `devices`(
  `id` integer NOT NULL PRIMARY KEY AUTOINCREMENT,
  `friendly_id` string,
  `label` string,
  `mac_address` string,
  `api_key` string,
  `firmware_version` string,
  `firmware_beta` boolean DEFAULT(0) NOT NULL,
  "signal" integer DEFAULT(0) NOT NULL,
  "battery" float DEFAULT(0) NOT NULL,
  `refresh_rate` integer DEFAULT(900) NOT NULL,
  `setup_at` timestamp,
  `created_at` timestamp DEFAULT(datetime(CURRENT_TIMESTAMP, 'localtime')) NOT NULL,
  `updated_at` timestamp DEFAULT(datetime(CURRENT_TIMESTAMP, 'localtime')) NOT NULL
);
INSERT INTO schema_migrations (filename) VALUES
('20250305150912_create_devices.rb'),
('20250318091514_alter_device_battery_and_signal.rb');
