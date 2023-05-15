module Types.Email exposing (Email, toString)

-- The Email type exists so that ordinary strings
-- are never confused for Emails
--
-- It adds some compile-time type sanity
type Email
    = Email String

-- Convert an Email to a String
toString : Email -> String
toString (Email str) =
    str