//////////////////////////////// 
// 
//   Copyright 2019 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using BusinessLogic.Helpers;
using CSET_Main.Common.EnumHelper;


namespace CSET_Main.Questions.POCO
{
    public enum AnswerEnum
    {
        [StringAttr(Constants.YES)]
        YES,
        [StringAttr(Constants.NO)]
        NO,
       [StringAttr(Constants.NA)]
        NA,
       [StringAttr(Constants.ALTERNATE)]
        ALT,
       [StringAttr(Constants.UNANSWERED)]
       UNANSWERED
    }
}


