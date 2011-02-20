#lang typed/racket

(require "base.rkt")

;; Utilities

(define (pass)
  (success (current-test-name)))

(: fail (case-lambda (-> Nothing) (String -> Nothing)))
(define fail
  (case-lambda:
    [()
     (fail "Test Failed")]
    [([msg : String])
     (raise
      (exn:fail:test msg (current-continuation-marks) (current-test-name) (current-test-info)))]))

(define-syntax-rule (lift expr ...)
  (with-handlers ([exn:fail? (current-test-listener)])
    expr ...
    (pass)))

(define-syntax-rule (with-test-name name expr ...)
  (parameterize ([current-test-name (cons (current-test-name))])
    expr ...))

(define-syntax-rule (with-test-info ([key value] ...) expr ...)
  (parameterize ([current-test-info (cons (list (cons key value) ...)
                                          (current-test-info))])
    expr ...))


(provide
 pass
 fail
 lift

 with-test-name
 with-test-info)