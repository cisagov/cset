//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;
using CSETWebCore.Model.Question;

namespace CSETWebCore.Helpers
{
    public class ParameterSubstitution
    {
        public List<ParameterToken> Tokens = new List<ParameterToken>();


        /// <summary>
        /// Adds a new element to the tokens list or overwrites
        /// if it already exists.  This is so that we can overlay
        /// global settings with local/answer settings.
        /// </summary>
        /// <param name="token"></param>
        /// <param name="substitution"></param>
        public void Set(int id, string token, string substitution, int reqId, int ansId)
        {
            var t = this.Tokens.Find(x => x.Token == token);
            if (t != null)
            {
                t.Substitution = substitution;
                t.RequirementId = reqId;
                t.AnswerId = ansId;
            }
            else
            {
                Tokens.Add(new ParameterToken(id, token, substitution, reqId, ansId));
            }
        }
    }
}