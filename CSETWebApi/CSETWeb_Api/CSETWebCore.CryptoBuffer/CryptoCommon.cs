//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.IO;
using System.Security.Cryptography;

namespace CSETWebCore.CryptoBuffer
{
	public static class CryptoCommon
	{
		public static SymmetricAlgorithm GetSymmetricAlgorithm(SymmetricCryptoAlgorithm cryptoAlg)
		{
			SymmetricAlgorithm symmetricAlg;

			string strSetup = cryptoAlg.ToString();
			string[] parts = strSetup.Split('_');

			switch (parts[0])
			{
				case "AES":
					symmetricAlg = new AesCryptoServiceProvider();
					break;
				case "Rijndael":
					symmetricAlg = new RijndaelManaged();
					symmetricAlg.BlockSize = int.Parse(parts[3]); // Rijndael is the only one that can set a different block size
					break;
				case "RC2":
					symmetricAlg = new RC2CryptoServiceProvider();
					break;
				case "DES":
					symmetricAlg = new DESCryptoServiceProvider();
					break;
				case "TripleDES":
					symmetricAlg = new TripleDESCryptoServiceProvider();
					break;
				default:
					throw new Exception("Invalid SymmetricAlgorithm");
			}

			symmetricAlg.KeySize = int.Parse(parts[1]);

			switch (parts[2])
			{
				case "CBC":
					symmetricAlg.Mode = CipherMode.CBC;
					break;
				case "ECB":
					symmetricAlg.Mode = CipherMode.ECB;
					break;
				case "CFB":
					symmetricAlg.Mode = CipherMode.CFB;
					break;
				default:
					throw new Exception("Invalid CipherMode");
			}

			return symmetricAlg;
		}

		public static System.Security.Cryptography.PaddingMode GetPaddingMode(PaddingMode paddingModes)
		{
			switch (paddingModes)
			{
				case PaddingMode.PKCS7:
					return System.Security.Cryptography.PaddingMode.PKCS7;

				case PaddingMode.None:
					return System.Security.Cryptography.PaddingMode.None;

				case PaddingMode.Zeros:
					return System.Security.Cryptography.PaddingMode.Zeros;

				case PaddingMode.ISO10126:
					return System.Security.Cryptography.PaddingMode.ISO10126;

				case PaddingMode.ANSIX923:
					return System.Security.Cryptography.PaddingMode.ANSIX923;

				default:
					throw new Exception("Invalid PaddingMode");
			}
		}

		// Get string in a byte format
		public static byte[] GetBytes(string str)
		{
			byte[] bytes = new byte[str.Length * sizeof(char)];
			Buffer.BlockCopy(str.ToCharArray(), 0, bytes, 0, bytes.Length);

			return bytes;
		}

		// Get a string from a byte array
		public static string GetString(byte[] bytes)
		{
			char[] chars = new char[bytes.Length / sizeof(char)];
			Buffer.BlockCopy(bytes, 0, chars, 0, bytes.Length);
			return new string(chars);
		}
	}

	public static class CryptoHelper
	{
		#region stream encryption
		public static void EncryptStream(string password, string salt, Stream inputStream, Stream outputStream, SymmetricCryptoAlgorithm algorithm = SymmetricCryptoAlgorithm.AES_256_CBC)
		{
			if (!inputStream.CanRead)
				throw new Exception("The input stream has to support read");
			if (!outputStream.CanWrite)
				throw new Exception("The output stream has to support write");

			EncryptionBuffer encBuffer = new EncryptionBuffer(password, salt, algorithm);
			byte[] readBuffer = new byte[500000];
			bool isLastData = false;
			while (!isLastData)
			{
				int nrOfBytes = inputStream.Read(readBuffer, 0, readBuffer.Length);
				isLastData = (nrOfBytes == 0);

				encBuffer.AddData(readBuffer, 0, nrOfBytes, isLastData);
				byte[] encryptedData = encBuffer.GetData();
				outputStream.Write(encryptedData, 0, encryptedData.Length);
			}
		}

