import NonFungibleToken from "../../contracts/NonFungibleToken.cdc"
import MetadataViews from "../../contracts/MetadataViews.cdc"
import NFTStorefront from "../../contracts/NFTStorefront.cdc"
import TeleRacingPreSale from "../../contracts/TeleRacingPreSale.cdc"

pub struct ListingItem {
    pub let name: String
    pub let description: String
    pub let thumbnail: String
    pub var editionNumber : Int64
    pub var maxEdition: Int64 

    pub let itemID: UInt64
    pub let resourceID: UInt64
    pub let owner: Address
    pub let price: UFix64

    init(
        name: String,
        description: String,
        thumbnail: String,
        editionNumber : Int64,
        maxEdition: Int64 ,
        itemID: UInt64,
        resourceID: UInt64,
        owner: Address,
        price: UFix64
    ) {
        self.name = name
        self.description = description
        self.thumbnail = thumbnail
        self.editionNumber = editionNumber
        self.maxEdition = maxEdition
        self.itemID = itemID
        self.resourceID = resourceID
        self.owner = owner
        self.price = price
    }
}

pub fun dwebURL(_ file: MetadataViews.IPFSFile): String {
    var url = "https://"
        .concat(file.cid)
        .concat(".ipfs.dweb.link/")
  
    if let path = file.path {
        return url.concat(path)
    }
  
    return url
}

pub fun main(address: Address): {UInt64:String} {
    //listName:{listingResourceID:Name}
    let listName:{UInt64:String} = {}
    let account = getAccount(address)
    let storefrontRef = account.getCapability<&NFTStorefront.Storefront{NFTStorefront.StorefrontPublic}>(
        NFTStorefront.StorefrontPublicPath
    ).borrow()
    ?? panic("Could not get storefront capability")


    //get name
    for item in storefrontRef.getListingIDs(){
        let listing = storefrontRef.borrowListing(listingResourceID: item)??panic("No item with this id")
        let details = listing.getDetails()
        let collection = getAccount(address).getCapability<&{NonFungibleToken.CollectionPublic, TeleRacingPreSale.TeleRacingPreSaleCollectionPublic}>(TeleRacingPreSale.CollectionPublicPath).borrow() ?? panic("Could not get collection capability")
        let itemInfo = collection.borrowTeleRacingPreSale(id: details.nftID)
        listName[item] = itemInfo!.name
    }
    return listName
}
