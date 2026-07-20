////////////////////////////////
//
//   Copyright 2026 Battelle Energy Alliance, LLC
//
//
////////////////////////////////
using CSETWebCore.Business.Demographic;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Model.Demographic;
using Microsoft.EntityFrameworkCore;

namespace CSETWebCore.Business.Tests.Demographic
{
    public class SectorManagementTests
    {
        [Fact]
        public void Save_WithNullSector_RemovesExistingSelection()
        {
            using var context = CreateContext();
            context.ASSESSMENT_SECTOR_SUBSECTOR.Add(new ASSESSMENT_SECTOR_SUBSECTOR
            {
                Assessment_Id = 1,
                SectorId = 1,
                Sequence = 1
            });
            context.SaveChanges();

            var manager = new SectorMultiManager(context);

            manager.Save(1, new SectorSubsector { SectorId = null, Sequence = 1 });

            Assert.Empty(context.ASSESSMENT_SECTOR_SUBSECTOR);
        }

        [Fact]
        public void Get_UpgradesLegacyDetailsSectorBeforeConvertingStorage()
        {
            using var context = CreateContext();
            context.SECTOR.AddRange(
                new SECTOR { SectorId = 10, SectorName = "Food and Agriculture", Is_NIPP = false },
                new SECTOR { SectorId = 17, SectorName = "Agriculture and Food", Is_NIPP = true });
            context.DETAILS_DEMOGRAPHICS.Add(new DETAILS_DEMOGRAPHICS
            {
                Assessment_Id = 1,
                DataItemName = "SECTOR",
                IntValue = 17
            });
            context.SaveChanges();

            var result = new SectorMultiManager(context).Get(1);

            var selection = Assert.Single(result);
            Assert.Equal(10, selection.SectorId);
            Assert.Null(selection.SubsectorId);
            Assert.Equal(10, Assert.Single(context.ASSESSMENT_SECTOR_SUBSECTOR).SectorId);
            Assert.DoesNotContain(context.DETAILS_DEMOGRAPHICS, x => x.DataItemName == "SECTOR");
            Assert.Contains(context.DETAILS_DEMOGRAPHICS,
                x => x.DataItemName == Constants.Constants.ACK_SECTOR_UPDATED_PPD21
                    && x.BoolValue == true);
        }

        [Fact]
        public void Save_WithLegacySector_ThrowsArgumentException()
        {
            using var context = CreateContext();
            context.SECTOR.Add(new SECTOR
            {
                SectorId = 17,
                SectorName = "Agriculture and Food",
                Is_NIPP = true
            });
            context.SaveChanges();

            var manager = new SectorMultiManager(context);

            var exception = Assert.Throws<ArgumentException>(() =>
                manager.Save(1, new SectorSubsector { SectorId = 17, Sequence = 1 }));

            Assert.Contains("sector is not supported", exception.Message);
            Assert.Empty(context.ASSESSMENT_SECTOR_SUBSECTOR);
        }

        [Fact]
        public void Save_WhenSectorChanges_IgnoresStaleSubsectorAndClearsIt()
        {
            using var context = CreateContext();
            context.SECTOR.AddRange(
                new SECTOR { SectorId = 1, SectorName = "Chemical", Is_NIPP = false },
                new SECTOR { SectorId = 2, SectorName = "Commercial Facilities", Is_NIPP = false });
            context.SECTOR_INDUSTRY.Add(new SECTOR_INDUSTRY
            {
                SectorId = 1,
                IndustryId = 100,
                IndustryName = "Old subsector",
                Is_NIPP = false
            });
            context.ASSESSMENT_SECTOR_SUBSECTOR.Add(new ASSESSMENT_SECTOR_SUBSECTOR
            {
                Assessment_Id = 1,
                SectorId = 1,
                IndustryId = 100,
                Sequence = 1
            });
            context.SaveChanges();

            var manager = new SectorMultiManager(context);

            manager.Save(1, new SectorSubsector
            {
                SectorId = 2,
                SubsectorId = 100,
                Sequence = 1
            });

            var selection = Assert.Single(context.ASSESSMENT_SECTOR_SUBSECTOR);
            Assert.Equal(2, selection.SectorId);
            Assert.Null(selection.IndustryId);
        }

        [Fact]
        public void Upgrade_TableSectorOnly_PreservesDetailsSubsector()
        {
            using var context = CreateContext();
            context.DETAILS_DEMOGRAPHICS.AddRange(
                new DETAILS_DEMOGRAPHICS
                {
                    Assessment_Id = 1,
                    DataItemName = "SECTOR",
                    IntValue = 1
                },
                new DETAILS_DEMOGRAPHICS
                {
                    Assessment_Id = 1,
                    DataItemName = "SUBSECTOR",
                    IntValue = 5
                });
            context.ASSESSMENT_SECTOR_SUBSECTOR.Add(new ASSESSMENT_SECTOR_SUBSECTOR
            {
                Assessment_Id = 1,
                SectorId = 17,
                IndustryId = 121,
                Sequence = 1
            });
            context.SaveChanges();

            var result = new SectorUpgradePpd21(context).UpgradeSector(1);

            Assert.True(result.Changed);
            Assert.Equal(10, Assert.Single(context.ASSESSMENT_SECTOR_SUBSECTOR).SectorId);
            Assert.Contains(context.DETAILS_DEMOGRAPHICS,
                x => x.DataItemName == "SUBSECTOR" && x.IntValue == 5);
        }

        [Fact]
        public void Upgrade_DetailsSector_ClearsItsLegacySubsector()
        {
            using var context = CreateContext();
            context.DETAILS_DEMOGRAPHICS.AddRange(
                new DETAILS_DEMOGRAPHICS
                {
                    Assessment_Id = 1,
                    DataItemName = "SECTOR",
                    IntValue = 17
                },
                new DETAILS_DEMOGRAPHICS
                {
                    Assessment_Id = 1,
                    DataItemName = "SUBSECTOR",
                    IntValue = 121
                });
            context.SaveChanges();

            var result = new SectorUpgradePpd21(context).UpgradeSector(1);

            Assert.True(result.Changed);
            Assert.Equal(10, context.DETAILS_DEMOGRAPHICS
                .Single(x => x.DataItemName == "SECTOR").IntValue);
            Assert.DoesNotContain(context.DETAILS_DEMOGRAPHICS,
                x => x.DataItemName == "SUBSECTOR");
        }

        private static CSETContext CreateContext()
        {
            var options = new DbContextOptionsBuilder<CsetwebContext>()
                .UseInMemoryDatabase(Guid.NewGuid().ToString())
                .Options;

            var context = new CSETContext(options);
            context.Database.EnsureCreated();
            return context;
        }
    }
}
