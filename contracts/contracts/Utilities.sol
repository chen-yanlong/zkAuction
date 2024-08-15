//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.8.0;
import { PoseidonT5 } from "./PoseidonT5.sol";


contract Utilities {

    struct Message {
        uint256[4] data;
    }

    function hashMessage(
        Message memory _message
    ) public pure returns (uint256 msgHash) {

        uint256[4] memory n;
        n[0] = _message.data[0];
        n[1] = _message.data[1];
        n[2] = _message.data[2];
        n[3] = _message.data[3];

        msgHash = hash4(n);
    }

    function hash4(uint256[4] memory array) public pure returns (uint256 result) {
        result = PoseidonT5.hash(array);
    }
}