		public static void DecryptStream(string password, string salt, Stream inputStream, Stream outputStream, SymmetricCryptoAlgorithm algorithm = SymmetricCryptoAlgorithm.AES_256_CBC)
		{
			if (!inputStream.CanRead)
				throw new Exception("The input stream has to support read");
			if (!outputStream.CanWrite)
				throw new Exception("The output stream has to support write");

			DecryptionBuffer decBuffer = new DecryptionBuffer(password, salt, algorithm);
			byte[] readBuffer = new byte[500000];
			bool isLastData = false;
			while (!isLastData)
			{
				int nrOfBytes = inputStream.Read(readBuffer, 0, readBuffer.Length);
				isLastData = (nrOfBytes == 0);

				decBuffer.AddData(readBuffer, 0, nrOfBytes, isLastData);
				byte[] decryptedData = decBuffer.GetData();
				outputStream.Write(decryptedData, 0, decryptedData.Length);
			}
		}

		public static void EncryptStream(string password, AutoSaltSizes saltSize, Stream inputStream, Stream outputStream, SymmetricCryptoAlgorithm algorithm = SymmetricCryptoAlgorithm.AES_256_CBC)
		{
			if (!inputStream.CanRead)
				throw new Exception("The input stream has to support read");
			if (!outputStream.CanWrite)
				throw new Exception("The output stream has to support write");

			EncryptionBuffer encBuffer = new EncryptionBuffer(password, saltSize, algorithm);
			byte[] readBuffer = new byte[500000];
			bool isLastData = false;
			while (!isLastData)
			{
				int nrOfBytes = inputStream.Read(readBuffer, 0, readBuffer.Length);
				isLastData = (nrOfBytes == 0);

				encBuffer.AddData(readBuffer, 0, nrOfBytes, isLastData);
				byte[] encryptedData = encBuffer.GetData();
				outputStream.Write(encryptedData, 0, encryptedData.Length);
			}
		}

		public static void DecryptStream(string password, AutoSaltSizes saltSize, Stream inputStream, Stream outputStream, SymmetricCryptoAlgorithm algorithm = SymmetricCryptoAlgorithm.AES_256_CBC)
		{
			if (!inputStream.CanRead)
				throw new Exception("The input stream has to support read");
			if (!outputStream.CanWrite)
				throw new Exception("The output stream has to support write");

			DecryptionBuffer decBuffer = new DecryptionBuffer(password, saltSize, algorithm);
			byte[] readBuffer = new byte[500000];
			bool isLastData = false;
			while (!isLastData)
			{
				int nrOfBytes = inputStream.Read(readBuffer, 0, readBuffer.Length);
				isLastData = (nrOfBytes == 0);

				decBuffer.AddData(readBuffer, 0, nrOfBytes, isLastData);
				byte[] decryptedData = decBuffer.GetData();
				outputStream.Write(decryptedData, 0, decryptedData.Length);
			}
		}
		#endregion

		#region file encryption
		public static void EncryptFile(string password, string salt, string inputFileName, string outputFileName, SymmetricCryptoAlgorithm algorithm = SymmetricCryptoAlgorithm.AES_256_CBC)
		{
			using (FileStream inputStream = new FileStream(inputFileName, FileMode.Open, FileAccess.Read))
			{
				using (FileStream outputStream = new FileStream(outputFileName, FileMode.Create, FileAccess.Write))
				{
					EncryptStream(password, salt, inputStream, outputStream, algorithm);
				}
			}
		}

		public static void DecryptFile(string password, string salt, string inputFileName, string outputFileName, SymmetricCryptoAlgorithm algorithm = SymmetricCryptoAlgorithm.AES_256_CBC)
		{
			using (FileStream inputStream = new FileStream(inputFileName, FileMode.Open, FileAccess.Read))
			{
				using (FileStream outputStream = new FileStream(outputFileName, FileMode.Create, FileAccess.Write))
				{
					DecryptStream(password, salt, inputStream, outputStream, algorithm);
				}
			}
		}

		public static void EncryptFile(string password, AutoSaltSizes saltSize, string inputFileName, string outputFileName, SymmetricCryptoAlgorithm algorithm = SymmetricCryptoAlgorithm.AES_256_CBC)
		{
			using (FileStream inputStream = new FileStream(inputFileName, FileMode.Open, FileAccess.Read))
			{
				using (FileStream outputStream = new FileStream(outputFileName, FileMode.Create, FileAccess.Write))
				{
					EncryptStream(password, saltSize, inputStream, outputStream, algorithm);
				}
			}
		}

