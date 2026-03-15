# 第 3 题：Layer Normalization 的作用及为何不用 Batch Normalization

## 题目

解释 Layer Normalization 的作用，以及为什么 Transformer 使用它而不是 Batch Normalization。

---

## 一、Layer Normalization 在做什么？

**Layer Normalization（LN）** 对**单个样本、同一层内**的所有特征做标准化：先在这一层的 $d$ 个神经元上算均值和方差，再对每个神经元减均值、除标准差，最后用可学习的 $\gamma,\beta$ 做缩放和平移。

设该层输出为 $\mathbf{h} \in \mathbb{R}^d$：

$$
\mu = \frac{1}{d}\sum_{i=1}^d h_i,\quad \sigma^2 = \frac{1}{d}\sum_{i=1}^d (h_i - \mu)^2
$$

$$
\mathrm{LN}(\mathbf{h}) = \gamma \cdot \frac{\mathbf{h} - \mu}{\sqrt{\sigma^2 + \epsilon}} + \beta
$$

**作用**：稳定每层输出的分布，减轻“内部协变量偏移”，让深层网络更好训、可以用更大学习率。$\gamma,\beta$ 让模型能学“要不要标准化、偏到哪”，避免丢失表达能力。

**和 BN 的本质区别**：LN 的均值和方差是在**特征维 $d$**（同一样本、同一层）上算的；BN 是在 **batch 维**（同一特征、不同样本）上算的。所以 LN 不依赖 batch，单样本也能算；BN 依赖 batch，batch 小时不稳定。

---

## 二、Batch Normalization 简要回顾

**Batch Normalization（BN）**：对每个特征维度，在**当前 batch 的 $N$ 个样本**上算均值和方差，然后对该特征做标准化。

- 训练时用当前 batch 的统计；推理时通常用训练阶段的**移动平均**（running mean/var），所以训练和推理不一致。  
- Batch 小时，batch 统计噪声大；序列长度不一或变长时，BN 在“batch×长度”上的统计也很难统一，推理时若长度和训练差很多，running 统计可能不适用。

---

## 三、Transformer 为什么用 LN 而不用 BN？

| 维度         | LN                          | BN                          |
|--------------|-----------------------------|-----------------------------|
| **统计维度** | 同一样本、层内 $d$ 维特征   | 同一特征、batch 内 $N$ 个样本 |
| **序列长度** | 与 $n$ 无关，任意长度一样算 | 长度不一/变长时统计难统一   |
| **Batch 大小** | 不依赖 batch，单样本可算   | 小 batch 方差大，推理用 running |
| **训练/推理** | 完全一致，无 running       | 推理用 running，易与训练不一致 |

**核心原因**：

1. **序列长度多变**：NLP 里序列长度不一，batch 内也会 pad 成不同长度；BN 要在“batch×序列”上做统计，很难稳定，推理时长度变化也麻烦。LN 只对特征维做，和 $n$、batch 都无关。  
2. **小 batch 很常见**：大模型经常小 batch 甚至单样本；LN 不受影响，BN 小 batch 时噪声大。  
3. **实现与稳定性**：LN 实现简单，训练和推理完全同一套逻辑；BN 要维护 running 统计，多卡时还要同步，Transformer 原文和后续大模型都选 LN（以及 Pre-LN 等变体）。

**面试追问**：“CV 里为什么常用 BN？”——图像 batch 大、尺寸常固定，batch 统计稳定；且 BN 有轻微正则效果。NLP 里序列变长、batch 常较小，所以 LN 更合适。

---

## 四、Pre-LN 与 Post-LN

- **Post-LN**：先 Attention/FFN，再 LN（原始 Transformer）。深层时容易梯度不稳定，需要 warmup。  
- **Pre-LN**：先 LN 再 Attention/FFN。训练更稳，几乎不用 warmup，当前大模型普遍用 Pre-LN。

面试可能问：“为什么现在都用 Pre-LN？”——因为梯度更稳、更容易训深、省掉 warmup。

---

## 五、小结与面试要点

**小结**：LN 对单样本、层内特征标准化，不依赖 batch 和序列长度，训练/推理一致；Transformer 用 LN 不用 BN，主要是因为序列变长、batch 多样、小 batch 多，以及实现简单、稳定。

**面试要点**：

- LN 和 BN 统计维度不同：LN 对特征维 $d$，BN 对 batch 维 $N$。  
- 为什么 Transformer 用 LN？序列长度不一、小 batch、训练/推理一致。  
- Pre-LN 和 Post-LN 区别？Pre-LN 先 norm 再子层，更稳，当前主流。

---

## 记忆要点

1. LN 在**特征维 $d$**上算均值和方差；BN 在 **batch 维**上算。  
2. LN 不依赖 batch 和序列长度，训练/推理一致；BN 依赖 batch，推理用 running。  
3. Transformer 用 LN 的原因：序列变长、小 batch、实现简单稳定。  
4. Pre-LN：先 LN 再 Attention/FFN，当前大模型标配。

---

*上一篇：[第 2 题 - 位置编码](./02-位置编码.md)*  
*下一篇：[第 4 题 - 注意力掩码](./04-Attention-Mask.md)*
