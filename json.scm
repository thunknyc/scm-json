(import (chibi parse))

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
	       ":" ,space (-> v ,datum)) (list k v)))
  
  (hash ((: "{" ,space (-> k ,string) ,space
	    ":" ,space (-> v ,datum) ,space
	    (-> els (* ,hash-el)) ,space "}")
	 (apply list (list k v) els))
	((: "{" ,space "}") (list))))

