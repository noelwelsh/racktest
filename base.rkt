#lang typed/racket

;; Base Types

(define-type (Dict Key Value)
  (U (HashTable Key Value) (Listof (Pair Key Value))))

(define-type Name (Listof Symbol))
(define-type Info (Dict Symbol Any))


;; Test Results

(struct: Test-Info ([name : Name] [info : Info] [result: Test-Result]))

(define-type Test-Result (U success failure))

(struct: Success ())
;; Skipped and Pending are a subtype of Success -- report it if you support it
(struct: Skipped Success ())
(struct: Pending Success ())

(struct: Failure ([exn : (U exn #f)]))
;; An error is a failure that occurred outside a testing construct -- report it if you support it
(struct: Error Failure ())


;; Test Listener

(define-type Test-Listener (Test-Info -> Void))

(: default-test-listener Test-Listener)
(define (default-test-listener result)
  (when (failure? result)
    (raise (result-exn result))))

(: current-test-listener (Parameterof Test-Listener))
(define current-test-listener (make-parameter default-test-listener))

;; Test Names

(: current-test-name (Parameterof Name))
(define current-test-name (make-parameter null))



;; Test Info

(: current-test-info (Parameterof (Listof Info)))
(define current-test-info (make-parameter null))



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

 current-test-info)