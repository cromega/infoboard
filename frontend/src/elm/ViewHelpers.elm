module ViewHelpers exposing (..)

import Http

formatHttpResponseError : Http.Error -> String
formatHttpResponseError err =
  case err of
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