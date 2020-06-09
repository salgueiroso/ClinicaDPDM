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
    public class LoginController : ControllerBase
    {
        private readonly ApplicationDbContext _ctx;
        public LoginController(ApplicationDbContext ctx)
        {
            _ctx = ctx;
        }

        [HttpPost]
        public IActionResult Logar([FromBody] LoginDTO model)
        {
            var result = _ctx.Pacientes.Any(x => x.Login == model.Login && x.Senha == model.Senha);

            return Ok(result);
        }
    }
}
