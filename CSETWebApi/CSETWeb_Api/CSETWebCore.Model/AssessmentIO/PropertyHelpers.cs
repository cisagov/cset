using System;
using System.Linq.Expressions;

namespace CSETWebCore.Model.AssessmentIO
{
    public class PropertyHelpers
    {
        public static string GetPropertyName<T>(Expression<Func<T>> propertyExpression)
        {
            return (propertyExpression.Body as MemberExpression).Member.Name;
        }
    }
}