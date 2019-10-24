using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWeb_Api.BusinessLogic.ImportAssessment
{
    interface ICSETJSONFileUpgrade
    {
        string ExecuteUpgrade(string json);

        System.Version GetVersion();        
    }
}
