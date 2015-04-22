using System.Threading.Tasks;
using System.Web.Http;
using AzureProvisioning.Entities;
using AzureProvisioning.Services.OrganizationService;

namespace AzureProvisioning.API.Controllers
{
    [RoutePrefix("api/orders")]
    public class OrdersController : ApiController
    {
        private readonly IOrderService _orderService;

        public OrdersController(IOrderService orderService)
        {
            _orderService = orderService;
        }

        [Authorize]
        public async Task<IHttpActionResult> Get()
        {
            var orders = await _orderService.GetOrdersAsync();

            return Ok(orders);
        }

        [Authorize]
        public IHttpActionResult Post(Order order)
        {
            _orderService.AddOrder(order);

            return Ok();
        } 
    }
}
