pragma solidity >= 0.5.0 < 0.7.0;

contract ProofOfExistence2 {
  constructor() public {
  }

  bytes32[] private proofs;

  function storeProof(bytes32 proof) public {
    proofs.push(proof);
  }

  function notarize(string memory document) public{
    bytes32 proof = proofFor(document);
    storeProof(proof);
  }

  function proofFor(string memory document) public pure returns (bytes32) {
    return sha256(abi.encode(document));
  }

  function checkDocument(string memory document) public view returns (bool) {
    bytes32 proof = proofFor(document);
    return hasProof(proof);
  }

  function hasProof(bytes32 proof) public view returns (bool) {
    for (uint256 i = 0; i < proofs.length; i++) {
      if (proofs[i] == proof) {
        return true;
      }
    }
    return false;
  }
}
