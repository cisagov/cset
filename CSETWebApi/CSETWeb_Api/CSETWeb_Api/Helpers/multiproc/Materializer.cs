//using System;
//using System.Collections;
//using System.Collections.Concurrent;
//using System.Collections.Generic;
//using System.ComponentModel.DataAnnotations.Schema;
//using System.Data;
//using System.Data.Common;
//using System.Linq;

//namespace CSETWeb_Api.Helpers.multiproc
//{
//    public static class DataRecordExtensions
//    {
//        private static readonly ConcurrentDictionary<Type, object> _materializers = new ConcurrentDictionary<Type, object>();

//        public static IList<T> Translate<T>(this DbDataReader reader) where T : new()
//        {
//            var materializer = (Func<IDataRecord, T>)_materializers.GetOrAdd(typeof(T), (Func<IDataRecord, T>)Materializer.Materialize<T>);
//            return Translate(reader, materializer, out var hasNextResults);
//        }

//        public static IList<T> Translate<T>(this DbDataReader reader, Func<IDataRecord, T> objectMaterializer)
//        {
//            return Translate(reader, objectMaterializer, out var hasNextResults);
//        }

//        public static IList<T> Translate<T>(this DbDataReader reader, Func<IDataRecord, T> objectMaterializer,
//            out bool hasNextResult)
//        {
//            var results = new List<T>();
//            while (reader.Read())
//            {
//                var record = (IDataRecord)reader;
//                var obj = objectMaterializer(record);
//                results.Add(obj);
//            }

//            hasNextResult = reader.NextResult();

//            return results;
//        }

//        public static bool Exists(this IDataRecord record, string propertyName)
//        {
//            return Enumerable.Range(0, record.FieldCount).Any(x => record.GetName(x) == propertyName);
//        }
//    }

//    public class Materializer
//    {
//        public static T Materialize<T>(IDataRecord record) where T : new()
//        {
//            var t = new T();
//            foreach (var prop in typeof(T).GetProperties())
//            {
//                // 1). If entity reference, bypass it.
//                if (prop.PropertyType.Namespace == typeof(T).Namespace)
//                {
//                    continue;
//                }

//                // 2). If collection, bypass it.
//                if (prop.PropertyType != typeof(string) && typeof(IEnumerable).IsAssignableFrom(prop.PropertyType))
//                {
//                    continue;
//                }

//                // 3). If property is NotMapped, bypass it.
//                if (Attribute.IsDefined(prop, typeof(NotMappedAttribute)))
//                {
//                    continue;
//                }

//                // If the property doesn't map to an existing field, just continue.
//                if (!record.Exists(prop.Name)) continue;

//                var dbValue = record[prop.Name];
//                if (dbValue is DBNull) continue;

//                if (prop.PropertyType.IsConstructedGenericType &&
//                    prop.PropertyType.GetGenericTypeDefinition() == typeof(Nullable<>))
//                {
//                    var baseType = prop.PropertyType.GetGenericArguments()[0];
//                    var baseValue = Convert.ChangeType(dbValue, baseType);
//                    var value = Activator.CreateInstance(prop.PropertyType, baseValue);
//                    prop.SetValue(t, value);
//                }
//                else
//                {
//                    var value = Convert.ChangeType(dbValue, prop.PropertyType);
//                    prop.SetValue(t, value);
//                }
//            }

//            return t;
//        }
//    }
//}