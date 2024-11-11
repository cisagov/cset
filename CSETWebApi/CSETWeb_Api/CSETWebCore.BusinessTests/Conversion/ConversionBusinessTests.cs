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
using DocumentFormat.OpenXml.Spreadsheet;

namespace CSETWebCore.Business.Contact.Tests
{
    [TestClass()]
    public class ConversionBusinessTests
    {
        private CSETContext? context;

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


        [TestMethod(),Timeout(1200000)]
        public void ConversionBusinessTest()
        {

            /**
             * Get all the entry assessments 
             * for each assessment convert it to 
             * while (the assessment is not full) then keep upgrading it
             *  if the assessment is entry then convert to mid
             *  if the assessment is mid then convert to full            
             */

            var db = this.context;

            if (db == null)
            {
                throw new Exception("Database context is null");
            }

            IAssessmentUtil util = new TestAssessmentUtil();
            ConversionBusiness conversionBusiness = new ConversionBusiness(db, util);
            
            List<int> ids = db.ASSESSMENTS.Select(x => x.Assessment_Id).ToList();

            foreach (int id in ids)
            {
                if (conversionBusiness.IsEntryCF(id))
                {
                    try
                    {
                        conversionBusiness.ConvertEntryToMid(id);
                    }
                    catch (Exception ex)
                    {
                        Assert.Fail(ex.Message);
                    }
                    var dd =  db.DETAILS_DEMOGRAPHICS.Where(x => x.Assessment_Id == id && x.DataItemName == "FORMER-CF-ENTRY").FirstOrDefault();
                    if (dd != null)
                    {
                        Assert.IsTrue(dd.StringValue.ToLower()=="true");
                    }
                        
                    
                }
                if (conversionBusiness.IsMidCF(id))
                {
                    try
                    {
                        conversionBusiness.ConvertMidToFull(id);
                    }
                    catch (Exception ex)
                    {
                        Assert.Fail(ex.Message);
                    }
                    var dd = db.DETAILS_DEMOGRAPHICS.Where(x => x.Assessment_Id == id && x.DataItemName == "FORMER-CF-MID").FirstOrDefault();
                    if (dd != null)
                        Assert.IsTrue(dd.StringValue.ToLower() == "true");
                }
            }
            
        }


        [TestMethod()]
        public void IsEntryCFTest()
        {
            var db = this.context;

            if (db == null)
            {
                throw new Exception("Database context is null");
            }

            IAssessmentUtil util = new TestAssessmentUtil();
            ConversionBusiness conversionBusiness = new ConversionBusiness(db, util);
            var mm = db.MATURITY_MODELS.FirstOrDefault();
            List<int> ids = db.ASSESSMENTS.Select(x => x.Assessment_Id).ToList();
            List<CFEntry> entries = conversionBusiness.IsEntryCF(ids);
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