const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("NftCollection", function () {
  let nft;
  let admin;
  let user1;
  let user2;

  beforeEach(async function () {
    [admin, user1, user2] = await ethers.getSigners();

    const NftCollection = await ethers.getContractFactory("NftCollection");
    nft = await NftCollection.deploy(
      "Test NFT",
      "TNFT",
      10,
      "https://example.com/metadata/"
    );

    await nft.waitForDeployment();

  });

  it("should set correct name, symbol, and admin", async function () {
    expect(await nft.name()).to.equal("Test NFT");
    expect(await nft.symbol()).to.equal("TNFT");
    expect(await nft.admin()).to.equal(admin.address);
  });

  it("admin should mint NFT successfully", async function () {
    await nft.safeMint(user1.address, 1);

    expect(await nft.ownerOf(1)).to.equal(user1.address);
    expect(await nft.balanceOf(user1.address)).to.equal(1);
  });

  it("should not allow non-admin to mint", async function () {
    await expect(
      nft.connect(user1).safeMint(user1.address, 2)
    ).to.be.revertedWith("Only admin allowed");
  });

  it("should not mint duplicate tokenId", async function () {
    await nft.safeMint(user1.address, 1);

    await expect(
      nft.safeMint(user2.address, 1)
    ).to.be.revertedWith("Token already minted");
  });

  it("owner should transfer NFT", async function () {
    await nft.safeMint(user1.address, 1);

    await nft.connect(user1).transferFrom(
      user1.address,
      user2.address,
      1
    );

    expect(await nft.ownerOf(1)).to.equal(user2.address);
  });

  it("approved address should transfer NFT", async function () {
    await nft.safeMint(user1.address, 1);

    await nft.connect(user1).approve(user2.address, 1);

    await nft.connect(user2).transferFrom(
      user1.address,
      user2.address,
      1
    );

    expect(await nft.ownerOf(1)).to.equal(user2.address);
  });

  it("should return correct tokenURI", async function () {
    await nft.safeMint(user1.address, 1);

    const uri = await nft.tokenURI(1);
    expect(uri).to.equal("https://example.com/metadata/1");
  });
});
