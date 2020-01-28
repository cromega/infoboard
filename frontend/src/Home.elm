module Home exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode exposing (Decoder, field, float, string, map4)
--import Json.Decode.Pipeline exposing (required)

-- TYPES

type alias Forecast =
  { time : String
  , temp_min : String
  , temp_max : String
  , icon : String
  }

type alias Forecasts = List Forecast

-- MAIN


main =
  Browser.element
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }




-- MODEL


type Model
  = Loading
  | Success Forecasts
  | Failure Http.Error

type Msg
  = GotForecast (Result Http.Error Forecasts)

init : () -> (Model, Cmd Msg)
init _ =
  (Loading, loadForecast)



-- UPDATE


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    GotForecast result ->
      case result of
        Ok forecasts -> (Success forecasts, Cmd.none)
        Err err -> (Failure err, Cmd.none)





-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- VIEW


view : Model -> Html Msg
view model =
  case model of
    Loading -> div [] [ h1 [] [ text "Loading" ] ]
    Success forecast -> text "forecast yeah"
    Failure err ->
      h1 [] [ text (buildErrorMessage err) ]



-- HTTP


loadForecast : Cmd Msg
loadForecast =
  Http.get
    { url = "/weather"
    , expect = Http.expectJson GotForecast forecastsDecoder
    }


forecastsDecoder : Decoder (List Forecast)
forecastsDecoder =
  Decode.list forecastDecoder

forecastDecoder : Decoder Forecast
forecastDecoder =
  Decode.map4 Forecast
    (Decode.at [ "time" ] Decode.string)
    (Decode.at [ "temp_min" ] Decode.string)
    (Decode.at [ "temp_max" ] Decode.string)
    (Decode.at [ "icon" ] Decode.string)




buildErrorMessage : Http.Error -> String
buildErrorMessage httpError =
  case httpError of
    Http.BadUrl message ->
      message

    Http.Timeout ->
      "Server is taking too long to respond. Please try again later."

    Http.NetworkError ->
      "Unable to reach server."

    Http.BadStatus statusCode ->
      "Request failed with status code: " ++ String.fromInt statusCode

    Http.BadBody message ->
      message

