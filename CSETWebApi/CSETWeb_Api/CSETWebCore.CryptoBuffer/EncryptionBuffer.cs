//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Security.Cryptography;

namespace CSETWebCore.CryptoBuffer
{
    public class EncryptionBuffer
    {
        private readonly ByteBuffer _outBuffer = new ByteBuffer();
        private readonly ByteBuffer _restBuffer = new ByteBuffer();
        private ICryptoTransform _ic;
        private bool _gotAllData;
        private int _keySize;
        readonly object _lockObject = new object();

        public bool GotAllData { get { return _gotAllData; } set { _gotAllData = value; } }
        public long BufferLength { get { return _outBuffer.Length; } }
        public long BlockSize { get { return _ic.InputBlockSize; } }
        public long KeySize { get { return _keySize; } }

        public EncryptionBuffer(string keyStr, AutoSaltSizes saltSize, SymmetricCryptoAlgorithm cryptoAlgorithm = SymmetricCryptoAlgorithm.AES_256_CBC, PaddingMode paddingMode = PaddingMode.PKCS7)
        {
            byte[] salt = new byte[(int)saltSize];
            RandomNumberGenerator.Fill(salt);
            _outBuffer.AddBytes(salt);
            if (saltSize == AutoSaltSizes.Salt32)
            {
                // Since the smallest supported salt in Rfc2898DeriveBytes is 8 bytes we write the 4 byte salt twice
                ByteBuffer newSalt = new ByteBuffer();
                newSalt.AddBytes(salt);
                newSalt.AddBytes(salt);
                salt = newSalt.GetAllBytes();
            }
            Rfc2898DeriveBytes key = new Rfc2898DeriveBytes(keyStr, salt, 7);
            Initialize(key, cryptoAlgorithm, paddingMode);
        }

        public EncryptionBuffer(byte[] keyBytes, AutoSaltSizes saltSize, SymmetricCryptoAlgorithm cryptoAlgorithm = SymmetricCryptoAlgorithm.AES_256_CBC, PaddingMode paddingMode = PaddingMode.PKCS7)
        {
            byte[] salt = new byte[(int)saltSize];
            RandomNumberGenerator.Fill(salt);
            _outBuffer.AddBytes(salt);
            if (saltSize == AutoSaltSizes.Salt32)
            {
                // Since the smallest supported salt in Rfc2898DeriveBytes is 8 bytes we write the 4 byte salt twice
                ByteBuffer newSalt = new ByteBuffer();
                newSalt.AddBytes(salt);
                newSalt.AddBytes(salt);
                salt = newSalt.GetAllBytes();
            }
            Rfc2898DeriveBytes key = new Rfc2898DeriveBytes(keyBytes, salt, 7);
            Initialize(key, cryptoAlgorithm, paddingMode);
        }

        public EncryptionBuffer(Rfc2898DeriveBytes key, SymmetricCryptoAlgorithm cryptoAlgorithm = SymmetricCryptoAlgorithm.AES_256_CBC, PaddingMode paddingMode = PaddingMode.PKCS7)
        {
            Initialize(key, cryptoAlgorithm, paddingMode);
        }

        public EncryptionBuffer(byte[] password, byte[] saltValueBytes, SymmetricCryptoAlgorithm cryptoAlgorithm = SymmetricCryptoAlgorithm.AES_256_CBC, PaddingMode paddingMode = PaddingMode.PKCS7)
        {
            Rfc2898DeriveBytes key = new Rfc2898DeriveBytes(password, saltValueBytes, 7);
            Initialize(key, cryptoAlgorithm, paddingMode);
        }

        public EncryptionBuffer(string password, byte[] saltValueBytes, SymmetricCryptoAlgorithm cryptoAlgorithm = SymmetricCryptoAlgorithm.AES_256_CBC, PaddingMode paddingMode = PaddingMode.PKCS7)
        {
            Rfc2898DeriveBytes key = new Rfc2898DeriveBytes(password, saltValueBytes, 7);
            Initialize(key, cryptoAlgorithm, paddingMode);
        }

        public EncryptionBuffer(string password, string salt, SymmetricCryptoAlgorithm cryptoAlgorithm = SymmetricCryptoAlgorithm.AES_256_CBC, PaddingMode paddingMode = PaddingMode.PKCS7)
        {
            byte[] saltValueBytes = CryptoCommon.GetBytes(salt);
            Rfc2898DeriveBytes key = new Rfc2898DeriveBytes(password, saltValueBytes, 7);
            Initialize(key, cryptoAlgorithm, paddingMode);
        }

