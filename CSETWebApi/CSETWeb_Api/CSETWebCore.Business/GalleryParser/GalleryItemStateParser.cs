//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Helpers;
using CSETWebCore.Interfaces.Maturity;
using CSETWebCore.Interfaces.Question;
using CSETWebCore.Interfaces.Standards;
using CSETWebCore.Model.Sal;
using System.Collections.Generic;
using System;
using System.Linq;
using System.Text.Json;
using System.Text.Json.Serialization;
using Nelibur.ObjectMapper;
using CSETWebCore.Interfaces.Helpers;

namespace CSETWebCore.Business.GalleryParser
{

    public class GalleryState : IGalleryState
    {
        private readonly ITokenManager _token;
        private CSETContext _context;
        private IMaturityBusiness _maturity_business;
        private IStandardsBusiness _standardsBusiness;
        private IQuestionRequirementManager _questionRequirementMananger;

        private readonly TranslationOverlay _overlay;


        /// <summary>
        /// 
        /// </summary>
        public GalleryState(ITokenManager token, CSETContext context, IMaturityBusiness maturityBusiness
            , IStandardsBusiness standardsBusiness
            , IQuestionRequirementManager questionRequirementManager)
        {
            _token = token;
            _context = context;
            _maturity_business = maturityBusiness;
            _standardsBusiness = standardsBusiness;
            _questionRequirementMananger = questionRequirementManager;

            _overlay = new TranslationOverlay();
        }


        /// <summary>
        /// Returns the gallery page structure
        /// </summary>
        /// <param name="layout_name"></param>
        /// <returns></returns>
        public GalleryBoardData GetGalleryBoard(string layout_name)
        {
            var data = from r in _context.GALLERY_ROWS
                       join g in _context.GALLERY_GROUP on r.Group_Id equals g.Group_Id
                       join d in _context.GALLERY_GROUP_DETAILS on g.Group_Id equals d.Group_Id
                       join i in _context.GALLERY_ITEM on d.Gallery_Item_Guid equals i.Gallery_Item_Guid
                       where r.Layout_Name == layout_name
                       orderby r.Row_Index, d.Column_Index
                       select new { r, g, d, i };
            var rvalue = new GalleryBoardData();

            var lang = _token.GetCurrentLanguage();

            int row = -1;
            GalleryGroup galleryGroup = null;
            foreach (var item in data)
            {
                if (row != item.r.Row_Index)
                {
                    rvalue.Layout_Name = item.r.Layout_Name;
                    galleryGroup = new GalleryGroup();
                    galleryGroup.Group_Title = item.g.Group_Title;
                    galleryGroup.Group_Id = item.g.Group_Id;
                    rvalue.Rows.Add(galleryGroup);
                    row = item.r.Row_Index;

                    if (lang != "en")
                    {
                        galleryGroup.Group_Title = _overlay.GetValue("GALLERY_GROUP", galleryGroup.Group_Id.ToString(), lang)?.Value;
                    }
                }

                if ((bool)item.i.Is_Visible)
                {
                    var galleryItem = new GalleryItem(item.i, galleryGroup.Group_Id);

                    if (lang != "en")
                    {
                        var itemOverlay = _overlay.GetJObject("GALLERY_ITEM", "key", galleryItem.Gallery_Item_Guid.ToString(), lang);

                        if (itemOverlay != null)
                        {
                            galleryItem.Title = itemOverlay.Value<string>("title");
                            galleryItem.Description = itemOverlay.Value<string>("description");
                        }
                    }

                    galleryGroup.GalleryItems.Add(galleryItem);
                }
            }

            /* The below "IncludeCustomSets(rvalue)" is commented out because we migrated from "on the fly" building 
             * to making a new GALLERY_ITEM and GALLERY_GROUP_DETAILS, like normal sets/models, when the custom set is made.
             * 
             * I don't feel safe taking this out until we know the new way is solid.
             */
            //IncludeCustomSets(rvalue);

            return rvalue;
        }


        /// <summary>
        /// Build a "Custom" row at the top of the structure on the fly
        /// if any custom sets exist.
        /// </summary>
        /// <param name="board"></param>
        private void IncludeCustomSets(GalleryBoardData board)
        {
            var customSets = _context.SETS.Where(s => s.Is_Custom && (s.Is_Displayed) && !s.Is_Deprecated).ToList();

            if (customSets.Count > 0)
            {
                var customGroup = new GalleryGroup();
                customGroup.Group_Id = 999;
                customGroup.Group_Title = "Custom";
                board.Rows.Insert(0, customGroup);

                foreach (var s in customSets)
                {
                    var customSet = new GalleryItem
                    {
                        Title = s.Full_Name,
                        Description = s.Standard_ToolTip,
                        Custom_Set_Name = s.Set_Name
                    };
                    customGroup.GalleryItems.Add(customSet);
                }
            }
        }
    }
}
