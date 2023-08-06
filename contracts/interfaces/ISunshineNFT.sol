// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity 0.8.18;

interface ISunshineNFT {
    /**
     * @notice Changes the pause state of the sunshine nft.
     * @param toPause The pause state.
     */
    function pause(bool toPause) external;
}
