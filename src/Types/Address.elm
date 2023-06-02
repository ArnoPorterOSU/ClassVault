module Types.Address exposing
    ( Address
    , toString
    , decode
    , encode
    )


import Json.Decode as D exposing (Decoder)
import Json.Encode as E exposing (Value)


-- The Address datatype
type alias Address =
    { street : String
    , city : String
    , state : String
    , zipCode : Int
    }


-- Converts an Address into a String
toString : Address -> String
toString addr =
    addr.street ++ " " ++ addr.city ++ ", " ++ addr.state ++ " " ++ String.fromInt addr.zipCode


-- Encodes an Address into JSON
encode : Address -> Value
encode addr =
    E.object
        [ ("street", E.string addr.street)
        , ("city", E.string addr.city)
        , ("state", E.string addr.state)
        , ("zipCode", E.int addr.zipCode)
        ]


-- Decodes an Address from JSON
decode : Decoder Address
decode =
    D.map4 Address
        (D.field "street" D.string)
        (D.field "city" D.string)
        (D.field "state" D.string)
        (D.field "zipCode" D.int)