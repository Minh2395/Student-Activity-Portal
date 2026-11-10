
using Microsoft.EntityFrameworkCore;
using StudentActivityPortal.Api.Data;

var builder = WebApplication.CreateBuilder(args);

// 1. Register Entity Framework Core
builder.Services.AddDbContext<ApplicationDbContext>(options =>
    options.UseSqlServer(
        builder.Configuration.GetConnectionString("DefaultConnection")
    )
);

// 2. Register services
builder.Services.AddControllers();
builder.Services.AddOpenApi();

var app = builder.Build();

// 3. Configure HTTP request pipeline
if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();
