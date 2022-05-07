import { url } from 'inspector';
import {useState, useEffect } from 'react'
function App() {

  const [hello, setHello] = useState<string | undefined>()
  
  useEffect(() => {
    fetch(`${process.env.REACT_APP_API_GATEWAY_ENDPOINT}` , {
      method: 'GET',
      headers: {
        Accept: "application/text"
      }
    }).then(data => {
      console.log("data:",data)
    })
  }, [])
  
  return (
    <div className="App">
      <h3>hello world2</h3>
    </div>
  );
}

export default App;
