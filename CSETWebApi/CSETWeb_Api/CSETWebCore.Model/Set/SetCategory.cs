//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWebCore.Model.Set
{
    public class SetCategory
    {
        public int Id;
        public string CategoryName;

        public SetCategory(int id, string categoryName)
        {
            this.Id = id;
            this.CategoryName = categoryName;
        }
    }
}