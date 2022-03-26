### TeleRacingNFT:
1. setupAccount: flow transactions send ./transaction/teleracing/setup_account.cdc --signer test1 --network testnet
2. mintNFT: flow transactions send ./transaction/teleracing/mint_nft.cdc --args-json='[{"type": "Address", "value": "0xf8d6e0586b0a20c7"},{"type": "String", "value": "rare"},{"type": "String", "value": "Des1"},{"type": "String", "value": "ipfsHash"},{"type": "UInt64", "value": "1"},{"type": "UInt64", "value": "100"} ]' --signer test0 --network testnet
3. transferNFT: flow transactions send ./transaction/teleracing/transfer_nft.cdc 0x09568b29f07c5f87 0 --signer test1 --network testnet
4. destroyNFT: flow transactions send ./transaction/teleracing/destroy_nft.cdc 1 --signer test1 --network testnet


查询特定地址的collectionids: flow scripts execute ./scripts/get_collection_ids.cdc 0x09568b29f07c5f87 --network testnet
查询特定地址的collection数量: flow scripts execute ./scripts/get_collection_length.cdc 0x09568b29f07c5f87 --network testnet
获取特定地址以及特定CollectionID的MetaData: flow scripts execute ./scripts/get_nft_metadata.cdc 0x09568b29f07c5f87 0 --network testnet
获取NFT这一系列的总量: flow scripts execute ./scripts/get_total_supply.cdc

-----------------------------

### NFTStoreFront
1. setupAccount: flow transactions send ./transaction/nftstorefront/setup_account.cdc --signer emulator-account --network testnet
2. setupAccount: flow transactions send ./transaction/nftstorefront/setup_account.cdc --signer test1 --network testnet
3. create_listing[create_listing_remove] : flow transactions send ./transaction/nftstorefront/create_listing.cdc 0 10.0 --signer emulator-account
4. purchase_listring : flow transactions send ./transaction/nftstorefront/purchase_listing.cdc 0 0xf8d6e0586b0a20c7 --signer test1

查询挂单的resourceID: flow scripts execute ./scripts/nftstorefront/get_listings.cdc 0x0xf8d6e0586b0a20c7




 