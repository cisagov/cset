////////////////////////////////
//
//   Copyright 2026 Battelle Energy Alliance, LLC
//
//
////////////////////////////////
using System.Linq.Expressions;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Query;
using Moq;

namespace CSETWebCore.Business.Tests.Assessment.Helpers
{
    /// <summary>
    /// Provides utilities to mock Entity Framework Core DbSet for testing.
    /// Supports both synchronous LINQ operations and async enumerations.
    /// </summary>
    public static class DbSetMocking
    {
        /// <summary>
        /// Creates a mock DbSet from an in-memory list that supports LINQ and async operations.
        /// </summary>
        public static Mock<DbSet<T>> CreateMockSet<T>(IList<T> data) where T : class
        {
            var queryable = data.AsQueryable();
            var mockSet = new Mock<DbSet<T>>();

            // Setup IQueryable properties
            mockSet.As<IQueryable<T>>().Setup(m => m.Provider)
                .Returns(new TestAsyncQueryProvider<T>(queryable.Provider));
            mockSet.As<IQueryable<T>>().Setup(m => m.Expression).Returns(queryable.Expression);
            mockSet.As<IQueryable<T>>().Setup(m => m.ElementType).Returns(queryable.ElementType);
            mockSet.As<IQueryable<T>>().Setup(m => m.GetEnumerator()).Returns(() => queryable.GetEnumerator());

            // Setup IAsyncEnumerable for async operations
            mockSet.As<IAsyncEnumerable<T>>().Setup(m => m.GetAsyncEnumerator(It.IsAny<CancellationToken>()))
                .Returns(() => new TestAsyncEnumerator<T>(data.GetEnumerator()));

            // Setup Add/Remove operations
            mockSet.Setup(d => d.Add(It.IsAny<T>())).Callback<T>(e => data.Add(e));
            mockSet.Setup(d => d.AddRange(It.IsAny<IEnumerable<T>>())).Callback<IEnumerable<T>>(e =>
            {
                foreach (var x in e) data.Add(x);
            });
            mockSet.Setup(d => d.Remove(It.IsAny<T>())).Callback<T>(e => data.Remove(e));

            return mockSet;
        }
    }

    /// <summary>
    /// Test implementation of IAsyncQueryProvider for mocking async EF operations.
    /// </summary>
    internal class TestAsyncQueryProvider<TEntity> : IAsyncQueryProvider
    {
        private readonly IQueryProvider _inner;

        public TestAsyncQueryProvider(IQueryProvider inner) => _inner = inner;

        public IQueryable CreateQuery(Expression expression) => new TestAsyncEnumerable<TEntity>(expression);

        public IQueryable<TElement> CreateQuery<TElement>(Expression expression) => new TestAsyncEnumerable<TElement>(expression);

        public object Execute(Expression expression) => _inner.Execute(expression)!;

        public TResult Execute<TResult>(Expression expression) => _inner.Execute<TResult>(expression);

        public IAsyncEnumerable<TResult> ExecuteAsync<TResult>(Expression expression) => new TestAsyncEnumerable<TResult>(expression);

        public TResult ExecuteAsync<TResult>(Expression expression, CancellationToken cancellationToken = default)
            => Execute<TResult>(expression);
    }

    /// <summary>
    /// Test implementation of IAsyncEnumerable for mocking async query operations.
    /// </summary>
    internal class TestAsyncEnumerable<T> : EnumerableQuery<T>, IAsyncEnumerable<T>, IQueryable<T>
    {
        public TestAsyncEnumerable(IEnumerable<T> enumerable) : base(enumerable) { }

        public TestAsyncEnumerable(Expression expression) : base(expression) { }

        public IAsyncEnumerator<T> GetAsyncEnumerator(CancellationToken cancellationToken = default)
            => new TestAsyncEnumerator<T>(this.AsEnumerable().GetEnumerator());

        IQueryProvider IQueryable.Provider => new TestAsyncQueryProvider<T>(this);
    }

    /// <summary>
    /// Test implementation of IAsyncEnumerator for mocking async iteration.
    /// </summary>
    internal class TestAsyncEnumerator<T> : IAsyncEnumerator<T>
    {
        private readonly IEnumerator<T> _inner;

        public TestAsyncEnumerator(IEnumerator<T> inner) => _inner = inner;

        public T Current => _inner.Current;

        public ValueTask DisposeAsync()
        {
            _inner.Dispose();
            return ValueTask.CompletedTask;
        }

        public ValueTask<bool> MoveNextAsync() => new ValueTask<bool>(_inner.MoveNext());
    }
}
