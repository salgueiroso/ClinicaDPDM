using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using api.model;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;

namespace api.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class CoberturasController : ControllerBase
    {
        private readonly ApplicationDbContext _ctx;
        public CoberturasController(ApplicationDbContext ctx)
        {
            _ctx = ctx;
        }

        [HttpGet]
        public IActionResult Get()
        {
            var result = _ctx.Coberturas
                .OrderBy(x => x.Nome)
                .ToList()
                .Select(x => new CoberturaDTO(x))
                .ToList();

            return Ok(result);
        }
    }
}
