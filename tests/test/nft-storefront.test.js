import path from "path";

import { 
	emulator,
	init,
	getAccountAddress,
	shallPass,
	mintFlow,
} from "flow-js-testing";

import { toUFix64 } from "../src/common";
import { 
	getTeleRacingCount,
	mintTeleracing,
	getTeleracing,
} from "../src/teleracingnft";
import {
	deployNFTStorefront,
	createListing,
	purchaseListing,
	removeListing,
	setupStorefrontOnAccount,
	getListingCount,
	purchaseByName,
	createListingRemoveExist
} from "../src/nft-storefront";

// We need to set timeout for a higher number, because some transactions might take up some time
jest.setTimeout(500000);

describe("NFT StoreFront",()=>{
	beforeEach(async()=>{
        const basePath = path.resolve(__dirname,"../../");
        const port = 7003;
        await init(basePath,{port});
        await emulator.start(port,false);
        return await new Promise(r=>setTimeout(r,1000));
	});

	// Stop emulator, so it could be restarted
	afterEach(async () => {
		await emulator.stop();
		return await new Promise(r => setTimeout(r, 1000));
	});

	it("should deploy NFTStorefront contract", async () => {
		await shallPass(deployNFTStorefront());
	});

	it("should be able to create an empty Storefront", async () => {
		// Setup
		await deployNFTStorefront();
		const Alice = await getAccountAddress("Alice");

		await shallPass(setupStorefrontOnAccount(Alice));
	});

	it("should be able to create a listing", async () => {
		// Setup
		await deployNFTStorefront();
		const Alice = await getAccountAddress("Alice");
		await setupStorefrontOnAccount(Alice);
		// Mint TeleracingNFT for Alice's account
		await shallPass(mintTeleracing(Alice,"name1","des1","hash1",1,100))
		const itemID = 0;

		await shallPass(createListing(Alice, itemID, toUFix64(1.11)));
	});

	it("should be able to accept a listing", async () => {
		// Setup
		await deployNFTStorefront();
		// Setup seller account
		const Alice = await getAccountAddress("Alice");
		await setupStorefrontOnAccount(Alice);
		await mintTeleracing(Alice,"name1","des1","hash1",1,100)
		const itemId = 0;
		// Setup buyer account
		const Bob = await getAccountAddress("Bob");
		await setupStorefrontOnAccount(Bob);
		await shallPass(mintFlow(Bob, toUFix64(100)));
		// Bob shall be able to buy from Alice
		const [sellItemTransactionResult] = await shallPass(createListing(Alice, itemId, toUFix64(1.11)));
		const listingAvailableEvent = sellItemTransactionResult.events[0];
		const listingResourceID = listingAvailableEvent.data.listingResourceID;
		await shallPass(purchaseListing(Bob, listingResourceID, Alice));
		const [itemCount] = await getTeleRacingCount(Bob);
		expect(itemCount).toBe(1);
		const [listingCount] = await getListingCount(Alice);
		expect(listingCount).toBe(0);
	});

	it("should be able to remove a listing", async () => {
		// Deploy contracts
		await shallPass(deployNFTStorefront());
		// Setup Alice account
		const Alice = await getAccountAddress("Alice");
		await shallPass(setupStorefrontOnAccount(Alice));
		// Mint instruction shall pass
		await shallPass(mintTeleracing(Alice,"name1","des1","hash1",1,100));
		const itemId = 0;
		await getTeleracing(Alice, itemId);
		// Listing item for sale shall pass
		const [sellItemTransactionResult] = await shallPass(createListing(Alice, itemId, toUFix64(1.11)));

		const listingAvailableEvent = sellItemTransactionResult.events[0];
		const listingResourceID = listingAvailableEvent.data.listingResourceID;

		// Alice shall be able to remove item from sale
		await shallPass(removeListing(Alice, listingResourceID));

		const [listingCount] = await getListingCount(Alice);
		expect(listingCount).toBe(0);
	});

	it("should be pruchase item by name", async () => {
		// Setup
		await deployNFTStorefront();
		// Setup seller account
		const Alice = await getAccountAddress("Alice");
		await setupStorefrontOnAccount(Alice);
		await mintTeleracing(Alice,"common","des1","hash1",1,100)
		const itemId = 0;
		// Setup buyer account
		const Bob = await getAccountAddress("Bob");
		await setupStorefrontOnAccount(Bob);
		await shallPass(mintFlow(Bob, toUFix64(100)));
		// Bob shall be able to buy from Alice
		const [sellItemTransactionResult] = await shallPass(createListing(Alice, itemId, toUFix64(1.11)));
		//const listingAvailableEvent = sellItemTransactionResult.events[0];
		//const listingResourceID = listingAvailableEvent.data.listingResourceID;
		await shallPass(purchaseByName(Bob, "common", Alice));
		const [itemCount] = await getTeleRacingCount(Bob);
		expect(itemCount).toBe(1);
		const [listingCount] = await getListingCount(Alice);
		expect(listingCount).toBe(0);
	});

	it("should be able to remove a exist listing when create new listing with same itemID", async () => {
		// Deploy contracts
		await shallPass(deployNFTStorefront());
		// Setup Alice account
		const Alice = await getAccountAddress("Alice");
		await shallPass(setupStorefrontOnAccount(Alice));
		// Mint instruction shall pass
		await shallPass(mintTeleracing(Alice,"name1","des1","hash1",1,100));
		const itemId = 0;
		await getTeleracing(Alice, itemId);
		// Listing item for sale shall pass twice to test if the first will be deleted
		await shallPass(createListingRemoveExist(Alice, itemId, toUFix64(1.11)));
		await shallPass(createListingRemoveExist(Alice, itemId, toUFix64(2.22)));

		const [listingCount] = await getListingCount(Alice);
		expect(listingCount).toBe(1);
	});

})