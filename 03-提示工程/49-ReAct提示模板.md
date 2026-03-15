# 第 49 题：ReAct 提示模板的设计要素

## 题目

解释 ReAct 提示模板的设计要素。

---

## 一、ReAct 模板在做什么？

ReAct 提示模板引导模型**交替输出**“思考（Thought）”“行动（Action）”“观察（Observation）”直至“答案（Answer）”。模板要明确定义：每段的**标签**（如 `Thought:`/`Action:`/`Observation:`）、**格式**（如 Action 的 `工具名[参数]`）、以及**谁填什么**（Observation 由系统根据工具结果填入，模型不生成）。

---

## 二、设计要素

- **标签与格式**：明确 Thought / Action / Observation / Answer 的**关键词与拼写**，便于解析器识别；Action 常用 `工具名[参数]` 或 JSON，便于与工具注册表匹配。  
- **工具描述注入**：在 prompt 中列出可用工具的名称、描述、参数说明，让模型知道“能做什么、怎么调用”；描述要简洁可区分。  
- **Few-shot 示例**：给 1–2 个完整的 Thought → Action → Observation → … → Answer 示例，示范“先想再做、看到结果再想”的节奏与格式；示例中 Observation 可为占位或真实工具返回的简化版。  
- **停止与边界**：规定何时结束——如模型输出 `Answer:` 后不再生成 Action；或规定最大步数、超时，防止死循环。  
- **错误与重试**：在示例或说明中包含“工具失败/超时”时的 Observation 写法，引导模型在 Observation 为错误时换策略或重试。

---

## 三、小结与面试要点

**小结**：ReAct 提示模板要素包括：Thought/Action/Observation/Answer 的标签与格式、工具描述注入、Few-shot 示例、停止条件与最大步数、错误与重试的示范。

**面试要点**：

- 要素：标签与格式、工具描述、Few-shot、停止与边界、错误/重试示范。  
- Observation 由系统填，模型只生成 Thought、Action、Answer。  
- 示例要示范“想→做→看→再想”的完整链。

---

## 记忆要点

1. 要素：Thought/Action/Observation/Answer 标签与格式、工具描述、Few-shot、停止与错误处理。  
2. Observation 由系统填入；模型生成 Thought、Action、Answer。  
3. 示例要完整示范一轮 ReAct 链。

---

*上一篇：[第 48 题 - 提示链](./48-提示链.md)*  
*下一篇：[第 50 题 - 自动提示优化](./50-自动提示优化.md)*
