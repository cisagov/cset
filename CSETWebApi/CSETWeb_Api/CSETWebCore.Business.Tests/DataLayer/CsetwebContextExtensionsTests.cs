using CSETWebCore.DataLayer.Model;
using Microsoft.EntityFrameworkCore;

namespace CSETWebCore.Business.Tests.DataLayer
{
    public class CsetwebContextExtensionsTests
    {
        private CsetwebContext CreateInMemoryContext()
        {
            var options = new DbContextOptionsBuilder<CsetwebContext>()
                .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
                .Options;

            return new CsetwebContext(options);
        }

        [Fact]
        public async Task CheckHeading_InsertsNewHeading_WhenNotExists()
        {
            // Arrange
            using var context = CreateInMemoryContext();
            var heading = "Test Heading";

            // Act
            await context.CheckHeadingAsync(heading);

            // Assert
            var exists = await context.QUESTION_GROUP_HEADING
                .AnyAsync(qh => qh.Question_Group_Heading1 == heading);
            Assert.True(exists);
        }

        [Fact]
        public async Task CheckHeading_DoesNotDuplicate_WhenHeadingExists()
        {
            // Arrange
            using var context = CreateInMemoryContext();
            var heading = "Test Heading";

            // Add heading first time
            await context.CheckHeadingAsync(heading);
            var countAfterFirst = await context.QUESTION_GROUP_HEADING
                .CountAsync(qh => qh.Question_Group_Heading1 == heading);

            // Act - add same heading again
            await context.CheckHeadingAsync(heading);

            // Assert - should still be only one
            var countAfterSecond = await context.QUESTION_GROUP_HEADING
                .CountAsync(qh => qh.Question_Group_Heading1 == heading);
            Assert.Equal(1, countAfterFirst);
            Assert.Equal(1, countAfterSecond);
        }

        [Fact]
        public async Task CheckHeading_HandlesNullInput()
        {
            // Arrange
            using var context = CreateInMemoryContext();

            // Act
            await context.CheckHeadingAsync(null);

            // Assert - no exception thrown, no rows added
            var count = await context.QUESTION_GROUP_HEADING.CountAsync();
            Assert.Equal(0, count);
        }

        [Fact]
        public async Task CheckHeading_HandlesWhitespaceInput()
        {
            // Arrange
            using var context = CreateInMemoryContext();

            // Act
            await context.CheckHeadingAsync("   ");

            // Assert - no rows added
            var count = await context.QUESTION_GROUP_HEADING.CountAsync();
            Assert.Equal(0, count);
        }

        [Fact]
        public async Task ChangeEmail_UpdatesEmail_WhenNewEmailNotInUse()
        {
            // Arrange
            using var context = CreateInMemoryContext();
            var originalEmail = "original@test.com";
            var newEmail = "new@test.com";

            var user = new USERS
            {
                PrimaryEmail = originalEmail,
                Lang = "en",
                EmailSentCount = 0,
                IsActive = true
            };
            context.USERS.Add(user);
            await context.SaveChangesAsync();

            // Act
            var result = await context.ChangeEmailAsync(originalEmail, newEmail);

            // Assert
            Assert.True(result);
            var updatedUser = await context.USERS.FirstOrDefaultAsync(u => u.UserId == user.UserId);
            Assert.Equal(newEmail, updatedUser?.PrimaryEmail);
        }

        [Fact]
        public async Task ChangeEmail_ReturnsFalse_WhenNewEmailAlreadyInUse()
        {
            // Arrange
            using var context = CreateInMemoryContext();
            var originalEmail = "original@test.com";
            var newEmail = "existing@test.com";

            var user1 = new USERS
            {
                PrimaryEmail = originalEmail,
                Lang = "en",
                EmailSentCount = 0,
                IsActive = true
            };
            var user2 = new USERS
            {
                PrimaryEmail = newEmail,
                Lang = "en",
                EmailSentCount = 0,
                IsActive = true
            };
            context.USERS.Add(user1);
            context.USERS.Add(user2);
            await context.SaveChangesAsync();

            // Act
            var result = await context.ChangeEmailAsync(originalEmail, newEmail);

            // Assert
            Assert.False(result);
            var unchangedUser = await context.USERS.FirstOrDefaultAsync(u => u.UserId == user1.UserId);
            Assert.Equal(originalEmail, unchangedUser?.PrimaryEmail);
        }

        [Fact]
        public async Task ChangeEmail_ReturnsFalse_WhenUserNotFound()
        {
            // Arrange
            using var context = CreateInMemoryContext();
            var originalEmail = "nonexistent@test.com";
            var newEmail = "new@test.com";

            // Act
            var result = await context.ChangeEmailAsync(originalEmail, newEmail);

            // Assert
            Assert.False(result);
        }

        [Fact]
        public async Task ChangeEmail_HandlesNullInput()
        {
            // Arrange
            using var context = CreateInMemoryContext();

            // Act & Assert
            var result1 = await context.ChangeEmailAsync(null, "new@test.com");
            Assert.False(result1);

            var result2 = await context.ChangeEmailAsync("old@test.com", null);
            Assert.False(result2);

            var result3 = await context.ChangeEmailAsync(null, null);
            Assert.False(result3);
        }

        [Fact]
        public async Task ChangeEmail_HandlesWhitespaceInput()
        {
            // Arrange
            using var context = CreateInMemoryContext();

            // Act & Assert
            var result1 = await context.ChangeEmailAsync("   ", "new@test.com");
            Assert.False(result1);

            var result2 = await context.ChangeEmailAsync("old@test.com", "   ");
            Assert.False(result2);
        }
    }
}
