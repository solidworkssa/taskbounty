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
        (try! (stx-transfer? amount tx-sender (as-contract tx-sender)))
        (map-set bounties id {
            issuer: tx-sender,
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
        (asserts! (is-eq tx-sender (get issuer b)) (err u401))
        (asserts! (not (get claimed b)) (err u403))
        (try! (as-contract (stx-transfer? (get amount b) tx-sender claimant)))
        (map-set bounties id (merge b {claimed: true, claimant: (some claimant)}))
        (ok true)
    )
)

