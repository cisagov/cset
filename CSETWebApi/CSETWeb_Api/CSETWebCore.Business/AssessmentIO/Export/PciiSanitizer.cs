//////////////////////////////// 
// 
//   Copyright 2026 Battelle Energy Alliance, LLC  
// 
// 
////////////////////////////////
using CSETWebCore.Model.ExportJson;
using System.Collections.Generic;


namespace CSETWebCore.Business.AssessmentIO.Export
{
    /// <summary>
    /// Sanitize the exported JSON by removing sensitive fields.
    /// </summary>
    public class PciiSanitizer
    {
        private AssessmentExportPayload _payload;


        public PciiSanitizer(AssessmentExportPayload payload)
        {
            _payload = payload;
        }




        /// <summary>
        /// Sanitizes / removes PCII data from the assessment payload to avoid leaking sensitive
        /// information that is not required by the exported JSON document.
        /// </summary>

        public void Sanitize()
        {
            if (_payload == null)
            {
                return;
            }

            if (_payload.Assessment == null)
            {
                return;
            }

            RemoveContacts();

            SanitizeQuestions();

            _payload.Assessment.Name = null;
            _payload.Assessment.FacilitatorName = null;


            // Remove PCII fields from organization info
            if (_payload.Assessment.OrganizationInfo != null)
            {
                _payload.Assessment.OrganizationInfo.OrganizationName = null;
                _payload.Assessment.OrganizationInfo.BusinessUnit = null;
                _payload.Assessment.OrganizationInfo.CityOrSiteName = null;
                _payload.Assessment.OrganizationInfo.FacilityName = null;
                _payload.Assessment.OrganizationInfo.StateProvRegion = null;
                _payload.Assessment.OrganizationInfo.Sectors = null;

                _payload.Assessment.OrganizationInfo.PciiNumber = null;

                _payload.Assessment.OrganizationInfo.Reg1Other = null;
                _payload.Assessment.OrganizationInfo.Reg2Other = null;
                _payload.Assessment.OrganizationInfo.ShareOrgOther = null;

                _payload.Assessment.OrganizationInfo.CriticalServiceDescription = null;
                _payload.Assessment.OrganizationInfo.MultiSiteDescription = null;
            }


            // Remove PCII fields from CIS demographics
            if (_payload.CisDemographics != null)
            {
                _payload.CisDemographics.ServiceComposition = null;
                _payload.CisDemographics.ServiceDemographics = null;
                _payload.CisDemographics.OrganizationDemographics = null;
            }
        }


        /// <summary>
        /// 
        /// </summary>
        private void RemoveContacts()
        {
            if (_payload.Contacts != null)
            {
                _payload.Contacts = [];
            }
        }


        /// <summary>
        /// Removes all Comments, Observations and Feedback from the questions, 
        /// whether they are attached to Requirements, Standard Questions or Maturity Questions.
        /// </summary>
        private void SanitizeQuestions()
        {
            // Standards:  requirements and generic questions
            if (_payload.Standards != null)
            {
                if (_payload.Standards.Standards != null)
                {
                    _payload.Standards.Standards.ForEach(s =>
                    {
                        s.Requirements?.ForEach(r =>
                        {
                            r.Observations = [];
                            r.Comment = null;
                            r.Feedback = null;
                        });
                    });
                }

                if (_payload.Standards.Questions != null)
                {
                    _payload.Standards.Questions.ForEach(q =>
                    {
                        q.Questions?.ForEach(question =>
                        {
                            question.Observations = [];
                            question.Comment = null;
                            question.Feedback = null;
                        });

                    });
                }
            }


            // Component Questions 
            if (_payload.Details.ContainsKey("componentQuestions"))
            {
                List<ComponentQuestionJson> questions = _payload.Details["componentQuestions"]
                    as List<ComponentQuestionJson>;

                questions.ForEach(cq =>
                {
                    cq.Observations = [];
                    cq.Comment = null;
                    cq.Feedback = null;
                });
            }


            // Maturity questions
            _payload.MaturityModels?.ForEach(model =>
            {
                model.Groupings?.ForEach(g =>
                {
                    g.Questions?.ForEach(mq =>
                    {
                        mq.Observations = [];
                        mq.Comment = null;
                        mq.Feedback = null;
                    });
                });
            });
        }
    }
}

