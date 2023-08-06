import { ethers, network } from "hardhat";
import { verify } from "../helper-functions";

async function main() {
  const [deployer] = await ethers.getSigners();
  let name = "Sunshine NFT";
  let symbol = "SUN";
  let baseURI = "https://tb-api.tastybones.xyz/api/token/";
  const sunshineNFTInterface = await ethers.deployContract("SunshineNFT", [
    deployer.address.toString(),
    name,
    symbol,
    baseURI,
  ]);
  await sunshineNFTInterface.waitForDeployment();

  console.log(`deployed to ${sunshineNFTInterface.target} on ${network.name} `);

  await verify(sunshineNFTInterface.target, [
    deployer.address,
    name,
    symbol,
    baseURI,
  ]);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
