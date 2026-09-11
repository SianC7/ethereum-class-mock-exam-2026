// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "./V4.sol";
import "./ExamBase.sol";

// =============================================================================
// TASK 3. Three things to fill in.
// Puts liquidity into the pool you opened in Task 2.
//
// This contract has to be holding your tokens before addLiquidity will work.
// The instructions tell you when to send them across.
//
// MOCK. The real exam splits its checks up differently and its event has a
// different name. Read what each gap asks for rather than recalling this one.
// =============================================================================

contract Task3Liquidity is ExamBase {
    using BalanceDeltaLibrary for BalanceDelta;

    IPoolModifyLiquidityTest public immutable liquidityRouter;

    event LiquidityProvided(
        bytes32 poolId,
        int24 tickLower,
        int24 tickUpper,
        int256 liquidityDelta,
        int256 amount0,
        int256 amount1
    );

    constructor(
        address _poolManager,
        address _liquidityRouter,
        address _tokenA,
        address _tokenB,
        uint24 _fee,
        int24 _tickSpacing
    ) ExamBase(_poolManager, _tokenA, _tokenB, _fee, _tickSpacing) {
        liquidityRouter = IPoolModifyLiquidityTest(_liquidityRouter);

        // Provided. The router takes the tokens out of this contract when you add
        // liquidity, so it needs permission to move them first.
        IERC20(_tokenA).approve(_liquidityRouter, type(uint256).max);
        IERC20(_tokenB).approve(_liquidityRouter, type(uint256).max);
    }

    /// @notice Adds liquidity between two ticks.
    function addLiquidity(
        int24 tickLower,
        int24 tickUpper,
        int256 liquidityDelta
    ) external returns (int256 amount0, int256 amount1) {
        require(
            poolExists(),
            "the pool is not open, run Task 2 first and check your constructor values match"
        );
        require(liquidityDelta > 0, "liquidity must be greater than zero");
        require(tickLower < tickUpper, "tickLower must be below tickUpper");

        int24 tickNow = currentTick();

        // TODO 3.1 --------------------------------------------------------
        // Both ticks have to sit on this pool's tick grid. The grid steps in units of
        // TICK_SPACING, so a tick is on the grid when dividing it by TICK_SPACING
        // leaves no remainder. The remainder operator in Solidity is %.
        //
        // One require, one condition, covering both ticks at once. Join the two
        // halves with &&.
        //
        // ExamBase stores it in a public immutable state variable called TICK_SPACING
        // (set in its constructor from _tickSpacing, see ExamBase.sol:37). Since Task3Liquidity inherits from ExamBase,
        // you can just reference it directly by name inside the contract — no getter call needed.
        require(
            (tickLower % TICK_SPACING == 0) && (tickUpper % TICK_SPACING == 0),
            "a tick is not a multiple of the tick spacing"
        );

        // TODO 3.2 --------------------------------------------------------
        // Liquidity only earns while the price sits inside your range, so the range
        // has to contain the live tick. That splits into two separate rules, and
        // each one gets its own require so the message tells you which end is wrong:
        //
        //     tickNow must be at or above tickLower
        bool lowerThan = tickNow >= tickLower;
        //     tickNow must be strictly below tickUpper
        bool higherThan = tickNow < tickUpper;
        //
        // Replace the two conditions marked below.

        require(lowerThan, "the live tick is below your range");
        require(higherThan, "the live tick is at or above your range");

        // TODO 3.3 --------------------------------------------------------
        // Ask the router to add the liquidity. The call looks like this:
        //
        //     liquidityRouter.modifyLiquidity(
        //         poolKey(),
        //         ModifyLiquidityParams({
        //             tickLower: tickLower,
        //             tickUpper: tickUpper,
        //             liquidityDelta: liquidityDelta,
        //             salt: bytes32(0)
        //         }),
        //         ""
        //     )
        //
        // It gives you back a BalanceDelta. Replace the line below with that call.

        BalanceDelta delta = liquidityRouter.modifyLiquidity(
            poolKey(),
            ModifyLiquidityParams({
                tickLower: tickLower,
                tickUpper: tickUpper,
                liquidityDelta: liquidityDelta,
                salt: bytes32(0)
            }),
            ""
        );

        // Provided. amount0 and amount1 come back negative, because the tokens left
        // this contract and went into the pool.
        amount0 = delta.amount0();
        amount1 = delta.amount1();
        emit LiquidityProvided(
            poolId(),
            tickLower,
            tickUpper,
            liquidityDelta,
            amount0,
            amount1
        );
    }
}
