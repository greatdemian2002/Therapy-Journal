;; Blockchain Therapy Journal Contract
;; Simple contract for immutable journal entries with optional therapist verification

;; Constants
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-ENTRY-NOT-FOUND (err u101))
(define-constant ERR-ALREADY-VERIFIED (err u102))
(define-constant ERR-EMPTY-CONTENT (err u103))
(define-constant ERR-INVALID-PRINCIPAL (err u104))
(define-constant ERR-INVALID-ENTRY-ID (err u105))

;; Data variables
(define-data-var next-entry-id uint u1)

;; Data maps
(define-map journal-entries
  { entry-id: uint }
  {
    author: principal,
    content: (string-utf8 1000),
    timestamp: uint,
    is-verified: bool,
    verified-by: (optional principal),
    verification-timestamp: (optional uint)
  }
)

(define-map therapist-registry
  { therapist: principal }
  { is-active: bool }
)

;; Read-only functions

(define-read-only (get-entry (entry-id uint))
  (map-get? journal-entries { entry-id: entry-id })
)

(define-read-only (get-next-entry-id)
  (var-get next-entry-id)
)

(define-read-only (is-therapist (therapist principal))
  (default-to false (get is-active (map-get? therapist-registry { therapist: therapist })))
)

;; Public functions

(define-public (create-entry (content (string-utf8 1000)))
  (let
    ((entry-id (var-get next-entry-id))
     (sender tx-sender))
    (asserts! (> (len content) u0) ERR-EMPTY-CONTENT)
    (map-set journal-entries
      { entry-id: entry-id }
      {
        author: sender,
        content: content,
        timestamp: block-height,
        is-verified: false,
        verified-by: none,
        verification-timestamp: none
      }
    )
    (var-set next-entry-id (+ entry-id u1))
    (ok entry-id)
  )
)

(define-public (register-therapist (therapist principal))
  (let
    ((sender tx-sender)
     (validated-therapist therapist))
    (asserts! (not (is-eq validated-therapist sender)) ERR-INVALID-PRINCIPAL)
    (map-set therapist-registry
      { therapist: validated-therapist }
      { is-active: true }
    )
    (ok true)
  )
)

(define-public (deactivate-therapist (therapist principal))
  (let
    ((sender tx-sender)
     (validated-therapist therapist))
    (asserts! (not (is-eq validated-therapist sender)) ERR-INVALID-PRINCIPAL)
    (map-set therapist-registry
      { therapist: validated-therapist }
      { is-active: false }
    )
    (ok true)
  )
)

(define-public (verify-entry (entry-id uint))
  (let
    ((validated-entry-id entry-id)
     (entry (unwrap! (map-get? journal-entries { entry-id: validated-entry-id }) ERR-ENTRY-NOT-FOUND))
     (sender tx-sender))
    (asserts! (> validated-entry-id u0) ERR-INVALID-ENTRY-ID)
    (asserts! (is-therapist sender) ERR-NOT-AUTHORIZED)
    (asserts! (not (get is-verified entry)) ERR-ALREADY-VERIFIED)
    (map-set journal-entries
      { entry-id: validated-entry-id }
      (merge entry {
        is-verified: true,
        verified-by: (some sender),
        verification-timestamp: (some block-height)
      })
    )
    (ok true)
  )
)