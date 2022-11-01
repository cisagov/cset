﻿using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Maturity;
using CSETWebCore.Interfaces.Question;
using CSETWebCore.Interfaces.Standards;
using Nelibur.ObjectMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Business.GalleryParser
{
    public class GalleryEditor : IGalleryEditor
    {
        private CSETContext _context;
        private IMaturityBusiness _maturity_business;
        private IStandardsBusiness _standardsBusiness;
        private IQuestionRequirementManager _questionRequirementMananger;


        public GalleryEditor(CSETContext context, IMaturityBusiness maturityBusiness
            , IStandardsBusiness standardsBusiness
            , IQuestionRequirementManager questionRequirementManager)
        {

            _context = context;
            _maturity_business = maturityBusiness;
            _standardsBusiness = standardsBusiness;
            _questionRequirementMananger = questionRequirementManager;
        }


        /// <summary>
        /// Clones the specified item
        /// </summary>
        /// <param name="item_to_clone"></param>
        /// <returns></returns>
        public void CloneGalleryItem(int item_to_clone, int group_Id)
        {
            //determine if it is an item or a parent (node vs leaf)
            //for leaf nodes create a new Gallery_item and copy everything into it.
            //clone the gallery_item and gallery_group_details need to clone that 
            //plus max column number +1

            TinyMapper.Bind<GALLERY_ITEM, GALLERY_ITEM>(
                config =>
                {
                    config.Ignore(source => source.Gallery_Item_Id);
                }
            );

            TinyMapper.Bind<GALLERY_GROUP_DETAILS, GALLERY_GROUP_DETAILS>(
                config =>
                {
                    config.Ignore(source => source.Group_Detail_Id);
                }
            );

            var oldItem = _context.GALLERY_ITEM.Where(x => x.Gallery_Item_Id == item_to_clone).FirstOrDefault();

            if (oldItem == null) { return; }

            var newItem = TinyMapper.Map<GALLERY_ITEM>(oldItem);
            newItem.CreationDate = DateTime.Now;
            newItem.Is_Visible = true;
            newItem.Configuration_Setup = "";

            _context.GALLERY_ITEM.Add(newItem);
            _context.SaveChanges();

            // Setup for adding to GALLERY_GROUP_DETAILS table
            var detailList = _context.GALLERY_GROUP_DETAILS.Where(x => x.Gallery_Item_Id == item_to_clone && x.Group_Id == group_Id).ToList();

            if (detailList.Count == 0) { return; }

            var maxColumn = _context.GALLERY_GROUP_DETAILS.Where(x => x.Group_Id == group_Id).Max(x => x.Column_Index);
            var newDetail = detailList[0];

            var newDetailItem = new GALLERY_GROUP_DETAILS()
            {
                Group_Id = newDetail.Group_Id,
                Column_Index = maxColumn + 1,
                Gallery_Item_Id = newDetail.Gallery_Item_Id,
                Click_Count = newDetail.Click_Count
            };

            //newDetailItem = TinyMapper.Map<GALLERY_GROUP_DETAILS>(newDetail);

            _context.GALLERY_GROUP_DETAILS.Add(newDetailItem);
            _context.SaveChanges();

        }

        /// <summary>
        /// Clones the specified item
        /// </summary>
        /// <param name="group_to_clone"></param>
        /// <returns></returns>
        public void CloneGalleryGroup(GalleryGroup group_to_clone)
        {
            //determine if it is an item or a parent (node vs leaf)
            //for leaf nodes create a new Gallery_item and copy everything into it.
            //clone the gallery_item and gallery_group_details need to clone that 
            //plus max column number +1

            TinyMapper.Bind<GalleryGroup, GALLERY_GROUP>(
            //config => {
            //config.Ignore(source => source.Gallery_Item_Id);
            //}
            );

            //var oldItem = _context.GALLERY_ITEM.Where(itemto)
            var newGroup = TinyMapper.Map<GALLERY_GROUP>(group_to_clone);

            _context.GALLERY_GROUP.Add(newGroup);
        }


        public List<string> GetLayout()
        {
            return _context.GALLERY_LAYOUT.Select(x => x.Layout_Name).ToList();
        }

        //
        public void AddGalleryItem(string newIcon_File_Name_Small, string newIcon_File_Name_Large, string newDescription, string newTitle, int group_id, int columnId)
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
            _context.SaveChanges();

            // Setup for adding to GALLERY_GROUP_DETAILS table            
            var galleryId = newItem.Gallery_Item_Id;

            //var columnMax = _context.GALLERY_GROUP_DETAILS.Where(x => x.Group_Id == groupId).Max(x => x.Column_Index);

            GALLERY_GROUP_DETAILS newDetailsRow = new GALLERY_GROUP_DETAILS()
            {
                Group_Id = group_id,
                Column_Index = columnId,
                Gallery_Item_Id = galleryId,
                Click_Count = 0
            };

            _context.GALLERY_GROUP_DETAILS.Add(newDetailsRow);
            _context.SaveChanges();

        }


        public int AddGalleryGroup(string group, string layout)
        {
            // Setup for adding to GALLERY_ITEM table
            GALLERY_GROUP newGroup = new GALLERY_GROUP()
            {
                Group_Title = group
            };

            _context.GALLERY_GROUP.Add(newGroup);
            _context.SaveChanges();

            var newGroupId = newGroup.Group_Id;
            var newRowIndex = _context.GALLERY_ROWS.Where(x => x.Layout_Name == layout).Max(x => x.Row_Index) + 1;


            GALLERY_ROWS newRow = new GALLERY_ROWS()
            {
                Layout_Name = layout,
                Row_Index = newRowIndex,
                Group_Id = newGroupId
            };

            _context.GALLERY_ROWS.Add(newRow);
            _context.SaveChanges();

            return newGroupId;

        }


        public void AddGalleryDetail(string groupName, int columnId)
        {

            // Setup for adding to GALLERY_GROUP_DETAILS table
            var groupId = from g in _context.GALLERY_GROUP.AsEnumerable()
                          where g.Group_Title == groupName
                          select g.Group_Id;

            var galleryId = from g in _context.GALLERY_ITEM.AsEnumerable()
                            select g.Gallery_Item_Id;

            GALLERY_GROUP_DETAILS newDetailsRow = new GALLERY_GROUP_DETAILS()
            {
                Group_Id = groupId.Single(),
                Column_Index = columnId,
                Gallery_Item_Id = galleryId.Last(),
                Click_Count = 0
            };

            _context.GALLERY_GROUP_DETAILS.Add(newDetailsRow);
            _context.SaveChanges();

        }


        public void DeleteGalleryItem(int id)
        {
            var item = _context.GALLERY_GROUP_DETAILS.Where(x => x.Gallery_Item_Id == id).FirstOrDefault();
            _context.GALLERY_GROUP_DETAILS.Remove(item);
            _context.SaveChanges();

        }

        public void DeleteGalleryGroup(int id)
        {
            var groups = _context.GALLERY_GROUP_DETAILS.Where(x => x.Group_Id == id); //.FirstOrDefault();
            foreach (GALLERY_GROUP_DETAILS row in groups)
            {
                _context.GALLERY_GROUP_DETAILS.Remove(row);
                _context.SaveChanges();
            }
        }

    }
}
