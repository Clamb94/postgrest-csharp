﻿using Supabase.Postgrest.Attributes;
using Supabase.Postgrest.Models;

namespace PostgrestExample.Models
{
    [Table("messages")]
    public class Message : BaseModel
    {
        [Column("channel_id")]
        public int ChannelId { get; set; }

        [Column("message")]
        public string MessageData { get; set; } = null!;

        [Column("data")]
        public string Data { get; set; } = null!;

        [Column("username")]
        public string Username { get; set; } = null!;
    }
}
