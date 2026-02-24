//////////////////////////////// 
// 
//   Copyright 2026 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Security.Cryptography;

namespace CSETWebCore.CryptoBuffer
{
    public class DecryptionBuffer
    {
        private readonly ByteBuffer _outBuffer = new ByteBuffer();
        private readonly ByteBuffer _restBuffer = new ByteBuffer();
        private ICryptoTransform _ic;
        private bool _gotAllData;
        readonly object _lockObject = new object();
        private readonly int _autoSaltLength;
        private byte[] _keyBytes;
        private string _keyStr;
        private readonly bool _autosizeSalt;
        private bool _autosizeSaltInitialized;
        private PaddingMode _autoSaltPaddingMode;
        private readonly SymmetricCryptoAlgorithm _autoSaltCryptoAlgorithm;
        private int _keySize;

        public bool GotAllData { get { return _gotAllData; } set { _gotAllData = value; } }
        public long BufferLength { get { return _outBuffer.Length; } }
        public long BlockSize { get { return _ic.OutputBlockSize; } }
        public long KeySize { get { return _keySize; } }

        public DecryptionBuffer(string keyStr, AutoSaltSizes saltSize, SymmetricCryptoAlgorithm cryptoAlgorithm = SymmetricCryptoAlgorithm.AES_256_CBC, PaddingMode paddingMode = PaddingMode.PKCS7)
        {
            _autoSaltLength = (int)saltSize;
            _autoSaltCryptoAlgorithm = cryptoAlgorithm;
            _keyStr = keyStr;
            _autosizeSalt = true;
            _autoSaltPaddingMode = paddingMode;
        }

        public DecryptionBuffer(byte[] keyBytes, AutoSaltSizes saltSize, SymmetricCryptoAlgorithm cryptoAlgorithm = SymmetricCryptoAlgorithm.AES_256_CBC, PaddingMode paddingMode = PaddingMode.PKCS7)
        {
            _autoSaltLength = (int)saltSize;
            _autoSaltCryptoAlgorithm = cryptoAlgorithm;
            _keyBytes = keyBytes;
            _autosizeSalt = true;
            _autoSaltPaddingMode = paddingMode;
        }

        public DecryptionBuffer(byte[] password, byte[] salt, SymmetricCryptoAlgorithm cryptoAlgorithm = SymmetricCryptoAlgorithm.AES_256_CBC, PaddingMode paddingMode = PaddingMode.PKCS7)
        {
            Initialize(password, salt, cryptoAlgorithm, paddingMode);
        }

        public DecryptionBuffer(string password, byte[] salt, SymmetricCryptoAlgorithm cryptoAlgorithm = SymmetricCryptoAlgorithm.AES_256_CBC, PaddingMode paddingMode = PaddingMode.PKCS7)
        {
            Initialize(password, salt, cryptoAlgorithm, paddingMode);
        }

        public DecryptionBuffer(string password, string salt, SymmetricCryptoAlgorithm cryptoAlgorithm = SymmetricCryptoAlgorithm.AES_256_CBC, PaddingMode paddingMode = PaddingMode.PKCS7)
        {
            byte[] saltValueBytes = CryptoCommon.GetBytes(salt);
            Initialize(password, saltValueBytes, cryptoAlgorithm, paddingMode);
        }

        private void Initialize(string password, byte[] salt, SymmetricCryptoAlgorithm cryptoAlgorithm, PaddingMode paddingMode)
        {
            Initialize(CryptoCommon.GetBytes(password), salt, cryptoAlgorithm, paddingMode);
        }

        private void Initialize(byte[] password, byte[] salt, SymmetricCryptoAlgorithm cryptoAlgorithm, PaddingMode paddingMode)
        {
            _gotAllData = false;

            SymmetricAlgorithm symmetricAlg = CryptoCommon.GetSymmetricAlgorithm(cryptoAlgorithm);
            symmetricAlg.Padding = CryptoCommon.GetPaddingMode(paddingMode);

            int ivSize = symmetricAlg.BlockSize / 8;
            int keySize = symmetricAlg.KeySize / 8;

            // Derive combined IV + key bytes using static Pbkdf2 method
            byte[] derivedBytes = Rfc2898DeriveBytes.Pbkdf2(password, salt, 100, HashAlgorithmName.SHA256, ivSize + keySize);

            byte[] ivBytes = new byte[ivSize];
            byte[] keyBytes = new byte[keySize];
            Buffer.BlockCopy(derivedBytes, 0, ivBytes, 0, ivSize);
            Buffer.BlockCopy(derivedBytes, ivSize, keyBytes, 0, keySize);

            _keySize = symmetricAlg.KeySize;
            _ic = symmetricAlg.CreateDecryptor(keyBytes, ivBytes);
        }

