
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using StudentActivityPortal.Api.Data;
using StudentActivityPortal.Api.Dtos.Students;
using StudentActivityPortal.Api.Models.Entities;

namespace StudentActivityPortal.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class StudentsController : ControllerBase
{
    private readonly ApplicationDbContext _context;
    private readonly PasswordHasher<User> _passwordHasher = new();

    public StudentsController(ApplicationDbContext context)
    {
        _context = context;
    }

    // GET: api/students
    [HttpGet]
    public async Task<ActionResult<IEnumerable<StudentResponseDto>>> GetStudents()
    {
        var students = await _context.Students
            .Where(s => s.User.IsActive)
            .AsNoTracking()
            .Select(s => new StudentResponseDto
            {
                StudentId = s.StudentId,
                UserId = s.UserId,
                Username = s.User.Username,
                StudentCode = s.StudentCode,
                FullName = s.User.FullName,
                Email = s.User.Email,
                PhoneNumber = s.User.PhoneNumber,
                ClassName = s.ClassName,
                Major = s.Major,
                IsActive = s.User.IsActive,
                CreatedAt = s.User.CreatedAt
            })
            .ToListAsync();

        return Ok(students);
    }

    // GET: api/students/{id}
    [HttpGet("{id:int}")]
    public async Task<ActionResult<StudentResponseDto>> GetStudent(int id)
    {
        var student = await _context.Students
            .AsNoTracking()
            .Where(s => s.StudentId == id)
            .Select(s => new StudentResponseDto
            {
                StudentId = s.StudentId,
                UserId = s.UserId,
                Username = s.User.Username,
                StudentCode = s.StudentCode,
                FullName = s.User.FullName,
                Email = s.User.Email,
                PhoneNumber = s.User.PhoneNumber,
                ClassName = s.ClassName,
                Major = s.Major,
                IsActive = s.User.IsActive,
                CreatedAt = s.User.CreatedAt
            })
            .FirstOrDefaultAsync();

        if (student == null)
        {
            return NotFound(new
            {
                message = "Không tìm thấy sinh viên."
            });
        }

        return Ok(student);
    }

    // POST: api/students
    [HttpPost]
    public async Task<ActionResult<StudentResponseDto>> CreateStudent(
        [FromBody] CreateStudentDto dto)
    {
        if (await _context.Users.AnyAsync(u => u.Username == dto.Username))
        {
            return Conflict(new { message = "Username đã tồn tại." });
        }

        if (await _context.Users.AnyAsync(u => u.Email == dto.Email))
        {
            return Conflict(new { message = "Email đã tồn tại." });
        }

        if (await _context.Students.AnyAsync(
            s => s.StudentCode == dto.StudentCode))
        {
            return Conflict(new { message = "Mã sinh viên đã tồn tại." });
        }

        var user = new User
        {
            Username = dto.Username,
            Email = dto.Email,
            FullName = dto.FullName,
            PhoneNumber = dto.PhoneNumber,
            Role = "Student",
            IsActive = true
        };

        user.PasswordHash = _passwordHasher.HashPassword(
            user,
            dto.Password
        );

        var student = new Student
        {
            User = user,
            StudentCode = dto.StudentCode,
            ClassName = dto.ClassName,
            Major = dto.Major
        };

        _context.Students.Add(student);
        await _context.SaveChangesAsync();

        var response = new StudentResponseDto
        {
            StudentId = student.StudentId,
            UserId = user.UserId,
            Username = user.Username,
            StudentCode = student.StudentCode,
            FullName = user.FullName,
            Email = user.Email,
            PhoneNumber = user.PhoneNumber,
            ClassName = student.ClassName,
            Major = student.Major,
            IsActive = user.IsActive,
            CreatedAt = user.CreatedAt
        };

        return CreatedAtAction(
            nameof(GetStudent),
            new { id = student.StudentId },
            response
        );
    }

    // PUT: api/students/{id}
    [HttpPut("{id:int}")]
    public async Task<IActionResult> UpdateStudent(
        int id,
        [FromBody] UpdateStudentDto dto)
    {
        var student = await _context.Students
            .Include(s => s.User)
            .FirstOrDefaultAsync(s => s.StudentId == id);

        if (student == null)
        {
            return NotFound(new
            {
                message = "Không tìm thấy sinh viên."
            });
        }

        bool emailExists = await _context.Users.AnyAsync(
            u => u.Email == dto.Email &&
                 u.UserId != student.UserId
        );

        if (emailExists)
        {
            return Conflict(new
            {
                message = "Email đã được sử dụng."
            });
        }

        student.User.Email = dto.Email;
        student.User.FullName = dto.FullName;
        student.User.PhoneNumber = dto.PhoneNumber;

        student.ClassName = dto.ClassName;
        student.Major = dto.Major;

        await _context.SaveChangesAsync();

        return NoContent();
    }

    // DELETE: api/students/{id}
    [HttpDelete("{id:int}")]
    public async Task<IActionResult> DeleteStudent(int id)
    {
        var student = await _context.Students
            .Include(s => s.User)
            .FirstOrDefaultAsync(s => s.StudentId == id);

        if (student == null)
        {
            return NotFound(new
            {
                message = "Không tìm thấy sinh viên."
            });
        }

        if (!student.User.IsActive)
        {
            return BadRequest(new
            {
                message = "Sinh viên đã bị vô hiệu hóa."
            });
        }

        student.User.IsActive = false;

        await _context.SaveChangesAsync();

        return Ok(new
        {
            message = "Vô hiệu hóa sinh viên thành công."
        });
    }
}
