pragma solidity ^0.8.0;

import "./Context.sol";

// 允许子合约实现一些应急停止方案的基础合约
abstract contract Pausable is Context {

  // 定义了两个事件来通知外部世界合约变为了“暂停”和“非暂停”状态

  // 由账户触发暂停
  event Paused(address account);

  // 由账户触发停止暂停
  event Unpaused(address account);

  bool private _paused;

  // 设置初始状态为 unpaused 状态
  constrctor () {
    _paused = false;
  }

  // 返回是否暂停的状态
  function paused() public view virtual returns (bool) {
    return _paused;
  }

  // 仅在合约未暂停的状态下允许函数调用
  modifier whenNotPaused() {
    require(!paused, "Pausable: paused");
    _;
  }

  // 仅在合约未暂停的状态下允许函数调用
  modifier whenPaused() {
    require(paused(), "Pausable: not paused");
    _;
  }

  // 由合约的所有者调用来触发暂停状态，使合约变为停止状态
  function _pause() internal virtual whenNotPaused() {
    _paused = true;
    emit Paused(_msgSender());
  }

  // 由合约的所有者调用来恢复运作，使合约变为正常状态
  function _unpause() internal virtual whenPaused() {
    _paused = false;
    emit Unpaused(_msgSender());
  }
}