using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.DatabaseManager
{

    /// <summary>
    /// Controller that is calling these respective pieces. 
    /// 
    /// one class that is responsible for determining the current situation
    ///  
    /// based on the current situation each situation has an upgrader that knows how to handle that situation
    /// from 2022 to 2022 -- New instance
    /// from 2019 to 2022
    /// From 2012 to 2022
    /// 
    /// </summary>


    internal interface IUpgradeDatabaseEngine
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="from">what database engine are you currently at</param>
        /// <param name="to">What database engine do we want to go to</param>
        public void Execute(string from, string to);
    }
}
