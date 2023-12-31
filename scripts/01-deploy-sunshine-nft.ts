import { ethers, network } from "hardhat";
import { verify } from "../helper-functions";

async function main() {
  const [deployer] = await ethers.getSigners();
  let name = "Sunshine NFT";
  let symbol = "SUN";
  let baseURI =
    "https://dweb.link/ipfs/bafybeidssyny2hua4v4upxpt3d4j6kdluxb6nvhcvcsyqnralvrd3vavei/";
  const sunshineNFTContract = await ethers.getContractFactory(
    "SunshineNFT",
    deployer
  );
  console.log(deployer.address);
  const sunshineNFTInterface = await sunshineNFTContract.deploy(
    deployer.address,
    name,
    symbol,
    baseURI
  );
  await sunshineNFTInterface.waitForDeployment();

  console.log(`deployed to ${sunshineNFTInterface.target} on ${network.name} `);

  await verify(sunshineNFTInterface.target.toString(), [
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
