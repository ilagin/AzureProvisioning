DECLARE @Result INT
DECLARE @Path nvarchar(50) = N'E:\PRJ\new.bak'
EXEC master.dbo.xp_fileexist @Path, @Result OUTPUT

IF @Result = 0 
BEGIN
	SET @Path = N'F:\PRJ\new.bak'
END

DECLARE @publication AS sysname;
DECLARE @subscriber AS sysname;
DECLARE @subscriptionDB AS sysname;
SET @publication = N'AzureProvisioning';
SET @subscriber = N'10.0.0.7';
SET @subscriptionDB = N'AzureProvisioning';

USE [AzureProvisioning]
EXEC sp_addsubscription
@publication = @publication,
@subscriber = @subscriber,
@destination_db = @subscriptionDB,
@subscription_type = N'push',
@sync_type = N'initialize with backup',
@backupdevicetype = N'disk',
@backupdevicename = @Path

EXEC sp_addpushsubscription_agent 
@publication = @publication, 
@subscriber = @subscriber, 
@subscriber_db = @subscriptionDB, 
@job_login = 'ILGTHREETEST\Replication', 
@job_password = 'Super Secure Password1';

USE [AzureProvisioning]
EXEC sp_changedbowner 'Replication'