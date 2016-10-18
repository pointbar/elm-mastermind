module MasterMind exposing (..)

import Html exposing (Html, text, div, ul, li)
import Html.Attributes exposing (class)
import Html.App exposing (program)


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


init : ( Model, Cmd Msg )
init =
    ( 1, Cmd.none )



-- Update


type Msg
    = None


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )



-- View


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ ul [ class "solution" ]
            [ li [] [ text "•" ]
            , li [] [ text "•" ]
            , li [] [ text "•" ]
            , li [] [ text "•" ]
            ]
        ]
