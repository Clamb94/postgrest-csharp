﻿using System.Runtime.Serialization;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using Postgrest.Attributes;
using Postgrest.Models;

namespace PostgrestTests.Models
{
	[Table("todos")]
	public class Todo : BaseModel
	{
		[JsonConverter(typeof(StringEnumConverter))]
		public enum TodoStatus
		{
			[EnumMember(Value = "NOT STARTED")]
			NOT_STARTED,
			[EnumMember(Value = "IN PROGRESS")]
			IN_PROGRESS,
			[EnumMember(Value = "DONE")]
			DONE,
		}

		[PrimaryKey("id")]
		public int Id { get; set; }

		[Column("user_id")]
		public int UserId { get; set; }

		[Column("status")]
		public TodoStatus Status { get; set; }

		[Column("name")]
		public string? Name { get; set; }

		[Column("notes")]
		public string? Notes { get; set; }

		[Column("done")]
		public bool Done { get; set; }

		[Column("details")]
		public string? Details { get; set; }
	}
}
