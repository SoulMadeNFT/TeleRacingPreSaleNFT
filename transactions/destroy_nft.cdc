// import NonFungibleToken from "../contracts/standard/NonFungibleToken.cdc"
// import TeleRacingPreSale from "../contracts/TeleRacingPreSale.cdc"
import NonFungibleToken from 0x631e88ae7f1d7c20
import TeleRacingPreSale from 0x09568b29f07c5f87

transaction(id: UInt64) {
    prepare(signer: AuthAccount) {
        let collectionRef = signer.borrow<&TeleRacingPreSale.Collection>(from: TeleRacingPreSale.CollectionStoragePath)
            ?? panic("Could not borrow a reference to the owner's collection")

        // withdraw the NFT from the owner's collection
        let nft <- collectionRef.withdraw(withdrawID: id)

        destroy nft
    }
}