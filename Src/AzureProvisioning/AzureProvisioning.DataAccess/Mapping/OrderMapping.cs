using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;
using AzureProvisioning.Entities;

namespace AzureProvisioning.DataAccess.Mapping
{
    public class OrderMapping : EntityTypeConfiguration<Order>
    {
        public OrderMapping()
        {
            HasKey(o => o.OrderId);
            Property(o => o.OrderId)
                .HasDatabaseGeneratedOption(DatabaseGeneratedOption.Identity);

            Property(o => o.OrderId).HasColumnName("OrderId");
            Property(o => o.OrderDetails).HasColumnName("OrderDetails");
            Property(o => o.IsActive).HasColumnName("IsActive");

            ToTable("Orders", "dbo");
        }
    }
}
