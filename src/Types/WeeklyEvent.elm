module Types.WeeklyEvent exposing
    (   WeeklyEvent
    ,   decode
    )


import Json.Decode as D exposing (Decoder)
import Types.Event exposing (Event)


type alias WeeklyEvent =
    {   event : Event
    ,   repetitions : Maybe Int
    }


decode : Decoder WeeklyEvent
decode =
    D.map2 WeeklyEvent
        (D.field "event" Event.decode)
        (D.maybe <| D.field "repetitions" D.int)