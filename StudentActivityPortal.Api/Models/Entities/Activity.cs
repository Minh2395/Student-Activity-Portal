using System;
using System.Collections.Generic;

namespace StudentActivityPortal.Api.Models.Entities;

public partial class Activity
{
    public int ActivityId { get; set; }

    public int CategoryId { get; set; }

    public int OrganizerId { get; set; }

    public string ActivityName { get; set; } = null!;

    public string? Description { get; set; }

    public string? Location { get; set; }

    public DateTime StartTime { get; set; }

    public DateTime EndTime { get; set; }

    public DateTime RegistrationDeadline { get; set; }

    public int MaxParticipants { get; set; }

    public string Status { get; set; } = null!;

    public DateTime CreatedAt { get; set; }

    public virtual ActivityCategory Category { get; set; } = null!;

    public virtual User Organizer { get; set; } = null!;

    public virtual ICollection<Registration> Registrations { get; set; } = new List<Registration>();
}
