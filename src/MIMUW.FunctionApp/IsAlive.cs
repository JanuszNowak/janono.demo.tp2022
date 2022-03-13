namespace MIMUW.FunctionApp
{
    using System;
    using System.Threading.Tasks;
    using Microsoft.AspNetCore.Mvc;
    using Microsoft.Azure.WebJobs;
    using Microsoft.Azure.WebJobs.Extensions.Http;
    using Microsoft.AspNetCore.Http;
    using Microsoft.Extensions.Logging;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel;
    using System.Reflection;

    public static class IsAlive
    {
        public static readonly string ApplicationVersion = Assembly.GetExecutingAssembly().GetName().Version.ToString();

        [FunctionName("IsAlive")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", "post", Route = null)] HttpRequest req,
            ILogger log)
        {
            log.LogInformation("C# HTTP trigger function processed a request.");            
            var result = new IsAliveContract
            {
                isAlive = true,
                timestamp = DateTimeOffset.UtcNow,
                version = ApplicationVersion,
                regionName = Environment.GetEnvironmentVariable("REGION_NAME")
            }; ;
            return new OkObjectResult(result);
        }
    }



    [Description("Is Alive Contract")]
    public class IsAliveContract
    {
        [Display(Description = "Version of Application")]
        public string version { get; set; }

        [Display(Description = "TimeStamp")]
        public DateTimeOffset timestamp { get; set; }

        [Display(Description = "Is Alive Value")]
        public bool isAlive { get; set; }

        [Display(Description = "Region name")]
        public string regionName { get; set; }
    }
}