        private void InitializeWithAutoSalt()
        {
            SymmetricAlgorithm symmetricAlg = CryptoCommon.GetSymmetricAlgorithm(_autoSaltCryptoAlgorithm);
            symmetricAlg.Padding = CryptoCommon.GetPaddingMode(_autoSaltPaddingMode);

            byte[] salt = _restBuffer.GetBytes(_autoSaltLength);
            if (_autoSaltLength == 4) // If salt length is 4, then add it twice because Rfc2898DeriveBytes supports only 8 byte salts
            {
                ByteBuffer newSalt = new ByteBuffer();
                newSalt.AddBytes(salt);
                newSalt.AddBytes(salt);
                salt = newSalt.GetAllBytes();
            }

            byte[] password = _keyBytes ?? CryptoCommon.GetBytes(_keyStr);
            _keyStr = null;
            _keyBytes = null;

            int ivSize = symmetricAlg.BlockSize / 8;
            int keySize = symmetricAlg.KeySize / 8;

            // Derive combined IV + key bytes using static Pbkdf2 method
            byte[] derivedBytes = Rfc2898DeriveBytes.Pbkdf2(password, salt, 100, HashAlgorithmName.SHA256, ivSize + keySize);

            byte[] ivBytes = new byte[ivSize];
            byte[] keyBytes = new byte[keySize];
            Buffer.BlockCopy(derivedBytes, 0, ivBytes, 0, ivSize);
            Buffer.BlockCopy(derivedBytes, ivSize, keyBytes, 0, keySize);

            _keySize = symmetricAlg.KeySize;
            _ic = symmetricAlg.CreateDecryptor(keyBytes, ivBytes);
            _autosizeSaltInitialized = true;
        }

        public void AddData(byte[] data, bool lastData)
        {
            lock (_lockObject)
            {
                if (_gotAllData)
                    throw new Exception("DecryptionStreamer.AddData - Can't add more data after entering last batch");
                if (data == null)
                    throw new Exception("DecryptionStreamer.AddData - Can't add null data");

                if (lastData)
                    _gotAllData = true;

                _restBuffer.AddBytes(data);

                if (!_autosizeSaltInitialized && _autosizeSalt)
                {
                    // Return if not enough data is added
                    if (_restBuffer.Length < _autoSaltLength)
                        return;
                    InitializeWithAutoSalt();
                }
                Decrypt();
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

        private void Decrypt()
        {
            lock (_lockObject)
            {
                int numWholeBlocks = (int)(_restBuffer.Length / _ic.OutputBlockSize);
                int numWholeBlocksInBytes = numWholeBlocks * _ic.OutputBlockSize;
                byte[] tmpOutBuffer = new byte[numWholeBlocksInBytes];
                byte[] data = _restBuffer.GetBytes(numWholeBlocksInBytes);
                int count = 0;
                if (numWholeBlocksInBytes > 0)
                {
                    if (_ic.CanTransformMultipleBlocks)
                    {
                        count = _ic.TransformBlock(data, 0, numWholeBlocksInBytes, tmpOutBuffer, 0);
                    }
                    else
                    {
                        int offset = 0;
                        while (offset < numWholeBlocksInBytes)
                        {
                            count += _ic.TransformBlock(data, offset, _ic.InputBlockSize, tmpOutBuffer, count);
                            offset += _ic.InputBlockSize;
                        }
                    }
                }
                _outBuffer.AddBytes(tmpOutBuffer, 0, count);

                if (_gotAllData)
                {
                    byte[] finalBytes = _ic.TransformFinalBlock(_restBuffer.GetAllBytes(), 0, (int)_restBuffer.Length);
                    _outBuffer.AddBytes(finalBytes);
                }
            }
        }
    }
}