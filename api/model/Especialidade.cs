using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace api.model
{
    public class Especialidade : IModel
    {
        [Key]
        public int Id { get; set; }

        public string Nome { get; set; }
        public virtual IEnumerable<Medico> Medicos { get; set; }

    }

    public class EspecialidadeDTO
    {
        public int? Id { get; set; }
        public string Nome { get; set; }

        public EspecialidadeDTO() { }
        public EspecialidadeDTO(Especialidade entity)
        {
            this.Id = entity.Id;
            this.Nome = entity.Nome;
        }
    }
}