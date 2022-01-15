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
        <header className="App-header">
          <Navbar/>
        </header>

        <Routes>
          <Route path='/arena' element={<Arena />} />
          <Route path='/staking' element={<Staking />} />
          <Route path='/whitepaper' element={<Whitepaper />} />
        </Routes>  
      
        <a class="nes-btn" href="/">Random Button</a>
      </BrowserRouter>
  </div>
  );
}

export default App;
