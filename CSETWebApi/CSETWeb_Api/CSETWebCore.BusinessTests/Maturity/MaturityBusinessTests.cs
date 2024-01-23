//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using Microsoft.VisualStudio.TestTools.UnitTesting;
using CSETWebCore.Business.Maturity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Extensions.Configuration;
using Microsoft.EntityFrameworkCore;
using CSETWebCore.DataLayer.Model;

namespace CSETWebCore.Business.Maturity.Tests
{
    [TestClass()]
    public class MaturityBusinessTests
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

        [TestMethod()]
        public void Get_LevelScoresByGroupTest()
        {
            MaturityBusiness maturityBusiness = new MaturityBusiness(this.context, null, null);
            maturityBusiness.Get_LevelScoresByGroup(2, 8);
        }
    }
}