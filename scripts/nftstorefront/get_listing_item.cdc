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

pub fun main(address: Address, listingResourceID: UInt64): ListingItem? {
    let account = getAccount(address)

    if let storefrontRef = account.getCapability<&NFTStorefront.Storefront{NFTStorefront.StorefrontPublic}>(NFTStorefront.StorefrontPublicPath).borrow() {

        if let listing = storefrontRef.borrowListing(listingResourceID: listingResourceID) {
            
            let details = listing.getDetails()

            let itemID = details.nftID
            log(itemID)
            let itemPrice = details.salePrice
        
            if let collection = getAccount(address).getCapability<&TeleRacingPreSale.Collection{NonFungibleToken.CollectionPublic, TeleRacingPreSale.TeleRacingPreSaleCollectionPublic}>(TeleRacingPreSale.CollectionPublicPath).borrow() {
            
                if let item = collection.borrowTeleRacingPreSale(id: itemID) {

                    if let view = item.resolveView(Type<MetadataViews.Display>()) {

                        let display = view as! MetadataViews.Display
                    
                        let owner: Address = item.owner!.address!

                        let ipfsThumbnail = display.thumbnail as! MetadataViews.IPFSFile     

                        return ListingItem(
                            name: display.name,
                            description: display.description,
                            thumbnail: dwebURL(ipfsThumbnail),
                            editionNumber : item.editionNumber,
                            maxEdition: item.maxEdition,
                            itemID: itemID,
                            resourceID: item.uuid,
                            owner: address,
                            price: itemPrice
                        )
                    }
                }
            }
        }
    }
    log("Here")

    return nil
}
