module Types.Event exposing
    (   Event
    ,   decode
    )


import Json.Decode as D exposing (Decoder)
import Time


type alias Event =
    {   when : Time.Posix
    ,   what : String
    ,   where : String
    ,   duration : Float
    }


decode : Decoder Event
decode =
    D.map4 Event
        (D.map Time.millisToPosix <| D.field "when" D.int)
        (D.field "what" D.string)
        (D.field "where" D.string)
        (D.field "duration" D.float)