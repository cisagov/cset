//////////////////////////////// 
// 
//   Copyright 2020 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Drawing;
using System.Runtime.Serialization;
using System.Runtime.Remoting.Lifetime;

namespace CSET_Main.ReportEngine.Contract
{
    
    public class StandardImage
    {

        private Image standardChartImage;
        

        public Image StandardChartImage
        {
            get { return standardChartImage; }
            set { standardChartImage = value;       
            }
        }

        private string standardName;
        
        public string StandardName
        {
            get { return standardName; }
            set { standardName = value; }
        }



        public byte[] StandardChartBytes { get; set; }
    }
}


