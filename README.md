# Mock exam: Uniswap v4

ECO5037W Fintech and Cryptocurrencies.

You will mint two reward tokens, open a Uniswap v4 pool at a set price, put liquidity into it, and
trade against it.

The code is already written for you. Your job is to fill in the gaps, each one marked with a
`TODO` and a hint. There are eleven gaps in total and most are a single line.

Read [PREPARATION.md](PREPARATION.md) first. It tells you what the real exam looks like and what to
study. This file is the practice run itself.

---

## Rules

The one rule worth imposing on yourself is this: **do it once without looking at the answer.** A
worked solution lives on the `solution` branch of this repository. Reading it feels like learning
and mostly is not. The exam asks you to explain your own choices, and you cannot explain a choice
you did not make.

Do it twice if you have time. The second run should take well under an hour, and that is the
point: on the day you want the mechanics to be automatic so your three hours go on thinking rather
than on finding buttons.

---

## Setup

**Step 1.** Open [remix.ethereum.org](https://remix.ethereum.org).

**Step 2.** On the top navigation bar, click the **GitHub Link** icon and connect to your GitHub account.

**Step 3.** Once connected, click the same icon again and select **Clone**. Paste this repository's URL and click **OK**. Wait for the files to appear in the file explorer on the left. (*NB* In the real exam you clone your own fork. Practise that here too if you want the whole thing to be familiar.)

**Step 4.** In the file explorer, right click `scripts/01_setup.js` and choose **Run**. Watch the
terminal at the bottom. After a few seconds it prints three addresses.

**Step 5.** Copy those three addresses into the table below. You will paste them repeatedly. (There is a button that says *EDIT* at the top of this page, click it to edit this markdown file.)

```
  Pool manager     0xd9145CCE52D386f254917e481eB44e9943F39138
  Liquidity router 0xd8b934580fcE35a11B58C6D73aDeE468a2833fa8
  Swap router      0xf8e81D47203A594245E36C48e151709F0C19fBe8
```

> **If you reload the page or change the Environment, everything you deployed is wiped.** You would
> have to start again from Step 4. Your written code is safe, only the deployments are lost.

**If any of this fails, tell us before exam day.** That is the main reason the mock exists. Setup
problems are not what is being examined, and there is no time to solve them on the day.

---

## Your parameter sheet

In the exam you get a sheet called `STUDENTNUMBER.txt` with your own parameters, and everyone's are
different. For the mock, everybody shares the one below. Copy the values exactly, digit for digit.
They are long because the tokens have 18 decimals, so the numbers are in the smallest unit, not
whole tokens.

```
--- TASK 1, your two tokens ---

  Token A name          Tutorial Tokens
  Token A symbol        TUT
  Token B name          Cafeteria Points
  Token B symbol        CAFE

  startingSupply_       2000000000000000000000000
                        that is 2000000 tokens at 18 decimals

--- TASK 2, your pool ---

  _fee                  10000
  _tickSpacing          200

  Starting price        1 TUT is worth 16 CAFE

  _sqrtPriceIfTokenALower
                        316912650057057350374175801344
  _sqrtPriceIfTokenBLower
                        19807040628566084398385987584

--- TASK 3, liquidity ---

  Send to your Task3Liquidity contract, from token A and again from token B:
                        1000000000000000000000000

  liquidityDelta        50000000000000000000000
                        a liquidity amount, not a number of tokens

--- TASK 4, the swap ---

  Send to your Task4Swap contract, from token A and again from token B:
                        1000000000000000000000000

  amountIn              5000000000000000000
                        that is 5 whole tokens

  Direction             currency1 into currency0
                        so zeroForOne is false
```

---

## Task 1: mint your tokens (10 marks in the exam)

**Open** `contracts/Task1Token.sol`. Complete `TODO 1.1`.

**Compile it.** Click the **Compile** button (blue button on the top left). Fix anything red before moving on.

**Deploy it twice.** Click the **Deploy and Run transactions button** (looks like a Solidity icon). In the **Contract** dropdown choose
`PracticeToken`. (If it says `Task1Token.sol` instead, click the *Compile* button next to it, then follow the next steps.)

**Fill in the three fields for each deployment:**
Deployment one, your token A:

| Field | What to type |
| --- | --- |
| `name_` | `Tutorial Tokens` |
| `symbol_` | `TUT` |
| `startingSupply_` | `2000000000000000000000000` |

Press **Deploy**. The contract appears under **Deployed Contracts** at the bottom. Click the copy
icon next to it to get its address.

Deployment two, your token B: same again, with `Cafeteria Points`, `CAFE`, and the same
`startingSupply_`.

**Write both addresses down now.** Everything from here needs them, and they are annoying to
recover if you lose them. (Replace the underscores in the table below with your addresses, the 0x is just a hint at what the address should look like, so remove it too before you paste.)

```
Token A address 0xD7ACd2a9FD159E69Bb102A1ca21C9a3e3A5F771B (TUT)
Token B address 0x7EF2e0048f5bAeDe046f6BF797943daF4ED8CB47 (CAFE)
```

---

## Task 2: open the pool (20 marks in the exam)

**Open** `contracts/Task2Pool.sol`. Complete `TODO 2.1`, `TODO 2.2`, and `TODO 2.3`.

**Compile it.** Click the **Compile** button (blue button on the top left). Fix anything red before moving on.

**Deploy `Task2Pool` once.** Click the **Deploy and Run transactions button** as we did before.
In the **Contract** dropdown choose `Task2Pool` and click **Deploy**. (If it says `Task2Pool.sol` instead, click the *Compile* button next to it, then follow the next steps.)

**Fill in the seven fields for this deployment:**

| Field | What to type |
| --- | --- |
| `_poolManager` | Pool manager address from Step 5 |
| `_tokenA` | Your token A address |
| `_tokenB` | Your token B address |
| `_fee` | `10000` |
| `_tickSpacing` | `200` |
| `_sqrtPriceIfTokenALower` | `316912650057057350374175801344` |
| `_sqrtPriceIfTokenBLower` | `19807040628566084398385987584` |

Press **Deploy**.

Those last two long numbers are the starting price, written the way the protocol wants it. You are
given both because the pool sorts your two tokens by address, and you do not get to choose which
one becomes `currency0`. Your code picks the right one in `TODO 2.1`.

**Call the functions.** Expand your deployed `Task2Pool` and click, in this order:

1. `alphaIsCurrency0` (blue, free). Note whether it says true or false.
2. `poolId` (blue, free). Write it down.
3. `startingSqrtPriceX96` (blue, free). It returns whichever of your two long numbers
   applies. Write it down.
4. `openPool` (orange, costs gas). This is the one that actually opens the pool.
5. `currentSlot0` (blue, free). It returns two numbers. The second is the tick.

**Record these:**

```
alphaIsCurrency0        False
poolId                0x3506df81c3c8b3f3179c57703d39a08a7b6def1a5347d9875e43d1c3603d0833
startingSqrtPriceX96    19807040628566084398385987584
tick after openPool     -27728
Task2Pool address     0xDA0bab807633f07f013f94DD0E6A4F96F8742B53
```

*Remember to get the address of the deployed contract, click the copy icon next to the address in the **Deployed Contracts** section.*

Before you move on, satisfy yourself that `startingSqrtPriceX96` returned the right one of your two
numbers for the sort order you actually got. Everything after this depends on it.

---

## Task 3: add liquidity (20 marks in the exam)

**Open** `contracts/Task3Liquidity.sol`. Complete `TODO 3.1`, `TODO 3.2`, and `TODO 3.3`.

**Compile it.** Click the **Compile** button (blue button on the top left). Fix anything red before moving on.

**Deploy `Task3Liquidity` once.** Click the **Deploy and Run transactions button** as we did before.
In the **Contract** dropdown choose `Task3Liquidity` and click **Deploy**. (If it says `Task3Liquidity.sol` instead, click the *Compile* button next to it, then follow the next steps.)

**Fill in the six fields for this deployment:**

| Field | What to type |
| --- | --- |
| `_poolManager` | Pool manager address from Step 5 |
| `_liquidityRouter` | Liquidity router address from Step 5 |
| `_tokenA` | Your token A address |
| `_tokenB` | Your token B address |
| `_fee` | `10000`, the same value as Task 2 |
| `_tickSpacing` | `200`, the same value as Task 2 |

Press **Deploy**.

> The fee and tick spacing must match Task 2 exactly. Change either one and you are pointing at a
> completely different pool, which does not exist, and everything will fail.

**Send it your tokens.** This contract pays for the liquidity, so it has to be holding tokens.

Under **Deployed Contracts**, expand your **token A** and call `transfer` with:

- `to`: your `Task3Liquidity` address
- `amount`: `1000000000000000000000000`, which is half your supply

Do the same on your **token B**.

**Choose your range.** Call `currentTick` on `Task3Liquidity` to see the live tick. Now pick a
`tickLower` below it and a `tickUpper` above it. Both must be exact multiples of your tick spacing,
so multiples of 200.

A safe way to do it: take the live tick, step it down to the multiple of 200 at or below it, then
go **twenty spacings** either side. With spacing 200 and a live tick of 12345, that is 12200 in the
middle, so 8200 and 16200.

Your live tick may well be negative, depending on which of your tokens became currency0. That is
normal and nothing is wrong. The same method works: with spacing 200 and a live tick of -8642, you
could use -8800 in the middle, so -12800 and -4800.

**Call `addLiquidity`** with your `tickLower`, your `tickUpper`, and `50000000000000000000000`. In
the terminal, expand the transaction and look at **decoded output**. It gives you `amount0` and
`amount1`, both negative because the tokens left your contract.

**Record these:**

```
tickLower        ______________________________________
tickUpper        ______________________________________
amount0          ______________________________________
amount1          ______________________________________
Task3 address 0x ______________________________________
```

*Remember to get the address of the deployed contract, click the copy icon next to the address in the **Deployed Contracts** section.*

---

## Task 4: predict, then swap (15 marks in the exam)

**Open** `contracts/Task4Swap.sol`. Complete `TODO 4.1`, `TODO 4.2`, `TODO 4.3`, and `TODO 4.4`.

**Compile it.** Click the **Compile** button (blue button on the top left). Fix anything red before moving on.

**Deploy `Task4Swap` once.** Click the **Deploy and Run transactions button** as we did before. In the **Contract** dropdown choose `Task4Swap` and click **Deploy**. (If it says `Task4Swap.sol` instead, click the *Compile* button next to it, then follow the next steps.)

**Fill in the six fields for this deployment:**

| Field | What to type |
| --- | --- |
| `_poolManager` | Pool manager address from Step 5 |
| `_swapRouter` | Swap router address from Step 5 |
| `_tokenA` | Your token A address |
| `_tokenB` | Your token B address |
| `_fee` | `10000`, same as Tasks 2 and 3 |
| `_tickSpacing` | `200`, same as Tasks 2 and 3 |

Press **Deploy**.

**Send it your tokens too**, the same way as Task 3: call `transfer` on token A and on token B,
this time to your `Task4Swap` address, using `1000000000000000000000000`. That is the other half of
your supply, so both contracts end up funded and your own balance ends at zero.

**Work out what you expect.** You are putting in 5 whole tokens of currency1 and getting currency0
back. Before you run anything, work out roughly how much you expect. Two things decide it:

- which of your tokens actually became currency0, because that flips the rate between 16 and one
  sixteenth, and the two answers are nowhere near each other
- the fee, which is one percent and comes off what you put in

Do not guess. Check `alphaIsCurrency0`, work out which rate applies to you, take the fee off. You do
not have to be exact, but you do need a number and a reason for it.

**Call `recordPrediction`** with that number, written in the same units as everything else, so
18 decimals. If you expect about 3 tokens back, that is `3000000000000000000`.

Your contract will not let you swap until you have recorded something.

**Call `swapExactIn`** with:

- `zeroForOne`: `false`, because the mock swaps currency1 into currency0
- `amountIn`: `5000000000000000000`

Check **decoded output** again. One amount is negative, the token you paid. The other is positive,
the token you received. The positive one is your actual output.

Copy both numbers exactly, minus sign and all. They are long because they are in the smallest unit
of the token, the same as everything else.

**Record these:**

```
predicted output    ______________________________________
actual output       ______________________________________
Task4 address     0x ______________________________________
```

*Remember to get the address of the deployed contract, click the copy icon next to the address in the **Deployed Contracts** section.*

Compare what you predicted against what you got, and make sure you can explain the gap. Some of it
is the fee. Some of it is your own trade moving the price. Know which is which, and roughly how big
each part is. The exam asks you to do exactly that in writing.

---

## Task 5: report your results (10 marks in the exam)

Open `results.json` and fill in every field with the values you wrote down.

Very long numbers, like the amounts and the price, go in as text inside quotes. The template
already shows which ones. *NB if the numbers are negative, keep the minus sign. Do not round or truncate anything.*

In the exam this is ten marks for what is essentially careful copying, so practise being careful.

---

## Task 6: written section (25 marks in the exam)

Answer all five questions in `ANSWERS.md`. **120 words each, maximum.** Each is worth 5 marks.

Full marks need specifics from your own work: your numbers, your addresses, your error messages,
your range.

---

## Submitting

You do not submit the mock. Do the submission steps once anyway, because fumbling them under time
pressure is a real way to lose marks.

In the exam you submit exactly six files:

```
Task1Token.sol
Task2Pool.sol
Task3Liquidity.sol
Task4Swap.sol
results.json
ANSWERS.md
```

Download each one from the Remix file explorer, right click and choose **Download**. Do not rename
them, and do not submit the whole workspace as a zip.

Before you submit, press **Compile** one last time and check there are no red errors. Files that do
not compile score zero on Tasks 1 to 5, whatever is written in them.

Once you have all files downloaded and checked, create a zip file called `STUDENTNUMBER.zip`. On the day, you will upload this to Amathuba.

---

## When you have finished

Do it again, then break it deliberately, because the written section has a habit of asking about
error messages:

- Give `addLiquidity` a tick that is not a multiple of 200. Read the error.
- Give it a range that sits entirely above the live tick. Read that error too, and note which of
  your two tokens the pool would have taken.
- Try `swapExactIn` before `recordPrediction` and see what happens.
- Deploy `Task3Liquidity` with a tick spacing of 60 instead of 200 and watch `poolId` change.
- Work out what your pool would have done if the other token had sorted first.

Read each error. Make sure you can say what caused it.

---

## References & Resources

**Which files you edit.** Only the four task files, plus `results.json` and `ANSWERS.md`. `V4.sol`,
`ERC20.sol` and `ExamBase.sol` are provided and already finished, and they are identical to the
ones you will get in the exam.

**Uniswap v4.** [Uniswap v4 docs](https://docs.uniswap.org/contracts/v4). Very comprehensive, but you do not need to read it all. The exam is designed so you can complete it without reading the docs, but they are there if you want to check something.

**Ticks.** `price = 1.0001 ** tick`. Any tick that holds liquidity has to be a multiple of the
pool's tick spacing.

**Compiler warnings.** The starting files produce warnings about unused variables. That is normal
and costs you nothing. They disappear as you fill the gaps in. Only red errors matter.

**Optional, `scripts/02_selfcheck.js`.** Checks the shape of your contracts and the rules they
should be enforcing. Fill in the three addresses at the top, right click the file, choose **Run**.
The exam has one of these too. It is not a mark predictor.

**The worked solution.** On the `solution` branch of this repository, in `SOLUTION.md` and the
contracts beside it.

**If something breaks.** Ask rather than spending twenty minutes on it. On the day, ask the
invigilator.
