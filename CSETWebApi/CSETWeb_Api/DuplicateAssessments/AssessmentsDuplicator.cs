using CSETWebCore.Business.AssessmentIO.Export;
using CSETWebCore.Business.AssessmentIO.Import;
using CSETWebCore.Business.Contact;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Helpers;
using CSETWebCore.Interfaces.Helpers;
using DocumentFormat.OpenXml.Office2010.Excel;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.VisualBasic;

namespace DuplicateAssessments
{
    internal class AssessmentsDuplicator
    {
        private static CSETContext? _context = null;

        public static IConfigurationRoot? Configuration { get; set; }


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


        /// <summary>
        /// 
        /// </summary>
        public async Task RunAssessmentsDuplicator()
        {
            //this is a version entry to full upgrader for all assessments
            String testToken = "eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJDU0VUX0FVRCIsImlzcyI6IkNTRVRfSVNTIiwiZXhwIjoxNzEzOTkwOTg0LCJ1c2VyaWQiOjIsImFjY2tleSI6bnVsbCwidHpvZmZzZXQiOiIzNjAiLCJzY29wZSI6IkNGIn0.bmDP2wMQaCTKhztzZ39KfddgCATBBiRAYncxM5yFBvg";
            ITokenManager tokenManager = new MockTokenManager(testToken, _context);
            IAssessmentUtil assessmentUtil = new AssessmentUtil(_context);
            IUtilities utilities = new MockUtilities();
            IImportManager importManager = new ImportManager(tokenManager, assessmentUtil, utilities, _context);
            ConversionBusiness conversionBusiness = new ConversionBusiness(assessmentUtil, tokenManager, _context, importManager);
            var m = _context.METRIC_COMPLETED_ENTRY.OrderBy(x => x.assessment_id).Select(x => x.assessment_id).ToList();
            //D0C19648-00F5-4215-AF2D-C7EBD75FC578
            foreach (int id in m)
            {
                try
                {
                    await conversionBusiness.ConvertEntryToMid(id);
                }
                catch (Exception ex)
                {
                    Console.WriteLine(ex.ToString());   
                }
            }
            var legacies = _context.ASSESSMENTS.Where(x=> x.GalleryItemGuid == new Guid("D0C19648-00F5-4215-AF2D-C7EBD75FC578")).Select(x => x.Assessment_Id).ToList();
            foreach(var id in legacies) 
            {
                if (conversionBusiness.IsLegacyCFFull(id))
                {
                    try
                    {
                        await conversionBusiness.ConvertLegacy(id);
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine(ex.ToString());
                    }
                }
            }
            
        }

    }
}
