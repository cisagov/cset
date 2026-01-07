using CSETWebCore.Business.Contact;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Helpers;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Notification;
using CSETWebCore.Interfaces.User;
using CSETWebCore.Model.Contact;
using Microsoft.EntityFrameworkCore;
using Moq;

namespace CSETWebCore.Business.Tests.Contact
{
    /// <summary>
    /// Unit tests for ContactBusiness class.
    /// Tests contact management functionality including retrieval, creation, update, and deletion.
    /// </summary>
    public class ContactBusinessTests : IDisposable
    {
        private readonly Mock<CSETContext> _mockContext;
        private readonly Mock<IAssessmentUtil> _mockAssessmentUtil;
        private readonly Mock<ITokenManager> _mockTokenManager;
        private readonly Mock<INotificationBusiness> _mockNotificationBusiness;
        private readonly Mock<IUserBusiness> _mockUserBusiness;
        private readonly Mock<ILocalInstallationHelper> _mockLocalInstallationHelper;
        private readonly ContactBusiness _contactBusiness;

        public ContactBusinessTests()
        {
            _mockContext = new Mock<CSETContext>();
            _mockAssessmentUtil = new Mock<IAssessmentUtil>();
            _mockTokenManager = new Mock<ITokenManager>();
            _mockNotificationBusiness = new Mock<INotificationBusiness>();
            _mockUserBusiness = new Mock<IUserBusiness>();
            _mockLocalInstallationHelper = new Mock<ILocalInstallationHelper>();

            _contactBusiness = new ContactBusiness(
                _mockContext.Object,
                _mockAssessmentUtil.Object,
                _mockTokenManager.Object,
                _mockNotificationBusiness.Object,
                _mockUserBusiness.Object,
                _mockLocalInstallationHelper.Object
            );
        }

        [Fact]
        public void GetContacts_ReturnsEmptyList_WhenNoContactsExist()
        {
            // Arrange
            var assessmentId = 1;
            var emptyContacts = new List<ASSESSMENT_CONTACTS>();
            var mockContactSet = CreateMockDbSet(emptyContacts);

            _mockContext.Setup(c => c.ASSESSMENT_CONTACTS).Returns(mockContactSet.Object);
            _mockTokenManager.Setup(t => t.PayloadInt(It.IsAny<string>())).Returns((int?)null);

            // Act
            var result = _contactBusiness.GetContacts(assessmentId);

            // Assert
            Assert.NotNull(result);
            Assert.Empty(result);
        }

        [Fact]
        public void GetContacts_ReturnsContactList_WhenContactsExist()
        {
            // Arrange
            var assessmentId = 1;
            var contacts = new List<ASSESSMENT_CONTACTS>
            {
                new ASSESSMENT_CONTACTS
                {
                    Assessment_Id = assessmentId,
                    Assessment_Contact_Id = 1,
                    FirstName = "John",
                    LastName = "Doe",
                    PrimaryEmail = "john.doe@example.com",
                    AssessmentRoleId = 1,
                    Invited = true,
                    UserId = 100,
                    Title = "Manager",
                    Phone = "555-1234",
                    Cell_Phone = "555-5678",
                    Is_Primary_POC = true
                }
            };

            var mockContactSet = CreateMockDbSet(contacts);
            _mockContext.Setup(c => c.ASSESSMENT_CONTACTS).Returns(mockContactSet.Object);
            _mockTokenManager.Setup(t => t.PayloadInt(It.IsAny<string>())).Returns((int?)null);

            // Act
            var result = _contactBusiness.GetContacts(assessmentId);

            // Assert
            Assert.NotNull(result);
            Assert.Single(result);
            Assert.Equal("John", result[0].FirstName);
            Assert.Equal("Doe", result[0].LastName);
            Assert.Equal("john.doe@example.com", result[0].PrimaryEmail);
            Assert.Equal(1, result[0].AssessmentRoleId);
            Assert.True(result[0].Invited);
        }

        [Fact]
        public void GetContactsByAssessmentId_ReturnsContactsFromMultipleAssessments()
        {
            // Arrange
            var contacts = new List<ASSESSMENT_CONTACTS>
            {
                new ASSESSMENT_CONTACTS
                {
                    Assessment_Id = 1,
                    Assessment_Contact_Id = 1,
                    FirstName = "Alice",
                    LastName = "Smith",
                    PrimaryEmail = "alice@example.com",
                    AssessmentRoleId = 1
                },
                new ASSESSMENT_CONTACTS
                {
                    Assessment_Id = 2,
                    Assessment_Contact_Id = 2,
                    FirstName = "Bob",
                    LastName = "Jones",
                    PrimaryEmail = "bob@example.com",
                    AssessmentRoleId = 2
                }
            };

            var mockContactSet = CreateMockDbSet(contacts);
            _mockContext.Setup(c => c.ASSESSMENT_CONTACTS).Returns(mockContactSet.Object);

            // Act
            var result = _contactBusiness.GetContactsByAssessmentId(1, 2);

            // Assert
            Assert.NotNull(result);
            Assert.Equal(2, result.Count);
            Assert.Contains(result, c => c.FirstName == "Alice");
            Assert.Contains(result, c => c.FirstName == "Bob");
        }

