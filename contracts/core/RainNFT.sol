// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity 0.8.18;

import { Address } from "openzeppelin-contracts/contracts/utils/Address.sol";
import { Strings } from "openzeppelin-contracts/contracts/utils/Strings.sol";
import { Pausable } from "openzeppelin-contracts/contracts/security/Pausable.sol";
import { ERC1155 } from "openzeppelin-contracts/contracts/token/ERC1155/ERC1155.sol";
import { ERC1155Burnable } from "openzeppelin-contracts/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";
import { ERC1155Supply } from "openzeppelin-contracts/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import { Ownable2Step } from "openzeppelin-contracts/contracts/access/Ownable2Step.sol";
import { ReentrancyGuard } from "openzeppelin-contracts/contracts/security/ReentrancyGuard.sol";
import { PullPayment } from "openzeppelin-contracts/contracts/security/PullPayment.sol";
import { Strings } from "openzeppelin-contracts/contracts/utils/Strings.sol";

error MintPriceNotPaid();
error MaxSupply();
error MaxNum();
error WithdrawTransfer();

/**
 * @title Rain NFT
 * @author nft
 * @notice This contract is used to create a rain NFT.
 */
contract RainNFT is
    Pausable,
    ERC1155,
    ERC1155Burnable,
    ERC1155Supply,
    Ownable2Step,
    ReentrancyGuard,
    PullPayment
{
    using Address for address;
    using Strings for uint256;

    constructor(
        address _owner,
        string memory _newBaseURI
    ) ERC1155(_newBaseURI) {
        _transferOwnership(_owner);
    }

    /*//////////////////////////////////////////////////////////////
                                 EXTERNAL
    //////////////////////////////////////////////////////////////*/

    function mint(
        address account,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public {
        _mint(account, id, amount, data);
    }

    function mintBatch(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) public {
        _mintBatch(to, ids, amounts, data);
    }

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    /*//////////////////////////////////////////////////////////////
                             PUBLIC
    //////////////////////////////////////////////////////////////*/


    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    /// @dev Overridden in order to make it an onlyOwner function
    function withdrawPayments(address payable payee) public override onlyOwner {
        super.withdrawPayments(payee);
    }

    /*//////////////////////////////////////////////////////////////
                         INTERNAL
    //////////////////////////////////////////////////////////////*/

    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal override(ERC1155, ERC1155Supply) whenNotPaused {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }
}
