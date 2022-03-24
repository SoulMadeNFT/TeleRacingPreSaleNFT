//return the exist listing count by the given name
//if we want to get how many sold
// on the premise of ensuring that there are no duplicate pending orders, 
// just subtract this number from the total number minted in this name
import NonFungibleToken from "../../contracts/NonFungibleToken.cdc"
import MetadataViews from "../../contracts/MetadataViews.cdc"
import NFTStorefront from "../../contracts/NFTStorefront.cdc"
import TeleRacingPreSale from "../../contracts/TeleRacingPreSale.cdc"

pub struct ListingItem {
    pub let name: String
    pub let description: String
    pub let thumbnail: String
    pub var editionNumber : UInt64
    pub var maxEdition: UInt64 

    pub let itemID: UInt64
    pub let resourceID: UInt64
    pub let owner: Address
    pub let price: UFix64

    init(
        name: String,
        description: String,
        thumbnail: String,
        editionNumber : UInt64,
        maxEdition: UInt64 ,
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
    var url = "ipfs://"
        .concat(file.cid)
  
    if let path = file.path {
        return url.concat(path)
    }
    return url
}

pub fun main(name:String,address: Address): {String:UInt64} {
    //listName:{listingResourceID:Name}
    let saleCount : {String:UInt64} = {}
    let account = getAccount(address)
    let storefrontRef = account.getCapability<&NFTStorefront.Storefront{NFTStorefront.StorefrontPublic}>(
        NFTStorefront.StorefrontPublicPath
    ).borrow()
    ?? panic("Could not get storefront capability")

    var count:UInt64 = 0
    //get sale count
    for item in storefrontRef.getListingIDs(){
        let listing = storefrontRef.borrowListing(listingResourceID: item)??panic("No item with this id")
        let details = listing.getDetails()
        let collection = getAccount(address).getCapability<&{NonFungibleToken.CollectionPublic, TeleRacingPreSale.TeleRacingPreSaleCollectionPublic}>(TeleRacingPreSale.CollectionPublicPath).borrow() ?? panic("Could not get collection capability")
        let itemInfo = collection.borrowTeleRacingPreSale(id: details.nftID) ?? panic("Could not get item info")
        if name == itemInfo.name {
            count = count + 1
        }
    }
    saleCount[name] = count
    return saleCount
}
 