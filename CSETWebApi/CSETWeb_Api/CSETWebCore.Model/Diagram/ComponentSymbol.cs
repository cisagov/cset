//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWebCore.Model.Diagram
{
    public class ComponentSymbol
    {
        public string FileName { get; set; }
        public string Abbreviation { get; set; }
        public string ComponentFamilyName { get; set; }
        public int Width { get; set; }
        public int Height { get; set; }
        public string Symbol_Name { get; set; }
        public string Search_Tags { get; set; }
        public int Component_Symbol_Id { get; set; }
    }
}