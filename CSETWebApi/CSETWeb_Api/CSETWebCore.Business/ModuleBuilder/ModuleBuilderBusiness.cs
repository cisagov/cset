//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Text.RegularExpressions;
using CSETWebCore.Business.GalleryParser;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Helpers;
using CSETWebCore.Interfaces.ModuleBuilder;
using CSETWebCore.Interfaces.Question;
using CSETWebCore.Model.Document;
using CSETWebCore.Model.Set;
using DocumentFormat.OpenXml.Drawing.Charts;
using J2N.Text;
using Microsoft.EntityFrameworkCore;

namespace CSETWebCore.Business.ModuleBuilder
{
    public class ModuleBuilderBusiness : IModuleBuilderBusiness
    {
        private CSETContext _context;
        private readonly IQuestionRequirementManager _question;
        private readonly IGalleryEditor _galleryEditor;
        private string _lang;
        private readonly TranslationOverlay _overlay;


        /// <summary>
        /// 
        /// </summary>
        public ModuleBuilderBusiness(CSETContext context, IQuestionRequirementManager question, IGalleryEditor galleryEditor)
        {
            _context = context;
            _question = question;
            _galleryEditor = galleryEditor;
            _lang = "en";

            _overlay = new TranslationOverlay();
        }


        public void SetLanguage(string lang)
        {
            _lang = lang;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public List<SetDetail> GetCustomSetList(bool includeNonCustom = false)
        {
            List<SetDetail> list = new List<SetDetail>();

            var s = _context.SETS
                .Where(x => x.Is_Custom || includeNonCustom)
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
                    IsDisplayed = set.Is_Displayed,

                    Clonable = true,
                    Deletable = true
                };

                list.Add(sr);
            }

            return list;
        }


        /// <summary>
        /// Gets the full list of sets that are being used in an assessment.
        /// </summary>
        public List<SetDetail> GetSetsInUseList()
        {
            List<AVAILABLE_STANDARDS> selectedStandards = _context.AVAILABLE_STANDARDS.Where(x => x.Selected).ToList();

            return GetCustomSetList(true).FindAll(x => selectedStandards.Exists(y => y.Set_Name == x.SetName));
        }


        /// <summary>
        /// 
        /// </summary>
        public void SetBaseSets(String setName, string[] setNames)
        {
            try
            {
                _context.usp_CopyIntoSet_Delete(setName);
                foreach (string sourceSet in setNames)
                {
                    _context.usp_CopyIntoSet(sourceSet, setName);
                }
            }
            catch (Exception exc)
            {
                NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");

                throw;
            }

        }

        public List<String> GetBaseSets(string customSetName)
        {

            var list = from a in _context.CUSTOM_STANDARD_BASE_STANDARD
                       where a.Custom_Questionaire_Name == customSetName
                       select a.Base_Standard;

            return list.ToList<string>();

        }
        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public List<SetDetail> GetNonCustomSetList(string exceptionList)
        {

            List<SetDetail> list = new List<SetDetail>();

            var s = _context.SETS
                .Where(x => !x.Is_Deprecated)
                .Where(x => x.Set_Name != exceptionList)
                .Where(x => x.Set_Name != "Components" && x.Set_Name != "Standards")
                .Where(x => x.Is_Displayed == true)
                .OrderBy(x => x.Short_Name)
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
                    IsDisplayed = set.Is_Displayed,

                    Clonable = true,
                    Deletable = false
                };

