# 第 1 题：Transformer 中的 Self-Attention 机制与计算复杂度

## 题目

解释 Transformer 架构中的 Self-Attention 机制，并说明其计算复杂度。

---

## 一、Self-Attention 在做什么？为什么重要？

**Self-Attention（自注意力）** 是 Transformer 的核心：让序列中**每个位置**都能“看到”**其他所有位置**，并根据**相关性**对信息做加权聚合。换句话说：每个 token 的表示，由整段序列里所有 token 共同决定，权重由“谁和谁更相关”来定。

**为什么重要？**

- **长距离依赖**：RNN 要一步步传，距离远时梯度易消失；Self-Attention 一步就能让任意两个位置交互，适合长文档、长对话。
- **并行**：所有位置的注意力可以同时算，训练比 RNN 快得多。
- **对顺序不敏感**：打乱 token 顺序，$QK^\top$ 和 $AV$ 的结果不变，所以**必须**配合位置编码，否则模型不知道“谁在前谁在后”。

面试里常追问：“和 RNN/CNN 比有什么不同？”——RNN 是顺序、局部传递；CNN 是局部窗口；Self-Attention 是全局、一次看全序列，且可并行。

---

## 二、计算流程（三步，必须能推）

设输入 $X \in \mathbb{R}^{n \times d}$：$n$ 为序列长度，$d$ 为特征维度。

### 1. 得到 Q、K、V

三个线性变换：

$$
Q = X W^Q,\quad K = X W^K,\quad V = X W^V
$$

$W^Q, W^K, W^V \in \mathbb{R}^{d \times d_k}$。做多头时通常 $d_k = d/h$（$h$ 为头数）。

- **Query**：当前位置“在找什么”。
- **Key**：每个位置“有什么可被注意的”。
- **Value**：真正被聚合的语义/信息。

**相似度**用 $Q$ 和 $K$ 算（点积），**聚合**用算出来的权重对 $V$ 加权求和。这样就把“找谁”和“取什么”分开，比直接用 $X$ 做点积更灵活。

### 2. 注意力分数与权重

- **分数**：$\mathrm{scores} = Q K^\top \in \mathbb{R}^{n \times n}$。第 $(i,j)$ 项表示位置 $i$ 对位置 $j$ 的未归一化相似度。
- **缩放**：除以 $\sqrt{d_k}$。因为点积随 $d_k$ 增大而变大，不除的话 softmax 会趋近 one-hot，梯度很小；除 $\sqrt{d_k}$ 后方差稳定，便于训练。
- **掩码**（可选）：要屏蔽的位置（如 padding、未来 token）在 scores 上加 $-\infty$，softmax 后为 0。
- **权重**：$A = \mathrm{softmax}(\mathrm{scores} / \sqrt{d_k})$，每行和为 1，表示每个位置对其它位置的注意力分布。

### 3. 加权求和得到输出

$$
\mathrm{Output} = A V \in \mathbb{R}^{n \times d_k}
$$

第 $i$ 行的输出 = 所有位置的 $V$ 按第 $i$ 行注意力权重加权和。

**完整公式**：

$$
\mathrm{Attention}(Q,K,V) = \mathrm{softmax}\left( \frac{Q K^\top}{\sqrt{d_k}} \right) V
$$

---

## 三、多头注意力（Multi-Head Attention）

多组 $(Q_h, K_h, V_h)$ 并行算，再拼起来过一层线性：

$$
\mathrm{MultiHead}(X) = \mathrm{Concat}(\mathrm{head}_1,\ldots,\mathrm{head}_h) W^O
$$

$$
\mathrm{head}_i = \mathrm{Attention}(X W^Q_i, X W^K_i, X W^V_i)
$$

**为什么多头？** 不同头可以学不同模式：有的关注局部、有的关注全局，有的偏语法、有的偏语义。单头相当于一个线性子空间，多头相当于多个子空间，表达能力更强。面试可能问：“头数怎么选？”——常见 8、16、32；头太多参数量大、单头维度太小可能欠拟合，要按模型规模折中。

---

## 四、计算复杂度（必考）

- **时间复杂度**  
  - 算 $Q,K,V$：$3 \cdot O(n \cdot d \cdot d_k) = O(n d^2)$（设 $d_k = O(d)$）。  
  - $Q K^\top$：$O(n^2 \cdot d)$。  
  - $A V$：$O(n^2 \cdot d)$。  
  - **主导项**：$O(n^2 d)$，即和序列长度 $n$ 的**平方**有关。

- **空间复杂度**  
  - 要存 $n \times n$ 的注意力矩阵 $A$（及反向时的梯度），所以是 $O(n^2)$。

**面试常问**：“长序列为什么费显存/慢？”——就是因为 $n^2$。所以会有 Sparse Attention、Local Attention、线性注意力等改进，把 $n^2$ 降成 $n \log n$ 或 $n$。

---

## 五、小结与面试要点

**小结**：Self-Attention 用 $Q,K,V$ 算位置间相似度，再对 $V$ 加权求和；缩放 $\sqrt{d_k}$ 和多头是标准设计；复杂度时间 $O(n^2 d)$、空间 $O(n^2)$。

**面试要点**：

- 能口头说出三步：Q/K/V → scores 缩放+softmax → A×V。
- 为什么除以 $\sqrt{d_k}$？防止点积过大导致 softmax 梯度变小。
- 为什么用 Q、K、V 而不是直接用 X？分离“相似度”和“取值”，更灵活。
- 复杂度为什么是 $O(n^2)$？因为要算 $n\times n$ 的注意力矩阵并存下来。

---

## 记忆要点

1. Self-Attention：每个位置对所有位置按相似度加权聚合 $V$；公式 $\mathrm{softmax}(QK^\top/\sqrt{d_k})V$。  
2. 三步：Q/K/V → 分数缩放+softmax → 输出 = A×V。  
3. 缩放 $\sqrt{d_k}$：稳定 softmax 梯度。  
4. 多头：多组 Q/K/V 并行，增强表达；复杂度与头数线性相关。  
5. 复杂度：时间 $O(n^2 d)$，空间 $O(n^2)$；长序列瓶颈在 $n^2$。

---

*下一篇：[第 2 题 - 位置编码：绝对 vs 相对](./02-位置编码.md)*
