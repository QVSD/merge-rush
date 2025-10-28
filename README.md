# **GAME DESIGN DOCUMENT (MVP) – “MERGE RUSH”**

## **1. Overview**

| Element             | Description                                                                                                                                     |
| ------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| **Title**           | *Merge Rush*                                                                                                                                    |
| **Genre**           | Hybrid runner + merge mechanic (satisfying casual)                                                                                              |
| **Platform**        | Mobile (Android + iOS, built in Godot 4)                                                                                                        |
| **Session length**  | 1–3 minutes                                                                                                                                     |
| **Gameplay goal**   | Collect numbered blocks, merge identical ones, avoid obstacles, and reach the finish line with the highest possible value and score multiplier. |
| **Visual style**    | Neon, saturated colors, glow effects, and “satisfying” particle feedback                                                                        |
| **Target audience** | Casual mobile players (ages 8–95)                                                                                                               |

---

## **2. MVP Scope**

The MVP includes:

* One world with 5 levels (differing by speed, obstacles, and background color)
* 3 power-ups (Magnet, Shield, Slow Motion)
* Full scoring, coins, and upgrade system
* Local leaderboard (JSON-based)
* Basic monetization (rewarded ad at the end)
* Complete gameplay loop:
  **Start → Run → Finish → Reward → Restart**

---

## **3. Core Gameplay Flow**

```
MENU → START → RUN (collect blocks + merge identical ones + avoid obstacles)
      → FINISH (apply score multiplier + award coins)
      → SHOP / UPGRADE → START again
```

---

## **4. Core Mechanic: Merge Logic**

This is the heart of the game.

| Element           | Description                                                                                |
| ----------------- | ------------------------------------------------------------------------------------------ |
| **Blocks**        | Numbered objects: 1, 2, 4, 8, 16, 32, 64, 128, 256, 512                                    |
| **Merge rule**    | Two blocks **with the same value** combine into one with **double value**                  |
| **Feedback**      | Flash, “pling” sound, short vibration, and colored particle burst                          |
| **Max value**     | 512 (after which the block explodes and grants a ×3 coin bonus)                            |
| **Invalid merge** | When different blocks collide: short “buzz” feedback, combo reset, and –10% speed for 0.5s |
| **Score formula** | `score += new_block_value × combo_multiplier`                                              |
| **Combo system**  | Each consecutive successful merge adds +0.2x to the multiplier (max ×3)                    |

### **Merge Logic Implementation Notes**

* Only blocks with equal values can merge.
* Upon collision, check for equality (`if a.value == b.value`).
* On merge success:

  * Destroy both original nodes
  * Spawn a new block with double value
  * Trigger visual + audio feedback
* On merge failure:

  * Play “buzz” sound
  * Slight camera shake or slowdown
  * Reset combo counter

---

## **5. Scoring and Rewards System**

| Type                 | Description                                                                |
| -------------------- | -------------------------------------------------------------------------- |
| **Score**            | Increases with each merge, calculated as above                             |
| **Coins**            | Awarded at end of run: `coins = total_score × final_multiplier`            |
| **Final multiplier** | Determined by the goal gate (×2 / ×3 / ×5)                                 |
| **Gems**             | Rare drop or rewarded ad bonus                                             |
| **Prestige XP**      | After finishing 5 levels, player can prestige for +1% permanent coin bonus |

---

## **6. Obstacles**

| Type           | Description                                     | Effect             |
| -------------- | ----------------------------------------------- | ------------------ |
| **Wall**       | Fixed barrier; collision removes the last block | Block loss         |
| **Spinner**    | Rotating arm requiring timed movement           | Slows player       |
| **Color gate** | Passable only if final block matches gate color | Blocked path       |

Difficulty increases each level via higher speed and obstacle density.

---

## **7. Power-Ups**

| Name                        | Description                             | Duration  | Rarity      |
| --------------------------- | --------------------------------------- | --------- | ----------- |
| **Magnet**                  | Automatically attracts nearby blocks    | 3s        | Common      |
| **Shield**                  | Prevents one collision with an obstacle | Until hit | Rare        |
| **Slow Motion**             | Slows all obstacles by 50%              | 3s        | Rare        |
| **Auto-Merge** *(ad bonus)* | Instantly merges all equal-value blocks | 5s        | Reward-only |

---

## **8. Permanent Upgrades (Shop)**

| Upgrade             | Effect                              | Base Cost | Scaling        |
| ------------------- | ----------------------------------- | --------- | -------------- |
| **Speed Boost**     | +2% permanent speed                 | 100 coins | ×1.5 per level |
| **Merge Chance**    | +1% auto-merge chance on collection | 250 coins | ×1.4           |
| **Magnet Duration** | +1s magnet duration                 | 300 coins | ×1.6           |
| **Shield Chance**   | +0.5% shield drop rate              | 400 coins | ×1.7           |

All data saved locally in `save_data.json`.

---

## **9. HUD & UI**

| Screen          | Elements                                      | Actions                  |
| --------------- | --------------------------------------------- | ------------------------ |
| **Main Menu**   | Logo, Start, Shop, Settings                   | Transition to Game Scene |
| **HUD**         | Score, Coins, Power-Up Indicators             | Real-time feedback       |
| **End Screen**  | Final Score, Coins, “Watch Ad = Double Coins” | Restart / Shop           |
| **Shop Screen** | Upgrade list, Buy/Back buttons                | Persistent data          |
| **Leaderboard** | Local top 10 scores (JSON)                    | Reset button             |

---

## **10. Feedback and Effects**

| Event              | Visual Feedback                         | Audio Feedback        |
| ------------------ | --------------------------------------- | --------------------- |
| Successful merge   | Particle explosion, short glow          | “Pling” crystal sound |
| Large merge (128+) | Camera shake + 0.3s slow motion         | “Deep boom” sound     |
| Obstacle hit       | Red flash + vibration                   | “Thud” sound          |
| Power-up collected | Highlight pulse                         | “Whoosh”              |
| Run finished       | Confetti burst + score multiplier popup | Short fanfare         |

---

## **11. Leaderboard and Progress**

**Local leaderboard:**

* Top 10 runs stored in `score.json`
* Score formula: `final_block_value × multiplier × average_combo`
* Each run receives a visual rank tag (“Good / Great / Insane”)

Global leaderboard integration (Google Play Games API) post-MVP.

---

## **12. Monetization (MVP)**

| Type                | Trigger                    | Effect                          |
| ------------------- | -------------------------- | ------------------------------- |
| **Rewarded Ad**     | End screen, “Double Coins” | +100% final reward              |
| **Interstitial Ad** | Every 3 runs               | 5-second display                |
| **IAP 1**           | “No Ads” ($2.99)           | Removes interstitial ads        |
| **IAP 2**           | “Starter Pack” ($4.99)     | +500 coins, +1 gem, removes ads |

---

## **13. MVP Success Criteria**

| Metric                     | Target       |
| -------------------------- | ------------ |
| **Average playtime**       | > 90 seconds |
| **Day 1 retention**        | > 25%        |
| **Internal tester rating** | > 4 / 5      |
| **Crash rate**             | < 1%         |

---
