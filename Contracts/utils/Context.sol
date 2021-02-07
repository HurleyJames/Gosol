pragma solidity ^0.8.0;

// 提供有关当前执行上下文的信息
abstract contract Context {

  // 交易的发件人，msg.sender 不应该直接被访问
  function _msgSender() internal view virtual returns (address) {
    return msg.sender;
  }

  // 交易的数据，msg.data 不应该直接被访问
  function _msgData() internal view virtual returns (bytes calldata) {
    this;
    return msg.data;
  }
}
