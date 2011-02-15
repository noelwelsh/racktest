#lang typed/racket

(require "base.rkt")

(define (check v1 v2)
  (lift
   (unless (equal? v1 v2)
     (fail (format "~a not equal to ~a" v1 v2)))))

(provide
 check)