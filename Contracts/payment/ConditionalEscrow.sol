pragma solidity ^0.8.0;

import "./Escrow.sol";

// 这是一个对托管（Escrow）合约的简单拓展，增加了可以给取款设定约束条件的特性
// 仅当特定条件满足时才允许取回的基础托管合约
abstract contract ConditionalEscrow is Escrow {
  
  // 返回一个地址是否被允许取回其款项，由子合约来具体实现
  function withdrawAllowed(address payee) public view virtual returns (bool);

  function withdraw(address payable payee) public virtual override {
    // 添加了 withdrawAllowed 这个限定条件的函数的检查
    require(withdrawAllowed(payee), "ConditionalEscrow: payee is not allowed to withdraw");
    super.withdraw(payee);
  }
}