
;; Identity Provider Verification Contract
;; Validates and registers credential issuers

;; Data Maps
(define-map providers
  { provider-id: (string-ascii 64) }
  {
    name: (string-ascii 100),
    public-key: (buff 33),
    status: (string-ascii 20),
    registration-time: uint
  }
)

(define-map provider-admins
  { admin-address: principal }
  { provider-id: (string-ascii 64) }
)

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-unauthorized (err u100))
(define-constant err-already-registered (err u101))
(define-constant err-not-found (err u102))

;; Public Functions

;; Register a new identity provider
(define-public (register-provider (provider-id (string-ascii 64)) (name (string-ascii 100)) (public-key (buff 33)))
  (let ((existing-provider (map-get? providers { provider-id: provider-id })))
    (asserts! (is-eq tx-sender contract-owner) err-unauthorized)
    (asserts! (is-none existing-provider) err-already-registered)

    (map-set providers
      { provider-id: provider-id }
      {
        name: name,
        public-key: public-key,
        status: "pending",
        registration-time: block-height
      }
    )

    (map-set provider-admins
      { admin-address: tx-sender }
      { provider-id: provider-id }
    )

    (ok provider-id)
  )
)

;; Verify a provider (only contract owner can do this)
(define-public (verify-provider (provider-id (string-ascii 64)))
  (let ((provider (map-get? providers { provider-id: provider-id })))
    (asserts! (is-eq tx-sender contract-owner) err-unauthorized)
    (asserts! (is-some provider) err-not-found)

    (map-set providers
      { provider-id: provider-id }
      (merge (unwrap-panic provider) { status: "verified" })
    )

    (ok true)
  )
)

;; Revoke a provider's verification
(define-public (revoke-provider (provider-id (string-ascii 64)))
  (let ((provider (map-get? providers { provider-id: provider-id })))
    (asserts! (is-eq tx-sender contract-owner) err-unauthorized)
    (asserts! (is-some provider) err-not-found)

    (map-set providers
      { provider-id: provider-id }
      (merge (unwrap-panic provider) { status: "revoked" })
    )

    (ok true)
  )
)

;; Read-only functions

;; Check if a provider is verified
(define-read-only (is-provider-verified (provider-id (string-ascii 64)))
  (let ((provider (map-get? providers { provider-id: provider-id })))
    (if (is-some provider)
      (is-eq (get status (unwrap-panic provider)) "verified")
      false
    )
  )
)

;; Get provider details
(define-read-only (get-provider (provider-id (string-ascii 64)))
  (map-get? providers { provider-id: provider-id })
)
