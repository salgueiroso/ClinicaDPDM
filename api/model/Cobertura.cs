using System;
using System.ComponentModel.DataAnnotations;

namespace api.model
{
    public class Cobertura : IModel
    {
        [Key]
        public int Id { get; set; }
        public string Nome { get; set; }
    }

    public class CoberturaDTO
    {
        public int? Id { get; set; }
        public string Nome { get; set; }

        public CoberturaDTO() { }
        public CoberturaDTO(Cobertura entity)
        {
            this.Id = entity.Id;
            this.Nome = entity.Nome;
        }
    }
}