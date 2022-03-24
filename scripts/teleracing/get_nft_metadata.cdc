import TeleRacingPreSale from "../../contracts/TeleRacingPreSale.cdc"
import MetadataViews from "../../contracts/MetadataViews.cdc"

// import MetadataViews from 0x631e88ae7f1d7c20
// import TeleRacingPreSale from 0x09568b29f07c5f87

//For specific address and nftID, return the metadata.
//the nftID is totalsupply sequence number.

pub struct NFT {
    pub let name: String
    pub let description: String
    pub let thumbnail: String
    pub var editionNumber : UInt64
    pub var maxEdition: UInt64 

    pub let itemID:UInt64
    pub let resourceID: UInt64
    pub let owner: Address
    pub let type: String

    init(
        name: String,
        description: String,
        thumbnail: String,
        itemID:UInt64,
        resourceID:UInt64,
        owner: Address,
        editionNumber : UInt64,
        maxEdition: UInt64 ,
        nftType: String,
    ) {
        self.name = name
        self.description = description
        self.thumbnail = thumbnail
        self.itemID = itemID
        self.resourceID = resourceID
        self.owner = owner
        self.editionNumber = editionNumber
        self.maxEdition = maxEdition
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
        itemID:id,
        resourceID:nft.uuid,
        owner: owner,
        editionNumber : nft.editionNumber,
        maxEdition: nft.maxEdition,
        nftType: nftType.identifier,
    )
}