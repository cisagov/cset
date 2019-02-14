using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;

namespace DataLayerCore.Model
{
    public partial class ANSWER
    {
        public IQueryable<DOCUMENT_FILE> DOCUMENT_FILEs()
        {   
            CSET_Context context = new CSET_Context();
                
            var NewRs = from a in context.DOCUMENT_ANSWERS
                        join b in context.DOCUMENT_FILE on a.Document_Id equals b.Document_Id
                        where a.Answer_Id == this.Answer_Id
                        select b;
            return NewRs;
        }
    }
}