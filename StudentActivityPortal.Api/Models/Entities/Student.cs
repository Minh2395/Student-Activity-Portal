using System;
using System.Collections.Generic;

namespace StudentActivityPortal.Api.Models.Entities;

public partial class Student
{
    public int StudentId { get; set; }

    public int UserId { get; set; }

    public string StudentCode { get; set; } = null!;

    public string? ClassName { get; set; }

    public string? Major { get; set; }

    public virtual ICollection<Registration> Registrations { get; set; } = new List<Registration>();

    public virtual User User { get; set; } = null!;
}
