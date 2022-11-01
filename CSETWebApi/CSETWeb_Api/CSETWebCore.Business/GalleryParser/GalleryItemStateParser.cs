﻿using CSETWebCore.DataLayer.Model;
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

namespace CSETWebCore.Business.GalleryParser
{

    public class GalleryState : IGalleryState
    {
        private CSETContext _context;
        private IMaturityBusiness _maturity_business;
        private IStandardsBusiness _standardsBusiness;
        private IQuestionRequirementManager _questionRequirementMananger;

        public GalleryState(CSETContext context, IMaturityBusiness maturityBusiness
            , IStandardsBusiness standardsBusiness
            , IQuestionRequirementManager questionRequirementManager)
        {

            _context = context;
            _maturity_business = maturityBusiness;
            _standardsBusiness = standardsBusiness;
            _questionRequirementMananger = questionRequirementManager;
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
                       join i in _context.GALLERY_ITEM on d.Gallery_Item_Id equals i.Gallery_Item_Id
                       where r.Layout_Name == layout_name
                       orderby r.Row_Index, d.Column_Index
                       select new { r, g, d, i };
            var rvalue = new GalleryBoardData();


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
                }

                if ((bool)item.i.Is_Visible)
                {
                    galleryGroup.GalleryItems.Add(new GalleryItem(item.i,galleryGroup.Group_Id));
                }
            }

            return rvalue;
        }

      

    }
}
