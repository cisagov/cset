using System;
using Microsoft.Data.SqlClient;

namespace UpgradeLibrary.Upgrade
{
    interface IConvertSqlDatabase
    {
        void Execute(SqlConnection conn);
    }
}

