pragma solidity ^0.8.0;

// 帮助合约抵抗重入攻击
// 解除锁定状态的常数——用非零值来避免额外的 gas 消耗
abstract contract ReentrancyGuard {
  
  uint256 private constant _NOT_ENTERED = 1;
  uint256 private constant _ENTERED = 2;

  uint256 private _status;

  // 构造函数，默认为 _NOT_ENTERED 状态
  constructor () {
    _status = _NOT_ENTERED;
  }

  // 使用这个修改器 nonReentrant 来限制对某个函数的重入
  modifier nonReentrant() {
    require(_status != _ENTERED, "ReentrancyGuard : reentrant call");
    _status = _ENTERED;

    // _; 之后的代码表示函数体中无论是否出现异常终止，都会执行
    _;

    _status = _NOT_ENTERED;
  }
}