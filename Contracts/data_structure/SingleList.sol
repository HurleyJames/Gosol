pragma solidity ^0.8.0;

// 单链表
library SingleList {
    bytes32 private constant NULL = bytes32(0);

    struct ListNode {
        bytes32 next;
        bool exist;
    }

    struct List {
        mapping(bytes32 => ListNode) data;
        bytes32 head;
        bytes32 tail;
        uint256 size;
    }

    struct Iterate {
        bytes32 value;
        bytes32 prev;
    }

    function findNode(List storage self, bytes32 elem)
        internal
        returns (Iterate memory)
    {
        require(self.data[elem].exist, "the node is not exists");
    }

    // 往后一节点插入
    function insertNext(
        List storage self,
        Iterate memory iter,
        bytes32 elem
    ) internal {
        require(self.data[iter.value].exist, "the node is not exist");
        bytes32 next = self.data[iter.value].next;
        self.data[elem] = ListNode({next: next, exist: true});
        self.data[iter.value].next = elem;
        if (self.tail == iter.value) {
            self.tail = elem;
        }
        self.size++;
    }

    // 往前一节点插入
    function insertPrev(
        List storage self,
        Iterate memory iter,
        bytes32 elem
    ) internal {
        require(self.data[iter.value].exist, "the node is not exits");
        self.data[elem] = ListNode({next: iter.value, exist: true});
        self.data[iter.value].next = elem;
        if (self.head == iter.value) {
            self.head = elem;
        } else {
            require(self.data[iter.prev].exist, "the prev node is not exist");
            self.data[iter.prev].next = elem;
        }
        self.size++;
    }

    function addFirstNode(List storage self, bytes32 elem) private {
        ListNode memory node = ListNode({next: NULL, exist: true});
        self.data[elem] = node;
        self.head = elem;
        self.tail = elem;
    }

    // 获取头节点
    function getHead(List storage self) internal returns (bytes32) {
        require(self.size > 0, "the list is empty");
        return self.head;
    }

    // 获得尾节点
    function getTail(List storage self) internal returns (bytes32) {
        require(self.size > 0, "the list is empty");
        return self.tail;
    }

    // 空间大小
    function getSize(List storage self) internal view returns (uint256) {
        return self.size;
    }

    // 是否为空
    function isEmpty(List storage self) internal view returns (bool) {
        return self.size == 0;
    }

    // 是否存在
    function isExist(List storage self, bytes32 elem)
        internal
        view
        returns (bool)
    {
        return self.data[elem].exist;
    }

    // 下一个节点
    function nextNode(List storage self, Iterate memory iter)
        internal
        view
        returns (Iterate)
    {
        require(self.data[iter.value].exist, "the node is not exists");
        Iterate memory nextIter = Iterate({
            value: self.data[iter.value].next,
            prev: iter.value
        });
        return nextIter;
    }
}
