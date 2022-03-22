import { deployContractByName, sendTransaction, executeScript } from "flow-js-testing"
import { getAdminAddress } from "./common"
import { deployTeleracing,setupTeleracingOnAccount } from "./teleracingnft"

/*
 * Deploys Teleracing and NFTStorefront contracts to Admin.
 * @throws Will throw an error if transaction is reverted.
 * @returns {Promise<[{*} txResult, {error} error]>}
 * */
export const deployNFTStorefront = async () => {
	const Admin = await getAdminAddress();
	await deployTeleracing();
	return deployContractByName({ to: Admin, name: "NFTStorefront" });
};

/*
 * Sets up NFTStorefront.Storefront on account and exposes public capability.
 * @param {string} account - account address
 * @throws Will throw an error if transaction is reverted.
 * @returns {Promise<[{*} txResult, {error} error]>}
 * */
export const setupStorefrontOnAccount = async (account) => {
	// Account shall be able to store TeleracingNFT
	await setupTeleracingOnAccount(account);

	const name = "nftstorefront/setup_account";
	const signers = [account];

	return sendTransaction({ name, signers });
};

/*
 * Lists item with id equal to **item** id for sale with specified **price**.
 * @param {string} seller - seller account address
 * @param {UInt64} itemId - id of item to sell
 * @param {UFix64} price - price
 * @returns {Promise<[{*} txResult, {error} error]>}
 * */
export const createListing = async (seller, itemId, price) => {
	const name = "nftstorefront/create_listing";
	const args = [itemId, price];
	const signers = [seller];

	return sendTransaction({ name, args, signers });
};

/*
 * Buys item with id equal to **item** id for **price** from **seller**.
 * @param {string} buyer - buyer account address
 * @param {UInt64} resourceId - resource uuid of item to sell
 * @param {string} seller - seller account address
 * @returns {Promise<[{*} txResult, {error} error]>}
 * */
export const purchaseListing = async (buyer, resourceId, seller) => {
	const name = "nftstorefront/purchase_listing";
	const args = [resourceId, seller];
	const signers = [buyer];

	return sendTransaction({ name, args, signers });
};

/*
 * Removes item with id equal to **item** from sale.
 * @param {string} owner - owner address
 * @param {UInt64} itemId - id of item to remove
 * @returns {Promise<[{*} txResult, {error} error]>}
 * */
export const removeListing = async (owner, itemId) => {
	const name = "nftstorefront/remove_listing";
	const signers = [owner];
	const args = [itemId];

	return sendTransaction({ name, args, signers });
};

/*
 * Returns the number of items for sale in a given account's storefront.
 * @param {string} account - account address
 * @returns {Promise<[{UInt64} result, {error} error]>}
 * */
export const getListingCount = async (account) => {
	const name = "nftstorefront/get_listings_length";
	const args = [account];

	return executeScript({ name, args });
};
