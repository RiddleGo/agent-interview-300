# 第 18 题：Group Query Attention（GQA）与 Multi-Query Attention（MQA）

## 题目

解释 Group Query Attention（GQA）和 Multi-Query Attention（MQA）的设计动机。

---

## 一、标准多头注意力中的 K、V

在标准 Multi-Head Attention 中，每个头有**独立的** $W^K, W^V$，因此每个头有自己的一组 K、V。解码时 KV Cache 要存 **num_heads × seq_len × head_dim**，显存随头数线性增长。

---

## 二、Multi-Query Attention（MQA）

- **做法**：**所有头共享同一组 K、V**；即只有一份 $W^K, W^V$，所有 query 头都对着同一份 K、V 做注意力。  
- **动机**：大幅减少 KV Cache 的显存（从 num_heads 份变为 1 份），加快解码、提高吞吐。  
- **代价**：所有头看到相同的 key/value 表示，表达能力下降，尤其在需要头间多样性时可能影响效果。

---

## 三、Group Query Attention（GQA）

- **做法**：折中——把 head 分成若干**组**，组内共享 K、V，组间不共享。即 K、V 的头数 = num_kv_heads（如 8），Q 的头数 = num_heads（如 32），每 4 个 Q 头共享 1 个 K、V 头。  
- **动机**：在 MQA 与标准 MHA 之间取得平衡：比 MHA 省 KV Cache（num_kv_heads 份），比 MQA 保留更多 key/value 多样性。  
- **效果**：在 LLaMA-2 等模型中，GQA 在几乎不损效果的前提下显著降低 KV Cache 与解码成本，被广泛采用。

---

## 四、对比小结

| 方法 | K、V 头数 | KV Cache | 表达能力 |
|------|-----------|----------|----------|
| **MHA** | = Q 头数 | 大 | 最高 |
| **MQA** | 1 | 最小 | 最低 |
| **GQA** | 1 < num_kv_heads < num_heads | 介于两者 | 介于两者 |

设计动机：**在解码阶段省 KV Cache、提吞吐**；MQA 最省但表达弱，GQA 用少量 K/V 头换回大部分表达能力。

---

**面试常问**：“为什么不全用 MQA？”——MQA 所有头共享 K、V，表达能力弱，效果可能掉；GQA 用少量 K/V 头换回大部分表达，几乎不损效果。 “GQA 的 num_kv_heads 怎么设？”——常见 8，或 num_heads 的 1/4；越大越接近 MHA、Cache 越大，越小越省显存。

---

## 五、面试要点

- MQA：所有 Q 头共享一组 K、V；KV Cache 最小，表达弱。  
- GQA：Q 头分组、组内共享 K、V；省 Cache 且保留多数表达，LLaMA-2 等采用。  
- 动机：解码时省 KV Cache、提吞吐；GQA 是 MHA 与 MQA 的折中。

---

## 记忆要点

1. MQA：所有头共享 K、V；KV Cache 最小，表达最弱。  
2. GQA：组内共享 K、V；省 Cache 且保留多数表达，当前主流。  
3. 动机：解码省显存、提吞吐；GQA 为 MHA 与 MQA 的折中。

---

*上一篇：[第 17 题 - 模型量化](./17-模型量化.md)*  
*下一篇：[第 19 题 - RoPE](./19-RoPE.md)*
