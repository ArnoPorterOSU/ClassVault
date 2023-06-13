module Page.Stats exposing
    ( Model
    , Msg(..)
    , init
    , update
    , view
    )


import Dict exposing (Dict)
import Element as El exposing (Element)
import Element.Input as Inp
import Json.Encode as E exposing (Value)
import StyleVars
import Types.Student exposing (Student)
import Util exposing (group, filterJust)


type alias Model =
    { chart : Maybe String
    , data : List Student
    }


type Msg
    = GenerateChart Value
    | UpdateChart String


init : List Student -> Model
init students =
    { chart = Nothing
    , data = students
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        UpdateChart url ->
            { model
            | chart = Just url
            }
        
        _ ->
            model


view : Model -> Element Msg
view model =
    El.column [El.spacing StyleVars.standardSpacing]
        [ El.row []
            [ freqButton model.data "First Name" (.name >> .first)
            , freqButton model.data "State" (.address >> .state)
            ]
        , case model.chart of
            Just url ->
                El.image [] 
                    { src = url
                    , description = "A graph"
                    }
        
            _ ->
                El.none
        ]


freqButton : List Student -> String -> (Student -> String) -> Element Msg
freqButton students label accessor =
    Inp.button [El.padding StyleVars.standardPadding]
        { onPress =
            students |>
            Just << GenerateChart
            << generateChartRequestData
            << generateBarChartData
            << frequencies accessor
        , label = El.text label
        }


frequencies : (Student -> String) -> List Student -> Dict String Int
frequencies accessor =
    List.map accessor
    >> List.sort
    >> group
    >> List.map (\xs ->
        let
            len = List.length xs
        in
            xs
            |> List.head
            >> Maybe.map (\x ->
                (x, len)
            )
        )
    >> filterJust
    >> Dict.fromList


generateBarChartData : Dict String Int -> Value
generateBarChartData freqMapping =
    E.object
        [   ( "type", E.string "bar" )
        ,   ( "data"
            , E.object
                [ ( "labels", freqMapping |> Dict.keys >> E.list E.string )
                , ( "datasets"
                  , freqMapping
                        |> List.singleton
                        >> E.list (\mapping ->
                            E.object
                                [ ( "label", E.string "Frequency" ) 
                                , ( "data", mapping |> Dict.values >> E.list E.int)
                                ]
                            )
                  )
                ]
            )
        ]

    
generateChartRequestData : Value -> Value
generateChartRequestData chart =
    E.object
        [ ( "format", E.string "png" ) 
        , ( "version", E.string "4" )
        , ( "chart", chart )
        ]