using System.Data.Entity;
using System.Linq;
using System.Threading.Tasks;
using AzureProvisioning.DataAccess.Database;
using AzureProvisioning.Entities;

namespace AzureProvisioning.Services.UserService
{
    public class UserService: IUserService
    {
        public User ValidateUser(string userName, string password)
        {
            using (var dbContext = new AzureProvisioningDb())
            {
                var user =
                    dbContext.Users.FirstOrDefault(u => u.UserName == userName && u.Password == password);

                return user;
            }
        }
        public async Task<User> ValidateUserAsync(string userName, string password)
        {
            using (var dbContext = new AzureProvisioningDb())
            {
                var user =
                    await dbContext.Users.FirstOrDefaultAsync(u => u.UserName == userName && u.Password == password);

                return user;
            }
        }
    }
}
