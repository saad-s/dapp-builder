(impl-trait .sip-010-ft-trait.sip-010-trait)

;; constants
(define-constant contract-owner tx-sender)

;; errors 
(define-constant err-invalid-caller (err u100))
(define-constant err-invalid-call (err u110))
(define-constant err-unauthorized-caller (err u99))

;; data vars
(define-data-var token-owner principal tx-sender)
(define-data-var token-name (string-ascii 32) "sip10-token")
(define-data-var token-symbol (string-ascii 32) "FT")
(define-data-var token-decimals uint u0)
(define-data-var token-balance uint u0)
(define-data-var total-supply uint u10000000)
(define-data-var token-uri (optional (string-utf8 256)) none)

;; define token 
(define-fungible-token sip10-token)

;; token owner 
(define-read-only (get-owner) (ok (var-get token-owner)))

(define-public (set-token-owner (owner principal))
    (begin
        (asserts! (is-eq tx-sender contract-owner) err-unauthorized-caller)
        (ok (var-set token-owner owner))
    )
)

;; verify permissions
(define-private (can-make-changes (user principal)) 
    (or (is-eq user contract-owner) (is-eq user (var-get token-owner)))
)

;; token name 
(define-read-only (get-name) (ok (var-get token-name)))

(define-public (set-name (name (string-ascii 32))) 
    (begin
        (asserts! (can-make-changes tx-sender) err-unauthorized-caller)
        (ok (var-set token-name name))
    )
)

;; token symbol 
(define-read-only (get-symbol) (ok (var-get token-symbol)))

(define-public (set-symbol (symbol (string-ascii 32))) 
    (begin
        (asserts! (can-make-changes tx-sender) err-unauthorized-caller)
        (ok (var-set token-symbol symbol))
    )
)

;; token decimals 
(define-read-only (get-decimals) (ok (var-get token-decimals)))

;; TODO: add limit check here <0-6>, but what are the effects ??
(define-public (set-decimals (decimals uint)) 
    (begin
        (asserts! (can-make-changes tx-sender) err-unauthorized-caller)
        (ok (var-set token-decimals decimals))
    )
)

;; token balance 
;; TODO: token name check !!
(define-read-only (get-balance (user principal)) 
    (ok (ft-get-balance sip10-token user))
)

;; token supply
;; TODO: check if we can set supply after init ??
;; TODO: token name check !!
(define-read-only (get-total-supply) (ok (ft-get-supply sip10-token)))

;; token uri 
(define-read-only (get-token-uri) (ok (var-get token-uri)))

(define-public (set-token-uri (uri (optional (string-utf8 256)))) 
    (begin
        (asserts! (can-make-changes tx-sender) err-unauthorized-caller)
        (ok (var-set token-uri uri))
    )
)

;; token transfer 
(define-public (transfer (amount uint) (sender principal) (receiver principal) (memo (optional (buff 34)))) 
    (begin 
        (asserts! (is-eq tx-sender tx-sender) err-invalid-caller)
        (ft-transfer? sip10-token amount sender receiver)
    )
)
