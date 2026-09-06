💻 Code Block Solutions
===

For this challenge you will use the `ai-agents-lab.ipynb` notebook in the Code Editor.

> [!NOTE]
> The solutions to the exercises are provided below. If you don’t need them, collapse this window by clicking the **Hide Instructions** button. You can toggle it back on at any time.


CODE_BLOCK_1
===
Paste the following into the notebook:
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
Paste the following into the notebook:
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
Paste the following into the notebook:
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
