use master
exec sp_adddistributor @distributor = N'ILGTHREETEST', @password = N''
GO
exec sp_adddistributiondb @database = N'distribution', @data_folder = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Data', @log_folder = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Data', @log_file_size = 2, @min_distretention = 0, @max_distretention = 72, @history_retention = 48, @security_mode = 1
GO

use [distribution] 
if (not exists (select * from sysobjects where name = 'UIProperties' and type = 'U ')) 
	create table UIProperties(id int) 
if (exists (select * from ::fn_listextendedproperty('SnapshotFolder', 'user', 'dbo', 'table', 'UIProperties', null, null))) 
	EXEC sp_updateextendedproperty N'SnapshotFolder', N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\ReplData', 'user', dbo, 'table', 'UIProperties' 
else 
	EXEC sp_addextendedproperty N'SnapshotFolder', N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\ReplData', 'user', dbo, 'table', 'UIProperties'
GO

exec sp_adddistpublisher @publisher = N'ILGTHREETEST', @distribution_db = N'distribution', @security_mode = 1, @working_directory = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\ReplData', @trusted = N'false', @thirdparty_flag = 0, @publisher_type = N'MSSQLSERVER'
GO

use [AzureProvisioning]
exec sp_replicationdboption @dbname = N'AzureProvisioning', @optname = N'publish', @value = N'true'
GO
use [AzureProvisioning]
exec [AzureProvisioning].sys.sp_addlogreader_agent @job_login = N'ILGTHREETEST\Replication', @job_password = 'Super Secure Password1', @publisher_security_mode = 0, @publisher_login = N'Replication', @publisher_password = N'Super Secure Password1', @job_name = null
GO
-- Adding the transactional publication
use [AzureProvisioning]
exec sp_addpublication @publication = N'AzureProvisioning', @description = N'Transactional publication of database ''AzureProvisioning'' from Publisher ''ILGTHREETEST''.', @sync_method = N'concurrent', @retention = 0, @allow_push = N'true', @allow_pull = N'true', @allow_anonymous = N'false', @enabled_for_internet = N'false', @snapshot_in_defaultfolder = N'true', @compress_snapshot = N'false', @ftp_port = 21, @allow_subscription_copy = N'false', @add_to_active_directory = N'false', @repl_freq = N'continuous', @status = N'active', @independent_agent = N'true', @immediate_sync = N'false', @allow_sync_tran = N'false', @allow_queued_tran = N'false', @allow_dts = N'false', @replicate_ddl = 1, @allow_initialize_from_backup = N'true', @enabled_for_p2p = N'false', @enabled_for_het_sub = N'false'
GO


exec sp_addpublication_snapshot @publication = N'AzureProvisioning', @frequency_type = 1, @frequency_interval = 1, @frequency_relative_interval = 1, @frequency_recurrence_factor = 0, @frequency_subday = 8, @frequency_subday_interval = 1, @active_start_time_of_day = 0, @active_end_time_of_day = 235959, @active_start_date = 0, @active_end_date = 0, @job_login = N'ILGTHREETEST\Replication', @job_password = 'Super Secure Password1', @publisher_security_mode = 0, @publisher_login = N'Replication', @publisher_password = N'Super Secure Password1'


use [AzureProvisioning]
exec sp_addarticle @publication = N'AzureProvisioning', @article = N'Orders', @source_owner = N'dbo', @source_object = N'Orders', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Orders', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboOrders', @del_cmd = N'CALL sp_MSdel_dboOrders', @upd_cmd = N'SCALL sp_MSupd_dboOrders'
GO