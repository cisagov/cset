//////////////////////////////// 
// 
//   Copyright 2018 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSET_Main.Aggregation.Data.Levels
{
    class LevelsStringMap
    {
        public const string AVAILABLILTY_LEVEL_CNSSI = "Availability_Level";
        public const string CONFIDENCE_LEVEL_CNSSI = "Confidence_Level";
        public const string INTEGRITY_LEVEL_CNSSI = "Integrity_Level";

        public const string CONF_LEVEL_DOD = "Dod_Conf_Level";
        public const string MAC_LEVEL_DOD = "Dod_Mac_Level";

        public const string DOD_CONF_STANDARD = "DOD_Conf";
        public const string DOD_MIS_STANDARD = "DOD_Mis";

        public void SetValue(String level, String value, Standard_Model model)
        {
            switch (level)
            {
                case AVAILABLILTY_LEVEL_CNSSI:
                    model.Availability_Level = value;
                    break;
                case CONFIDENCE_LEVEL_CNSSI:
                    model.Confidence_Level = value;
                    break;
                case INTEGRITY_LEVEL_CNSSI:
                    model.Integrity_Level = value;
                    break;
                case CONF_LEVEL_DOD:
                    model.DOD_Confidentiality_Level = value;
                    break;
                case MAC_LEVEL_DOD:
                    model.DOD_MAC_Level = value;
                    break;
            }
        }
    }
}


