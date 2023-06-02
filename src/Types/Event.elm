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
    { when : Time.Posix
    , what : String
    , where : String
    , duration : Milliseconds
    }


-- JSON encoder for the Event class
encode : Event -> Value
encode event =
    E.object
        [ ("when", E.int <| Time.posixToMillis event.when)
        , ("what", E.string event.what)
        , ("where", E.string event.where)
        , ("duration", E.float event.duration)
        ]


-- JSON decoder for the Event class
decode : Decoder Event
decode =
    D.map4 Event
        (D.map Time.millisToPosix <| D.field "when" D.int)
        (D.field "what" D.string)
        (D.field "where" D.string)
        (D.field "duration" D.float)