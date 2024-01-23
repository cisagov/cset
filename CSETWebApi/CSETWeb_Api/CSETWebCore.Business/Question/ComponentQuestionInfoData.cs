//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;
using CSETWebCore.Model.Question;
using CSETWebCore.DataLayer.Model;

namespace CSETWebCore.Business.Question
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