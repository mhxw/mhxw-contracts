// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity 0.8.18;

import { Address } from "openzeppelin-contracts/contracts/utils/Address.sol";
import { Strings } from "openzeppelin-contracts/contracts/utils/Strings.sol";
import { ERC721 } from "openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import { Ownable2Step } from "openzeppelin-contracts/contracts/access/Ownable2Step.sol";
import { Pausable } from "openzeppelin-contracts/contracts/security/Pausable.sol";
import { ReentrancyGuard } from "openzeppelin-contracts/contracts/security/ReentrancyGuard.sol";
import { PullPayment } from "openzeppelin-contracts/contracts/security/PullPayment.sol";
import { Strings } from "openzeppelin-contracts/contracts/utils/Strings.sol";
import { ISunshineNFT } from "../interfaces/ISunshineNFT.sol";

error MintPriceNotPaid();
error MaxSupply();
error MaxNum();
error WithdrawTransfer();

/**
 * @title Sunshine NFT
 * @author nft
 * @notice This contract is used to create a sunshine NFT.
 */
contract SunshineNFT is
    ERC721,
    Ownable2Step,
    Pausable,
    ReentrancyGuard,
    PullPayment,
    ISunshineNFT
{
    using Address for address;
    using Strings for uint256;
    uint256 public constant TOTAL_SUPPLY = 10_000;
    uint256 public currentTokenId;
    string public baseURI;

    constructor(
        address _owner,
        string memory _name,
        string memory _symbol,
        string memory _newBaseURI
    ) ERC721(_name, _symbol) {
        _transferOwnership(_owner);
        baseURI = _newBaseURI;
    }

    /*//////////////////////////////////////////////////////////////
                                 EXTERNAL
    //////////////////////////////////////////////////////////////*/

    function tokenURI(
        uint256 tokenId
    ) public view virtual override returns (string memory) {
        require(_ownerOf(tokenId) != address(0), "Token Not Exist");

        string memory baseURI_ = _baseURI();
        return
            bytes(baseURI_).length > 0
                ? string(abi.encodePacked(baseURI_, tokenId.toString()))
                : "";
    }

    function mint(uint256 num, address recipient) external nonReentrant {
        if (num > 10) {
            revert MaxNum();
        }
        for (uint256 i; i < num; ) {
            uint256 newTokenId = ++currentTokenId;
            if (newTokenId > TOTAL_SUPPLY) {
                revert MaxSupply();
            }
            _safeMint(recipient, newTokenId);
            unchecked {
                ++i;
            }
        }
    }

    /// @inheritdoc ISunshineNFT
    function pause(bool toPause) external override onlyOwner {
        if (toPause) {
            super._pause();
        } else {
            super._unpause();
        }
    }

    /**
     * @notice sets the new baseURI.
     * @param newBaseURI The baseURI.
     */
    function setBaseURI(string memory newBaseURI) external onlyOwner {
        baseURI = newBaseURI;
    }

    /*//////////////////////////////////////////////////////////////
                             PUBLIC
    //////////////////////////////////////////////////////////////*/

    /// @dev Overridden in order to make it an onlyOwner function
    function withdrawPayments(address payable payee) public override onlyOwner {
        super.withdrawPayments(payee);
    }

    /*//////////////////////////////////////////////////////////////
                          INTERNAL
    //////////////////////////////////////////////////////////////*/

    /**
     * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
     * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
     * by default, can be overridden in child contracts.
     */
    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    /**
     * @notice Transfers the sunshine nft.
     * @dev It requires the state to be unpaused
     * @param from The initial owner address.
     * @param to The recipient address.
     * @param id The nft id.
     */
    function _transfer(
        address from,
        address to,
        uint256 id
    ) internal override whenNotPaused {
        super._transfer(from, to, id);
    }
}
