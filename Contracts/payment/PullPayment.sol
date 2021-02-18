pragma solidity ^0.8.0;

import "./Escrow.sol";

// 由付款人先将应付的金额充值到托管合约里，而后收款人可以随时调用 withdrawPayments 函数来获得其可以取回的所有资金

// “取回”模式支付的基础合约，通过这个合约，付款方可以向收款方提供异步的付款服务
abstract contract PullPayment {
  Escrow private _escrow;

  constructor () {
    _escrow = new Escrow();
  }

  // 由取款人调用的取回番薯，可以取回累计的可提取余额
  function withdrawPayments(address payable payee) public virtual {
    _escrow.withdraw(payee);
  }

  // 返回某个地址可取回的余额
  function payments(address dest) public view returns (uint256) {
    return _escrow.depositOf(dest);
  }

  // 付款人调用此函数将应付的金额保存到托管合约，以供取款人取回
  function _asyncTransfer(address dest, uint256 amount) internal virtual {
    _escrow.deposit{ value: amount }(dest);
  }
}