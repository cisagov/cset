using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Query;

namespace DataLayerCore.Model
{
    public static class IQueryableExtensions
    {
        public static IQueryable<T> AddWheres<T>(
            this DbSet<T> table, params Expression<Func<T, bool>>[] wheres) where T : class, new()
        {
            if (wheres == null || wheres.Length == 0)
            {
                return table.AsQueryable();
            }
            return table.AsQueryable().AddWheres(wheres);
        }

        public static IQueryable<T> AddWheres<T>(
            this IQueryable<T> query, params Expression<Func<T, bool>>[] wheres) where T : new()
        {
            if (wheres == null || wheres.Length == 0)
            {
                return query;
            }
            return wheres.Length == 1
                ? query.Where(wheres[0])
                : wheres.Aggregate(query, (current, espression) => current.Where(espression));
        }

        public static IQueryable<T> AddIncludes<T>(
            this IQueryable<T> query, params Func<IQueryable<T>,IIncludableQueryable<T, object>>[] includes)
            where T : class, new()
        {
            foreach (var expression in includes)
            {
                query = expression(query);
            }
            return query;
        }
        public static IQueryable<T> AddOrderBys<T>(
            this DbSet<T> table, params (Expression<Func<T, object>>, bool)[] orderBys) where T : class, new()
        {
            if (orderBys == null || orderBys.Length == 0)
            {
                return table.AsQueryable();
            }
            return table.AsQueryable().AddOrderBys(orderBys);
        }

        public static IQueryable<T> AddOrderBys<T>(
            this IQueryable<T> query, params (Expression<Func<T, object>> expresssion, bool ascending)[] orderBys) where T : class, new()
        {
            if (orderBys == null || orderBys.Length == 0)
            {
                return query;
            }
            foreach (var itm in orderBys)
            {
                if (query.Expression.Type != typeof(IOrderedQueryable<T>))
                {
                    query = itm.ascending 
                        ? query.OrderBy(itm.expresssion) 
                        : query.OrderByDescending(itm.expresssion);
                }
                else
                {
                    query = itm.ascending 
                        ? ((IOrderedQueryable<T>)query).ThenBy(itm.expresssion) 
                        : ((IOrderedQueryable<T>)query).ThenByDescending(itm.expresssion);
                }
            }
            return query;
        }
    }
}