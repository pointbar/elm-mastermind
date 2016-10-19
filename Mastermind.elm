module MasterMind exposing (..)

import Html exposing (Html, text, div, ul, li)
import Html.Attributes exposing (class)
import Html.App exposing (program)
import List exposing (map, member, take, drop, repeat)


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
    { tries : List ( Choice, Evaluation ) }


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
    ( { tries = repeat 10 ( repeat 4 Nothing, repeat 4 Nothing ) }, Cmd.none )


colorChoices : List Color
colorChoices =
    [ Red, Yellow, Blue, Green, Orange, Purple, Black, White ]



-- Update


type Msg
    = None


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )



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
        renderSequence :  List Color -> List (Html Msg)
        renderSequence colors =
            map
                (\color ->
                    li [ class (toString color) ] [ text "•" ]
                )
                colors
    in
        div [ class "container" ]
            [ ul [ class "solution" ]
                [ li [] [ text "•" ]
                , li [] [ text "•" ]
                , li [] [ text "•" ]
                , li [] [ text "•" ]
                ]
            , ul [ class "propositions" ] (renderProposition model.tries)
            , ul [ class "choice" ] (renderSequence colorChoices)
            ]
