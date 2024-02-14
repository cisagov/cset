//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Model.Malcolm;
using System;
using System.Collections.Generic;

namespace CSETWebCore.Interfaces.Malcolm
{
    public interface IMalcolmBusiness
    {
        public List<MalcolmData> GetMalcolmJsonData(List<MalcolmData> list);
        public void VerificationAndValidation(int assessment_Id);
        public List<MALCOLM_ANSWERS> GetMalcolmAnswers(int assessId);
    }
}
