const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Testing Champions Contract", function () {
  it("Should deploy and import Champion", async function () {
    // Deploy champions
    const [owner] = await ethers.getSigners();
    const contractFactory = await ethers.getContractFactory("Champion");
    const token = await contractFactory.deploy(3, 8888, "ipfs://");
    await token.deployed();
    // await token.reserve();

    const ownerBalance = await token.balanceOf(owner.address);

    expect(await token.totalSupply()).to.equal(ownerBalance);
  });
});
