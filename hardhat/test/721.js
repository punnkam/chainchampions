const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Testing Champions Contract", function () {


  let contract;
  let champion;
  let owner
  let addr1;
  let addr2;
  let addrs;

  // Deploy before every test
  beforeEach(async function() {
    [owner, addr1, addr2, ...addrs] = await ethers.getSigners();
    contract = await ethers.getContractFactory("Champion");
    champion = await contract.deploy(3, 8888, "ipfs://");
    await champion.deployed();
  });
  
  describe("Deployment", function () {

    // Setting the owner
    it("Set the correct owner", async function () {
      expect(await champion.owner()).to.equal(owner.address);
    });

    it("Owner's balance is total supply", async function () {
      const ownerBalance = await champion.balanceOf(owner.address);
  
      expect(await champion.totalSupply()).to.equal(ownerBalance);
    });

    it("30 Assets are reserved", async function () {
      await champion.reserve();
      const ownerBalance = await champion.balanceOf(owner.address);
  
      expect(await ownerBalance).to.equal(30);
    });  

  });

  describe("Transfers", function () {

    
    it("Addr1 mints one", async function () {

      // Test Mint
      await champion.connect(addr1).mint(1, {
        value: ethers.utils.parseEther("0.001")
      });

      const addr1Balance = await champion.balanceOf(addr1.address);
      expect(addr1Balance).to.equal(1);
    });

    it("Addr2 mints 100", async function () {
      
      // Addr2 mints 100
      expect(champion.connect(addr2).mint(100, {
        value: ethers.utils.parseEther("0.1")
      })).to.be.revertedWith("Cannot mint this amount");


    });

  })

  describe("Admin functions", function () {
  
    it("Only owner withdraw", async function () {
      
      // const contractBalance = 
    })
  });

});
