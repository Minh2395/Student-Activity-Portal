using System;
using System.Collections.Generic;

namespace StudentActivityPortal.Api.Models.Entities;

public partial class Registration
{
    public int RegistrationId { get; set; }

    public int StudentId { get; set; }

    public int ActivityId { get; set; }

    public DateTime RegisteredAt { get; set; }

    public string Status { get; set; } = null!;

    public virtual Activity Activity { get; set; } = null!;

    public virtual Student Student { get; set; } = null!;
}
