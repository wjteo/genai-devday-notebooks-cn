---
slug: agents-lab
id: gyuxthfmoxq2
type: challenge
title: The A to Z of Building AI Agents
tabs:
- id: aqyl8uxpa4qw
  title: Code Editor
  type: service
  hostname: genai
  path: /?folder=/root/labs/
  port: 8081
- id: mwcwgexqkzog
  title: Terminal
  type: terminal
  hostname: genai
  cmd: bash
difficulty: ""
enhanced_loading: null
---

💻 Code Block Solutions
===

For this challenge you will use ``[[ Instruqt-Var key="CURRENT_NOTEBOOK_FOR_CHALLENGE" hostname="genai" ]]`` in the [button label="Code Editor" variant="outline"](tab-0) tab.

> [!NOTE]
> The solutions to the exercises are provided below. If you don’t need them, collapse this window by clicking the **Hide Instructions** button. You can toggle it back on at any time.


CODE_BLOCK_1
===
Paste the following into VS Code in the [button label="Code Editor" variant="outline"](tab-0) tab:
```python
vo.contextualized_embed(inputs=[[query]], model="voyage-context-4", input_type="query")
```

CODE_BLOCK_2
===
```python
embds_obj.results[0].embeddings[0]
```

CODE_BLOCK_3
===
```python
get_embeddings(user_query)
```

CODE_BLOCK_4
===
```python
[
    {
        "$vectorSearch": {
            "index": VS_INDEX_NAME,
            "path": "embedding",
            "queryVector": query_embedding,
            "numCandidates": 150,
            "limit": 5,
        }
    },
    {
        "$project": {
            "_id": 0,
            "body": 1,
            "score": {"$meta": "vectorSearchScore"},
        }
    },
]
```

CODE_BLOCK_5
===
```python
vs_collection.aggregate(pipeline)
```

CODE_BLOCK_6
===
```python
{"title": user_query}
```

CODE_BLOCK_7
===
Paste the following into VS Code in the [button label="Code Editor" variant="outline"](tab-0) tab:
```python
{"_id": 0, "body": 1}
```

CODE_BLOCK_8
===
```python
full_collection.find_one(query, projection)
```

CODE_BLOCK_9
===
```python
llm.bind_tools(tools)
```

CODE_BLOCK_10
===
```python
prompt | bind_tools
```

CODE_BLOCK_11
===
```python
state["messages"]
```

CODE_BLOCK_12
===
```python
llm_with_tools.invoke(messages)
```

CODE_BLOCK_13
===
```python
tool.invoke(tool_call["args"])
```

CODE_BLOCK_14
===
Paste the following into VS Code in the [button label="Code Editor" variant="outline"](tab-0) tab:
```python
graph.add_node("agent", agent)
```

CODE_BLOCK_15
===
```python
graph.add_node("tools", tool_node)
```

CODE_BLOCK_16
===
```python
graph.add_edge(START, "agent")
```

CODE_BLOCK_17
===
```python
graph.add_edge("tools", "agent")
```

CODE_BLOCK_18
===
```python
graph.add_conditional_edges(
    "agent",
    route_tools,
    {"tools": "tools", END: END},
)
```

CODE_BLOCK_19
===
```python
{"configurable": {"thread_id": thread_id}}
```
