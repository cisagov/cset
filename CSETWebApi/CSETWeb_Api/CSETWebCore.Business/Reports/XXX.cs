using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using System.Reflection;
// using ReportGenerator.Pages;

namespace CSETWebCore.Business.Reports
{
    public class XXX
    {


        public string Go()
        {
            //var g = new Attempt1Model();
            //var h = g.ToString();

            //return h;

            return "";
        }




        public string Go2()
        {

            var assembly = Assembly.GetExecutingAssembly();
            var resourceName = "CSETWebCore.Business.Reports.TextFile1.html";

            using (Stream stream = assembly.GetManifestResourceStream(resourceName))
            using (StreamReader reader = new StreamReader(stream))
            {
                string result = reader.ReadToEnd();

                return result;

            }


        }





        public string BuildHeatMap(string json)
        {
            return "";
        }

    }
}
