using Microsoft.VisualStudio.TestTools.UnitTesting;
using CSETWebCore.Business.Contact;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CSETWebCore.Helpers;
using CSETWebCore.DataLayer.Model;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using CSETWebCore.Interfaces.Helpers;

namespace CSETWebCore.Business.Contact.Tests
{
    [TestClass()]
    public class ConversionBusinessTests
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
        public void IsEntryCFTest()
        {
            var db = this.context;
            IAssessmentUtil util = new TestAssessmentUtil();
            ConversionBusiness conversionBusiness = new ConversionBusiness(db,util);
            var mm = db.MATURITY_MODELS.FirstOrDefault();
            List<int> ids =  db.ASSESSMENTS.Select(x=> x.Assessment_Id).ToList();
            List<CFEntry> entries =  conversionBusiness.IsEntryCF(ids);
            Assert.IsTrue(entries.Count > 0);

        }
    }

    internal class TestAssessmentUtil : IAssessmentUtil
    {
        public void TouchAssessment(int assessmentId)
        {
         
        }
    }
}