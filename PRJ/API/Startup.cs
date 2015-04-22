using System.Web.Http;
using AzureProvisioning.API;
using AzureProvisioning.API.Configuration;
using AzureProvisioning.Services.OrganizationService;
using AzureProvisioning.Services.UserService;
using Microsoft.Owin;
using Microsoft.Practices.Unity;
using Owin;
using Unity.WebApi;

[assembly: OwinStartup(typeof(Startup))]

namespace AzureProvisioning.API
{
    public class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            HttpConfiguration config = new HttpConfiguration();

            UnityConfig.RegisterComponents(config);
            AuthConfig.ConfigureAuthentication(app);
            WebApiConfig.Register(config);
            app.UseCors(Microsoft.Owin.Cors.CorsOptions.AllowAll);
            app.UseWebApi(config);
        }
    }
}