        private void Initialize(Rfc2898DeriveBytes key, SymmetricCryptoAlgorithm cryptoAlgorithm, PaddingMode paddingMode)
        {
            _gotAllData = false;

            SymmetricAlgorithm symmetricAlg = CryptoCommon.GetSymmetricAlgorithm(cryptoAlgorithm);
            symmetricAlg.Padding = CryptoCommon.GetPaddingMode(paddingMode);

            byte[] ivBytes;
            byte[] keyBytes;
            lock (key) // Make key threadsafe from itself if you reuse the same one ove and over
            {
                key.Reset();
                ivBytes = key.GetBytes(symmetricAlg.BlockSize / 8);
                keyBytes = key.GetBytes(symmetricAlg.KeySize / 8);
            }
            _keySize = symmetricAlg.KeySize;
            _ic = symmetricAlg.CreateEncryptor(keyBytes, ivBytes);
        }

        public void AddData(byte[] data, bool lastData)
        {
            lock (_lockObject)
            {
                if (_gotAllData)
                    throw new Exception("EncryptionBuffer.AddData - Can't add more data after entering last batch");
                if (data == null)
                    throw new Exception("EncryptionBuffer.AddData - Can't add null data");

                if (lastData)
                    _gotAllData = true;

                Encrypt(data);
            }
        }

        public void AddData(byte[] data, int offset, int length, bool lastData)
        {
            if (data == null)
                throw new Exception("EncryptionBuffer.AddData - Can't add null data");

            if (offset < 0 || offset + length > data.Length)
                throw new Exception("EncryptionBuffer.AddData - Index out of bounds");

            byte[] newArray = new byte[length];
            Buffer.BlockCopy(data, offset, newArray, 0, length);

            AddData(newArray, lastData);
        }

        public byte[] GetData()
        {
            return GetData(_outBuffer.Length);
        }

        public byte[] GetData(long maxNrOfBytes)
        {
            lock (_lockObject)
            {
                return _outBuffer.GetBytes(maxNrOfBytes);
            }
        }

        private void Encrypt(byte[] data)
        {
            lock (_lockObject)
            {
                _restBuffer.AddBytes(data);

                int numWholeBlocksAvailable = (int)(_restBuffer.Length / _ic.InputBlockSize);
                int numWholeBlocksInBytes = numWholeBlocksAvailable * _ic.InputBlockSize;
                long cipherdataLength = numWholeBlocksInBytes;

                if (_gotAllData) // Add paddingsize to data
                    cipherdataLength = _restBuffer.Length + _ic.InputBlockSize - (_restBuffer.Length % _ic.InputBlockSize);

                if (cipherdataLength > 0)
                {
                    data = _restBuffer.GetBytes(numWholeBlocksInBytes);
                    byte[] tmpOutBuffer = new byte[cipherdataLength];

                    if (numWholeBlocksInBytes > 0)
                    {
                        if (_ic.CanTransformMultipleBlocks) //Fast (all data in one go)
                            _ic.TransformBlock(data, 0, numWholeBlocksInBytes, tmpOutBuffer, 0);
                        else //Slow (do block by block)
                        {
                            int count = 0;
                            int offset = 0;
                            while (count < numWholeBlocksInBytes)
                            {
                                offset += _ic.TransformBlock(data, count, _ic.InputBlockSize, tmpOutBuffer, offset);
                                count += _ic.InputBlockSize;
                            }
                        }
                    }
                    if (_gotAllData) // If we have the last data, then add the padding
                    {
                        byte[] inputBuffer = new byte[_ic.InputBlockSize];
                        data = _restBuffer.GetAllBytes();
                        Buffer.BlockCopy(data, 0, inputBuffer, 0, data.Length);
                        byte[] restData = _ic.TransformFinalBlock(inputBuffer, 0, data.Length);
                        Buffer.BlockCopy(restData, 0, tmpOutBuffer, tmpOutBuffer.Length - _ic.InputBlockSize, restData.Length);
                    }
                    _outBuffer.AddBytes(tmpOutBuffer);
                }
            }
        }
    }
}