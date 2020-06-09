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
    public class ConsultasController : ControllerBase
    {
        private readonly ApplicationDbContext _ctx;
        public ConsultasController(ApplicationDbContext ctx)
        {
            _ctx = ctx;
        }

        [HttpGet]
        public IActionResult Get()
        {
            var result = _ctx.Consultas
                .OrderByDescending(x => x.DataHora)
                .ToList()
                .Select(x => new ConsultaDTO(x))
                .ToList();

            return Ok(result);
        }

        [HttpGet("datasHorasLivres/{idMedico}")]
        public IActionResult GetDatasHorasLivres(int idMedico)
        {
            var dhOcupados = _ctx.Consultas
                .Where(x => x.MedicoId == idMedico)
                .OrderBy(x => x.DataHora)
                .Select(x => x.DataHora)
                .ToList()
                .Select(x => new DateTime(x.Year, x.Month, x.Day, x.Hour, 0, 0))
                .ToList();

            var hDiarias = Enumerable
                .Range(8, 8)
                .ToList();

            var dias = Enumerable
                .Range(1, 30)
                .ToList();

            var dh = dias.Join(
                    hDiarias,
                    a => 1,
                    b => 1,
                    (a, b) => DateTime.Now.Date.AddDays(a).AddHours(b))
                .ToList();

            var dhDisponiveis = dh.Where(x => !dhOcupados.Contains(x)).ToList();

            return Ok(dhDisponiveis);
        }
    }
}
