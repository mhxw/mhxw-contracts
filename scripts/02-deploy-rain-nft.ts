import { ethers, network } from "hardhat";
import { verify } from "../helper-functions";

async function main() {
  const [deployer] = await ethers.getSigners();
  let name = "Rain NFT";
  let symbol = "RAIN";
  let baseURI =
    "https://dweb.link/ipfs/bafybeidssyny2hua4v4upxpt3d4j6kdluxb6nvhcvcsyqnralvrd3vavei/";
  const rainNFTContract = await ethers.getContractFactory(
    "RainNFT",
    deployer
  );
  console.log(deployer.address);
  const rainNFTInterface = await rainNFTContract.deploy(
    deployer.address,
    baseURI
  );
  await rainNFTInterface.waitForDeployment();

  console.log(`deployed to ${rainNFTInterface.target} on ${network.name} `);

  await verify(rainNFTInterface.target.toString(), [
    deployer.address,
    baseURI,
  ]);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
