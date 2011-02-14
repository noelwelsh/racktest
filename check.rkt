#lang typed/racket

(define (check v1 v2)
  (unless (equal? v1 v2)
    (fail (format "~a not equal to ~a" v1 v2))))