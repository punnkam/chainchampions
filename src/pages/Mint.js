import React, { useState } from 'react';
import './Mint.css';
import Navbar from '../components/Navbar';

export default function Mint() {
    // to be changed based on chain data
    const [mints, setMintsLeft] = useState(0);
    const totalMints = 1000;

    // todo: disable mint button once mints === totalMints

    const mintNFT = () => {
        setMintsLeft(mints + 1);
    }

    return (
        <div class='Mint'>
            <Navbar />
            <div class="mint-container">
                <div class="mint-text nes-container is-dark">
                    <h1>Mint a Chain Champion!</h1>
                    <p>{mints} / {totalMints} at xyz ETH each</p>
                </div>
                <progress class="nes-progress is-pattern" value={totalMints} value={mints} max="100"></progress>
                <button type="button" class="nes-btn" onClick={mintNFT}>Mint</button>
            </div>
        </div>
    );
}