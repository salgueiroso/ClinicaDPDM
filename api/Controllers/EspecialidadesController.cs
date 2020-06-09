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
    public class EspecialidadesController : ControllerBase
    {
        private readonly ILogger<EspecialidadesController> _logger;
        private readonly ApplicationDbContext _ctx;

        public EspecialidadesController(ILogger<EspecialidadesController> logger, ApplicationDbContext ctx)
        {
            _logger = logger;
            _ctx = ctx;
        }

        [HttpGet]
        public IActionResult Get()
        {
            _logger.Log(LogLevel.Information, "Acessou");

            return Ok(_ctx.Especialidades.OrderBy(x => x.Nome).Select(e => new EspecialidadeDTO(e)).ToList());
        }

        [HttpGet("{id}")]
        public IActionResult Get(int id)
        {

            var entity = _ctx.Especialidades.FirstOrDefault(x => x.Id == id);
            if (entity != null)
                return Ok(new EspecialidadeDTO(entity));
            else
                return NotFound();
        }

        [HttpPost]
        public IActionResult Post([FromBody] EspecialidadeDTO model)
        {
            var entity = new Especialidade
            {
                Nome = model.Nome
            };

            _ctx.Especialidades.Add(entity);
            _ctx.SaveChanges();

            return Ok();
        }

        [HttpPut]
        public IActionResult Put([FromBody] EspecialidadeDTO model)
        {
            var entity = _ctx.Especialidades.FirstOrDefault(x => x.Id == model.Id);

            entity.Nome = model.Nome;

            _ctx.Especialidades.Update(entity);
            _ctx.SaveChanges();

            return Ok();
        }

        [HttpDelete("{id}")]
        public IActionResult Delete(int id)
        {
            var entity = _ctx.Especialidades.FirstOrDefault(x => x.Id == id);

            _ctx.Especialidades.Remove(entity);
            _ctx.SaveChanges();

            return Ok();
        }
    }
}
