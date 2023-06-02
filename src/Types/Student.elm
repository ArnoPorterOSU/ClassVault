module Types.Student exposing
    (   Student
    ,   decode
    ,   encode
    )


import Dict exposing (Dict)
import Json.Decode as D exposing (Decoder)
import Json.Encode as E exposing (Value)
import Types.Name as Name exposing (Name)
import Types.Address as Address exposing (Address)
import Types.RegisteredClass as RC exposing (RegisteredClass)


-- The Student datatype, consisting of the following fields:
-- name: The student's name, as a Name record
-- id: The student's identifier
-- email: The student's email address
-- gpa: The student's GPA, represented as a float
-- address: The student's address, as an Address record
-- classes: A dictionary keyed by class names, representing the student's registered classes
type alias Student =
    {   name : Name
    ,   id : Int
    ,   email : String
    ,   gpa : Float
    ,   address : Address
    ,   classes : Dict String RegisteredClass
    }


-- JSON encoder for a student
encode : Student -> Value
encode student =
    E.object
        [   ("name", Name.encode student.name)
        ,   ("id", E.int student.id)
        ,   ("email", E.string student.email)
        ,   ("gpa", E.float student.gpa)
        ,   ("address", Address.encode student.address)
        ,   ("classes", E.dict identity RC.encode student.classes)
        ]

-- JSON decoder for a student
decode : Decoder Student
decode =
    D.map6 Student
        (D.field "name" Name.decode)
        (D.field "id" D.int)
        (D.field "email" D.string)
        (D.field "gpa" D.float)
        (D.field "address" Address.decode)
        (D.field "classes" <| D.dict RC.decode)