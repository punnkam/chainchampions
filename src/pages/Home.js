import React from 'react';
import { NavLink } from 'react-router-dom';
import './Home.css'
import Navbar from '../components/Navbar'

// png imports; these pngs are placeholders to be replaced by more interesting sample nfts
import Wizard from '../images/Wizard.png';
import Marksman from '../images/Marksman.png';
import Warrior from '../images/Warrior.png';

export default function Home() {
    return (
        <div className='Home'>
            <Navbar></Navbar>
            <div class="main-container">
                <div class="welcome-container">
                    <div class="welcome-text-container nes-container is-dark">
                        <h2>Welcome to Chain Champions!</h2>
                        <h5>Chain Champions is a collection of 8888 unique NFTs that live 
                            completely on the blockchain. Each Champion is made up of unique traits
                            which are used to determine their battle rating. Higher battle 
                            ratings give Champions a higher chance of winning battles (and Ether!) in the 
                            battle arena. The number of wins and the amount of Ether won ($$$) will be stored dynamically
                            within each Champion, making those records immutable for the rest of time. Get yourself
                            a Champion and start battling!

                        </h5>
                    </div>
                    <div class="welcome-images-container">
                        <img src={Wizard} alt='Boy' class="nft-img"/>
                        <img src={Warrior} alt='Boy' class="nft-img"/>
                        <img src={Marksman} alt='Boy' class="nft-img"/>
                    </div>
                    <div class="collect-a-champion nes-container is-dark">
                        <p class="nav-text">Get a champion here:</p>
                        <NavLink to="/mint">
                            <button type="button" class="nes-btn">Mint</button>
                        </NavLink>
                    </div>
                    
                </div>
            </div>
        </div>
    )
}