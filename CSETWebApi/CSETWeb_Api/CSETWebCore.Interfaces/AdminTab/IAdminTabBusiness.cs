//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Model.AdminTab;
using CSETWebCore.DataLayer.Model;

namespace CSETWebCore.Interfaces.AdminTab
{
    public interface IAdminTabBusiness
    {
        AdminTabData GetTabData(int assessmentId);
        AdminSaveResponse SaveData(int assessmentId, AdminSaveData save);
        FINANCIAL_HOURS CreateNewFinancialHours(int assessmentId, AdminSaveData save);
        void SaveDataAttribute(int assessmentId, AttributePair att);
    }
}