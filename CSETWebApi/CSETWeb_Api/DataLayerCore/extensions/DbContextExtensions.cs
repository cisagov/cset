using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.SqlServer;

namespace DataLayerCore.Model
{
    public static class DbContextExtensions
    {
        public static string GetSqlServerTableName<TEntity>(this DbContext context) where TEntity : class, new()
        {
            var metaData = context.Model
                .FindEntityType(typeof(TEntity).FullName);
            
            return $"{metaData.GetSchema()}.{metaData.GetTableName()}";
        }
    }
}
