import React from 'react'
import { Link } from 'react-router-dom'
import './Navbar.css'

export default function Navbar() {
	return (
		<div className='Navbar'>
			<div className='container'>
				<Link className='title-link' to='/'>Chain Champions</Link>
				<div className='link-container'>
					<Link className='link' to='/'>Home</Link>
					<Link className='link' to='/arena'>Arena</Link>
					<Link className='link' to='/whitepaper'>Whitepaper</Link>
					<Link className='link' to='/staking'>Staking</Link>
				</div>
			</div>
		</div>
		
	)
}
