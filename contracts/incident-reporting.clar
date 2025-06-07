;; Incident Reporting Contract
;; c

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u400))
(define-constant ERR_INCIDENT_NOT_FOUND (err u401))

;; Incident data structure
(define-map incidents
  { incident-id: uint }
  {
    material-id: uint,
    reporter-id: uint,
    incident-type: (string-ascii 30),
    severity-level: uint,
    location: (string-ascii 100),
    description: (string-ascii 500),
    immediate-actions: (string-ascii 500),
    reported-at: uint,
    status: (string-ascii 20),
    resolved-at: (optional uint)
  }
)

;; Incident follow-up actions
(define-map incident-actions
  { incident-id: uint, action-id: uint }
  {
    action-description: (string-ascii 300),
    responsible-handler: uint,
    due-date: uint,
    completed-at: (optional uint),
    status: (string-ascii 20)
  }
)

(define-data-var next-incident-id uint u1)
(define-map incident-action-counter { incident-id: uint } { next-action-id: uint })

;; Report new incident
(define-public (report-incident
  (material-id uint)
  (reporter-id uint)
  (incident-type (string-ascii 30))
  (severity-level uint)
  (location (string-ascii 100))
  (description (string-ascii 500))
  (immediate-actions (string-ascii 500))
)
  (let ((incident-id (var-get next-incident-id)))
    (map-set incidents
      { incident-id: incident-id }
      {
        material-id: material-id,
        reporter-id: reporter-id,
        incident-type: incident-type,
        severity-level: severity-level,
        location: location,
        description: description,
        immediate-actions: immediate-actions,
        reported-at: block-height,
        status: "open",
        resolved-at: none
      }
    )
    (map-set incident-action-counter { incident-id: incident-id } { next-action-id: u1 })
    (var-set next-incident-id (+ incident-id u1))
    (ok incident-id)
  )
)

;; Add follow-up action
(define-public (add-follow-up-action
  (incident-id uint)
  (action-description (string-ascii 300))
  (responsible-handler uint)
  (due-date uint)
)
  (match (map-get? incidents { incident-id: incident-id })
    incident-data
    (let (
      (counter-data (default-to { next-action-id: u1 } (map-get? incident-action-counter { incident-id: incident-id })))
      (action-id (get next-action-id counter-data))
    )
      (map-set incident-actions
        { incident-id: incident-id, action-id: action-id }
        {
          action-description: action-description,
          responsible-handler: responsible-handler,
          due-date: due-date,
          completed-at: none,
          status: "pending"
        }
      )
      (map-set incident-action-counter
        { incident-id: incident-id }
        { next-action-id: (+ action-id u1) }
      )
      (ok action-id)
    )
    ERR_INCIDENT_NOT_FOUND
  )
)

;; Resolve incident
(define-public (resolve-incident (incident-id uint))
  (match (map-get? incidents { incident-id: incident-id })
    incident-data
    (begin
      (map-set incidents
        { incident-id: incident-id }
        (merge incident-data {
          status: "resolved",
          resolved-at: (some block-height)
        })
      )
      (ok true)
    )
    ERR_INCIDENT_NOT_FOUND
  )
)

;; Get incident details
(define-read-only (get-incident (incident-id uint))
  (map-get? incidents { incident-id: incident-id })
)

;; Get incident action
(define-read-only (get-incident-action (incident-id uint) (action-id uint))
  (map-get? incident-actions { incident-id: incident-id, action-id: action-id })
)
