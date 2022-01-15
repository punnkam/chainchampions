import React from 'react'
import { Link } from 'react-router-dom'
import styled from 'styled-components'
import './Navbar.css'

const Divider = styled.hr`
	border-top: 3px dashed black;
	width: 100%;
`;


export default function Navbar() {
	return (
		<div className='Navbar'>
			<div className='container'>
				<Link className='title-link' to='/'>Chain Champions</Link>
				<div className='link-container'>
					<Link className='link' to='/'>Home</Link>
					<Link className='link' to='/'>Arena</Link>
					<Link className='link' to='/'>Whitepaper</Link>
					<Link className='link' to='/'>Staking</Link>
				</div>
			</div>
			<Divider />
		</div>
		
	)
}
