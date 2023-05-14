module Types.Email exposing (Email, toString)

type Email
    = Email String

toString : Email -> String
toString (Email str) =
    str