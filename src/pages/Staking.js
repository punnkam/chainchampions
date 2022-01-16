import React from 'react';
import './Staking.css'
import Navbar from '../components/Navbar'
import 'nes.css/css/nes.min.css';
export default function Staking() {
    return (
        <div className='Staking'>
            <Navbar></Navbar>
            <div className='main-container'>
                <p id='starting-text'>Staking Grounds</p>
                <p>Stake your champions to earn $EXP tokens to upgrade and have a strong champion for Arena play</p>
                <div className='staking-container nes-container is-dark'>
                    <p>Champions staked:2</p>
                    <p>$EXP balance:420.00</p>
                    <p>$EXP earned:0.00</p>
                    <progress class="nes-progress" value="75" max="100"></progress>
                    <div className='stake-buttons-container'>
                        <button className='nes-btn' id='stake-button'>Stake Champion</button>
                        <button className='nes-btn' id='unstake-button'>Unstake Champion</button>
                    </div>
                </div>
            </div>
        </div>
    )
}