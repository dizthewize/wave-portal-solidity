const main = async () => {
  const fistBumpContractFactory = await hre.ethers.getContractFactory('FistBumpPortal');
  const fistBumpContract = await fistBumpContractFactory.deploy();
  await fistBumpContract.deployed({
    value: hre.ethers.utils.parseEther('0.001'),
  });

  console.log('Contract addy:', fistBumpContract.address);
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
