import React, { useEffect, useState } from "react";
import "./Staking.css";
import { ethers } from "ethers";
import Navbar from "../components/Navbar";
import "nes.css/css/nes.min.css";
import Champion from "../utils/Champion.json";

export default function Staking() {
  const [stakes, setStakes] = useState(0);
  //   const CONTRACT_ADDRESS = "0x1bBb5700cFBB8ffA225ed2d268c0Ad28D2B59d41";
  //   const [gameContract, setGameContract] = useState(null);
  //   const [signer, setSigner] = useState(null);
  const stakeChampion1 = () => {
    setStakes(stakes + 1);
  };

  //   const stakeChampion = () => async () => {
  //     console.log("hmm");
  //     try {
  //       if (gameContract) {
  //         console.log("Staking character in progress...");
  //         const mintTxn = await gameContract.stakeChampion(0);
  //         await mintTxn.wait();
  //         console.log("mintTxn:", mintTxn);
  //         setStakes(stakes + 1);
  //       }
  //     } catch (error) {
  //       console.warn("MintCharacterAction Error:", error);
  //     }
  //   };

  //   // UseEffect
  //   useEffect(() => {
  //     const { ethereum } = window;
  //     if (ethereum) {
  //       const provider = new ethers.providers.Web3Provider(ethereum);
  //       const signer = provider.getSigner();
  //       const gameContract = new ethers.Contract(
  //         CONTRACT_ADDRESS,
  //         Camp.abi,
  //         signer
  //       );

  //       /*
  //        * This is the big difference. Set our gameContract in state.
  //        */
  //       setGameContract(gameContract);
  //       setSigner(signer);
  //       console.log("bro?");
  //     } else {
  //       console.log("Ethereum object not found");
  //     }
  //   }, []);

  //starting

  // to be changed based on chain data
  //   const [mints, setMintsLeft] = useState(0);
  //   const totalMints = 1000;
  //   const CONTRACT_ADDRESS = "0x080e0aacC4C2DD8289F0Bb3A45FdD675bc7e13A2";
  //   const [gameContract, setGameContract] = useState(null);

  //   // todo: disable mint button once mints === totalMints
  //   const mintNFT = () => {
  //     setMintsLeft(gameContract.getCount());
  //   };

  //   const mintChampion = () => async () => {
  //     console.log("hmm");
  //     try {
  //       if (gameContract) {
  //         console.log("Minting character in progress...");
  //         const mintTxn = await gameContract.createRandomChampion();
  //         await mintTxn.wait();
  //         console.log("mintTxn:", mintTxn);
  //         //setMintsLeft(mints + 1);
  //         setStakes(stakes + 1);
  //       }
  //     } catch (error) {
  //       console.warn("MintCharacterAction Error:", error);
  //     }
  //   };

  //   // UseEffect
  //   useEffect(() => {
  //     const { ethereum } = window;
  //     if (ethereum) {
  //       const provider = new ethers.providers.Web3Provider(ethereum);
  //       const signer = provider.getSigner();
  //       const gameContract = new ethers.Contract(
  //         CONTRACT_ADDRESS,
  //         Champion.abi,
  //         signer
  //       );

  //       /*
  //        * This is the big difference. Set our gameContract in state.
  //        */
  //       setGameContract(gameContract);
  //       console.log("bro?");
  //     } else {
  //       console.log("Ethereum object not found");
  //     }
  //   }, []);
  //   //end

  return (
    <div className="Staking">
      <Navbar></Navbar>
      <div className="main-container">
        <p id="starting-text">Staking Grounds</p>
        <p>
          Stake your champions to earn $EXP tokens to upgrade and have a strong
          champion for Arena play
        </p>
        <div className="staking-container nes-container is-dark">
          <p>Champions staked:{stakes}</p>
          <p>$EXP balance:420.00</p>
          <p>$EXP earned:0.00</p>
          <progress class="nes-progress" value="75" max="100"></progress>
          <div className="stake-buttons-container">
            <button
              className="nes-btn"
              id="stake-button"
              onClick={stakeChampion1}
            >
              Stake Champion
            </button>
            <button className="nes-btn" id="unstake-button">
              Unstake Champion
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}