		public static void DecryptFile(string password, AutoSaltSizes saltSize, string inputFileName, string outputFileName, SymmetricCryptoAlgorithm algorithm = SymmetricCryptoAlgorithm.AES_256_CBC)
		{
			using (FileStream inputStream = new FileStream(inputFileName, FileMode.Open, FileAccess.Read))
			{
				using (FileStream outputStream = new FileStream(outputFileName, FileMode.Create, FileAccess.Write))
				{
					DecryptStream(password, saltSize, inputStream, outputStream, algorithm);
				}
			}
		}
		#endregion

		#region data encryption
		public static byte[] EncryptData(string password, string salt, byte[] data, SymmetricCryptoAlgorithm algorithm = SymmetricCryptoAlgorithm.AES_256_CBC)
		{
			EncryptionBuffer encBuffer = new EncryptionBuffer(password, salt, algorithm);
			encBuffer.AddData(data, true);
			return encBuffer.GetData();
		}

		public static byte[] DecryptData(string password, string salt, byte[] data, SymmetricCryptoAlgorithm algorithm = SymmetricCryptoAlgorithm.AES_256_CBC)
		{
			DecryptionBuffer decBuffer = new DecryptionBuffer(password, salt, algorithm);
			decBuffer.AddData(data, true);
			return decBuffer.GetData();
		}

		public static byte[] EncryptData(string password, AutoSaltSizes saltSize, byte[] data, SymmetricCryptoAlgorithm algorithm = SymmetricCryptoAlgorithm.AES_256_CBC)
		{
			EncryptionBuffer encBuffer = new EncryptionBuffer(password, saltSize, algorithm);
			encBuffer.AddData(data, true);
			return encBuffer.GetData();
		}

		public static byte[] DecryptData(string password, AutoSaltSizes saltSize, byte[] data, SymmetricCryptoAlgorithm algorithm = SymmetricCryptoAlgorithm.AES_256_CBC)
		{
			DecryptionBuffer decBuffer = new DecryptionBuffer(password, saltSize, algorithm);
			decBuffer.AddData(data, true);
			return decBuffer.GetData();
		}
		#endregion

		#region string encryption
		public static string EncryptString(string password, string salt, string strData, SymmetricCryptoAlgorithm algorithm = SymmetricCryptoAlgorithm.AES_256_CBC)
		{
			byte[] data = CryptoCommon.GetBytes(strData);
			byte[] encryptedData = EncryptData(password, salt, data, algorithm);
			return CryptoCommon.GetString(encryptedData);
		}

		public static string DecryptString(string password, string salt, string strData, SymmetricCryptoAlgorithm algorithm = SymmetricCryptoAlgorithm.AES_256_CBC)
		{
			byte[] data = CryptoCommon.GetBytes(strData);
			byte[] encryptedData = DecryptData(password, salt, data, algorithm);
			return CryptoCommon.GetString(encryptedData);
		}

		public static string EncryptString(string password, AutoSaltSizes saltSize, string strData, SymmetricCryptoAlgorithm algorithm = SymmetricCryptoAlgorithm.AES_256_CBC)
		{
			byte[] data = CryptoCommon.GetBytes(strData);
			byte[] encryptedData = EncryptData(password, saltSize, data, algorithm);
			return CryptoCommon.GetString(encryptedData);
		}

		public static string DecryptString(string password, AutoSaltSizes saltSize, string strData, SymmetricCryptoAlgorithm algorithm = SymmetricCryptoAlgorithm.AES_256_CBC)
		{
			byte[] data = CryptoCommon.GetBytes(strData);
			byte[] encryptedData = DecryptData(password, saltSize, data, algorithm);
			return CryptoCommon.GetString(encryptedData);
		}
		#endregion

		#region Base 64 string encryption
		public static string EncryptBase64String(string password, string salt, string strData, SymmetricCryptoAlgorithm algorithm = SymmetricCryptoAlgorithm.AES_256_CBC)
		{
			byte[] data = CryptoCommon.GetBytes(strData);
			byte[] encryptedData = EncryptData(password, salt, data, algorithm);
			return Convert.ToBase64String(encryptedData);
		}

