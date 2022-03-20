import NonFungibleToken from "../contracts/NonFungibleToken.cdc"
import TeleRacingPreSale from "../contracts/TeleRacingPreSale.cdc"

// import NonFungibleToken from 0x631e88ae7f1d7c20
// import TeleRacingPreSale from 0x09568b29f07c5f87

//For specific address, return the nft quantity of collection under this account
pub fun main(address: Address): Int {
    let account = getAccount(address)

    let collectionRef = account.getCapability(TeleRacingPreSale.CollectionPublicPath)!
        .borrow<&{NonFungibleToken.CollectionPublic}>()
        ?? panic("Could not borrow capability from public collection")

    return collectionRef.getIDs().length
}
