using System;

namespace CSETWebCore.Model.Analytics;

public class AgDocuments
{
    public int DocumentId { get; set; }
    public int AnswerId { get; set; }
    public string Path { get; set; }
    public string Title { get; set; }
    public string FileMd5 { get; set; }
    public string ContentType { get; set; }
    public DateTime CreatedTimeStamp { get; set; }
    public DateTime UpdatedTimeStamp { get; set; }
    public string Name { get; set; }
    public byte[] Data { get; set; }
    public int AssessmentId { get; set; }
}