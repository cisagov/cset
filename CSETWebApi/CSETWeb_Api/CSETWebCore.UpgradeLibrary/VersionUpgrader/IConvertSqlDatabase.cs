//////////////////////////////// 
// 
//   Copyright 2023 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using Microsoft.Data.SqlClient;

namespace UpgradeLibrary.Upgrade
{
    interface IConvertSqlDatabase
    {
        void Execute(SqlConnection conn);
    }
}

