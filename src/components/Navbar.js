import React from 'react'
import { useRef } from 'react'
import { NavLink } from 'react-router-dom'
import './Navbar.css'
import 'nes.css/css/nes.min.css';


export default function Navbar() {
	const activeStyle = 
	{
		color: "gray"
	};

	const linkRef = useRef();
	console.log(linkRef.current);

	return (
		<div className='Navbar'>
			<div className='container'>
				<NavLink className='title-link' to='/'>Chain Champions</NavLink>
				<div className='link-container'>
					<NavLink className='link' style={({isActive}) =>
				isActive ? activeStyle : undefined} to='/'>Home</NavLink>
					<NavLink className='link' style={({isActive}) =>
				isActive ? activeStyle : undefined} to='/arena'>Arena</NavLink>
					<NavLink className='link' style={({isActive}) =>
				isActive ? activeStyle : undefined} to='/whitepaper'>Whitepaper</NavLink>
					<NavLink className='link' style={({isActive}) =>
				isActive ? activeStyle : undefined} to='/staking'>Staking</NavLink>
					<NavLink className='link' style={({isActive}) => 
				isActive ? activeStyle : undefined} to='/mint'>Mint</NavLink>
				</div>
				<button type='button' className='nes-btn' id='wallet-button'>Connect wallet</button>
			</div>
		</div>
	)
}