		public static string DecryptBase64String(string password, string salt, string b64StrData, SymmetricCryptoAlgorithm algorithm = SymmetricCryptoAlgorithm.AES_256_CBC)
		{
			byte[] data = Convert.FromBase64String(b64StrData);
			byte[] encryptedData = DecryptData(password, salt, data, algorithm);
			return CryptoCommon.GetString(encryptedData);
		}

		public static string EncryptBase64String(string password, AutoSaltSizes saltSize, string strData, SymmetricCryptoAlgorithm algorithm = SymmetricCryptoAlgorithm.AES_256_CBC)
		{
			byte[] data = CryptoCommon.GetBytes(strData);
			byte[] encryptedData = EncryptData(password, saltSize, data, algorithm);
			return Convert.ToBase64String(encryptedData);
		}

		public static string DecryptBase64String(string password, AutoSaltSizes saltSize, string b64StrData, SymmetricCryptoAlgorithm algorithm = SymmetricCryptoAlgorithm.AES_256_CBC)
		{
			byte[] data = Convert.FromBase64String(b64StrData);
			byte[] encryptedData = DecryptData(password, saltSize, data, algorithm);
			return CryptoCommon.GetString(encryptedData);
		}
		#endregion
	}

	public enum PaddingMode
	{
		None,
		PKCS7,
		Zeros,
		ANSIX923,
		ISO10126
	}

	public enum AutoSaltSizes : int
	{
		Salt32 = 4,
		Salt64 = 8,
		Salt128 = 16,
		Salt192 = 24,
		Salt256 = 32,
		Salt384 = 48,
		Salt512 = 64
	}

	public enum SymmetricCryptoAlgorithm
	{
		AES_128_CBC,
		AES_128_ECB,
		AES_128_CFB,
		AES_192_CBC,
		AES_192_ECB,
		AES_192_CFB,
		AES_256_CBC,
		AES_256_ECB,
		AES_256_CFB,

		Rijndael_128_CBC_128,
		Rijndael_128_CBC_192,
		Rijndael_128_CBC_256,
		Rijndael_128_ECB_128,
		Rijndael_128_ECB_192,
		Rijndael_128_ECB_256,
		Rijndael_128_CFB_128,
		Rijndael_128_CFB_192,
		Rijndael_128_CFB_256,
		Rijndael_192_CBC_128,
		Rijndael_192_CBC_192,
		Rijndael_192_CBC_256,
		Rijndael_192_ECB_128,
		Rijndael_192_ECB_192,
		Rijndael_192_ECB_256,
		Rijndael_192_CFB_128,
		Rijndael_192_CFB_192,
		Rijndael_192_CFB_256,
		Rijndael_256_CBC_128,
		Rijndael_256_CBC_192,
		Rijndael_256_CBC_256,
		Rijndael_256_ECB_128,
		Rijndael_256_ECB_192,
		Rijndael_256_ECB_256,
		Rijndael_256_CFB_128,
		Rijndael_256_CFB_192,
		Rijndael_256_CFB_256,

		DES_64_CBC,
		DES_64_ECB,
		DES_64_CFB,

		TripleDES_128_CBC,
		TripleDES_128_ECB,
		TripleDES_128_CFB,
		TripleDES_192_CBC,
		TripleDES_192_ECB,
		TripleDES_192_CFB,

		RC2_40_CBC,
		RC2_40_ECB,
		RC2_40_CFB,
		RC2_48_CBC,
		RC2_48_ECB,
		RC2_48_CFB,
		RC2_56_CBC,
		RC2_56_ECB,
		RC2_56_CFB,
		RC2_64_CBC,
		RC2_64_ECB,
		RC2_64_CFB,
		RC2_72_CBC,
		RC2_72_ECB,
		RC2_72_CFB,
		RC2_80_CBC,
		RC2_80_ECB,
		RC2_80_CFB,
		RC2_88_CBC,
		RC2_88_ECB,
		RC2_88_CFB,
		RC2_96_CBC,
		RC2_96_ECB,
		RC2_96_CFB,
		RC2_104_CBC,
		RC2_104_ECB,
		RC2_104_CFB,
		RC2_112_CBC,
		RC2_112_ECB,
		RC2_112_CFB,
		RC2_120_CBC,
		RC2_120_ECB,
		RC2_120_CFB,
		RC2_128_CBC,
		RC2_128_ECB,
		RC2_128_CFB
	}
}
