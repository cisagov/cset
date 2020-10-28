using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using CSETWeb_Api.BusinessLogic.Helpers;
using CSETWeb_Api.BusinessLogic.Helpers.upload;
using CSETWeb_Api.BusinessLogic.Models;
using DataLayerCore.Model;
using Microsoft.EntityFrameworkCore;

namespace CSETWeb_Api.BusinessManagers
{
    /// <summary>
    /// Provides logic to administer new custom Modules (Standards/Question Sets).
    /// </summary>
    public class ModuleBuilderManager
    {
        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public List<SetDetail> GetCustomSetList()
        {
            using (var db = new CSET_Context())
            {
                List<SetDetail> list = new List<SetDetail>();

                var s = db.SETS
                    .Where(x => x.Is_Custom)
                    .Where(x => !x.Is_Deprecated)
                    .OrderBy(x => x.Full_Name)
                    .ToList();
                foreach (SETS set in s)
                {
                    SetDetail sr = new SetDetail
                    {
                        SetName = set.Set_Name,
                        FullName = set.Full_Name,
                        ShortName = set.Short_Name,
                        SetCategory = set.Set_Category_Id != null ? (int)set.Set_Category_Id : 0,
                        IsCustom = set.Is_Custom,
                        IsDisplayed = set.Is_Displayed ?? false,

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
            using (var db = new CSET_Context())
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
                    set.IsDisplayed = dbSet.Is_Displayed ?? false;
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
        /// Copies the structure of an existing set into a new one.  
        /// </summary>
        public SetDetail CloneSet(string setName)
        {
            string newSetName = GenerateNewSetName();

            ModuleCloner cloner = new ModuleCloner();
            bool cloneSuccess = cloner.CloneModule(setName, newSetName);

            if (cloneSuccess)
            {
                return GetSetDetail(newSetName);
            }

            return null;
        }


        /// <summary>
        /// 
        /// </summary>
        public BasicResponse DeleteSet(string setName)
        {
            BasicResponse resp = new BasicResponse();

            using (var db = new CSET_Context())
            {
                var dbSet = db.SETS.Where(x => x.Set_Name == setName).FirstOrDefault();

                if (dbSet == null)
                {
                    return resp;
                }

                // Don't allow a non-custom set to be deleted
                if (!dbSet.Is_Custom)
                {
                    return resp;
                }

                // See if the set to be deleted is the original set for other sets' requirements.
                // If so, don't allow the delete.
                var query = from req in db.NEW_REQUIREMENT
                            join rs in db.REQUIREMENT_SETS on req.Requirement_Id equals rs.Requirement_Id
                            where req.Original_Set_Name == setName
                            && rs.Set_Name != req.Original_Set_Name
                            select req;

                if (query.ToList().Count > 0)
                {
                    resp.ErrorMessages.Add("Cannot perform delete. " +
                        "One or more of this Module's requirements " +
                        "are referenced by other Modules.");
                    return resp;
                }


                // Delete the Requirements first.  Waiting to let the SET delete cascade to the Requirements
                // seems to get hung up on the Original_Set_Name FK.
                query = from req in db.NEW_REQUIREMENT
                        join rs in db.REQUIREMENT_SETS on req.Requirement_Id equals rs.Requirement_Id
                        where rs.Set_Name == setName
                        select req;

                foreach (NEW_REQUIREMENT r in query.ToList())
                {
                    db.NEW_REQUIREMENT.Remove(r);
                }
                db.SaveChanges();


                // Delete any questions that were created for this set.
                var queryQ = db.NEW_QUESTION.Where(x => x.Original_Set_Name == setName);
                foreach (NEW_QUESTION q in queryQ.ToList())
                {
                    db.NEW_QUESTION.Remove(q);
                }
                db.SaveChanges();


                // This should cascade delete everything else
                db.SETS.Remove(dbSet);
                db.SaveChanges();
            }

            return resp;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="set"></param>
        /// <returns></returns>
        public string SaveSetDetail(SetDetail set)
        {
            CSET_Context db = new CSET_Context();

            if (string.IsNullOrEmpty(set.FullName))
            {
                set.FullName = "(untitled set)";
            }

            if (string.IsNullOrEmpty(set.ShortName))
            {
                set.ShortName = "";
            }


            // Add or update the SETS record
            var dbSet = db.SETS.Where(x => x.Set_Name == set.SetName).FirstOrDefault();
            if (dbSet == null)
            {
                dbSet = new SETS()
                {
                    Set_Name = set.SetName,
                    Full_Name = set.FullName,
                    Short_Name = set.ShortName,
                    Standard_ToolTip = set.Description,
                    Set_Category_Id = set.SetCategory == 0 ? null : set.SetCategory,
                    Is_Custom = set.IsCustom,
                    Is_Displayed = set.IsDisplayed
                };

                db.SETS.Add(dbSet);
            }
            else
            {
                dbSet.Full_Name = set.FullName;
                dbSet.Short_Name = set.ShortName;
                dbSet.Standard_ToolTip = set.Description;
                dbSet.Set_Category_Id = set.SetCategory == 0 ? null : set.SetCategory;
                dbSet.Is_Custom = set.IsCustom;
                dbSet.Is_Displayed = set.IsDisplayed;

                db.SETS.Update(dbSet);
            }

            db.SaveChanges();

            return set.SetName;
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
            using (var db = new CSET_Context())
            {
                List<NEW_QUESTION_SETS> dbQuestions = db.NEW_QUESTION_SETS
                    .Include(x => x.Question_)
                    .Where(x => x.Set_Name == setName).ToList();

                List<QuestionDetail> response = new List<QuestionDetail>();
                foreach (NEW_QUESTION_SETS nqs in dbQuestions)
                {
                    QuestionDetail q = new QuestionDetail();
                    q.QuestionID = nqs.Question_.Question_Id;
                    q.QuestionText = nqs.Question_.Simple_Question;
                    PopulateCategorySubcategory(nqs.Question_.Heading_Pair_Id, db,
                        ref q.QuestionGroupHeading, ref q.PairID, ref q.Subcategory, ref q.SubHeading);
                    q.Title = GetTitle(nqs.Question_.Question_Id, db);

                    // Look at the question's original set to determine if the question is 'custom' and can be edited
                    q.IsCustom = db.SETS.Where(x => x.Set_Name == nqs.Question_.Original_Set_Name).FirstOrDefault().Is_Custom;


                    // Get the SAL levels for this question-set
                    var sals = db.NEW_QUESTION_LEVELS.Where(l => l.New_Question_Set_Id == nqs.New_Question_Set_Id).ToList();
                    foreach (NEW_QUESTION_LEVELS l in sals)
                    {
                        q.SalLevels.Add(l.Universal_Sal_Level);
                    }

                    response.Add(q);
                }

                List<QuestionDetail> list = response.OrderBy(x => x.QuestionGroupHeading).ThenBy(x => x.Subcategory).ThenBy(x => x.PairID).ToList();

                List<int> customPairingsForThisSet = db.UNIVERSAL_SUB_CATEGORY_HEADINGS
                    .Where(x => x.Set_Name == setName).Select(x => x.Heading_Pair_Id).ToList();

                QuestionListResponse ql = new QuestionListResponse();

                var set = db.SETS.Where(x => x.Set_Name == setName).FirstOrDefault();
                ql.SetFullName = set.Full_Name;
                ql.SetShortName = set.Short_Name;
                ql.SetDescription = set.Standard_ToolTip;


                string currentQGH = string.Empty;
                QuestionListCategory cat = null;

                // In case there are two subcategories with the same name but different pair IDs, they should be rendered separately.
                int currentSubcategoryPairID = -1;
                QuestionListSubcategory subcat = null;

                int displayNumber = 0;

                foreach (QuestionDetail q in list)
                {
                    if (q.QuestionGroupHeading != currentQGH)
                    {
                        cat = new QuestionListCategory
                        {
                            CategoryName = q.QuestionGroupHeading
                        };

                        ql.Categories.Add(cat);
                        currentQGH = q.QuestionGroupHeading;
                        displayNumber = 0;
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

                    q.DisplayNumber = ++displayNumber;
                    subcat.Questions.Add(q);
                }

                return ql;
            }
        }


        /// <summary>
        /// Gets any questions originated by the specified set 
        /// that are being used by other sets.
        /// </summary>
        /// <param name="setName"></param>
        /// <returns></returns>
        public List<int> GetMyQuestionsUsedByOtherSets(string setName)
        {
            using (var db = new CSET_Context())
            {
                var query = from nqs in db.NEW_QUESTION_SETS
                            join question in db.NEW_QUESTION on nqs.Question_Id equals question.Question_Id
                            where question.Original_Set_Name == setName && nqs.Set_Name != setName
                            select question;
                List<int> qList = new List<int>();
                foreach (var q in query)
                {
                    qList.Add(q.Question_Id);
                }
                return qList;
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name=""></param>
        /// <returns></returns>
        private void PopulateCategorySubcategory(int headingPairId, CSET_Context db, ref string cat,
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
        private string GetTitle(int questionId, CSET_Context db)
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
            using (var db = new CSET_Context())
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

            using (var db = new CSET_Context())
            {
                // get the max Std_Ref_Number for the std_ref
                int newStdRefNum = 1;
                var fellowQuestions = db.NEW_QUESTION.Where(x => x.Std_Ref == request.SetName).ToList();
                if (fellowQuestions.Count > 0)
                {
                    newStdRefNum = fellowQuestions.Max(x => x.Std_Ref_Number) + 1;
                }




                NEW_QUESTION q = new NEW_QUESTION
                {
                    Simple_Question = request.CustomQuestionText,

                    // TODO:  std_ref + std_ref_number must be unique
                    Std_Ref = request.SetName,
                    Std_Ref_Number = newStdRefNum,

                    Universal_Sal_Level = "L",
                    Weight = 0,
                    Original_Set_Name = request.SetName,
                    Heading_Pair_Id = GetHeadingPair(request.QuestionCategoryID, request.QuestionSubcategoryText, request.SetName)
                };

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


                    REQUIREMENT_QUESTIONS rq = new REQUIREMENT_QUESTIONS
                    {
                        Question_Id = q.Question_Id,
                        Requirement_Id = request.RequirementID
                    };

                    db.REQUIREMENT_QUESTIONS.Add(rq);
                }


                // Add question to set
                NEW_QUESTION_SETS nqs = new NEW_QUESTION_SETS
                {
                    Question_Id = q.Question_Id,
                    Set_Name = request.SetName
                };

                db.NEW_QUESTION_SETS.Add(nqs);

                db.SaveChanges();


                // Define SALs
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
            using (var db = new CSET_Context())
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

                    db.REQUIREMENT_QUESTIONS_SETS.Add(rqs);


                    REQUIREMENT_QUESTIONS rq = new REQUIREMENT_QUESTIONS
                    {
                        Question_Id = request.QuestionID,
                        Requirement_Id = request.RequirementID
                    };

                    db.REQUIREMENT_QUESTIONS.Add(rq);


                    db.SaveChanges();
                }


                // Attach this question to the Set
                NEW_QUESTION_SETS nqs = new NEW_QUESTION_SETS
                {
                    Question_Id = request.QuestionID,
                    Set_Name = request.SetName
                };

                db.NEW_QUESTION_SETS.Add(nqs);
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
            using (var db = new CSET_Context())
            {
                if (request.RequirementID != 0)
                {
                    // Requirement-related question
                    var rqs = db.REQUIREMENT_QUESTIONS_SETS
                        .Where(x => x.Set_Name == request.SetName && x.Question_Id == request.QuestionID)
                        .FirstOrDefault();
                    if (rqs != null)
                    {
                        db.REQUIREMENT_QUESTIONS_SETS.Remove(rqs);
                    }

                    var rq = db.REQUIREMENT_QUESTIONS
                        .Where(x => x.Question_Id == request.QuestionID && x.Requirement_Id == request.RequirementID)
                        .FirstOrDefault();
                    if (rq != null)
                    {
                        db.REQUIREMENT_QUESTIONS.Remove(rq);
                    }
                }

                // Set-level question
                var nqs = db.NEW_QUESTION_SETS
                    .Where(x => x.Set_Name == request.SetName && x.Question_Id == request.QuestionID)
                    .FirstOrDefault();
                if (nqs != null)
                {
                    db.NEW_QUESTION_SETS.Remove(nqs);
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

            using (var db = new CSET_Context())
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

                // See if this pairing exists (regardless of the set name)
                var usch = db.UNIVERSAL_SUB_CATEGORY_HEADINGS
                    .Where(x => x.Question_Group_Heading_Id == categoryId && x.Universal_Sub_Category_Id == subcatID)
                    .FirstOrDefault();

                if (usch != null)
                {
                    return usch.Heading_Pair_Id;
                }

                // Create a new USCH record
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

            using (var db = new CSET_Context())
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


            using (var db = new CSET_Context())
            {
                var categories = db.QUESTION_GROUP_HEADING.Select(q => new CategoryEntry { Text = q.Question_Group_Heading1, ID = q.Question_Group_Heading_Id }).ToList();
                response.Categories = categories;

                var subcategories = db.UNIVERSAL_SUB_CATEGORIES.Select(u => new CategoryEntry { Text = u.Universal_Sub_Category, ID = u.Universal_Sub_Category_Id }).ToList();
                response.Subcategories = subcategories;

                var groupHeadings = db.QUESTION_GROUP_HEADING.Where(x => x.Universal_Weight != 0).Select(q => new CategoryEntry { Text = q.Question_Group_Heading1, ID = q.Question_Group_Heading_Id }).ToList();
                response.GroupHeadings = groupHeadings;
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

            using (var db = new CSET_Context())
            {
                // Build a list of all questionIDs that are currently in the set
                List<int> includedQuestions = db.NEW_QUESTION_SETS.Where(x => x.Set_Name == searchParms.SetName)
                    .Select(q => q.Question_Id).ToList();


                // First, look for an exact string match within the question
                var hits = from q in db.NEW_QUESTION
                           join usch in db.UNIVERSAL_SUB_CATEGORY_HEADINGS on q.Heading_Pair_Id equals usch.Heading_Pair_Id
                           join qgh in db.QUESTION_GROUP_HEADING on usch.Question_Group_Heading_Id equals qgh.Question_Group_Heading_Id
                           join subcat in db.UNIVERSAL_SUB_CATEGORIES on usch.Universal_Sub_Category_Id equals subcat.Universal_Sub_Category_Id
                           where q.Simple_Question.Contains(searchParms.SearchTerms)
                           select new { q, qgh, subcat };

                foreach (var hit in hits.ToList())
                {
                    if (!includedQuestions.Contains(hit.q.Question_Id) && !IsTextEncrypted(hit.q.Simple_Question))
                    {
                        QuestionDetail candidate = new QuestionDetail
                        {
                            QuestionID = hit.q.Question_Id,
                            QuestionText = QuestionsManager.FormatLineBreaks(hit.q.Simple_Question),
                            QuestionGroupHeading = hit.qgh.Question_Group_Heading1,
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
                        sbWhereClause.AppendFormat("[Simple_Question] like '%{0}%' and ", term.Replace('*', '%').Replace("\'", "''"));
                    }
                }

                string whereClause = sbWhereClause.ToString();
                whereClause = whereClause.Substring(0, whereClause.Length - 5);

                var hits2 = db.NEW_QUESTION.FromSqlRaw("SELECT * FROM [NEW_QUESTION] where " + whereClause).ToList();

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
                                QuestionGroupHeading = hit.cat.Question_Group_Heading1,
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
            using (var db = new CSET_Context())
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
                        db.REQUIREMENT_LEVELS.Add(level);
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
            using (var db = new CSET_Context())
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
                        db.NEW_QUESTION_LEVELS.Add(nql);
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
        public BasicResponse UpdateQuestionText(int questionID, string text)
        {
            BasicResponse resp = new BasicResponse();
            if (text.Length > 7000)
                text = text.Substring(0, 7000);

            using (var db = new CSET_Context())
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
                    return resp;
                }

                // if the question's original set is not 'custom', do nothing.
                if (!origSet.Is_Custom)
                {
                    return resp;
                }

                // Update text.  Try/catch in case they are setting duplicate question text.
                try
                {
                    var question = db.NEW_QUESTION.Where(x => x.Question_Id == questionID).FirstOrDefault();
                    if (question == null)
                    {
                        resp.ErrorMessages.Add("Question ID is not defined");
                        return resp;
                    }

                    question.Simple_Question = text;

                    db.NEW_QUESTION.Update(question);
                    db.SaveChanges();

                    return resp;
                }
                catch (Microsoft.EntityFrameworkCore.DbUpdateException exc)
                {
                    resp.ErrorMessages.Add("DUPLICATE QUESTION TEXT");
                    return resp;
                }
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
            using (var db = new CSET_Context())
            {
                if (db.NEW_QUESTION_SETS.Where(x => x.Question_Id == questionID).Count() > 1)
                {
                    return true;
                }

                if (db.ANSWER.Where(x => x.Question_Or_Requirement_Id == questionID).Count() > 0)
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
            using (var db = new CSET_Context())
            {
                var usch = db.UNIVERSAL_SUB_CATEGORY_HEADINGS.Where(x => x.Heading_Pair_Id == pairID).FirstOrDefault();

                if (usch == null)
                {
                    return;
                }

                usch.Sub_Heading_Question_Description = string.IsNullOrEmpty(text) ? null : text;
                db.UNIVERSAL_SUB_CATEGORY_HEADINGS.Update(usch);
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
        public ModuleResponse GetModuleStructure(string setName)
        {
            ModuleResponse response = new ModuleResponse();

            List<NEW_REQUIREMENT> reqs = new List<NEW_REQUIREMENT>();

            using (var db = new CSET_Context())
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
            using (var db = new CSET_Context())
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
                    Requirement_Title = parms.Title == null ? "" : parms.Title.Trim().Truncate(250),
                    Requirement_Text = parms.RequirementText.Trim(),
                    Standard_Category = parms.Category.Trim().Truncate(250),
                    Standard_Sub_Category = parms.Subcategory == null ? "" : parms.Subcategory.Trim().Truncate(250),
                    Question_Group_Heading_Id = parms.QuestionGroupHeadingID,
                    Original_Set_Name = parms.SetName.Truncate(50)
                };

                db.NEW_REQUIREMENT.Add(req);
                db.SaveChanges();

                parms.RequirementID = req.Requirement_Id;


                // Determine a new sequence number
                int sequence = 1;
                var seqList = db.REQUIREMENT_SETS
                    .Where(x => x.Set_Name == parms.SetName)
                    .Select(x => x.Requirement_Sequence).ToList();
                if (seqList.Count > 0)
                {
                    sequence = seqList.Max() + 1;
                }


                REQUIREMENT_SETS rs = new REQUIREMENT_SETS
                {
                    Requirement_Id = req.Requirement_Id,
                    Set_Name = parms.SetName,
                    Requirement_Sequence = sequence
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
            using (var db = new CSET_Context())
            {
                var q = from rs in db.REQUIREMENT_SETS
                        from s in db.SETS.Where(x => x.Set_Name == rs.Set_Name)
                        from r in db.NEW_REQUIREMENT.Where(x => x.Requirement_Id == rs.Requirement_Id)
                        where rs.Set_Name == setName && rs.Requirement_Id == reqID
                        select r;

                var result = q.FirstOrDefault();

                if (result == null)
                {
                    return null;
                }

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


                // Get the Reference documents for this requirement
                var allDocs = GetReferencesForRequirement(requirement.RequirementID);
                requirement.SourceDocs = allDocs.SourceDocs;
                requirement.ResourceDocs = allDocs.ResourceDocs;



                // Get the questions for this requirement
                var relatedQuestions = db.REQUIREMENT_QUESTIONS_SETS
                    .Include(x => x.Question_)
                    .Where(x => x.Requirement_Id == requirement.RequirementID && x.Set_Name == setName).ToList();

                foreach (var q1 in relatedQuestions)
                {
                    requirement.Questions.Add(new QuestionDetail()
                    {
                        QuestionID = q1.Question_Id,
                        QuestionText = q1.Question_.Simple_Question,
                        IsCustom = db.SETS.Where(x => x.Set_Name == q1.Question_.Original_Set_Name).FirstOrDefault().Is_Custom
                    });
                }

                return requirement;
            }
        }


        /// <summary>
        /// Returns two lists -- reference documents that are 'source' 
        /// and 'resource'.
        /// </summary>
        /// <param name="reqID"></param>
        /// <returns></returns>
        private ReferenceDocLists GetReferencesForRequirement(int reqID)
        {
            using (var db = new CSET_Context())
            {
                // Get all "source" documents
                List<ReferenceDoc> sourceList = new List<ReferenceDoc>();
                var sources = db.REQUIREMENT_SOURCE_FILES
                    .Include(x => x.Gen_File_)
                    .Where(x => x.Requirement_Id == reqID).ToList();
                foreach (REQUIREMENT_SOURCE_FILES reff in sources)
                {
                    sourceList.Add(new ReferenceDoc
                    {
                        SectionRef = reff.Section_Ref,
                        ID = reff.Gen_File_Id,
                        Title = reff.Gen_File_.Title,
                        Name = reff.Gen_File_.Name,
                        ShortName = reff.Gen_File_.Short_Name,
                        FileName = reff.Gen_File_.File_Name,
                        DocumentNumber = reff.Gen_File_.Doc_Num,
                        DocumentVersion = reff.Gen_File_.Doc_Version,
                        PublishDate = reff.Gen_File_.Publish_Date,
                        Summary = reff.Gen_File_.Summary,
                        Description = reff.Gen_File_.Description,
                        Comments = reff.Gen_File_.Comments,
                    });
                }

                // Get all "resource" documents
                List<ReferenceDoc> resourceList = new List<ReferenceDoc>();
                var resources = db.REQUIREMENT_REFERENCES
                    .Include(x => x.Gen_File_)
                    .Where(x => x.Requirement_Id == reqID).ToList();
                foreach (REQUIREMENT_REFERENCES reff in resources)
                {
                    resourceList.Add(new ReferenceDoc
                    {
                        SectionRef = reff.Section_Ref,
                        ID = reff.Gen_File_Id,
                        Title = reff.Gen_File_.Title,
                        Name = reff.Gen_File_.Name,
                        ShortName = reff.Gen_File_.Short_Name,
                        FileName = reff.Gen_File_.File_Name,
                        DocumentNumber = reff.Gen_File_.Doc_Num,
                        DocumentVersion = reff.Gen_File_.Doc_Version,
                        PublishDate = reff.Gen_File_.Publish_Date,
                        Summary = reff.Gen_File_.Summary,
                        Description = reff.Gen_File_.Description,
                        Comments = reff.Gen_File_.Comments,
                    });
                }

                // Package the two lists together
                ReferenceDocLists response = new ReferenceDocLists();
                response.SourceDocs = sourceList;
                response.ResourceDocs = resourceList;
                return response;
            }
        }


        /// <summary>
        /// Updates the NEW_REQUIREMENT record for the set.  Creates new category/subcategory records as needed.
        /// </summary>
        /// <param name="parms"></param>
        public Requirement UpdateRequirement(Requirement parms)
        {
            using (var db = new CSET_Context())
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


                db.NEW_REQUIREMENT.Update(req);
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
            using (var db = new CSET_Context())
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


        /// <summary>
        /// Returns a collection of reference documents.
        /// Reference documents attached to the set are marked as selected.
        /// </summary>
        /// <returns></returns>
        public List<ReferenceDoc> GetReferenceDocs(string setName, string filter)
        {
            if (filter == null)
            {
                filter = "";
            }

            List<ReferenceDoc> list = new List<ReferenceDoc>();
            using (var db = new CSET_Context())
            {
                var genFileList = db.GEN_FILE
                    .Include(x => x.GEN_FILE_LIB_PATH_CORL)
                    .Where(x => x.Title.Contains(filter)).ToList().OrderBy(x => x.Title).ToList();

                var selectedFiles = db.SET_FILES.Where(x => x.SetName == setName).ToList().Select(y => y.Gen_File_Id);

                foreach (var f in genFileList)
                {
                    list.Add(new ReferenceDoc
                    {
                        ID = f.Gen_File_Id,
                        FileName = f.File_Name,
                        Title = f.Title,
                        Selected = selectedFiles.Contains(f.Gen_File_Id),

                        IsCustom = (f.Gen_File_Id > 3866)

                    });
                }
            }

            return list;
        }


        /// <summary>
        /// Returns the list of reference docs attached to the set. 
        /// </summary>
        /// <param name="setName"></param>
        /// <returns></returns>
        public List<ReferenceDoc> GetReferenceDocsForSet(string setName)
        {
            using (var db = new CSET_Context())
            {

                var query = from sf in db.SET_FILES
                            join gf in db.GEN_FILE on sf.Gen_File_Id equals gf.Gen_File_Id
                            where sf.SetName == setName
                            select new { gf };
                var files = query.ToList();

                List<ReferenceDoc> list = new List<ReferenceDoc>();
                foreach (var f in files)
                {
                    ReferenceDoc doc = new ReferenceDoc
                    {
                        Title = f.gf.Title,
                        FileName = f.gf.File_Name,
                        ID = f.gf.Gen_File_Id
                    };

                    list.Add(doc);
                }

                return list;
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public ReferenceDoc GetReferenceDocDetail(int id)
        {
            using (var db = new CSET_Context())
            {
                var dbDoc = db.GEN_FILE.Where(x => x.Gen_File_Id == id).FirstOrDefault();
                ReferenceDoc doc = new ReferenceDoc
                {
                    ID = dbDoc.Gen_File_Id,
                    Title = dbDoc.Title,
                    FileName = dbDoc.File_Name,
                    Name = dbDoc.Name,
                    ShortName = dbDoc.Short_Name,
                    DocumentNumber = dbDoc.Doc_Num,
                    PublishDate = dbDoc.Publish_Date,
                    DocumentVersion = dbDoc.Doc_Version,
                    Summary = dbDoc.Summary,
                    Description = dbDoc.Description,
                    Comments = dbDoc.Comments
                };


                doc.IsCustom = (doc.ID > 3866);
                // How can we define 'custom' files?


                return doc;
            }
        }


        /// <summary>
        /// 
        /// </summary>
        public void UpdateReferenceDocDetail(ReferenceDoc doc)
        {
            using (var db = new CSET_Context())
            {
                var dbDoc = db.GEN_FILE.Where(x => x.Gen_File_Id == doc.ID).FirstOrDefault();
                if (dbDoc == null)
                {
                    return;
                }

                dbDoc.Title = string.IsNullOrEmpty(doc.Title) ? "(no title)" : doc.Title;
                dbDoc.Name = string.IsNullOrEmpty(doc.Name) ? "(no name)" : doc.Name;
                dbDoc.Short_Name = doc.ShortName;
                dbDoc.Doc_Num = doc.DocumentNumber;
                dbDoc.Publish_Date = doc.PublishDate;
                dbDoc.Doc_Version = doc.DocumentVersion;
                // dbDoc.Source_Type = doc.sourcetype
                dbDoc.Summary = doc.Summary;
                dbDoc.Description = doc.Description;
                dbDoc.Comments = doc.Comments;

                db.GEN_FILE.Update(dbDoc);
                db.SaveChanges();
            }
        }


        /// <summary>
        /// Creates or deletes the SET_FILE row tying the document to the set.
        /// </summary>
        public void SelectSetFile(SetFileSelection parms)
        {
            using (var db = new CSET_Context())
            {
                if (parms.Doc.Selected)
                {
                    SET_FILES sf = new SET_FILES
                    {
                        SetName = parms.SetName,
                        Gen_File_Id = parms.Doc.ID
                    };
                    db.SET_FILES.Add(sf);
                }
                else
                {
                    var setFile = db.SET_FILES.Where(x => x.SetName == parms.SetName && x.Gen_File_Id == parms.Doc.ID).FirstOrDefault();
                    db.SET_FILES.Remove(setFile);
                }

                db.SaveChanges();
            }
        }


        /// <summary>
        /// Either add or delete the reference document to the requirement.
        /// Returns the new list.
        /// </summary>
        public ReferenceDocLists AddDeleteRefDocToRequirement(int requirementId, int docId, bool isSourceRef, string bookmark, bool add)
        {
            if (bookmark == null)
            {
                bookmark = string.Empty;
            }

            using (var db = new CSET_Context())
            {
                if (isSourceRef)
                {
                    var reqref = db.REQUIREMENT_SOURCE_FILES
                            .Where(x => x.Requirement_Id == requirementId && x.Gen_File_Id == docId && x.Section_Ref == bookmark).FirstOrDefault();

                    if (add)
                    {
                        if (reqref == null)
                        {
                            // Create a new one
                            reqref = new REQUIREMENT_SOURCE_FILES
                            {
                                Gen_File_Id = docId,
                                Requirement_Id = requirementId,
                                Section_Ref = bookmark.TrimStart('#')
                            };
                            db.REQUIREMENT_SOURCE_FILES.Add(reqref);
                            db.SaveChanges();
                        }
                    }
                    else
                    {
                        // Delete reference
                        if (reqref != null)
                        {
                            db.REQUIREMENT_SOURCE_FILES.Remove(reqref);
                            db.SaveChanges();
                        }
                    }
                }
                else
                {
                    var reqref = db.REQUIREMENT_REFERENCES
                            .Where(x => x.Requirement_Id == requirementId && x.Gen_File_Id == docId && x.Section_Ref == bookmark).FirstOrDefault();

                    if (add)
                    {
                        if (reqref == null)
                        {
                            // Create a new one
                            reqref = new REQUIREMENT_REFERENCES
                            {
                                Gen_File_Id = docId,
                                Requirement_Id = requirementId,
                                Section_Ref = bookmark.TrimStart('#')
                            };
                            db.REQUIREMENT_REFERENCES.Add(reqref);
                            db.SaveChanges();
                        }
                        else
                        {
                            // reference record already exists
                        }
                    }
                    else
                    {
                        // Delete reference
                        if (reqref != null)
                        {
                            db.REQUIREMENT_REFERENCES.Remove(reqref);
                            db.SaveChanges();
                        }
                    }
                }
            }

            return GetReferencesForRequirement(requirementId);
        }


        /// <summary>
        /// Saves the physical document and defines it in the database.
        /// Returns the ID of the new GEN_FILE row.
        /// !!Note that this only processes the first file in the foreach list!!
        /// </summary>
        public int RecordDocInDB(FileUploadStreamResult result)
        {

            using (var db = new CSET_Context())
            {
                // Determine file type ID.  Store null if not known.
                int? fileType = null;

                foreach (var file in result.FileResultList)
                {
                    var type = db.FILE_TYPE.Where(x => x.Mime_Type == file.ContentType).FirstOrDefault();
                    if (type != null)
                    {
                        fileType = (int)type.File_Type_Id;
                    }


                    GEN_FILE gf = new GEN_FILE
                    {
                        File_Name = file.FileName,
                        Title = "(no title)",
                        File_Type_Id = fileType,
                        File_Size = file.FileSize,
                        Doc_Num = "NONE",
                        Short_Name = "(no short name)",
                        Data = file.FileBytes
                    };
                    db.GEN_FILE.Add(gf);
                    db.SaveChanges();


                    SET_FILES sf = new SET_FILES
                    {
                        SetName = result.FormNameValues["setName"],
                        Gen_File_Id = gf.Gen_File_Id
                    };
                    db.SET_FILES.Add(sf);
                    db.SaveChanges();

                    return gf.Gen_File_Id;
                }
                return 0;
            }
        }
    }
}
