namespace AzureProvisioning.Entities
{
    public class Order
    {
        public int OrderId { get; set; }
        public string OrderDetails { get; set; }
        public bool IsActive { get; set; }
    }
}
