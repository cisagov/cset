using Microsoft.VisualStudio.TestTools.UnitTesting;
using CSETWebCore.Api.Controllers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CSETWebCore.DataLayer.Model;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;

namespace CSETWebCore.Api.Controllers.Tests
{
    [TestClass()]
    public class CustomExcelExportTests
    {
        private CSETContext? context;

        [TestInitialize()]
        public void Initialize()
        {
            var builder = new ConfigurationBuilder()
               .AddJsonFile("appsettings.json", optional: false, reloadOnChange: true);
            var configuration = builder.Build();
            this.context = new CSETContext(configuration);
            string sql = context.Database.GetConnectionString();
            Assert.IsNotNull(sql);


        }

        [TestMethod()]
        public async Task ExportExcelTestAsync()
        {
            CustomExcelExport export = new CustomExcelExport(this.context);
            var test = await export.ExportExcel(1);
        }
    }
}