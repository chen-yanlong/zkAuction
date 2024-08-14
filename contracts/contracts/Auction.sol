//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.8.0;

import "@zk-kit/incremental-merkle-tree.sol/IncrementalBinaryTree.sol";

interface IVerifier {
    function verifyProof(
        uint256[2] memory a,
        uint256[2] memory b,
        uint256[2] memory c,
        uint256[3] memory publicSignals
    ) external view returns (bool r);
}

contract Auction {
    using IncrementalBinaryTree for IncrementalTreeData;

    struct Proof {
        uint256[2] a;
        uint256[2][2] b;
        uint256[2] c;
    }

    event TreeCreated(bytes32 id, uint256 depth);
    event LeafInserted(uint256 leaf, uint256 root);
    event Start(uint256 startTime, uint256 endTime);
    event Bid(address bidder, uint256 encryptedData);
    event End();
    event Tally(address winner);

    address _owner;

    // auction param
    bool public started;
    bool public ended;
    address public winner;
    uint256 public duration;
    uint256 public endTime;

    //merkle tree
    mapping(uint256 => address) public bidder; 
    mapping(uint256 => uint256) public leaves; 
    uint256 public leafCount = 0;
    uint256 public root;
    IncrementalTreeData public tree;

    //verifier
    address public immutable verifier;
    

    constructor(address verifier_, uint256 duration_, uint256 treeDepth_) {
        tree.init(treeDepth_, 0);
        
        verifier = verifier_;
        _owner = msg.sender;
        duration = duration_;
    }

    function start() external {
        require(!started, "Auction has already started.");
        require(msg.sender == _owner, "Only creator can start.");

        started = true;
        endTime = block.timestamp + duration;

        emit Start(block.timestamp, endTime);
    }

    function bid(uint256 _encryptedBid) public {
        require(block.timestamp < endTime, "Bidding time has ended.");
        bidder[leafCount] = msg.sender;
        leaves[leafCount] = _encryptedBid;
        leafCount++;
        tree.insert(_encryptedBid); 
        emit Bid(msg.sender, _encryptedBid);
        emit LeafInserted(_encryptedBid, tree.root);
    }


    function endAuction() public returns (uint256){
        require(block.timestamp >= endTime, "Bidding time not yet ended.");
        require(!ended, "Auction already ended.");
        
        root = tree.root;
        ended = true;
        emit End();
        return root;
    }


    // function tally(uint256[3] memory publicSignals, Proof memory proof, uint256 winnerIdx) public {
    //     require(msg.sender == _owner, "Only owner can tally.");
    //     bool result = IVerifier(verifier).verifyProof(
    //         proof.a,
    //         proof.b,
    //         proof.c,
    //         publicSignals
    //     );
        
    //     require(result == true, "Invalid proof.");

    //     winner = bidder[winnerIdx];
    // }


}