        [Fact]
        public void SearchContacts_ReturnsEmpty_WhenSearchParmsIsNull()
        {
            // Arrange
            var userId = 1;

            // Act
            var result = _contactBusiness.SearchContacts(userId, null);

            // Assert
            Assert.NotNull(result);
            Assert.Empty(result);
        }

        [Fact]
        public void SearchContacts_ReturnsEmpty_WhenAllSearchFieldsAreEmpty()
        {
            // Arrange
            var userId = 1;
            var searchParms = new ContactSearchParameters
            {
                FirstName = "",
                LastName = "",
                PrimaryEmail = "",
                AssessmentId = 1
            };

            // Act
            var result = _contactBusiness.SearchContacts(userId, searchParms);

            // Assert
            Assert.NotNull(result);
            Assert.Empty(result);
        }

        [Fact]
        public void AddContactToAssessment_CreatesNewContact_WhenContactDoesNotExist()
        {
            // Arrange
            var assessmentId = 1;
            var userId = 100;
            var roleId = 1;
            var invited = true;

            var user = new USERS
            {
                UserId = userId,
                FirstName = "Jane",
                LastName = "Doe",
                PrimaryEmail = "jane.doe@example.com"
            };

            var users = new List<USERS> { user };
            var mockUserSet = CreateMockDbSet(users);

            var contacts = new List<ASSESSMENT_CONTACTS>();
            var mockContactSet = CreateMockDbSet(contacts);

            _mockContext.Setup(c => c.USERS).Returns(mockUserSet.Object);
            _mockContext.Setup(c => c.ASSESSMENT_CONTACTS).Returns(mockContactSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);
            _mockAssessmentUtil.Setup(a => a.TouchAssessment(It.IsAny<int>()));

            // Act
            var result = _contactBusiness.AddContactToAssessment(assessmentId, userId, roleId, invited);

            // Assert
            Assert.NotNull(result);
            Assert.Equal("Jane", result.FirstName);
            Assert.Equal("Doe", result.LastName);
            Assert.Equal("jane.doe@example.com", result.PrimaryEmail);
            Assert.Equal(roleId, result.AssessmentRoleId);
            Assert.Equal(invited, result.Invited);
            _mockContext.Verify(c => c.SaveChanges(), Times.Once);
            _mockAssessmentUtil.Verify(a => a.TouchAssessment(assessmentId), Times.Once);
        }

        [Fact]
        public void GetUserRoleOnAssessment_ReturnsRoleId_WhenUserHasRole()
        {
            // Arrange
            var userId = 100;
            var assessmentId = 1;
            var expectedRoleId = 2;

            var contacts = new List<ASSESSMENT_CONTACTS>
            {
                new ASSESSMENT_CONTACTS
                {
                    UserId = userId,
                    Assessment_Id = assessmentId,
                    AssessmentRoleId = expectedRoleId
                }
            };

            var mockContactSet = CreateMockDbSet(contacts);
            _mockContext.Setup(c => c.ASSESSMENT_CONTACTS).Returns(mockContactSet.Object);

            // Act
            var result = _contactBusiness.GetUserRoleOnAssessment(userId, assessmentId);

            // Assert
            Assert.NotNull(result);
            Assert.Equal(expectedRoleId, result.Value);
        }

        [Fact]
        public void GetUserRoleOnAssessment_ReturnsNull_WhenUserHasNoRole()
        {
            // Arrange
            var userId = 100;
            var assessmentId = 1;

            var contacts = new List<ASSESSMENT_CONTACTS>();
            var mockContactSet = CreateMockDbSet(contacts);
            _mockContext.Setup(c => c.ASSESSMENT_CONTACTS).Returns(mockContactSet.Object);

            // Act
            var result = _contactBusiness.GetUserRoleOnAssessment(userId, assessmentId);

            // Assert
            Assert.Null(result);
        }

