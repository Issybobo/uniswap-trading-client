import { ethers } from "ethers";

async function main() {
  const owner = await ethers.getSigners();

  const btc = await ethers.deployContract("BTC", owner);
  await btc.waitForDeployment();
  const btcAddress = await btc.getAddress();
  console.log("BTC contract address: ", btcAddress);

  const usdc = await ethers.deployContract("USDC", owner);
  await usdc.waitForDeployment();
  const usdcAddress = await usdc.getAddress();
  console.log("USDC contract address: ", usdcAddress);

  const simpleswap = await ethers.deployContract("SimpleSwap", [btcAddress, usdcAddress, 1000, 10000]);
  await simpleswap.waitForDeployment();
  console.log("SimpleSwap contract address: ", await simpleswap.getAddress());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

