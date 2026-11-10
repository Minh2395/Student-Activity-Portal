using System.ComponentModel.DataAnnotations;

namespace StudentActivityPortal.Api.Dtos.Students;

public class UpdateStudentDto
{
    [Required]
    [EmailAddress]
    [StringLength(100)]
    public string Email { get; set; } = string.Empty;

    [Required]
    [StringLength(100)]
    public string FullName { get; set; } = string.Empty;

    [StringLength(15)]
    public string? PhoneNumber { get; set; }

    [StringLength(50)]
    public string? ClassName { get; set; }

    [StringLength(100)]
    public string? Major { get; set; }
}
