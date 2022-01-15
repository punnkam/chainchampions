import './App.css';
import 'nes.css/css/nes.min.css';
import { BrowserRouter, Routes, Route } from 'react-router-dom';
import Navbar from './components/Navbar'

// pages imports
import Arena from './pages/Arena';
import Home from './pages/Home';
import Staking from './pages/Staking';
import Whitepaper from './pages/Whitepaper';

function App() {
  return (
    <div className="App">
      <BrowserRouter>
        <Routes>
<<<<<<< HEAD
          <Route path='/' element={<Home />} />
          <Route path='/arena' element={<Arena />} />
          <Route path='/staking' element={<Staking />} />
          <Route path='/whitepaper' element={<Whitepaper />} />
        </Routes>
      
        <a class="nes-btn" href="/">Random Button</a>
=======
          <Route path="/" element={<Home /> } />
          <Route path='/arena' element={<Arena />} />
          <Route path='/staking' element={<Staking />} />
          <Route path='/whitepaper' element={<Whitepaper />} />
        </Routes>  
>>>>>>> 418ba5b19c7d844b1b19f09cba1a4204e03ad1ec
      </BrowserRouter>
  </div>
  );
}

export default App;
