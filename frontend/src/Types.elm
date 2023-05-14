module Types exposing
    ( Student
    , Name
    , Address
    )

-- STUDENT TYPE

type alias Student =
    { name : Name
    , id : Int
    , email : String
    , gpa : Float
    , address : Address
    -- TODO: Add attendance records to this somehow
    }


-- NAME TYPE

type alias Name =
    { first : String
    , middles : List String
    , last : String
    }


-- ADDRESS TYPE

type alias Address =
    { streetAddress : String
    , zipCode : Int
    , city : String
    , state : String
    }