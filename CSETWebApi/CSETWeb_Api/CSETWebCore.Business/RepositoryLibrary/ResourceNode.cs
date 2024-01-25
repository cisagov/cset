//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Enum;

namespace CSETWebCore.Api.Models
{
    public class ResourceNode
    {
        public ObservableCollection<ResourceNode> Nodes { get; set; }

        public int ID { get; set; }
        public int ParentID { get; set; }
        public string TreeTextNode { get; set; }
        public string HeadingTitle { get; protected set; }
        public string HeadingTitle2 { get; protected set; }
        public string DatePublished { get; protected set; }
        public string HeadingText { get; protected set; }

        public ResourceNodeType Type { get; set; }

        public string PathDoc { get; protected set; }
        public string FileName { get; set; }
        public double Score { get; set; }

        private bool isSelected;
        public bool IsSelected
        {
            get { return isSelected; }
            set { isSelected = value; }
        }

        private bool isExpanded;
        public bool IsExpanded
        {
            get { return isExpanded; }
            set
            {
                isExpanded = value;
            }
        }

        public ResourceNode()
        {
            Nodes = new ObservableCollection<ResourceNode>();
        }


        public ResourceNode(GEN_FILE doc)
            : this()
        {

            ID = doc.Gen_File_Id;
            TreeTextNode = doc.Short_Name;

            if (doc.Title != null)
                HeadingTitle = doc.Title;
            if (doc.Doc_Num != null)
                HeadingTitle2 = doc.Short_Name;
            if (doc.Publish_Date != null)
                DatePublished = String.Format("{0:ddd, MMM d, yyyy}", doc.Publish_Date);

            if (doc.Summary != null)
                HeadingText = doc.Summary;
        }




        public void ExpandAll()
        {
            ApplyActionToAllItems(item => item.IsExpanded = true);
        }

        public void CollapseAll()
        {
            ApplyActionToAllItems(item => item.IsExpanded = false);
        }

        private void ApplyActionToAllItems(Action<ResourceNode> itemAction)
        {
            Stack<ResourceNode> dataItemStack = new Stack<ResourceNode>();
            dataItemStack.Push(this);

            while (dataItemStack.Count != 0)
            {
                ResourceNode currentItem = dataItemStack.Pop();
                itemAction(currentItem);
                foreach (ResourceNode childItem in currentItem.Nodes)
                {
                    dataItemStack.Push(childItem);
                }
            }
        }
    }
}