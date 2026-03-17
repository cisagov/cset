using CSETWebCore.DataLayer.Model;
using Microsoft.EntityFrameworkCore;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;



namespace CSETWebCore.Business.Diagnostic
{
    /// <summary>
    /// Conducts a few integrity audits.  Designed for pre-release
    /// cleanup, not for day-to-day production use.
    /// </summary>
    public class DatabaseAuditor
    {
        private readonly CsetwebContext _context;

        private AuditResponse response = new();


        /// <summary>
        /// CTOR
        /// </summary>
        public DatabaseAuditor(CsetwebContext context)
        {
            _context = context;
        }


        /// <summary>
        /// 
        /// </summary>
        public object Run()
        {
            // look for sets with temp-sounding names
            AuditSets();

            // look for gallery_item that point to unknown sets
            AuditGallery();

            // look for requirements above 1,000,000, orphaned, etc.
            AuditRequirements();


            return response;
        }


        /// <summary>
        /// 
        /// </summary>
        public void AuditRequirements()
        {
            var rrr = _context.NEW_REQUIREMENT.Where(x => x.Requirement_Id >= 1000000).ToList();
            var l = rrr.Select(x => new ReqItem { RequirementId = x.Requirement_Id }).ToList();
            response.RequirementSections.Add(new ReqSection
            {
                AuditTitle = "Requirements With IDs Above 1 Million",
                Items = l
            });



            // look for requirements that have a weird original set name
            rrr = _context.NEW_REQUIREMENT.Where(x => x.Original_Set_Name.StartsWith("SET.")).ToList();
            l = rrr.Select(x => new ReqItem { RequirementId = x.Requirement_Id }).ToList();
            response.RequirementSections.Add(new ReqSection
            {
                AuditTitle = "Requirements With Suspect 'Original Set Name'",
                Items = l
            });



            // look for orphaned requirements that aren't in any SET
            var suspicious = _context.NEW_REQUIREMENT
                .Where(x => !_context.REQUIREMENT_SETS
                    .Any(y => y.Requirement_Id == x.Requirement_Id))
                .ToList();

            l = suspicious.Select(x => new ReqItem { RequirementId = x.Requirement_Id }).ToList();
            response.RequirementSections.Add(new ReqSection
            {
                AuditTitle = "Requirements Not Attached To Any Set",
                Items = l
            });
        }


        /// <summary>
        /// 
        /// </summary>
        public void AuditSets()
        {
            var sss = _context.SETS.Where(x => x.Set_Name.StartsWith("SET.")).ToList();
            var l = sss.Select(x => new SetItem { SetName = x.Set_Name, Description = x.Standard_ToolTip }).ToList();
            response.SetSections.Add(new SetSection
            {
                AuditTitle = "Sets With a Temporary Name, e.g. 'SETS.'",
                Sets = l
            });



            // sets marked as Custom
            sss = _context.SETS.Where(x => x.Is_Custom).ToList();
            l = sss.Select(x => new SetItem { SetName = x.Set_Name, Description = x.Standard_ToolTip }).ToList();
            response.SetSections.Add(new SetSection
            {
                AuditTitle = "Sets Marked Is_Custom",
                Sets = l
            });



            // sets with no requirements ...
            sss = _context.SETS.Where(x => x.Is_Requirement && !x.Is_Deprecated && !(_context.REQUIREMENT_SETS.Select(rs => rs.Set_Name).Contains(x.Set_Name))).ToList();
            l = sss.Select(x => new SetItem { SetName = x.Set_Name, Description = x.Standard_ToolTip }).ToList();
            response.SetSections.Add(new SetSection
            {
                AuditTitle = "Sets Marked as Requirement based, but with none",
                Sets = l
            });



            // Gary's 401 set is questions only.  How can we check that?
            // sets with no questions
            var qqq = _context.SETS.Where(x => x.Is_Question && !x.Is_Deprecated && !(_context.NEW_QUESTION_SETS.Select(rs => rs.Set_Name).Contains(x.Set_Name))).ToList();
            l = qqq.Select(x => new SetItem { SetName = x.Set_Name, Description = x.Standard_ToolTip }).ToList();
            response.SetSections.Add(new SetSection
            {
                AuditTitle = "Sets Marked as Question based, but with none",
                Sets = l
            });



            // sets with no requirements or questions
            var setsNeither = sss.Intersect(qqq).ToList();
            l = setsNeither.Select(x => new SetItem { SetName = x.Set_Name, Description = x.Standard_ToolTip }).ToList();
            response.SetSections.Add(new SetSection
            {
                AuditTitle = "Sets Without Requirements AND Questions",
                Sets = l
            });

        }


