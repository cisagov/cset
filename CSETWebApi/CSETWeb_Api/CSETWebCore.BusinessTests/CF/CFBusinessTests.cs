using Microsoft.VisualStudio.TestTools.UnitTesting;
using CSETWebCore.Business.CF;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CSETWebCore.DataLayer.Model;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;

namespace CSETWebCore.Business.CF.Tests
{
    [TestClass()]
    public class CFBusinessTests
    {
        private CSETContext context;

        [TestInitialize()]
        public void Initialize()
        {
            var builder = new ConfigurationBuilder()
               .AddJsonFile("appsettings.json", optional: false, reloadOnChange: true);
            var configuration = builder.Build();

            var optionsBuilder = new DbContextOptionsBuilder<CSETContext>();
            optionsBuilder.UseSqlServer(configuration.GetConnectionString("CSET_DB"));
            this.context = new CSETContext(configuration);

        }

        [TestMethod()]
        public async Task callBullTest()
        {
            try
            {
                
                CFBusiness cF = new CFBusiness(context);
                string url = await cF.callBull(3966, 1006);  
                Console.WriteLine(url);
                Assert.IsNotNull(url);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.ToString());
            }

            
        }
    }
}