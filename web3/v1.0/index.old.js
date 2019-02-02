const MainCtrl = require('./MainCtrl');


MainCtrl.initMain()
.then(() => {
  console.log('init, wait for timeout');
  // MainCtrl.MainInstance.allEvents((e, d) => {
  //   console.lor(e, d);
  // })
  return MainCtrl.callTest();
  return MainCtrl.registerManufacturer({
    ownerId: '0xB8a760532Ef384C6f90d95812A4Ae01DAAEfb341',
    name: 'TestName'
  })
})
.then(d => {
  console.log('data: ',d.toString());
})

// manufacturer 1 address 0x6058c18bdf1be89f3be4ffa43c28cb67aef372b83fa7b955560a9d46311d8236



// setTimeout(()=> {
//   console.log('timeout', Object.keys(MainCtrl));
//   console.log(MainCtrl.registerManufacturer({
//     ownerId: '0x0c00b627a3b2e3e09485ac41db5b47c9d29e6634',
//     name: 'TestName'
//   }));

// }, 3000)

