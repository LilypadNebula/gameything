import React from 'react'
import axios from 'axios'
import Rails from 'rails-ujs'
axios.defaults.headers['x-csrf-token'] = Rails.csrfToken()

const App = () => {

  const doThing = async () => {
    let temp = await axios.post('/users',{user:{email:'test@testing.com',password:'qwerty',confirmation:'qwerty'}})
    console.log(temp)
  }

  return (
    <button onClick={doThing}>Do thing</button>
  )
}

export default App