using Newtonsoft.Json;
using System;
using System.Net;
using System.Net.Http;
using System.Security.Policy;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Business.Malcolm
{
    public class MalcomHttpClient
    {
        private HttpClient _client;

        public void GetHttpClient(string ipAddress,int timeoutInSeconds)
        {
            ServicePointManager.ServerCertificateValidationCallback += (sender, cert, chain, sslPolicyError) => true;
            var EndPoint = "https://" + ipAddress + "/api";
            var httpClientHandler = new HttpClientHandler();
            httpClientHandler.ServerCertificateCustomValidationCallback = (message, cert, chain, sslPolicyErrors) =>
            {
                return true;
            };

            _client = new HttpClient(httpClientHandler) { BaseAddress = new Uri(EndPoint), Timeout= TimeSpan.FromSeconds(timeoutInSeconds)};
        }

        private async Task<string> PostAndSaveResponseAsJsonAsync(string url, string postValue)
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
            this.GetHttpClient(ipaddress, 4);
            var data = "{\"from\":\"now\",\"to\": \"now\"}";
            var responseJson = await PostAndSaveResponseAsJsonAsync("https://" + ipaddress + "/mapi/agg/source.ip,source.device.role,destination.ip,destination.device.role", data);
            if(responseJson == null)
            {
                throw new ApplicationException("Malcom server is not responding");
            }
            this.GetHttpClient(ipaddress, 180);
            data = "{\"from\":\"5 years ago\",\"to\": \"now\"}";
            responseJson = await PostAndSaveResponseAsJsonAsync("https://"+ipaddress+"/mapi/agg/source.ip,source.device.role,destination.ip,destination.device.role", data);
            return responseJson;
        } 
    }
}