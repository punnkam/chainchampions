import './App.css';
import 'nes.css/css/nes.min.css';
import { BrowserRouter } from 'react-router-dom';
import Navbar from './components/Navbar'

function App() {
  return (
    <div className="App">
      <header className="App-header">
        <BrowserRouter>
          <Navbar/>  
        </BrowserRouter>
        
      </header>
      
      <a class="nes-btn" href="#">Random Button</a>

  </div>
  );
}

export default App;
