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
    public class PacientesController : ControllerBase
    {
        private readonly ILogger<PacientesController> _logger;
        private readonly ApplicationDbContext _ctx;

        public PacientesController(ILogger<PacientesController> logger, ApplicationDbContext ctx)
        {
            _logger = logger;
            _ctx = ctx;
        }

        [HttpGet]
        public IActionResult Get()
        {
            _logger.Log(LogLevel.Information, "Acessou");

            return Ok(_ctx.Pacientes.OrderBy(x => x.Nome).ToList().Select(e => new PacienteDTO(e)).ToList());
        }

        [HttpGet("{id}")]
        public IActionResult Get(int id)
        {

            var entity = _ctx.Pacientes.FirstOrDefault(x => x.Id == id);
            if (entity != null)
                return Ok(new PacienteDTO(entity));
            else
                return NotFound();
        }

        [HttpPost]
        public IActionResult Post([FromBody] PacienteDTO model)
        {

            var entity = new Paciente
            {
                Nome = model.Nome,
                DataNascimento = model.DataNascimento,
                Telefone = model.Telefone,
                CPF = model.cpf,
                RG = model.rg,
                Login = model.Login,
                Senha = model.Senha,
                Endereco = new Endereco
                {
                    Bairro = model.Endereco.Bairro,
                    Numero = model.Endereco.Numero,
                    Rua = model.Endereco.Rua,
                }
            };

            _ctx.Pacientes.Add(entity);
            _ctx.SaveChanges();

            return Ok();
        }

        [HttpPut]
        public IActionResult Put([FromBody] PacienteDTO model)
        {
            var entity = _ctx.Pacientes.FirstOrDefault(x => x.Id == model.Id);

            entity.Nome = model.Nome;
            entity.DataNascimento = model.DataNascimento;
            entity.Telefone = model.Telefone;
            entity.RG = model.rg;
            entity.CPF = model.cpf;
            entity.Endereco.Bairro = model.Endereco.Bairro;
            entity.Endereco.Numero = model.Endereco.Numero;
            entity.Endereco.Rua = model.Endereco.Rua;
            if (!string.IsNullOrWhiteSpace(model.Senha))
                entity.Senha = model.Senha;

            _ctx.Pacientes.Update(entity);
            _ctx.SaveChanges();

            return Ok();
        }


        [HttpDelete("{id}")]
        public IActionResult Delete(int id)
        {
            var tran = _ctx.Database.BeginTransaction();
            try
            {
                var entity = _ctx.Pacientes.FirstOrDefault(x => x.Id == id);

                _ctx.Enderecos.Remove(entity.Endereco);
                _ctx.Pacientes.Remove(entity);
                _ctx.SaveChanges();
                tran.Commit();
            }
            catch (Exception ex)
            {
                tran.Rollback();
                throw ex;
            }

            return Ok();
        }
    }
}
