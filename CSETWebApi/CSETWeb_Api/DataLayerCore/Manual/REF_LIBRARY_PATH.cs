using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;

namespace DataLayerCore.Model
{
    public partial class REF_LIBRARY_PATH
    {
        public IQueryable<GEN_FILE> GEN_FILE
        {
            get
            {

                CSET_Context context = new CSET_Context();
                context.GEN_FILE_LIB_PATH_CORL.Include("GEN_FILE");
                var NewRs = from a in context.GEN_FILE_LIB_PATH_CORL
                            join b in context.GEN_FILE on a.Gen_File_Id equals b.Gen_File_Id
                            where a.Lib_Path_Id == this.Lib_Path_Id 
                            select b;
                return NewRs;

            }
            private set { }
        }
    }
}