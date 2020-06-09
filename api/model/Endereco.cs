using System;
using System.ComponentModel.DataAnnotations;

namespace api.model
{
    public class Endereco : IModel
    {
        [Key]
        public int Id { get; set; }
        public string Rua { get; set; }
        public string Bairro { get; set; }
        public string Numero { get; set; }
    }

    public class EnderecoDTO
    {
        public int? Id { get; set; }
        public string Rua { get; set; }
        public string Bairro { get; set; }
        public string Numero { get; set; }

        public EnderecoDTO() { }
        public EnderecoDTO(Endereco entity)
        {
            this.Id = entity.Id;
            this.Rua = entity.Rua;
            this.Bairro = entity.Bairro;
            this.Numero = entity.Numero;
        }
    }
}