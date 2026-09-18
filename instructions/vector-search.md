💻 Code Block Solutions
===

For this challenge you will use the `vector-search-lab.ipynb` notebook in the Code Editor.

> [!NOTE]
> The solutions to the exercises are provided below. If you don’t need them, collapse this window by clicking the **Hide Instructions** button. You can toggle it back on at any time.

CODE_BLOCK_1
===
Paste the following into the notebook:
```python
vo.multimodal_embed(inputs=[[image]], model="voyage-multimodal-3.5")
```

CODE_BLOCK_2
===
```python
embedding.embeddings[0]
```

CODE_BLOCK_3
===
```python
collection.find({})
```

CODE_BLOCK_4
===
```python
get_embeddings(content, "image", "document")
```

CODE_BLOCK_5
===
```python
{"$set": {embedding_field: embedding}}
```

CODE_BLOCK_6
===
```python
collection.update_one(filter, update)
```

CODE_BLOCK_7
===
Paste the following into the notebook:
```python
get_embeddings(user_query, mode, "query")
```

CODE_BLOCK_8
===
```python
[
    {
        "$vectorSearch": {
            "index": ATLAS_VECTOR_SEARCH_INDEX_NAME,
            "queryVector": query_embedding,
            "path": "embedding",
            "numCandidates": 20,
            "filter": filter,
            "limit": 5,
        }
    },
    {"$project": {"_id": 0, "title": 1, "cover": 1, "year":1, "pages":1, "score": {"$meta": "vectorSearchScore"}}},
]
```

CODE_BLOCK_9
===
```python
collection.aggregate(pipeline)
```

CODE_BLOCK_10
===
```python
{
    "name": ATLAS_VECTOR_SEARCH_INDEX_NAME,
    "type": "vectorSearch",
    "definition": {
        "fields": [
            {
                "type": "vector",
                "path": "embedding",
                "numDimensions": 1024,
                "similarity": "cosine",
            },
            {"type": "filter", "path": "year"},
        ]
    },
}
```

CODE_BLOCK_11
===
```python
{"year": {"$gte": 2002}}
```

CODE_BLOCK_12
===
```python
{
    "name": ATLAS_VECTOR_SEARCH_INDEX_NAME,
    "type": "vectorSearch",
    "definition": {
        "fields": [
            {
                "type": "vector",
                "path": "embedding",
                "numDimensions": 1024,
                "similarity": "cosine",
            },
            {"type": "filter", "path": "year"},
            {"type": "filter", "path": "pages"},
        ]
    },
}
```

CODE_BLOCK_13
===
```python
{"$and": [{"year": {"$gte": 2002}}, {"pages": {"$lte": 250}}]}
```

CODE_BLOCK_14
===
Paste the following into the notebook:
```python
{
    "name": ATLAS_VECTOR_SEARCH_INDEX_NAME,
    "type": "vectorSearch",
    "definition": {
        "fields": [
            {
                "type": "vector",
                "path": "embedding",
                "numDimensions": 1024,
                "similarity": "cosine",
                "quantization": "scalar",
            },
        ]
    },
}
```
