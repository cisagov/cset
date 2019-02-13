//////////////////////////////// 
// 
//   Copyright 2018 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSET_Main.Questions.POCO;
using DataLayer;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;

namespace CSET_Main.Questions.Slice
{
    public class RequirementsPocoBuilder
    {
        public Dictionary<int, Requirement_And_Set> Requirements { get; private set; }
        

        private Dictionary<String, List<QuestionPoco>> dictionaryCNSSICategory;        
        private Boolean createQuestionPoco;
        private CSETWebEntities DataContext { get; }

        public RequirementsPocoBuilder(CSETWebEntities datacontext)
        {
            this.DataContext = datacontext;
            this.dictionaryCNSSICategory = new Dictionary<string, List<QuestionPoco>>();          
        }

        public void BuildRequirementQuestionPocos(UNIVERSAL_SAL_LEVEL selectedSalLevel, List<SET> listActiveStandards)
        {
            createQuestionPoco = true;
            InitAndBuildRequirementQuestionPocos(selectedSalLevel, listActiveStandards);            
        }

        

        private void InitAndBuildRequirementQuestionPocos(UNIVERSAL_SAL_LEVEL sal, List<SET> sets)
        {
            Requirements = new Dictionary<int, Requirement_And_Set>();
            dictionaryCNSSICategory.Clear();           
        }
       

        private void SetCNSSIQuestionNumbers()
        {
            foreach (List<QuestionPoco> listQuestions in dictionaryCNSSICategory.Values)
            {
                int i = 1;
                foreach (QuestionPoco qp in listQuestions.OrderBy(x=>x.Question_or_Requirement_ID))
                {
                    qp.CNSSINumber = i;
                    i++;
                }
            }
        }

        private void AddCNSSIQuestions(Requirement_And_Set requirementSet)
        {
            if (requirementSet.IsCNSSI)
            {
                List<QuestionPoco> listQuestionCNSSI;

                if (!dictionaryCNSSICategory.TryGetValue(requirementSet.Question.Category, out listQuestionCNSSI))
                {
                    listQuestionCNSSI = new List<QuestionPoco>();
                    dictionaryCNSSICategory.Add(requirementSet.Question.Category, listQuestionCNSSI);

                }
                listQuestionCNSSI.Add(requirementSet.Question);
            }
        }
    }
}


