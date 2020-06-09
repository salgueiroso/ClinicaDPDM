using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace api.model
{
    public class ReqExame : IModel
    {
        [Key]
        public int Id { get; set; }
        public string Descricao { get; set; }
        public DateTime Data { get; set; }

        [Column("Consulta")]
        [ForeignKey("Consulta")]
        public int ConsultaId { get; set; }
        public virtual Consulta Consulta { get; set; }
    }

    public class ReqExameDTO
    {
        public int Id { get; set; }
        public string Descricao { get; set; }
        public DateTime Data { get; set; }
        public ConsultaDTO Consulta { get; set; }

        public ReqExameDTO() { }
        public ReqExameDTO(ReqExame entity)
        {
            this.Id = entity.Id;
            this.Descricao = entity.Descricao;
            this.Data = entity.Data;
            this.Consulta = new ConsultaDTO(entity.Consulta);
        }
    }
}