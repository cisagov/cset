//////////////////////////////// 
// 
//   Copyright 2018 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSET_Main.Data.ControlData.DiagramSymbolPalette;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSET_Main.Questions.InformationTabData
{
    public class ComponentQuestionInfoData:BaseQuestionInfoData
    {
        public Dictionary<String, ComponentTypeSalData> DictionaryComponentTypes { get; set; }
        public Dictionary<String, SymbolComponentInfoData> DictionaryComponentInfo { get; set; }


        public bool HasComponentsForTypeAtSal(String componentType, int salLevel)
        {
            ComponentTypeSalData data;
            if (DictionaryComponentTypes.TryGetValue(componentType, out data))
            {
                if (data.HasComponentAtSALLevels(salLevel))
                {
                    return true;
                }
            }

            return false;
        }

        

    }
}


