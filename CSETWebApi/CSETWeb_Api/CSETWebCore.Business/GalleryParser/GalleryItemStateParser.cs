using CSETWebCore.DataLayer.Model;
using CSETWebCore.Helpers;
using CSETWebCore.Interfaces.Maturity;
using CSETWebCore.Interfaces.Question;
using CSETWebCore.Interfaces.Standards;
using CSETWebCore.Model.Sal;
using System.Collections.Generic;
using System.Linq;
using System.Text.Json;
using System.Text.Json.Serialization;

namespace CSETWebCore.Business.GalleryParser
{

    public class GalleryItemStateParser:IGalleryStateParser
    {
        private CSETContext _context;
        private IMaturityBusiness _maturity_business;
        private IStandardsBusiness _standardsBusiness;
        private IQuestionRequirementManager _questionRequirementMananger;

        public GalleryItemStateParser(CSETContext context, IMaturityBusiness maturityBusiness
            ,IStandardsBusiness standardsBusiness
            ,IQuestionRequirementManager questionRequirementManager)
        {

            _context = context;
            _maturity_business = maturityBusiness;
            _standardsBusiness = standardsBusiness;
            _questionRequirementMananger = questionRequirementManager;
        }

        /// <summary>        
        /// gets the given gallery_item and sets the configuration
        /// for that gallery item.
        /// </summary>
        /// <param name="assessment_id"></param>
        /// <param name="gallery_item_id"></param>
        public void ProcessParserState(int assessment_id, int gallery_item_id)
        {
            /**Get the state from the database for the given item
             * once we have that state parse it and call the appropriate methods            
              GalleryConfig:{
	            MatModel:{ModelName:"CRR", Level:1},
	              Sets:["800-53",
		            "TSAPipeline"]
	               ,SALLevel:"Low"
                   ,QuestionMode:"Requirements",
	                  SAL_Detail:{
		                "selected_Sal_Level": null,
		                "last_Sal_Determination_Type": null,
		                "sort_Set_Name": null,
		                "cLevel": null,
		                "iLevel": null,
		                "aLevel": null,
		                "selectedSALOverride": false
	                  }	
                  }
              }
            */

            var item = _context.GALLERY_ITEM.Where(x => x.Gallery_Item_Id == gallery_item_id).FirstOrDefault();
            parseAndProcess(assessment_id, item.Configuration_Setup);
        }

        public void parseAndProcess(int assessment_id,string config)
        {
            GalleryConfig gallery = (GalleryConfig) JsonSerializer.Deserialize<GalleryConfig>(config);
            //process the matModels
            if (gallery.MatModel != null)
            {
                _maturity_business.PersistSelectedMaturityModel(assessment_id, gallery.MatModel.ModelName);
                _maturity_business.PersistMaturityLevel(assessment_id, gallery.MatModel.Level);
            }            
            //process the standards
            if(gallery.Sets != null)
            {
                _standardsBusiness.PersistSelectedStandards(assessment_id, gallery.Sets);                
            }
            //set the sal level
            if (gallery.SALLevel != null)
            {
                LevelManager lm = new LevelManager(assessment_id, _context);
                STANDARD_SELECTION s =  _context.STANDARD_SELECTION.Where(x => x.Assessment_Id == assessment_id).FirstOrDefault();
                lm.Init(s);
                lm.SaveSALLevel(gallery.SALLevel);                
            }
            //set the questions mode
            if (gallery.QuestionMode != null)
            {
                _questionRequirementMananger.SetApplicationMode(gallery.QuestionMode);
            }

        }
    }
    public class GalleryConfig
    {
        [JsonPropertyName("MatModel")]
        public MatModel MatModel { get; set; }

        [JsonPropertyName("Sets")]
        public List<string> Sets { get; set; }

        [JsonPropertyName("SALLevel")]
        public string SALLevel { get; set; }

        [JsonPropertyName("QuestionMode")]
        public string QuestionMode { get; set; }
        [JsonPropertyName("SAL_Detail")]
        public Sals SALDetail { get; set; }
    }

    public class MatModel
    {
        [JsonPropertyName("ModelName")]
        public string ModelName { get; set; }

        [JsonPropertyName("Level")]
        public int Level { get; set; }
    }
  
}
