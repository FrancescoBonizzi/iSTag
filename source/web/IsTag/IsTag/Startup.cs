using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.AzureAD.UI;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Authorization;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using System.Linq;

namespace IsTag
{
    public class Startup
    {
        public IConfiguration Configuration { get; }
        private const string _multipleSchemasAuthenticationHandler = "multipleSchemasAuthenticationHandler";

        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public void ConfigureServices(IServiceCollection services)
        {
            services
                .AddAuthentication(sharedOptions =>
                {
                    sharedOptions.DefaultScheme = _multipleSchemasAuthenticationHandler;
                    sharedOptions.DefaultChallengeScheme = _multipleSchemasAuthenticationHandler;
                })
                .AddAzureAD(options =>
                {
                    // Azure Cookie authentication policy
                    Configuration.Bind("AzureAd", options);
                })
                .AddAzureADBearer(options =>
                {
                    // Azure header Authorization Bearer authentication policy
                    Configuration.Bind("AzureAd", options);
                })
                .AddPolicyScheme(_multipleSchemasAuthenticationHandler, "Multiple schemas", options =>
                {
                    options.ForwardDefaultSelector = context =>
                    {
                        var authHeader = context.Request.Headers["Authorization"].FirstOrDefault();
                        if (authHeader?.StartsWith("Bearer ") == true)
                        {
                            return AzureADDefaults.JwtBearerAuthenticationScheme;
                        }

                        return AzureADDefaults.AuthenticationScheme;
                    };
                });

            services.AddMvc(options =>
            {
                var policy = new AuthorizationPolicyBuilder()
                //    .AddAuthenticationSchemes(AzureADDefaults.AuthenticationScheme)
                    .RequireAuthenticatedUser()
                    .Build();
                options.Filters.Add(new AuthorizeFilter(policy));
            })
            .SetCompatibilityVersion(CompatibilityVersion.Version_2_2);
        }

        public void Configure(
            IApplicationBuilder app,
            IHostingEnvironment env)
        {
            app.UseDeveloperExceptionPage();

            if (!env.IsDevelopment())
            {
                app.UseHsts();
            }

            app.UseHttpsRedirection();
            app.UseStaticFiles();
            app.UseAuthentication();

            app.UseDefaultFiles();

            app.UseMvc(routes =>
            {
                routes.MapRoute(
                    name: "default",
                    template: "{controller=Pages}/{action=Index}/{id?}");
            });
        }
    }
}
