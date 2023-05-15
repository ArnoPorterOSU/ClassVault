module Types.Student exposing
    ( Student
    )

import Types.Email exposing (Email)
import Types.Name exposing (Name)
import Types.Address exposing (Address)


-- The Student datatype
type alias Student =
    { name : Name
    , id : Int
    , email : Email
    , gpa : Float
    , address : Address
    }