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
    public class MedicosController : ControllerBase
    {
        private readonly ILogger<MedicosController> _logger;
        private readonly ApplicationDbContext _ctx;

        public MedicosController(ILogger<MedicosController> logger, ApplicationDbContext ctx)
        {
            _logger = logger;
            _ctx = ctx;
        }

/*         [HttpGet]
        public IActionResult Get()
        {
            var result = _ctx.Medicos
                .OrderBy(x => x.Nome)
                .ToList()
                .Select(e => new MedicoDTO(e))
                .ToList();
            return Ok(result);
        } */

        [HttpGet]
        public IActionResult GetPorEspecialidade([FromQuery] int? idEspecialidade = null)
        {
            var result = _ctx.Medicos
                .Where(x => idEspecialidade == null || x.EspecialidadeId == idEspecialidade)
                .OrderBy(x => x.Nome)
                .ToList()
                .Select(e => new MedicoDTO(e))
                .ToList();
            return Ok(result);
        }

        [HttpGet("{id}")]
        public IActionResult Get(int id)
        {

            var entity = _ctx.Medicos.FirstOrDefault(x => x.Id == id);
            if (entity != null)
                return Ok(new MedicoDTO(entity));
            else
                return NotFound();
        }

        [HttpPost]
        public IActionResult Post([FromBody] MedicoDTO model)
        {
            var esp = _ctx.Especialidades.FirstOrDefault(x => x.Id == model.Especialidade.Id);

            var entity = new Medico
            {
                Nome = model.Nome,
                CRM = model.crm,
                Especialidade = esp
            };

            _ctx.Medicos.Add(entity);
            _ctx.SaveChanges();

            return Ok();
        }

        [HttpPut]
        public IActionResult Put([FromBody] MedicoDTO model)
        {
            var esp = _ctx.Especialidades.FirstOrDefault(x => x.Id == model.Especialidade.Id);
            var entity = _ctx.Medicos.FirstOrDefault(x => x.Id == model.Id);

            entity.Nome = model.Nome;
            entity.CRM = model.crm;
            entity.Especialidade = esp;

            _ctx.Medicos.Update(entity);
            _ctx.SaveChanges();

            return Ok();
        }


        [HttpDelete("{id}")]
        public IActionResult Delete(int id)
        {
            var entity = _ctx.Medicos.FirstOrDefault(x => x.Id == id);

            _ctx.Medicos.Remove(entity);
            _ctx.SaveChanges();

            return Ok();
        }
    }
}
