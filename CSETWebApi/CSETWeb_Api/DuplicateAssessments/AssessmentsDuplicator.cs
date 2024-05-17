using CSETWebCore.Business.AssessmentIO.Export;
using CSETWebCore.Business.AssessmentIO.Import;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Helpers;
using CSETWebCore.Interfaces.Helpers;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace DuplicateAssessments
{
    internal class AssessmentsDuplicator
    {
        private static CSETContext _context = null;
        public static IConfigurationRoot Configuration { get; set; }

        /// <summary>
        /// A tool that utilizes the api's of CSETWebCore to duplicate assessments.
        /// </summary>
        /// <param name="args"></param>
        static async Task Main(string[] args)
        {
            var builder = new ConfigurationBuilder()
               .SetBasePath(Directory.GetCurrentDirectory()) // <== compile failing here
               .AddJsonFile("appsettings.json");
            Configuration = builder.Build();

            // Setup services
            var services = new ServiceCollection();
            services.AddDbContext<CSETContext>(options =>
                options.UseSqlServer(Configuration.GetConnectionString("DefaultConnection")));

            //var optionsBuilder = new DbContextOptionsBuilder<CsetwebContext>();
            //optionsBuilder.UseSqlServer(Configuration.GetConnectionString("DefaultConnection"));
            _context = new CSETContext(Configuration);
            
            AssessmentsDuplicator duper = new AssessmentsDuplicator();
            await duper.RunAssessmentsDuplicator();
        }

        public async Task RunAssessmentsDuplicator()
        {
           

            AssessmentExportManager exportManager = new AssessmentExportManager(_context);

            Guid[] guidsToExport = _context.ASSESSMENTS                
                //.Where(x=> x.Assessment_Id ==571)
                .Select(a => a.Assessment_GUID).ToArray();
            //comment out the below line to no longer debug
            //guidsToExport = new Guid[] { new Guid("F2776CC4-0FBA-4C15-A845-305FC4A70082") };
            MemoryStream assessmentsExportArchive = exportManager.BulkExportAssessments(guidsToExport, "dup");
            String testToken = "eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJDU0VUX0FVRCIsImlzcyI6IkNTRVRfSVNTIiwiZXhwIjoxNzEzOTkwOTg0LCJ1c2VyaWQiOjIsImFjY2tleSI6bnVsbCwidHpvZmZzZXQiOiIzNjAiLCJzY29wZSI6IkNGIn0.bmDP2wMQaCTKhztzZ39KfddgCATBBiRAYncxM5yFBvg";
            ITokenManager tokenManager = new MockTokenManager(testToken, _context);
            IAssessmentUtil assessmentUtil = new AssessmentUtil(_context);
            IUtilities utilities = new MockUtilities();

            assessmentsExportArchive.Seek(0, SeekOrigin.Begin);

            ImportManager importManager = new ImportManager(tokenManager, assessmentUtil,utilities, _context);
            await importManager.BulkImportAssessments(assessmentsExportArchive, false);
        }

    }

    
}
