const main = async () => {
  const fistBumpContractFactory = await hre.ethers.getContractFactory('FistBumpPortal');
  const fistBumpContract = await fistBumpContractFactory.deploy({
    value: hre.ethers.utils.parseEther('0.1'),
  });
  await fistBumpContract.deployed();
  console.log('Contract addy:', fistBumpContract.address);

  /*
   * Get Contract balance
   */
  let contractBalance = await hre.ethers.provider.getBalance(
    fistBumpContract.address
  );
  console.log(
    'Contract balance:',
    hre.ethers.utils.formatEther(contractBalance)
  );

   /*
   * Send Fist Bump
   */
   let fistBumpTxn = await fistBumpContract.bump('Heres a fist bump');
   await fistBumpTxn.wait();

   let fistBumpTxn2 = await fistBumpContract.bump('This is fist bump #2');
   await fistBumpTxn2.wait();

   /*
   * Get Contract balance to see what happened!
   */
  contractBalance = await hre.ethers.provider.getBalance(fistBumpContract.address);
  console.log(
    'Contract balance:',
    hre.ethers.utils.formatEther(contractBalance)
  );

  let allFistBumps = await fistBumpContract.getAllFistBumps();
  console.log(allFistBumps);
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();
