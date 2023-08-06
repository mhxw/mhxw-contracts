import { DeployFunction } from "hardhat-deploy/types";
import { verify } from "../helper-functions";
import { HardhatRuntimeEnvironment } from "hardhat/types";

const func: DeployFunction = async (hre: HardhatRuntimeEnvironment) => {
  const { deployments, getNamedAccounts, network } = hre;
  const { deploy, log } = deployments;

  const { deployer } = await getNamedAccounts();
  let name = "Sunshine NFT";
  let symbol = "SUN";
  let baseURI = "https://tb-api.tastybones.xyz/api/token/";
  const sunshineNFTInterface = await deploy("SunshineNFT", {
    from: deployer,
    log: true,
    args: [deployer, name, symbol, baseURI],
  });

  log(`deployed to ${sunshineNFTInterface.address} on ${network.name}`);

  await verify(sunshineNFTInterface.address, [deployer, name, symbol, baseURI]);
};

export default func;
func.tags = [`SunshineNFT`];
