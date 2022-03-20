import NonFungibleToken from "../contracts/NonFungibleToken.cdc"
import TeleRacingPreSale from "../contracts/TeleRacingPreSale.cdc"

// import TeleRacingPreSale from 0x09568b29f07c5f87
// import NonFungibleToken from 0x631e88ae7f1d7c20

// This transaction is for transferring and NFT from one account to another

transaction(recipient: Address, withdrawID: UInt64) {

    prepare(signer: AuthAccount) {
        // get the recipients public account object
        let recipient = getAccount(recipient)

        // borrow a reference to the signer's NFT collection
        let collectionRef = signer
            .borrow<&TeleRacingPreSale.Collection>(from: TeleRacingPreSale.CollectionStoragePath)
            ?? panic("Could not borrow a reference to the owner's collection")

        // borrow a public reference to the receivers collection
        let depositRef = recipient
            .getCapability(TeleRacingPreSale.CollectionPublicPath)
            .borrow<&{NonFungibleToken.CollectionPublic}>()
            ?? panic("Could not borrow a reference to the receiver's collection")

        // withdraw the NFT from the owner's collection
        let nft <- collectionRef.withdraw(withdrawID: withdrawID)

        // Deposit the NFT in the recipient's collection
        depositRef.deposit(token: <-nft)
    }
}