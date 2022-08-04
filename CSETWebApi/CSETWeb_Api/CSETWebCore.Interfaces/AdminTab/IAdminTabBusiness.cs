using CSETWebCore.Model.AdminTab;
using CSETWebCore.DataLayer.Model;
using System.Threading.Tasks;

namespace CSETWebCore.Interfaces.AdminTab
{
    public interface IAdminTabBusiness
    {
        Task<AdminTabData> GetTabData(int assessmentId);
        Task<AdminSaveResponse> SaveData(int assessmentId, AdminSaveData save);
        FINANCIAL_HOURS CreateNewFinancialHours(int assessmentId, AdminSaveData save);
        Task SaveDataAttribute(int assessmentId, AttributePair att);
    }
}