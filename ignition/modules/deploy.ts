import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const ContractsModule = buildModule("ContractsModule", (m) => {

  const swap = m.contract("SwapFactory");

  const wtoken = m.contract("W3BToken");

  return { swap, wtoken};
});

export default ContractsModule;