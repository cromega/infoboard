module Home exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode exposing (Decoder, field, float, string, map5)
--import Json.Decode.Pipeline exposing (required)

-- TYPES

type alias DataPoint =
  { iconCode : String -- weather.icon
  , minTemperature : Float -- main.temp_min
  , maxTemperature : Float -- main.temp_max
  , windSpeed : Float -- wind.speed
  , rain3h : Float -- rain.3h
  , time : String -- dt
  }

type alias Forecast = List DataPoint

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
  | Success Forecast
  | Failure Http.Error

type Msg
  = GotForecast (Result Http.Error Forecast)

init : () -> (Model, Cmd Msg)
init _ =
  (Loading, loadForecast)



-- UPDATE


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    GotForecast result ->
      case result of
        Ok forecast -> (Success forecast, Cmd.none)
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
    { url = "https://api.openweathermap.org/data/2.5/forecast?q=London,uk&mode=json&units=metric&appid="
    , expect = Http.expectJson GotForecast forecastDecoder
    }


forecastDecoder : Decoder Forecast
forecastDecoder = Decode.at [ "list" ] (Decode.list dataPointDecoder)

dataPointDecoder : Decoder DataPoint
dataPointDecoder =
  Decode.map6 DataPoint
    (Decode.at [ "weather", "icon" ] Decode.string)
    (Decode.at [ "main", "temp_min" ] Decode.float)
    (Decode.at [ "main", "temp_max" ] Decode.float)
    (Decode.at [ "wind", "speed" ] Decode.float)
    (Decode.at [ "rain", "3h" ] Decode.float)
    (Decode.at [ "dt" ] Decode.string)


gifDecoder : Decoder String
gifDecoder =
  field "data" (field "image_url" string)

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

