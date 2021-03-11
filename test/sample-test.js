const { expect } = require("chai");

describe("MemArray", function() {
  it("demo of MemArray", async function() {
    const UseMemArray = await ethers.getContractFactory("UseMemArray");
    const useMemArray = await UseMemArray.deploy();
    
    await useMemArray.deployed();
    await useMemArray.demo();
    /*expect(await greeter.greet()).to.equal("Hello, world!");

    await greeter.setGreeting("Hola, mundo!");
    expect(await greeter.greet()).to.equal("Hola, mundo!");*/
  });
});
