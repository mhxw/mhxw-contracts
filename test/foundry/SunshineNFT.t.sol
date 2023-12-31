// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity 0.8.18;

import "forge-std/Test.sol";
import { SunshineNFT } from "mhxw-contracts/contracts/core/SunshineNFT.sol";
import "openzeppelin-contracts/contracts/token/ERC721/IERC721Receiver.sol";

contract SunshineNFTTest is Test {
    using stdStorage for StdStorage;
    SunshineNFT private nft;
    address private constant OWNER =
        address(0x01f933904539Fe8662c48392ee31C0aFCf98758E);

    function setUp() public {
        nft = new SunshineNFT(
            OWNER,
            "SUNSHINE NFT",
            "SUN",
            "https://tb-api.tastybones.xyz/api/token/"
        );
    }

    function testFailNoMintPricePaid() public {
        nft.mintTo(address(1));
        vm.expectRevert("MintPriceNotPaid");
    }

    function testMintPricePaid() public {
        nft.mintTo{ value: 0.08 ether }(address(1));
    }

    function testFailMaxSupplyReached() public {
        uint256 slot = stdstore
            .target(address(nft))
            .sig("currentTokenId()")
            .find();
        bytes32 loc = bytes32(slot);
        bytes32 mockedCurrentTokenId = bytes32(abi.encode(10000));
        vm.store(address(nft), loc, mockedCurrentTokenId);
        nft.mintTo{ value: 0.08 ether }(address(1));
    }

    function testFailMintToZeroAddress() public {
        nft.mintTo{ value: 0.08 ether }(address(0));
    }

    function testNewMintOwnerRegistered() public {
        nft.mintTo{ value: 0.08 ether }(address(1));
        uint256 slotOfNewOwner = stdstore
            .target(address(nft))
            .sig(nft.ownerOf.selector)
            .with_key(1)
            .find();

        uint160 ownerOfTokenIdOne = uint160(
            uint256(
                (vm.load(address(nft), bytes32(abi.encode(slotOfNewOwner))))
            )
        );
        assertEq(address(ownerOfTokenIdOne), address(1));
    }

    function testBalanceIncremented() public {
        nft.mintTo{ value: 0.08 ether }(address(1));
        uint256 slotBalance = stdstore
            .target(address(nft))
            .sig(nft.balanceOf.selector)
            .with_key(address(1))
            .find();

        uint256 balanceFirstMint = uint256(
            vm.load(address(nft), bytes32(slotBalance))
        );
        assertEq(balanceFirstMint, 1);

        nft.mintTo{ value: 0.08 ether }(address(1));
        uint256 balanceSecondMint = uint256(
            vm.load(address(nft), bytes32(slotBalance))
        );
        assertEq(balanceSecondMint, 2);
    }

    function testSafeContractReceiver() public {
        Receiver receiver = new Receiver();
        nft.mintTo{ value: 0.08 ether }(address(receiver));
        uint256 slotBalance = stdstore
            .target(address(nft))
            .sig(nft.balanceOf.selector)
            .with_key(address(receiver))
            .find();

        uint256 balance = uint256(vm.load(address(nft), bytes32(slotBalance)));
        assertEq(balance, 1);
    }

    function testFailUnSafeContractReceiver() public {
        vm.etch(address(1), bytes("mock code"));
        nft.mintTo{ value: 0.08 ether }(address(1));
    }
}

contract Receiver is IERC721Receiver {
    function onERC721Received(
        address operator,
        address from,
        uint256 id,
        bytes calldata data
    ) external pure returns (bytes4) {
        operator;
        from;
        id;
        data;
        return this.onERC721Received.selector;
    }
}
