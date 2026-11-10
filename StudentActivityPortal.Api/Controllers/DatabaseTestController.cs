
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using StudentActivityPortal.Api.Data;

namespace StudentActivityPortal.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class DatabaseTestController : ControllerBase
{
    private readonly ApplicationDbContext _context;
    private readonly ILogger<DatabaseTestController> _logger;

    public DatabaseTestController(
        ApplicationDbContext context,
        ILogger<DatabaseTestController> logger)
    {
        _context = context;
        _logger = logger;
    }

    [HttpGet]
    public async Task<IActionResult> CheckConnection()
    {
        try
        {
            bool connected = await _context.Database.CanConnectAsync();

            if (!connected)
            {
                return StatusCode(503, new
                {
                    success = false,
                    message = "Không thể kết nối SQL Server."
                });
            }

            return Ok(new
            {
                success = true,
                message = "Kết nối SQL Server thành công.",
                database = _context.Database.GetDbConnection().Database
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Database connection test failed.");

            return StatusCode(503, new
            {
                success = false,
                message = "Có lỗi khi kết nối SQL Server."
            });
        }
    }
}
