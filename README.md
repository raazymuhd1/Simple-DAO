### DAO
- [https://docs.openzeppelin.com/contracts/4.x/governance#setup](build-dao) VIDEO STOP AT 07.21.27

### ACCOUNT ABSTRACTION EIP-4337
- [https://eips.ethereum.org/EIPS/eip-4337](account-abstraction)

## ETHEREUM NAME SERVICE (ENS)
[https://eips.ethereum.org/EIPS/eip-137](ethereum-name-service)

## Caveats
  - to install any packages/dependencies to foundry project without having to use --no-commit at the end
  - you need to commit your local changes first, then install any deps and it will be fine

### Current Dao Problem with voting
 - proof of personhood of participation => meaning one user can only vote once no matter how much token of the protocol they have ( still unsolve )
   - the issue is user can still create another more account with diff address to give a vote

### off-chain vs on-chain voting
 - off-chain voting can be very cheap, bcoz each vote doesnt need to send on chain ( no gas spent )
   - the way it work is user sign a vote, and all that vote will save/collected to decentralized database like ( ipfs ), after all collected then   send it to on-chain, that way only cost one transaction
   - we can also use snapshot platform to let our community to sign a vote on our proposal and store all that signed vote on ipfs without send it to on-chain directly, it could be send to onchain if dao chose it.

 - on-chain voting could be very expensive for every single person vote, imagine per vote cost $100 * 1M users = $1mn
   and thats not good for the community, bcoz each time the protocol want to make changes they need to spend that much of money 

### Dao structure
 - contract that we want to make changes
 - Governance token
 - Governor Contract ( which contain all vote proposal and other stuff )
 - timelock Controller ( this contract will owne the governor contract )
   - timelock controller will give user some time to get out if they dont like the proposal, bfore the proposal get execute it.