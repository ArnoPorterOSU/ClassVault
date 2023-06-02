module Types.Attendance exposing
    (   Attendance
    ,   decode
    )

import Json.Decode as D exposing (Decoder)
import Time

type alias Attendance =
    {   date : Time.Posix
    ,   present : Bool
    ,   comment : String
    }

decode : Decoder Attendance
decode =
    D.map3 Attendance
        (D.map Time.millisToPosix <| D.field "date" int)
        (field "present" D.bool)
        (field "comment" D.string)