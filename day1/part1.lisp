(defvar hops (with-open-file (stream "input")
  (loop for line = (read-line stream nil 'eof)
        until (eq line 'eof)
        collecting (parse-integer line))))

(print (reduce #'+ hops))
