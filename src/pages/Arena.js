import React from 'react';
import { useRef, useState, useEffect } from 'react'
import './Arena.css'
import Navbar from '../components/Navbar'
import Champ from '../images/long_metal_sword_or_blue_steel.png'
import 'nes.css/css/nes.min.css';

export default function Arena() {
    let joinRef = useRef();

    const [joinedState, setJoinedState] = useState(false)
    const [gameState, setGameState] = useState(false)

    useEffect(() => {
        setJoinedState(true)
        setGameState(false)
        gameOngoing(gameState, joinedState)
    }, [joinedState, gameState])

    const gameOngoing = (status, joined) =>
    {
        if(status)
        {
            joinRef.current.innerText = "Arena ongoing"
            joinRef.current.classList.add("is-disabled")
            return true;
        }
        else if(!joined)
        {
            joinRef.current.innerText = "Join Arena"
            joinRef.current.classList.remove('is-disabled')
            return false;
        }
        else if(joined)
        {
            joinRef.current.innerText = "Waiting for Arena to start"
            joinRef.current.classList.add("is-disabled")
            return true;
        }
    }

    return (
        <div className='Arena'>
            <Navbar></Navbar>
            <div className='main-container'>
                <div className='arena-container-1  nes-container is-dark'>
                    <div className='user-container'>
                        <p>Your champs</p>
                        <div className='champs-container'>
                            <img src={Champ} className='nes-pointer' alt='champ'></img>
                            <img src={Champ} className='nes-pointer' alt='champ'></img>
                            <img src={Champ} className='nes-pointer' alt='champ'></img>
                        </div>
                        <p>Max 3 champions</p> 
                    </div>
                    <div className='stats-container'>
                        <p>Stats</p>
                        <ul className='stats-list'>
                            {/* 3 functions to retrieve players , bounty, and game */}
                            <li className='stat'>game: #1</li>
                            <li className='stat'>total players left:100</li>
                            <li className='stat'>total bounty staked:5 Eth</li>
                        </ul>
                    </div>
                </div>
                <div className='arena-container-2'>
                    <p>Arena Status</p>
                    <button className='nes-btn' ref={joinRef}>Join Arena</button>
                </div>
            </div>
        </div>
    )
}