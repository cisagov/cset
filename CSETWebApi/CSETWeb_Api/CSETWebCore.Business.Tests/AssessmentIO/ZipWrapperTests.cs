////////////////////////////////
//
//   Copyright 2026 Battelle Energy Alliance, LLC
//
//
////////////////////////////////
using System.Text;
using ICSharpCode.SharpZipLib.Zip;
using CSETWebCore.Business.AssessmentIO;

namespace CSETWebCore.Business.Tests.AssessmentIO
{
    /// <summary>
    /// Unit tests for SharpZipLibWrapper utility class.
    /// </summary>
    public class ZipWrapperTests : IDisposable
    {
        private MemoryStream _outputStream;

        public ZipWrapperTests()
        {
            _outputStream = new MemoryStream();
        }

        public void Dispose()
        {
            _outputStream?.Dispose();
        }

        [Fact]
        public void Constructor_InitializesSuccessfully()
        {
            // Arrange & Act
            using var wrapper = new SharpZipLibWrapper(_outputStream);

            // Assert
            Assert.NotNull(wrapper);
            Assert.NotNull(wrapper._zipStream);
        }

        [Fact]
        public void AddEntry_WithStringContent_AddsEntrySuccessfully()
        {
            // Arrange
            var entryName = "test.txt";
            var content = "Hello, World!";

            // Act
            using (var wrapper = new SharpZipLibWrapper(_outputStream))
            {
                wrapper.AddEntry(entryName, content);
                wrapper.Save();
                wrapper.CloseStream();
            }

            // Assert
            _outputStream.Seek(0, SeekOrigin.Begin);
            using var zipFile = new ZipFile(_outputStream);
            Assert.Equal(1, zipFile.Count);

            var entry = zipFile.GetEntry(entryName);
            Assert.NotNull(entry);

            using var entryStream = zipFile.GetInputStream(entry);
            using var reader = new StreamReader(entryStream);
            var actualContent = reader.ReadToEnd();
            Assert.Equal(content, actualContent);
        }

        [Fact]
        public void AddEntry_WithStreamContent_AddsEntrySuccessfully()
        {
            // Arrange
            var entryName = "stream-data.bin";
            var content = new byte[] { 0x01, 0x02, 0x03, 0x04, 0x05 };
            var contentStream = new MemoryStream(content);

            // Act
            using (var wrapper = new SharpZipLibWrapper(_outputStream))
            {
                wrapper.AddEntry(entryName, contentStream);
                wrapper.Save();
                wrapper.CloseStream();
            }

            // Assert
            _outputStream.Seek(0, SeekOrigin.Begin);
            using var zipFile = new ZipFile(_outputStream);
            var entry = zipFile.GetEntry(entryName);
            Assert.NotNull(entry);

            using var entryStream = zipFile.GetInputStream(entry);
            var actualContent = new byte[content.Length];
            entryStream.ReadExactly(actualContent);
            Assert.Equal(content, actualContent);
        }

        [Fact]
        public void AddEntry_MultipleEntries_AllEntriesPresent()
        {
            // Arrange
            var entries = new[]
            {
                ("file1.txt", "Content 1"),
                ("file2.txt", "Content 2"),
                ("folder/file3.txt", "Content 3")
            };

            // Act
            using (var wrapper = new SharpZipLibWrapper(_outputStream))
            {
                foreach (var (name, content) in entries)
                {
                    wrapper.AddEntry(name, content);
                }
                wrapper.Save();
                wrapper.CloseStream();
            }

            // Assert
            _outputStream.Seek(0, SeekOrigin.Begin);
            using var zipFile = new ZipFile(_outputStream);
            Assert.Equal(entries.Length, zipFile.Count);

            foreach (var (name, content) in entries)
            {
                var entry = zipFile.GetEntry(name);
                Assert.NotNull(entry);
            }
        }

        [Fact]
        public void Password_SetAndVerify_PasswordApplied()
        {
            // Arrange
            var password = "SecurePassword123!";
            var entryName = "protected.txt";
            var content = "Sensitive data";

            // Act
            using (var wrapper = new SharpZipLibWrapper(_outputStream))
            {
                wrapper.Password = password;
                wrapper.AddEntry(entryName, content);
                wrapper.Save();
                wrapper.CloseStream();
            }

            // Assert - Verify password is required
            _outputStream.Seek(0, SeekOrigin.Begin);
            using var zipFile = new ZipFile(_outputStream);
            zipFile.Password = password;

            var entry = zipFile.GetEntry(entryName);
            Assert.NotNull(entry);

            using var entryStream = zipFile.GetInputStream(entry);
            using var reader = new StreamReader(entryStream);
            var actualContent = reader.ReadToEnd();
            Assert.Equal(content, actualContent);
        }

