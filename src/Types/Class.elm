module Types.Class exposing
    (   Class
    ,   decode
    )

import Json.Decode as D exposing (Decoder)
import Types.Event as Event exposing (Event)
import Types.WeeklyEvent as WE exposing (WeeklyEvent)

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