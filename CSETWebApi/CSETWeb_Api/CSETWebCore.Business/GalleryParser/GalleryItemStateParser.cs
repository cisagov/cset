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

                galleryGroup.GalleryItems.Add(new GalleryItem(item.i));
            }

            return rvalue;
        }

        /// <summary>
        /// Returns the gallery page structure
        /// </summary>
        /// <param name="item_to_clone"></param>
        /// <returns></returns>
        public GalleryBoardData CloneGalleryItem(GalleryItem item_to_clone)
        {
            //determine if it is an item or a parent (node vs leaf)
            //for leaf nodes create a new Gallery_item and copy everything into it.
            //clone the gallery_item and gallery_group_details need to clone that 
            //plus max column number +1

            TinyMapper.Bind<GalleryItem, GalleryItem>();
            var oldItem = _context.GALLERY_ITEM.Where(itemto)
            var newItem = TinyMapper.Map<GalleryItem>(item_to_clone); 
            // var clone = insert into _context.GALLERY_ITEM
            //            values ();
            //var data = from r in _context.GALLERY_ROWS
            //           join g in _context.GALLERY_GROUP on r.Group_Id equals g.Group_Id
            //           join d in _context.GALLERY_GROUP_DETAILS on g.Group_Id equals d.Group_Id
            //           join i in _context.GALLERY_ITEM on d.Gallery_Item_Id equals i.Gallery_Item_Id
            //           where r.Layout_Name == layout_name
            //           orderby r.Row_Index, d.Column_Index
            //           select new { r, g, d, i };
            var rvalue = new GalleryBoardData();


            //int row = -1;
            //GalleryGroup galleryGroup = null;
            //foreach (var item in data)
            //{
            //    if (row != item.r.Row_Index)
            //    {
            //        rvalue.Layout_Name = item.r.Layout_Name;
            //        galleryGroup = new GalleryGroup();
            //        galleryGroup.Group_Title = item.g.Group_Title;
            //        galleryGroup.Group_Id = item.g.Group_Id;
            //        rvalue.Rows.Add(galleryGroup);
            //        row = item.r.Row_Index;
            //    }

            //    galleryGroup.GalleryItems.Add(new GalleryItem(item.i));
            //}

            return rvalue;
        }


        public List<string> GetLayout()
        {
            return _context.GALLERY_LAYOUT.Select(x=> x.Layout_Name).ToList();
        }

        public List<string> AddGalleryItem(string newIcon_File_Name_Small, string newIcon_File_Name_Large, string newDescription, string newTitle, string groupName, int columnId)
        {
            // Setup for adding to GALLERY_ITEM table
            GALLERY_ITEM newItem = new GALLERY_ITEM()
            {
                //Gallery_Item_Id = newGallery_Item_Id,
                Icon_File_Name_Small = newIcon_File_Name_Small,
                Icon_File_Name_Large = newIcon_File_Name_Large,
                Configuration_Setup = "",
                Configuration_Setup_Client = null,
                Description = newDescription,
                Title = newTitle,
                CreationDate = DateTime.Now,
                Is_Visible = true
            };

            _context.GALLERY_ITEM.Add(newItem);

            // Setup for adding to GALLERY_GROUP_DETAILS table
            var groupId = from g in _context.GALLERY_GROUP.AsEnumerable()
                       where g.Group_Title == groupName
                       select g.Group_Id;

            var galleryId  = from g in _context.GALLERY_ITEM.AsEnumerable()
                       select g.Gallery_Item_Id;

            GALLERY_GROUP_DETAILS newDetailsRow = new GALLERY_GROUP_DETAILS() {
                Group_Id = groupId.Single(),
                Column_Index = columnId,
                Gallery_Item_Id = galleryId.Last() + 1,
                Click_Count = 0
            };

            _context.GALLERY_GROUP_DETAILS.Add(newDetailsRow);
            _context.SaveChanges();

            return _context.GALLERY_ITEM.Select(x => x.Title).ToList();
        }


    }
}
