module Types.Student exposing
    ( Student
    , Address
    )

import Types.Email exposing (Email)
import Types.Name exposing (Name)

-- STUDENT TYPE

type alias Student =
    { name : Name
    , id : Int
    , email : Email
    , gpa : Float
    , address : Address
    }

-- ADDRESS TYPE

type alias Address =
    { street : String
    , zipCode : Int
    , city : String
    , state : String
    }