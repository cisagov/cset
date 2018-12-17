using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DataLayer;
using BusinessLogic.Models;
using CSETWeb_Api.BusinessLogic.Models;
using System.Data.Entity.Migrations;


namespace CSETWeb_Api.BusinessManagers
{
    /// <summary>
    /// 
    /// </summary>
    public class StandardBuilderManager
    {
        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public List<SetDetail> GetCustomSetList()
        {
            using (var db = new CSETWebEntities())
            {
                List<SetDetail> list = new List<SetDetail>();

                var s = db.SETS.Where(x => x.Is_Custom).ToList();
                foreach (SET set in s)
                {
                    SetDetail sr = new SetDetail
                    {
                        SetName = set.Set_Name,
                        FullName = set.Full_Name,
                        ShortName = set.Short_Name,
                        SetCategory = set.Set_Category_Id != null ? (int)set.Set_Category_Id : 0,
                        IsCustom = set.Is_Custom,
                        IsDisplayed = set.Is_Displayed,

                        Clonable = true,
                        Deletable = true
                    };

                    list.Add(sr);
                }

                return list;
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="setName"></param>
        public SetDetail GetSetDetail(string setName)
        {
            using (var db = new CSETWebEntities())
            {
                var dbSet = db.SETS.Where(x => x.Set_Name == setName).FirstOrDefault();

                SetDetail set = new SetDetail();

                // instantiate a Set and populate it
                if (dbSet == null || string.IsNullOrEmpty(dbSet.Set_Name))
                {
                    set.SetName = GenerateNewSetName();
                    set.SetCategory = 0;
                    set.IsCustom = true;
                    set.IsDisplayed = true;
                }
                else
                {
                    set.Description = dbSet.Standard_ToolTip;
                    set.FullName = dbSet.Full_Name;
                    set.SetName = dbSet.Set_Name;
                    set.SetCategory = dbSet.Set_Category_Id == null ? 0 : (int)dbSet.Set_Category_Id;
                    set.ShortName = dbSet.Short_Name;
                    set.IsCustom = dbSet.Is_Custom;
                    set.IsDisplayed = dbSet.Is_Displayed;
                }


                // include the set category values
                set.CategoryList = new List<SetCategory>();
                var setsCategories = db.SETS_CATEGORY.ToList();
                foreach (SETS_CATEGORY cat in setsCategories)
                {
                    set.CategoryList.Add(new SetCategory(cat.Set_Category_Id, cat.Set_Category_Name));
                }

                return set;
            }
        }


        /// <summary>
        /// 
        /// </summary>
        public SetDetail CloneSet(string setName)
        {
            // clone the SETS record
            using (var db = new CSETWebEntities())
            {
                var dbSet = db.SETS.Where(x => x.Set_Name == setName).FirstOrDefault();
                if (dbSet == null)
                {
                    return null;
                }

                var copy = (SET)db.Entry(dbSet).CurrentValues.ToObject();

                copy.Set_Name = GenerateNewSetName();
                copy.Full_Name = dbSet.Full_Name + " (copy)";

                db.SETS.AddOrUpdate(copy);
                db.SaveChanges();

                return GetSetDetail(copy.Set_Name);
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="set"></param>
        /// <returns></returns>
        public string SaveSetDetail(SetDetail set)
        {
            CSETWebEntities db = new CSETWebEntities();

            if (string.IsNullOrEmpty(set.FullName))
            {
                set.FullName = "(untitled set)";
            }

            if (string.IsNullOrEmpty(set.ShortName))
            {
                set.ShortName = "";
            }


            // Add or update the ASSESSMENT record
            var dbSet = new DataLayer.SET()
            {
                Set_Name = set.SetName,
                Full_Name = set.FullName,
                Short_Name = set.ShortName,
                Standard_ToolTip = set.Description,
                Set_Category_Id = set.SetCategory == 0 ? null : set.SetCategory,
                Is_Custom = set.IsCustom,
                Is_Displayed = set.IsDisplayed
            };

            db.SETS.AddOrUpdate(dbSet);
            db.SaveChanges();

            return dbSet.Set_Name;
        }

        private string GenerateNewSetName()
        {
            return "SET_" + DateTime.Now.ToString("yyyy-MM-dd.HH:mm:ss");
        }
    }
}
