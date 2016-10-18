module MasterMind exposing (..)

import Html exposing (Html, text, div, ul, li)
import Html.Attributes exposing (class)
import Html.App exposing (program)
import List exposing (map, member, take, drop)


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
    Int


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
    ( 1, Cmd.none )


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
        renderChoice : List Color -> List (Html Msg)
        renderChoice colors =
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
            , ul [ class "choice" ] (renderChoice colorChoices)
            ]
