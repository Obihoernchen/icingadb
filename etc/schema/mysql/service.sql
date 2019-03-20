SET sql_mode = 'STRICT_ALL_TABLES,NO_ENGINE_SUBSTITUTION';
SET innodb_strict_mode = 1;

CREATE TABLE service (
  id binary(20) NOT NULL COMMENT 'sha1(environment.name + name)',
  env_id binary(20) NOT NULL COMMENT 'sha1(environment.name)',
  name_checksum binary(20) NOT NULL COMMENT 'sha1(name)',
  properties_checksum binary(20) NOT NULL COMMENT 'sha1(all properties)',
  customvars_checksum binary(20) NOT NULL COMMENT 'sha1(service.vars)',
  groups_checksum binary(20) NOT NULL COMMENT 'sha1(servicegroup.name + servicegroup.name ...)',
  host_id binary(20) NOT NULL COMMENT 'sha1(host.id)',

  name varchar(255) NOT NULL,
  name_ci varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  display_name varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,

  checkcommand varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'checkcommand.name',
  checkcommand_id binary(20) NOT NULL COMMENT 'checkcommand.id',

  max_check_attempts int(10) unsigned NOT NULL,

  check_period varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'timeperiod.name',
  check_period_id binary(20) DEFAULT NULL COMMENT 'timeperiod.id',

  check_timeout int(10) unsigned DEFAULT NULL,
  check_interval int(10) unsigned NOT NULL,
  check_retry_interval int(10) unsigned NOT NULL,

  active_checks_enabled enum('y','n') NOT NULL,
  passive_checks_enabled enum('y','n') NOT NULL,
  event_handler_enabled enum('y','n') NOT NULL,
  notifications_enabled enum('y','n') NOT NULL,

  flapping_enabled enum('y','n') NOT NULL,
  flapping_threshold_low float unsigned NOT NULL,
  flapping_threshold_high float unsigned NOT NULL,

  perfdata_enabled enum('y','n') NOT NULL,

  eventcommand varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'eventcommand.name',
  eventcommand_id binary(20) DEFAULT NULL COMMENT 'eventcommand.id',

  is_volatile enum('y','n') NOT NULL,

  action_url_id binary(20) DEFAULT NULL COMMENT 'action_url.id',
  notes_url_id binary(20) DEFAULT NULL COMMENT 'notes_url.id',
  notes text NOT NULL,
  icon_image_id binary(20) DEFAULT NULL COMMENT 'icon_image.id',
  icon_image_alt varchar(32) NOT NULL,

  zone varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'zone.name',
  zone_id binary(20) DEFAULT NULL COMMENT 'zone.id',

  command_endpoint varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'endpoint.name',
  command_endpoint_id binary(20) DEFAULT NULL COMMENT 'endpoint.id',

  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC;

CREATE TABLE servicegroup (
  id binary(20) NOT NULL COMMENT 'sha1(environment.name + name)',
  env_id binary(20) NOT NULL COMMENT 'sha1(environment.name)',
  name_checksum binary(20) NOT NULL COMMENT 'sha1(name)',
  properties_checksum binary(20) NOT NULL COMMENT 'sha1(all properties)',
  customvars_checksum binary(20) NOT NULL COMMENT 'sha1(servicegroup.vars)',

  name varchar(255) NOT NULL,
  name_ci varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  display_name varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,

  zone_id binary(20) DEFAULT NULL COMMENT 'zone.id',

  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC;

CREATE TABLE servicegroup_member (
  service_id binary(20) NOT NULL COMMENT 'service.id',
  servicegroup_id binary(20) NOT NULL COMMENT 'servicegroup.id',
  env_id binary(20) DEFAULT NULL COMMENT 'sha1(environment.name)',

  PRIMARY KEY (servicegroup_id,service_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC;

CREATE TABLE service_customvar (
  service_id binary(20) NOT NULL COMMENT 'service.id',
  customvar_id binary(20) NOT NULL COMMENT 'customvar.id',
  env_id binary(20) DEFAULT NULL COMMENT 'sha1(environment.name)',

  PRIMARY KEY (customvar_id, service_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC;

CREATE TABLE servicegroup_customvar (
  servicegroup_id binary(20) NOT NULL COMMENT 'servicegroup.id',
  customvar_id binary(20) NOT NULL COMMENT 'customvar.id',
  env_id binary(20) DEFAULT NULL COMMENT 'sha1(environment.name)',

  PRIMARY KEY (customvar_id, servicegroup_id)
) ENGINE=InnoDb ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_bin;

CREATE TABLE service_state (
  service_id binary(20) NOT NULL COMMENT 'service.id',
  env_id binary(20) NOT NULL COMMENT 'sha1(environment.name)',

  state_type enum('hard', 'soft') NOT NULL,
  soft_state tinyint(1) unsigned NOT NULL,
  hard_state tinyint(1) unsigned NOT NULL,
  attempt tinyint(1) unsigned NOT NULL,
  severity smallint unsigned NOT NULL,

  output text DEFAULT NULL,
  long_output text DEFAULT NULL,
  performance_data text DEFAULT NULL,
  check_commandline varchar(255) DEFAULT NULL,

  is_problem enum('y', 'n') NOT NULL,
  is_handled enum('y', 'n') NOT NULL,
  is_reachable enum('y', 'n') NOT NULL,
  is_flapping enum('y', 'n') NOT NULL,

  is_acknowledged enum('y', 'n', 'sticky') NOT NULL,
  acknowledgement_comment_id binary(20) DEFAULT NULL COMMENT 'comment.id',

  in_downtime enum('y', 'n') NOT NULL,

  execution_time bigint(20) unsigned DEFAULT NULL,
  latency bigint(20) unsigned DEFAULT NULL,
  timeout bigint(20) unsigned DEFAULT NULL,

  last_update bigint(20) unsigned NOT NULL,
  last_state_change bigint(20) unsigned NOT NULL,
  last_soft_state tinyint(1) unsigned NOT NULL,
  last_hard_state tinyint(1) unsigned NOT NULL,
  next_check bigint(20) unsigned NOT NULL,

  PRIMARY KEY (service_id)
) ENGINE=InnoDb ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_bin;