pragma solidity ^0.8.0;

import "./Context.sol";

abstract contract Pausable is Context {

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

  // 当一个合约没有暂停，调用这个 modifier 函数
  modifier whenNotPaused() {
    require(!paused, "Pausable: paused");
    _;
  }

  // 当一个合约已暂停，调用这个 modifier 函数
  modifier whenPaused() {
    require(paused(), "Pausable: not paused");
    _;
  }

  // 触发暂停状态
  function _pause() internal virtual whenNotPaused() {
    _paused = true;
    emit Paused(_msgSender());
  }

  // 触发非暂停状态
  function _unpause() internal virtual whenPaused() {
    _paused = false;
    emit Unpaused(_msgSender());
  }
}