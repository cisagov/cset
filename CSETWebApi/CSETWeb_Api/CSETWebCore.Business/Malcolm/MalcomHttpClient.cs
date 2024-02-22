using Newtonsoft.Json;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Business.Malcolm
{
    public class MalcomHttpClient
    {
        private readonly HttpClient _client;

        public MalcomHttpClient()
        {
            _client = new HttpClient();
        }

        public async Task<string> PostAndSaveResponseAsJsonAsync(string url, string postValue)
        {
            var content = new StringContent(postValue, Encoding.UTF8, "application/json");
            var response = await _client.PostAsync(url, content);

            if (response.IsSuccessStatusCode)
            {
                var responseJson = await response.Content.ReadAsStringAsync();
                return responseJson;
            }

            return null;
        }

        public async Task<string> getMalcomData(string ipaddress)
        {
            var data = "{\"from\":\"5 years ago\",\"to\": \"now\"}";
            var responseJson = await PostAndSaveResponseAsJsonAsync("https://"+ipaddress+"/mapi/agg/source.ip,source.device.role,destination.ip,destination.device.role", data);
            return responseJson;
        } 
    }
}