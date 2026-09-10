// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "./V4.sol";
import "./ExamBase.sol";

// =============================================================================
// TASK 2. Three things to fill in.
// Opens your pool at the starting price on the parameter list.
//
// MOCK. The real exam names these variables differently and its event carries a
// different set of fields. The ideas are the same, the text is not.
// =============================================================================

contract Task2Pool is ExamBase {
    /// @notice The two starting prices from the parameter list.
    /// @dev One for each way the pool might sort your two tokens.
    uint160 public immutable sqrtPriceIfTokenALower;
    uint160 public immutable sqrtPriceIfTokenBLower;

    event PoolReady(
        bytes32 poolId,
        address currency0,
        address currency1,
        uint160 sqrtPriceX96,
        int24 tick
    );

    constructor(
        address _poolManager,
        address _tokenA,
        address _tokenB,
        uint24 _fee,
        int24 _tickSpacing,
        uint160 _sqrtPriceIfTokenALower,
        uint160 _sqrtPriceIfTokenBLower
    ) ExamBase(_poolManager, _tokenA, _tokenB, _fee, _tickSpacing) {
        sqrtPriceIfTokenALower = _sqrtPriceIfTokenALower;
        sqrtPriceIfTokenBLower = _sqrtPriceIfTokenBLower;
    }

    /// @notice The starting price that matches the way the pool actually sorted your tokens.
    function startingSqrtPriceX96() public view returns (uint160) {
        // TODO 2.1 --------------------------------------------------------
        // You were given two starting prices, because the pool sorts your two tokens
        // by address and you do not get to choose which one becomes currency0.
        //
        // The two immutables above are named after which token turned out to be the
        // lower address. ExamBase already works that out for you: alphaIsCurrency0()
        // returns true when your token A is the lower one.
        //
        // Return whichever of the two prices belongs to the sort order you actually got.
        // Replace the line below.

        if (currency0() == tokenA) {
            return sqrtPriceIfTokenALower;
        } else {
            return sqrtPriceIfTokenBLower;
        }
        // OR: return alphaIsCurrency0() ? sqrtPriceIfTokenALower : sqrtPriceIfTokenBLower;
    }

    /// @notice Opens the pool. You only ever call this once.
    function openPool() external returns (int24 tick) {
        require(
            !poolExists(),
            "this pool is already open, you only open it once"
        );

        PoolKey memory key = poolKey();
        uint160 startingPrice = startingSqrtPriceX96();
        require(
            startingPrice != 0,
            "startingSqrtPriceX96 still returns zero, finish TODO 2.1 first"
        );

        // TODO 2.2 --------------------------------------------------------
        // Open the pool.
        //
        tick = poolManager.initialize(key, startingPrice); // price = 1.0001^tick
        //
        // takes the pool key and the starting price, and hands back the tick the pool
        // opened at. That returned tick belongs in the variable below.
        // Replace the line below.

        // TODO 2.3 --------------------------------------------------------
        // Announce it, so the marker can see what you did. Emit PoolReady. Look at
        // its declaration near the top of this file for the fields it wants and the
        // order they go in, then supply:
        //
        //     the pool id, the two currencies in protocol order, the price you
        //     opened at, and the tick you just captured
        //
        // ExamBase gives you poolId(), currency0() and currency1().
        // Write one emit statement below.
        emit PoolReady(poolId(), currency0(), currency1(), startingPrice, tick);
    }
}
