-- Flarum Database Initialization Script

-- Database creation (already created via environment variables)
-- CREATE DATABASE IF NOT EXISTS flarum CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- User creation (already created via environment variables)
-- CREATE USER IF NOT EXISTS 'flarum'@'%' IDENTIFIED BY 'flarum_password';
-- GRANT ALL PRIVILEGES ON flarum.* TO 'flarum'@'%';

-- Additional settings for Flarum
SET GLOBAL innodb_file_per_table = 1;
SET GLOBAL innodb_buffer_pool_size = 256*1024*1024;

-- Create view for performance monitoring
CREATE OR REPLACE VIEW performance_schema.global_status_summary AS
SELECT 
    VARIABLE_NAME,
    VARIABLE_VALUE
FROM performance_schema.global_status
WHERE VARIABLE_NAME IN (
    'Innodb_buffer_pool_read_requests',
    'Innodb_buffer_pool_reads',
    'Innodb_buffer_pool_pages_data',
    'Innodb_buffer_pool_pages_total',
    'Threads_connected',
    'Threads_running',
    'Questions',
    'Queries'
);

-- Settings for Flarum table optimization
SET GLOBAL innodb_adaptive_hash_index = 1;
SET GLOBAL innodb_adaptive_flushing = 1;
SET GLOBAL innodb_adaptive_flushing_lwm = 10;
SET GLOBAL innodb_adaptive_hash_index = 1;

-- Log settings
SET GLOBAL slow_query_log = 'ON';
SET GLOBAL long_query_time = 2;
SET GLOBAL log_queries_not_using_indexes = 'ON';

-- Connection optimization
SET GLOBAL max_connections = 100;
SET GLOBAL max_connect_errors = 1000;
SET GLOBAL connect_timeout = 10;
SET GLOBAL wait_timeout = 28800;
SET GLOBAL interactive_timeout = 28800;

-- Refresh privileges
FLUSH PRIVILEGES;

-- Initialization completion log
INSERT INTO mysql.general_log (event_time, user_host, thread_id, server_id, command_type, argument) 
VALUES (NOW(), 'init', 1, 1, 'Query', 'Flarum database initialization completed');
