
using System.IO;

namespace CSETWebCore.Business.Demographic.DemographicIO
{
	public class DemographicsExportFile
	{
		public DemographicsExportFile(string fileName, Stream fileContents)
		{
            FileName = fileName;
            FileContents = fileContents;
        }
        public string FileName { get; set; }

        public Stream FileContents { get; set; }
    }
}


