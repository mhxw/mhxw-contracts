import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "hardhat-contract-sizer";
import "hardhat-preprocessor";
import "hardhat-deploy";
import fs from "fs";
import * as dotenv from "dotenv";

dotenv.config();

const config: HardhatUserConfig = {
  namedAccounts: {
    deployer: 0,
  },
  contractSizer: {
    alphaSort: true,
    runOnCompile: false,
    disambiguatePaths: false,
  },
  paths: {
    artifacts: "./artifacts",
    sources: "./contracts",
    cache: "./cache_hardhat",
  },
  networks: {
    hardhat: {},
    polygon_mumbai: {
      url: "https://rpc.ankr.com/polygon_mumbai",
      chainId: 80001,
      accounts: [process.env.PRIVATE_KEY as string],
    },
    arb_goe: {
      url: "https://arbitrum-goerli.publicnode.com",
      accounts: [process.env.PRIVATE_KEY as string],
    },
  },
  solidity: {
    version: "0.8.18",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  etherscan: {
    apiKey: {
      polygonMumbai: process.env.POLYGON_MUMBAI_API_KEY ?? "",
      arbitrumGoerli: process.env.ARBITRUM_GOERLI_API_KEY ?? "",
    },
  },
  preprocess: {
    eachLine: (hre: any) => ({
      transform: (line: string) => {
        if (line.match(/^\s*import /i)) {
          getRemappings().forEach(([find, replace]) => {
            // this matches all occurrences not just the start of import which could be a problem
            if (line.match(find)) {
              line = line.replace(find, replace);
            }
          });
        }
        return line;
      },
    }),
  },
};
function getRemappings() {
  return fs
    .readFileSync("remappings.txt", "utf8")
    .split("\n")
    .filter(Boolean) // remove empty lines
    .map((line) => line.trim().split("="));
}

export default config;
