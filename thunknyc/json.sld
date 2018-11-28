;;> Simple JSON parsing library.

(define-library (thunknyc json)
  (export parse-json)
  (import (scheme base) (scheme char) (chibi parse))
  (include "json.scm"))
