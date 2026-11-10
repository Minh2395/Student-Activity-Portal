using System;
using System.Collections.Generic;

namespace StudentActivityPortal.Api.Models.Entities;

public partial class ActivityCategory
{
    public int CategoryId { get; set; }

    public string CategoryName { get; set; } = null!;

    public string? Description { get; set; }

    public virtual ICollection<Activity> Activities { get; set; } = new List<Activity>();
}
