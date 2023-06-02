module Types.RegisteredClass exposing
    (   RegisteredClass
    ,   decode
    )

import Json.Decode as D exposing (Decoder)
import Types.Class as Class exposing (Class)
import Types.Attendance as Attendance exposing (Attendance)

type alias RegisteredClass =
    {   class : Class
    ,   grade : Float
    ,   attendance : List Attendance
    }


decode : Decoder RegisteredClass
decode =
    D.map3 RegisteredClass
        (D.field "class" Class.decode)
        (D.field "grade" D.bool)
        (D.field "attendance" <| D.list Attendance.decode)