                list.Add(sr);
            }

            return list;

        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="setName"></param>
        public SetDetail GetSetDetail(string setName)
        {

            var dbSet = _context.SETS.Where(x => x.Set_Name == setName).FirstOrDefault();

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
            var setsCategories = _context.SETS_CATEGORY.ToList();
            foreach (SETS_CATEGORY cat in setsCategories)
            {
                set.CategoryList.Add(new SetCategory(cat.Set_Category_Id, cat.Set_Category_Name));
            }

            return set;

        }

        public void AddCopyToSet(string sourceSetName, string destinationSetName)
        {

            _context.usp_CopyIntoSet(sourceSetName, destinationSetName);

        }

        public void DeleteCopyToSet(string setName)
        {
            _context.usp_CopyIntoSet_Delete(setName);
        }

        /// <summary>
        /// Copies the structure of an existing set into a new one.  
        /// </summary>
        public SetDetail CloneSet(string setName)
        {
            string newSetName = GenerateNewSetName();

            ModuleCloner cloner = new ModuleCloner(_context);
            SETS clonedSet = cloner.CloneModule(setName, newSetName);

            if (clonedSet != null)
            {
                // Add custom gallery card for newly cloned set
                string configSetup = "{Sets:[\"" + clonedSet.Set_Name + "\"],SALLevel:\"Low\",QuestionMode:\"Questions\"}";

                var custom = _context.GALLERY_GROUP.Where(x => x.Group_Title.Equals("Custom")).FirstOrDefault();
                int colIndex = 0;
                if (custom != null)
                {
                    var colIndexList = _context.GALLERY_GROUP_DETAILS.Where(x => x.Group_Id.Equals(custom.Group_Id)).ToList();

                    if (colIndexList != null)
                    {
                        colIndex = colIndexList.Count;
                    }
                }

                _galleryEditor.AddGalleryItem("", "", clonedSet.Standard_ToolTip, clonedSet.Full_Name, configSetup, custom.Group_Id, colIndex);

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

            var dbSet = _context.SETS.Where(x => x.Set_Name == setName).FirstOrDefault();

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
            var query = from req in _context.NEW_REQUIREMENT
                        join rs in _context.REQUIREMENT_SETS on req.Requirement_Id equals rs.Requirement_Id
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
            query = from req in _context.NEW_REQUIREMENT
                    join rs in _context.REQUIREMENT_SETS on req.Requirement_Id equals rs.Requirement_Id
                    where rs.Set_Name == setName
                    select req;

            foreach (NEW_REQUIREMENT r in query.ToList())
            {
                _context.NEW_REQUIREMENT.Remove(r);
            }
            _context.SaveChanges();


            // Delete any questions that were created for this set.
            var queryQ = _context.NEW_QUESTION.Where(x => x.Original_Set_Name == setName);
            foreach (NEW_QUESTION q in queryQ.ToList())
            {
                _context.NEW_QUESTION.Remove(q);
            }
            _context.SaveChanges();


            // This should cascade delete everything else (except the Gallery card stuff)
            _context.SETS.Remove(dbSet);

            // Now to remove the Gallery Item and card. This gets the guid for the item / card.
            // Currently any custom SET will have a one-to-one relationship with a GALLERY_ITEM, so we can look for it
            // in the cards' config setup.
            var cardInfo = _context.GALLERY_ITEM.Where(x => x.Configuration_Setup.Contains($"[\"{setName}\"]")).FirstOrDefault();

            if (cardInfo != null)
            {
                _context.GALLERY_ITEM.Remove(cardInfo);
            }

            _context.SaveChanges();
            return resp;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="set"></param>
        /// <returns></returns>
        public string SaveSetDetail(SetDetail set)
        {
            if (string.IsNullOrEmpty(set.FullName))
            {
                set.FullName = "(untitled set)";
            }

            if (string.IsNullOrEmpty(set.ShortName))
            {
                set.ShortName = "";
            }

            string gallDescription = set.Description;

            if (string.IsNullOrEmpty(set.Description))
            {
                gallDescription = "";
            }

            // Add or update the SETS record
            var dbSet = _context.SETS.Where(x => x.Set_Name == set.SetName).FirstOrDefault();
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

                _context.SETS.Add(dbSet);

                string configSetup = "{Sets:[\"" + set.SetName + "\"],SALLevel:\"Low\",QuestionMode:\"Questions\"}";

                var custom = _context.GALLERY_GROUP.Where(x => x.Group_Title.Equals("Custom")).FirstOrDefault();
                int colIndex = 0;
                if (custom != null)
                {
                    var colIndexList = _context.GALLERY_GROUP_DETAILS.Where(x => x.Group_Id.Equals(custom.Group_Id)).ToList();

                    if (colIndexList != null)
                    {
                        colIndex = colIndexList.Count;
                    }
                }

                _galleryEditor.AddGalleryItem("", "", gallDescription, set.FullName, configSetup, custom.Group_Id, colIndex);

            }
            else
            {
                var originalSet = dbSet;
                dbSet.Full_Name = set.FullName;
                dbSet.Short_Name = set.ShortName;
                dbSet.Standard_ToolTip = set.Description;
                dbSet.Set_Category_Id = set.SetCategory == 0 ? null : set.SetCategory;
                dbSet.Is_Custom = set.IsCustom;
                dbSet.Is_Displayed = set.IsDisplayed;

                var gallItem = _context.GALLERY_ITEM.Where(x => x.Configuration_Setup.Contains($"[\"{originalSet.Set_Name}\"]")).FirstOrDefault();

                gallItem.Description = gallDescription;
                gallItem.Title = dbSet.Full_Name;

                _context.SETS.Update(dbSet);
                _context.SaveChanges();

                _context.GALLERY_ITEM.Update(gallItem);
            }

            _context.SaveChanges();

            return set.SetName;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public string GenerateNewSetName()
        {
            return "SET." + DateTime.Now.ToString("yyyyMMdd.HHmmss");
        }


        /// <summary>
        /// 
        /// </summary>
        public QuestionListResponse GetQuestionsForSet(string setName)
        {
            List<NEW_QUESTION_SETS> dbQuestions = _context.NEW_QUESTION_SETS
                .Include(x => x.Question)
                .Where(x => x.Set_Name == setName).ToList();

            List<QuestionDetail> response = new List<QuestionDetail>();
            foreach (NEW_QUESTION_SETS nqs in dbQuestions)
            {
                QuestionDetail q = new QuestionDetail();
                q.QuestionID = nqs.Question.Question_Id;
                q.QuestionText = nqs.Question.Simple_Question;
                PopulateCategorySubcategory(nqs.Question.Heading_Pair_Id, _context,
                    out string qgh, out int pi, out string subcat1, out string subhead);

                q.QuestionGroupHeading = qgh;
                q.PairID = pi;
                q.Subcategory = subcat1;
                q.SubHeading = subhead;

                q.Title = GetTitle(nqs.Question.Question_Id, _context);

                // Look at the question's original set to determine if the question is 'custom' and can be edited
                q.IsCustom = _context.SETS.Where(x => x.Set_Name == nqs.Question.Original_Set_Name).FirstOrDefault().Is_Custom;


                // Get the SAL levels for this question-set
                var sals = _context.NEW_QUESTION_LEVELS.Where(l => l.New_Question_Set_Id == nqs.New_Question_Set_Id).ToList();
                foreach (NEW_QUESTION_LEVELS l in sals)
                {
                    q.SalLevels.Add(l.Universal_Sal_Level);
                }

                response.Add(q);
            }

            List<QuestionDetail> list = response.OrderBy(x => x.QuestionGroupHeading).ThenBy(x => x.Subcategory).ThenBy(x => x.PairID).ToList();

            List<int> customPairingsForThisSet = _context.UNIVERSAL_SUB_CATEGORY_HEADINGS
                .Where(x => x.Set_Name == setName).Select(x => x.Heading_Pair_Id).ToList();

            QuestionListResponse ql = new QuestionListResponse();

            var set = _context.SETS.Where(x => x.Set_Name == setName).FirstOrDefault();
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


        /// <summary>
        /// Gets any questions originated by the specified set 
        /// that are being used by other sets.
        /// </summary>
        /// <param name="setName"></param>
        /// <returns></returns>
        public List<int> GetMyQuestionsUsedByOtherSets(string setName)
        {

            var query = from nqs in _context.NEW_QUESTION_SETS
                        join question in _context.NEW_QUESTION on nqs.Question_Id equals question.Question_Id
                        where question.Original_Set_Name == setName && nqs.Set_Name != setName
                        select question;
            List<int> qList = new List<int>();
            foreach (var q in query)
            {
                qList.Add(q.Question_Id);
            }
            return qList;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name=""></param>
        /// <returns></returns>
        public void PopulateCategorySubcategory(int headingPairId, CSETContext db, out string cat,
            out int pairID, out string subcat, out string subheading)
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
        public string GetTitle(int questionId, CSETContext db)
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
            return (_context.NEW_QUESTION.Where(q => q.Simple_Question == questionText).Count() > 0);
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

            // get the max Std_Ref_Number for the std_ref
            int newStdRefNum = 1;
            var fellowQuestions = _context.NEW_QUESTION.Where(x => x.Std_Ref == request.SetName).ToList();
            if (fellowQuestions.Count > 0)
            {
                newStdRefNum = fellowQuestions.Max(x => x.Std_Ref_Number) + 1;
            }




            NEW_QUESTION q = new NEW_QUESTION
            {
                Simple_Question = request.CustomQuestionText,
                Std_Ref = request.SetName,
                Std_Ref_Number = newStdRefNum,

                Universal_Sal_Level = "L",
                Weight = 0,
                Original_Set_Name = request.SetName,
                Heading_Pair_Id = GetHeadingPair(request.QuestionCategoryID, request.QuestionSubcategoryText, request.SetName)
            };

            _context.NEW_QUESTION.Add(q);
            _context.SaveChanges();


            if (request.RequirementID > 0)
            {
                // Add question to requirement
                REQUIREMENT_QUESTIONS_SETS rqs = new REQUIREMENT_QUESTIONS_SETS
                {
                    Question_Id = q.Question_Id,
                    Set_Name = request.SetName,
                    Requirement_Id = request.RequirementID
                };

                _context.REQUIREMENT_QUESTIONS_SETS.Add(rqs);


                //REQUIREMENT_QUESTIONS rq = new REQUIREMENT_QUESTIONS
                //{
                //    Question_Id = q.Question_Id,
                //    Requirement_Id = request.RequirementID
                //};

                //_context.REQUIREMENT_QUESTIONS.Add(rq);
            }


            // Add question to set
            NEW_QUESTION_SETS nqs = new NEW_QUESTION_SETS
            {
                Question_Id = q.Question_Id,
                Set_Name = request.SetName
            };

            _context.NEW_QUESTION_SETS.Add(nqs);

            _context.SaveChanges();


            // Define SALs
            foreach (string level in request.SalLevels)
            {
                NEW_QUESTION_LEVELS nql = new NEW_QUESTION_LEVELS
                {
                    New_Question_Set_Id = nqs.New_Question_Set_Id,
                    Universal_Sal_Level = level
                };

                _context.NEW_QUESTION_LEVELS.Add(nql);
            }

            _context.SaveChanges();
        }


        /// <summary>
        /// Adds an existing question to a set or requirement.
        /// </summary>
        /// <param name="request"></param>
        public void AddQuestion(SetQuestion request)
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

                _context.REQUIREMENT_QUESTIONS_SETS.Add(rqs);


                //REQUIREMENT_QUESTIONS rq = new REQUIREMENT_QUESTIONS
                //{
                //    Question_Id = request.QuestionID,
                //    Requirement_Id = request.RequirementID
                //};

                //_context.REQUIREMENT_QUESTIONS.Add(rq);


                _context.SaveChanges();
            }


            // Attach this question to the Set
            NEW_QUESTION_SETS nqs = new NEW_QUESTION_SETS
            {
                Question_Id = request.QuestionID,
                Set_Name = request.SetName
            };

            _context.NEW_QUESTION_SETS.Add(nqs);
            _context.SaveChanges();


            // SAL levels
            var nqls = _context.NEW_QUESTION_LEVELS.Where(l => l.New_Question_Set_Id == nqs.New_Question_Set_Id);
            foreach (NEW_QUESTION_LEVELS l in nqls)
            {
                _context.NEW_QUESTION_LEVELS.Remove(l);
            }
            _context.SaveChanges();

            foreach (string l in request.SalLevels)
            {
                NEW_QUESTION_LEVELS nql = new NEW_QUESTION_LEVELS
                {
                    New_Question_Set_Id = nqs.New_Question_Set_Id,
                    Universal_Sal_Level = l
                };

                _context.NEW_QUESTION_LEVELS.Add(nql);
            }
            _context.SaveChanges();
        }


        /// <summary>
        /// Detaches the specified question from the Set or Requirement.
        /// </summary>
        /// <param name="request"></param>
        public void RemoveQuestion(SetQuestion request)
        {
            if (request.RequirementID != 0)
            {
                // Requirement-related question
                var rqs = _context.REQUIREMENT_QUESTIONS_SETS
                    .Where(x => x.Set_Name == request.SetName && x.Question_Id == request.QuestionID)
                    .FirstOrDefault();
                if (rqs != null)
                {
                    _context.REQUIREMENT_QUESTIONS_SETS.Remove(rqs);
                }

                //var rq = _context.REQUIREMENT_QUESTIONS
                //    .Where(x => x.Question_Id == request.QuestionID && x.Requirement_Id == request.RequirementID)
                //    .FirstOrDefault();
                //if (rq != null)
                //{
                //    _context.REQUIREMENT_QUESTIONS.Remove(rq);
                //}
            }

            // Set-level question
            var nqs = _context.NEW_QUESTION_SETS
                .Where(x => x.Set_Name == request.SetName && x.Question_Id == request.QuestionID)
                .FirstOrDefault();
            if (nqs != null)
            {
                _context.NEW_QUESTION_SETS.Remove(nqs);
            }

            _context.SaveChanges();
        }


        /// <summary>
        /// Finds or creates a set-specific UNIVERSAL_SUB_CATEGORY_HEADING
        /// for the category/subcategory/set.
        /// </summary>
        /// <returns></returns>
        public int GetHeadingPair(int categoryId, string subcatText, string setName)
        {
            int subcatID = 0;

            // Either find or create the subcategory
            var subcat = _context.UNIVERSAL_SUB_CATEGORIES.Where(x => x.Universal_Sub_Category == subcatText).FirstOrDefault();
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
                _context.UNIVERSAL_SUB_CATEGORIES.Add(sc);
                _context.SaveChanges();

                subcatID = sc.Universal_Sub_Category_Id;
            }

            // See if this pairing exists (regardless of the set name)
            var usch = _context.UNIVERSAL_SUB_CATEGORY_HEADINGS
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
            _context.UNIVERSAL_SUB_CATEGORY_HEADINGS.Add(usch);
            _context.SaveChanges();

            return usch.Heading_Pair_Id;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public List<CategoryEntry> GetStandardCategories()
        {
            List<CategoryEntry> categoryList = new List<CategoryEntry>();

            var standardCategories = _context.STANDARD_CATEGORY.ToList();
            foreach (var c in standardCategories)
            {
                CategoryEntry entry = new CategoryEntry
                {
                    Text = c.Standard_Category1
                };
                categoryList.Add(entry);
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

            var categories = _context.QUESTION_GROUP_HEADING.Select(q => new CategoryEntry { Text = q.Question_Group_Heading1, ID = q.Question_Group_Heading_Id }).ToList();
            response.Categories = categories;

            var subcategories = _context.UNIVERSAL_SUB_CATEGORIES.Select(u => new CategoryEntry { Text = u.Universal_Sub_Category, ID = u.Universal_Sub_Category_Id }).ToList();
            response.Subcategories = subcategories;

            var groupHeadings = _context.QUESTION_GROUP_HEADING.Where(x => x.Universal_Weight != 0).Select(q => new CategoryEntry { Text = q.Question_Group_Heading1, ID = q.Question_Group_Heading_Id }).ToList();
            response.GroupHeadings = groupHeadings;

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


            // Build a list of all questionIDs that are currently in the set
            List<int> includedQuestions = _context.NEW_QUESTION_SETS.Where(x => x.Set_Name == searchParms.SetName)
                .Select(q => q.Question_Id).ToList();


            // First, look for an exact string match within the question
            var hits = from q in _context.NEW_QUESTION
                       join usch in _context.UNIVERSAL_SUB_CATEGORY_HEADINGS on q.Heading_Pair_Id equals usch.Heading_Pair_Id
                       join qgh in _context.QUESTION_GROUP_HEADING on usch.Question_Group_Heading_Id equals qgh.Question_Group_Heading_Id
                       join subcat in _context.UNIVERSAL_SUB_CATEGORIES on usch.Universal_Sub_Category_Id equals subcat.Universal_Sub_Category_Id
                       where q.Simple_Question.Contains(searchParms.SearchTerms)
                       select new { q, qgh, subcat };

            foreach (var hit in hits.ToList())
            {
                if (!includedQuestions.Contains(hit.q.Question_Id) && !IsTextEncrypted(hit.q.Simple_Question))
                {
                    QuestionDetail candidate = new QuestionDetail
                    {
                        QuestionID = hit.q.Question_Id,
                        QuestionText = hit.q.Simple_Question,
                        QuestionGroupHeading = hit.qgh.Question_Group_Heading1,
                        Subcategory = hit.subcat.Universal_Sub_Category,
                    };

                    // Get the default SAL levels as defined in the question's original set
                    var sals = from nqs in _context.NEW_QUESTION_SETS
                               join nql in _context.NEW_QUESTION_LEVELS on nqs.New_Question_Set_Id equals nql.New_Question_Set_Id
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

            var hits2 = _context.NEW_QUESTION.FromSqlRaw("SELECT * FROM [NEW_QUESTION] where " + whereClause).ToList();

            var hits3 = from q in hits2
                        join usch in _context.UNIVERSAL_SUB_CATEGORY_HEADINGS on q.Heading_Pair_Id equals usch.Heading_Pair_Id
                        join cat in _context.QUESTION_GROUP_HEADING on usch.Question_Group_Heading_Id equals cat.Question_Group_Heading_Id
                        join subcat in _context.UNIVERSAL_SUB_CATEGORIES on usch.Universal_Sub_Category_Id equals subcat.Universal_Sub_Category_Id
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
                            QuestionText = hit.q.Simple_Question,
                            QuestionGroupHeading = hit.cat.Question_Group_Heading1,
                            Subcategory = hit.subcat.Universal_Sub_Category
                        });
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
        public void SetRequirementSalLevel(SalParms salParms)
        {
            REQUIREMENT_LEVELS level = _context.REQUIREMENT_LEVELS.Where(x => x.Requirement_Id == salParms.RequirementID
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
                    _context.REQUIREMENT_LEVELS.Add(level);
                    _context.SaveChanges();
                }
            }
            else
            {
                // remove the level
                if (level != null)
                {
                    _context.REQUIREMENT_LEVELS.Remove(level);
                    _context.SaveChanges();
                }
            }
        }


        /// <summary>
        /// Sets or removes a single SAL level for a question.
        /// </summary>
        /// <param name="salParms"></param>
        public void SetQuestionSalLevel(SalParms salParms)
        {

            NEW_QUESTION_SETS nqs = _context.NEW_QUESTION_SETS.Where(x => x.Question_Id == salParms.QuestionID && x.Set_Name == salParms.SetName).FirstOrDefault();

            NEW_QUESTION_LEVELS nql = _context.NEW_QUESTION_LEVELS.Where(x =>
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
                    _context.NEW_QUESTION_LEVELS.Add(nql);
                    _context.SaveChanges();
                }
            }
            else
            {
                // remove the level
                if (nql != null)
                {
                    _context.NEW_QUESTION_LEVELS.Remove(nql);
                    _context.SaveChanges();
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

            // is this a custom question?
            var query = from q in _context.NEW_QUESTION
                        join s in _context.SETS on q.Original_Set_Name equals s.Set_Name
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
                var question = _context.NEW_QUESTION.Where(x => x.Question_Id == questionID).FirstOrDefault();
                if (question == null)
                {
                    resp.ErrorMessages.Add("Question ID is not defined");
                    return resp;
                }

                question.Simple_Question = text;

                _context.NEW_QUESTION.Update(question);
                _context.SaveChanges();

                return resp;
            }
            catch (Microsoft.EntityFrameworkCore.DbUpdateException)
            {
                resp.ErrorMessages.Add("DUPLICATE QUESTION TEXT");
                return resp;
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
            if (_context.NEW_QUESTION_SETS.Where(x => x.Question_Id == questionID).Count() > 1)
            {
                return true;
            }

            if (_context.ANSWER.Where(x => x.Question_Or_Requirement_Id == questionID).Count() > 0)
            {
                return true;
            }

            return false;
        }


        /// <summary>
        /// Updates the question text.  Only questions originally attached
        /// to a 'custom' set can have their text updated.
        /// </summary>
        public void UpdateHeadingText(int pairID, string text)
        {
            var usch = _context.UNIVERSAL_SUB_CATEGORY_HEADINGS.Where(x => x.Heading_Pair_Id == pairID).FirstOrDefault();

            if (usch == null)
            {
                return;
            }

            usch.Sub_Heading_Question_Description = string.IsNullOrEmpty(text) ? null : text;
            _context.UNIVERSAL_SUB_CATEGORY_HEADINGS.Update(usch);
            _context.SaveChanges();
        }


        /// <summary>
        /// Try to determine if this an encrypted question.
        /// </summary>
        /// <param name="text"></param>
        /// <returns></returns>
        public bool IsTextEncrypted(string text)
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

            var set = _context.SETS.Where(x => x.Set_Name == setName).FirstOrDefault();
            response.SetFullName = set.Full_Name;
            response.SetShortName = set.Short_Name;
            response.SetDescription = set.Standard_ToolTip;


            var q = from rs in _context.REQUIREMENT_SETS
                    from s in _context.SETS.Where(x => x.Set_Name == rs.Set_Name)
                    from r in _context.NEW_REQUIREMENT.Where(x => x.Requirement_Id == rs.Requirement_Id)
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
                // overlay
                var translatedCategory = _overlay.GetPropertyValue("STANDARD_CATEGORY", rq.Standard_Category.ToLower(), _lang);
                if (translatedCategory != null)
                {
                    rq.Standard_Category = translatedCategory;
                }

                var translatedSubcat = _overlay.GetPropertyValue("STANDARD_CATEGORY", rq.Standard_Sub_Category.ToLower(), _lang);
                if (translatedSubcat != null)
                {
                    rq.Standard_Sub_Category = translatedSubcat;
                }

                Requirement r = new Requirement()
                {
                    RequirementID = rq.Requirement_Id,
                    Title = rq.Requirement_Title,
                    RequirementText = rq.Requirement_Text,
                    SupplementalInfo = rq.Supplemental_Info
                };

                // overlay
                var reqOverlay = _overlay.GetRequirement(r.RequirementID, _lang);
                if (reqOverlay != null)
                {
                    r.RequirementText = reqOverlay.RequirementText;
                    r.SupplementalInfo = reqOverlay.SupplementalInfo;
                }

                // Get the SAL levels for this requirement
                var sals = _context.REQUIREMENT_LEVELS.Where(l => l.Requirement_Id == rq.Requirement_Id).ToList();
                foreach (REQUIREMENT_LEVELS l in sals)
                {
                    r.SalLevels.Add(l.Standard_Level);
                }


                // Get the questions for this requirement
                var relatedQuestions = _context.REQUIREMENT_QUESTIONS_SETS
                    .Include(x => x.Question)
                    .Where(x => x.Requirement_Id == r.RequirementID && x.Set_Name == setName).ToList();

                foreach (var q1 in relatedQuestions)
                {
                    r.Questions.Add(new QuestionDetail()
                    {
                        QuestionID = q1.Question_Id,
                        QuestionText = q1.Question.Simple_Question,
                        IsCustom = _context.SETS.Where(x => x.Set_Name == q1.Question.Original_Set_Name).FirstOrDefault().Is_Custom
                    });
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

            return response;
        }


        /// <summary>
        /// Creates a NEW_REQUIREMENT record for the set.  Creates new category/subcategory records as needed.
        /// </summary>
        /// <param name="parms"></param>
        public Requirement CreateRequirement(Requirement parms)
        {
            // Create the category if not already defined
            var existingCategory = _context.STANDARD_CATEGORY.Where(x => x.Standard_Category1 == parms.Category).FirstOrDefault();
            if (existingCategory == null)
            {
                STANDARD_CATEGORY newCategory = new STANDARD_CATEGORY()
                {
                    Standard_Category1 = parms.Category
                };
                _context.STANDARD_CATEGORY.Add(newCategory);
            }

            // Create the subcategory if not already defined
            var existingSubcategory = _context.UNIVERSAL_SUB_CATEGORIES.Where(x => x.Universal_Sub_Category == parms.Subcategory).FirstOrDefault();
            if (existingSubcategory == null)
            {
                UNIVERSAL_SUB_CATEGORIES newSubcategory = new UNIVERSAL_SUB_CATEGORIES()
                {
                    Universal_Sub_Category = parms.Subcategory
                };
                _context.UNIVERSAL_SUB_CATEGORIES.Add(newSubcategory);
            }

            _context.SaveChanges();


            NEW_REQUIREMENT req = new NEW_REQUIREMENT
            {
                Requirement_Title = parms.Title == null ? "" : parms.Title.Trim().Truncate(250),
                Requirement_Text = parms.RequirementText.Trim(),
                Standard_Category = parms.Category.Trim().Truncate(250),
                Standard_Sub_Category = parms.Subcategory == null ? "" : parms.Subcategory.Trim().Truncate(250),
                Question_Group_Heading_Id = parms.QuestionGroupHeadingID,
                Original_Set_Name = parms.SetName.Truncate(50)
            };

            _context.NEW_REQUIREMENT.Add(req);
            _context.SaveChanges();

            parms.RequirementID = req.Requirement_Id;


            // Determine a new sequence number
            int sequence = 1;
            var seqList = _context.REQUIREMENT_SETS
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

            _context.REQUIREMENT_SETS.Add(rs);
            _context.SaveChanges();

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
            var q = from rs in _context.REQUIREMENT_SETS
                    from s in _context.SETS.Where(x => x.Set_Name == rs.Set_Name)
                    from r in _context.NEW_REQUIREMENT.Where(x => x.Requirement_Id == rs.Requirement_Id)
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
            var sals = _context.REQUIREMENT_LEVELS.Where(l => l.Requirement_Id == requirement.RequirementID).ToList();
            foreach (REQUIREMENT_LEVELS l in sals)
            {
                requirement.SalLevels.Add(l.Standard_Level);
            }


            // Get the Reference documents for this requirement
            var allDocs = GetReferencesForRequirement(requirement.RequirementID);
            requirement.SourceDocs = allDocs.SourceDocs;
            requirement.AdditionalDocs = allDocs.AdditionalDocs;



            // Get the questions for this requirement
            var relatedQuestions = _context.REQUIREMENT_QUESTIONS_SETS
                .Include(x => x.Question)
                .Where(x => x.Requirement_Id == requirement.RequirementID && x.Set_Name == setName).ToList();

            foreach (var q1 in relatedQuestions)
            {
                requirement.Questions.Add(new QuestionDetail()
                {
                    QuestionID = q1.Question_Id,
                    QuestionText = q1.Question.Simple_Question,
                    IsCustom = _context.SETS.Where(x => x.Set_Name == q1.Question.Original_Set_Name).FirstOrDefault().Is_Custom
                });
            }

            return requirement;
        }


        /// <summary>
        /// Returns two lists -- reference documents that are 'source' 
        /// and 'resource'.
        /// </summary>
        /// <param name="reqID"></param>
        /// <returns></returns>
        public ReferenceDocLists GetReferencesForRequirement(int reqID)
        {
            // Get all "source" documents
            List<ReferenceDoc> sourceList = new List<ReferenceDoc>();
            var sources = _context.REQUIREMENT_REFERENCES
                .Include(x => x.Gen_File)
                .Where(x => x.Requirement_Id == reqID && x.Source).ToList();
            foreach (REQUIREMENT_REFERENCES reff in sources)
            {
                sourceList.Add(new ReferenceDoc
                {
                    SectionRef = reff.Section_Ref,
                    ID = reff.Gen_File_Id,
                    Title = reff.Gen_File.Title,
                    Name = reff.Gen_File.Name,
                    ShortName = reff.Gen_File.Short_Name,
                    FileName = reff.Gen_File.File_Name,
                    DocumentNumber = reff.Gen_File.Doc_Num,
                    DocumentVersion = reff.Gen_File.Doc_Version,
                    PublishDate = reff.Gen_File.Publish_Date,
                    Summary = reff.Gen_File.Summary,
                    Description = reff.Gen_File.Description,
                    Comments = reff.Gen_File.Comments,
                });
            }

            // Get all "resource" documents
            List<ReferenceDoc> resourceList = new List<ReferenceDoc>();
            var resources = _context.REQUIREMENT_REFERENCES
                .Include(x => x.Gen_File)
                .Where(x => x.Requirement_Id == reqID && !x.Source).ToList();
            foreach (REQUIREMENT_REFERENCES reff in resources)
            {
                resourceList.Add(new ReferenceDoc
                {
                    SectionRef = reff.Section_Ref,
                    ID = reff.Gen_File_Id,
                    Title = reff.Gen_File.Title,
                    Name = reff.Gen_File.Name,
                    ShortName = reff.Gen_File.Short_Name,
                    FileName = reff.Gen_File.File_Name,
                    DocumentNumber = reff.Gen_File.Doc_Num,
                    DocumentVersion = reff.Gen_File.Doc_Version,
                    PublishDate = reff.Gen_File.Publish_Date,
                    Summary = reff.Gen_File.Summary,
                    Description = reff.Gen_File.Description,
                    Comments = reff.Gen_File.Comments,
                });
            }

            // Package the two lists together
            ReferenceDocLists response = new ReferenceDocLists();
            response.SourceDocs = sourceList;
            response.AdditionalDocs = resourceList;
            return response;
        }


        /// <summary>
        /// Updates the NEW_REQUIREMENT record for the set.  Creates new category/subcategory records as needed.
        /// </summary>
        /// <param name="parms"></param>
        public Requirement UpdateRequirement(Requirement parms)
        {
            // Create the category if not already defined
            var existingCategory = _context.STANDARD_CATEGORY.Where(x => x.Standard_Category1 == parms.Category).FirstOrDefault();
            if (existingCategory == null)
            {
                STANDARD_CATEGORY newCategory = new STANDARD_CATEGORY()
                {
                    Standard_Category1 = parms.Category
                };
                _context.STANDARD_CATEGORY.Add(newCategory);
            }

            // Create the subcategory if not already defined
            var existingSubcategory = _context.UNIVERSAL_SUB_CATEGORIES.Where(x => x.Universal_Sub_Category == parms.Subcategory).FirstOrDefault();
            if (existingSubcategory == null)
            {
                UNIVERSAL_SUB_CATEGORIES newSubcategory = new UNIVERSAL_SUB_CATEGORIES()
                {
                    Universal_Sub_Category = parms.Subcategory
                };
                _context.UNIVERSAL_SUB_CATEGORIES.Add(newSubcategory);
            }

            _context.SaveChanges();

            NEW_REQUIREMENT req = _context.NEW_REQUIREMENT.Where(x => x.Requirement_Id == parms.RequirementID).FirstOrDefault();
            req.Requirement_Title = parms.Title;
            req.Requirement_Text = parms.RequirementText;
            req.Standard_Category = parms.Category;
            req.Standard_Sub_Category = parms.Subcategory;
            req.Question_Group_Heading_Id = parms.QuestionGroupHeadingID;
            req.Original_Set_Name = parms.SetName;
            req.Supplemental_Info = parms.SupplementalInfo;


            _context.NEW_REQUIREMENT.Update(req);
            _context.SaveChanges();

            return parms;
        }


        /// <summary>
        /// Removes the NEW_REQUIREMENT record from the set.
        /// </summary>
        /// <param name="parms"></param>
        public void RemoveRequirement(Requirement parms)
        {
            var bridge = _context.REQUIREMENT_SETS.Where(x => x.Set_Name == parms.SetName && x.Requirement_Id == parms.RequirementID).FirstOrDefault();
            if (bridge == null)
            {
                return;
            }

            _context.REQUIREMENT_SETS.Remove(bridge);

            var req = _context.NEW_REQUIREMENT.Where(x => x.Requirement_Id == parms.RequirementID).FirstOrDefault();
            if (req == null)
            {
                return;
            }

            _context.NEW_REQUIREMENT.Remove(req);
            _context.SaveChanges();
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
            var genFileList = _context.GEN_FILE
                .Include(x => x.GEN_FILE_LIB_PATH_CORL)
                .Where(x => x.Title.Contains(filter)).ToList().OrderBy(x => x.Title).ToList();

            var selectedFiles = _context.SET_FILES.Where(x => x.SetName == setName).ToList().Select(y => y.Gen_File_Id);

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

            return list;
        }


        /// <summary>
        /// Returns the list of reference docs attached to the set. 
        /// </summary>
        /// <param name="setName"></param>
        /// <returns></returns>
        public List<ReferenceDoc> GetReferenceDocsForSet(string setName)
        {
            var query = from sf in _context.SET_FILES
                        join gf in _context.GEN_FILE on sf.Gen_File_Id equals gf.Gen_File_Id
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


        /// <summary>
        /// 
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public ReferenceDoc GetReferenceDocDetail(int id)
        {
            var dbDoc = _context.GEN_FILE.Where(x => x.Gen_File_Id == id).FirstOrDefault();
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


        /// <summary>
        /// 
        /// </summary>
        public void UpdateReferenceDocDetail(ReferenceDoc doc)
        {
            var dbDoc = _context.GEN_FILE.Where(x => x.Gen_File_Id == doc.ID).FirstOrDefault();
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

            _context.GEN_FILE.Update(dbDoc);
            _context.SaveChanges();
        }


        /// <summary>
        /// Creates or deletes the SET_FILE row tying the document to the set.
        /// </summary>
        public void SelectSetFile(SetFileSelection parms)
        {
            if (parms.Doc.Selected)
            {
                SET_FILES sf = new SET_FILES
                {
                    SetName = parms.SetName,
                    Gen_File_Id = parms.Doc.ID
                };
                _context.SET_FILES.Add(sf);
            }
            else
            {
                var setFile = _context.SET_FILES.Where(x => x.SetName == parms.SetName && x.Gen_File_Id == parms.Doc.ID).FirstOrDefault();
                _context.SET_FILES.Remove(setFile);
            }

            _context.SaveChanges();
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

            if (isSourceRef)
            {
                var reqref = _context.REQUIREMENT_REFERENCES
                        .Where(x => x.Requirement_Id == requirementId && x.Source && x.Gen_File_Id == docId && x.Section_Ref == bookmark).FirstOrDefault();

                if (add)
                {
                    if (reqref == null)
                    {
                        // Create a new one
                        reqref = new REQUIREMENT_REFERENCES()
                        {
                            Gen_File_Id = docId,
                            Requirement_Id = requirementId,
                            Section_Ref = bookmark.TrimStart('#'), 
                            Source = true
                        };
                        _context.REQUIREMENT_REFERENCES.Add(reqref);
                        _context.SaveChanges();
                    }
                }
                else
                {
                    // Delete reference
                    if (reqref != null)
                    {
                        _context.REQUIREMENT_REFERENCES.Remove(reqref);
                        _context.SaveChanges();
                    }
                }
            }
            else
            {
                var reqref = _context.REQUIREMENT_REFERENCES
                        .Where(x => x.Requirement_Id == requirementId && !x.Source && x.Gen_File_Id == docId && x.Section_Ref == bookmark).FirstOrDefault();

                if (add)
                {
                    if (reqref == null)
                    {
                        // Create a new one
                        reqref = new REQUIREMENT_REFERENCES
                        {
                            Gen_File_Id = docId,
                            Requirement_Id = requirementId,
                            Section_Ref = bookmark.TrimStart('#'),
                            Source = false
                        };
                        _context.REQUIREMENT_REFERENCES.Add(reqref);
                        _context.SaveChanges();
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
                        _context.REQUIREMENT_REFERENCES.Remove(reqref);
                        _context.SaveChanges();
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

            // Determine file type ID.  Store null if not known.
            int? fileType = null;

            foreach (var file in result.FileResultList)
            {
                var type = _context.FILE_TYPE.Where(x => x.Mime_Type == file.ContentType).FirstOrDefault();
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
                _context.GEN_FILE.Add(gf);
                _context.SaveChanges();


                SET_FILES sf = new SET_FILES
                {
                    SetName = result.FormNameValues["setName"],
                    Gen_File_Id = gf.Gen_File_Id
                };
                _context.SET_FILES.Add(sf);
                _context.SaveChanges();

                return gf.Gen_File_Id;
            }
            return 0;
        }
    }
}