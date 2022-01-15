import React from 'react';
import './Arena.css'
import Navbar from '../components/Navbar'
import Champ from '../images/long_metal_sword_or_blue_steel.png'
export default function Arena() {
    return (
        <div className='Arena'>
            <Navbar></Navbar>
            <div className='main-container'>
                <div className='arena-container-1'>
                    <div className='user-container'>
                        <div className='row-1'>
                            <p>Your champs</p>
                            <div className='champs-container'>
                                <img src={Champ} alt='champ'></img>
                                <img src={Champ} alt='champ'></img>
                                <img src={Champ} alt='champ'></img>
                            </div>
                        </div>
                        <div className='row-2'>

                        </div>
                    </div>
                    <div className='arena-desktop-container'>

                    </div>
                    <div className='stats-container'>

                    </div>
                </div>
                <div className='arena-container-2'>
                    <div className='arena-mobile-container'>

                    </div>
                </div>
            </div>
        </div>
    )
}