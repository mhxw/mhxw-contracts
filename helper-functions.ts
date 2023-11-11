import { network, run } from "hardhat";

export const verify = async (contractAddress: string, args: any[]) => {
  if (network.name != "hardhat") {
    console.log("Verifying contract...");

    await sleep(10000);
    try {
      await run("verify:verify", {
        address: contractAddress,
        constructorArguments: args,
      });
    } catch (e: any) {
      if (e.message.toLowerCase().includes("already verified")) {
        console.log("Already verified!");
      } else {
        console.log(e);
      }
    }
  }
};

export const sleep = (ms: number) => {
  return new Promise((resolve) => {
    setTimeout(resolve, ms);
  });
};

module.exports = {
  verify,
};
