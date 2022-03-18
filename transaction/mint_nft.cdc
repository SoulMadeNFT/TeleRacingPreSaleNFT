// import NonFungibleToken from "../contracts/standard/NonFungibleToken.cdc"
// import TeleRacingPreSale from "../contracts/TeleRacingPreSale.cdc"

import NonFungibleToken from 0x631e88ae7f1d7c20
import TeleRacingPreSale from 0x09568b29f07c5f87

// This script uses the NFTMinter resource to mint a new NFT
// It must be run with the account that has the minter resource
// stored in /storage/NFTMinter

transaction(
    recipient: Address,
    name: String,
    description: String,
    thumbnail: String,
    editionNumber:Int64,
    maxEdition:Int64,
) {

    // local variable for storing the minter reference
    let minter: &TeleRacingPreSale.NFTMinter

    prepare(signer: AuthAccount) {
        // borrow a reference to the NFTMinter resource in storage
        self.minter = signer.borrow<&TeleRacingPreSale.NFTMinter>(from: TeleRacingPreSale.MinterStoragePath)
            ?? panic("Could not borrow a reference to the NFT minter")
    }

    execute {
        // Borrow the recipient's public NFT collection reference
        let receiver = getAccount(recipient)
            .getCapability(TeleRacingPreSale.CollectionPublicPath)
            .borrow<&{NonFungibleToken.CollectionPublic}>()
            ?? panic("Could not get receiver reference to the NFT Collection")

        // Mint the NFT and deposit it to the recipient's collection
        self.minter.mintNFT(
            recipient: receiver,
            name: name,
            description: description,
            thumbnail: thumbnail,
            editionNumber: editionNumber,
            maxEdition:maxEdition
        )
    }
}
 