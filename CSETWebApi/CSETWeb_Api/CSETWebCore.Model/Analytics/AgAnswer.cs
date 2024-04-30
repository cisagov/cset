using System;
using System.ComponentModel.DataAnnotations;

namespace CSETWebCore.Model.Analytics;

public class AgAnswer
{
    public int AnswerId { get; set; }
    public int QuestionOrRequirementId { get; set; }
    public bool? MarkForReview { get; set; }
    public string Comment { get; set; }
    public string AlternateJustification { get; set; }
    public int? QuestionNumber { get; set; }
    public string AnswerText { get; set; }
    public Guid ComponentGuid { get; set; }
    public string CustomQuestionGuid { get; set; }
    public int? OldAnswerId { get; set; }
    public bool Reviewed { get; set; }
    public string FeedBack { get; set; }
    public string QuestionType { get; set; }
    public bool? IsRequirement { get; set; }
    public bool? IsComponent { get; set; }
    public bool? IsFramework { get; set; }
    public bool? IsMaturity { get; set; }
    public string FreeResponseAnswer { get; set; }
    public int? MatOptionId { get; set; }
    public int AssessmentId { get; set; }
}