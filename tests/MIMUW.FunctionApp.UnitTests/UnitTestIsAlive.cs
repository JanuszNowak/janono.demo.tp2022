using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Primitives;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace MIMUW.FunctionApp.UnitTests
{
    [TestClass]
    public class UnitTestIsAlive : FunctionTest
    {
        [TestMethod]
        public async Task Request_Without_Query_And_Body()
        {
            var logger = Mock.Of<ILogger>();
            var query = new Dictionary<String, StringValues>();
            var body = "";
            var result = await IsAlive.Run(HttpRequestSetup(query, body), logger);
            var resultObject = (OkObjectResult)result;
            Assert.AreEqual(true, ((IsAliveContract)resultObject.Value).isAlive);
        }
    }
}
