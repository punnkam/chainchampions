import React, { useState } from 'react'
import './style/Navbar.css'
import { NavLink } from 'react-router-dom'


const Navbar = () => {
    const [click, setClick] = useState(false);

    const handleClick = () => setClick(!click);

    return (
        <>
            <nav className="navbar">
                <div className="nav-container ">
                    <NavLink exact to="/" className="nav-logo nes-container is-dark">
                        ChainChampions
                    </NavLink>

                     <ul className={click ? "nav-menu active" : "nav-menu"}>
                        <li className="nav-item nes-container is-dark">
                            <NavLink
                                exact
                                to="/"
                                activeClassName="active"
                                className="nav-links"
                                onClick={handleClick}
                            >
                                HOME
                            </NavLink>
                        </li>
                         <li className="nav-item nes-container is-dark">
                            <NavLink
                                exact
                                to="/team"
                                activeClassName="active"
                                className="nav-links"
                                onClick={handleClick}
                            >
                                TEAM
                            </NavLink>
                        </li>
                            <li className="nav-item nes-container is-dark">
                            <NavLink
                                exact
                                to="/whitepaper"
                                activeClassName="active"
                                className="nav-links"
                                onClick={handleClick}
                            >
                                WHITEPAPER
                            </NavLink>
                        </li>
                        <li className="nav-item nes-container is-dark">
                            <NavLink
                                exact
                                to="/roadmap"
                                activeClassName="active"
                                className="nav-links"
                                onClick={handleClick}
                            >
                               ROADMAP
                            </NavLink>
                        </li>
                        <i class="nes-icon twitter is-large"></i>
                        <i class="nes-icon twitter is-large"></i>
                        <i class="nes-icon twitter is-large"></i>

                     </ul>
                    <div className="nav-icon" onClick={handleClick}>
                        <i className={click ? "fas fa-times" : "fas fa-bars"}></i>
                    </div>
                </div>
            </nav>
        </>
  )
}

export default Navbar;