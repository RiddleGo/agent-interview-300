# 第 4 题：注意力掩码（Attention Mask）在训练与推理中的使用

## 题目

什么是注意力掩码（Attention Mask）？在训练和推理中分别如何使用？

---

## 一、什么是注意力掩码？为什么需要？

**注意力掩码**是在算注意力**权重之前**，对 logits（即 $QK^\top$ 缩放后的 scores）做遮挡，让某些位置在 softmax 之后的权重变成 0，这样模型就**不会从这些位置读取信息**。

两种最常见用法：

- **Padding mask**：把 **padding 位置**遮掉。batch 里序列长度不一时会 pad 到同一长度，pad 本身没有语义，若参与注意力会干扰模型，所以要对 pad 位置 mask。  
- **Causal mask（因果掩码）**：把**未来位置**遮掉。自回归语言模型在预测第 $t$ 个 token 时，只能看到 1 到 $t-1$，不能看到 $t$ 及以后，否则就“作弊”了。所以对 $j > i$ 的 $(i,j)$ 要 mask，保证位置 $i$ 只能注意 $j \le i$。

面试常问：“训练时为什么也要 causal mask？”——因为训练时虽然一次能看到整句，但我们要模拟“逐 token 生成”的分布，每个位置只能基于之前的 token 预测下一个，这样训练和推理一致，否则推理时模型没见过“看到未来”的情况会崩。

---

## 二、实现方式（必须能说清）

在 softmax **之前**，对要屏蔽的位置在 scores 上加一个很大的**负数**（如 $-\infty$ 或 $-10^9$），softmax 后这些位置就接近 0：

$$
\mathrm{scores}_{i,j} = \frac{Q_i K_j^\top}{\sqrt{d_k}} + M_{i,j},\qquad A = \mathrm{softmax}(\mathrm{scores})
$$

- $M_{i,j} = 0$：不遮挡，正常参与注意力。  
- $M_{i,j} = -\infty$（或 $-10^9$）：遮挡，softmax 后权重≈0。

**为什么是加负数而不是乘 0？** 若乘 0，softmax(0) 不是 0，其他位置会分走权重；加 $-\infty$ 后 softmax 分母里该项趋于 0，得到的权重才是 0，且不影响其他位置的相对大小。

---

## 三、训练中怎么用？

- **Padding mask**：对每个 pad 的 **key 位置 $j$**，让所有 query $i$ 都不能注意它：对所有 $i$ 设 $M_{i,j} = -\infty$。有的实现也会对 pad 的 **query 位置 $i$** 设 $M_{i,j} = -\infty$（对所有 $j$），这样 pad 位置既不当 key 也不当 query，完全不参与。  
- **Causal mask**：对 $j > i$ 设 $M_{i,j} = -\infty$，即位置 $i$ 只能看到 $j \le i$。  
- **两者同时用**：先按 causal 把上三角遮掉，再在 pad 对应的行/列上把 padding mask 加上。实现时可以两个 mask 相加（都是 0 和 $-\infty$），再一起加到 scores 上。

---

## 四、推理中怎么用？

- **自回归生成**：每步只生成一个 token，当前 step 的 query 只和**已经生成**的 token 的 key 做注意力；通过 causal mask 保证“只看过去”，和训练一致。  
- **Padding**：若 batch 内多条序列长度不同（例如 beam search 时），同样对 pad 位置做 padding mask，避免 pad 参与计算。

---

## 五、小结与面试要点

**小结**：注意力掩码 = 在 softmax 前对 scores 加 $-\infty$，使对应位置权重为 0。Padding mask 遮 pad，有 pad 就用；Causal mask 遮未来，自回归训练和推理都要用。

**面试要点**：

- 两种 mask：Padding（遮 pad）、Causal（遮 $j>i$）。  
- 为什么加 $-\infty$ 而不是乘 0？保证 softmax 后真正为 0 且不破坏其他位置比例。  
- 训练时为什么也要 causal？保证“每个位置只基于过去预测下一个”，和推理一致。  
- 可以同时用：先 causal 再在 pad 位置加 padding mask。

---

## 记忆要点

1. 掩码在 softmax **前**对 scores 加 $-\infty$，使权重为 0。  
2. Padding mask：遮 pad，训练和推理只要有 pad 就用。  
3. Causal mask：遮 $j>i$，自回归训练与推理必用，保证“只看过去”。  
4. 实现：两种 mask 可相加后一起加到 scores 上。

---

*上一篇：[第 3 题 - Layer Normalization](./03-Layer-Normalization.md)*  
*下一篇：[第 5 题 - KV Cache](./05-KV-Cache.md)*
