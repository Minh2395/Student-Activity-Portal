using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;
using StudentActivityPortal.Api.Models.Entities;

namespace StudentActivityPortal.Api.Data;

public partial class ApplicationDbContext : DbContext
{
    public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Activity> Activities { get; set; }

    public virtual DbSet<ActivityCategory> ActivityCategories { get; set; }

    public virtual DbSet<Notification> Notifications { get; set; }

    public virtual DbSet<NotificationRecipient> NotificationRecipients { get; set; }

    public virtual DbSet<Registration> Registrations { get; set; }

    public virtual DbSet<Student> Students { get; set; }

    public virtual DbSet<User> Users { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Activity>(entity =>
        {
            entity.HasKey(e => e.ActivityId).HasName("PK__Activiti__45F4A791C0C931C6");

            entity.HasIndex(e => e.CategoryId, "IX_Activities_CategoryId");

            entity.HasIndex(e => e.StartTime, "IX_Activities_StartTime");

            entity.Property(e => e.ActivityName).HasMaxLength(200);
            entity.Property(e => e.CreatedAt).HasDefaultValueSql("(sysdatetime())");
            entity.Property(e => e.Location).HasMaxLength(200);
            entity.Property(e => e.Status)
                .HasMaxLength(20)
                .HasDefaultValue("Draft");

            entity.HasOne(d => d.Category).WithMany(p => p.Activities)
                .HasForeignKey(d => d.CategoryId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Activities_Categories");

            entity.HasOne(d => d.Organizer).WithMany(p => p.Activities)
                .HasForeignKey(d => d.OrganizerId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Activities_Users");
        });

        modelBuilder.Entity<ActivityCategory>(entity =>
        {
            entity.HasKey(e => e.CategoryId).HasName("PK__Activity__19093A0B962F0288");

            entity.HasIndex(e => e.CategoryName, "UQ__Activity__8517B2E08414FA2A").IsUnique();

            entity.Property(e => e.CategoryName).HasMaxLength(100);
            entity.Property(e => e.Description).HasMaxLength(500);
        });

        modelBuilder.Entity<Notification>(entity =>
        {
            entity.HasKey(e => e.NotificationId).HasName("PK__Notifica__20CF2E12A38999BB");

            entity.Property(e => e.CreatedAt).HasDefaultValueSql("(sysdatetime())");
            entity.Property(e => e.Title).HasMaxLength(200);
        });

        modelBuilder.Entity<NotificationRecipient>(entity =>
        {
            entity.HasKey(e => e.NotificationRecipientId).HasName("PK__Notifica__F6659EE4DD8CE6BD");

            entity.HasIndex(e => new { e.UserId, e.IsRead }, "IX_NotificationRecipients_UserId");

            entity.HasIndex(e => new { e.NotificationId, e.UserId }, "UQ_Notification_User").IsUnique();

            entity.HasOne(d => d.Notification).WithMany(p => p.NotificationRecipients)
                .HasForeignKey(d => d.NotificationId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Recipients_Notifications");

            entity.HasOne(d => d.User).WithMany(p => p.NotificationRecipients)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Recipients_Users");
        });

        modelBuilder.Entity<Registration>(entity =>
        {
            entity.HasKey(e => e.RegistrationId).HasName("PK__Registra__6EF588102EE23092");

            entity.HasIndex(e => new { e.ActivityId, e.Status }, "IX_Registrations_ActivityId_Status");

            entity.HasIndex(e => e.StudentId, "IX_Registrations_StudentId");

            entity.HasIndex(e => new { e.StudentId, e.ActivityId }, "UQ_Student_Activity").IsUnique();

            entity.Property(e => e.RegisteredAt).HasDefaultValueSql("(sysdatetime())");
            entity.Property(e => e.Status)
                .HasMaxLength(20)
                .HasDefaultValue("Pending");

            entity.HasOne(d => d.Activity).WithMany(p => p.Registrations)
                .HasForeignKey(d => d.ActivityId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Registrations_Activities");

            entity.HasOne(d => d.Student).WithMany(p => p.Registrations)
                .HasForeignKey(d => d.StudentId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Registrations_Students");
        });

        modelBuilder.Entity<Student>(entity =>
        {
            entity.HasKey(e => e.StudentId).HasName("PK__Students__32C52B99A115DE02");

            entity.HasIndex(e => e.UserId, "UQ__Students__1788CC4D321017CD").IsUnique();

            entity.HasIndex(e => e.StudentCode, "UQ__Students__1FC8860410002999").IsUnique();

            entity.Property(e => e.ClassName).HasMaxLength(50);
            entity.Property(e => e.Major).HasMaxLength(100);
            entity.Property(e => e.StudentCode).HasMaxLength(20);

            entity.HasOne(d => d.User).WithOne(p => p.Student)
                .HasForeignKey<Student>(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Students_Users");
        });

        modelBuilder.Entity<User>(entity =>
        {
            entity.HasKey(e => e.UserId).HasName("PK__Users__1788CC4CA70D223F");

            entity.HasIndex(e => e.Username, "UQ__Users__536C85E499D2E474").IsUnique();

            entity.HasIndex(e => e.Email, "UQ__Users__A9D105344AA9505F").IsUnique();

            entity.Property(e => e.CreatedAt).HasDefaultValueSql("(sysdatetime())");
            entity.Property(e => e.Email).HasMaxLength(100);
            entity.Property(e => e.FullName).HasMaxLength(100);
            entity.Property(e => e.IsActive).HasDefaultValue(true);
            entity.Property(e => e.PasswordHash).HasMaxLength(255);
            entity.Property(e => e.PhoneNumber).HasMaxLength(15);
            entity.Property(e => e.Role)
                .HasMaxLength(20)
                .HasDefaultValue("Student");
            entity.Property(e => e.Username).HasMaxLength(50);
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
