//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Maturity;
using CSETWebCore.Interfaces.Question;
using CSETWebCore.Interfaces.Standards;
using DocumentFormat.OpenXml.Office2010.Excel;
using DocumentFormat.OpenXml.Spreadsheet;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
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
        public void CloneGalleryItem(Guid item_to_clone, int group_Id, bool new_Id)
        {
            //determine if it is an item or a parent (node vs leaf)
            //for leaf nodes create a new Gallery_item and copy everything into it.
            //clone the gallery_item and gallery_group_details need to clone that 
            //plus max column number +1

            TinyMapper.Bind<GALLERY_ITEM, GALLERY_ITEM>(
                config =>
                {
                    config.Ignore(source => source.Gallery_Item_Guid);
                }
            );

            TinyMapper.Bind<GALLERY_GROUP_DETAILS, GALLERY_GROUP_DETAILS>(
                config =>
                {
                    config.Ignore(source => source.Group_Detail_Id);
                }
            );

            Guid newGallItemGuid = item_to_clone;

            if (new_Id == true)
            {
                var oldItem = _context.GALLERY_ITEM.Where(x => x.Gallery_Item_Guid == newGallItemGuid).FirstOrDefault();

                if (oldItem == null) { return; }

                Guid newGuid = Guid.NewGuid();

                var newItem = TinyMapper.Map<GALLERY_ITEM>(oldItem);
                newItem.CreationDate = DateTime.Now;
                newItem.Is_Visible = true;
                newItem.Gallery_Item_Guid = newGuid;

                _context.GALLERY_ITEM.Add(newItem);
                _context.SaveChanges();

                newGallItemGuid = newItem.Gallery_Item_Guid;
            }

            // Setup for adding to GALLERY_GROUP_DETAILS table
            var detailList = _context.GALLERY_GROUP_DETAILS.Where(x => x.Gallery_Item_Guid == item_to_clone && x.Group_Id == group_Id).ToList();

            if (detailList.Count == 0) { return; }

            var maxColumn = _context.GALLERY_GROUP_DETAILS.Where(x => x.Group_Id == group_Id).Max(x => x.Column_Index);
            var newDetail = detailList[0];

            var newDetailItem = new GALLERY_GROUP_DETAILS()
            {
                Group_Id = newDetail.Group_Id,
                Column_Index = maxColumn + 1,
                Gallery_Item_Guid = newGallItemGuid,
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
        public void CloneGalleryGroup(int group_to_clone, string layout)
        {
            //determine if it is an item or a parent (node vs leaf)
            //for leaf nodes create a new Gallery_item and copy everything into it.
            //clone the gallery_item and gallery_group_details need to clone that 
            //plus max column number +1

            TinyMapper.Bind<GALLERY_GROUP, GALLERY_GROUP>(
                config =>
                {
                    config.Ignore(source => source.Group_Id);
                }
            );
            TinyMapper.Bind<GALLERY_GROUP_DETAILS, GALLERY_GROUP_DETAILS>(
              config =>
              {
                  config.Ignore(source => source.Group_Id);
                  config.Ignore(source => source.Group_Detail_Id);
              }
          );

            //clone the group and the details
            var oldGroup = _context.GALLERY_GROUP.Where(x => x.Group_Id == group_to_clone).FirstOrDefault();
            var newGroup = TinyMapper.Map<GALLERY_GROUP>(oldGroup);
            _context.GALLERY_GROUP.Add(newGroup);
            _context.SaveChanges();
            var nextRow = _context.GALLERY_ROWS.Where(x => x.Layout_Name == layout).Max(x => x.Row_Index);
            _context.GALLERY_ROWS.Add(new GALLERY_ROWS() { Group_Id = newGroup.Group_Id, Layout_Name = layout, Group = newGroup, Row_Index = (++nextRow) });

            foreach (var item in _context.GALLERY_GROUP_DETAILS.Where(x => x.Group_Id == oldGroup.Group_Id))
            {
                //make a copy and add it to the new group
                var newItem = new GALLERY_GROUP_DETAILS() { Group_Id = newGroup.Group_Id, Column_Index = item.Column_Index, Gallery_Item_Guid = item.Gallery_Item_Guid };
                newGroup.GALLERY_GROUP_DETAILS.Add(newItem);
            }
            _context.SaveChanges();

        }


        public List<string> GetLayout()
        {
            return _context.GALLERY_LAYOUT.Select(x => x.Layout_Name).ToList();
        }

        //
        public void AddGalleryItem(string newIcon_File_Name_Small, string newIcon_File_Name_Large, string newDescription, string newTitle, string newConfigSetup, int group_id, int columnId)
        {
            // Setup for adding to GALLERY_ITEM table
            GALLERY_ITEM newItem = new GALLERY_ITEM()
            {
                Icon_File_Name_Small = newIcon_File_Name_Small,
                Icon_File_Name_Large = newIcon_File_Name_Large,
                Configuration_Setup = newConfigSetup,
                Configuration_Setup_Client = null,
                Description = newDescription,
                Title = newTitle,
                CreationDate = DateTime.Now,
                Is_Visible = true,
                Gallery_Item_Guid = Guid.NewGuid()
            };

            _context.GALLERY_ITEM.Add(newItem);
            _context.SaveChanges();

            // Setup for adding to GALLERY_GROUP_DETAILS table            
            var galleryId = newItem.Gallery_Item_Guid;

            //var columnMax = _context.GALLERY_GROUP_DETAILS.Where(x => x.Group_Id == groupId).Max(x => x.Column_Index);

            GALLERY_GROUP_DETAILS newDetailsRow = new GALLERY_GROUP_DETAILS()
            {
                Group_Id = group_id,
                Column_Index = columnId,
                Gallery_Item_Guid = galleryId,
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


        public int AddCustomGalleryGroup(string group, string layout)
        {
            // Setup for adding to GALLERY_ITEM table
            GALLERY_GROUP newGroup = new GALLERY_GROUP()
            {
                Group_Title = group
            };

            _context.GALLERY_GROUP.Add(newGroup);
            _context.SaveChanges();

            var newGroupId = newGroup.Group_Id;
            var newRowIndex = 0;



            GALLERY_ROWS newRow = new GALLERY_ROWS()
            {
                Layout_Name = layout,
                Row_Index = newRowIndex,
                Group_Id = newGroupId
            };

            var layoutRows = _context.GALLERY_ROWS.Where(x => x.Layout_Name.Equals(layout));

            foreach (GALLERY_ROWS row in layoutRows)
            {
                row.Row_Index = row.Row_Index + 1;
            }
            _context.SaveChanges();
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
                            select g.Gallery_Item_Guid;

            GALLERY_GROUP_DETAILS newDetailsRow = new GALLERY_GROUP_DETAILS()
            {
                Group_Id = groupId.Single(),
                Column_Index = columnId,
                Gallery_Item_Guid = galleryId.Last(),
                Click_Count = 0
            };

            _context.GALLERY_GROUP_DETAILS.Add(newDetailsRow);
            _context.SaveChanges();

        }


        public void UpdatePosition(MoveItem moveItem)
        {
            _context.Database.ExecuteSqlRaw("delete GALLERY_ROWS FROM[GALLERY_ROWS] AS[g] INNER JOIN[GALLERY_GROUP] AS[g0] ON[g].[Group_Id] = [g0].[Group_Id] left JOIN[GALLERY_GROUP_DETAILS] AS[g1] ON[g0].[Group_Id] = [g1].[Group_Id] WHERE g1.Column_Index is null");
            if (String.IsNullOrWhiteSpace(moveItem.fromId) && !string.IsNullOrWhiteSpace(moveItem.toId))
            {

                //find the new group and insert it
                //renumber both groups

                Guid guid = Guid.Parse(moveItem.gallery_Item_Guid);
                var dbItem = _context.GALLERY_ITEM.Where(x => x.Gallery_Item_Guid == guid).FirstOrDefault();
                if (dbItem != null)
                {
                    var detailsNewList = _context.GALLERY_GROUP_DETAILS.Where(r => r.Group_Id == int.Parse(moveItem.toId)).OrderBy(r => r.Column_Index).ToList();
                    var newGroupItem = new GALLERY_GROUP_DETAILS()
                    {
                        Gallery_Item_Guid = guid,
                        Column_Index = int.Parse(moveItem.newIndex),
                        Group_Id = int.Parse(moveItem.toId)
                    };
                    _context.GALLERY_GROUP_DETAILS.Add(newGroupItem);
                    detailsNewList.Insert(int.Parse(moveItem.newIndex), newGroupItem);
                    RenumberGroup(detailsNewList);
                    _context.SaveChanges();
                }


            }
            else if (String.IsNullOrWhiteSpace(moveItem.fromId) || string.IsNullOrWhiteSpace(moveItem.toId))
            {



                //we are changing position of the rows. 
                //move the item from the old index to the new index and then 
                //update the indexes of everything below them.
                var rows = (from r in _context.GALLERY_ROWS
                            where r.Layout_Name == moveItem.Layout_Name
                            orderby r.Row_Index
                            select r).ToList();
                _context.GALLERY_ROWS.RemoveRange(rows);
                _context.SaveChanges();
                //question can I violate the primary key before I save? 
                //if so then remove the old one and insert it at the new position.
                //iterate through all the items and just reassign the row_index. 
                var itemToMove = rows[int.Parse(moveItem.oldIndex)];
                rows.Remove(itemToMove);
                if (int.Parse(moveItem.oldIndex) < int.Parse(moveItem.newIndex))
                {
                    //we are moving it down. so the new index needs to be -1
                    //(I took out the -1 from "int.Parse(moveItem.newIndex)-1"
                    //because it was putting the row 1 group above what the target was)
                    rows.Insert(int.Parse(moveItem.newIndex), itemToMove);
                }
                else if (int.Parse(moveItem.oldIndex) > int.Parse(moveItem.newIndex))
                {
                    //we are moving it up. so the new index is unchanged
                    rows.Insert(int.Parse(moveItem.newIndex), itemToMove);
                }

                RenumberGroup(rows);
                _context.GALLERY_ROWS.AddRange(rows);
                _context.SaveChanges();
            }
            else if (moveItem.fromId == moveItem.toId)
            {
                //the items is moved in the same group 
                //find the group and move it
                //get the group
                var detailsList = _context.GALLERY_GROUP_DETAILS.Where(r => r.Group_Id == int.Parse(moveItem.fromId)).OrderBy(r => r.Column_Index).ToList();
                var itemToMove = detailsList[int.Parse(moveItem.oldIndex)];
                detailsList.Remove(itemToMove);
                detailsList.Insert(int.Parse(moveItem.newIndex), itemToMove);
                RenumberGroup(detailsList);
                _context.SaveChanges();
            }
            else
            {
                //find the old group and remove it
                //find the new group and insert it
                //renumber both groups
                var detailsOldList = _context.GALLERY_GROUP_DETAILS.Where(r => r.Group_Id == int.Parse(moveItem.fromId)).OrderBy(r => r.Column_Index).ToList();
                var itemToMove = detailsOldList[int.Parse(moveItem.oldIndex)];
                detailsOldList.Remove(itemToMove);
                RenumberGroup(detailsOldList);
                var detailsNewList = _context.GALLERY_GROUP_DETAILS.Where(r => r.Group_Id == int.Parse(moveItem.toId)).OrderBy(r => r.Column_Index).ToList();
                detailsNewList.Insert(int.Parse(moveItem.newIndex), itemToMove);
                RenumberGroup(detailsNewList);
                itemToMove.Group_Id = int.Parse(moveItem.toId);
                _context.SaveChanges();
            }
        }


        public void DeleteGalleryItem(Guid galleryItemGuid, int group_id)
        {
            var item = _context.GALLERY_GROUP_DETAILS.Where(x => x.Gallery_Item_Guid == galleryItemGuid && x.Group_Id == group_id).FirstOrDefault();
            if (item != null)
            {
                _context.GALLERY_GROUP_DETAILS.Remove(item);
                _context.SaveChanges();
            }


        }

        public void DeleteGalleryGroup(int id, string layout)
        {
            var groups = _context.GALLERY_ROWS.Remove(_context.GALLERY_ROWS.Where(x => x.Group_Id == id && x.Layout_Name == layout).First());
            _context.SaveChanges();
        }

        public GalleryItem[] GetUnused(string layout_Name)
        {
            var queryExcept = (from i in _context.GALLERY_ITEM
                               join d in _context.GALLERY_GROUP_DETAILS on i.Gallery_Item_Guid equals d.Gallery_Item_Guid
                               join g in _context.GALLERY_GROUP on d.Group_Id equals g.Group_Id
                               join r in _context.GALLERY_ROWS on g.Group_Id equals r.Group_Id
                               where r.Layout_Name == layout_Name
                               select new GalleryItem()
                               {
                                   Gallery_Item_Guid = i.Gallery_Item_Guid
                                   ,
                                   Title = i.Title
                                   ,
                                   Description = i.Description
                                   ,
                                   Configuration_Setup = i.Configuration_Setup
                                   ,
                                   Configuration_Setup_Client = i.Configuration_Setup_Client
                                   ,
                                   Icon_File_Name_Large = i.Icon_File_Name_Large
                                   ,
                                   Icon_File_Name_Small = i.Icon_File_Name_Small
                                   ,
                                   Is_Visible = i.Is_Visible
                               }).Distinct().ToList();

            var query = (from i in _context.GALLERY_ITEM
                         select new GalleryItem()
                         {
                             Gallery_Item_Guid = i.Gallery_Item_Guid
                             ,
                             Title = i.Title
                             ,
                             Description = i.Description
                             ,
                             Configuration_Setup = i.Configuration_Setup
                             ,
                             Configuration_Setup_Client = i.Configuration_Setup_Client
                             ,
                             Icon_File_Name_Large = i.Icon_File_Name_Large
                             ,
                             Icon_File_Name_Small = i.Icon_File_Name_Small
                             ,
                             Is_Visible = i.Is_Visible
                         }).ToList();


            return query.Except(queryExcept.ToList(), new GalleryItemComparer()).ToArray();
        }

        public List<GalleryLayout> GetLayouts()
        {
            List<GalleryLayout> layouts = new List<GalleryLayout>();
            foreach (var g in _context.GALLERY_LAYOUT)
            {
                layouts.Add(new GalleryLayout() { LayoutName = g.Layout_Name });
            }
            return layouts;
        }

        public void UpdateItem(GALLERY_ITEM item)
        {
            var galleryItem = _context.GALLERY_ITEM.Where(x => x.Gallery_Item_Guid == item.Gallery_Item_Guid).FirstOrDefault();
            //if (galleryItem == null) return BadRequest();

            galleryItem.Title = item.Title;
            galleryItem.Description = item.Description;
            galleryItem.Configuration_Setup = item.Configuration_Setup;
            galleryItem.Icon_File_Name_Large = item.Icon_File_Name_Large;
            galleryItem.Icon_File_Name_Small = item.Icon_File_Name_Small;
            galleryItem.Is_Visible = item.Is_Visible;

            _context.SaveChanges();
        }


        public void RenumberGroup(List<GALLERY_GROUP_DETAILS> detailsList)
        {
            int i = 0;
            foreach (var item in detailsList)
            {
                item.Column_Index = i++;
            }
        }

        public void RenumberGroup(List<GALLERY_ROWS> rows)
        {
            int i = 0;
            foreach (var row in rows)
            {
                row.Row_Index = i++;
            }
        }
    }

    class GalleryItemComparer : IEqualityComparer<GalleryItem>
    {
        public bool Equals(GalleryItem x, GalleryItem y)
        {
            if (x.Gallery_Item_Guid == y.Gallery_Item_Guid)
                return true;

            return false;
        }

        public int GetHashCode(GalleryItem obj)
        {
            return obj.Gallery_Item_Guid.GetHashCode();
        }
    }

    public class UpdateItem
    {
        public bool IsGroup { get; set; }
        public int? Group_Id { get; set; }
        public string Gallery_Item_Guid { get; set; }
        public string Value { get; set; }
    }

    public class MoveItem
    {
        public string Layout_Name { get; set; }
        public string fromId { get; set; }
        public string toId { get; set; }
        public string oldIndex { get; set; }
        public string newIndex { get; set; }
        public string gallery_Item_Guid { get; set; }
    }

}
