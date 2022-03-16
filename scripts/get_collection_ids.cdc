import TeleRacingPreSale from 0xf04eba8c8366000e
import NonFungibleToken from 0x631e88ae7f1d7c20

//For specific address, return the nft quantity of collection under this account
pub fun main(address:Address):[UInt64]{
    let account = getAccount(address)
    let collectionRef = account.getCapability(TeleRacingPreSale.CollectionPublicPath)
                                .borrow<&{NonFungibleToken.CollectionPublic}>()
                                ?? panic("Could not borrow capability from public collection||Maybe you need to send transaction setupAccount🐱‍🚀")
    return collectionRef.getIDs()
}