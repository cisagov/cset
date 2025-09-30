//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
////////////////////////////////

using CSETWebCore.Model.Maturity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Model.ExportJson
{
    public class AssessmentJson
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public DateTime? CreatedDate { get; set; }
        public bool SelfAssessment { get; set; }
        public DateTime? AssessmentDate { get; set; }
        public Guid AssessmentGuid { get; set; }

        public int SectorId { get; set; }
        public string SectorName { get; set; }
        public int SubsectorId { get; set; }
        public string SubsectorName { get; set; }


    }

    public class SectorDetailsJson
    {
        public int SectorId { get; set; }
        public string SectorName { get; set; }
        public int? SelectedIndustryId { get; set; }
        public string SelectedIndustryName { get; set; }
    }


    ////// Maturity Model Content /////////////////////////////////////

    public class ModelsJson
    {
        public List<ModelJson> Models { get; set; }
    }


    public class ModelJson
    {
        public int ModelId { get; set; }
        public string ModelName { get; set; }
        public string ModelTitle { get; set; }
        public List<MaturityLevel> Levels { get; set; } = [];

        public List<GroupingJson> Groupings { get; set; } = [];
    }


    public class GroupingJson
    {
        public int GroupingId { get; set; }
        public string Title { get; set; }
        public List<GroupingJson> Groupings { get; set; } = [];
        public List<MaturityQuestionJson> Questions { get; set; } = [];
    }


    public class MaturityQuestionJson
    {
        public int QuestionId { get; set; }
        public string QuestionText { get; set; }
        public int MaturityLevel { get; set; }
        public AnswerJson Answer { get; set; }

        public List<MaturityQuestionJson> FollowupQuestions { get; set; } = [];
    }


    ////// Standards Content /////////////////////////////////////

    /// <summary>
    /// This is only included if the assessment contains standards
    /// </summary>
    public class StandardsJson
    { 
        public List<StandardJson> Standards { get; set; }

        /// <summary>
        /// Requirements Mode or Questions Mode
        /// </summary>
        public string Mode { get; set; }


        /// <summary>
        /// This property is only applicable for assessments in Questions Mode.
        /// It should not show up when in Requirements Mode.
        /// </summary>
        public List<StandardQuestionJson> Questions { get; set; } = [];
    }


    public class StandardJson
    {
        public string SetName { get; set; }
        public List<RequirementJson> Requirements { get; set; } = [];
    }


    public class RequirementJson
    {
        public int RequirementId { get; set; }
        public string RequirementText { get; set; }
    }


    public class StandardQuestionJson
    {
        public int QuestionId { get; set; }
        public string QuestionText { get; set; }

        public AnswerJson Answer { get; set; }
    }


    ////// Shared between Maturity and Standards ///////////////////////

    public class AnswerJson
    {
        public string AnswerText { get; set; }
        public string Comment { get; set; }
        public List<ObservationJson> Observations { get; set; } = [];
    }


    public class ObservationJson
    {
        public int ObservationId { get; set; }
        public string Issue { get; set; }
    }


    public class ContactJson
    {
        public string UserId { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Email { get; set; }
        public string Phone { get; set; }
        public string Role { get; set; }

        public bool Invited { get; set; }
        public bool IsPrimaryPoc { get; set; }
        public bool IsSiteParticipant { get; set; }
    }
}
