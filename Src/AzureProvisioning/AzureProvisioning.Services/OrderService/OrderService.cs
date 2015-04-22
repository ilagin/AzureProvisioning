using System.Collections.Generic;
using System.Configuration;
using System.Data.Entity;
using System.Linq;
using System.Threading.Tasks;
using AzureProvisioning.DataAccess.Database;
using AzureProvisioning.Entities;

namespace AzureProvisioning.Services.OrderService
{
    public class OrderService: IOrderService
    {
        public IEnumerable<Order> GetOrders()
        {
            var replicaConnection = ConfigurationManager.ConnectionStrings["ReplicaConnection"].ConnectionString;

            using (var dbContext = new AzureProvisioningDb(replicaConnection))
            {
                var districts =
                    dbContext.Orders.ToList();

                return districts;
            }
        }

        public async Task<IEnumerable<Order>> GetOrdersAsync()
        {
            var replicaConnection = ConfigurationManager.ConnectionStrings["ReplicaConnection"].ConnectionString;

            using (var dbContext = new AzureProvisioningDb(replicaConnection))
            {
                var districts =
                    await dbContext.Orders.ToListAsync();

                return districts;
            }
        }

        public async void AddOrderAsync(Order order)
        {
            using (var dbContext = new AzureProvisioningDb())
            {
                dbContext.Orders.Add(order);
                await dbContext.SaveChangesAsync();
            }
        }

        public void AddOrder(Order order)
        {
            using (var dbContext = new AzureProvisioningDb())
            {
                dbContext.Orders.Add(order);
                dbContext.SaveChanges();
            }
        }
    }
}
