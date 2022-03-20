# 🚓TeleRacingPreSaleNFT 🚗

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
   - flow transactions send ./transaction/setup_account.cdc --signer test1 --network testnet
2. mint_nft.cdc
   - flow transactions send ./transaction/mint_nft.cdc --args-json='[{"type": "Address", "value": "0x027cb9b03cf921ae"},{"type": "String", "value": "name1"},{"type": "String", "value": "Des1"},{"type": "String", "value": "ipfsHash"},{"type": "Int64", "value": "1"},{"type": "Int64", "value": "100"} ]' --signer test0 --network testnet
3. transfer_nft.cdc
   - flow transactions send ./transaction/transfer_nft.cdc 0x09568b29f07c5f87 0 --signer test1 --network testnet
4. destroy_nft.cdc
   - flow transactions send ./transaction/destroy_nft.cdc 1 --signer test1 --network testnet

---

### Scripts

1. get_collection_ids.cdc
2. get_collection_length.cdc
3. get_nft_metadata.cdc
4. get_total_supply.cdc
5. borrow_nft.cdc

---

### Tests

1. `yarn`

2. `yarn test`