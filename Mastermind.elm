module MasterMind exposing (..)

import Html exposing (Html, text, div, ul, li)
import Html.Attributes exposing (class)
import Html.App exposing (program)
import Html.Events exposing (onClick)
import List exposing (map, member, take, drop, repeat, head)
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
    { tries : List ( Choice, Evaluation )
    , solution : Choice
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
    ( { tries = repeat 10 ( repeat 4 Nothing, repeat 4 Nothing )
      , solution = []
      }
    , Random.generate InitSolution <|
        Random.list 4 <|
            Random.int 0 7
    )


colorChoices : List Color
colorChoices =
    [ Red, Yellow, Blue, Green, Orange, Purple, Black, White ]



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
            Debug.log "Tuple ( model, Cmd.none )" ( model, Cmd.none )



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
            , ul [ class "propositions" ] (renderProposition model.tries)
            , ul [ class "color-choices" ] (renderColorChoices colorChoices)
            ]
