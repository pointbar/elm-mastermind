module MasterMind exposing (..)

import Html exposing (Html, text, div, ul, li)
import Html.Attributes exposing (class)
import Html.App exposing (program)
import Html.Events exposing (onClick)
import List exposing (..)
import Random


-- Main


main : Program Never
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }



-- Init


type alias Model =
    { previousTries : List ( Choice, Evaluation )
    , currentTry : List Color
    , solution : Choice
    , position : Int
    , round : Int
    }


type alias Choice =
    List Color


type alias Evaluation =
    List Color


type Color
    = Red
    | Yellow
    | Blue
    | Green
    | Orange
    | Purple
    | Black
    | White
    | Nothing


init : ( Model, Cmd Msg )
init =
    ( { previousTries = []
      , currentTry = []
      , solution = []
      , round = 0
      , position = 1
      }
    , Random.generate InitSolution <|
        Random.list 4 <|
            Random.int 0 7
    )


colorChoices : List Color
colorChoices =
    [ Red, Yellow, Blue, Green, Orange, Purple, Black, White ]


tries : Model -> List ( Choice, Evaluation )
tries model =
    model.previousTries
        ++ [ ( model.currentTry ++ (repeat (5 - model.position) Nothing), repeat 4 Nothing ) ]
        ++ repeat (10 - model.round) ( repeat 4 Nothing, repeat 4 Nothing )
        |> reverse



-- Update


type Msg
    = InitSolution (List Int)
    | SelectColor Color


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        InitSolution random ->
            ( { model
                | solution =
                    map
                        (\number ->
                            colorChoices
                                |> drop number
                                |> head
                                |> Maybe.withDefault Nothing
                        )
                        random
              }
            , Cmd.none
            )

        SelectColor color ->
            let
                currentTry =
                    model.currentTry ++ [ color ]
            in
                case (model.position) of
                    1 ->
                        ( { model
                            | currentTry = currentTry
                            , position = 2
                          }
                        , Cmd.none
                        )

                    4 ->
                        let
                            evaluation =
                                let
                                    rightPlace : Int
                                    rightPlace =
                                        filter (\index -> (drop index model.solution |> head) == (drop index currentTry |> head)) [0..3]
                                            |> length
                                in
                                    repeat rightPlace Black
                        in
                            ( { model
                                | currentTry = []
                                , previousTries =
                                    model.previousTries
                                        ++ [ ( currentTry, evaluation ) ]
                                , round = model.round + 1
                                , position = 1
                              }
                            , Cmd.none
                            )

                    _ ->
                        ( { model
                            | currentTry = currentTry
                            , position = model.position + 1
                          }
                        , Cmd.none
                        )



-- View


view : Model -> Html Msg
view model =
    let
        renderProposition : List ( Choice, Evaluation ) -> List (Html Msg)
        renderProposition tries =
            map
                (\try ->
                    ul [ class "round" ]
                        [ ul [ class "evaluation" ] (renderSequence (snd try))
                        , ul [ class "choice" ] (renderSequence (fst try))
                        ]
                )
                tries

        renderSequence : List Color -> List (Html Msg)
        renderSequence colors =
            map
                (\color ->
                    li [ class (toString color) ] [ text "•" ]
                )
                colors

        renderColorChoices : List Color -> List (Html Msg)
        renderColorChoices colors =
            map
                (\color ->
                    li [ class (toString color), onClick (SelectColor color) ] [ text "•" ]
                )
                colors
    in
        div [ class "container" ]
            [ ul [ class "solution" ] (renderSequence model.solution)
            , ul [ class "propositions" ] (renderProposition (tries model))
            , ul [ class "color-choices" ] (renderColorChoices colorChoices)
            ]
