# 第 187 题：首 token 延迟（TTFT）

## 题目

什么是首 token 延迟（Time To First Token，TTFT）？如何优化？

---

## 一、TTFT 是什么

**TTFT** = 从**请求发出**到**收到第一个输出 token** 的时间。在流式场景下，用户**先感知**的是 TTFT，再是后续 token 的**持续输出**。TTFT 长会让人觉得“卡顿”；**总生成时间**受 **token 数 × 每 token 延迟** 影响，但**体验**更依赖 TTFT 与**首几句**是否快速出来。

---

## 二、TTFT 的主要来源

- **排队**：请求在**调度/队列**中等待；**批处理**或高负载时明显；**优先级**与**公平调度**可缓解。  
- **Prefill**：**整段 prompt** 的**前向计算**（把 context 编码完）；context 越长、模型越大，prefill 越慢；**Prefill 与 Decode 分离**、**分块 prefill** 可优化。  
- **调度与调度器**：**连续批处理**（Continuous Batching）让**先到的请求**先开始 decode，不必等整批 prefill 完；**Chunked prefill** 先算一部分 context 就可开始出 token。  
- **网络与序列化**：**首包**从推理服务到客户端的**网络与序列化**；**就近部署**、**小首包**可略降。

---

## 三、优化手段

- **减少 prefill 量**：**压缩 prompt**（摘要历史、少带无关 context）；**RAG** 只注入高相关 chunk；**分层**（先短 context 出首句，再补长 context）。  
- **Chunked prefill / 流式 prefill**：**不一次性**算完整个 context，而是**分块** prefill，**先算完的块**即可参与**首 token 生成**；vLLM 等已支持。  
- **连续批处理**：**不凑满 batch** 才 prefill；**单请求或小 batch** 即可开始；**decode 阶段**动态加入新请求，减少排队。  
- **投机采样**：用**小模型**快速 draft 若干 token，**大模型**一次验证；可**显著降低**大模型的 TTFT 与总步数（在兼容实现下）。  
- **缓存**：**相同 prefix**（如 system prompt、长 context）**缓存 KV Cache**，下次请求**跳过**该部分 prefill；多轮对话与 RAG 场景有效。  
- **模型与量化**：**小模型**或**量化** prefill 更快；**简单任务**用快模型可明显降 TTFT。

---

## 四、小结与面试要点

**小结**：TTFT 是用户最先感知的延迟；主要受排队、prefill 时间与调度影响；优化包括减少 prefill 量、chunked/流式 prefill、连续批处理、投机采样、KV 缓存与模型选择。

**面试要点**：能定义 TTFT 并说清为何重要；prefill 与连续批处理要提到；chunked prefill、投机采样、KV 缓存可举一二。

---

## 记忆要点

1. TTFT = 请求到首 token 的时间；决定“卡不卡”的体验。  
2. 来源：排队、prefill 时长、调度策略。  
3. 优化：减 prefill 量、chunked prefill、连续批、投机采样、KV 缓存。

---

*上一篇：[第 186 题 - 延迟优化概述](./186-延迟优化.md)*  
*下一篇：[第 188 题 - 端到端延迟分析](./188-端到端延迟分析.md)*
