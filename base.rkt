#lang typed/racket

(define-type Name (Option String))

;; Test Results

(define-type Test-Result (U success skipped pending exn:fail:test))

(struct: success ([name : Name]))
(struct: skipped ([name : Name]))
(struct: pending ([name : Name]))
(struct: exn:fail:test exn:fail ([name : Name] [info : (HashTable Symbol Any)]))

;; Test Listener

(define-type Test-Listener (Test-Result -> Void))

(: default-test-listener Test-Listener)
(define (default-test-listener result)
  (when (exn:fail:test? result)
    (raise result)))

(: current-test-listener (Parameterof Test-Listener))
(define current-test-listener (make-parameter default-test-listener))

;; Utilities

(define (fail [msg "Test failed"])
  (exn:fail:test #f (hash) msg (current-continuation-marks)))

(provide
 Name
 
 Test-Result
 success
 skipped
 pending
 exn:fail:test

 default-test-listener
 current-test-listener

 fail)