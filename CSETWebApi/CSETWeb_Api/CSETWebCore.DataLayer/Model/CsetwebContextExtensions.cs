// Replacement implementations for low-complexity stored procedures
using Microsoft.EntityFrameworkCore;
using System.Threading.Tasks;

namespace CSETWebCore.DataLayer.Model
{
    public static class CsetwebContextExtensions
    {
        /// <summary>
        /// Inserts a Question_Group_Heading if it doesn't exist.
        /// LINQ equivalent of CheckHeading stored procedure.
        /// </summary>
        /// <param name="context">The database context</param>
        /// <param name="heading">The heading to check/insert</param>
        /// <returns>Task that completes when operation is done</returns>
        public static async Task CheckHeadingAsync(this CsetwebContext context, string heading)
        {
            if (string.IsNullOrWhiteSpace(heading))
            {
                return;
            }

            // Check if heading exists (case-insensitive due to SQL Server default collation)
            var exists = await context.QUESTION_GROUP_HEADING
                .AnyAsync(qh => qh.Question_Group_Heading1 == heading);

            if (!exists)
            {
                // Insert new heading
                // The unique index IX_Question_Group_Heading will prevent duplicates if there's a race condition
                try
                {
                    var newHeading = new QUESTION_GROUP_HEADING
                    {
                        Question_Group_Heading1 = heading,
                        Universal_Weight = 0,
                        Std_Ref = null,
                        Is_Custom = false
                    };

                    context.QUESTION_GROUP_HEADING.Add(newHeading);
                    await context.SaveChangesAsync();
                }
                catch (DbUpdateException)
                {
                    // Ignore duplicate key violations - another thread beat us to it
                    // The unique index ensures idempotency
                }
            }
        }

        /// <summary>
        /// Updates a user's email address if the new email is not already in use.
        /// LINQ equivalent of changeEmail stored procedure.
        /// </summary>
        /// <param name="context">The database context</param>
        /// <param name="originalEmail">The current email address</param>
        /// <param name="newEmail">The new email address</param>
        /// <returns>True if the update succeeded, false if new email is already in use or user not found</returns>
        public static async Task<bool> ChangeEmailAsync(this CsetwebContext context, string originalEmail, string newEmail)
        {
            if (string.IsNullOrWhiteSpace(originalEmail) || string.IsNullOrWhiteSpace(newEmail))
            {
                return false;
            }

            // Check if new email is already in use
            var newEmailExists = await context.USERS
                .AnyAsync(u => u.PrimaryEmail == newEmail);

            if (newEmailExists)
            {
                return false;
            }

            // Find user with original email and update
            var user = await context.USERS
                .FirstOrDefaultAsync(u => u.PrimaryEmail == originalEmail);

            if (user == null)
            {
                return false;
            }

            try
            {
                user.PrimaryEmail = newEmail;
                await context.SaveChangesAsync();
                return true;
            }
            catch (DbUpdateException)
            {
                // Unique constraint violation - another thread created a user with the new email
                return false;
            }
        }
    }
}