        [Fact]
        public void Password_WrongPassword_ThrowsException()
        {
            // Arrange
            var correctPassword = "CorrectPassword";
            var wrongPassword = "WrongPassword";
            var entryName = "protected.txt";
            var content = "Sensitive data";

            using (var wrapper = new SharpZipLibWrapper(_outputStream))
            {
                wrapper.Password = correctPassword;
                wrapper.AddEntry(entryName, content);
                wrapper.Save();
                wrapper.CloseStream();
            }

            // Act & Assert
            _outputStream.Seek(0, SeekOrigin.Begin);
            using var zipFile = new ZipFile(_outputStream);
            zipFile.Password = wrongPassword;

            var entry = zipFile.GetEntry(entryName);
            Assert.Throws<ZipException>(() =>
            {
                using var entryStream = zipFile.GetInputStream(entry);
                var buffer = new byte[1024];
                entryStream.ReadExactly(buffer);
            });
        }

        [Fact]
        public void ContainsEntry_ExistingEntry_ReturnsTrue()
        {
            // Arrange
            var entryName = "exists.txt";
            using var wrapper = new SharpZipLibWrapper(_outputStream);

            // Act
            wrapper.AddEntry(entryName, "Content");

            // Assert
            Assert.True(wrapper.ContainsEntry(entryName));
        }

        [Fact]
        public void ContainsEntry_NonExistingEntry_ReturnsFalse()
        {
            // Arrange
            using var wrapper = new SharpZipLibWrapper(_outputStream);
            wrapper.AddEntry("exists.txt", "Content");

            // Act & Assert
            Assert.False(wrapper.ContainsEntry("notexists.txt"));
        }

        [Fact]
        public void AddEntry_DuplicateEntryName_ThrowsInvalidOperationException()
        {
            // Arrange
            var entryName = "duplicate.txt";
            using var wrapper = new SharpZipLibWrapper(_outputStream);
            wrapper.AddEntry(entryName, "Content 1");

            // Act & Assert
            var exception = Assert.Throws<InvalidOperationException>(() =>
            {
                wrapper.AddEntry(entryName, "Content 2");
            });
            Assert.Contains(entryName, exception.Message);
        }

        [Fact]
        public void Save_FinalizeArchive_ArchiveIsValid()
        {
            // Arrange
            using (var wrapper = new SharpZipLibWrapper(_outputStream))
            {
                wrapper.AddEntry("test.txt", "Test content");

                // Act
                wrapper.Save();
                wrapper.CloseStream();
            }

            // Assert
            _outputStream.Seek(0, SeekOrigin.Begin);
            using var zipFile = new ZipFile(_outputStream);
            Assert.Equal(1, zipFile.Count);
        }

        [Fact]
        public void CloseStream_WithIsStreamOwnerFalse_UnderlyingStreamRemainsOpen()
        {
            // Arrange
            var canReadBeforeClose = _outputStream.CanRead;

            // Act
            using (var wrapper = new SharpZipLibWrapper(_outputStream))
            {
                wrapper.AddEntry("test.txt", "Content");
                wrapper.Save();
                wrapper.CloseStream();
            }

            // Assert
            Assert.True(canReadBeforeClose);
            Assert.True(_outputStream.CanRead); // Stream should remain open
        }

        [Fact]
        public void Dispose_ClosesZipStream()
        {
            // Arrange
            var wrapper = new SharpZipLibWrapper(_outputStream);
            wrapper.AddEntry("test.txt", "Content");
            wrapper.Save();

            // Act
            wrapper.Dispose();

            // Assert - Subsequent operations should fail
            Assert.ThrowsAny<Exception>(() =>
            {
                wrapper._zipStream.WriteByte(0);
            });
        }

        [Fact]
        public void AddEntry_WithUnicodeContent_PreservesEncoding()
        {
            // Arrange
            var entryName = "unicode.txt";
            var content = "Hello 世界 🌍 Привет";

            // Act
            using (var wrapper = new SharpZipLibWrapper(_outputStream))
            {
                wrapper.AddEntry(entryName, content);
                wrapper.Save();
                wrapper.CloseStream();
            }

            // Assert
            _outputStream.Seek(0, SeekOrigin.Begin);
            using var zipFile = new ZipFile(_outputStream);
            var entry = zipFile.GetEntry(entryName);

            using var entryStream = zipFile.GetInputStream(entry);
            using var reader = new StreamReader(entryStream, Encoding.UTF8);
            var actualContent = reader.ReadToEnd();
            Assert.Equal(content, actualContent);
        }

        [Fact]
        public void AddEntry_LargeContent_HandledCorrectly()
        {
            // Arrange
            var entryName = "large.txt";
            var content = new string('A', 100000); // 100KB

            // Act
            using (var wrapper = new SharpZipLibWrapper(_outputStream))
            {
                wrapper.AddEntry(entryName, content);
                wrapper.Save();
                wrapper.CloseStream();
            }

            // Assert
            _outputStream.Seek(0, SeekOrigin.Begin);
            using var zipFile = new ZipFile(_outputStream);
            var entry = zipFile.GetEntry(entryName);
            Assert.NotNull(entry);
            Assert.True(entry.Size >= content.Length);
        }
    }
}
