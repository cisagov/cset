//////////////////////////////// 
// 
//   Copyright 2018 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data.Common;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.Data.SqlClient;
using System.Linq;

namespace CSETWeb_Api.Common
{

    /// <summary>
    /// var command = new SqlCommand()
    /// {   
    /// CommandText = "[dbo].[Pets]",
    /// CommandType = CommandType.StoredProcedure
    /// add parameter values
    /// };
    /// 
    /// var results = contect.MultipleResults(command)
    ///     .With<Cat>()
    ///     .With<Dog>()
    ///     .Execute();
    /// </summary>
public static class MultipleResultSets
    {
        public static MultipleResultSetWrapper MultipleResults(this DbContext db, SqlCommand storedProcedure)
        {
            return new MultipleResultSetWrapper(db, storedProcedure);
        }

        public class MultipleResultSetWrapper
        {
            private readonly DbContext _db;
            private readonly SqlCommand _storedProcedure;
            public List<Func<IObjectContextAdapter, DbDataReader, IEnumerable>> _resultSets;

            public MultipleResultSetWrapper(DbContext db, SqlCommand storedProcedure)
            {
                _db = db;
                _storedProcedure = storedProcedure;
                _resultSets = new List<Func<IObjectContextAdapter, DbDataReader, IEnumerable>>();
            }

            public MultipleResultSetWrapper With<TResult>()
            {
                _resultSets.Add((adapter, reader) => adapter
                    .ObjectContext
                    .Translate<TResult>(reader)
                    .ToList());

                return this;
            }

            public List<IEnumerable> Execute()
            {
                var results = new List<IEnumerable>();

                using (var connection = _db.Database.Connection)
                {
                    connection.Open();
                    _storedProcedure.Connection = (SqlConnection)connection;
                    using (var reader = _storedProcedure.ExecuteReader())
                    {
                        var adapter = ((IObjectContextAdapter)_db);
                        foreach (var resultSet in _resultSets)
                        {
                            results.Add(resultSet(adapter, reader));
                            reader.NextResult();
                        }
                    }
                    return results;
                }
            }
        }
    }
}

