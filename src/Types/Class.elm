module Types.Class exposing
    ( Class
    , decode
    , encode
    )


import Json.Decode as D exposing (Decoder)
import Json.Encode as E exposing (Value)
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
    { subject : String
    , crn : Int
    , credits : Int
    , sessions : List WeeklyEvent
    , midterms: List Event
    , final : Maybe Event
    }


-- JSON encoder for a Class object
encode : Class -> Value
encode class =
    E.object <|
        [ ("subject", E.string class.subject)
        , ("crn", E.int class.crn)
        , ("credits", E.int class.credits)
        , ("sessions", E.list WE.encode class.sessions)
        , ("midterms", E.list Event.encode class.midterms)
        ]
        ++
        case class.final of
            Just final ->
                [("final", Event.encode final)]

            _ ->
                []
                
-- JSON decoder for a Class object
decode : Decoder Class
decode =
    D.map6 Class
        (D.field "subject" D.string)
        (D.field "crn" D.int)
        (D.field "credits" D.int)
        (D.field "sessions" <| D.list WE.decode)
        (D.field "midterms" <| D.list Event.decode)
        (D.maybe <| D.field "final" Event.decode)