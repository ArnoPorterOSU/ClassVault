module Types.Student exposing
    (   Student
    ,   decode
    )

import Dict exposing (Dict)
import Json.Decode as D exposing (Decoder)
import Types.Name as Name exposing (Name)
import Types.Address as Address exposing (Address)
import Types.RegisteredClass as RC exposing (RegisteredClass)


-- The Student datatype
type alias Student =
    {   name : Name
    ,   id : Int
    ,   email : String
    ,   gpa : Float
    ,   address : Address
    ,   classes : Dict String RegisteredClass
    }

decode : Decoder Student
decode =
    D.map6 Student
        (D.field "name" Name.decode)
        (D.field "id" D.int)
        (D.field "email" D.string)
        (D.field "gpa" D.float)
        (D.field "address" Address.decode)
        (D.field "classes" <| D.dict RC.decode)