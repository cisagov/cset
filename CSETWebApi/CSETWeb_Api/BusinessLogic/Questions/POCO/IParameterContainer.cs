//////////////////////////////// 
// 
//   Copyright 2018 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSET_Main.Questions.POCO
{
    public interface IParameterContainer
    {
        int Id { get; }
        string Name { get; }
        string Default { get; }
        
    }
}


