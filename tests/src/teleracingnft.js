import { mintFlow,executeScript,sendTransaction,deployContractByName } from "flow-js-testing";
import { getAdminAddress } from "./common";

/*
 * Deploys NonFungibleToken and TeleracingNFT contracts to Admin.
 * @throws Will throw an error if transaction is reverted.
 * @returns {Promise<[{*} txResult, {error} error]>}
 * */
export const deployTeleracing = async() =>{
    const Admin = await getAdminAddress();
    await mintFlow(Admin,"10.0")

	await deployContractByName({ to: Admin, name: "NonFungibleToken" });
	await deployContractByName({ to: Admin, name: "MetadataViews" });
	return deployContractByName({ to: Admin, name: "TeleRacingPreSale" });
}

/*
 * Setups TeleracingNFT collection on account and exposes public capability.
 * @param {string} account - account address
 * @returns {Promise<[{*} txResult, {error} error]>}
 * */
export const setupTeleracingOnAccount = async (account) => {
	const name = "setup_account";
	const signers = [account];

	return sendTransaction({ name, signers });
};

/*
 * Returns TeleracingNFT supply.
 * @throws Will throw an error if execution will be halted
 * @returns {UInt64} - number of NFT minted so far
 * */
export const getTeleracingSupply = async () => {
	const name = "get_total_supply";

	return executeScript({ name });
};

/*
 * Mints TeleracingNFT of a specific **itemType** and sends it to **recipient**.
 * @param {UInt64} itemType - type of NFT to mint
 * @param {string} recipient - recipient account address
 * @returns {Promise<[{*} result, {error} error]>}
 * */
export const mintTeleracing = async (recipient, _name, description, thumbnail, editionNumber, maxEdition) => {
	const Admin = await getAdminAddress();

	const name = "mint_nft";
	const args = [recipient, _name, description, thumbnail, editionNumber, maxEdition];
	const signers = [Admin];

	return sendTransaction({ name, args, signers });
};



/*
 * Transfers TeleracingNFT NFT with id equal **itemId** from **sender** account to **recipient**.
 * @param {string} sender - sender address
 * @param {string} recipient - recipient address
 * @param {UInt64} itemId - id of the item to transfer
 * @throws Will throw an error if execution will be halted
 * @returns {Promise<*>}
 * */
export const transferTeleracing = async (sender, recipient, itemId) => {
	const name = "transfer_nft";
	const args = [recipient, itemId];
	const signers = [sender];

	return sendTransaction({ name, args, signers });
};



/*
 * Returns the Teleracing NFT with the provided **id** from an account collection.
 * @param {string} account - account address
 * @param {UInt64} itemID - NFT id
 * @throws Will throw an error if execution will be halted
 * @returns {UInt64}
 * */
export const getTeleracing = async (account, itemID) => {
	const name = "get_nft_metadata";
	const args = [account, itemID];

	return executeScript({ name, args });
};


/*
 * Returns the number of TeleracingNFT in an account's collection.
 * @param {string} account - account address
 * @throws Will throw an error if execution will be halted
 * @returns {UInt64}
 * */
export const getTeleRacingCount = async (account) => {
	const name = "get_collection_length";
	const args = [account];
	return executeScript({ name, args });
};

/*
 * Returns the ids of TeleracingNFT in an account's collection.
 * @param {string} account - account address
 * @throws Will throw an error if execution will be halted
 * @returns [UInt64]
 * */
export const getTeleRacingids = async (account) => {
	const name = "get_collection_ids";
	const args = [account];
	return executeScript({ name, args });
};