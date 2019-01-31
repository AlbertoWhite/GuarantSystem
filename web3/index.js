const MainCtrl = require('./MainCtrl');


MainCtrl.initMain()
.then(() => {
  console.log('init, wait for timeout');
  MainCtrl.registerManufacturer({
    ownerId: '0x0c00b627a3b2e3e09485ac41db5b47c9d29e6634',
    name: 'TestName'
  })
})



// setTimeout(()=> {
//   console.log('timeout', Object.keys(MainCtrl));
//   console.log(MainCtrl.registerManufacturer({
//     ownerId: '0x0c00b627a3b2e3e09485ac41db5b47c9d29e6634',
//     name: 'TestName'
//   }));

// }, 3000)

