using System.ComponentModel.DataAnnotations;

namespace StudentActivityPortal.Api.Dtos.Students;

public class CreateStudentDto
{
    [Required]
    [StringLength(50)]
    public string Username { get; set; } = string.Empty;

    [Required]
    [StringLength(255, MinimumLength = 8)]
    public string Password { get; set; } = string.Empty;

    [Required]
    [EmailAddress]
    [StringLength(100)]
    public string Email { get; set; } = string.Empty;

    [Required]
    [StringLength(100)]
    public string FullName { get; set; } = string.Empty;

    [StringLength(15)]
    public string? PhoneNumber { get; set; }

    [Required]
    [StringLength(20)]
    public string StudentCode { get; set; } = string.Empty;

    [StringLength(50)]
    public string? ClassName { get; set; }

    [StringLength(100)]
    public string? Major { get; set; }
}
