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

                // TODO: remove the NERC from this condition!!!
                var s = db.SETS.Where(x => x.Is_Custom || x.Set_Name == "NERC_CIP_R6").ToList();
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
                copy.Is_Custom = true;

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
            return "SET." + DateTime.Now.ToString("yyyyMMdd.HHmmss");
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
                    PopulateCategorySubcategory(nqs.NEW_QUESTION.Heading_Pair_Id, db,
                        ref q.Category, ref q.PairID, ref q.Subcategory, ref q.SubHeading);
                    q.Title = GetTitle(nqs.NEW_QUESTION.Question_Id, db);

                    // Look at the question's original set to determine if the question is 'custom' and can be edited
                    q.IsCustom = db.SETS.Where(x => x.Set_Name == nqs.NEW_QUESTION.Original_Set_Name).FirstOrDefault().Is_Custom;


                    // Get the SAL levels for this question-set
                    var sals = db.NEW_QUESTION_LEVELS.Where(l => l.New_Question_Set_Id == nqs.New_Question_Set_Id).ToList();
                    foreach (NEW_QUESTION_LEVELS l in sals)
                    {
                        q.SalLevels.Add(l.Universal_Sal_Level);
                    }

                    response.Add(q);
                }

                List<QuestionDetail> list = response.OrderBy(x => x.Category).ThenBy(x => x.Subcategory).ThenBy(x => x.PairID).ToList();

                List<int> customPairingsForThisSet = db.UNIVERSAL_SUB_CATEGORY_HEADINGS
                    .Where(x => x.Set_Name == setName).Select(x => x.Heading_Pair_Id).ToList();

                QuestionListResponse ql = new QuestionListResponse();

                var set = db.SETS.Where(x => x.Set_Name == setName).FirstOrDefault();
                ql.SetFullName = set.Full_Name;
                ql.SetShortName = set.Short_Name;
                ql.SetDescription = set.Standard_ToolTip;


                string currentCategory = string.Empty;
                QuestionListCategory cat = null;

                // In case there are two subcategories with the same name but different pair IDs, they should be rendered separately.
                int currentSubcategoryPairID = -1;
                QuestionListSubcategory subcat = null;

                foreach (QuestionDetail q in list)
                {
                    if (q.Category != currentCategory)
                    {
                        cat = new QuestionListCategory
                        {
                            CategoryName = q.Category
                        };

                        ql.Categories.Add(cat);
                        currentCategory = q.Category;
                    }


                    if (q.PairID != currentSubcategoryPairID)
                    {
                        subcat = new QuestionListSubcategory
                        {
                            PairID = q.PairID,
                            SubcategoryName = q.Subcategory,
                            SubHeading = q.SubHeading,
                            IsSubHeadingEditable = customPairingsForThisSet.Contains(q.PairID)
                        };

                        cat.Subcategories.Add(subcat);
                        currentSubcategoryPairID = q.PairID;
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
        private void PopulateCategorySubcategory(int headingPairId, CSETWebEntities db, ref string cat,
            ref int pairID, ref string subcat, ref string subheading)
        {
            var query = from h in db.UNIVERSAL_SUB_CATEGORY_HEADINGS
                        from h1 in db.QUESTION_GROUP_HEADING.Where(x => x.Question_Group_Heading_Id == h.Question_Group_Heading_Id)
                        from h2 in db.UNIVERSAL_SUB_CATEGORIES.Where(x => x.Universal_Sub_Category_Id == h.Universal_Sub_Category_Id)
                        where h.Heading_Pair_Id == headingPairId
                        select new
                        {
                            h1.Question_Group_Heading1,
                            h2.Universal_Sub_Category,
                            h.Heading_Pair_Id,
                            h.Sub_Heading_Question_Description,
                            h.Set_Name
                        };

            var result = query.FirstOrDefault();
            cat = result.Question_Group_Heading1;
            subcat = result.Universal_Sub_Category;
            pairID = result.Heading_Pair_Id;
            subheading = result.Sub_Heading_Question_Description;
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
        public void AddCustomQuestion(SetQuestion request)
        {
            if (string.IsNullOrEmpty(request.CustomQuestionText))
            {
                return;
            }

            using (var db = new CSETWebEntities())
            {
                NEW_QUESTION q = new NEW_QUESTION();
                q.Simple_Question = request.CustomQuestionText;

                // TODO:  std_ref + std_ref_number must be unique
                q.Std_Ref = DateTime.Now.Millisecond.ToString();
                q.Std_Ref_Number = 0;

                q.Universal_Sal_Level = "L";
                q.Weight = 0;
                q.Original_Set_Name = request.SetName;
                q.Heading_Pair_Id = GetHeadingPair(request.QuestionCategoryID, request.QuestionSubcategoryText, request.SetName);

                db.NEW_QUESTION.Add(q);
                db.SaveChanges();


                if (request.RequirementID > 0)
                {
                    // Add question to requirement
                    REQUIREMENT_QUESTIONS_SETS rqs = new REQUIREMENT_QUESTIONS_SETS
                    {
                        Question_Id = q.Question_Id,
                        Set_Name = request.SetName,
                        Requirement_Id = request.RequirementID
                    };

                    db.REQUIREMENT_QUESTIONS_SETS.Add(rqs);
                }


                // Add question to set
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

                db.SaveChanges();
            }
        }


        /// <summary>
        /// Adds an existing question to a set or requirement.
        /// </summary>
        /// <param name="request"></param>
        public void AddQuestion(SetQuestion request)
        {
            using (var db = new CSETWebEntities())
            {
                if (request.RequirementID > 0)
                {
                    // Attach the question to a Requirement
                    REQUIREMENT_QUESTIONS_SETS rqs = new REQUIREMENT_QUESTIONS_SETS
                    {
                        Question_Id = request.QuestionID,
                        Set_Name = request.SetName,
                        Requirement_Id = request.RequirementID
                    };

                    db.REQUIREMENT_QUESTIONS_SETS.AddOrUpdate(rqs);
                    db.SaveChanges();
                }


                // Attach this question to the Set
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
            }
        }


        /// <summary>
        /// Detaches the specified question from the Set or Requirement.
        /// </summary>
        /// <param name="request"></param>
        public void RemoveQuestion(SetQuestion request)
        {
            using (var db = new CSETWebEntities())
            {
                if (request.RequirementID == 0)
                {
                    // Set-level question
                    var nqs = db.NEW_QUESTION_SETS.Where(x => x.Set_Name == request.SetName && x.Question_Id == request.QuestionID).FirstOrDefault();
                    if (nqs == null)
                    {
                        return;
                    }
                    db.NEW_QUESTION_SETS.Remove(nqs);
                }
                else
                {
                    // Requirement-related question
                    var rqs = db.REQUIREMENT_QUESTIONS_SETS
                        .Where(x => x.Set_Name == request.SetName && x.Question_Id == request.QuestionID).FirstOrDefault();
                    if (rqs == null)
                    {
                        return;
                    }
                    db.REQUIREMENT_QUESTIONS_SETS.Remove(rqs);
                }

                db.SaveChanges();
            }
        }


        /// <summary>
        /// Finds or creates a set-specific UNIVERSAL_SUB_CATEGORY_HEADING
        /// for the category/subcategory/set.
        /// </summary>
        /// <returns></returns>
        private int GetHeadingPair(int categoryId, string subcatText, string setName)
        {
            int subcatID = 0;

            using (var db = new CSETWebEntities())
            {
                // Either find or create the subcategory
                var subcat = db.UNIVERSAL_SUB_CATEGORIES.Where(x => x.Universal_Sub_Category == subcatText).FirstOrDefault();
                if (subcat != null)
                {
                    subcatID = subcat.Universal_Sub_Category_Id;
                }
                else
                {
                    // The subcategory name is new (entered by user) -- create a new subcategory
                    UNIVERSAL_SUB_CATEGORIES sc = new UNIVERSAL_SUB_CATEGORIES
                    {
                        Universal_Sub_Category = subcatText
                    };
                    db.UNIVERSAL_SUB_CATEGORIES.Add(sc);
                    db.SaveChanges();

                    subcatID = sc.Universal_Sub_Category_Id;
                }

                // See if we have this pairing for our set
                var usch = db.UNIVERSAL_SUB_CATEGORY_HEADINGS.Where(x => x.Question_Group_Heading_Id == categoryId
                    && x.Universal_Sub_Category_Id == subcatID
                    && x.Set_Name == setName).FirstOrDefault();

                if (usch != null)
                {
                    return usch.Heading_Pair_Id;
                }

                // Create a new set-specific USCH record
                usch = new UNIVERSAL_SUB_CATEGORY_HEADINGS
                {
                    Question_Group_Heading_Id = categoryId,
                    Universal_Sub_Category_Id = subcatID,
                    Set_Name = setName
                };
                db.UNIVERSAL_SUB_CATEGORY_HEADINGS.Add(usch);
                db.SaveChanges();

                return usch.Heading_Pair_Id;
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public List<CategoryEntry> GetStandardCategories()
        {
            List<CategoryEntry> categoryList = new List<CategoryEntry>();

            using (var db = new CSETWebEntities())
            {
                var standardCategories = db.STANDARD_CATEGORY.ToList();
                foreach (var c in standardCategories)
                {
                    CategoryEntry entry = new CategoryEntry
                    {
                        Text = c.Standard_Category1
                    };
                    categoryList.Add(entry);
                }
            }

            return categoryList;
        }


        /// <summary>
        /// Returns a list of all Question Group Headings (Categories).
        /// Should we ignore categories that aren't paired with any subcategories
        /// in the UNIVERSAL_SUB_CATEGORY_HEADINGS table?
        /// </summary>
        public CategoriesSubcategoriesGroupHeadings GetCategoriesSubcategoriesGroupHeadings()
        {
            CategoriesSubcategoriesGroupHeadings response = new CategoriesSubcategoriesGroupHeadings();


            using (var db = new CSETWebEntities())
            {
                List<CategoryEntry> categoryList = new List<CategoryEntry>();
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


                List<CategoryEntry> groupHeadingsList = new List<CategoryEntry>();
                var groupHeadings = db.QUESTION_GROUP_HEADING.ToList();
                foreach (var h in groupHeadings)
                {
                    CategoryEntry entry = new CategoryEntry
                    {
                        Text = h.Question_Group_Heading1,
                        ID = h.Question_Group_Heading_Id
                    };
                    groupHeadingsList.Add(entry);
                }

                response.GroupHeadings = groupHeadingsList;
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
                List<int> includedQuestions = new List<int>();
                if (searchParms.RequirementID > 0)
                {
                    // Build a list of all questionIDs that are currently on the Requirement
                    includedQuestions = db.REQUIREMENT_QUESTIONS_SETS
                        .Where(x => x.Set_Name == searchParms.SetName && x.Requirement_Id == searchParms.RequirementID)
                        .Select(q => q.Question_Id).ToList();
                }
                else
                {
                    // Build a list of all questionIDs that are currently in the set
                    includedQuestions = db.NEW_QUESTION_SETS.Where(x => x.Set_Name == searchParms.SetName)
                        .Select(q => q.Question_Id).ToList();
                }


                // First, look for an exact string match within the question
                var hits = from q in db.NEW_QUESTION
                           join usch in db.UNIVERSAL_SUB_CATEGORY_HEADINGS on q.Heading_Pair_Id equals usch.Heading_Pair_Id
                           join cat in db.QUESTION_GROUP_HEADING on usch.Question_Group_Heading_Id equals cat.Question_Group_Heading_Id
                           join subcat in db.UNIVERSAL_SUB_CATEGORIES on usch.Universal_Sub_Category_Id equals subcat.Universal_Sub_Category_Id
                           where q.Simple_Question.Contains(searchParms.SearchTerms)
                           select new { q, cat, subcat };

                foreach (var hit in hits.ToList())
                {
                    if (!includedQuestions.Contains(hit.q.Question_Id) && !IsTextEncrypted(hit.q.Simple_Question))
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
                        if (!includedQuestions.Contains(hit.q.Question_Id) && !IsTextEncrypted(hit.q.Simple_Question))
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
        /// Sets or removes a single SAL level for a requirement or question.
        /// </summary>
        /// <param name="salParms"></param>
        public void SetSalLevel(SalParms salParms)
        {
            if (salParms.RequirementID != 0)
            {
                SetRequirementSalLevel(salParms);
            }
            if (salParms.QuestionID != 0)
            {
                SetQuestionSalLevel(salParms);
            }
        }


        /// <summary>
        /// Sets or removes a single SAL level for a requirement.
        /// </summary>
        /// <param name="salParms"></param>
        private void SetRequirementSalLevel(SalParms salParms)
        {
            using (var db = new CSETWebEntities())
            {
                REQUIREMENT_LEVELS level = db.REQUIREMENT_LEVELS.Where(x => x.Requirement_Id == salParms.RequirementID
                    && x.Standard_Level == salParms.Level).FirstOrDefault();

                if (salParms.State)
                {
                    // add the level if it doesn't exist
                    if (level == null)
                    {
                        level = new REQUIREMENT_LEVELS()
                        {
                            Requirement_Id = salParms.RequirementID,
                            Standard_Level = salParms.Level,
                            Level_Type = "NST"
                        };
                        db.REQUIREMENT_LEVELS.AddOrUpdate(level);
                        db.SaveChanges();
                    }
                }
                else
                {
                    // remove the level
                    if (level != null)
                    {
                        db.REQUIREMENT_LEVELS.Remove(level);
                        db.SaveChanges();
                    }
                }
            }
        }


        /// <summary>
        /// Sets or removes a single SAL level for a question.
        /// </summary>
        /// <param name="salParms"></param>
        private void SetQuestionSalLevel(SalParms salParms)
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
                        nql = new NEW_QUESTION_LEVELS()
                        {
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
        /// Updates the question text.  Only questions originally attached
        /// to a 'custom' set can have their text updated.
        /// </summary>
        public void UpdateQuestionText(int questionID, string text)
        {
            using (var db = new CSETWebEntities())
            {
                // is this a custom question?
                var query = from q in db.NEW_QUESTION
                            join s in db.SETS on q.Original_Set_Name equals s.Set_Name
                            where q.Question_Id == questionID
                            select s;

                var origSet = query.FirstOrDefault();

                // if the question's original set does not exist (this should never happen), do nothing.
                if (origSet == null)
                {
                    return;
                }

                // if the question's original set is not 'custom', do nothing.
                if (!origSet.Is_Custom)
                {
                    return;
                }

                // update text
                var question = db.NEW_QUESTION.Where(x => x.Question_Id == questionID).FirstOrDefault();
                if (question == null)
                {
                    return;
                }

                question.Simple_Question = text;
                db.NEW_QUESTION.AddOrUpdate(question);
                db.SaveChanges();
            }
        }


        /// <summary>
        /// Returns a boolean indicating if the question is used by multiple SETs
        /// or has been answered in any ASSESSMENT.
        /// </summary>
        /// <param name="questionID"></param>
        /// <returns></returns>
        public bool IsQuestionInUse(int questionID)
        {
            using (var db = new CSETWebEntities())
            {
                if (db.NEW_QUESTION_SETS.Where(x => x.Question_Id == questionID).Count() > 1)
                {
                    return true;
                }

                if (db.ANSWERs.Where(x => x.Question_Or_Requirement_Id == questionID).Count() > 0)
                {
                    return true;
                }
            }

            return false;
        }


        /// <summary>
        /// Updates the question text.  Only questions originally attached
        /// to a 'custom' set can have their text updated.
        /// </summary>
        public void UpdateHeadingText(int pairID, string text)
        {
            using (var db = new CSETWebEntities())
            {

                //  TODO:::  ARE ALL HEADING UPDATES ALLOWED?  ARE THERE ANY THAT ARE NOT?



                var usch = db.UNIVERSAL_SUB_CATEGORY_HEADINGS.Where(x => x.Heading_Pair_Id == pairID).FirstOrDefault();

                if (usch == null)
                {
                    return;
                }

                usch.Sub_Heading_Question_Description = string.IsNullOrEmpty(text) ? null : text;
                db.UNIVERSAL_SUB_CATEGORY_HEADINGS.AddOrUpdate(usch);
                db.SaveChanges();
            }
        }


        /// <summary>
        /// Try to determine if this an encrypted question.
        /// </summary>
        /// <param name="text"></param>
        /// <returns></returns>
        private bool IsTextEncrypted(string text)
        {
            if (!text.Contains(" ") && text.Length > 10)
            {
                return true;
            }

            return false;
        }


        /// <summary>
        /// Returns a structure of categories/subcategories/requirements for the standard.
        /// </summary>
        /// <param name="setName"></param>
        /// <returns></returns>
        public StandardsResponse GetStandardStructure(string setName)
        {
            StandardsResponse response = new StandardsResponse();

            List<NEW_REQUIREMENT> reqs = new List<NEW_REQUIREMENT>();

            using (var db = new CSETWebEntities())
            {
                var set = db.SETS.Where(x => x.Set_Name == setName).FirstOrDefault();
                response.SetFullName = set.Full_Name;
                response.SetShortName = set.Short_Name;
                response.SetDescription = set.Standard_ToolTip;


                var q = from rs in db.REQUIREMENT_SETS
                        from s in db.SETS.Where(x => x.Set_Name == rs.Set_Name)
                        from r in db.NEW_REQUIREMENT.Where(x => x.Requirement_Id == rs.Requirement_Id)
                        where rs.Set_Name == setName
                        select new { r, rs, s };
                var results = q.Distinct()
                    .OrderBy(x => x.s.Short_Name)
                    .ThenBy(x => x.rs.Requirement_Sequence)
                    .Select(x => x.r);


                reqs.AddRange(results);


                string currentCategory = string.Empty;
                RequirementListCategory cat = null;
                string currentSubcategory = string.Empty;
                RequirementListSubcategory subcat = null;


                foreach (NEW_REQUIREMENT rq in reqs)
                {
                    Requirement r = new Requirement()
                    {
                        RequirementID = rq.Requirement_Id,
                        Title = rq.Requirement_Title,
                        RequirementText = rq.Requirement_Text
                    };

                    // Get the SAL levels for this requirement
                    var sals = db.REQUIREMENT_LEVELS.Where(l => l.Requirement_Id == rq.Requirement_Id).ToList();
                    foreach (REQUIREMENT_LEVELS l in sals)
                    {
                        r.SalLevels.Add(l.Standard_Level);
                    }


                    // Group into Category/Subcategory structure
                    if (rq.Standard_Category != currentCategory)
                    {
                        cat = new RequirementListCategory
                        {
                            CategoryName = rq.Standard_Category
                        };

                        response.Categories.Add(cat);
                        currentCategory = rq.Standard_Category;
                    }


                    if (rq.Standard_Sub_Category != currentSubcategory)
                    {
                        subcat = new RequirementListSubcategory
                        {
                            SubcategoryName = rq.Standard_Sub_Category
                        };

                        cat.Subcategories.Add(subcat);
                        currentSubcategory = rq.Standard_Sub_Category;
                    }

                    subcat.Requirements.Add(r);
                }
            }

            return response;
        }


        /// <summary>
        /// Creates a NEW_REQUIREMENT record for the set.  Creates new category/subcategory records as needed.
        /// </summary>
        /// <param name="parms"></param>
        public Requirement CreateRequirement(Requirement parms)
        {
            using (var db = new CSETWebEntities())
            {
                // Create the category if not already defined
                var existingCategory = db.STANDARD_CATEGORY.Where(x => x.Standard_Category1 == parms.Category).FirstOrDefault();
                if (existingCategory == null)
                {
                    STANDARD_CATEGORY newCategory = new STANDARD_CATEGORY()
                    {
                        Standard_Category1 = parms.Category
                    };
                    db.STANDARD_CATEGORY.Add(newCategory);
                }

                // Create the subcategory if not already defined
                var existingSubcategory = db.UNIVERSAL_SUB_CATEGORIES.Where(x => x.Universal_Sub_Category == parms.Subcategory).FirstOrDefault();
                if (existingSubcategory == null)
                {
                    UNIVERSAL_SUB_CATEGORIES newSubcategory = new UNIVERSAL_SUB_CATEGORIES()
                    {
                        Universal_Sub_Category = parms.Subcategory
                    };
                    db.UNIVERSAL_SUB_CATEGORIES.Add(newSubcategory);
                }

                db.SaveChanges();


                NEW_REQUIREMENT req = new NEW_REQUIREMENT
                {
                    Requirement_Title = parms.Title,
                    Requirement_Text = parms.RequirementText,
                    Standard_Category = parms.Category,
                    Standard_Sub_Category = parms.Subcategory,
                    Question_Group_Heading_Id = parms.QuestionGroupHeadingID,
                    Original_Set_Name = parms.SetName
                };

                db.NEW_REQUIREMENT.Add(req);
                db.SaveChanges();

                parms.RequirementID = req.Requirement_Id;


                REQUIREMENT_SETS rs = new REQUIREMENT_SETS
                {
                    Requirement_Id = req.Requirement_Id,
                    Set_Name = parms.SetName,
                    Requirement_Sequence = 1
                };

                db.REQUIREMENT_SETS.Add(rs);
                db.SaveChanges();
            }

            return parms;
        }


        /// <summary>
        /// Gets a Requirement for the specified Set and ID
        /// </summary>
        /// <param name="setName"></param>
        /// <param name="reqID"></param>
        /// <returns></returns>
        public Requirement GetRequirement(string setName, int reqID)
        {
            using (var db = new CSETWebEntities())
            {
                var q = from rs in db.REQUIREMENT_SETS
                        from s in db.SETS.Where(x => x.Set_Name == rs.Set_Name)
                        from r in db.NEW_REQUIREMENT.Where(x => x.Requirement_Id == rs.Requirement_Id)
                        where rs.Set_Name == setName && rs.Requirement_Id == reqID
                        select r;

                var result = q.FirstOrDefault();

                Requirement requirement = new Requirement
                {
                    Category = result.Standard_Category,
                    Subcategory = result.Standard_Sub_Category,
                    Title = result.Requirement_Title,
                    RequirementID = result.Requirement_Id,
                    RequirementText = result.Requirement_Text,
                    QuestionGroupHeadingID = result.Question_Group_Heading_Id,
                    SetName = setName,
                    SupplementalInfo = result.Supplemental_Info
                };

                // Get the SAL levels for this requirement
                var sals = db.REQUIREMENT_LEVELS.Where(l => l.Requirement_Id == requirement.RequirementID).ToList();
                foreach (REQUIREMENT_LEVELS l in sals)
                {
                    requirement.SalLevels.Add(l.Standard_Level);
                }

                // Get the questions for this requirement
                var relatedQuestions = db.REQUIREMENT_QUESTIONS_SETS
                    .Where(x => x.Requirement_Id == requirement.RequirementID && x.Set_Name == setName).ToList();

                foreach (var q1 in relatedQuestions)
                {
                    requirement.Questions.Add(new QuestionDetail()
                    {
                        QuestionID = q1.Question_Id,
                        QuestionText = q1.NEW_QUESTION.Simple_Question,
                        IsCustom = db.SETS.Where(x => x.Set_Name == q1.NEW_QUESTION.Original_Set_Name).FirstOrDefault().Is_Custom
                    });
                }

                return requirement;
            }
        }


        /// <summary>
        /// Updates the NEW_REQUIREMENT record for the set.  Creates new category/subcategory records as needed.
        /// </summary>
        /// <param name="parms"></param>
        public Requirement UpdateRequirement(Requirement parms)
        {
            using (var db = new CSETWebEntities())
            {
                // Create the category if not already defined
                var existingCategory = db.STANDARD_CATEGORY.Where(x => x.Standard_Category1 == parms.Category).FirstOrDefault();
                if (existingCategory == null)
                {
                    STANDARD_CATEGORY newCategory = new STANDARD_CATEGORY()
                    {
                        Standard_Category1 = parms.Category
                    };
                    db.STANDARD_CATEGORY.Add(newCategory);
                }

                // Create the subcategory if not already defined
                var existingSubcategory = db.UNIVERSAL_SUB_CATEGORIES.Where(x => x.Universal_Sub_Category == parms.Subcategory).FirstOrDefault();
                if (existingSubcategory == null)
                {
                    UNIVERSAL_SUB_CATEGORIES newSubcategory = new UNIVERSAL_SUB_CATEGORIES()
                    {
                        Universal_Sub_Category = parms.Subcategory
                    };
                    db.UNIVERSAL_SUB_CATEGORIES.Add(newSubcategory);
                }

                db.SaveChanges();

                NEW_REQUIREMENT req = db.NEW_REQUIREMENT.Where(x => x.Requirement_Id == parms.RequirementID).FirstOrDefault();
                req.Requirement_Title = parms.Title;
                req.Requirement_Text = parms.RequirementText;
                req.Standard_Category = parms.Category;
                req.Standard_Sub_Category = parms.Subcategory;
                req.Question_Group_Heading_Id = parms.QuestionGroupHeadingID;
                req.Original_Set_Name = parms.SetName;
                req.Supplemental_Info = parms.SupplementalInfo;


                db.NEW_REQUIREMENT.AddOrUpdate(req);
                db.SaveChanges();
            }

            return parms;
        }


        /// <summary>
        /// Removes the NEW_REQUIREMENT record from the set.
        /// 
        /// TODO:  Actually delete the NEW_REQUIREMENT record?
        /// </summary>
        /// <param name="parms"></param>
        public void RemoveRequirement(Requirement parms)
        {
            using (var db = new CSETWebEntities())
            {
                var bridge = db.REQUIREMENT_SETS.Where(x => x.Set_Name == parms.SetName && x.Requirement_Id == parms.RequirementID).FirstOrDefault();
                if (bridge == null)
                {
                    return;
                }

                db.REQUIREMENT_SETS.Remove(bridge);

                var req = db.NEW_REQUIREMENT.Where(x => x.Requirement_Id == parms.RequirementID).FirstOrDefault();
                if (req == null)
                {
                    return;
                }

                db.NEW_REQUIREMENT.Remove(req);
                db.SaveChanges();
            }
        }
    }
}
