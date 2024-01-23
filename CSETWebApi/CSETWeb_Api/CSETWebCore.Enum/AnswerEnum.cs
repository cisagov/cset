//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Enum.EnumHelper;
namespace CSETWebCore.Enum
{
    public enum AnswerEnum
    {
        [StringAttr(Constants.Constants.YES)]
        YES,
        [StringAttr(Constants.Constants.NO)]
        NO,
        [StringAttr(Constants.Constants.NA)]
        NA,
        [StringAttr(Constants.Constants.ALTERNATE)]
        ALT,
        [StringAttr(Constants.Constants.UNANSWERED)]
        UNANSWERED
    }
}