# 🚓 TeleRacingPreSaleNFT 🚗

### Contracts

1. MetadataViews.cdc
   - It comes from the NFT template, 👉[Here](https://github.com/onflow/flow-nft/blob/master/contracts/MetadataViews.cdc)
2. NonFungibleToken.cdc
   - it comes from the NFT template,👉[Here](https://github.com/onflow/flow-nft/blob/master/contracts/NonFungibleToken.cdc)
3. TeleRacingPreSale.cdc
   - **This is our core contract✔**
   - it is an NFT contract that follows Cadence NonFungibleToken standard and fit MetadataViews interface🎉
   - <u>its thumbai should be passed into ipfsHash when mint.</u>

---

### Trasactions

1. setup_account.cdc
   - flow transactions send ./transaction/teleracing/setup_account.cdc --signer test1 --network testnet
2. mint_nft.cdc
   - flow transactions send ./transaction/teleracing/mint_nft.cdc --args-json='[{"type": "Address", "value": "0x027cb9b03cf921ae"},{"type": "String", "value": "name1"},{"type": "String", "value": "Des1"},{"type": "String", "value": "ipfsHash"},{"type": "Int64", "value": "1"},{"type": "Int64", "value": "100"} ]' --signer test0 --network testnet
3. transfer_nft.cdc
   - flow transactions send ./transaction/teleracing/transfer_nft.cdc 0x09568b29f07c5f87 0 --signer test1 --network testnet
4. destroy_nft.cdc
   - flow transactions send ./transaction/teleracing/destroy_nft.cdc 1 --signer test1 --network testnet

---

### Scripts

1. get_collection_ids.cdc
2. get_collection_length.cdc
3. get_nft_metadata.cdc
4. get_total_supply.cdc
5. borrow_nft.cdc

---

# 🐱‍👤 NFTStoreFront 🐱‍🐉

### Contracts

1. FlowToken.cdc
   - It comes from the FlowToken template, 👉[Here](https://github.com/onflow/flow-core-contracts/blob/master/contracts/FlowToken.cdc)
2. FungibleToken.cdc
   - it comes from the FungibleToken template,👉[Here](https://github.com/onflow/flow-ft/blob/master/contracts/FungibleToken.cdc)
3. NFTStorefront.cdc
   - **This is our core contract✔**
   - it comes from the NFTStorefront template,👉[Here](https://github.com/onflow/nft-storefront/blob/main/contracts/NFTStorefront.cdc)

---

### Trasactions

1. setup_account.cdc
2. create_listing.cdc
3. create_listing_remove.cdc
4. purchase_listing.cdc
5. purchase_by_hash.cdc
6. remove_listing.cdc
7. clean_listing.cdc

---

### Scripts

1. get_listing_item.cdc
2. get_listing_length.cdc
3. get_listing_names.cdc
4. get_listings.cdc
5. get_sale_count.cdc
6. git_listing.cdc

---


---

# 🚩 Tests

1. `yarn`

2. `yarn test`