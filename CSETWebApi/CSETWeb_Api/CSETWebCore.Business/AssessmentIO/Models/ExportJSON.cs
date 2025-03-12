
namespace CSETWebCore.Business.AssessmentIO.Models
{
    public class ExportJson
    {
        public SetObject SetObj { get; set; }
        public DocObject DocObj { get; set; }
        public ModelObject ModelObj { get; set; }
        public PasswordObject PasswordObj { get; set; }
        
    }
    public class SetObject
    {
        public string SetName { get; set; }
        public string Json { get; set; }
    }

    public class DocObject
    {
        public string DocName { get; set; }
        public string Json { get; set; }
    }
    
    public class ModelObject
    {
        public string ModelName { get; set; }
        public string Json { get; set; }
    }

    public class PasswordObject
    {
        public string PasswordName { get; set; }
        public string Hint { get; set; }
    }
    
}