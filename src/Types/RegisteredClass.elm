module Types.RegisteredClass exposing
    (   RegisteredClass
    ,   decode
    ,   encode
    )


import Json.Decode as D exposing (Decoder)
import Json.Encode as E exposing (Value)
import Types.Class as Class exposing (Class)
import Types.Attendance as Attendance exposing (Attendance)


-- The RegisteredClass record consists of the following fields:
-- class: A Class object, representing the underlying class
-- grade: A Float representing the grade in the class
-- attendance: A list of Attendance records
type alias RegisteredClass =
    {   class : Class
    ,   grade : Float
    ,   attendance : List Attendance
    }


-- JSON encoder for a RegisteredClass object
encode : RegisteredClass -> Value
encode registeredClass =
    E.object
        [   ("class", Class.encode registeredClass.class)
        ,   ("grade", E.float registeredClass.grade)
        ,   ("attendance", E.list Attendance.encode registeredClass.attendance)
        ]


-- JSON decoder for a RegisteredClass object
decode : Decoder RegisteredClass
decode =
    D.map3 RegisteredClass
        (D.field "class" Class.decode)
        (D.field "grade" D.float)
        (D.field "attendance" <| D.list Attendance.decode)