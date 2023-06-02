module Types.Class exposing
    (   Class
    ,   decode
    )


import Json.Decode as D exposing (Decoder)
import Types.Event as Event exposing (Event)
import Types.WeeklyEvent as WE exposing (WeeklyEvent)


-- Class object, consisting of:
-- subject: representing the name of the class, e.g. "MTH 231"
-- crn: the course registration number
-- credits: how many credits the class is
-- sessions: a list of weekly meeting times
-- midterms: a list of events
-- final: either a single event (Just Event) or Nothing
type alias Class =
    {   subject : String
    ,   crn : Int
    ,   credits : Int
    ,   sessions : List WeeklyEvent
    ,   midterms: List Event
    ,   final : Maybe Event
    }


decode : Decoder Class
decode =
    D.map6 Class
        (D.field "subject" D.string)
        (D.field "crn" D.int)
        (D.field "credits" D.int)
        (D.field "sessions" <| D.list WE.decode)
        (D.field "midterms" <| D.list Event.decode)
        (D.maybe <| D.field "final" Event.decode)