import path from "path"
import { 
	emulator,
	init,
	getAccountAddress,
	shallPass,
	shallResolve,
	shallRevert,
} from "flow-js-testing";

import { getAdminAddress } from "../src/common";
import { 
    deployTeleracing,
    setupTeleracingOnAccount,
    getTeleracingSupply,
    mintTeleracing,
    transferTeleracing,
    getTeleRacingCount, 
    getTeleracing,
    getTeleRacingids,
} from "../src/teleracingnft";

// We need to set timeout for a higher number, because some transactions might take up some time
jest.setTimeout(50000);

describe("Teleracing NFT",()=>{
    //Instantiate emulator and path to Cadence files
    beforeEach(async()=>{
        const basePath = path.resolve(__dirname,"../../");
        const port = 7002;
        await init(basePath,{port});
        await emulator.start(port,false);
        return await new Promise(r=>setTimeout(r,1000));
    });

    afterEach(async()=>{
        await emulator.stop();
        return await new Promise(r=>setTimeout(r,1000));
    });

    //check contract deploy
    it("should deploy teleracing contract",async()=>{
        await shallPass(deployTeleracing());
    });
    //after deployed, check collection supply
    it("supply should be 0 after contract is deployed", async()=>{
        await deployTeleracing();
        const Admin = await getAdminAddress();
        await shallPass(setupTeleracingOnAccount(Admin));
        const [supply] = await shallResolve(getTeleracingSupply())
        expect(supply).toBe(0)
    });

    //check mint
    it("should be able to mint a teleracing NFT",async()=>{
        await deployTeleracing();
        const Alice = await getAccountAddress("Alice");
        await setupTeleracingOnAccount(Alice);
        //Mint should work
        await shallPass(mintTeleracing(Alice,"name1","des1","hash1",1,100))
    })

    it("should be fit metadata after mint",async () => {
        //setup account for collection
        await deployTeleracing();
        const Alice = await getAccountAddress("Alice");
        await setupTeleracingOnAccount(Alice)
        await mintTeleracing(Alice,"name1","des1","hash1",1,100)

		const [metadata] = await shallResolve(getTeleracing(Alice,0))
        expect(metadata.name).toBe('name1');
        expect(metadata.description).toBe('des1');
        expect(metadata.thumbnail).toBe('ipfs://hash1');
        expect(metadata.editionNumber).toBe(1);
        expect(metadata.maxEdition).toBe(100);
    })

    it("collection length should be 1 after mint 1",async () => {
        //setup account for collection
        await deployTeleracing();
        const Alice = await getAccountAddress("Alice");
        await setupTeleracingOnAccount(Alice)
        await mintTeleracing(Alice,"name1","des1","hash1",1,100)
        //once setup done, the number of nft in this account collection should be 0
		const [itemCount] = await shallResolve(getTeleRacingCount(Alice))
		expect(itemCount).toBe(1);
    })

//-----------------------------------------------------------------------------------------
    it("should be able to create a new empty NFT collection",async () => {
        //setup account for collection
        await deployTeleracing();
        const Alice = await getAccountAddress("Alice");
        await setupTeleracingOnAccount(Alice)
        //once setup done, the number of nft in this account collection should be 0
		const [itemCount] = await shallResolve(getTeleRacingCount(Alice))
		expect(itemCount).toBe(0);
    })
//-------------------------------------------------------------------------------------

    it("should not be able to withdraw an NFT that doesn't exist in a collection", async () => {
		// Setup
		await deployTeleracing();
		const Alice = await getAccountAddress("Alice");
		const Bob = await getAccountAddress("Bob");
		await setupTeleracingOnAccount(Alice);
		await setupTeleracingOnAccount(Bob);

		// Transfer transaction shall fail for non-existent item
		await shallRevert(transferTeleracing(Alice, Bob, 1337));
	});

	it("should be able to withdraw an NFT and deposit to another accounts collection", async () => {
		await deployTeleracing();
		const Alice = await getAccountAddress("Alice");
		const Bob = await getAccountAddress("Bob");
		await setupTeleracingOnAccount(Alice);
		await setupTeleracingOnAccount(Bob);

		// Mint instruction for Alice account shall be resolved
		await shallPass(mintTeleracing(Alice,"name1","des1","hash1",1,100));

		// Transfer transaction shall pass
		await shallPass(transferTeleracing(Alice, Bob, 0));
	});
})