module Types.Attendance exposing
    (   Attendance
    ,   decode
    )


import Json.Decode as D exposing (Decoder)
import Time


-- Attendance record, consisting of:
-- date: the Posix time that the class happened
-- present: whether or not the student was present
-- comment: comments on the student's behavior
type alias Attendance =
    {   date : Time.Posix
    ,   present : Bool
    ,   comment : String
    }


-- JSON decoder for an Attendance object
decode : Decoder Attendance
decode =
    D.map3 Attendance
        (D.map Time.millisToPosix <| D.field "date" D.int)
        (D.field "present" D.bool)
        (D.field "comment" D.string)