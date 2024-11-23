import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

const config: HardhatUserConfig = {
  solidity: "0.8.20",
  networks: {
    sepolia: {
      url: "", // your alchemy https
      accounts: [""], // your private key
      timeout: 180000
    }
  }
};

export default config;