        [Fact]
        public void RemoveContact_DeletesContactAndRelatedData()
        {
            // Arrange
            var assessmentContactId = 1;
            var assessmentId = 1;

            var contact = new ASSESSMENT_CONTACTS
            {
                Assessment_Contact_Id = assessmentContactId,
                Assessment_Id = assessmentId,
                FirstName = "Test",
                LastName = "User"
            };

            var contacts = new List<ASSESSMENT_CONTACTS> { contact };
            var mockContactSet = CreateMockDbSet(contacts);

            var findingContacts = new List<FINDING_CONTACT>();
            var mockFindingContactSet = CreateMockDbSet(findingContacts);

            var demographics = new List<DETAILS_DEMOGRAPHICS>();
            var mockDemographicsSet = CreateMockDbSet(demographics);

            _mockContext.Setup(c => c.ASSESSMENT_CONTACTS).Returns(mockContactSet.Object);
            _mockContext.Setup(c => c.FINDING_CONTACT).Returns(mockFindingContactSet.Object);
            _mockContext.Setup(c => c.DETAILS_DEMOGRAPHICS).Returns(mockDemographicsSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);
            _mockAssessmentUtil.Setup(a => a.TouchAssessment(It.IsAny<int>()));

            // Act
            var result = _contactBusiness.RemoveContact(assessmentContactId);

            // Assert
            Assert.NotNull(result);
            mockContactSet.Verify(m => m.Remove(It.IsAny<ASSESSMENT_CONTACTS>()), Times.Once);
            _mockContext.Verify(c => c.SaveChanges(), Times.Once);
            _mockAssessmentUtil.Verify(a => a.TouchAssessment(assessmentId), Times.Once);
        }

        [Fact]
        public void RemoveContact_ThrowsException_WhenContactDoesNotExist()
        {
            // Arrange
            var assessmentContactId = 999;
            var contacts = new List<ASSESSMENT_CONTACTS>();
            var mockContactSet = CreateMockDbSet(contacts);

            _mockContext.Setup(c => c.ASSESSMENT_CONTACTS).Returns(mockContactSet.Object);

            // Act & Assert
            var exception = Assert.Throws<Exception>(() => _contactBusiness.RemoveContact(assessmentContactId));
            Assert.Equal("User does not exist", exception.Message);
        }

        [Fact]
        public void GetAllRoles_ReturnsAllAssessmentRoles()
        {
            // Arrange
            var roles = new List<ASSESSMENT_ROLES>
            {
                new ASSESSMENT_ROLES { AssessmentRoleId = 1, AssessmentRole = "User" },
                new ASSESSMENT_ROLES { AssessmentRoleId = 2, AssessmentRole = "Admin" }
            };

            var mockRoleSet = CreateMockDbSet(roles);
            _mockContext.Setup(c => c.ASSESSMENT_ROLES).Returns(mockRoleSet.Object);

            // Act
            var result = _contactBusiness.GetAllRoles();

            // Assert
            Assert.NotNull(result);
            // The result is an anonymous type collection, so we can verify it's not null
            // and contains elements by converting to list
            var roleList = ((IEnumerable<object>)result).ToList();
            Assert.Equal(2, roleList.Count);
        }

        [Fact]
        public void UpdateContact_UpdatesExistingContact()
        {
            // Arrange
            var userId = 100;
            var assessmentId = 1;

            var existingContact = new ASSESSMENT_CONTACTS
            {
                UserId = userId,
                Assessment_Id = assessmentId,
                FirstName = "OldFirst",
                LastName = "OldLast",
                PrimaryEmail = "old@example.com"
            };

            var contacts = new List<ASSESSMENT_CONTACTS> { existingContact };
            var mockContactSet = CreateMockDbSet(contacts);

            _mockContext.Setup(c => c.ASSESSMENT_CONTACTS).Returns(mockContactSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);

            var updatedContact = new ContactDetail
            {
                UserId = userId,
                AssessmentId = assessmentId,
                FirstName = "NewFirst",
                LastName = "NewLast",
                PrimaryEmail = "new@example.com",
                AssessmentRoleId = 2,
                Title = "Director",
                Phone = "555-9999"
            };

            // Act
            _contactBusiness.UpdateAssessmentContact(updatedContact, userId);

            // Assert
            Assert.Equal("NewFirst", existingContact.FirstName);
            Assert.Equal("NewLast", existingContact.LastName);
            Assert.Equal("new@example.com", existingContact.PrimaryEmail);
            Assert.Equal(2, existingContact.AssessmentRoleId);
            _mockContext.Verify(c => c.SaveChanges(), Times.Once);
        }

        /// <summary>
        /// Helper method to create a mock DbSet from a list of entities
        /// </summary>
        private Mock<DbSet<T>> CreateMockDbSet<T>(List<T> data) where T : class
        {
            var queryable = data.AsQueryable();
            var mockSet = new Mock<DbSet<T>>();

            mockSet.As<IQueryable<T>>().Setup(m => m.Provider).Returns(queryable.Provider);
            mockSet.As<IQueryable<T>>().Setup(m => m.Expression).Returns(queryable.Expression);
            mockSet.As<IQueryable<T>>().Setup(m => m.ElementType).Returns(queryable.ElementType);
            mockSet.As<IQueryable<T>>().Setup(m => m.GetEnumerator()).Returns(() => queryable.GetEnumerator());

            return mockSet;
        }

        public void Dispose()
        {
            // Cleanup if needed
        }
    }
}
