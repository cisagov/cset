using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DataLayer;
using BusinessLogic.Models;
using CSETWeb_Api.BusinessLogic.Models;
using System.Data.Entity.Migrations;
using System.Text.RegularExpressions;



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
        public QuestionListResponse GetQuestionsForSet(string setName)
        {
            using (var db = new CSETWebEntities())
            {
                List<NEW_QUESTION_SETS> dbQuestions = db.NEW_QUESTION_SETS.Where(x => x.Set_Name == setName).ToList();

                List<QuestionDetail> response = new List<QuestionDetail>();
                foreach (NEW_QUESTION_SETS nqs in dbQuestions)
                {
                    QuestionDetail q = new QuestionDetail();
                    q.QuestionID = nqs.NEW_QUESTION.Question_Id;
                    q.QuestionText = nqs.NEW_QUESTION.Simple_Question;
                    PopulateCategorySubcategory(nqs.NEW_QUESTION.Heading_Pair_Id, db, ref q.Category, ref q.Subcategory);
                    q.Title = GetTitle(nqs.NEW_QUESTION.Question_Id, db);
                    q.IsCustom = nqs.SET.Is_Custom;


                    // Get the SAL levels for this question-set
                    var sals = db.NEW_QUESTION_LEVELS.Where(l => l.New_Question_Set_Id == nqs.New_Question_Set_Id).ToList();                               
                    foreach (NEW_QUESTION_LEVELS l in sals)
                    {
                        q.SalLevels.Add(l.Universal_Sal_Level);
                    }

                    q.IsCustom = false;

                    response.Add(q);
                }

                List<QuestionDetail> list = response.OrderBy(x => x.Category).ThenBy(x => x.Subcategory).ToList();

                QuestionListResponse ql = new QuestionListResponse();
                string currentCategory = string.Empty;
                QuestionListCategory cat = null;
                string currentSubcategory = string.Empty;
                QuestionListSubcategory subcat = null;
                foreach (QuestionDetail q in list)
                {
                    if (q.Category != currentCategory)
                    {
                        cat = new QuestionListCategory();
                        ql.Categories.Add(cat);
                        cat.CategoryName = q.Category;
                        currentCategory = q.Category;
                    }


                    if (q.Subcategory != currentSubcategory)
                    {
                        subcat = new QuestionListSubcategory();
                        cat.Subcategories.Add(subcat);
                        subcat.SubcategoryName = q.Subcategory;
                        currentSubcategory = q.Subcategory;
                    }

                    subcat.Questions.Add(q);                   
                }

                return ql;
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
            if (string.IsNullOrEmpty(request.NewQuestionText))
            {
                return;
            }

            using (var db = new CSETWebEntities())
            {
                NEW_QUESTION q = new NEW_QUESTION();
                q.Simple_Question = request.NewQuestionText;

                // TODO:  std_ref + std_ref_number must be unique
                q.Std_Ref = DateTime.Now.Millisecond.ToString();
                q.Std_Ref_Number = 0;

                q.Universal_Sal_Level = "L";
                q.Weight = 0;
                q.Original_Set_Name = request.SetName;
                q.Heading_Pair_Id = GetHeadingPairId(request.QuestionCategoryID, request.QuestionSubcategoryText);

                db.NEW_QUESTION.Add(q);
                db.SaveChanges();


                NEW_QUESTION_SETS nqs = new NEW_QUESTION_SETS
                {
                    Question_Id = q.Question_Id,
                    Set_Name = request.SetName
                };

                db.NEW_QUESTION_SETS.AddOrUpdate(nqs);


                foreach (string level in request.SalLevels)
                {
                    NEW_QUESTION_LEVELS nql = new NEW_QUESTION_LEVELS
                    {
                        New_Question_Set_Id = nqs.New_Question_Set_Id,
                        Universal_Sal_Level = level
                    };

                    db.NEW_QUESTION_LEVELS.Add(nql);
                }



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
        /// Finds a record for the category/subcategory combination.
        /// If there isn't a record, one is created.
        /// If the user typed a new subcategory name, a new subcategory is created
        /// and used for the combination.
        /// </summary>
        /// <returns></returns>
        private int GetHeadingPairId(int categoryId, string subcatText)
        {
            int subcatID = 0;

            using (var db = new CSETWebEntities())
            {
                var subcat = db.UNIVERSAL_SUB_CATEGORIES.Where(x => x.Universal_Sub_Category == subcatText).FirstOrDefault();
                if (subcat != null)
                {
                    subcatID = subcat.Universal_Sub_Category_Id;

                    var usch = db.UNIVERSAL_SUB_CATEGORY_HEADINGS.Where(x => x.Question_Group_Heading_Id == categoryId
                        && x.Universal_Sub_Category_Id == subcatID).FirstOrDefault();
                    if (usch != null)
                    {
                        return usch.Heading_Pair_Id;
                    }
                }
                else
                {
                    // The subcategory name is new -- create a new subcategory
                    UNIVERSAL_SUB_CATEGORIES sc = new UNIVERSAL_SUB_CATEGORIES
                    {
                        Universal_Sub_Category = subcatText
                    };
                    db.UNIVERSAL_SUB_CATEGORIES.Add(sc);
                    db.SaveChanges();

                    subcatID = sc.Universal_Sub_Category_Id;
                }


                // The USCH combination is not yet defined -- create a new USCH
                UNIVERSAL_SUB_CATEGORY_HEADINGS u1 = new UNIVERSAL_SUB_CATEGORY_HEADINGS
                {
                    Question_Group_Heading_Id = categoryId,
                    Universal_Sub_Category_Id = subcatID
                };
                db.UNIVERSAL_SUB_CATEGORY_HEADINGS.Add(u1);
                db.SaveChanges();

                return u1.Heading_Pair_Id;
            }
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




                // SAL levels
                var nqls = db.NEW_QUESTION_LEVELS.Where(l => l.New_Question_Set_Id == nqs.New_Question_Set_Id);
                foreach (NEW_QUESTION_LEVELS l in nqls)
                {
                    db.NEW_QUESTION_LEVELS.Remove(l);
                }
                db.SaveChanges();

                foreach (string l in request.SalLevels)
                {
                    NEW_QUESTION_LEVELS nql = new NEW_QUESTION_LEVELS
                    {
                        New_Question_Set_Id = nqs.New_Question_Set_Id,
                        Universal_Sal_Level = l
                    };

                    db.NEW_QUESTION_LEVELS.Add(nql);
                }
                db.SaveChanges();


                //REQUIREMENT_QUESTIONS_SETS rqs = new REQUIREMENT_QUESTIONS_SETS
                //{
                //    Question_Id = request.QuestionID,
                //    Set_Name = request.SetName,
                //    Requirement_Id = 0
                //};

                //db.SaveChanges();
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
        public CategoriesAndSubcategories GetCategoriesAndSubcategories()
        {
            CategoriesAndSubcategories response = new CategoriesAndSubcategories();
            List<CategoryEntry> categoryList = new List<CategoryEntry>();

            using (var db = new CSETWebEntities())
            {
                var categories = db.QUESTION_GROUP_HEADING.ToList();
                foreach (var c in categories)
                {
                    CategoryEntry entry = new CategoryEntry
                    {
                        Text = c.Question_Group_Heading1,
                        ID = c.Question_Group_Heading_Id
                    };
                    categoryList.Add(entry);
                }

                response.Categories = categoryList;


                List<CategoryEntry> subcategoryList = new List<CategoryEntry>();

                var subcategories = db.UNIVERSAL_SUB_CATEGORIES.ToList();
                foreach (var s in subcategories)
                {
                    CategoryEntry entry = new CategoryEntry
                    {
                        Text = s.Universal_Sub_Category,
                        ID = s.Universal_Sub_Category_Id
                    };
                    subcategoryList.Add(entry);
                }

                response.Subcategories = subcategoryList;
            }

            return response;
        }


        /// <summary>
        /// Find all questions based on the supplied search terms.  
        /// Exclude any questions that are already attached to the Set.
        /// </summary>
        /// <param name="questionText"></param>
        /// <returns></returns>
        public List<QuestionDetail> SearchQuestions(QuestionSearch searchParms)
        {
            List<QuestionDetail> candidateQuestions = new List<QuestionDetail>();

            using (var db = new CSETWebEntities())
            {
                // Build a list of all questionIDs that are currently in the set
                List<int> includedQuestions = db.NEW_QUESTION_SETS.Where(x => x.Set_Name == searchParms.SetName)
                    .Select(q => q.Question_Id).ToList();


                // First, look for an exact string match within the question
                var hits = from q in db.NEW_QUESTION
                           join usch in db.UNIVERSAL_SUB_CATEGORY_HEADINGS on q.Heading_Pair_Id equals usch.Heading_Pair_Id
                           join cat in db.QUESTION_GROUP_HEADING on usch.Question_Group_Heading_Id equals cat.Question_Group_Heading_Id
                           join subcat in db.UNIVERSAL_SUB_CATEGORIES on usch.Universal_Sub_Category_Id equals subcat.Universal_Sub_Category_Id
                           where q.Simple_Question.Contains(searchParms.SearchTerms)
                           select new { q, cat, subcat };

                foreach (var hit in hits.ToList())
                {
                    if (!includedQuestions.Contains(hit.q.Question_Id) && !EncryptedQuestionText(hit.q.Simple_Question))
                    {
                        QuestionDetail candidate = new QuestionDetail
                        {
                            QuestionID = hit.q.Question_Id,
                            QuestionText = QuestionsManager.FormatLineBreaks(hit.q.Simple_Question),
                            Category = hit.cat.Question_Group_Heading1,
                            Subcategory = hit.subcat.Universal_Sub_Category,
                        };

                        // Get the default SAL levels as defined in the question's original set
                        var sals = from nqs in db.NEW_QUESTION_SETS
                                   join nql in db.NEW_QUESTION_LEVELS on nqs.New_Question_Set_Id equals nql.New_Question_Set_Id
                                   where nqs.Set_Name == hit.q.Original_Set_Name && nqs.Question_Id == hit.q.Question_Id
                                   select nql.Universal_Sal_Level;

                        foreach (string s in sals.ToList())
                        {
                            candidate.SalLevels.Add(s);
                        }

                        candidateQuestions.Add(candidate);
                            
                    }
                }


                // Then, include a multi-part LIKE search with the supplied words (search terms)
                StringBuilder sbWhereClause = new StringBuilder();

                List<string> searchTerms = new List<string>();

                // pull out any quoted literals as a single term
                string pattern = "\"(.*?)\"";
                MatchCollection m = Regex.Matches(searchParms.SearchTerms, pattern, RegexOptions.IgnoreCase);
                foreach (Match match in m)
                {
                    searchTerms.Add(match.Value.Replace("\"", ""));
                }

                // remove quoted literals so we can split the rest into words
                searchParms.SearchTerms = Regex.Replace(searchParms.SearchTerms, pattern, "");

                searchTerms.AddRange(new List<string>(searchParms.SearchTerms.Split(' ')));
                foreach (string term in searchTerms)
                {
                    if (term != "")
                    {
                        sbWhereClause.AppendFormat("[Simple_Question] like '%{0}%' and ", term.Replace('*', '%'));
                    }
                }

                string whereClause = sbWhereClause.ToString();
                whereClause = whereClause.Substring(0, whereClause.Length - 5);

                var hits2 = db.NEW_QUESTION.SqlQuery("SELECT * FROM [NEW_QUESTION] where " + whereClause).ToList();

                var hits3 = from q in hits2
                           join usch in db.UNIVERSAL_SUB_CATEGORY_HEADINGS on q.Heading_Pair_Id equals usch.Heading_Pair_Id
                           join cat in db.QUESTION_GROUP_HEADING on usch.Question_Group_Heading_Id equals cat.Question_Group_Heading_Id
                           join subcat in db.UNIVERSAL_SUB_CATEGORIES on usch.Universal_Sub_Category_Id equals subcat.Universal_Sub_Category_Id
                           where q.Simple_Question.Contains(searchParms.SearchTerms)
                           select new { q, cat, subcat };

                foreach (var hit in hits3)
                {
                    if (!candidateQuestions.Exists(q => q.QuestionID == hit.q.Question_Id))
                    {
                        if (!includedQuestions.Contains(hit.q.Question_Id) && !EncryptedQuestionText(hit.q.Simple_Question))
                        {
                            candidateQuestions.Add(new QuestionDetail
                            {
                                QuestionID = hit.q.Question_Id,
                                QuestionText = QuestionsManager.FormatLineBreaks(hit.q.Simple_Question),
                                Category = hit.cat.Question_Group_Heading1,
                                Subcategory = hit.subcat.Universal_Sub_Category
                            });
                        }
                    }
                }
            }

            return candidateQuestions;
        }


        /// <summary>
        /// Sets or removes a single SAL level for a question in a set.
        /// </summary>
        /// <param name="salParms"></param>
        public void SetQuestionSalLevel(SalParms salParms)
        {
            using (var db = new CSETWebEntities())
            {
                NEW_QUESTION_SETS nqs = db.NEW_QUESTION_SETS.Where(x => x.Question_Id == salParms.QuestionID && x.Set_Name == salParms.SetName).FirstOrDefault();

                NEW_QUESTION_LEVELS nql = db.NEW_QUESTION_LEVELS.Where(x => 
                    x.New_Question_Set_Id == nqs.New_Question_Set_Id
                    && x.Universal_Sal_Level == salParms.Level).FirstOrDefault();

                if (salParms.State)
                {
                    // add the level if it doesn't exist
                    if (nql == null)
                    {
                        nql = new NEW_QUESTION_LEVELS() {
                            New_Question_Set_Id = nqs.New_Question_Set_Id,
                            Universal_Sal_Level = salParms.Level
                        };
                        db.NEW_QUESTION_LEVELS.AddOrUpdate(nql);
                        db.SaveChanges();
                    }
                }
                else
                {
                    // remove the level
                    if (nql != null)
                    {
                        db.NEW_QUESTION_LEVELS.Remove(nql);
                        db.SaveChanges();
                    }
                }
            }
        }


        /// <summary>
        /// Try to determine if this an encrypted question.
        /// </summary>
        /// <param name="text"></param>
        /// <returns></returns>
        private bool EncryptedQuestionText(string text)
        {
            if (!text.Contains(" ") && text.Length > 10)
            {
                return true;
            }

            return false;
        }
    }
}
