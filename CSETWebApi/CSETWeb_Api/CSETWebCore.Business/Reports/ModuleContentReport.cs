//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.ModuleBuilder;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Question;
using CSETWebCore.Model.Set;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using CSETWebCore.Business.GalleryParser;

namespace CSETWebCore.Business.Reports
{
    public class ModuleContentReport
    {
        private CSETContext _context;
        private readonly IQuestionRequirementManager _question;
        private readonly IGalleryEditor _gallery;

        /// <summary>
        /// The user's language
        /// </summary>
        private string _lang;


        public ModuleContentReport(CSETContext context, IQuestionRequirementManager question, IGalleryEditor gallery)
        {
            _context = context;
            _question = question;
            _gallery = gallery;
            _lang = "en";
        }

        /// <summary>
        /// Sets the user language for the report.
        /// </summary>
        /// <param name="lang"></param>
        public void SetLanguage(string lang)
        {
            _lang = lang;
        }


        /// <summary>
        /// 
        /// </summary>
        public ModuleResponse GetResponse(string set)
        {
            var mbb = new ModuleBuilderBusiness(_context, _question, _gallery);
            mbb.SetLanguage(_lang);
            var resp = mbb.GetModuleStructure(set);

            IncludeSourceFiles(resp, set);

            IncludeResourceFiles(resp, set);

            return resp;
        }

        private void IncludeSourceFiles(ModuleResponse module, string set)
        {
            var q = from nr in _context.NEW_REQUIREMENT
                    join rsf in _context.REQUIREMENT_REFERENCES on nr.Requirement_Id equals rsf.Requirement_Id
                    join rqs in _context.REQUIREMENT_QUESTIONS_SETS on nr.Requirement_Id equals rqs.Requirement_Id
                    join gf in _context.GEN_FILE on rsf.Gen_File_Id equals gf.Gen_File_Id
                    where rqs.Set_Name == set && rsf.Source
                    select new { rsf, gf };

            var gggg = q.Distinct().ToList();

            foreach (var cat in module.Categories)
            {
                foreach (var subcat in cat.Subcategories)
                {
                    foreach (var req in subcat.Requirements)
                    {
                        var sourceLinks = gggg.Where(x => x.rsf.Requirement_Id == req.RequirementID).ToList();
                        foreach (var link in sourceLinks)
                        {
                            req.SourceDocs.Add(new ReferenceDoc
                            {
                                SectionRef = link.rsf.Section_Ref,
                                ID = link.gf.Gen_File_Id,
                                Title = link.gf.Title,
                                Name = link.gf.Name,
                                ShortName = link.gf.Short_Name,
                                FileName = link.gf.File_Name,
                                DocumentNumber = link.gf.Doc_Num,
                                DocumentVersion = link.gf.Doc_Version,
                                PublishDate = link.gf.Publish_Date,
                                Summary = link.gf.Summary,
                                Description = link.gf.Description,
                                Comments = link.gf.Comments,
                            });
                        }
                    }
                }
            }
        }

        private void IncludeResourceFiles(ModuleResponse module, string set)
        {
            var q = from nr in _context.NEW_REQUIREMENT
                    join rsf in _context.REQUIREMENT_REFERENCES on nr.Requirement_Id equals rsf.Requirement_Id
                    join rqs in _context.REQUIREMENT_QUESTIONS_SETS on nr.Requirement_Id equals rqs.Requirement_Id
                    join gf in _context.GEN_FILE on rsf.Gen_File_Id equals gf.Gen_File_Id
                    where rqs.Set_Name == set
                    select new { rsf, gf };

            var gggg = q.Distinct().ToList();

            foreach (var cat in module.Categories)
            {
                foreach (var subcat in cat.Subcategories)
                {
                    foreach (var req in subcat.Requirements)
                    {
                        var sourceLinks = gggg.Where(x => x.rsf.Requirement_Id == req.RequirementID).ToList();
                        foreach (var link in sourceLinks)
                        {
                            req.AdditionalDocs.Add(new ReferenceDoc
                            {
                                SectionRef = link.rsf.Section_Ref,
                                ID = link.gf.Gen_File_Id,
                                Title = link.gf.Title,
                                Name = link.gf.Name,
                                ShortName = link.gf.Short_Name,
                                FileName = link.gf.File_Name,
                                DocumentNumber = link.gf.Doc_Num,
                                DocumentVersion = link.gf.Doc_Version,
                                PublishDate = link.gf.Publish_Date,
                                Summary = link.gf.Summary,
                                Description = link.gf.Description,
                                Comments = link.gf.Comments,
                            });
                        }
                    }
                }
            }
        }
    }
}
