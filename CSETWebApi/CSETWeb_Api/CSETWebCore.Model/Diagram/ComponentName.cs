//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWebCore.Model.Diagram
{
    public class ComponentName
    {
        public string Abbreviation;
        public string ImageFileName;

        public ComponentName(string abbrev, string fileName)
        {
            this.Abbreviation = abbrev;
            this.ImageFileName = fileName;
        }
    }
}