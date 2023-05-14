module Main exposing (..)

import Browser
import Element as El exposing (Element, Color, Attribute)
import Element.Background as Bg
import Element.Input as Inp
import Html exposing (Html)
import Url exposing (Url)
import Types exposing (Student)


-- MAIN

main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }


-- Flags

type alias Flags =
    { user : String
    , studentdata : List Student
    }


-- INIT

-- Model