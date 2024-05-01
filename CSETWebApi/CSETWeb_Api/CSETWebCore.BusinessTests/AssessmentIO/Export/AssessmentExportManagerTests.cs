using Microsoft.VisualStudio.TestTools.UnitTesting;
using CSETWebCore.Business.AssessmentIO.Export;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CSETWebCore.DataLayer.Model;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;

namespace CSETWebCore.Business.AssessmentIO.Export.Tests
{
    [TestClass()]
    public class AssessmentExportManagerTests
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
        public void GetAnswerProfilesTest()
        {
            AssessmentExportManager exportManager = new AssessmentExportManager(context);
            
        }
    }
}