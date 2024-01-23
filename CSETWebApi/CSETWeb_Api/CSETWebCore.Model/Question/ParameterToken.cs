//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWebCore.Model.Question
{
    public class ParameterToken
    {
        public int Id { get; set; }
        public string Token { get; set; }
        public string Substitution { get; set; }
        public int RequirementId { get; set; }
        public int AnswerId { get; set; }

        /// <summary>
        /// Constructor
        /// </summary>
        public ParameterToken(int id, string token, string substitution, int reqId, int ansId)
        {
            this.Id = id;
            this.Token = token;
            this.Substitution = substitution;
            this.RequirementId = reqId;
            this.AnswerId = ansId;
        }

        public ParameterToken() { }
    }
}