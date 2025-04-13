---

# Eldoria Chronicles: Idle RPG
![Screenshot](assets/images/icons/eldoria_chronicles.png)
A Flutter Game Development Experiment*

---

## 🧪 Introduction (Experimental Project)

**Eldoria Chronicles: Idle RPG** is a personal experimental project aimed at evaluating the capabilities of the **Flutter framework** as a potential game development platform, specifically for building idle and RPG-style games. The objective is to explore whether Flutter offers the necessary tools, libraries, and performance optimization features required to replicate the core mechanics found in idle games commonly published on the **Google Play Store**.

Unlike traditional game engines such as **Unity**, which are renowned for their rendering power and physics capabilities, Flutter is typically used for UI-focused apps. This experiment seeks to determine whether Flutter can serve as a **viable alternative** by developing a functional prototype that includes:

- Automated resource generation  
- Progression systems  
- Interactive UI elements  
- Cross-platform support  
- Performance testing across devices

Ultimately, this project aims to uncover the **strengths and limitations** of using Flutter for idle game development.

---

## 🎮 Game Inspiration

This project draws inspiration from the following titles and engines:

- **RPG Maker MV & ACE** – For its straightforward class/stat system and turn-based combat  
- **King God Castle** – For its pixel-art aesthetic and unit-based idle mechanics  
- **Idle Space Farmer** – For farm/resource-based progression systems

---

## 🧠 AI Tools Used

| Tool | Purpose |
|------|---------|
| [DeepSeek Chat](https://chat.deepseek.com/) | Code structure, game logic, and mechanics |
| [ChatGPT](https://chat.openai.com/) | Icon and UI asset generation |
| [PixAI](https://pixai.art/) | Character and background asset generation |
| [Stable Diffusion Web](https://stablediffusionweb.com/) | Background and environmental design |

---

## 🧩 Core Game Systems

### 🔧 Resource Management
- Primary resources: **Energy**, **Minerals**, and **Credits**
- Resources generated via character-assigned farms
- Resource conversion/exchange system

### 🏗️ Base Building
- Farms with up to **25 upgradeable floors**
- Types: `Aetheris` (Energy), `Eldoria` (Minerals)
- Floor unlocking and tier upgrades

### 👩 Character System
- Playable "Girls" with RPG stats: `HP`, `MP`, `SP`, `Attack`, `Defense`, `Agility`
- Rarity tiers: **Common**, **Rare**, **Unique**
- Systems:  
  - **Race**: Human, Eldren, Therian, Dracovar, Daemon  
  - **Class**: Divine Cleric, Phantom Reaver, etc.  
  - **Abilities** with resource costs and cooldowns  
  - **Leveling** with stat growth

### 🛡️ Equipment System
- Slots: **Weapon**, **Armor**, **Accessory**
- Rarity: **Common → Mythic**
- Features:
  - Enhancement system
  - Restrictions: Slot, type, race
  - Stat bonuses (Attack, Defense, HP, etc.)

### 🛒 Shop System
- Daily item refresh system
- Categories: **Girls**, **Equipment**, **Potions**, **Abilities**
- Uses various in-game currencies
- Manual refresh (3x per day)

### 🧪 Potion System
- Rarities: **Common → Legendary**
- Permanent stat boosts
- Usage limitations
- Inventory and sales system

### ⚔️ Battle System
- Turn-based combat
- Initiative based on **Agility**
- Elements:  
  - Ability usage with **MP/SP costs**  
  - Buffs/debuffs and elemental affinity  
  - **Auto-battle** and critical hit system  
  - Win/loss conditions

### 🎲 Gacha Mechanics
- Summon systems:
  - **Character Gacha**
  - **Equipment Gacha**
- Rarity rates:
  - **Mythic – 1%**
  - **Legendary – 5%**
  - Others vary

### 📈 Progression Systems
- Character leveling (up to **Level 100**)
- Equipment enhancement & tier progression
- Farm/floor upgrades
- Ability unlock milestones

---

## 🧑‍💻 Technical Features

- Persistent game state (save/load)
- **Offline progression** via timer-based calculations
- **Background timers** for resource generation
- **Daily reset logic** for shops, quests, and cooldowns

---

## ⚠️ Disclaimer

This repository is a **non-commercial, experimental prototype** created for personal learning and exploratory research on using **Flutter** for game development. It is not intended for public release or monetization.

All third-party inspirations and tools referenced (e.g., **RPG Maker**, **King God Castle**, **AI tools**) are used for **educational and developmental purposes only**, in accordance with their respective **terms of service**. This project does **not claim ownership** over any visual, gameplay, or conceptual elements inspired by existing games or platforms.

Furthermore:

- All AI-generated assets and logic implementations are strictly for prototype usage.
- Any borrowed concepts or gameplay systems are **heavily modified or reinterpreted** for Flutter feasibility testing.
- This experiment serves only to assess **Flutter's viability as a cross-platform game engine**, and **no infringement or competition with original IPs is intended**.

---
