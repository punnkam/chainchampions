const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Arena", function () {
  it("Should deploy and import Champion", async function () {

    // Deploy champions
    const Champion = await ethers.getContractFactory("Champion");
    const champion = await Champion.deploy();
    await champion.deployed();

    // Deploy arena
    // const Arena = await ethers.getContractFactory("Arena");
    // const arena = await Arena.deploy("Hello, world!");
    // await arena.deployed();

    // expect(await greeter.greet()).to.equal("Hello, world!");

    // const setGreetingTx = await greeter.setGreeting("Hola, mundo!");

    // // wait until the transaction is mined
    // await setGreetingTx.wait();

    expect(await champion.getDeployed()).to.equal(true);
  });
});
