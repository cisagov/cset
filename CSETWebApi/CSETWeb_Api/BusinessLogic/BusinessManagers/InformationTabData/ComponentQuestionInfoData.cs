//////////////////////////////// 
// 
//   Copyright 2019 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSET_Main.Data.ControlData.DiagramSymbolPalette;
using DataLayerCore.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSET_Main.Questions.InformationTabData
{
    public class ComponentQuestionInfoData : BaseQuestionInfoData
    {
        public Dictionary<int, ComponentTypeSalData> DictionaryComponentTypes { get; set; }
        public Dictionary<int, COMPONENT_SYMBOLS> DictionaryComponentInfo { get; set; }


        public bool HasComponentsForTypeAtSal(int componentType, int salLevel)
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


