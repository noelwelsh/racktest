#lang typed/racket

;; Base Types

(define-type (Dict Key Value)
  (U (HashTable Key Value) (Listof (Pair Key Value))))

(define-type Name (Listof Symbol))
(define-type Info (Dict Symbol Any))

;; Test Results

(define-type Test-Result (U success skipped pending exn:fail:test exn:fail))

(struct: success ([name : Name]))
(struct: skipped ([name : Name]))
(struct: pending ([name : Name]))
(struct: exn:fail:test exn:fail ([name : Name] [info : (Listof Info)]))

;; Test Listener

(define-type Test-Listener (Test-Result -> Void))

(: default-test-listener Test-Listener)
(define (default-test-listener result)
  (when (exn:fail:test? result)
    (raise result)))

(: current-test-listener (Parameterof Test-Listener))
(define current-test-listener (make-parameter default-test-listener))

;; Test Names

(: current-test-name (Parameterof Name))
(define current-test-name (make-parameter null))

(define-syntax-rule (with-test-name name expr ...)
  (parameterize ([current-test-name (cons (current-test-name))])
    expr ...))

;; Test Info

(: current-test-info (Parameterof (Listof Info)))
(define current-test-info (make-parameter null))

(define-syntax-rule (with-test-info ([key value] ...) expr ...)
  (parameterize ([current-test-info (cons (list (cons key value) ...)
                                          (current-test-info))])
    expr ...))

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


(provide
 Name
 Info
 
 Test-Result
 success
 skipped
 pending
 exn:fail:test

 default-test-listener
 current-test-listener

 current-test-name
 with-test-name

 current-test-info
 with-test-info

 pass
 fail
 lift)