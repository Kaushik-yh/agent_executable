# For LangGraph
from langgraph.graph import MessagesState, StateGraph, START, END
from typing_extensions import Literal, TypedDict

# Load nodes.py
import nodes

# Other libs
import sys

# Define State Structure
class State(TypedDict):
    query: str
    category: str
    sentiment: str
    response: str

# Create the graph
workflow = StateGraph(State)

# Add nodes
workflow.add_node("categorize", nodes.categorize)
workflow.add_node("analyze_sentiment", nodes.analyze_sentiment)
workflow.add_node("handle_technical", nodes.handle_technical)
workflow.add_node("handle_billing", nodes.handle_billing)
workflow.add_node("handle_general", nodes.handle_general)
workflow.add_node("escalate", nodes.escalate)

# Add edges
workflow.add_edge("categorize", "analyze_sentiment")
workflow.add_conditional_edges(
    "analyze_sentiment",
    nodes.route_query,
    {
        "handle_technical": "handle_technical",
        "handle_billing": "handle_billing",
        "handle_general": "handle_general",
        "escalate": "escalate"
    }
)
workflow.add_edge("handle_technical", END)
workflow.add_edge("handle_billing", END)
workflow.add_edge("handle_general", END)
workflow.add_edge("escalate", END)

# Set entry point
workflow.set_entry_point("categorize")

# Compile the graph
app = workflow.compile()

# A function to call the initial invoke
def run_customer_support(query: str):
    """Process a customer query through the LangGraph workflow.
    
    Args:
        query (str): The customer's query
        
    Returns:
        Dict[str, str]: A dictionary containing the query's category, sentiment, and response
    """
    results = app.invoke({"query": query})
    return {
        "category": results["category"],
        "sentiment": results["sentiment"],
        "response": results["response"]
    }

# Testing the app
while True:
    query = input("Enter a prompt (or 'exit' to quit): ").strip().lower()

    if query == "exit":
        print("Exiting program.")
        sys.exit()  # or simply 'break' if you have code after the loop

    result = run_customer_support(query)
    print(f"Query: {query}")
    print(f"Category: {result['category']}")
    print(f"Sentiment: {result['sentiment']}")
    print(f"Response: {result['response']}")
    print("\n")