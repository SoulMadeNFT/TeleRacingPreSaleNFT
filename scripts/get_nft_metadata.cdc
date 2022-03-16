// import TeleRacingPreSale from "../contracts/TeleRacingPreSale.cdc"
// import MetadataViews from "../contracts/standard/MetadataViews.cdc"
import MetadataViews from 0x631e88ae7f1d7c20
import TeleRacingPreSale from 0xf04eba8c8366000e

//For specific address and nftID, return the metadata.
//the nftID is totalsupply sequence number.

pub struct NFT {
    pub let name: String
    pub let description: String
    pub let thumbnail: String
    pub let owner: Address
    pub let type: String

    init(
        name: String,
        description: String,
        thumbnail: String,
        owner: Address,
        nftType: String,
    ) {
        self.name = name
        self.description = description
        self.thumbnail = thumbnail
        self.owner = owner
        self.type = nftType
    }
}

pub fun main(address: Address, id: UInt64): NFT {
    let account = getAccount(address)

    let collection = account
        .getCapability(TeleRacingPreSale.CollectionPublicPath)
        .borrow<&{TeleRacingPreSale.TeleRacingPreSaleCollectionPublic}>()
        ?? panic("Could not borrow a reference to the collection")

    let nft = collection.borrowTeleRacingPreSale(id: id)!

    // Get the basic display information for this NFT
    let view = nft.resolveView(Type<MetadataViews.Display>())!

    let display = view as! MetadataViews.Display
    
    let owner: Address = nft.owner!.address!
    let nftType = nft.getType()

    return NFT(
        name: display.name,
        description: display.description,
        thumbnail: display.thumbnail.uri(),
        owner: owner,
        nftType: nftType.identifier,
    )
}