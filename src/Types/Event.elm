module Types.Event exposing
    (   Event
    ,   decode
    )


import Json.Decode as D exposing (Decoder)
import Time


-- convenience type alias representing milliseconds
type alias Milliseconds =
    Float


-- Event record, consisting of:
-- when: when the event happens, in Posix time format
-- what: the event's name
-- where: the event's location
-- duration: how long the event lasts, in milliseconds as a Float
type alias Event =
    {   when : Time.Posix
    ,   what : String
    ,   where : String
    ,   duration : Milliseconds
    }


-- JSON decoder for the Event class
decode : Decoder Event
decode =
    D.map4 Event
        (D.map Time.millisToPosix <| D.field "when" D.int)
        (D.field "what" D.string)
        (D.field "where" D.string)
        (D.field "duration" D.float)