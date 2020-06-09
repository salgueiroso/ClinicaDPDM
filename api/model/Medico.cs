using System;
using System.Linq;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace api.model
{
    public class Medico : IModel
    {
        [Key]
        public int Id { get; set; }

        public string Nome { get; set; }

        public string CRM { get; set; }

        [Column("Especialidade")]
        [ForeignKey("Especialidade")]
        public int EspecialidadeId { get; set; }
        public virtual Especialidade Especialidade { get; set; }
        public virtual IEnumerable<Consulta> Consultas { get; set; }
    }

    public class MedicoDTO
    {
        public int? Id { get; set; }
        public string Nome { get; set; }
        public string crm { get; set; }

        public EspecialidadeDTO Especialidade { get; set; }
        public IEnumerable<ConsultaDTO> Consultas { get; set; }

        public MedicoDTO() { }
        public MedicoDTO(Medico entity)
        {
            this.Id = entity.Id;
            this.Nome = entity.Nome;
            this.crm = entity.CRM;
            this.Especialidade = new EspecialidadeDTO(entity.Especialidade);
            this.Consultas = entity.Consultas
                .ToList()
                .Select(x => new ConsultaDTO(x))
                .ToList();
        }
    }
}