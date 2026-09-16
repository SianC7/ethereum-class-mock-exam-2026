# Written section, mock

Answer all five questions. **Maximum 120 words each.**

---

## Question 1 (5 marks)

State your `poolId` and list the exact values that produced it. Then explain what would have
happened if you had deployed (redeploy?) `Task3Liquidity` with a tick spacing of 60 instead of 200, everything else unchanged. Say what `poolId` would have done, and what the first failure would have been.

**Answer:**
- PoolId is `0x3506df81c3c8b3f3179c57703d39a08a7b6def1a5347d9875e43d1c3603d0833a`
Values that produced it: 
- tokenA: 0x5e17b14ADd6c386305A32928F985b29bbA34Eff5, 
- tokenB: 0xe2899bddFD890e320e643044c6b95B9B0b84157A, 
- fee: 3000, 
- tickSpacing: 200

With tickSpacing 60 instead of 200, the poolId would be different as tickSpacing is one of the fields used in making it. The first failure would be from requirement of poolExists() being true in the addLiquidity() function when trying to add liquidity to the pool. The failure message would be "the pool is not open, run Task 2 first and check your constructor values match".

---

## Question 2 (5 marks)

You put in 5 whole tokens of currency1. State which of your two tokens became currency0 and how you knew, the output you predicted, the output you actually received, and the arithmetic that got you from 5 to your prediction. Then split the difference between prediction and actual into the part that is fee and the part that is not, with numbers.

**Answer:**

currency0 is token A as the alphaIsCurrency0() function returns true (currency 1 is therefore token B). 

The predicted output token A received from putting in 5 of token B was: 

1 TUT (Token A): 16 CAFE (Token B)

fee = 10000 / 1,000,000 = 0.01

5000000000000000000 * 0.99 (fee deduction) / 16 = 309375000000000000 predicted output of token A.

The actual output received was 309367343158256833.

The difference is 7656841743167. Of this, the fee is 50000000000000000 (In terms of token B), and the 26568416841743167 is price impact.

---

## Question 3 (5 marks) ***

`Task3Liquidity` has to be holding your tokens and it also has to have approved the liquidity
router. Explain why both are needed and what each one does. Then call `addLiquidity` from a freshly
deployed `Task3Liquidity` that you have not sent any tokens to, quote the error message exactly,
and say which of the two requirements it was complaining about.

**Answer:**

A liquidity pool is needed to act as the central place where traders can swap tokens. It is a collection of different cryptocurrency tokens locked in a smart contract that enables automated trading without traditional order books. A liquidity router is an automated system that finds and uses the best places to buy or sell assets across fragmented markets. The liquidity router access the tokens in the pool and execute trades on behalf of users.

Aftering calling addLiquidity from a freshly deployed Task3Liquidity that has not been sent any tokens, the error message is: "ERC20: balance too small, send tokens to that contract first". This error message is complaining about contract Task3Liquidity not holding enough tokens to cover the liquidity provision so that the router can use them.

- Task3Liquidity's job is to hold the tokens and grant permission (via approve) — it does not itself move or send anything to the pool.
- The router (liquidityRouter) is the one that actually pulls the tokens, using the permission Task3Liquidity gave it, and forwards them into PoolManager

---

## Question 4 (5 marks) ***

State your live tick and the range you chose, and say why you chose it. Then answer this: if you
had chosen a range sitting entirely **below** the live tick, what would have happened? Name which
of your two tokens the pool would have taken, which it would have left untouched, and why that is
the way round it is.

**Answer:**

Live tick is 27727, and the range chosen was 23600 to 31600. I chose this range because they are both 20 spacings (given tick spacing is 200) on either side of the live tick. 

Snap down to the nearest multiple of 200: 27727 / 200 = 138.64 → round down → 138 × 200 = 27600 (27600 ≤ 27727)

Get 20 spacings (4000) either side:

tickLower = 27600 − 4000 = 23600 

tickUpper = 27600 + 4000 = 31600

If the range sat entirely below the live tick, the pool would have taken 100% currency1 (token B) and left currency0 (token A) untouched. A tick encodes price = 1.0001^tick, where that price means currency1 per unit of currency0 (currency1/currency0). As tick rate decreases, the price decreases, meaning it becomes cheaper to buy currency0 using currency1. A range below the live tick is at a price lower than today's rate and functions as a buy order: wait for currency0 to get cheap enough before using currency1 to buy currency0. Since the tick drop has not happened yet, the position holds only the currency1 (token B) it's ready to spend, and no currency0 (token A).

---

## Question 5 (5 marks)

State the number `startingSqrtPriceX96` returned for your run. Show how that number relates to your
starting price of 16, or one sixteenth, and to two to the power of ninety six. Then explain why the
protocol stores the square root of the price rather than the price itself, and why your tick came
out at roughly plus or minus 27727.

**Answer:**

startingSqrtPriceX96 = 316912650057057350374175801344, returned directly as _sqrtPriceIfTokenALower.

Price = currency1/currency0 = 16 (1 TUT = 16 CAFE). sqrtPriceX96 = sqrt(price) * 2^96 = sqrt(16) * 2^96 = 4 * 2^96 = 316912650057057350374175801344, matching the returned value.

The protocol stores the square root rather than the price itself because Uniswap's core liquidity formulas are linear in sqrtPrice, so swaps and liquidity math avoid taking square roots at runtime, and it keeps values from overflowing: squaring the raw price directly could exceed 256 bits, while sqrtPrice fits safely in Q64.96.

Tick came out at ~27727 because tick = ln(16) / ln(1.0001) ≈ 27727.27, rounded to the nearest valid tick.

---
