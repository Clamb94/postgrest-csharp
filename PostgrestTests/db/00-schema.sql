﻿-- Create the Replication publication 
CREATE PUBLICATION supabase_realtime FOR ALL TABLES;

-- Create a second schema
CREATE SCHEMA personal;

-- USERS
CREATE TYPE public.user_status AS ENUM ('ONLINE', 'OFFLINE');
CREATE TABLE public.users
(
    username         text primary key,
    inserted_at      timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at       timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    favorite_numbers int[]                       DEFAULT null,
    favorite_name    text UNIQUE                                                      null,
    data             jsonb                       DEFAULT null,
    age_range        int4range                   DEFAULT null,
    status           user_status                 DEFAULT 'ONLINE'::public.user_status,
    catchphrase      tsvector                    DEFAULT null
);
ALTER TABLE public.users
    REPLICA IDENTITY FULL; -- Send "previous data" to supabase 
COMMENT ON COLUMN public.users.data IS 'For unstructured data and prototyping.';

-- CHANNELS
CREATE TABLE public.channels
(
    id          bigint GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    inserted_at timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at  timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    data        jsonb                       DEFAULT null,
    slug        text
);
ALTER TABLE public.users
    REPLICA IDENTITY FULL; -- Send "previous data" to supabase
COMMENT ON COLUMN public.channels.data IS 'For unstructured data and prototyping.';

-- MESSAGES
CREATE TABLE public.messages
(
    id          bigint GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    inserted_at timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at  timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    data        jsonb                       DEFAULT null,
    message     text,
    username    text REFERENCES users                                            NOT NULL,
    channel_id  bigint REFERENCES channels                                       NOT NULL
);
ALTER TABLE public.messages
    REPLICA IDENTITY FULL; -- Send "previous data" to supabase
COMMENT ON COLUMN public.messages.data IS 'For unstructured data and prototyping.';

create table "public"."kitchen_sink"
(
    "id"                          uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    "string_value"                varchar(255)     null,
    "bool_value"                  BOOL DEFAULT false,
    "unique_value"                varchar(255) UNIQUE,
    "int_value"                   INT              null,
    "float_value"                 FLOAT            null,
    "double_value"                DOUBLE PRECISION null,
    "datetime_value"              timestamp        null,
    "datetime_value_1"            timestamp        null,
    "datetime_pos_infinite_value" timestamp        null,
    "datetime_neg_infinite_value" timestamp        null,
    "list_of_strings"             TEXT[]           null,
    "list_of_datetimes"           DATE[]           null,
    "list_of_ints"                INT[]            null,
    "list_of_floats"              FLOAT[]          null,
    "int_range"                   INT4RANGE        null,
    "uuidv4"                      uuid             null
);

CREATE TABLE public.movie
(
    id         uuid                                 DEFAULT gen_random_uuid() PRIMARY KEY,
    created_at timestamp without time zone NOT NULL DEFAULT now(),
    name       character varying(255)      NULL,
    status     character varying(255)      NULL
);

CREATE TABLE public.person
(
    id         uuid                                 DEFAULT gen_random_uuid() PRIMARY KEY,
    created_at timestamp without time zone NOT NULL DEFAULT now(),
    first_name character varying(255)      NULL,
    last_name  character varying(255)      NULL
);

CREATE TABLE public.profile
(
    person_id  uuid PRIMARY KEY references person (id),
    email      character varying(255)      null,
    created_at timestamp without time zone NOT NULL DEFAULT now()
);

CREATE TABLE public.movie_person
(
    movie_id  uuid references movie (id),
    person_id uuid references person (id),
    primary key (movie_id, person_id)
);

-- STORED FUNCTION
CREATE FUNCTION public.get_status(name_param text)
    RETURNS user_status AS
$$
SELECT status
from users
WHERE username = name_param;
$$ LANGUAGE SQL IMMUTABLE;

-- STORED FUNCTION WITH ROW PARAMETER
CREATE FUNCTION public.get_data(param public.users)
    RETURNS public.users.data%TYPE AS
$$
SELECT data
from users u
WHERE u.username = param.username;
$$ LANGUAGE SQL IMMUTABLE;

-- SECOND SCHEMA USERS
CREATE TYPE personal.user_status AS ENUM ('ONLINE', 'OFFLINE');
CREATE TABLE personal.users
(
    username    text primary key,
    inserted_at timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at  timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    data        jsonb                       DEFAULT null,
    age_range   int4range                   DEFAULT null,
    status      user_status                 DEFAULT 'ONLINE'::public.user_status
);

-- SECOND SCHEMA STORED FUNCTION
CREATE FUNCTION personal.get_status(name_param text)
    RETURNS user_status AS
$$
SELECT status
from users
WHERE username = name_param;
$$ LANGUAGE SQL IMMUTABLE;

-- SECOND SCHEMA STORED FUNCTION WITH ROW PARAMETER
CREATE FUNCTION personal.get_data(param personal.users)
    RETURNS personal.users.data%TYPE AS
$$
SELECT data
from users u
WHERE u.username = param.username;
$$ LANGUAGE SQL IMMUTABLE;

