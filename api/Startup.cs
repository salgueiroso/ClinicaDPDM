using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.HttpsPolicy;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Microsoft.EntityFrameworkCore;
using api.model;
using Microsoft.EntityFrameworkCore.Migrations;

using Microsoft.EntityFrameworkCore.Infrastructure;


namespace api
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddControllers();
            services.AddDbContext<ApplicationDbContext>(o => o.UseNpgsql(Configuration.GetConnectionString("PG")));
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env, ApplicationDbContext ctx)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }

            //app.UseHttpsRedirection();

            app.UseRouting();

            app.UseAuthorization();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });


            ctx.Database.EnsureCreated();
        }
    }

    public class ApplicationDbContext : DbContext
    {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
            : base(options)
        {

        }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            optionsBuilder.UseLazyLoadingProxies();
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            AdicionarEntidades(modelBuilder);

            base.OnModelCreating(modelBuilder);
        }

        private void AdicionarEntidades(ModelBuilder modelBuilder)
        {
            var models = this.GetType()
                .Assembly
                .ExportedTypes
                .Where(t => IsInherance(t, typeof(IModel)))
                .ToList();

            foreach (var m in models)
                modelBuilder.Entity(m);


        }

        private bool IsInherance(Type classe, Type tipo)
        {
            if (classe == null) return false;

            if (classe.GetInterfaces().Contains(tipo))
            {
                return true;
            }
            else
            {
                return IsInherance(classe.BaseType, tipo);
            }
        }

        public DbSet<Cobertura> Coberturas { get; set; }
        public DbSet<Consulta> Consultas { get; set; }
        public DbSet<Endereco> Enderecos { get; set; }
        public DbSet<Especialidade> Especialidades { get; set; }
        public DbSet<Medico> Medicos { get; set; }
        public DbSet<Paciente> Pacientes { get; set; }
        public DbSet<ReceitaMedica> ReceitasMedicas { get; set; }
        public DbSet<ReqExame> ReqExames { get; set; }
    }
}
