;; ────────────────────────────────────────
;; TaskBounty v1.0.0
;; Author: solidworkssa
;; License: MIT
;; ────────────────────────────────────────

(define-constant VERSION "1.0.0")

;; Error codes
(define-constant ERR-NOT-AUTHORIZED (err u401))
(define-constant ERR-NOT-FOUND (err u404))
(define-constant ERR-ALREADY-EXISTS (err u409))
(define-constant ERR-INVALID-INPUT (err u422))

;; TaskBounty Clarity Contract
;; Decentralized task marketplace with crypto bounties.


(define-map bounties
    uint
    {
        issuer: principal,
        amount: uint,
        claimed: bool,
        claimant: (optional principal)
    }
)
(define-data-var bounty-nonce uint u0)

(define-public (create-bounty (amount uint))
    (let ((id (var-get bounty-nonce)))
        (try! (stx-transfer? amount contract-caller (as-contract contract-caller)))
        (map-set bounties id {
            issuer: contract-caller,
            amount: amount,
            claimed: false,
            claimant: none
        })
        (var-set bounty-nonce (+ id u1))
        (ok id)
    )
)

(define-public (claim-bounty (id uint) (claimant principal))
    (let ((b (unwrap! (map-get? bounties id) (err u404))))
        (asserts! (is-eq contract-caller (get issuer b)) (err u401))
        (asserts! (not (get claimed b)) (err u403))
        (try! (as-contract (stx-transfer? (get amount b) contract-caller claimant)))
        (map-set bounties id (merge b {claimed: true, claimant: (some claimant)}))
        (ok true)
    )
)

