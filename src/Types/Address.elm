module Types.Address exposing
    (   Address
    ,   toString
    ,   decode
    )


import Json.Decode as D exposing (Decoder)


-- The Address datatype
type alias Address =
    {   street : String
    ,   city : String
    ,   state : String
    ,   zipCode : Int
    }


-- Converts an Address into a String
toString : Address -> String
toString addr =
    addr.street ++ " " addr.city ++ ", " ++ addr.state ++ " " ++ String.fromInt addr.zipCode


-- Decodes an Address
decode : Decoder Address
decode =
    D.map4 Address
        (D.field "street" D.string)
        (D.field "city" D.string)
        (D.field "state" D.string)
        (D.field "zipCode" D.int)