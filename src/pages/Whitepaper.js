import React from 'react';
import './Whitepaper.css'
import Navbar from '../components/Navbar'

export default function Whitepaper() {
    return (
        <div className='Whitepaper'>
            <Navbar></Navbar>
            <div className='whitepaper-container'>
                <div className='text-container nes-container is-dark'>
                        <p> Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla id quam dapibus. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla id quam dapibus.</p>
                </div>
                <div className='text-container nes-container is-dark'>
                        <p> Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla id quam dapibus.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla id quam dapibus.</p>
                </div>
            </div>
        </div>
    )
}