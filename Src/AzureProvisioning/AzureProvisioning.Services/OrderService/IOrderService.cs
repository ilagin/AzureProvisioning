using System.Collections.Generic;
using System.Threading.Tasks;
using AzureProvisioning.Entities;

namespace AzureProvisioning.Services.OrderService
{
    public interface IOrderService
    {
        IEnumerable<Order> GetOrders();
        Task<IEnumerable<Order>> GetOrdersAsync();
        void AddOrderAsync(Order order);
        void AddOrder(Order order);
    }
}
