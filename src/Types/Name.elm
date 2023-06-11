module Types.Name exposing
    ( Name
    , toString
    , fromString
    , decode
    , encode
    )


import Json.Encode as E exposing (Value)
import Json.Decode as D exposing (Decoder)


-- Name record, consisting of the following fields:
-- first: A first name
-- last: A last name
-- middles: A list of middle names; potentially empty
type alias Name = 
    { first : String
    , last : String
    , middles : List String
    }


-- Converts a name to a string
toString : Name -> String
toString name =
    name.first ++ List.foldr (++) " " (List.map ((++) " ") name.middles) ++ name.last


-- Converts a string into a name
fromString : String -> Maybe Name
fromString nameString =
    let
        nameData = nameString |> String.split " " >> List.map String.trim >> List.filter (String.length >> (<) 0)
        nameLen = List.length nameData
    in
        if nameLen < 2 then
            Nothing
        else
            let
                first = nameData |> List.head >> Maybe.withDefault ""
                last = nameData |> List.drop (nameLen - 1) >> List.head >> Maybe.withDefault ""
                middles = nameData |> List.take (nameLen - 1) >> List.drop 1
            in
                Just
                    { first = first
                    , last = last
                    , middles = middles
                    }
        



-- JSON Encoder
encode : Name -> Value
encode name =
    E.object
        [ ("first", E.string name.first)
        , ("last", E.string name.last)
        , ("middles", E.list E.string name.middles)
        ]


-- Decoder to decode a name from JSON
decode : Decoder Name
decode =
    D.map3 Name
        (D.field "first" D.string)
        (D.field "last" D.string)
        (D.map (Maybe.withDefault []) << D.maybe << D.field "middles" <| D.list D.string)