using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace api.model
{
    public class Paciente : IModel
    {
        [Key]
        public int Id { get; set; }

        public string Nome { get; set; }
        public string Login { get; set; }
        public string Senha { get; set; }

        public DateTime DataNascimento { get; set; }

        public long Telefone { get; set; }
        public int RG { get; set; }
        public long CPF { get; set; }

        [Column("Endereco")]
        [ForeignKey("Endereco")]
        public int EnderecoId { get; set; }
        public virtual Endereco Endereco { get; set; }
    }

    public class LoginDTO
    {
        public string Login { get; set; }
        public string Senha { get; set; }
    }

    public class PacienteDTO : LoginDTO
    {
        public int? Id { get; set; }

        public string Nome { get; set; }

        public DateTime DataNascimento { get; set; }

        public long Telefone { get; set; }
        public int rg { get; set; }
        public long cpf { get; set; }
        public EnderecoDTO Endereco { get; set; }

        public PacienteDTO() { }
        public PacienteDTO(Paciente entity)
        {
            this.Id = entity.Id;
            this.Nome = entity.Nome;
            this.DataNascimento = entity.DataNascimento;
            this.Telefone = entity.Telefone;
            this.rg = entity.RG;
            this.cpf = entity.CPF;
            this.Login = entity.Login;
            this.Endereco = new EnderecoDTO(entity.Endereco);
        }
    }
}