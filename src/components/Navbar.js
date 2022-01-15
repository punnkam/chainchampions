import React from 'react'
import { Link } from 'react-router-dom'
import styled from 'styled-components'
import './Navbar.css'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { faBars } from '@fortawesome/free-solid-svg-icons'

const Container = styled.div`
	width: 100%;
	display: flex;
	flex-direction: row;
	align-items: center;
	justify-content: center;
`;

const StyledLink = styled(Link)`
	color: black;
	font-size: 1rem;
	// margin: 0.5rem;
	// margin-right: 3rem;
	&:hover {
		text-decoration: none;
		color: grey;
	}
`;

const Title = styled(Link)`
	color: black;
	font-size: 1.7rem;
	// margin-left: 2rem;
	// margin-right: 4rem;
	&:hover {
		text-decoration: none;
		color: black;
	}
`;

const Divider = styled.hr`
	border-top: 3px dashed black;
	width: 100%;
`;


export default function Navbar() {
	return (
		<div className='Navbar'>
			<Container>
				<Title to='/'>Chain Champions</Title>
				<FontAwesomeIcon icon={faBars} className='menu-icon'></FontAwesomeIcon>
				<div className='link-container'>
					<StyledLink to='/'>Home</StyledLink>
					<StyledLink to='/'>Arena</StyledLink>
					<StyledLink to='/'>Whitepaper</StyledLink>
					<StyledLink to='/'>Staking</StyledLink>
				</div>
			</Container>
			<Divider />
		</div>
		
	)
}
