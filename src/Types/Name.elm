module Types.Name exposing
    ( Name
    , toString
    , decode
    )


import Json.Decode as D exposing (Decoder)


type alias Name = 
    { first : String
    , last : String
    , middles : List String
    }


-- Converts a name to a string
toString : Name -> String
toString name =
    name.first ++ List.foldr (++) " " (List.map ((++) " ") name.middles) ++ name.last


decode : Decoder Name
decode =
    D.map3 Name
        (D.field "first" D.string)
        (D.field "last" D.string)
        (D.map (Maybe.withDefault []) <|
            D.maybe <| D.field "middles" <| D.list D.string)