;; Disposal Coordination Contract
;; Coordinates hazardous material disposal processes

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u500))
(define-constant ERR_DISPOSAL_NOT_FOUND (err u501))
(define-constant ERR_INVALID_STATUS (err u502))

;; Disposal request data
(define-map disposal-requests
  { disposal-id: uint }
  {
    material-id: uint,
    requester-id: uint,
    disposal-method: (string-ascii 50),
    disposal-facility: (string-ascii 100),
    scheduled-date: uint,
    quantity: uint,
    unit: (string-ascii 10),
    special-instructions: (string-ascii 300),
    status: (string-ascii 20),
    created-at: uint,
    completed-at: (optional uint)
  }
)

;; Disposal facility certifications
(define-map disposal-facilities
  { facility-id: uint }
  {
    name: (string-ascii 100),
    license-number: (string-ascii 50),
    authorized-materials: (string-ascii 200),
    contact-info: (string-ascii 200),
    certification-expiry: uint,
    is-active: bool
  }
)

(define-data-var next-disposal-id uint u1)
(define-data-var next-facility-id uint u1)

;; Register disposal facility
(define-public (register-facility
  (name (string-ascii 100))
  (license-number (string-ascii 50))
  (authorized-materials (string-ascii 200))
  (contact-info (string-ascii 200))
  (certification-expiry uint)
)
  (let ((facility-id (var-get next-facility-id)))
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
    (map-set disposal-facilities
      { facility-id: facility-id }
      {
        name: name,
        license-number: license-number,
        authorized-materials: authorized-materials,
        contact-info: contact-info,
        certification-expiry: certification-expiry,
        is-active: true
      }
    )
    (var-set next-facility-id (+ facility-id u1))
    (ok facility-id)
  )
)

;; Create disposal request
(define-public (create-disposal-request
  (material-id uint)
  (requester-id uint)
  (disposal-method (string-ascii 50))
  (disposal-facility (string-ascii 100))
  (scheduled-date uint)
  (quantity uint)
  (unit (string-ascii 10))
  (special-instructions (string-ascii 300))
)
  (let ((disposal-id (var-get next-disposal-id)))
    (map-set disposal-requests
      { disposal-id: disposal-id }
      {
        material-id: material-id,
        requester-id: requester-id,
        disposal-method: disposal-method,
        disposal-facility: disposal-facility,
        scheduled-date: scheduled-date,
        quantity: quantity,
        unit: unit,
        special-instructions: special-instructions,
        status: "pending",
        created-at: block-height,
        completed-at: none
      }
    )
    (var-set next-disposal-id (+ disposal-id u1))
    (ok disposal-id)
  )
)

;; Update disposal status
(define-public (update-disposal-status (disposal-id uint) (new-status (string-ascii 20)))
  (match (map-get? disposal-requests { disposal-id: disposal-id })
    disposal-data
    (let ((completed-at (if (is-eq new-status "completed") (some block-height) none)))
      (map-set disposal-requests
        { disposal-id: disposal-id }
        (merge disposal-data {
          status: new-status,
          completed-at: completed-at
        })
      )
      (ok true)
    )
    ERR_DISPOSAL_NOT_FOUND
  )
)

;; Get disposal request
(define-read-only (get-disposal-request (disposal-id uint))
  (map-get? disposal-requests { disposal-id: disposal-id })
)

;; Get facility details
(define-read-only (get-facility (facility-id uint))
  (map-get? disposal-facilities { facility-id: facility-id })
)
