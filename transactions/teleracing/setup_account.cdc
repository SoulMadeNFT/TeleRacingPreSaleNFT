import NonFungibleToken from "../../contracts/NonFungibleToken.cdc"
import TeleRacingPreSale from "../../contracts/TeleRacingPreSale.cdc"
// import TeleRacingPreSale from 0x09568b29f07c5f87
// import NonFungibleToken from 0x631e88ae7f1d7c20

transaction {

    prepare(signer: AuthAccount) {
        // Return early if the account already has a collection
        if signer.borrow<&TeleRacingPreSale.Collection>(from: TeleRacingPreSale.CollectionStoragePath) != nil {
            return
        }

        // Create a new empty collection
        let collection <- TeleRacingPreSale.createEmptyCollection()

        // save it to the account
        signer.save(<-collection, to: TeleRacingPreSale.CollectionStoragePath)

        // create a public capability for the collection
        signer.link<&{NonFungibleToken.CollectionPublic, TeleRacingPreSale.TeleRacingPreSaleCollectionPublic}>(
            TeleRacingPreSale.CollectionPublicPath,
            target: TeleRacingPreSale.CollectionStoragePath
        )
    }
}
