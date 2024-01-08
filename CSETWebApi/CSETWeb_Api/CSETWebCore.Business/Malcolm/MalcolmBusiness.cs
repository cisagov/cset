using CSETWebCore.Interfaces.Malcolm;
using CSETWebCore.Model.Malcolm;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Business.Malcolm
{
    public class MalcolmBusiness : IMalcolmBusiness
    {
        //public MalcolmBusiness() { }

        public IEnumerable<MalcolmData> GetMalcolmJsonData()
        {
            string[] files = Directory.GetFiles("C:\\Users\\WINSMR\\Documents\\MalcolmJson");
            var malcolmDataList = new List<MalcolmData>();

            try
            {
                foreach (string file in files)
                {
                    string jsonString = File.ReadAllText(file);
                    var malcolmData = JsonConvert.DeserializeObject<MalcolmData>(jsonString);

                    malcolmDataList.Add(malcolmData);
                }

                return malcolmDataList;
            }
            catch (Exception exc)
            {
                NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");
            }

            return null;
        }

        /*
        private static Dictionary<string, List<Buckets>> dict = new Dictionary<string, List<Buckets>>();

        public void Dijkstras (GenericInput malcolmData) 
        {
            for (malcolmData.Values.Buckets)
            {

            }

            dict.Add(malcolmDataList);

            return 
        }

        public List<Buckets> DijkstrasRecursive (ValuePairs valuePair, List<Buckets> continuousBucketList)
        {
            if (valuePair.Buckets != null && valuePair.Buckets.Count > 0) 
            { 
                foreach (Buckets bucket in  valuePair.Buckets)
                {
                    if (bucket.Key != "")
                    {
                        continuousBucketList.Add(bucket);
                    }

                    if (bucket.Values != null)
                    {

                    }
                }
            }

            return
        }
        */
    }
}
