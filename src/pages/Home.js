import React from 'react';
import './Home.css'
import Navbar from '../components/Navbar'

// png imports; these pngs are placeholders to be replaced by more interesting sample nfts
import Boy from '../images/Base.png';
import RustyAxe from '../images/rusty_axe.png';
import Sword from '../images/long_metal_sword_or_blue_steel.png'

export default function Home() {
    return (
        <div className='Home'>
            <Navbar></Navbar>
            <div class="main-container">
                <div class="welcome-container">
                    <div class="welcome-text-and-images">
                        <div class="welcome-text-container">
                            <h2>Welcome to Chain Champions!</h2>
                            <h5>Chain Champions is a collection of...Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla id quam dapibus, dictum tortor sit amet, feugiat enim. Vivamus eu convallis nisl. Aenean suscipit pulvinar felis non sodales. Donec cursus mattis lorem nec varius. Vivamus tincidunt, lacus ut consectetur volutpat, mi justo tristique dui, ut hendrerit ex mi nec turpis. Phasellus at laoreet augue, sit amet vestibulum magna. Quisque mattis nisi a nunc porta, ut ullamcorper enim facilisis. Aenean tempus erat turpis, in suscipit lorem ultrices quis. Nulla imperdiet feugiat sapien eu rutrum.</h5>
                        </div>
                        <div class="welcome-images-container">
                            <img src={Boy} alt='Boy' class="nft-img"/>
                            <img src={Boy} alt='Boy' class="nft-img"/>
                            <img src={Boy} alt='Boy' class="nft-img"/>
                        </div>
                    </div>
                    <div class="collect-a-champion"></div>
                </div>
                <div class="team-container">
                </div>
            </div>
        </div>
    )
}