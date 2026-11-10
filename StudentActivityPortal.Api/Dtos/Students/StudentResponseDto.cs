namespace StudentActivityPortal.Api.Dtos.Students;

public class StudentResponseDto
{
    public int StudentId { get; set; }

    public int UserId { get; set; }

    public string Username { get; set; } = string.Empty;

    public string StudentCode { get; set; } = string.Empty;

    public string FullName { get; set; } = string.Empty;

    public string Email { get; set; } = string.Empty;

    public string? PhoneNumber { get; set; }

    public string? ClassName { get; set; }

    public string? Major { get; set; }

    public bool IsActive { get; set; }

    public DateTime CreatedAt { get; set; }
}
