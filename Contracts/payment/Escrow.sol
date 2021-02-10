pragma solidity ^0.8.0;

import "../../access/Ownable.sol";
import "../../utils/Address.sol";

// 实现了资金的暂由第三方保管的功能的基础合约，为合约所有者提供了 deposi/withdraw 函数来对特定的地址进行付款转账
contract Escrow is Ownable {

  // 保存向特定收款人支付的资金，直到他们取回这些款项
  // 使用托管模式的合约应该是这个托管合约的所有者，并提供一些 public 函数来间接使用托管合约的充值和取款功能
  
  using Address for address payable;

  // 充值事件
  event Deposited(address indexed payee, uint256 weiAmount);
  // 取款事件
  event Withdrawn(address indexed payee, uint256 weiAmount);

  // 保存了一个取款人地址到其取款金额的映射
  mapping(address => uint256) private _deposits;

  function depositOf(address payee) public view returns (uint256) {
    return _deposits[payee];
  }

  // 接受转账并保存要取款的功能
  function deposit(address payee) public payable virtual onlyOwner {
    uint256 amount = msg.value;
    _deposits[payee] = _deposits[payee] + amount;
    emit Deposited(payee, amount);
  }

  // 向取款人地址转出其应得的地址
  function withdraw(address payable payee) public virtual onlyOwner {
    uint256 payment = _deposits[payee];
    _deposits[payee] = 0;
    payee.sendValue(payment);
    emit Withdrawn(payee, payment);
  }
}