# 第 24 题：ReAct（Reasoning + Acting）框架的核心思想

## 题目

解释 ReAct（Reasoning + Acting）框架的核心思想。

---

## 一、ReAct 是什么？

**ReAct** 是一种将**推理（Reasoning）**与**行动（Acting）**交织在一起的 Agent 范式：Agent 交替进行“**思考**”（用自然语言给出下一步推理）和“**行动**”（调用工具并得到观察），直到得出最终答案。论文标题即 “Synergizing Reasoning and Acting in LLMs”。

核心格式：**Thought → Action → Observation** 的循环。Thought 是模型对当前局势的推理与下一步计划；Action 是具体的工具调用；Observation 是工具返回的结果，由系统填入。下一轮模型在看到 Observation 后继续 Thought，再决定下一个 Action 或给出 Answer。

---

## 二、核心思想（为什么有效）

- **推理指导行动**：先“想清楚再动手”（例如：要比较两家公司股价，需要先查 A 再查 B），减少盲目试错。  
- **行动反馈推理**：观察结果能纠正错误假设（例如以为某 API 返回某字段，实际没有），避免模型“闭门造车”。  
- **可解释**：Thought 序列形成人类可读的推理链，便于调试与审计。  
- **与 CoT 的区别**：CoT 只有“想”；ReAct 是“想→做→看→再想”，把**行动与观察**纳入推理链，适合需要工具的任务。

面试常问：“ReAct 和 Chain-of-Thought 有什么区别？”——CoT 是纯推理链；ReAct 在推理中插入工具调用与观察，是 Reasoning + Acting 的交替。

---

## 三、典型流程示例

```
用户：2023年诺贝尔物理学奖得主是谁？
Thought: 需要查最新诺贝尔奖信息，用搜索。
Action: search["2023 Nobel Prize Physics winner"]
Observation: The 2023 Nobel Prize in Physics was awarded to ...
Thought: 已得到答案，可以总结回复。
Answer: 2023年诺贝尔物理学奖得主是 ...
```

模型在每轮根据当前 Thought + 历史 Action/Observation 生成下一段 Thought 或 Action；系统执行 Action 并填入 Observation；当模型生成 Answer 时结束。

---

## 四、小结与面试要点

**小结**：ReAct = 推理与行动交织，格式为 Thought → Action → Observation 循环；推理指导行动、行动反馈推理，适合需要多步工具调用的任务，且具可解释性。

**面试要点**：

- 核心：Reasoning + Acting 交替；Thought（推理）→ Action（工具调用）→ Observation（结果）→ 再 Thought。  
- 与 CoT：CoT 只有推理；ReAct 在推理中插入工具调用与观察。  
- 优势：推理指导行动、观察反馈推理、可解释、适合工具型任务。

---

## 记忆要点

1. ReAct = Reasoning + Acting，Thought → Action → Observation 循环。  
2. 推理指导行动、行动反馈推理；比纯 CoT 多“做”与“看”。  
3. 适合多步工具任务，Thought 链可解释。

---

*上一篇：[第 23 题 - 工具使用](./23-工具使用.md)*  
*下一篇：[第 25 题 - Zero-shot / Few-shot / Auto-CoT](./25-Zero-shot-Few-shot-Auto-CoT.md)*
