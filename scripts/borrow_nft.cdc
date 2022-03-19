// import NonFungibleToken from "../contracts/standard/NonFungibleToken.cdc"
// import TeleRacingPreSale from "../contracts/TeleRacingPreSale.cdc"

import NonFungibleToken from 0x631e88ae7f1d7c20
import TeleRacingPreSale from 0x09568b29f07c5f87

//Return the reference about specific nftid under this account
//No useful for now
pub fun main(address:Address,id:UInt64){
    let account = getAccount(address)
    let collectionRef = account.getCapability(TeleRacingPreSale.CollectionPublicPath)
                                .borrow<&{NonFungibleToken.CollectionPublic}>()
                                ?? panic("Could not borrow collection ref")
    let _ = collectionRef.borrowNFT(id:id)
}