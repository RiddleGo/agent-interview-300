# 第 20 题：SwiGLU 激活函数相比 ReLU / GELU 的优势

## 题目

解释 SwiGLU 激活函数相比 ReLU 和 GELU 的优势。

---

## 一、ReLU 与 GELU 简述

- **ReLU**：$\mathrm{ReLU}(x) = \max(0, x)$；简单、稀疏，但死神经元、非零处恒为 1 的梯度。  
- **GELU**：$\mathrm{GELU}(x) \approx x \Phi(x)$（与正态 CDF 相关）；平滑、在负半轴非零，被 BERT、GPT-2 等采用。

---

## 二、门控与 GLU 族

**GLU（Gated Linear Unit）** 形式：$\mathrm{GLU}(x) = \sigma(W_1 x) \odot (W_2 x)$，即一路做门控（sigmoid），一路做线性变换，再逐元素乘。**门控**可让模型学会“选通”信息，提升表达能力。

**SwiGLU**：把门控的 sigmoid 换成 **Swish**（即 $\mathrm{Swish}(x) = x \cdot \sigma(x)$，又称 SiLU），即：

$$
\mathrm{SwiGLU}(x) = \mathrm{Swish}(W_1 x) \odot (W_2 x)
$$

在 FFN 中常用：$\mathrm{FFN}(x) = \mathrm{SwiGLU}(x) W_3$，即先对 $x$ 做两个线性得到两路，一路 Swish、一路恒等，相乘后再乘 $W_3$。

---

## 三、相比 ReLU / GELU 的优势

- **门控**：SwiGLU 是门控结构，能学习“让多少信息通过”，比单一非线性（ReLU/GELU）更灵活。  
- **Swish**：Swish 平滑、非单调，在负半轴有小幅非零值，梯度更友好，常比 ReLU 表达力更强。  
- **实践**：PaLM、LLaMA 等将 FFN 从 ReLU/GELU 换为 SwiGLU，在相同参数量或相同算力下往往得到更好效果，因此成为大模型 FFN 的常见选择。

---

## 四、代价

- **参数量与计算**：SwiGLU 需要两路线性（$W_1, W_2$），再乘 $W_3$，比“单路线性 + ReLU + 线性”多一组矩阵；为控制参数量，常把隐藏维略缩小（如 4d → 8d/3 的等效设计），使总参数量与 ReLU FFN 接近。

---

## 五、小结

- SwiGLU = Swish 门控 × 线性路，用于 FFN 可学习选通、表达力强。  
- 相比 ReLU/GELU：门控 + Swish 的平滑性，在大模型上效果更好；代价是 FFN 结构略复杂，需在维度上做平衡。

---

**面试常问**：“为什么用 Swish 而不是 sigmoid 做门控？”——Swish 平滑、非单调，梯度更友好，表达力更强；GLU 用 sigmoid 容易饱和。 “SwiGLU 多一路线性，参数量怎么控？”——常把 FFN 的中间维从 4d 调成 8d/3 等，使总参数量与 ReLU FFN 接近。

---

## 六、面试要点

- 形式：SwiGLU(x) = Swish(W1x) ⊙ (W2x)；FFN 中再乘 W3。  
- 优势：门控 + Swish 平滑，表达力强于 ReLU/GELU；PaLM/LLaMA 验证。  
- 代价：多一路线性，需在隐藏维上平衡参数量。

---

## 记忆要点

1. SwiGLU = Swish(W1x) ⊙ (W2x)；门控 + Swish。  
2. 优势：门控选通、Swish 平滑，强于 ReLU/GELU。  
3. 代价：多一路线性，需调隐藏维控参数量；大模型 FFN 常见选择。

---

*上一篇：[第 19 题 - RoPE](./19-RoPE.md)*  
*下一篇：进入 [Agent 核心概念](../02-Agent核心概念)（第 21 题）*
