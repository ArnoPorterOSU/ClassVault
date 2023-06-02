module Types.WeeklyEvent exposing
    (   WeeklyEvent
    ,   decode
    )


import Json.Decode as D exposing (Decoder)
import Types.Event exposing (Event)


-- WeeklyEvent record, consisting of
-- event: An underlying Event record
-- repetitions: If Nothing, represents a WeeklyEvent that should repeat indefinitely
--      if Just x, represents an event that shall repeat x times.
type alias WeeklyEvent =
    {   event : Event
    ,   repetitions : Maybe Int
    }


-- JSON decoder for a WeeklyEvent object
decode : Decoder WeeklyEvent
decode =
    D.map2 WeeklyEvent
        (D.field "event" Event.decode)
        (D.maybe <| D.field "repetitions" D.int)