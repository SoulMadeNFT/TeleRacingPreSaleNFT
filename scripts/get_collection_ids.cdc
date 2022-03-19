// import NonFungibleToken from "../contracts/standard/NonFungibleToken.cdc"
// import TeleRacingPreSale from "../contracts/TeleRacingPreSale.cdc"

import TeleRacingPreSale from 0x09568b29f07c5f87
import NonFungibleToken from 0x631e88ae7f1d7c20

//For specific address, return the nft quantity of collection under this account
pub fun main(address:Address):[UInt64]{
    let account = getAccount(address)
    let collectionRef = account.getCapability(TeleRacingPreSale.CollectionPublicPath)
                                .borrow<&{NonFungibleToken.CollectionPublic}>()
                                ?? panic("Could not borrow capability from public collection||Maybe you need to send transaction setupAccount🐱‍🚀")
    return collectionRef.getIDs()
}