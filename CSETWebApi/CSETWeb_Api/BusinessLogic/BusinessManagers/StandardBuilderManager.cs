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


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        private string GenerateNewSetName()
        {
            return "SET_" + DateTime.Now.ToString("yyyy-MM-dd.HH:mm:ss");
        }


        /// <summary>
        /// 
        /// </summary>
        public List<QuestionDetail> GetQuestionsForSet(string setName)
        {
            using (var db = new CSETWebEntities())
            {
                //var dbSet = db.SETS.Where(x => x.Set_Name == setName).FirstOrDefault();
                List<NEW_QUESTION_SETS> dbQuestions = db.NEW_QUESTION_SETS.Where(x => x.Set_Name == setName).ToList();

                List<QuestionDetail> response = new List<QuestionDetail>();
                foreach (NEW_QUESTION_SETS nqs in dbQuestions)
                {
                    QuestionDetail q = new QuestionDetail();
                    q.QuestionID = nqs.NEW_QUESTION.Question_Id;
                    q.QuestionText = nqs.NEW_QUESTION.Simple_Question;
                    PopulateCategorySubcategory(nqs.NEW_QUESTION.Heading_Pair_Id, db, ref q.Category, ref q.Subcategory);
                    q.Level = nqs.NEW_QUESTION.UNIVERSAL_SAL_LEVEL1.Full_Name_Sal;
                    q.Title = GetTitle(nqs.NEW_QUESTION.Question_Id, db);

                    q.IsCustom = false;

                    response.Add(q);
                }

                return response;
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name=""></param>
        /// <returns></returns>
        private void PopulateCategorySubcategory(int headingPairId, CSETWebEntities db, ref string cat, ref string subcat)
        {
            var query = from h in db.UNIVERSAL_SUB_CATEGORY_HEADINGS
                        from h1 in db.QUESTION_GROUP_HEADING.Where(x => x.Question_Group_Heading_Id == h.Question_Group_Heading_Id)
                        from h2 in db.UNIVERSAL_SUB_CATEGORIES.Where(x => x.Universal_Sub_Category_Id == h.Universal_Sub_Category_Id)
                        where h.Heading_Pair_Id == headingPairId
                        select new { h1.Question_Group_Heading1, h2.Universal_Sub_Category };

            var result = query.FirstOrDefault();
            cat = result.Question_Group_Heading1;
            subcat = result.Universal_Sub_Category;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="questionId"></param>
        /// <param name="db"></param>
        /// <returns></returns>
        private string GetTitle(int questionId, CSETWebEntities db)
        {
            var query = from rqs in db.REQUIREMENT_QUESTIONS_SETS
                        from r in db.NEW_REQUIREMENT.Where(x => x.Requirement_Id == rqs.Requirement_Id)
                        where rqs.Question_Id == questionId
                        select r.Requirement_Title;

            if (query.FirstOrDefault() == null)
            {
                return string.Empty;
            }

            return query.FirstOrDefault();
        }


        /// <summary>
        /// Queries the database to see if there is already a question with this text.
        /// 
        /// Tech note:  If comparing hashes is preferable, QuestionHash is SHA1 encryption 
        /// of the first 8000 bytes of the question text.
        /// </summary>
        /// <param name="questionText"></param>
        /// <returns></returns>
        public bool ExistsQuestionText(string questionText)
        {
            using (var db = new CSETWebEntities())
            {
                return (db.NEW_QUESTION.Where(q => q.Simple_Question == questionText).Count() > 0);
            }
        }


        /// <summary>
        /// Creates a new custom question from the supplied text.
        /// </summary>
        /// <param name="request"></param>
        public void AddCustomQuestionToSet(SetQuestion request)
        {
            using (var db = new CSETWebEntities())
            {
                NEW_QUESTION q = new NEW_QUESTION();
                q.Simple_Question = request.NewQuestionText;

                // std_ref + std_ref_number must be unique
                q.Std_Ref = DateTime.Now.Millisecond.ToString();
                q.Std_Ref_Number = 0;

                q.Universal_Sal_Level = "L";
                q.Weight = 0;
                q.Original_Set_Name = request.SetName;

                int headingPairId = GetHeadingPairId(request.NewQuestionCategory, request.NewQuestionSubcategory);
                q.Heading_Pair_Id = headingPairId;

                db.NEW_QUESTION.Add(q);
                db.SaveChanges();


                NEW_QUESTION_SETS nqs = new NEW_QUESTION_SETS
                {
                    Question_Id = q.Question_Id,
                    Set_Name = request.SetName
                };

                db.NEW_QUESTION_SETS.AddOrUpdate(nqs);



                REQUIREMENT_QUESTIONS_SETS rqs = new REQUIREMENT_QUESTIONS_SETS
                {
                    Question_Id = q.Question_Id,
                    Set_Name = request.SetName,
                    Requirement_Id = 0
                };

                db.SaveChanges();
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        private int GetHeadingPairId(int catId, int subcatId)
        {
            using (var db = new CSETWebEntities())
            {
                var h = db.UNIVERSAL_SUB_CATEGORY_HEADINGS.Where(x => x.Question_Group_Heading_Id == catId
                        && x.Universal_Sub_Category_Id == subcatId).FirstOrDefault();

                if (h != null)
                {
                    return h.Heading_Pair_Id;
                }
            }

            return 0;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="request"></param>
        public void AddQuestionToSet(SetQuestion request)
        {
            using (var db = new CSETWebEntities())
            {
                NEW_QUESTION_SETS nqs = new NEW_QUESTION_SETS
                {
                    Question_Id = request.QuestionID,
                    Set_Name = request.SetName
                };

                db.NEW_QUESTION_SETS.AddOrUpdate(nqs);
                db.SaveChanges();
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="request"></param>
        public void RemoveQuestionFromSet(SetQuestion request)
        {
            using (var db = new CSETWebEntities())
            {
                var nqs = db.NEW_QUESTION_SETS.Where(x => x.Set_Name == request.SetName && x.Question_Id == request.QuestionID).FirstOrDefault();
                if (nqs == null)
                {
                    return;
                }

                db.NEW_QUESTION_SETS.Remove(nqs);
                db.SaveChanges();
            }
        }


        /// <summary>
        /// Returns a list of all Question Group Headings (Categories).
        /// Should we ignore categories that aren't paired with any subcategories
        /// in the UNIVERSAL_SUB_CATEGORY_HEADINGS table?
        /// </summary>
        public List<CategoryEntry> GetCategories()
        {
            List<CategoryEntry> response = new List<CategoryEntry>();

            using (var db = new CSETWebEntities())
            {
                var cats = from qgh in db.QUESTION_GROUP_HEADING
                           join usch in db.UNIVERSAL_SUB_CATEGORY_HEADINGS on qgh.Question_Group_Heading_Id equals usch.Question_Group_Heading_Id
                           where usch.Question_Group_Heading_Id > 0
                           select qgh;
                foreach (var c in cats.Distinct().ToList())
                {
                    CategoryEntry entry = new CategoryEntry
                    {
                        Text = c.Question_Group_Heading1,
                        ID = c.Question_Group_Heading_Id
                    };
                    response.Add(entry);
                }
            }

            return response;
        }


        /// <summary>
        /// Returns a list of all Subcategories for the specified Question Group Heading (Category).
        /// </summary>
        /// <returns></returns>
        public List<CategoryEntry> GetSubcategories(int categoryId)
        {
            List<CategoryEntry> response = new List<CategoryEntry>();

            using (var db = new CSETWebEntities())
            {
                var query = from usch in db.UNIVERSAL_SUB_CATEGORY_HEADINGS
                            from usc in db.UNIVERSAL_SUB_CATEGORIES.Where(x => x.Universal_Sub_Category_Id == usch.Universal_Sub_Category_Id)
                            where usch.Question_Group_Heading_Id == categoryId
                            select new CategoryEntry
                            {
                                ID = usc.Universal_Sub_Category_Id,
                                Text = usc.Universal_Sub_Category
                            };

                foreach (var s in query.ToList())
                {
                    CategoryEntry entry = new CategoryEntry();
                    entry.Text = s.Text;
                    entry.ID = s.ID;
                    response.Add(entry);
                }
            }

            return response;
        }
    }
}
