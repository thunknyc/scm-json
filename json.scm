(define-library (json)

  ;; JSON parsing
  ;; Edwin Watkeys, Thunk NYC Corp.
  ;; <edw@poseur.com>

  (export (parse-json))
  (import (scheme base) (chibi parse))
  (begin 
    (define-grammar json
      (space ((* ,(parse-char char-whitespace?))))
      
      (number ((-> n (+ (or ,(parse-char char-numeric?)
			    #\.)))
	       (string->number (list->string n))))

      (string ((: ,(parse-char #\")
		  (-> s (* ,(parse-not-char #\")))
		  ,(parse-char #\"))
	       (list->string s)))

      (atom ((-> n ,number) n)
	    ((-> s ,string) s)
	    ("true" #t)
	    ("false" #f))
      
      (datum ((or ,atom ,array ,hash)))

      (array-el ((: "," ,space (-> el ,datum)) el))

      (array ((: "[" ,space (-> el ,datum) ,space
		 (-> els (* ,array-el)) ,space "]")
	      (apply vector el els))
	     ((: "[" ,space "]") (vector)))

      (hash-el ((: "," ,space (-> k ,string) ,space
		   ":" ,space (-> v ,datum)) (cons k v)))
      
      (hash ((: "{" ,space (-> k ,string) ,space
		":" ,space (-> v ,datum) ,space
		(-> els (* ,hash-el)) ,space "}")
	     (apply list (cons k v) els))
	    ((: "{" ,space "}") '()))
      
      (json ((: ,space (-> json ,datum) ,space) json))))

  (define (parse-json . args) (apply parse json args)))
