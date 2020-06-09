using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;

namespace api.model
{
    public class Consulta : IModel
    {
        [Key]
        public int Id { get; set; }
        public DateTime DataHora { get; set; }

        [Column("Cobertura")]
        [ForeignKey("Cobertura")]
        public int? CoberturaId { get; set; }
        public virtual Cobertura Cobertura { get; set; }

        [Column("Paciente")]
        [ForeignKey("Paciente")]
        public int PacienteId { get; set; }
        public virtual Paciente Paciente { get; set; }

        [Column("Medico")]
        [ForeignKey("Medico")]
        public int MedicoId { get; set; }
        public virtual Medico Medico { get; set; }
        public virtual IEnumerable<ReceitaMedica> ReceitasMedicas { get; set; }
        public virtual IEnumerable<ReqExame> ReqExames { get; set; }
    }

    public class ConsultaDTO
    {
        public int Id { get; set; }
        public DateTime DataHora { get; set; }
        public CoberturaDTO Cobertura { get; set; }
        public PacienteDTO Paciente { get; set; }
        public MedicoDTO Medico { get; set; }
        public IEnumerable<ReceitaMedicaDTO> ReceitasMedicas { get; set; }
        public IEnumerable<ReqExameDTO> ReqExames { get; set; }
        public ConsultaDTO() { }
        public ConsultaDTO(Consulta entity)
        {
            this.Id = entity.Id;
            this.DataHora = entity.DataHora;
            this.Cobertura = new CoberturaDTO(entity.Cobertura);
            this.Paciente = new PacienteDTO(entity.Paciente);
            this.Medico = new MedicoDTO(entity.Medico);
            this.ReceitasMedicas = entity.ReceitasMedicas
                .Select(rm => new ReceitaMedicaDTO(rm))
                .ToList();

            this.ReqExames = entity.ReqExames
                .Select(rm => new ReqExameDTO(rm))
                .ToList();
        }
    }
}