module CommonTypes exposing (..)

import Http exposing (Error)

type alias HttpResult = Result Http.Error String

newHttpResult : HttpResult
newHttpResult =
  Ok ""
