import json


def generate_sample_data(filename):
    sample_data = {
        "event_types": ["account", "lesson", "payment"],
        "event_subtypes": {
            "account": ["created", "updated", "deleted"],
            "lesson": ["started", "completed"],
            "payment": ["order_created", "order_completed", "refund"]
        }
    }

    with open(filename, 'w') as f:
        json.dump(sample_data, f, indent=4)


if __name__ == "__main__":
    generate_sample_data("sample_data.json")
