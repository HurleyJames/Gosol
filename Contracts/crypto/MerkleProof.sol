pragma solidity ^0.8.0;

// 用来进行 Merkle 验证的库
// Merkle 树是一个二叉树，所有分支节点（包括根节点）都有且最多有两个子节点
// 分支节点的数值等于两个子节点的数值的哈希值（将两个子节点的数值连接为一个数值再进行哈希运算，连接的时候将较小的节点数据放在前面）
library MerkleProof {
  // 用来验证某个节点确实存在于一个 Merkle 树中，这里假设每对叶节点都是已经排序的
  // 证明某个数据包含了 Merkle 树中从叶节点到根节点所经过的所有分支之上的兄弟节点的哈希值

  function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
    // 叶子节点的哈希值
    bytes32 computedHash = leaf;

    for (uint256 i = 0; i < proof.length; i++) {
      // 从根节点到叶节点所经过的路径上的所有分支节点的哈希值
      bytes32 proofElement = proof[i];

      if (computedHash <= proofElement) {
        // 将较小的节点数值放在前面
        computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
      } else {
        computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
      }
    }

    // 检查计算结果是否与给定的根节点的哈希值相同
    return computedHash == root;
  }
}