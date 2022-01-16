import React from 'react';
import './Staking.css'
import Navbar from '../components/Navbar'
import 'nes.css/css/nes.min.css';
export default function Staking() {
    return (
        <div className='Staking'>
            <Navbar></Navbar>
            <div className='main-container'>
                <p>Staking Grounds</p>
                <p>Stake your champions to earn $EXP tokens to upgrade and have a strong champion for Arena play</p>
                <div className='staking-container nes-container is-dark'>
                    <p>Champions staked:2</p>
                    <p>$EXP balance:420.00</p>
                </div>
            </div>
        </div>
    )
}