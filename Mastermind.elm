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
    { previousTries : List Try
    , currentTry : Sequence
    , solution : Sequence
    , position : Int
    , round : Int
    , isGameOver : Bool
    }


type alias Try =
    ( Sequence, Evaluation )


type alias Sequence =
    List (Maybe Color)


type alias Evaluation =
    List (Maybe Color)


type Color
    = Red
    | Yellow
    | Blue
    | Green
    | Orange
    | Purple
    | Black
    | White


init : ( Model, Cmd Msg )
init =
    ( { previousTries = []
      , currentTry = []
      , solution = []
      , round = 0
      , position = 1
      , isGameOver = False
      }
    , Random.generate InitSolution <|
        Random.list 4 <|
            Random.int 0 7
    )


colorChoices : List Color
colorChoices =
    [ Red
    , Yellow
    , Blue
    , Green
    , Orange
    , Purple
    , Black
    , White
    ]



-- Update


type Msg
    = InitSolution (List Int)
    | SelectColor Color


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        InitSolution random ->
            ( { model | solution = numbersToColors random }, Cmd.none )

        SelectColor color ->
            let
                currentTry =
                    model.currentTry ++ [ Just color ]
            in
                case (model.position) of
                    4 ->
                        let
                            previousTries =
                                storeCurrentWithEval model currentTry

                            isGameOver =
                                snd (Maybe.withDefault ( [], [] ) (head previousTries)) == repeat 4 (Just Black)
                        in
                            ( { model
                                | currentTry = []
                                , previousTries = previousTries
                                , round = model.round + 1
                                , position = 1
                                , isGameOver = isGameOver
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


numbersToColors : List Int -> Sequence
numbersToColors random =
    map
        (\number ->
            colorChoices
                |> drop number
                |> head
        )
        random


evalPosition : Sequence -> Sequence -> Evaluation
evalPosition currentTry solution =
    let
        rightPlace : Int
        rightPlace =
            filter
                (\index ->
                    (drop index solution |> head) == (drop index currentTry |> head)
                )
                [0..3]
                |> length

        wrongPlace : Int
        wrongPlace =
            (filter (\color -> member color solution) currentTry
                |> length
            )
                - rightPlace
    in
        repeat rightPlace (Just Black)
            ++ repeat wrongPlace (Just White)
            ++ repeat (4 - (rightPlace + wrongPlace)) Nothing


storeCurrentWithEval : Model -> Sequence -> List Try
storeCurrentWithEval model currentTry =
    [ ( currentTry, evalPosition currentTry model.solution ) ]
        ++ model.previousTries



-- View


tries : Model -> List Try
tries model =
    repeat (10 - model.round) ( repeat 4 Nothing, repeat 4 Nothing )
        ++ [ ( (model.currentTry ++ (repeat (5 - model.position) Nothing)), repeat 4 Nothing ) ]
        ++ model.previousTries


view : Model -> Html Msg
view model =
    let
        renderSolution : Sequence -> Bool -> Html Msg
        renderSolution solution isGameOver =
            case isGameOver of
                True ->
                    ul [ class "solution" ] (renderSequence solution)

                False ->
                    ul [ class "solution" ] (renderSequence (repeat 4 Nothing))

        renderProposition : List Try -> List (Html Msg)
        renderProposition tries =
            map
                (\try ->
                    ul [ class "round" ]
                        [ ul [ class "evaluation" ] (renderSequence (snd try))
                        , ul [ class "choice" ] (renderSequence (fst try))
                        ]
                )
                tries

        renderSequence : Sequence -> List (Html Msg)
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
            [ (renderSolution model.solution model.isGameOver)
            , ul [ class "propositions" ] (renderProposition (tries model))
            , ul [ class "color-choices" ] (renderColorChoices colorChoices)
            ]
