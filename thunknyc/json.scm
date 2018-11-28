(define-grammar json
  (space ((* ,(parse-char char-whitespace?))))
  
  ;;> The number parser is currently quite primitive; it reads a
  ;;> sequence of characters matching [-+0-9eE,.] and attempts to
  ;;> parse it as a Scheme number.

  (number ((-> n (+ (or ,(parse-char char-numeric?)
			#\. #\- #\+ #\e #\E)))
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

  (object ((: ,space (-> o ,datum) ,space) o)))

;;> Call the JSON parser on the \scheme{(chibi parse)} parse stream
;;> \var{source}, at index \var{index}, and return the result, or
;;> \scheme{#f} if parsing fails.

(define (parse-json source . o)
  (let ((index (if (pair? o) (car o) 0)))
    (parse object source index)))
