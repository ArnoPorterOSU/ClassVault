module Types.Student exposing
    ( Student
    , Name
    , Address
    )

import Types.Email exposing (Email)

-- STUDENT TYPE

type alias Student =
    { name : Name
    , id : Int
    , email : Email
    , gpa : Float
    , address : Address
    -- TODO: Add attendance records to this somehow
    }


-- NAME TYPE

type alias Name =
    { first : String
    , last : String
    , middles : List String
    }


-- ADDRESS TYPE

type alias Address =
    { street : String
    , zipCode : Int
    , city : String
    , state : String
    }