module Types.Event exposing
    ( Event
    , decode
    , encode
    )


import Json.Decode as D exposing (Decoder)
import Json.Encode as E exposing (Value)
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
    { start : Time.Posix
    , name : String
    , location : String
    , duration : Milliseconds
    }


-- JSON encoder for the Event class
encode : Event -> Value
encode event =
    E.object
        [ ("start", E.int <| Time.posixToMillis event.start)
        , ("name", E.string event.name)
        , ("location", E.string event.location)
        , ("duration", E.float event.duration)
        ]


-- JSON decoder for the Event class
decode : Decoder Event
decode =
    D.map4 Event
        (D.map Time.millisToPosix <| D.field "start" D.int)
        (D.field "name" D.string)
        (D.field "location" D.string)
        (D.field "duration" D.float)