        /// <summary>
        /// 
        /// </summary>
        public void AuditGallery()
        {
            var orphaned = new GallSection { AuditTitle = "Gallery Items Not in Any Category" };
            response.GallerySections.Add(orphaned);

            var noConfig = new GallSection { AuditTitle = "Gallery With No Configuration Setup" };
            response.GallerySections.Add(noConfig);

            var tempSetName = new GallSection { AuditTitle = "Gallery Items With Temporary Set Name" };
            response.GallerySections.Add(tempSetName);

            var deprecatedSet = new GallSection { AuditTitle = "Gallery Items Configured for a Deprecated Set" };
            response.GallerySections.Add(deprecatedSet);

            var unknownModel = new GallSection { AuditTitle = "Gallery Items With Unknown Maturity Model" };
            response.GallerySections.Add(unknownModel);


            var dbGalleryItems = _context.GALLERY_ITEM.Where(x => x.Is_Visible).ToList();

            foreach (var item in dbGalleryItems)
            {
                var itemGuid = item.Gallery_Item_Guid;
                var setupJson = item.Configuration_Setup;
                var setupConfig = JsonConvert.DeserializeObject<Model.Assessment.GalleryConfig>(item.Configuration_Setup);



                // orphaned gallery_items
                var groupCount = _context.GALLERY_GROUP_DETAILS.Where(x => x.Gallery_Item_Guid == itemGuid).Count();
                if (groupCount == 0)
                {
                    var g2 = new GallItem
                    {
                        Guid = item.Gallery_Item_Guid.ToString(),
                        Title = item.Title,
                        Description = item.Description,
                        Config = item.Configuration_Setup
                    };

                    orphaned.Items.Add(g2);
                }


                // no configuration_setup
                if (setupConfig == null)
                {
                    noConfig.Items.Add(new GallItem
                    {
                        Guid = item.Gallery_Item_Guid.ToString(),
                        Description = item.Description,
                        Title = item.Title,
                        Config = item.Configuration_Setup
                    });
                    continue;
                }


                // audit sets in the configuration_setup
                if (setupConfig.Sets != null)
                {
                    foreach (var set in setupConfig.Sets)
                    {
                        if (set.StartsWith("SET."))
                        {
                            tempSetName.Items.Add(new GallItem
                            {
                                Guid = item.Gallery_Item_Guid.ToString(),
                                Description = item.Description,
                                Title = item.Title,
                                Config = item.Configuration_Setup
                            });
                        }



                        // Gallery configured for deprecated SET
                        var dbSet = _context.SETS.FirstOrDefault(x => x.Set_Name == set);
                        if (dbSet?.Is_Deprecated ?? false)
                        {
                            deprecatedSet.Items.Add(new GallItem
                            {
                                Guid = item.Gallery_Item_Guid.ToString(),
                                Description = item.Description,
                                Title = item.Title,
                                Config = item.Configuration_Setup
                            });
                        }
                    }
                }

                // audit models in configuration_setup
                if (setupConfig.Model != null)
                {
                    if (!_context.MATURITY_MODELS.Any(x => x.Model_Name == setupConfig.Model.ModelName))
                    {
                        unknownModel.Items.Add(new GallItem
                        {
                            Guid = item.Gallery_Item_Guid.ToString(),
                            Description = item.Description,
                            Title = item.Title,
                            Config = item.Configuration_Setup
                        });
                    }
                }
            }
        }
    }


    public class AuditResponse
    {
        public List<SetSection> SetSections { get; set; } = [];
        public List<GallSection> GallerySections { get; set; } = [];
        public List<ReqSection> RequirementSections { get; set; } = [];
    }



    public class SetSection
    {
        public string AuditTitle { get; set; }
        public List<SetItem> Sets { get; set; } = [];
    }

    public class SetItem
    {
        public string SetName { get; set; }
        public string Description { get; set; }
    }





    public class GallSection
    {
        public string AuditTitle { get; set; }
        public List<GallItem> Items { get; set; } = [];
    }

    public class GallItem
    {
        public string Guid { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public string Config { get; set; }
    }


                


    public class ReqSection
    {
        public string AuditTitle { get; set; }
        public List<ReqItem> Items { get; set; } = [];
    }

    public class ReqItem
    {
        public int RequirementId { get; set; }
    }

}


