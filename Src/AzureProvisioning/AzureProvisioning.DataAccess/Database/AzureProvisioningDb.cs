using System.Data.Entity;
using AzureProvisioning.DataAccess.Mapping;
using AzureProvisioning.Entities;

namespace AzureProvisioning.DataAccess.Database
{
    public class AzureProvisioningDb: DbContext
    {
        public AzureProvisioningDb()
        {
            Configuration.LazyLoadingEnabled = false;
        }

        public AzureProvisioningDb(string connection):this()
        {
            Database.Connection.ConnectionString = connection;
        }

        public IDbSet<User> Users { get; set; }
        public IDbSet<Order> Orders { get; set; }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.Configurations.Add(new UserMapping());
            modelBuilder.Configurations.Add(new OrderMapping());
        }
    }
}
