pragma solidity ^0.8.0;

import "../utils/Context.sol";

// 归属权合约
// 这个合约包含了一个拥有者的地址，并提供了基础的授权管理功能
abstract contract Ownable is Context {
  address private _owner;

  // 将 address 类型的参数声明为 indexed，是为了方便外部程序可以直接判断给定的地址是否满足了特定条件
  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  // 通过构造函数将创建合约的消息发送者设置为合约的所有者
  constructor () {
    address msgSender = _msgSender();
    _owner = msgSender;
    emit OwnershipTransferred(address(0), msgSender);
  }

  // 返回当前拥有者的地址
  function owner() public view virtual returns (address) {
    return _owner;
  }

  // 如果调用者不是合约的所有者，则抛出错误
  modifier onlyOwner() {
    require(owner() == _msgSender(), "Ownable: caller is not the owner");
    _;
  }

  // 允许当前的拥有者放弃合约的控制权，放弃合约会使合约没有主人，就不能再调用声明为 onlyOwner 的函数
  function renounceOwnership() public virtual onlyOwner {
    // 通知外界所有者放弃了对合约的所有权
    emit OwnershipTransferred(_owner, address(0));
    // 将合约的持有人设置为 0 地址，就意味着没有人能够再调用声明该函数
    _owner = address(0);
  }

  // 允许当前的持有者将合约的控制权转移到新的所有者
  function transferOwnership(address newOwner) public virtual onlyOwner {
    require(newOwner != address(0), "Ownable: new owner is the zero address");
    // 通知外部世界，合约的所有权发生了转变
    emit OwnershipTransferred(_owner, newOwner);
    _owner = newOwner;
  }
}
