pragma solidity ^0.8.0;
import "../math/SafeMath.sol";
import "../math/Math.sol";

library Array {
    // 找出数组中的最大值和所在的索引
    function maxInArray(uint256[] storage array)
        internal
        view
        returns (uint256 maxValue, uint256 maxIndex)
    {
        // 先设置默认的最大值和最大值的索引
        maxValue = array[0];
        maxIndex = 0;
        for (uint256 i = 0; i < array.length; i++) {
            if (array[i] > maxValue) {
                // 交换
                maxValue = array[i];
                maxIndex = i;
            }
        }
    }

    // 找出数组中的最小值和所在的索引
    function minInArray(uint256[] storage array)
        internal
        view
        returns (uint256 minValue, uint256 minIndex)
    {
        minValue = array[0];
        minIndex = 0;
        for (uint256 i = 0; i < array.length; i++) {
            if (array[i] < minValue) {
                minValue = array[i];
                minIndex = i;
            }
        }
    }

    // 寻找第一处出现该元素的位置 index
    function firstIndexOf(uint256[] storage array, uint256 key)
        internal
        view
        returns (bool, uint256)
    {
        if (array.length == 0) {
            return (false, 0);
        }

        for (uint256 i = 0; i < array.length; i++) {
            if (array[i] == key) {
                return (true, i);
            }
        }
        return (false, 0);
    }

    // 根据 index 移除元素
    function removeByIndex(uint256[] storage array, uint256 index) internal {
        require(index < array.length, "ArrayUtils: index out of bounds");

        while (index < array.length - 1) {
            array[index] = array[index + 1];
            index++;
        }
        array.length--;
    }

    // 根据 value 来移除某个存在于数组中的元素
    function removeByValue(uint256[] storage array, uint256 value) internal {
        uint256 index;
        bool isInArray;
        (isInArray, index) = firstIndexOf(array, value);
        if (isInArray) {
            removeByIndex(array, index);
        }
    }

    // 添加 value 到数组中
    function addValue(uint256[] storage array, uint256 value) internal {
        uint256 index;
        bool isInArray;
        (isInArray, index) = firstIndexOf(array, value);
        // 如果不存在于数组中
        if (!isInArray) {
            array.push(value);
        }
    }

    // 数组反转逆置
    function reverse(uint256[] storage array) internal {
        uint256 temp;
        for (uint256 i = 0; i < array.length / 2; i++) {
            temp = array[i];
            array[i] = array[array.length - 1 - i];
            array[array.length - 1 - i] = temp;
        }
    }

    // 将两个数组合并扩容
    function extend(uint256[] storage a, uint256[] storage b) internal {
        if (b.length != 0) {
            for (uint256 i = 0; i < b.length; i++) {
                a.push(b[i]);
            }
        }
    }

    // 判断两个数组是否完全相同
    function equals(uint256[] storage a, uint256[] storage b)
        internal
        view
        returns (bool)
    {
        if (a.length != b.length) {
            return false;
        }

        for (uint256 i = 0; i < a.length; i++) {
            if (a[i] != b[i]) {
                return false;
            }
        }
        return true;
    }

    // 去除重复元素
    function distinct(uint256[] storage array)
        internal
        returns (uint256 length)
    {
        // 是否含有
        bool isContain;
        uint256 index;
        for (uint256 i = 0; i < array.length; i++) {
            isContain = false;
            index = 0;
            uint256 j = i + 1;
            for (; j < array.length; j++) {
                if (array[j] == array[i]) {
                    isContain = true;
                    index = i;
                    break;
                }
            }
            if (isContain) {
                for (j = index; j < array.length - 1; j++) {
                    array[j] = array[j + 1];
                }
                array.length--;
                i--;
            }
        }
        length = array.length;
    }

    // 二分查找法
    function binarySearch(uint256[] storage array, uint256 key)
        internal
        view
        returns (bool, uint256)
    {
        if (array.length == 0) {
            return (false, 0);
        }

        uint256 low = 0;
        uint256 high = array.length - 1;

        while (low <= high) {
            uint256 mid = Math.average(low, high);
            if (array[mid] == key) {
                return (true, mid);
            } else if (array[mid] > key) {
                high = mid - 1;
            } else {
                low = mid + 1;
            }
        }

        return (false, 0);
    }

    // 快排
    function quickSort(uint256[] storage array) internal {
        quickSort(array, 0, array.length - 1);
    }

    // 快速排序法
    function quickSort(
        uint256[] storage array,
        uint256 begin,
        uint256 end
    ) private {
        if (begin >= end || end == uint256(-1)) return;

        uint256 pivot = array[end];

        uint256 store = begin;
        uint256 i = begin;
        for (; i < end; i++) {
            if (array[i] < pivot) {
                uint256 tmp = array[i];
                array[i] = array[store];
                array[store] = tmp;
                store++;
            }
        }

        array[end] = array[store];
        array[store] = pivot;

        quickSort(array, begin, store - 1);
        quickSort(array, store + 1, end);
    }
}
