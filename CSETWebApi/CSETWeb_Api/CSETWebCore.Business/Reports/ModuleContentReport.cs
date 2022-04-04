using CSETWebCore.Business.ModuleBuilder;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Question;
using CSETWebCore.Model.Set;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Business.Reports
{
    public class ModuleContentReport
    {
        private CSETContext _context;
        private readonly IQuestionRequirementManager _question;


        public ModuleContentReport(CSETContext context, IQuestionRequirementManager question)
        {
            _context = context;
            _question = question;
        }


        /// <summary>
        /// 
        /// </summary>
        public ModuleResponse GetResponse(string set)
        {
            var mbb = new ModuleBuilderBusiness(_context, _question);
            return mbb.GetModuleStructure(set);
        }
    }
}
