using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Model.CyOTE
{
    public class CyoteDetail
    {
        // there may be a few data items here
        // . . .


        /// <summary>
        /// The observables registered on the assessment
        /// </summary>
        public List<Observable> Observables { get; set; } = new List<Observable>();
    }
}
