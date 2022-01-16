import React, { useEffect, useState } from "react";
import { ethers } from "ethers";
import "./Mint.css";
import Navbar from "../components/Navbar";
import Champion from "../utils/Champion.json";

export default function Mint() {
  // to be changed based on chain data
  const [mints, setMintsLeft] = useState(0);
  const totalMints = 1000;
  const CONTRACT_ADDRESS = "0x080e0aacC4C2DD8289F0Bb3A45FdD675bc7e13A2";
  const [gameContract, setGameContract] = useState(null);

  // todo: disable mint button once mints === totalMints
  const mintNFT = () => {
    setMintsLeft(gameContract.getCount());
  };

  const mintChampion = () => async () => {
    console.log("hmm");
    try {
      if (gameContract) {
        console.log("Minting character in progress...");
        const mintTxn = await gameContract.createRandomChampion();
        await mintTxn.wait();
        console.log("mintTxn:", mintTxn);
        setMintsLeft(mints + 1);
      }
    } catch (error) {
      console.warn("MintCharacterAction Error:", error);
    }
  };

  // UseEffect
  useEffect(() => {
    const { ethereum } = window;
    if (ethereum) {
      const provider = new ethers.providers.Web3Provider(ethereum);
      const signer = provider.getSigner();
      const gameContract = new ethers.Contract(
        CONTRACT_ADDRESS,
        Champion.abi,
        signer
      );

      /*
       * This is the big difference. Set our gameContract in state.
       */
      setGameContract(gameContract);
      console.log("bro?");
    } else {
      console.log("Ethereum object not found");
    }
  }, []);

  return (
    <div class="Mint">
      <Navbar />
      <div class="mint-container">
        <div class="mint-text nes-container is-dark">
          <h1>Mint a Chain Champion!</h1>
          <p>
            {mints} / {totalMints} at xyz ETH each
          </p>
        </div>
        <progress
          class="nes-progress is-pattern"
          value={totalMints}
          value={mints}
          max="100"
        ></progress>
        <button type="button" class="nes-btn" onClick={mintChampion()}>
          Mint
        </button>
      </div>
    </div>
  );
}
