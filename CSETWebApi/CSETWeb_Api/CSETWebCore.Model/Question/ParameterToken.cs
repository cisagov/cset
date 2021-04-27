namespace CSETWebCore.Model.Question
{
    public class ParameterToken
    {
        public int Id;
        public string Token;
        public string Substitution;
        public int RequirementId;
        public int AnswerId;

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
    }
}