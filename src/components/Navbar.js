import React from 'react'
import { Link } from 'react-router-dom'
import styled from 'styled-components'

const Container = styled.div`
	display: flex;
	flex-direction: row;
	justify-content: flex-start;
	margin: 1.5rem;
	margin-top: 2.5rem;
`;

const StyledLink = styled(Link)`
	color: black;
	font-size: 1rem;
	margin: 0.5rem;
	margin-right: 3rem;
	&:hover {
		text-decoration: none;
		color: grey;
	}
`;

const Title = styled(Link)`
	color: black;
	font-size: 1.7rem;
	margin-left: 2rem;
	margin-right: 4rem;
	&:hover {
		text-decoration: none;
		color: black;
	}
`;

const Divider = styled.hr`
	border-top: 3px dashed black;
`;


export default function Navbar() {
	return (
		<div>
			<Container>
				<Title to='/'>Chain Champions</Title>
				<StyledLink to='/'>Home</StyledLink>
				<StyledLink to='/'>Arena</StyledLink>
				<StyledLink to='/'>Whitepaper</StyledLink>
				<StyledLink to='/'>Staking</StyledLink>
			</Container>
			<Divider />
		</div>
		
	)
}
