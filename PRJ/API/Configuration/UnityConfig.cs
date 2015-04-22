using System.Web.Http;
using AzureProvisioning.Services.OrganizationService;
using AzureProvisioning.Services.UserService;
using Microsoft.Practices.Unity;
using Unity.WebApi;

namespace AzureProvisioning.API.Configuration
{
    public static class UnityConfig
    {
        public static void RegisterComponents(HttpConfiguration configuration)
        {
			var container = new UnityContainer();

            container.RegisterType<IUserService, UserService>();
            container.RegisterType<IOrderService, OrderService>();

            configuration.DependencyResolver = new UnityDependencyResolver(container);
        }
    }
}