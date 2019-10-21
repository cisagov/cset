using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AutoExportToJson
{
    class Program
    {
        static void Main(string[] args)
        {
            //var e = new ExportDbToJson();
            //e.Go();



            var i = new ImportDbFromJson();
            i.Go();
        }
    }
}
