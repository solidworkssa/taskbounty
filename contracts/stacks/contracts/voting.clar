;; TaskBounty - Bounty Board (Clarity v4)

(define-data-var bounty-nonce uint u0)

(define-map bounties
    uint
    {
        creator: principal,
        title: (string-utf8 128),
        description: (string-utf8 512),
        reward: uint,
        claimant: (optional principal),
        claimed: bool,
        completed: bool,
        paid: bool
    }
)

(define-public (create-bounty (title (string-utf8 128)) (description (string-utf8 512)) (reward uint))
    (let
        (
            (bounty-id (var-get bounty-nonce))
        )
        (try! (stx-transfer? reward tx-sender (as-contract tx-sender)))
        
        (map-set bounties bounty-id {
            creator: tx-sender,
            title: title,
            description: description,
            reward: reward,
            claimant: none,
            claimed: false,
            completed: false,
            paid: false
        })
        
        (var-set bounty-nonce (+ bounty-id u1))
        (ok bounty-id)
    )
)

(define-public (claim-bounty (bounty-id uint))
    (let
        (
            (bounty (unwrap! (map-get? bounties bounty-id) (err u100)))
        )
        (asserts! (not (get claimed bounty)) (err u101))
        
        (map-set bounties bounty-id (merge bounty {
            claimant: (some tx-sender),
            claimed: true
        }))
        (ok true)
    )
)

(define-public (complete-bounty (bounty-id uint))
    (let
        (
            (bounty (unwrap! (map-get? bounties bounty-id) (err u100)))
            (claimant (unwrap! (get claimant bounty) (err u102)))
        )
        (asserts! (is-eq tx-sender (get creator bounty)) (err u103))
        (asserts! (and (get claimed bounty) (not (get completed bounty))) (err u104))
        
        (try! (as-contract (stx-transfer? (get reward bounty) tx-sender claimant)))
        (map-set bounties bounty-id (merge bounty {completed: true, paid: true}))
        (ok true)
    )
)

(define-read-only (get-bounty (bounty-id uint))
    (ok (map-get? bounties bounty-id))
)
