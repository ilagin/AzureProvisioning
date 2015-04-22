using System.Threading.Tasks;
using AzureProvisioning.Entities;

namespace AzureProvisioning.Services.UserService
{
    public interface IUserService
    {
        User ValidateUser(string userName, string password);
        Task<User> ValidateUserAsync(string userName, string password);
    }
}
