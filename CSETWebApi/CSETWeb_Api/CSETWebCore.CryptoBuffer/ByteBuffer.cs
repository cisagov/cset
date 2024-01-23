//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;

namespace CSETWebCore.CryptoBuffer
{
    public class ByteBuffer
    {
        private readonly List<byte[]> _byteList = new List<byte[]>();
        private readonly object _lockObj = new object();
        private long _length;
        private long _offset;

        public long Length { get { lock (_lockObj) return _length; } }

        public ByteBuffer()
        {
            _offset = 0;
            _length = 0;
        }

        public void AddBytes(byte[] data)
        {
            if (data == null || data.Length == 0)
                return;

            lock (_lockObj)
            {
                _byteList.Add(data);
                _length += data.Length;
            }
        }

        public void AddBytes(byte[] data, int offset, int count)
        {
            if (count == 0)
                return;

            lock (_lockObj)
            {
                if (offset == 0 && count == data.Length)
                    AddBytes(data);
                else
                {
                    byte[] newData = new byte[count];
                    Buffer.BlockCopy(data, offset, newData, 0, count);
                    AddBytes(newData);
                }
            }
        }

        public byte[] GetAllBytes()
        {
            return GetBytes(_length);
        }

        public byte[] GetBytes(long byteCount)
        {
            byte[] returnData;
            long dataFilled = 0;
            int removeCount = 0;
            lock (_lockObj)
            {
                byteCount = byteCount > _length ? _length : byteCount;
                returnData = new byte[byteCount];

                for (int i = 0; i < _byteList.Count && dataFilled != byteCount; i++)
                {
                    long listPartLength = Math.Min(byteCount - dataFilled, _byteList[i].Length - _offset);
                    Buffer.BlockCopy(_byteList[i], (int)_offset, returnData, (int)dataFilled, (int)listPartLength);
                    dataFilled += listPartLength;

                    if (listPartLength + _offset == _byteList[i].Length)
                    {
                        removeCount++;
                        _offset = 0;
                    }
                    else
                    {
                        _offset = listPartLength + _offset;
                    }
                }

                if (removeCount > 0)
                    _byteList.RemoveRange(0, removeCount);
                _length -= byteCount;
            }

            return returnData;
        }
    }
}