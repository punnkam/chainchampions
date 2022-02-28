import './App.css';
import 'nes.css/css/nes.min.css';
import { BrowserRouter, Routes, Route } from 'react-router-dom'

import Home from './pages/Home';
import Team from './pages/Team';
import Whitepaper from './pages/Whitepaper';
import Roadmap from './pages/Roadmap';

function App() {
  return (
    <BrowserRouter>
        <Routes>
          <Route path="/" element={<Home />}/>
          <Route path="/team" element={<Team/>}/>
          <Route path="/whitepaper" element={<Whitepaper />}/>
          <Route path="/roadmap" element={<Roadmap/>}/>
        </Routes>  
      </BrowserRouter>
  );
}

export default App;
