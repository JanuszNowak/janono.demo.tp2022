using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Primitives;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;

namespace MIMUW.FunctionApp.UnitTests
{
    [TestClass]
    public class UnitTestIsAlive : FunctionTest
    {
        [TestMethod]
        public async Task Request_Without_Query_And_Body()
        {
            //var logger = Mock.Of<ILogger>();
            var logger = Mock.Of<ILogger<IsAlive>>();

            var query = new Dictionary<String, StringValues>();
            var body = "";
            var a = new IsAlive(logger);
            var result = await a.Run(HttpRequestSetup(query, body));
            var resultObject = (OkObjectResult)result;
            Assert.AreEqual(true, ((IsAliveContract)resultObject.Value).isAlive);
        }
    }
}
